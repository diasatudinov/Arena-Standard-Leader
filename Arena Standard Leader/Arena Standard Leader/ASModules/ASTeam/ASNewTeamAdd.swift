//
//  ASNewTeamAdd.swift
//  Arena Standard Leader
//
//

import SwiftUI

struct ASNewTeamAdd: View {
    @ObservedObject var viewModel: ASTeamViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var name = ""
    @State private var jobTitle = ""
    @State private var balance: Double = 0.0
    @State private var note = ""
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Image(.addNewTextAS)
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20, weight: .black))
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .offset(y: -10)
                    }
                VStack(spacing: 24) {
                    VStack {
                        ScrollView {
                            VStack(spacing: 20) {
                                VStack(spacing: 12) {
                                    Text("ADD PHOTO")
                                        .font(.system(size: 20, weight: .black))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    
                                    if let image = selectedImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                            .overlay(alignment: .topTrailing, content: {
                                                Button {
                                                    selectedImage = nil
                                                } label: {
                                                    Image(systemName: "xmark")
                                                        .font(.system(size: 14, weight: .black))
                                                        .foregroundStyle(.white)
                                                        .padding(8)
                                                        .background(.red)
                                                        .clipShape(Circle())
                                                }
                                            })
                                            .onTapGesture {
                                                withAnimation {
                                                    showingImagePicker = true
                                                }
                                            }
                                    } else {
                                        Circle()
                                            .fill(.gray.opacity(0.6))
                                            .frame(width: 100, height: 100)
                                            .overlay {
                                                VStack {
                                                    Image(systemName: "camera")
                                                        .font(.system(size: 20, weight: .regular))
                                                        .foregroundStyle(.gray)
                                                    
                                                    Text("PHOTO")
                                                        .font(.system(size: 12, weight: .regular))
                                                        .foregroundStyle(.gray)
                                                }
                                            }
                                            .overlay {
                                                Circle()
                                                    .stroke(lineWidth: 1)
                                                    .foregroundStyle(.gray)
                                            }
                                            .onTapGesture {
                                                withAnimation {
                                                    showingImagePicker = true
                                                }
                                            }
                                    }
                                    
                                }.padding(.top, 24)
                                
                                VStack(spacing: 12) {
                                    Text("NAME")
                                        .font(.system(size: 20, weight: .black))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    
                                    TextField("Enter name...", text: $name)
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
                                    
                                }
                               
                                
                                VStack(spacing: 12) {
                                    Text("JOB TITLE")
                                        .font(.system(size: 20, weight: .black))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    
                                    TextField("Enter role...", text: $jobTitle)
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
                                    
                                }
                                
                                VStack(spacing: 12) {
                                    Text("ENERGY BALANCE")
                                        .font(.system(size: 20, weight: .black))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    
                                    CareerRangeSliderView(value: $balance)
                                                    .padding(.horizontal, 0)
                                    
                                }
                                
                                VStack(spacing: 12) {
                                    Text("NOTE")
                                        .font(.system(size: 20, weight: .black))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    
                                    TextField("Enter note...", text: $note)
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
                                    
                                }
                                .padding(.bottom, 24)
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    .background(.newTeamBg)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    
                    
                    Button {
                        if let selectedImage {
                            let team = Team(name: name, jobTitle: jobTitle, energyBalance: balance, note: note, imageData: selectedImage.pngData())
                            viewModel.add(team)
                            dismiss()
                        } else {
                            let team = Team(name: name, jobTitle: jobTitle, energyBalance: balance, note: note)
                            viewModel.add(team)
                            dismiss()
                        }
                        
                    } label: {
                        Image(.addBtnAS)
                            .resizable()
                            .scaledToFit()
                    }
                }.padding()
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: $selectedImage, isPresented: $showingImagePicker)
            }
        }
    }
    
    func loadImage() {
        if let selectedImage = selectedImage {
            print("Selected image size: \(selectedImage.size)")
        }
    }
}

#Preview {
    ASNewTeamAdd(viewModel: ASTeamViewModel())
}

struct CareerRangeSliderView: View {
    
    @Binding var value: Double
    
    private let range: ClosedRange<Double> = -3...3
    private let step: Double = 0.1
    
    private let horizontalPadding: CGFloat = 0
    private let trackHeight: CGFloat = 4
    private let thumbSize: CGFloat = 12
    private let dotSize: CGFloat = 18
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let trackStart = horizontalPadding
            let trackEnd = width - horizontalPadding
            let trackWidth = trackEnd - trackStart
            let progress = progress(for: value)
            let thumbX = trackStart + trackWidth * progress
            let trackY: CGFloat = 86
            
            ZStack {
                
                endpointDots(
                    trackStart: trackStart,
                    trackEnd: trackEnd,
                    trackY: trackY
                )
                
                track(
                    trackStart: trackStart,
                    trackEnd: trackEnd,
                    thumbX: thumbX,
                    trackY: trackY
                )
                
                ticks(
                    trackStart: trackStart,
                    trackWidth: trackWidth,
                    trackY: trackY
                )
                
                valueBubble(x: thumbX, trackY: trackY)
                
                thumb(x: thumbX, trackY: trackY)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        updateValue(
                            locationX: gesture.location.x,
                            trackStart: trackStart,
                            trackWidth: trackWidth
                        )
                    }
            )
        }
        .frame(height: 90)
        .offset(y: -40)
    }
    
    private func endpointDots(
        trackStart: CGFloat,
        trackEnd: CGFloat,
        trackY: CGFloat
    ) -> some View {
        ZStack {
            Circle()
                .fill(Color.red)
                .frame(width: dotSize, height: dotSize)
                .position(x: trackStart + 10, y: trackY - 30)
            
            Circle()
                .fill(Color(red: 0.55, green: 0.82, blue: 0.05))
                .frame(width: dotSize, height: dotSize)
                .position(x: trackEnd - 10, y: trackY - 30)
        }
    }
    
    private func track(
        trackStart: CGFloat,
        trackEnd: CGFloat,
        thumbX: CGFloat,
        trackY: CGFloat
    ) -> some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.orange.opacity(0.25))
                .frame(width: trackEnd - trackStart, height: trackHeight)
                .position(x: (trackStart + trackEnd) / 2, y: trackY)
            
            Capsule()
                .fill(Color(red: 1.0, green: 0.32, blue: 0.12))
                .frame(width: max(0, thumbX - trackStart), height: trackHeight)
                .position(x: trackStart + max(0, thumbX - trackStart) / 2, y: trackY)
        }
    }
    
    private func ticks(
        trackStart: CGFloat,
        trackWidth: CGFloat,
        trackY: CGFloat
    ) -> some View {
        ZStack {
            ForEach([-3, -2, -1, 0, 1, 2, 3], id: \.self) { tick in
                let tickValue = Double(tick)
                let x = trackStart + trackWidth * progress(for: tickValue)
                
                VStack(spacing: 8) {
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 1, height: 4)
                        .cornerRadius(2)
                    
                    if tick != 0 {
                        Text("\(tick)")
                            .font(.system(size: 8, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                    } else {
                        Text("")
                            .font(.system(size: 22, weight: .medium, design: .rounded))
                    }
                }
                .position(x: x, y: trackY + 25)
            }
        }
    }
    
    private func valueBubble(x: CGFloat, trackY: CGFloat) -> some View {
        VStack(spacing: 0) {
            Text(valueText)
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 26, height: 24)
                .background(Color(red: 1.0, green: 0.32, blue: 0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Triangle()
                .fill(Color(red: 1.0, green: 0.32, blue: 0.12))
                .frame(width: 10, height: 6)
                .rotationEffect(.degrees(180))
        }
        .position(x: x, y: trackY - 25)
    }
    
    private func thumb(x: CGFloat, trackY: CGFloat) -> some View {
        Circle()
            .fill(Color(red: 1.0, green: 0.86, blue: 0.86))
            .frame(width: thumbSize, height: thumbSize)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            .position(x: x, y: trackY)
    }
    
    private var valueText: String {
        String(format: "%.1f", value)
    }
    
    private func progress(for value: Double) -> CGFloat {
        let clamped = min(max(value, range.lowerBound), range.upperBound)
        return CGFloat((clamped - range.lowerBound) / (range.upperBound - range.lowerBound))
    }
    
    private func updateValue(
        locationX: CGFloat,
        trackStart: CGFloat,
        trackWidth: CGFloat
    ) {
        let rawProgress = (locationX - trackStart) / trackWidth
        let clampedProgress = min(max(rawProgress, 0), 1)
        
        let rawValue = range.lowerBound + Double(clampedProgress) * (range.upperBound - range.lowerBound)
        let steppedValue = (rawValue / step).rounded() * step
        
        value = min(max(steppedValue, range.lowerBound), range.upperBound)
    }
}


private struct Triangle: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}
