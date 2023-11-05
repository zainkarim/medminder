//
//  MedicationManager.swift
//  medication tracker
//
//  Created by Zain Karim on 11/5/23.
//

import Foundation

class MedicationManager: ObservableObject {
    @Published var medications: [Medication] = [] {
        didSet {
            saveToUserDefaults()
        }
    }

    init() {
        UserDefaults.standard.removeObject(forKey: "isOnboardingCompleted")
        loadFromUserDefaults()
    }

    func addMedication(_ medication: Medication) {
        medications.append(medication)
    }

    func removeMedication(_ medication: Medication) {
        medications.removeAll { $0.id == medication.id }
    }

    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(medications) {
            UserDefaults.standard.set(encoded, forKey: "medications")
        }
    }

    private func loadFromUserDefaults() {
        if let medicationsData = UserDefaults.standard.data(forKey: "medications"),
           let decoded = try? JSONDecoder().decode([Medication].self, from: medicationsData) {
            medications = decoded
        }
    }
    
    func updateMedication(_ medication: Medication) {
            if let index = medications.firstIndex(where: { $0.id == medication.id }) {
                medications[index] = medication
            }
        }
}
