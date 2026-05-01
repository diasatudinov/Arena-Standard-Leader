//
//  Achievement.swift
//  Arena Standard Leader
//
//

import SwiftUI

struct Achievement: Codable, Hashable, Identifiable {
    let id: Int
    let icon: String
    let title: String
    let description: String
    let requirement: AchievementRequirement
    var currentProgress: Int = 0
    var isUnlocked: Bool = false
}

enum AchievementRequirement: Codable, Hashable {
    case firstCompletedQuest
    case completedMeetings(count: Int)
    case completedBrainstorms(count: Int)
    case tookResponsibilityForFailure(count: Int)
    case teamEnergyCharged(amount: Int)
    case levelUpWithinDays(days: Int)
    case completedHardQuests(count: Int)
    case givenFeedbacks(count: Int)
}
