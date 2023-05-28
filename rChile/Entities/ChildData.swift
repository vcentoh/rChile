// MARK: - ChildData
struct ChildData: Codable {
    
    let linkFlairText: String
    let postHint: String?
    let title: String
    let url: String
    let score: Int
    let numComments: Int
    
    enum CodingKeys: String, CodingKey {
        case score, title, url
        case linkFlairText = "link_flair_text"
        case postHint = "post_hint"
        case numComments = "num_comments"
    }
}

enum LinkFlairTextType: String {
    case shitposting = "Shitposting"
}

enum PostHintType: String {
    case threadImage = "image"
}
