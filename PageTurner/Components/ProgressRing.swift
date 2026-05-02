//
//  ProgressRing.swift
//  PageTurner
//
//  Created by Kody McNamara on 5/2/26.
//

//from online, i couldn't figure out how to get it to look right
import SwiftUI

struct ProgressRing: View {
    let progress: Double
    
    private let lineWidth: CGFloat = 4
    
    var body: some View {
        ZStack {
            //track in background
            Circle()
                .stroke(.secondary.opacity(0.2), lineWidth: lineWidth)
            
            //fill the arc
            Circle()
                .trim(from: 0, to: progress)
                .stroke(progressColor, style: StrokeStyle(lineWidth:lineWidth,lineCap:.round))
                .rotationEffect(.degrees(-90)) //start from the top
                .animation(.easeInOut(duration: 0.4),value: progress)
            
            //percentage label
            Text("\(Int(progress * 100))%")
                .font(.system(size:9,weight:.semibold))
                .foregroundStyle(.secondary)
        }
    }
    
    //make it fancy and change color depending on progress
    private var progressColor: Color {
        switch progress {
        case 1.0: return .green
        case 0.5...: return .blue
        default: return .orange
        }
    }
}
