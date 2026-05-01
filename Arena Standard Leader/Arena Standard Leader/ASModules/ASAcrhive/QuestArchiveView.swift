//
//  QuestArchiveView.swift
//  Arena Standard Leader
//
//

import SwiftUI

struct QuestArchiveView: View {
    
    @ObservedObject var viewModel: CareerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        
                        statsView
                        
                        if viewModel.sortedArchivedQuests.isEmpty {
                            emptyView
                        } else {
                            ForEach(viewModel.sortedArchivedQuests) { quest in
                                ArchivedQuestCard(quest: quest)
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 150)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        ZStack {
            Image(.archiveText)
                .resizable()
                .scaledToFit()
            
        }
    }
    
    private var statsView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ArchiveStatCard(
                    title: "TOTAL COMPLETED",
                    value: "\(viewModel.totalCompletedQuests)"
                )
                
                ArchiveStatCard(
                    title: "AVG DIFFICULTY",
                    value: String(format: "%.1f", viewModel.averageDifficulty)
                )
            }
            
            ArchiveStatCard(
                title: "FAVORITE QUEST TYPE",
                value: viewModel.favoriteQuestType.uppercased()
            )
            
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "archivebox.fill")
                .font(.system(size: 44, weight: .bold))
                .foregroundColor(.white.opacity(0.8))
            
            Text("No completed quests yet")
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
            
            Text("Complete quests in Mission Hub to see them here.")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.65))
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.black.opacity(0.28))
        )
    }
}

#Preview {
    QuestArchiveView(viewModel: CareerViewModel())
}

private struct ArchiveStatCard: View {
    
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .foregroundColor(.brown.opacity(0.7))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            Text(value)
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .shadow(color: .black.opacity(0.75), radius: 1, x: 1, y: 2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 90)
        .background(
            LinearGradient(
                colors: [
                    Color.yellow.opacity(0.95),
                    Color.orange.opacity(0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.65), lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.35), radius: 5, x: 0, y: 4)
    }
}

private struct ArchivedQuestCard: View {
    
    let quest: CompletedQuest
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        
                        Text(quest.title.uppercased())
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.7), radius: 1, x: 1, y: 2)
                            .lineLimit(2)
                            .minimumScaleFactor(0.65)
                    }
                    
                }
                
                Spacer()
                
                StarRatingView(value: quest.difficulty.rawValue)
            }
            
            if !quest.note.isEmpty {
                Text(quest.note)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.purple)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.white.opacity(0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.purple, lineWidth: 2)
                    )
            }
            
            HStack {
                Label("+\(quest.xpReward) XP", systemImage: "bolt.fill")
                
                Spacer()
                
                Label {
                    Text(quest.energyRewardText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                } icon: {
                    Image(systemName: "gearshape.fill")
                }
            }
            .font(.system(size: 18, weight: .black, design: .rounded))
            .foregroundColor(.black)
        }
        .padding(16)
        .background(cardGradient)
    }
    
    private var cardGradient: Image {
        switch quest.difficulty {
        case .easy:
            return Image(.easyBg)
                .resizable()
            
        case .medium:
            return Image(.mediumBg).resizable()
            
        case .hard:
            return Image(.hardBg).resizable()
        }
    }
}

private extension Date {
    
    var archiveDateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM d, yyyy HH:mm"
        return formatter.string(from: self)
    }
}
