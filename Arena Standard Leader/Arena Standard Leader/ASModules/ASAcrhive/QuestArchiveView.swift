struct QuestArchiveView: View {
    
    @ObservedObject var viewModel: CareerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            MissionHubBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                headerView
                
                statsView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        if viewModel.sortedArchivedQuests.isEmpty {
                            emptyView
                        } else {
                            ForEach(viewModel.sortedArchivedQuests) { quest in
                                ArchivedQuestCard(quest: quest)
                            }
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
            Text("QUEST ARCHIVE")
                .font(.system(size: 32, weight: .heavy, design: .rounded))
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
            
            Button {
                print("Export PDF Report tapped")
            } label: {
                Text("EXPORT PDF REPORT")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.blue,
                                Color.cyan.opacity(0.85)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 18)
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