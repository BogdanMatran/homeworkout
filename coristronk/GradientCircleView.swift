//
//  GradientCircleView.swift
//  coristronk
//
//  Created by Matran Bogdan on 09.07.2024.
//

import SwiftUI

struct GradientCircleView: View {
    @State private var progress: Double = 0.75
    private let gradientColors = Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple])

    var body: some View {
        GeometryReader { geometry in
            Circle()
                .trim(from: 0.0, to: CGFloat(self.progress))
                .stroke(
                    LinearGradient(
                        gradient: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(Angle(degrees: 270.0))
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .frame(width: 200, height: 200) // Adjust the frame size as needed
    }
}

#Preview {
    GradientCircleView()
}
