//
//  CompletedQuest.swift
//  Arena Standard Leader
//
//

import SwiftUI

struct CompletedQuest: Identifiable, Codable {
    let id: UUID
    let questId: Int
    let title: String
    let type: String
    let difficulty: QuestDifficulty
    let xpReward: Int
    let energyRewardText: String
    let note: String
    let completedAt: Date
    
    init(
        id: UUID = UUID(),
        questId: Int,
        title: String,
        type: String,
        difficulty: QuestDifficulty,
        xpReward: Int,
        energyRewardText: String,
        note: String,
        completedAt: Date
    ) {
        self.id = id
        self.questId = questId
        self.title = title
        self.type = type
        self.difficulty = difficulty
        self.xpReward = xpReward
        self.energyRewardText = energyRewardText
        self.note = note
        self.completedAt = completedAt
    }
}
