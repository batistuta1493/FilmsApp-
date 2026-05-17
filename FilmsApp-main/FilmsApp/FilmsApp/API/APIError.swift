import Foundation

enum APIError: Error {
    case failedRequest
    case unexpectedDataFormat
    case failedURLCreation
    case failedAuthentication
}
