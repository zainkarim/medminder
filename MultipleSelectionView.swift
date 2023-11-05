import SwiftUI

struct MultipleSelectionView: View {
    @Binding var selectedDays: [String]
    private let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    var body: some View {
        List(daysOfWeek, id: \.self) { day in
            MultipleSelectionRow(title: day, isSelected: selectedDays.contains(day)) {
                if let selectedIndex = selectedDays.firstIndex(of: day) {
                    selectedDays.remove(at: selectedIndex)
                } else {
                    selectedDays.append(day)
                }
            }
        }
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
        .foregroundColor(isSelected ? .blue : .primary)
    }
}
