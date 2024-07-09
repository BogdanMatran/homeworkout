//
//  ProgressCircle.swift
//  coristronk
//
//  Created by Matran Bogdan on 09.07.2024.
//

import SwiftUI
struct ProgressBar: View {
    @Binding var progress: Float
    @Binding var fillColor: Color
    @Binding var image: String
    
    var body: some View {
            ZStack {
                GeometryReader { geometry in
                    Circle()
                        .stroke(lineWidth: 20.0)
                        .opacity(0.3)
                        .foregroundColor(fillColor.opacity(0.5))
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(self.progress))
                        .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(fillColor)
                        .rotationEffect(Angle(degrees: 270.0))
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15) // Adjust size as needed
                        .foregroundColor(.black)
                        .position(x: geometry.size.width / 2, y: 0) // Adjust y offset as needed
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
}

#Preview {
    ProgressBar(progress: .constant(0.5), fillColor: .constant(.blue), image: .constant("leg"))
}
