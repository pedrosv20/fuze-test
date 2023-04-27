import Foundation

public struct Players: Equatable {
    public let name: String
    public let imageURL: URL?
    public let firstName: String?
    public let lastName: String?

    public init(
        name: String,
        imageURL: URL?,
        firstName: String?,
        lastName: String?
    ) {
        self.name = name
        self.imageURL = imageURL
        self.firstName = firstName
        self.lastName = lastName
    }
}

public extension Players {
    static func fixture(
        name: String = "player1",
        imageURL: URL? = nil,
        firstName: String = "pedro",
        lastName: String = "vargas"
    ) -> Self {
        return .init(name: name, imageURL: imageURL, firstName: firstName, lastName: lastName)
    }
}
