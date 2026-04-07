import Foundation

public struct BackgroundImageEntry: Identifiable, Equatable, Codable, Sendable {
    public let id: UUID
    public var imageData: Data

    public init(id: UUID = UUID(), imageData: Data) {
        self.id = id
        self.imageData = imageData
    }
}
