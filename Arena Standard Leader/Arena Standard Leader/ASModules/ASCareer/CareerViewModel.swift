//
//  CareerViewModel.swift
//  Arena Standard Leader
//
//

import SwiftUI

// MARK: - ViewModel

class CareerViewModel: ObservableObject {
    
    @Published var currentLevelIndex: Int = 0
    @Published var completedQuests: Int = 0
    @Published var completedToday: Int = 0
    @Published var selectedFilter: QuestFilter = .all
    @Published var totalXP: Int = 0
    @Published var quests: [CareerQuest] = CareerQuest.all
    @Published var archivedQuests: [CompletedQuest] = []
    
    let questsGoal: Int = 50
    let dailyQuestLimit: Int = 50
    let levels: [CareerLevel] = CareerLevel.all
    
    private var dailyLimitDateKey: String = CareerViewModel.todayKey()
    
    init() {
        restoreState()
        resetDailyLimitIfNeeded()
    }
    
    var safeCurrentLevelIndex: Int {
        min(max(currentLevelIndex, 0), levels.count - 1)
    }
    
    var currentLevel: CareerLevel {
        levels[safeCurrentLevelIndex]
    }
    
    var progress: Double {
        guard questsGoal > 0 else { return 0 }
        return min(Double(completedQuests) / Double(questsGoal), 1)
    }
    
    var isDailyLimitReached: Bool {
        completedToday >= dailyQuestLimit
    }
    
    var filteredQuests: [CareerQuest] {
        switch selectedFilter {
        case .all:
            return quests
        case .easy:
            return quests.filter { $0.difficulty == .easy }
        case .medium:
            return quests.filter { $0.difficulty == .medium }
        case .hard:
            return quests.filter { $0.difficulty == .hard }
        }
    }
    
    var totalCompletedQuests: Int {
        archivedQuests.count
    }
    
    var averageDifficulty: Double {
        guard !archivedQuests.isEmpty else { return 0 }
        
        let total = archivedQuests.reduce(0) { partialResult, quest in
            partialResult + quest.difficulty.rawValue
        }
        
        return Double(total) / Double(archivedQuests.count)
    }
    
    var favoriteQuestType: String {
        guard !archivedQuests.isEmpty else { return "None" }
        
        let grouped = Dictionary(grouping: archivedQuests, by: { $0.type })
        
        return grouped
            .max { $0.value.count < $1.value.count }?
            .key ?? "None"
    }
    
    var sortedArchivedQuests: [CompletedQuest] {
        archivedQuests.sorted { $0.completedAt > $1.completedAt }
    }
    
    func state(for index: Int) -> CareerLevelState {
        if index < safeCurrentLevelIndex {
            return .completed
        } else if index == safeCurrentLevelIndex {
            return .current
        } else if index == safeCurrentLevelIndex + 1 {
            return .next
        } else {
            return .locked
        }
    }
    
    func noteBinding(for questID: Int) -> Binding<String> {
        Binding(
            get: {
                self.quests.first(where: { $0.id == questID })?.note ?? ""
            },
            set: { newValue in
                guard let index = self.quests.firstIndex(where: { $0.id == questID }) else { return }
                self.quests[index].note = newValue
            }
        )
    }
    
    func completeQuest(id: Int) {
        resetDailyLimitIfNeeded()
        
        guard !isDailyLimitReached else { return }
        guard let index = quests.firstIndex(where: { $0.id == id }) else { return }
        
        let quest = quests[index]
        let note = quest.note.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let completedQuest = CompletedQuest(
            questId: quest.id,
            title: quest.title,
            type: quest.type,
            difficulty: quest.difficulty,
            xpReward: quest.xpReward,
            energyRewardText: quest.energyRewardText,
            note: note,
            completedAt: Date()
        )
        
        archivedQuests.insert(completedQuest, at: 0)
        
        completedToday += 1
        completedQuests += 1
        totalXP += quest.xpReward
        
        quests[index].note = ""
        
        if completedQuests >= questsGoal {
            if currentLevelIndex < levels.count - 1 {
                completedQuests = 0
                currentLevelIndex += 1
            } else {
                completedQuests = questsGoal
            }
        }
        
        saveState()
    }
    
    func clearArchive() {
        archivedQuests.removeAll()
        saveState()
    }
    
    private func resetDailyLimitIfNeeded() {
        let today = Self.todayKey()
        
        if dailyLimitDateKey != today {
            completedToday = 0
            dailyLimitDateKey = today
            saveState()
        }
    }
    
    private func saveState() {
        let state = CareerStorageState(
            currentLevelIndex: currentLevelIndex,
            completedQuests: completedQuests,
            completedToday: completedToday,
            dailyLimitDateKey: dailyLimitDateKey,
            totalXP: totalXP,
            archivedQuests: archivedQuests
        )
        
        CareerStorage.save(state)
    }
    
    private func restoreState() {
        guard let state = CareerStorage.load() else { return }
        
        currentLevelIndex = state.currentLevelIndex
        completedQuests = state.completedQuests
        completedToday = state.completedToday
        dailyLimitDateKey = state.dailyLimitDateKey
        totalXP = state.totalXP
        archivedQuests = state.archivedQuests
    }
    
    private static func todayKey() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

private struct CareerStorageState: Codable {
    let currentLevelIndex: Int
    let completedQuests: Int
    let completedToday: Int
    let dailyLimitDateKey: String
    let totalXP: Int
    let archivedQuests: [CompletedQuest]
}

private enum CareerStorage {
    
    private static let key = "career.storage.state.v1"
    
    static func save(_ state: CareerStorageState) {
        do {
            let data = try JSONEncoder().encode(state)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("CareerStorage save error:", error)
        }
    }
    
    static func load() -> CareerStorageState? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(CareerStorageState.self, from: data)
        } catch {
            print("CareerStorage load error:", error)
            return nil
        }
    }
}
