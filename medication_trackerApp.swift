import SwiftUI

@main
struct MedicationReminderApp: App {
    @StateObject private var medicationManager = MedicationManager()
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false

    var body: some Scene {
        WindowGroup {
            if isOnboardingCompleted {
                MedicationListView(manager: medicationManager)
            } else {
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
            }
        }
    }

}
