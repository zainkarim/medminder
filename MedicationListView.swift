import SwiftUI

struct MedicationListView: View {
    @ObservedObject var manager: MedicationManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(manager.medications) { medication in
                    VStack(alignment: .leading) {
                        Text(medication.name).font(.headline)
                        Text("Dosage: \(medication.dosage)") // Fixed: Removed the extra "mg"
                        Text("Frequency: \(medication.frequency.joined(separator: ", "))")
                        Text("Time: \(medication.timeFormatted)")
                    }
                }
                .onDelete(perform: deleteMedication)
            }
            .navigationBarTitle("My Medications")
            .navigationBarItems(trailing: NavigationLink(destination: MedicationView(manager: manager)) {
                Image(systemName: "plus")
            })
        }
    }
    
    private func deleteMedication(at offsets: IndexSet) {
        offsets.forEach { index in
            let medication = manager.medications[index]
            manager.removeMedication(medication)
        }
    }
}

// The extension for Medication to format the time remains the same.
