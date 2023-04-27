
import Foundation

public struct PlayersResponse: Decodable {
    public let players: [Player]
    
    public init(players: [Player]) {
        self.players = players
    }
    
    public struct Player: Decodable {
        public let name: String
        public let imageURL: String?

        public init(
            name: String,
            imageURL: String?
        ) {
            self.name = name
            self.imageURL = imageURL
        }
        
        public enum CodingKeys: String, CodingKey {
            case name
            case imageURL = "image_url"
        }
    }
}
