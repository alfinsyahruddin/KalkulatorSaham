import SwiftUI

struct NumericTextField: View {
    var placeholder: String
    @Binding var value: Double
    @State private var input = ""
    @State private var formattedInput = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        TextField(placeholder, text: $input)
            .focused($isFocused)
            .onAppear { updateFromValue() }
            .onChange(of: input) { _, entered in
                guard entered != formattedInput else { return }
                let formatted = NumericInputFormatter.format(entered, previous: formattedInput)
                guard let number = NumericInputFormatter.value(of: formatted) else {
                    input = formattedInput
                    return
                }
                formattedInput = formatted
                if input != formatted { input = formatted }
                if value != number { value = number }
            }
            .onChange(of: value) { _, newValue in
                if NumericInputFormatter.value(of: input) != newValue { updateFromValue() }
            }
            .onChange(of: isFocused) { _, focused in
                if !focused { updateFromValue() }
            }
    }

    private func updateFromValue() {
        formattedInput = NumericInputFormatter.display(value)
        input = formattedInput
    }
}
