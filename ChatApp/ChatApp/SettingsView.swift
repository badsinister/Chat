
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var userInfo: UserInfo
    
    private var isUsernameIsValid: Bool {
        return !userInfo.username.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("Username")) {
                TextField("E.g. John Applesheed", text: $userInfo.username)
                NavigationLink("Continue", destination: ChatView())
                    .disabled(!isUsernameIsValid)
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
