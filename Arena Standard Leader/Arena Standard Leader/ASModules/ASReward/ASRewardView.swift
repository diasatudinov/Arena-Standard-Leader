//
//  ASRewardView.swift
//  Arena Standard Leader
//
//

import SwiftUI

struct ASRewardView: View {
    @ObservedObject var viewModel: ASTeamViewModel
    
    private let columns = [
           GridItem(.flexible(), spacing: 12),
           GridItem(.flexible(), spacing: 12)
       ]
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                Image(.rewardsTextAS)
                    .resizable()
                    .scaledToFit()
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.rewards, id: \.id) { reward in
                            Image(reward.isUnlocked ? "achiveBgOn" : "achiveBgOff")
                                .resizable()
                                .scaledToFit()
                                .overlay {
                                    VStack(spacing: 25) {
                                        VStack(spacing: 20) {
                                            Text(reward.title)
                                                .font(.system(size: 17, weight: .black))
                                                .textCase(.uppercase)
                                                .foregroundStyle(.white)
                                            
                                            Text(reward.description)
                                                .font(.system(size: 13, weight: .black))
                                                .textCase(.uppercase)
                                                .foregroundStyle(.white)
                                                .lineLimit(2)
                                                .padding(.horizontal, 8)
                                        }
                                        
                                        Text(reward.icon)
                                            .font(.system(size: 70, weight: .black))
                                            .textCase(.uppercase)
                                        
                                        
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 9)
                                }
                                .onTapGesture {
                                    viewModel.toggleReward(reward)
                                }
                        }
                    }.padding(.horizontal)
                        .padding(.bottom, 150)
                }
            }
        }
    }
}

#Preview {
    ASRewardView(viewModel: ASTeamViewModel())
}
