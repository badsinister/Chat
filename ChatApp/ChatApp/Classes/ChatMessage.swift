
import Foundation

/// Сообщение, которое пользователь отправляет на сервер.
struct SubmittedChatMessage: Encodable {
    let message: String
    let username: String
    let userID: String
}

/// Сообщение, полученное от сервера.
struct ReceivingChatMessage: Decodable, Identifiable {
    let id: String
    let date: Date
    let message: String
    let username: String
    let userID: String
}
