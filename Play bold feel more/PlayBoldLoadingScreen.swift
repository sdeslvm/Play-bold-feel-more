import SwiftUI

protocol ProgressDisplayable {
    var progressPercentage: Int { get }
}

protocol BackgroundProviding {
    associatedtype BackgroundContent: View
    func makeBackground() -> BackgroundContent
}

// MARK: - Modern Loading Overlay

struct PlayBoldLoadingOverlay: View, ProgressDisplayable {
    let progress: Double
    @State private var pulse = false
    var progressPercentage: Int { Int(progress * 100) }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Modern animated gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#0f2027"),
                        Color(hex: "#2c5364"),
                        Color(hex: "#00d2ff"),
                        Color(hex: "#ff6e7f")
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulse)
                .onAppear { pulse.toggle() }

                VStack(spacing: 32) {
                    Spacer()
                    // Animated, neon-style loading text
                    Text("PlayBold is Loading...")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "#00d2ff"), Color(hex: "#ff6e7f")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: Color(hex: "#00d2ff").opacity(0.6), radius: 12, y: 0)
                        .shadow(color: Color(hex: "#ff6e7f").opacity(0.4), radius: 20, y: 0)
                        .scaleEffect(pulse ? 1.05 : 0.95)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulse)
                        .onAppear { pulse = true }

                    // Neon progress bar and percentage
                    VStack(spacing: 18) {
                        Text("Loading \(progressPercentage)%")
                            .font(.system(size: 22, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                        PlayBoldProgressBar(value: progress)
                            .frame(width: geo.size.width * 0.6, height: 14)
                    }
                    .padding(18)
                    .background(Color.black.opacity(0.18))
                    .cornerRadius(18)
                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

// MARK: - Modern Progress Bar

struct PlayBoldProgressBar: View {
    let value: Double
    @State private var shimmerOffset: CGFloat = -1.0
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "#232526"),
                                Color(hex: "#414345"),
                                Color(hex: "#2c5364")
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: geometry.size.height)
                    .shadow(color: Color.black.opacity(0.3), radius: 6, y: 2)

                // Progress track
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "#00d2ff"),
                                Color(hex: "#ff6e7f"),
                                Color(hex: "#f7971e")
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: CGFloat(value) * geometry.size.width, height: geometry.size.height)
                    .scaleEffect(pulseScale)
                    .shadow(color: Color(hex: "#00d2ff").opacity(0.5), radius: 10, y: 0)
                    .shadow(color: Color(hex: "#ff6e7f").opacity(0.3), radius: 14, y: 0)
                    .animation(.easeInOut(duration: 0.3), value: value)

                // Shimmer effect
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.clear,
                                Color.white.opacity(0.7),
                                Color.clear,
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * 0.25, height: geometry.size.height)
                    .offset(x: shimmerOffset * geometry.size.width)
                    .clipped()
                    .frame(width: CGFloat(value) * geometry.size.width, height: geometry.size.height)
            }
            .onAppear {
                withAnimation(Animation.linear(duration: 1.8).repeatForever(autoreverses: false)) {
                    shimmerOffset = 1.2
                }
                withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    pulseScale = 1.08
                }
            }
        }
    }
}

// MARK: - Превью

#Preview("Modern Loading") {
    PlayBoldLoadingOverlay(progress: 0.42)
}

#Preview("Modern Loading Landscape") {
    PlayBoldLoadingOverlay(progress: 0.42)
        .previewInterfaceOrientation(.landscapeRight)
}
