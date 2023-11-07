
import Vapor

var env = try Environment.detect()
let app = Application(env)
//app.http.server.configuration.hostname = "192.168.1.39"

defer {
    app.shutdown()
}

var connections = Set<WebSocket>()

app.webSocket("chat") { request, client in
    print("Connected:", client)
    connections.insert(client)
    
    client.onClose.whenComplete { _ in
        print("Disconnected:", client)
        connections.remove(client)
    }
    
    client.onText { _, text in
        do {
            guard let date = text.data(using: .utf8) else {
                return
            }
            let incomingMessage = try JSONDecoder().decode(SubmittedChatMessage.self, from: date)
            let outgoingMessage = ReceivingChatMessage(message: incomingMessage.message,
                                                       username: incomingMessage.username,
                                                       userID: incomingMessage.userID)
            let jsonData = try JSONEncoder().encode(outgoingMessage)
            
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                return
            }
            
            for connection in connections {
                connection.send(jsonString)
            }
        } catch {
            print(error)
        }
    }
}

try app.run()
