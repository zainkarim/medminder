import SwiftUI
import UserNotifications

struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @State private var showWelcome = true // To toggle between the welcome and notification request view

    var body: some View {
        VStack {
            if showWelcome {
                welcomeView
                    .transition(.opacity)
            } else {
                notificationRequestView
                    .transition(.opacity)
            }
        }
    }

    var welcomeView: some View {
        VStack {
            Text("Welcome to MedMinder! 👋")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Button("Continue") {
                withAnimation {
                    showWelcome = false
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }

    var notificationRequestView: some View {
        VStack {
            Text("Before we continue, we need you to enable notifications. 🔔")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Button("Okay!") {
                requestNotificationPermission()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())

            Button("Maybe later") {
                isOnboardingCompleted = true // Assuming the user can enable notifications later in settings.
            }
            .padding()
            .foregroundColor(Color.blue)
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                isOnboardingCompleted = true
            }
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
