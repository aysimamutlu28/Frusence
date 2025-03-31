import SwiftUI
import Foundation

struct WaveShape: Shape {
    var amplitude1: CGFloat
    var frequency1: CGFloat
    var amplitude2: CGFloat
    var frequency2: CGFloat
    var phase: CGFloat
    
    
    var animatableData: AnimatablePair<CGFloat, AnimatablePair<CGFloat, AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>>> {
        get {
            AnimatablePair(
                amplitude1,
                AnimatablePair(
                    frequency1,
                    AnimatablePair(
                        amplitude2,
                        AnimatablePair(frequency2, phase)
                    )
                )
            )
        }
        set {
            amplitude1 = newValue.first
            frequency1 = newValue.second.first
            amplitude2 = newValue.second.second.first
            frequency2 = newValue.second.second.second.first
            phase = newValue.second.second.second.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let height = rect.height
        let width = rect.width
        
        return Path { path in
            path.move(to: CGPoint(x: 0, y: calculateY(at: 0, in: rect)))
            
            stride(from: 0, to: width, by: 1).forEach { x in
                path.addLine(to: CGPoint(x: x, y: calculateY(at: x, in: rect)))
            }
            
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.closeSubpath()
        }
    }
    
    private func calculateY(at x: CGFloat, in rect: CGRect) -> CGFloat {
        let normalizedX = x / rect.width
        
        let baseHeight = rect.height * 0.3 //
        let component1 = amplitude1 * sin(2 * .pi * frequency1 * normalizedX)
        let component2 = amplitude2 * sin(2 * .pi * frequency2 * normalizedX + phase)
        
        return baseHeight + component1 + component2
    }
}
