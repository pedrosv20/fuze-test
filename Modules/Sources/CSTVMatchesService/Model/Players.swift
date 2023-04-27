import Foundation

public struct Players: Equatable {
    public let name: String
    public let imageURL: URL?

    public init(
        name: String,
        imageURL: URL?
    ) {
        self.name = name
        self.imageURL = imageURL
    }
}

public extension Players {
    static func fixture(
        name: String = "player1",
        imageURL: URL? = nil
    ) -> Self {
        return .init(name: name, imageURL: imageURL)
    }
}
