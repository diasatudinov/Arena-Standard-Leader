//
//  ASMenuView.swift
//  Arena Standard Leader
//
//

import SwiftUI

struct ASMenuView: View {
    @StateObject private var viewModel = CareerViewModel()
    @StateObject private var teamVM = ASTeamViewModel()
    @State var selectedTab = 0
    private let tabs = ["Spin", "Talk", "Stats", "Trips", "Trips"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            Color.black
                .ignoresSafeArea()
            
            
            TabView(selection: $selectedTab) {
                CareerView(viewModel: viewModel)
                    .tag(0)
                
                QuestArchiveView(viewModel: viewModel)
                    .tag(1)
                
                ASTeamView(viewModel: teamVM)
                    .tag(2)
                
                ASRewardView(viewModel: teamVM)
                    .tag(3)
                
                ASAnalyticsView(
                    teamViewModel: teamVM,
                    careerViewModel: viewModel
                )
                    .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            customTabBar
        }
        .background(.blue)
        .ignoresSafeArea(edges: .bottom)
        
    }
    
    private var customTabBar: some View {
        HStack(spacing: 0) {
            HStack(spacing: 4) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Button {
                        selectedTab = index
                    } label: {
                        VStack(spacing: 4) {
                            Image(selectedTab == index ? selectedIcon(for: index) : icon(for: index))
                                .resizable()
                                .scaledToFit()
                                .frame(height: selectedTab == index ? 120 : 52)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                        .padding(.bottom, 5)
                    }
                    .offset(y: selectedTab == index ? -10 : 0)
                }
            }
            .frame(height: 90)
            .frame(maxWidth: .infinity)
            .background(
                Image(.tabBarBgAS)
                    .resizable()
                    .scaledToFill()
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 35)
        }
        .frame(height: 100)
    }
    
    private func icon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconAS"
        case 1: return "tab2IconAS"
        case 2: return "tab3IconAS"
        case 3: return "tab4IconAS"
        case 4: return "tab5IconAS"
        default: return ""
        }
    }
    
    private func selectedIcon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconSelectedAS"
        case 1: return "tab2IconSelectedAS"
        case 2: return "tab3IconSelectedAS"
        case 3: return "tab4IconSelectedAS"
        case 4: return "tab5IconSelectedAS"
        default: return ""
        }
    }
}

#Preview {
    NavigationStack {
        ASMenuView()
    }
}
