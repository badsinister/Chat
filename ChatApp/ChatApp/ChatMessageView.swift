
import SwiftUI

struct ChatMessageView: View {
    
    let message: ReceivingChatMessage
    let isOutcoming: Bool
    
    var body: some View {
        HStack {
            if isOutcoming {
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(message.username)
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                    
                    Text(DateFormatter.localizedString(from: message.date, dateStyle: .medium, timeStyle: .medium))
                        .font(.system(size: 10))
                        .opacity(0.7)
                }
                Text(message.message)
            }
            .foregroundColor(isOutcoming ? .white : .black)
            .padding(16)
            .background(isOutcoming ? Color.blue : Color(white: 0.95))
            .cornerRadius(5)
            
            if !isOutcoming {
                Spacer()
            }
        }
    }
}
