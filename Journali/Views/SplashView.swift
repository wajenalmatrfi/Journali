import SwiftUI

/// The first screen people see when Journali launches.
///
/// Shows the app's logo and tagline briefly, then fades into
/// ``MainView``.
 
struct SplashView: View {
    /// Whether the splash has finished and the main screen should appear.
    @State private var isFinished = false
    
    var body: some View {
        // A ZStack keeps both screens on top of each other during the transition, so one can fade out while the other fades in.
        ZStack {
            if isFinished {
                MainView()
                    .transition(.opacity)
            } else {
                splashContent
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(1.5))
            withAnimation(.easeInOut(duration: 0.6)) {
                isFinished = true
            }
        }
    }
    
    private var splashContent: some View {
        ZStack {
            LinearGradient(
                colors: [Color(.backgroundPrimary), Color(.gradientBottom)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 12) {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                
                Text("Journali")
                    .font(.system(size: 42, weight: .black))
                    .foregroundStyle(Color(.textPrimary))
                
                Text("Your thoughts, your story")
                    .font(.system(size: 18, weight: .light))
                    .foregroundStyle(Color(.textPrimary).opacity(0.8))
            }
        }
    }
}

