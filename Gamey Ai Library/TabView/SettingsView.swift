import SwiftUI

struct SettingsView: View {
    @State private var showAlert = false

    var body: some View {
        List {
            Text("These should be the settings")
            Text("These should be the settings")

            Button("Show Alert") {
                showAlert = true
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Settings"),
                    message: Text("Settings Test"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    SettingsView()
}
