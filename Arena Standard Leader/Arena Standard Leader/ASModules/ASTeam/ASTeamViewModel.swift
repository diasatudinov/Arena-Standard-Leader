//
//  ASTeamViewModel.swift
//  Arena Standard Leader
//
//

import Foundation

final class ASTeamViewModel: ObservableObject {
    @Published var teams: [Team] = [
    ] {
        didSet {
            saveTeams()
        }
    }
    
    @Published var rewards: [Achievement] = [
        Achievement(
            id: 1,
            icon: "🏆",
            title: "First Blood",
            description: "Complete your first quest.",
            requirement: .firstCompletedQuest
        ),
        Achievement(
            id: 2,
            icon: "🤝",
            title: "Life of the Party",
            description: "Hold 50 meetings.",
            requirement: .completedMeetings(count: 50)
        ),
        Achievement(
            id: 3,
            icon: "💡",
            title: "Idea Generator",
            description: "Organize 20 brainstorms.",
            requirement: .completedBrainstorms(count: 20)
        ),
        Achievement(
            id: 4,
            icon: "🛡️",
            title: "Team Shield",
            description: "Take responsibility for a failure 10 times.",
            requirement: .tookResponsibilityForFailure(count: 10)
        ),
        Achievement(
            id: 5,
            icon: "⚡",
            title: "Energizer",
            description: "Charge 100 energy points for the team.",
            requirement: .teamEnergyCharged(amount: 100)
        ),
        Achievement(
            id: 6,
            icon: "📈",
            title: "Fast Elevator",
            description: "Level up within 30 days.",
            requirement: .levelUpWithinDays(days: 30)
        ),
        Achievement(
            id: 7,
            icon: "🎯",
            title: "Sniper",
            description: "Complete 30 hard quests.",
            requirement: .completedHardQuests(count: 30)
        ),
        Achievement(
            id: 8,
            icon: "🌟",
            title: "Mentor",
            description: "Give feedback to colleagues 20 times.",
            requirement: .givenFeedbacks(count: 20)
        )
    ] {
        didSet {
            saveAchi()
        }
    }
    
    init() {
        loadTeams()
        loadAchi()
    }
    
    private var outfitsFileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("outfitsTest3.json")
    }
    
    private var rewardsFileURL: URL {
           let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
           return dir.appendingPathComponent("rewardsFileURL.json")
       }
    
    private func saveTeams() {
        let url = outfitsFileURL
        do {
            let data = try JSONEncoder().encode(teams)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Failed to save teams:", error)
        }
    }
    
    private func loadTeams() {
        let url = outfitsFileURL
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let outfitsData = try JSONDecoder().decode([Team].self, from: data)
            teams = outfitsData
        } catch {
            print("Failed to load teams:", error)
        }
    }
    
    private func saveAchi() {
           let url = rewardsFileURL
           do {
               let data = try JSONEncoder().encode(rewards)
               try data.write(to: url, options: [.atomic])
           } catch {
               print("Failed to save teams:", error)
           }
       }
       
       private func loadAchi() {
           let url = rewardsFileURL
           guard FileManager.default.fileExists(atPath: url.path) else {
               return
           }
           
           do {
               let data = try Data(contentsOf: url)
               let outfitsData = try JSONDecoder().decode([Achievement].self, from: data)
               rewards = outfitsData
           } catch {
               print("Failed to load teams:", error)
           }
       }
    
    func add(_ team: Team) {
        teams.append(team)
    }
    
    func toggleReward(_ reward: Achievement) {
        if let index = rewards.firstIndex(where: { $0.id == reward.id }) {
            rewards[index].isUnlocked.toggle()
        }
    }
    
}

