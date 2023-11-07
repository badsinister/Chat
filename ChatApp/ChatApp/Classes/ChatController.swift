
import Foundation
import Combine

/// Контроллер данных. Организация взаимодействия с сервером.
class ChatController: ObservableObject {
    /// Данные пользователя.
    private var userInfo: UserInfo?
    /// Соединение с сервером.
    private var webSocketTask: URLSessionWebSocketTask?
    
    /// Сообщения, полученные от сервера.
    @Published private(set) var messages: [ReceivingChatMessage] = []
    
    // MARK: - Connection
    
    func connect(with userInfo: UserInfo) {
        self.userInfo = userInfo
        //let url = URL(string: "ws://192.168.1.39:8080/chat")!
        let url = URL(string: "ws://localhost:8080/chat")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.receive(completionHandler: onReceive)
        webSocketTask?.resume()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
    
    // MARK: - Messaging
    
    func send(text: String) {
        guard let userInfo = userInfo else {
            return
        }
        let message = SubmittedChatMessage(message: text, username: userInfo.username, userID: userInfo.userID)
        guard let jsonData = try? JSONEncoder().encode(message), let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }
        
        webSocketTask?.send(.string(jsonString), completionHandler: { error in
            if let error = error {
                print("Error sending message", error)
            }
        })
    }
    
    private func onReceive(incoming: Result<URLSessionWebSocketTask.Message, Error>) {
        webSocketTask?.receive(completionHandler: onReceive)
        switch incoming {
        case .success(let message):
            onMessage(message: message)
        case .failure(let error):
            print(error)
            // Чат сервер выключен
            
        }
    }
    
    private func onMessage(message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let text):
            guard let data = text.data(using: .utf8), let chatMessage = try? JSONDecoder().decode(ReceivingChatMessage.self, from: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self.messages.append(chatMessage)
            }
        case .data(let data):
            print(data)
        @unknown default:
            fatalError("Unknown message type;")
        }
    }
    
    deinit {
        disconnect()
    }
}
