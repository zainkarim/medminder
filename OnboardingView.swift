import SwiftUI
import UserNotifications

struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @State private var showWelcome = true // To toggle between the welcome and notification request view

    var body: some View {
        ZStack {
            Color(hex: "C3DBC5")
                .edgesIgnoringSafeArea(.all) // This will make the color extend to the edges

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
    }

    var welcomeView: some View {
        VStack {
            Text("Welcome to MedMinder! 👋")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .multilineTextAlignment(.center) // This will center align the text
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
        .background(Color(hex: "C3DBC5")) // Set the background color here
        .edgesIgnoringSafeArea(.all) // Make it extend to the screen edges
    }

    var notificationRequestView: some View {
        VStack {
            Text("Before we continue, we need you to enable notifications. 🔔")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .multilineTextAlignment(.center) // This will center align the text
            Button("Okay!") {
                requestNotificationPermission()
            }
            .padding()
            .background(Color.blue) // Choose an appropriate color that stands out
            .foregroundColor(.white)
            .clipShape(Capsule())
            Button("Maybe later") {
                isOnboardingCompleted = true
            }
            .padding()
            .foregroundColor(Color.blue) // Choose an appropriate color that contrasts well
        }
        .background(Color(hex: "C3DBC5")) // Set the background color here
        .edgesIgnoringSafeArea(.all) // Make it extend to the screen edges
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

// Extension to allow initialization of Color with a hex string
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
