import SwiftUI
import Combine // Import Combine for the onReceive modifier

struct MedicationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var dosage: String = "" // Use a string to hold the dosage amount
    @State private var frequency: [String] = []
    @State private var timeOfDay = Date() // State variable for the time picker
    @ObservedObject var manager: MedicationManager
    @State private var medicationToEdit: Medication?
    
    init(manager: MedicationManager, medication: Medication?) {
            self._manager = ObservedObject(wrappedValue: manager)
            self._medicationToEdit = State(initialValue: medication)
            if let medication = medication {
                _name = State(initialValue: medication.name)
                _dosage = State(initialValue: medication.dosage)
                _frequency = State(initialValue: medication.frequency)
                _timeOfDay = State(initialValue: medication.time)
            }
        }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medication Details")) {
                    TextField("Name", text: $name)
                    
                    // A text field for dosage, with a numeric keypad
                    TextField("Dosage (mg)", text: $dosage)
                        .keyboardType(.numberPad)
                        .onReceive(Just(dosage)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.dosage = filtered
                            }
                        }
                    
                    // Multiple selection for weekdays
                    MultipleSelectionView(selectedDays: $frequency)
                    
                    // Time picker
                    DatePicker(
                        "Time of Day",
                        selection: $timeOfDay,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                }
                
                Button(action: addOrUpdateMedication) {
                    Text(medicationToEdit != nil ? "Update Medication" : "Add Medication")
                }
            }
            .navigationBarTitle("Add Medication")
        }
    }
    
    private func addMedication() {
        let newMedication = Medication(
            name: name,
            dosage: "\(dosage) mg", // Assume dosage is entered correctly and append "mg" here
            frequency: sortDaysOfWeek(frequency), // Sort the days of the week properly
            time: timeOfDay
        )
        manager.addMedication(newMedication)
        // Reset the fields
        name = ""
        dosage = ""
        frequency = []
        presentationMode.wrappedValue.dismiss() // Dismiss after adding the medication
    }
    
    private func sortDaysOfWeek(_ days: [String]) -> [String] {
        let weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        return days.sorted { weekDays.firstIndex(of: $0)! < weekDays.firstIndex(of: $1)! }
    }
    
    private func addOrUpdateMedication() {
            let medication = Medication(
                id: medicationToEdit?.id ?? UUID(), // Use existing ID if editing
                name: name,
                dosage: "\(dosage) mg",
                frequency: sortDaysOfWeek(frequency),
                time: timeOfDay
            )
            
            if medicationToEdit != nil {
                manager.updateMedication(medication)
            } else {
                manager.addMedication(medication)
            }
            
            // Reset the fields and dismiss
            resetFields()
            presentationMode.wrappedValue.dismiss()
        }
    private func resetFields() {
            name = ""
            dosage = ""
            frequency = []
            timeOfDay = Date()
            medicationToEdit = nil
        }

}

// MultipleSelectionView and MultipleSelectionRow remain the same.
