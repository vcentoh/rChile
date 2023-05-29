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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        linkFlairText = try container.decodeIfPresent(String.self, forKey: .linkFlairText) ?? ""
        postHint = try container.decodeIfPresent(String.self, forKey: .postHint) ?? ""
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        score = try container.decodeIfPresent(Int.self, forKey: .score) ?? 0
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        numComments = try container.decodeIfPresent(Int.self, forKey: .numComments) ?? 0
    }
}

enum LinkFlairTextType: String {
    case shitposting = "Shitposting"
}

enum PostHintType: String {
    case threadImage = "image"
}
