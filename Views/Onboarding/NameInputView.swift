//
//  NameInputView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//
import SwiftUI

struct MeshGradientView: View {
    @Binding var maskTimer: Float
    let gradientSpeed: Float
    
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                
                let gradient = Gradient(colors: [
                    Color.AI.mandy, Color.AI.redRibbon, Color.AI.ecstasy,
                    Color.AI.tonysPink, Color.AI.mediumPurple, Color.AI.fuchsiaPink,
                    Color.AI.wisteria, Color.AI.cornflowerBlue, Color.AI.danube
                ])
                
                let startPoint = CGPoint(
                    x: size.width * CGFloat(sinInRange(0.2...0.8, offset: 0.239, timeScale: 0.084, t: maskTimer)),
                    y: size.height * CGFloat(sinInRange(0.3...0.7, offset: 3.42, timeScale: 0.984, t: maskTimer))
                )
                
                let endPoint = CGPoint(
                    x: size.width * CGFloat(sinInRange(0.1...0.9, offset: 1.439, timeScale: 0.442, t: maskTimer)),
                    y: size.height * CGFloat(sinInRange(0.2...0.8, offset: 0.25, timeScale: 0.642, t: maskTimer))
                )
                
                context.drawLayer { ctx in
                    ctx.fill(
                        Path(CGRect(origin: .zero, size: size)),
                        with: .linearGradient(
                            gradient,
                            startPoint: startPoint,
                            endPoint: endPoint
                        )
                    )
                }
            }
        }
        .onReceive(timer) { _ in
            withAnimation {
                maskTimer += gradientSpeed
            }
        }
    }
    
    private func sinInRange(
        _ range: ClosedRange<Float>,
        offset: Float,
        timeScale: Float,
        t: Float
    ) -> Float {
        let amplitude = (range.upperBound - range.lowerBound) / 2
        let midPoint = (range.upperBound + range.lowerBound) / 2
        return midPoint + amplitude * sin(timeScale * t + offset)
    }
}

struct NameInputView: View {
    @Binding var name: String
    @State private var maskTimer: Float = 0.0
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                MeshGradientView(maskTimer: $maskTimer, gradientSpeed: 0.03)
                    .scaleEffect(1.3)
                    .opacity(isAnimating ? 1 : 0)
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text("Welcome to Hero Coach")
                            .font(.system(size: 40, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                        Text("A goals experience tailored for you")
                            .font(.title2)
                            .italic()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text("What's your name?")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        TextField("Enter your name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 30)
                        
                    }
                    .padding(.bottom, 50)
                    
                    
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}
