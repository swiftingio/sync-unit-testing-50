import Foundation

struct Message {
    let author: String
    let text: String
    let id: String
}


extension Message {
    
    static let welcome =
        
        Message(author: "The App",
                text:   "Welcome in the App!",
                id:     "0")
    
}
