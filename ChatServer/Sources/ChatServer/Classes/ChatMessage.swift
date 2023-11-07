
import Foundation

/// Сообщение, которое пользователь отправляет на сервер.
struct SubmittedChatMessage: Decodable {
    let message: String
    let username: String
    let userID: String
}

/// Сообщение, полученное от сервера.
struct ReceivingChatMessage: Encodable, Identifiable {
    let id: String = UUID().uuidString
    let date: Date = Date()
    let message: String
    let username: String
    let userID: String
}

