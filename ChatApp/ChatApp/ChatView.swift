
import SwiftUI

struct ChatView: View {
    @EnvironmentObject private var userInfo: UserInfo
    @StateObject private var controller = ChatController()
    @State private var message = ""
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack(spacing: 8) {
                        ForEach(controller.messages) { message in
                            ChatMessageView(message: message, isOutcoming: message.userID == userInfo.userID).id(message.id)
                        }
                    }
                    .padding(10)
                    .onChange(of: controller.messages.count) { _ in
                        scrollToLastMessage(proxy: proxy)
                    }
                }
            }
            HStack {
                TextField("Message", text: $message, onCommit: onCommit)
                    .padding(10)
                    //.background(.secondary.opacity(0.2))
                    .foregroundColor(.secondary.opacity(0.2))
                    .cornerRadius(5)
                Button(action: onCommit) {
                    Image(systemName: "arrowshape.turn.up.right")
                        .font(.system(size: 20))
                }
                .padding()
                .disabled(message.isEmpty)
            }
            .padding()
        }
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }
    
    private func onAppear() {
        controller.connect(with: userInfo)
    }
    
    private func onDisappear() {
        controller.disconnect()
    }
    
    private func onCommit() {
        if !message.isEmpty {
            controller.send(text: message)
            message = ""
        }
    }
    
    private func scrollToLastMessage(proxy: ScrollViewProxy) {
        if let lastMessage = controller.messages.last {
            withAnimation(.easeOut(duration: 0.4)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
