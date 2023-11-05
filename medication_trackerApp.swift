//
//  medication_trackerApp.swift
//  medication tracker
//
//  Created by Zain Karim on 11/5/23.
//

import SwiftUI

@main
struct MedicationReminderApp: App {
    @StateObject private var medicationManager = MedicationManager()

    var body: some Scene {
        WindowGroup {
            MedicationListView(manager: medicationManager)
        }
    }
}
