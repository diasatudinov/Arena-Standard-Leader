import SwiftUI

struct ASAnalyticsView: View {
    
    @ObservedObject var teamViewModel: ASTeamViewModel
    
    let currentLevel: Int
    let levelGrowthPercent: Int
    let questsDone: Int
    let questsGoal: Int
    
    private let monthlyProgress: [Double] = [0.15, 0.34, 0.47, 0.52, 0.55, 0.58, 0.62, 0.69, 0.82]
    private let monthLabels: [String] = ["JUL", "JAN", "OCT", "DEC", "APR"]
    
    private var sortedTeams: [Team] {
        teamViewModel.teams
            .sorted { $0.energyBalance > $1.energyBalance }
    }
    
    private var maxEnergyBalance: Double {
        max(sortedTeams.map { abs($0.energyBalance) }.max() ?? 1, 1)
    }
    
    private var averageBalancePercent: Int {
        guard !teamViewModel.teams.isEmpty else { return 0 }
        
        let total = teamViewModel.teams.reduce(0) { $0 + $1.energyBalance }
        let average = total / Double(teamViewModel.teams.count)
        
        // Если energyBalance у тебя от -3 до 3
        let normalized = ((average + 3) / 6) * 100
        
        return min(max(Int(normalized.rounded()), 0), 100)
    }
    
    private var greenStatusCount: Int {
        teamViewModel.teams.filter { $0.energyBalance > 0 }.count
    }
    
    var body: some View {
        ZStack {
            ASAnalyticsBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        statsGrid
                        
                        levelProgressCard
                        
                        energyExchangeCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        ZStack {
            Text("ANALYTICS")
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.85), radius: 2, x: 2, y: 3)
        }
        .frame(height: 88)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color.purple.opacity(0.8),
                    Color.purple.opacity(0.45)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    private var statsGrid: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ASStatCard(
                    title: "CURRENT LEVEL",
                    value: "\(currentLevel)",
                    suffix: "+\(levelGrowthPercent)%",
                    suffixColor: .green
                )
                
                ASStatCard(
                    title: "QUESTS DONE",
                    value: "\(questsDone)",
                    suffix: "/\(questsGoal)",
                    suffixColor: .white.opacity(0.75)
                )
            }
            
            HStack(spacing: 12) {
                ASStatCard(
                    title: "AVG BALANCE",
                    value: "\(averageBalancePercent)%",
                    suffix: nil,
                    suffixColor: .clear
                )
                
                ASStatCard(
                    title: "GREEN STATUS",
                    value: String(format: "%02d", greenStatusCount),
                    suffix: nil,
                    suffixColor: .clear
                )
            }
        }
    }
    
    private var levelProgressCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("LEVEL PROGRESS")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("LAST 12 MONTHS")
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                    .foregroundColor(.white.opacity(0.45))
            }
            
            ASLineChartView(values: monthlyProgress)
                .frame(height: 150)
            
            HStack {
                ForEach(monthLabels, id: \.self) { month in
                    Text(month)
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                        .foregroundColor(.white.opacity(0.55))
                    
                    if month != monthLabels.last {
                        Spacer()
                    }
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 34)
                .fill(Color(red: 0.10, green: 0.20, blue: 0.34))
        )
    }
    
    private var energyExchangeCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("ENERGY EXCHANGE")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("RECEIVED")
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                    .foregroundColor(.white.opacity(0.45))
            }
            
            if sortedTeams.isEmpty {
                emptyEnergyView
            } else {
                VStack(spacing: 16) {
                    ForEach(sortedTeams.prefix(5)) { team in
                        ASEnergyRow(
                            team: team,
                            maxEnergyBalance: maxEnergyBalance
                        )
                    }
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 34)
                .fill(Color(red: 0.10, green: 0.20, blue: 0.34))
        )
    }
    
    private var emptyEnergyView: some View {
        VStack(spacing: 10) {
            Image(systemName: "bolt.slash.fill")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white.opacity(0.7))
            
            Text("No team energy yet")
                .font(.system(size: 16, weight: .heavy, design: .rounded))
                .foregroundColor(.white.opacity(0.75))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}