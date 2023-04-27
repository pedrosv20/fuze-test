
import Foundation

public struct PlayersResponse: Decodable {
    public let players: [Player]
    
    public init(players: [Player]) {
        self.players = players
    }
    
    public struct Player: Decodable {
        public let name: String
        public let imageURL: String?
        public let firstName: String?
        public let lastName: String?

        public init(
            name: String,
            imageURL: String?,
            firstName: String?,
            lastName: String?
        ) {
            self.name = name
            self.imageURL = imageURL
            self.firstName = firstName
            self.lastName = lastName
        }
        
        public enum CodingKeys: String, CodingKey {
            case name
            case imageURL = "image_url"
            case firstName = "first_name"
            case lastName = "last_name"
        }
    }
}
