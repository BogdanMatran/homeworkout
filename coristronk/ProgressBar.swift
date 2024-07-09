//
//  ProgressCircle.swift
//  coristronk
//
//  Created by Matran Bogdan on 09.07.2024.
//

import SwiftUI
struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
        }
    }
}

#Preview {
    ProgressBar(progress: .constant(50))
}
