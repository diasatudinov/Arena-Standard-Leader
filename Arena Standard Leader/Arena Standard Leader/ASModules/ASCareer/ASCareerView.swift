//
//  ASCareerView.swift
//  Arena Standard Leader
//
//

import SwiftUI

// MARK: - Career Main Screen

struct CareerView: View {
    
    @ObservedObject var viewModel: CareerViewModel
    
    var body: some View {
        ZStack {
            CareerTowerBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                    .padding(.bottom, -20)
                                
                ScrollView(showsIndicators: false) {
                    ZStack {
                        CareerTowerTrack()
                        
                        VStack(spacing: 80) {
                            ForEach(Array(viewModel.levels.enumerated()).reversed(), id: \.element.id) { index, level in
                                CareerLevelRow(
                                    viewModel: viewModel,
                                    level: level,
                                    state: viewModel.state(for: index),
                                    progress: viewModel.progress,
                                    progressText: "\(viewModel.completedQuests)/\(viewModel.questsGoal)"
                                )
                            }
                        }
                        .padding(.vertical, 22)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 150)
                }
                
            }
            .padding(.top, 24)
            .padding(.bottom, 24)
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        VStack(spacing: 4) {
            Image(.towerText)
                .resizable()
                .scaledToFit()
        }
        .padding(.top, 8)
    }
    
    private var currentRankView: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Rank")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("\(viewModel.currentLevel.icon) \(viewModel.currentLevel.title)")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Quests")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("\(viewModel.completedQuests)/\(viewModel.questsGoal)")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundColor(.orange)
                }
            }
            
            CareerProgressBar(progress: viewModel.progress)
                .frame(height: 12)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.black.opacity(0.28))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}



// MARK: - Career Level Row

struct CareerLevelRow: View {
    @ObservedObject var viewModel: CareerViewModel
    let level: CareerLevel
    let state: CareerLevelState
    let progress: Double
    let progressText: String
    
    var body: some View {
        HStack(spacing: 12) {
            CareerLevelBadge(level: level, state: state)
                .frame(maxWidth: .infinity)
            
            CareerCheckpoint(level: level, state: state)
                .frame(width: 54, height: 54)
            
            rightContent
                .frame(maxWidth: .infinity)
        }
        .frame(height: 86)
    }
    
    @ViewBuilder
    private var rightContent: some View {
        switch state {
        case .current:
            CareerQuestProgressCard(
                viewModel: viewModel,
                progress: progress,
                progressText: progressText
            )
            
        case .next:
            NextLevelLockedView()
            
        case .completed, .locked:
            Color.clear
        }
    }
}

// MARK: - Career Level Badge

struct CareerLevelBadge: View {
    
    let level: CareerLevel
    let state: CareerLevelState
    
    private var isLocked: Bool {
        state == .locked || state == .next
    }
    
    var body: some View {
        ZStack {
            
            Image(.levelBg)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            VStack(spacing: 4) {
                
                Text(level.title)
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.75)
                    .lineLimit(2)
            }
            .padding(.horizontal, 8)
            
            if isLocked {
                Color.black.opacity(0.28)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .frame(width: 100, height: 100)
        .opacity(isLocked ? 0.68 : 1)
        .scaleEffect(state == .current ? 1.04 : 1)
    }
    
    private var badgeGradient: LinearGradient {
        if isLocked {
            return LinearGradient(
                colors: [
                    Color.gray.opacity(0.45),
                    Color.black.opacity(0.35)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else if state == .current {
            return LinearGradient(
                colors: [
                    Color.orange,
                    Color.yellow.opacity(0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [
                    Color.orange.opacity(0.95),
                    Color.orange.opacity(0.65)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

// MARK: - Career Checkpoint

struct CareerCheckpoint: View {
    
    let level: CareerLevel
    let state: CareerLevelState
    
    private var isLocked: Bool {
        state == .locked || state == .next
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(circleGradient)
                .shadow(color: .black.opacity(0.45), radius: 5, x: 0, y: 4)
            
            Circle()
                .stroke(Color.white.opacity(0.8), lineWidth: 2)
                .padding(4)
            
            if isLocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(.white)
            } else {
                Text("\(level.number)")
                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.7), radius: 1, x: 1, y: 1)
            }
        }
        .opacity(isLocked ? 0.75 : 1)
    }
    
    private var circleGradient: LinearGradient {
        if state == .current {
            return LinearGradient(
                colors: [.cyan, .blue],
                startPoint: .top,
                endPoint: .bottom
            )
        } else if isLocked {
            return LinearGradient(
                colors: [.gray.opacity(0.55), .black.opacity(0.45)],
                startPoint: .top,
                endPoint: .bottom
            )
        } else {
            return LinearGradient(
                colors: [.green, .mint],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

// MARK: - Current Quest Progress Card

struct CareerQuestProgressCard: View {
    @ObservedObject var viewModel: CareerViewModel
    let progress: Double
    let progressText: String
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("Quests")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                
                Text(progressText)
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .red.opacity(0.8), radius: 1, x: 1, y: 1)
                
            }
            .frame(width: 120, height: 120)
            .background(
                Image(.levelBg)
                    .resizable()
                    .scaledToFit()
            )
            
            NavigationLink {
                MissionHubView(viewModel: viewModel)
            } label: {
                Image(.questsBg)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                    .overlay {
                        Text("QUESTS")
                            .font(.system(size: 17, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }
            }
            .padding(.horizontal, 20)
        }
        
    }
}

// MARK: - Next Level Locked View

struct NextLevelLockedView: View {
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: "lock.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Text("Unlocks")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("at 50/50")
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .foregroundColor(.cyan)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.35))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
    }
}

// MARK: - Progress Bar

struct CareerProgressBar: View {
    
    let progress: Double
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black.opacity(0.35))
                
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.cyan,
                                Color.blue
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: proxy.size.width * min(max(progress, 0), 1))
                
                Capsule()
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            }
        }
    }
}

// MARK: - Star Rating

struct StarRatingView: View {
    
    let value: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...3, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.system(size: 21, weight: .heavy))
                    .foregroundColor(index <= value ? .orange : .black.opacity(0.55))
                    .shadow(color: .white.opacity(index <= value ? 0.7 : 0), radius: 1, x: 0, y: 0)
            }
        }
    }
}

// MARK: - Track

struct CareerTowerTrack: View {
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                RoundedRectangle(cornerRadius: 34)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.2),
                                Color.blue.opacity(0.45),
                                Color.blue.opacity(0.7)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                HStack(spacing: 200) {
                    ZStack {
                        Rectangle()
                            .fill(Color.purple.opacity(0.75))
                            .frame(width: 24)
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.45))
                            .frame(width: 11)
                    }
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.purple.opacity(0.75))
                            .frame(width: 24)
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.45))
                            .frame(width: 11)
                        
                    }
                }
                
                VStack {
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.5),
                            Color.black.opacity(0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: proxy.size.height * 0.35)
                    
                    Spacer()
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Backgrounds

struct CareerTowerBackground: View {
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.00, blue: 0.03),
                    Color(red: 0.06, green: 0.07, blue: 0.18),
                    Color(red: 0.09, green: 0.00, blue: 0.05)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
        }
    }
}

struct MissionHubBackground: View {
    
    var body: some View {
        ZStack {
            CareerTowerBackground()
            
            VStack {
                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.75),
                        Color.purple.opacity(0.2)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 110)
                
                Spacer()
            }
        }
    }
}


// MARK: - Models

struct CareerQuest: Identifiable {
    let id: Int
    let title: String
    let type: String
    let difficulty: QuestDifficulty
    let xpReward: Int
    let energyRewardText: String
    
    var note: String = ""
    
    static let all: [CareerQuest] = [
        .init(
            id: 1,
            title: "Lead a Meeting",
            type: "Meetings",
            difficulty: .easy,
            xpReward: 5,
            energyRewardText: "+1 to all participants"
        ),
        .init(
            id: 2,
            title: "Send a Deadline Report",
            type: "Tasks",
            difficulty: .easy,
            xpReward: 5,
            energyRewardText: "0"
        ),
        .init(
            id: 3,
            title: "Update Documentation",
            type: "Tasks",
            difficulty: .easy,
            xpReward: 5,
            energyRewardText: "0"
        ),
        .init(
            id: 4,
            title: "Give Feedback to a Colleague",
            type: "Feedback",
            difficulty: .medium,
            xpReward: 10,
            energyRewardText: "+1 to a colleague"
        ),
        .init(
            id: 5,
            title: "Hold a 1:1 with a Direct Report",
            type: "Meetings",
            difficulty: .medium,
            xpReward: 10,
            energyRewardText: "+1 to a direct report"
        ),
        .init(
            id: 6,
            title: "Organize a Brainstorm",
            type: "Meetings",
            difficulty: .medium,
            xpReward: 10,
            energyRewardText: "+2 to all participants"
        ),
        .init(
            id: 7,
            title: "Train a Newcomer",
            type: "Training",
            difficulty: .medium,
            xpReward: 10,
            energyRewardText: "+1 to a newcomer"
        ),
        .init(
            id: 8,
            title: "Resolve a Team Conflict",
            type: "Conflicts",
            difficulty: .medium,
            xpReward: 10,
            energyRewardText: "+1 to both sides"
        ),
        .init(
            id: 9,
            title: "Take Responsibility for a Failure",
            type: "Responsibility",
            difficulty: .hard,
            xpReward: 20,
            energyRewardText: "-1 to yourself, +1 to team"
        ),
        .init(
            id: 10,
            title: "Present a Project to Leadership",
            type: "Meetings",
            difficulty: .hard,
            xpReward: 20,
            energyRewardText: "+2 to all participants"
        ),
        .init(
            id: 11,
            title: "Launch a New Process",
            type: "Initiative",
            difficulty: .hard,
            xpReward: 20,
            energyRewardText: "+1 to team"
        ),
        .init(
            id: 12,
            title: "Run a Retrospective",
            type: "Meetings",
            difficulty: .hard,
            xpReward: 20,
            energyRewardText: "+1 to team"
        ),
        .init(
            id: 13,
            title: "Write a Post in the Internal Chat",
            type: "Communication",
            difficulty: .easy,
            xpReward: 5,
            energyRewardText: "+1 to readers"
        ),
        .init(
            id: 14,
            title: "Publicly Thank a Colleague",
            type: "Feedback",
            difficulty: .easy,
            xpReward: 5,
            energyRewardText: "+2 to a colleague"
        ),
        .init(
            id: 15,
            title: "Conduct a Candidate Interview",
            type: "HR",
            difficulty: .medium,
            xpReward: 10,
            energyRewardText: "0"
        ),
        .init(
            id: 16,
            title: "Create a Development Plan for Yourself",
            type: "Planning",
            difficulty: .medium,
            xpReward: 10,
            energyRewardText: "0"
        ),
        .init(
            id: 17,
            title: "Speak at an Internal Conference",
            type: "Public Speaking",
            difficulty: .hard,
            xpReward: 20,
            energyRewardText: "+3 to all listeners"
        ),
        .init(
            id: 18,
            title: "Initiate a Cross-Department Project",
            type: "Initiative",
            difficulty: .hard,
            xpReward: 20,
            energyRewardText: "+2 to all participants"
        ),
        .init(
            id: 19,
            title: "Help a Colleague with a Deadline",
            type: "Support",
            difficulty: .medium,
            xpReward: 10,
            energyRewardText: "+1 to a colleague"
        ),
        .init(
            id: 20,
            title: "Read a Professional Article",
            type: "Learning",
            difficulty: .easy,
            xpReward: 5,
            energyRewardText: "0"
        )
    ]
}

enum QuestDifficulty: Int, Codable {
    case easy = 1
    case medium = 2
    case hard = 3
    
    var title: String {
        switch self {
        case .easy:
            return "Easy Quest"
        case .medium:
            return "Medium Quest"
        case .hard:
            return "Hard Quest"
        }
    }
    
    var icon: String {
        switch self {
        case .easy:
            return "🟢"
        case .medium:
            return "🔵"
        case .hard:
            return "🟣"
        }
    }
}

enum QuestFilter: CaseIterable {
    case all
    case easy
    case medium
    case hard
    
    var title: String {
        switch self {
        case .all:
            return "All"
        case .easy:
            return ""
        case .medium:
            return ""
        case .hard:
            return ""
        }
    }
    
    var icon: Int? {
        switch self {
        case .all:
            return nil
        case .easy:
            return 1
        case .medium:
            return 2
        case .hard:
            return 3
        }
    }
}

struct CareerLevel: Identifiable {
    let id: Int
    let number: Int
    let icon: String
    let title: String
    let requirement: String
    
    static let all: [CareerLevel] = [
        CareerLevel(
            id: 1,
            number: 1,
            icon: "🌱",
            title: "Intern",
            requirement: "0/50 quests"
        ),
        CareerLevel(
            id: 2,
            number: 2,
            icon: "📋",
            title: "Specialist",
            requirement: "50/50 quests"
        ),
        CareerLevel(
            id: 3,
            number: 3,
            icon: "🎯",
            title: "Expert",
            requirement: "50/50 quests"
        ),
        CareerLevel(
            id: 4,
            number: 4,
            icon: "🤝",
            title: "Mentor",
            requirement: "50/50 quests"
        ),
        CareerLevel(
            id: 5,
            number: 5,
            icon: "🏆",
            title: "Leader",
            requirement: "50/50 quests"
        ),
        CareerLevel(
            id: 6,
            number: 6,
            icon: "👑",
            title: "Director",
            requirement: "50/50 quests"
        ),
        CareerLevel(
            id: 7,
            number: 7,
            icon: "⭐",
            title: "Legend",
            requirement: "50/50 quests"
        )
    ]
}

enum CareerLevelState {
    case completed
    case current
    case next
    case locked
}

// MARK: - Preview

struct CareerRootView_Previews: PreviewProvider {
    static var previews: some View {
        CareerView(viewModel: CareerViewModel())
    }
}
