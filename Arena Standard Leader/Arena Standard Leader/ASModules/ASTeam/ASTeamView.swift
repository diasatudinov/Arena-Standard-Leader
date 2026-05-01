//
//  ASTeamView.swift
//  Arena Standard Leader
//
//

import SwiftUI

struct ASTeamView: View {
    @ObservedObject var viewModel: ASTeamViewModel
    
    var body: some View {
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Image(.networkTextAS)
                    .resizable()
                    .scaledToFit()
                
                if viewModel.teams.isEmpty {
                    VStack {
                        Spacer()
                        Text("No Connections Yet")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundStyle(.white)
                        
                        
                        Text("It looks like you haven't added any teammates to your network. Start tracking your team's energy to stay in sync!")
                            .font(.system(size: 22, weight: .regular))
                            .foregroundStyle(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                        Spacer()
                        
                        NavigationLink {
                            ASNewTeamAdd(viewModel: viewModel)
                                .navigationBarBackButtonHidden()
                        } label: {
                            Image(.addNewBtnAS)
                                .resizable()
                                .scaledToFit()
                            
                        }
                        .padding(.bottom, 150)
                        
                    }
                    .padding(.horizontal)
                } else {
                    VStack {
                        
                        NavigationLink {
                            ASNewTeamAdd(viewModel: viewModel)
                                .navigationBarBackButtonHidden()
                        } label: {
                            Image(.addNewBtnAS)
                                .resizable()
                                .scaledToFit()
                            
                        }
                        
                        ScrollView {
                            VStack {
                                ForEach(viewModel.teams, id: \.id) { team in
                                    ASTeamCell(team: team)
                                }
                            }
                            .padding(.bottom, 150)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                }
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        ASTeamView(viewModel: ASTeamViewModel())
    }
}


struct ASTeamCell: View {
    let team: Team
    
    var body: some View {
        VStack {
            HStack {
                
                if let image = team.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 54, height: 54)
                        .clipShape(Circle())
                        
                        
                } else {
                    Circle()
                        .fill(.gray.opacity(0.6))
                        .frame(width: 54, height: 54)
                        .overlay {
                            VStack {
                                Image(systemName: "camera")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundStyle(.gray)
                                
                                Text("PHOTO")
                                    .font(.system(size: 10, weight: .regular))
                                    .foregroundStyle(.gray)
                            }
                        }
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 1)
                                .foregroundStyle(.gray)
                        }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(team.name)
                        .font(.system(size: 24, weight: .black))
                        .foregroundStyle(.black)
                    
                    Text(team.jobTitle)
                        .font(.system(size: 18, weight: .black))
                        .foregroundStyle(.black.opacity(0.8))
                    
                }
            }
            
            MoodProgressView(value: team.energyBalance)
                .padding(.top)
            
            Text(team.note)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.white.opacity(0.75))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.black, lineWidth: 2)
                )
                .padding(.vertical)
        }
        .padding()
        .background(
            Image(.cardBgAS)
                .resizable()
        )
        
    }
}

struct MoodProgressView: View {
    
    let value: Double
    let maxValue: Double = 3
    
    private var progress: Double {
        min(abs(value) / maxValue, 1)
    }
    
    private var progressColor: Color {
        if value < 0 {
            return .red
        } else if value > 0 {
            return .green
        } else {
            return .gray
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ProgressView(value: progress)
                .progressViewStyle(.linear)
                .tint(progressColor)
                .scaleEffect(x: 1, y: 4, anchor: .center)
        }
    }
}
