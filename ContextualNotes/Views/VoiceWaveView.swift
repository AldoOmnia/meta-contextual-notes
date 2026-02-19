import SwiftUI

/// Animated voice wave bars mimicking audio levels
struct VoiceWaveView: View {
    let isActive: Bool
    let barCount: Int

    init(isActive: Bool = true, barCount: Int = 7) {
        self.isActive = isActive
        self.barCount = barCount
    }

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<barCount, id: \.self) { i in
                VoiceBar(index: i, isActive: isActive)
            }
        }
    }
}

private struct VoiceBar: View {
    let index: Int
    let isActive: Bool
    @State private var scale: CGFloat = 0.3

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(AppTheme.accent.opacity(isActive ? 0.9 : 0.25))
            .frame(width: 3, height: 8)
            .scaleEffect(y: isActive ? scale : 0.3, anchor: .center)
            .onAppear {
                if isActive {
                    animate()
                }
            }
            .onChange(of: isActive) { _, active in
                if active {
                    animate()
                } else {
                    scale = 0.3
                    withAnimation(.easeOut(duration: 0.2)) { scale = 0.3 }
                }
            }
    }

    private func animate() {
        let delay = Double(index) * 0.05
        let variance = 0.3 + (Double(index % 3) * 0.25)
        withAnimation(.easeInOut(duration: 0.35).repeatForever(autoreverses: true).delay(delay)) {
            scale = variance
        }
    }
}
