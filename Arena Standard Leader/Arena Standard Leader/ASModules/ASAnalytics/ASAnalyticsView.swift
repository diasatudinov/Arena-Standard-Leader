//
//  ASAnalyticsView.swift
//  Arena Standard Leader
//
//


import SwiftUI

struct ASAnalyticsView: View {
    
    @ObservedObject var teamViewModel: ASTeamViewModel
    @ObservedObject var careerViewModel: CareerViewModel
    
    private var sortedTeams: [Team] {
        teamViewModel.teams
            .sorted { $0.energyBalance > $1.energyBalance }
    }
    
    private var maxEnergyBalance: Double {
        max(sortedTeams.map { abs($0.energyBalance) }.max() ?? 1, 1)
    }
    
    private var averageBalancePercent: Int {
        guard !teamViewModel.teams.isEmpty else { return 0 }
        
        let balances = teamViewModel.teams.map { $0.energyBalance }
        let average = balances.reduce(0, +) / Double(balances.count)
        let maxAbs = max(balances.map { abs($0) }.max() ?? 1, 1)
        
        let normalized = ((average + maxAbs) / (maxAbs * 2)) * 100
        return min(max(Int(normalized.rounded()), 0), 100)
    }
    
    private var greenStatusCount: Int {
        teamViewModel.teams.filter { $0.energyBalance > 0 }.count
    }
    
    private var currentLevelNumber: Int {
        careerViewModel.currentLevel.number
    }
    
    private var levelProgressPercent: Int {
        Int((careerViewModel.progress * 100).rounded())
    }
    
    private var monthlyProgress: [Double] {
        makeMonthlyProgress()
    }
    
    private var monthLabels: [String] {
        makeMonthLabels()
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        statsGrid
                        
                        levelProgressCard
                        
                        energyExchangeCard
                        
                        questStatsCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    .padding(.bottom, 150)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        Image(.analyticsTextAS)
            .resizable()
            .scaledToFit()
    }
    
    private var statsGrid: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ASStatCard(
                    title: "CURRENT LEVEL",
                    value: "\(currentLevelNumber)",
                    suffix: "+\(levelProgressPercent)%",
                    suffixColor: .green
                )
                
                ASStatCard(
                    title: "QUESTS DONE",
                    value: "\(careerViewModel.completedQuests)",
                    suffix: "/\(careerViewModel.questsGoal)",
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
                    ForEach(Array(sortedTeams.prefix(5))) { team in
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
    
    private var questStatsCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("QUEST STATS")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("ARCHIVE")
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                    .foregroundColor(.white.opacity(0.45))
            }
            
            HStack(spacing: 12) {
                ASMiniStatCard(
                    title: "TOTAL",
                    value: "\(careerViewModel.totalCompletedQuests)"
                )
                
                ASMiniStatCard(
                    title: "AVG DIFF",
                    value: String(format: "%.1f", careerViewModel.averageDifficulty)
                )
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("FAVORITE TYPE")
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .foregroundColor(.white.opacity(0.45))
                
                Text(careerViewModel.favoriteQuestType.uppercased())
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .shadow(color: .black.opacity(0.7), radius: 1, x: 1, y: 2)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [
                        Color.orange.opacity(0.95),
                        Color.yellow.opacity(0.8)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.55), lineWidth: 1.5)
            )
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
    
    private func makeMonthlyProgress() -> [Double] {
        let calendar = Calendar.current
        let now = Date()
        
        guard let currentMonthStart = calendar.dateInterval(of: .month, for: now)?.start else {
            return [0.1, 0.2, 0.35, 0.45, 0.5, 0.58, 0.62, 0.7, 0.82]
        }
        
        let months: [Date] = (0..<12).compactMap { offset in
            calendar.date(byAdding: .month, value: -offset, to: currentMonthStart)
        }
        .reversed()
        
        let counts = months.map { monthStart in
            guard let interval = calendar.dateInterval(of: .month, for: monthStart) else {
                return 0
            }
            
            return careerViewModel.archivedQuests.filter {
                $0.completedAt >= interval.start && $0.completedAt < interval.end
            }.count
        }
        
        var cumulative: [Double] = []
        var total = 0
        
        for count in counts {
            total += count
            cumulative.append(Double(total))
        }
        
        let maxValue = max(cumulative.max() ?? 0, 1)
        let normalized = cumulative.map { $0 / maxValue }
        
        if normalized.allSatisfy({ $0 == 0 }) {
            return [0.12, 0.24, 0.36, 0.46, 0.52, 0.56, 0.6, 0.66, 0.74, 0.84, 0.92, 1.0]
        }
        
        return normalized
    }
    
    private func makeMonthLabels() -> [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM"
        
        let calendar = Calendar.current
        let now = Date()
        
        guard let currentMonthStart = calendar.dateInterval(of: .month, for: now)?.start else {
            return ["JUL", "JAN", "OCT", "DEC", "APR"]
        }
        
        let months: [Date] = (0..<12).compactMap { offset in
            calendar.date(byAdding: .month, value: -offset, to: currentMonthStart)
        }
        .reversed()
        
        let selectedIndexes = [0, 3, 6, 9, 11]
        
        return selectedIndexes.compactMap { index in
            guard months.indices.contains(index) else { return nil }
            return formatter.string(from: months[index]).uppercased()
        }
    }
}

private struct ASLineChartView: View {
    
    let values: [Double]
    
    var body: some View {
        GeometryReader { proxy in
            let points = makePoints(in: proxy.size)
            
            ZStack {
                areaPath(points: points, size: proxy.size)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.orange.opacity(0.45),
                                Color.orange.opacity(0.15)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                linePath(points: points)
                    .stroke(
                        Color(red: 1.0, green: 0.36, blue: 0.10),
                        style: StrokeStyle(
                            lineWidth: 8,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
            }
        }
    }
    
    private func makePoints(in size: CGSize) -> [CGPoint] {
        guard values.count > 1 else { return [] }
        
        let maxValue = max(values.max() ?? 1, 1)
        let minValue = min(values.min() ?? 0, 0)
        let range = max(maxValue - minValue, 0.0001)
        
        return values.enumerated().map { index, value in
            let x = size.width * CGFloat(index) / CGFloat(values.count - 1)
            let normalized = (value - minValue) / range
            let y = size.height - CGFloat(normalized) * size.height
            return CGPoint(x: x, y: y)
        }
    }
    
    private func linePath(points: [CGPoint]) -> Path {
        var path = Path()
        
        guard let firstPoint = points.first else { return path }
        
        path.move(to: firstPoint)
        
        for index in 1..<points.count {
            let previous = points[index - 1]
            let current = points[index]
            let midX = (previous.x + current.x) / 2
            
            path.addCurve(
                to: current,
                control1: CGPoint(x: midX, y: previous.y),
                control2: CGPoint(x: midX, y: current.y)
            )
        }
        
        return path
    }
    
    private func areaPath(points: [CGPoint], size: CGSize) -> Path {
        var path = linePath(points: points)
        
        guard let first = points.first, let last = points.last else { return path }
        
        path.addLine(to: CGPoint(x: last.x, y: size.height))
        path.addLine(to: CGPoint(x: first.x, y: size.height))
        path.closeSubpath()
        
        return path
    }
}

private struct ASAnalyticsBackground: View {
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.02, green: 0.08, blue: 0.14),
                    Color.black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            HStack(spacing: 26) {
                ForEach(0..<6, id: \.self) { index in
                    Rectangle()
                        .fill(index.isMultiple(of: 2) ? Color.black.opacity(0.45) : Color.cyan.opacity(0.08))
                        .frame(width: 34)
                }
            }
            .opacity(0.65)
        }
    }
}

private struct ASStatCard: View {
    
    let title: String
    let value: String
    let suffix: String?
    let suffixColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .heavy, design: .rounded))
                .foregroundColor(.brown.opacity(0.75))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 38, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.75), radius: 1, x: 1, y: 2)
                
                if let suffix {
                    Text(suffix)
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(suffixColor)
                        .shadow(color: .black.opacity(0.4), radius: 1, x: 1, y: 1)
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
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
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.8), lineWidth: 2)
        )
    }
}

private struct ASMiniStatCard: View {
    
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .foregroundColor(.brown.opacity(0.75))
            
            Text(value)
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.75), radius: 1, x: 1, y: 2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 84)
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
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.65), lineWidth: 1.5)
        )
    }
}

private struct ASEnergyRow: View {
    
    let team: Team
    let maxEnergyBalance: Double
    
    private var progress: Double {
        guard maxEnergyBalance > 0 else { return 0 }
        return min(abs(team.energyBalance) / maxEnergyBalance, 1)
    }
    
    private var balanceText: String {
        "\(Int(team.energyBalance.rounded())) PTS"
    }
    
    private var progressColor: Color {
        team.energyBalance < 0 ? .red : Color(red: 1.0, green: 0.36, blue: 0.10)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(team.name.uppercased())
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Spacer()
                
                Text(balanceText)
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
            }
            
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.black.opacity(0.65))
                    
                    Capsule()
                        .fill(progressColor)
                        .frame(width: proxy.size.width * progress)
                }
            }
            .frame(height: 16)
        }
    }
}

#Preview {
    ASAnalyticsView(
        teamViewModel: ASTeamViewModel(),
        careerViewModel: CareerViewModel()
    )
}
