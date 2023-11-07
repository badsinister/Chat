
import SwiftUI

struct ContentView: View {
    @StateObject private var userInfo = UserInfo()
    
    var body: some View {
        NavigationView {
            SettingsView()
        }
        .environmentObject(userInfo)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
