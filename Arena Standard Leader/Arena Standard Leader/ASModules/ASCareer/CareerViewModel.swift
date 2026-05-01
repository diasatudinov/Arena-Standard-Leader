// MARK: - ViewModel

class CareerViewModel: ObservableObject {
    
    @Published var currentLevelIndex: Int = 0
    @Published var completedQuests: Int = 0
    @Published var completedToday: Int = 0
    @Published var selectedFilter: QuestFilter = .all
    @Published var totalXP: Int = 0
    
    @Published var quests: [CareerQuest] = CareerQuest.all
    
    let questsGoal: Int = 50
    let dailyQuestLimit: Int = 5
    let levels: [CareerLevel] = CareerLevel.all
    
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
        guard !isDailyLimitReached else { return }
        guard let index = quests.firstIndex(where: { $0.id == id }) else { return }
        
        completedToday += 1
        completedQuests += 1
        totalXP += quests[index].xpReward
        
        quests[index].note = ""
        
        if completedQuests >= questsGoal {
            completedQuests = 0
            currentLevelIndex = min(currentLevelIndex + 1, levels.count - 1)
        }
    }
}