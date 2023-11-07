
import Foundation
import Combine

class UserInfo: ObservableObject {
    let userID = UUID().uuidString
    @Published var username: String = ""
}
