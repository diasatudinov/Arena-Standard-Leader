// MARK: - Mission Hub Screen

struct MissionHubView: View {
    
    @ObservedObject var viewModel: CareerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            MissionHubBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                headerView
                
                filterView
                
                dailyLimitView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(viewModel.filteredQuests) { quest in
                            MissionQuestCard(
                                quest: quest,
                                note: viewModel.noteBinding(for: quest.id),
                                isLimitReached: viewModel.isDailyLimitReached,
                                onDoneTap: {
                                    viewModel.completeQuest(id: quest.id)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 28)
                }
            }
            .padding(.top, 24)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        ZStack {
            Text("MISSION HUB")
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.85), radius: 2, x: 2, y: 3)
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(width: 42, height: 42)
                        .background(Color.black.opacity(0.25))
                        .clipShape(Circle())
                }
                
                Spacer()
            }
            .padding(.horizontal, 18)
        }
        .frame(height: 76)
        .background(
            LinearGradient(
                colors: [
                    Color.purple.opacity(0.75),
                    Color.purple.opacity(0.35)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    private var filterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(QuestFilter.allCases, id: \.self) { filter in
                    Button {
                        viewModel.selectedFilter = filter
                    } label: {
                        HStack(spacing: 6) {
                            if let icon = filter.icon {
                                Text(icon)
                            }
                            
                            Text(filter.title)
                                .font(.system(size: 16, weight: .heavy, design: .rounded))
                        }
                        .foregroundColor(viewModel.selectedFilter == filter ? .purple : .white)
                        .frame(height: 58)
                        .padding(.horizontal, 22)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(
                                    viewModel.selectedFilter == filter
                                    ? Color.yellow.opacity(0.95)
                                    : Color.white.opacity(0.25)
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(
                                    Color.orange.opacity(viewModel.selectedFilter == filter ? 1 : 0.25),
                                    lineWidth: 4
                                )
                        )
                        .shadow(color: .black.opacity(0.35), radius: 5, x: 0, y: 4)
                    }
                }
            }
            .padding(.horizontal, 18)
        }
    }
    
    private var dailyLimitView: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Daily Limit")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("Max 5 quests per day")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 3) {
                    Text("\(viewModel.completedToday)/\(viewModel.dailyQuestLimit)")
                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                        .foregroundColor(viewModel.isDailyLimitReached ? .red : .yellow)
                    
                    Text("\(viewModel.totalXP) XP")
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .foregroundColor(.cyan)
                }
            }
            
            CareerProgressBar(
                progress: Double(viewModel.completedToday) / Double(viewModel.dailyQuestLimit)
            )
            .frame(height: 9)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.28))
        )
        .padding(.horizontal, 18)
    }
}

// MARK: - Mission Quest Card

private struct MissionQuestCard: View {
    
    let quest: CareerQuest
    @Binding var note: String
    
    let isLimitReached: Bool
    let onDoneTap: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(quest.difficulty.icon)
                            .font(.system(size: 20))
                        
                        Text(quest.title.uppercased())
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.7), radius: 1, x: 1, y: 2)
                            .lineLimit(2)
                            .minimumScaleFactor(0.65)
                    }
                    
                    HStack(spacing: 8) {
                        Text(quest.type)
                            .font(.system(size: 12, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.black.opacity(0.25))
                            .clipShape(Capsule())
                        
                        Text(quest.difficulty.title)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                Spacer()
                
                StarRatingView(value: quest.difficulty.rawValue)
            }
            
            TextField("Who, what, result...", text: $note)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.purple)
                .padding(.horizontal, 16)
                .frame(height: 54)
                .background(Color.white.opacity(0.75))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.purple, lineWidth: 2)
                )
            
            VStack(spacing: 8) {
                HStack {
                    Label("+\(quest.xpReward) XP", systemImage: "bolt.fill")
                    
                    Spacer()
                }
                
                HStack(alignment: .top) {
                    Label {
                        Text(quest.energyRewardText)
                            .multilineTextAlignment(.trailing)
                    } icon: {
                        Image(systemName: "gearshape.fill")
                    }
                    
                    Spacer()
                }
            }
            .font(.system(size: 15, weight: .heavy, design: .rounded))
            .foregroundColor(.black)
            
            Button {
                onDoneTap()
            } label: {
                Text("DONE!")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        LinearGradient(
                            colors: isLimitReached
                            ? [Color.gray, Color.gray.opacity(0.75)]
                            : [Color.yellow, Color.orange],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.orange.opacity(0.9), lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 3)
            }
            .disabled(isLimitReached)
            
            if isLimitReached {
                Text("Daily limit reached")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.85))
            }
        }
        .padding(16)
        .background(cardGradient)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.55), lineWidth: 3)
        )
        .shadow(color: .black.opacity(0.45), radius: 6, x: 0, y: 5)
    }
    
    private var cardGradient: LinearGradient {
        switch quest.difficulty {
        case .easy:
            return LinearGradient(
                colors: [
                    Color.cyan.opacity(0.95),
                    Color.blue.opacity(0.65)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
        case .medium:
            return LinearGradient(
                colors: [
                    Color.green.opacity(0.95),
                    Color.yellow.opacity(0.75)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
        case .hard:
            return LinearGradient(
                colors: [
                    Color.pink.opacity(0.95),
                    Color.purple.opacity(0.75)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}