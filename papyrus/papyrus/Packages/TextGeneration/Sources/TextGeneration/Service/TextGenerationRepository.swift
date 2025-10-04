import Foundation
import SDNetworkCore

public protocol TextGenerationRepositoryProtocol {
    func createPlotOutline(story originalStory: Story) async throws -> Story
    func createSequelPlotOutline(story originalStory: Story, previousStory: Story) async throws -> Story
    func createChapterBreakdown(story originalStory: Story) async throws -> Story
    func getStoryDetails(story originalStory: Story) async throws -> Story
    func getChapterTitle(story originalStory: Story) async throws -> Story
    func createChapter(story originalStory: Story) async throws -> Story
}

public class TextGenerationRepository: TextGenerationRepositoryProtocol {
    private let networkCore: SDNetworkCore
    
    public init(
        networkCore: SDNetworkCore = SDNetworkCore()
    ) {
        self.networkCore = networkCore
    }
    
    public func createPlotOutline(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let endpoint = CreatePlotOutlineEndpoint(story: story)
        let content = try await networkCore.requestContent(endpoint)
        
        story.plotOutline = content
        return story
    }
    
    public func createSequelPlotOutline(story originalStory: Story, previousStory: Story) async throws -> Story {
        var story = originalStory
        let endpoint = CreateSequelPlotOutlineEndpoint(story: story, previousStory: previousStory)
        let content = try await networkCore.requestContent(endpoint)
        
        story.plotOutline = content
        return story
    }
    
    public func createChapterBreakdown(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let endpoint = CreateChapterBreakdownEndpoint(story: story)
        let content = try await networkCore.requestContent(endpoint)
        
        story.chaptersBreakdown = content
        return story
    }
    
    public func getStoryDetails(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let endpoint = GetStoryDetailsEndpoint(story: story)
        let content = try await networkCore.requestContent(endpoint)
        
        // Extract the integer from the response
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        if let numberOfChapters = Int(trimmedContent) {
            story.maxNumberOfChapters = numberOfChapters
        } else {
            // Fallback: try to extract first number from the response
            let numbers = trimmedContent.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap { Int($0) }
            story.maxNumberOfChapters = numbers.first ?? 0
        }
        
        return story
    }
    
    public func getChapterTitle(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let endpoint = GetChapterTitleEndpoint(story: story)
        let content = try await networkCore.requestContent(endpoint)
        
        story.title = content.trimmingCharacters(in: .whitespacesAndNewlines)
        return story
    }
    
    public func createChapter(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let endpoint = CreateChapterEndpoint(story: story)
        let content = try await networkCore.requestContent(endpoint)
        
        story.chapters.append(.init(content: content))
        return story
    }
}

public enum TextGenerationError: Error {
    case invalidResponse
    case parsingError
}
