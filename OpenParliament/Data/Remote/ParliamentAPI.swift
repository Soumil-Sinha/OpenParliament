//
//  ParliamentAPI.swift
//  OpenParliament
//
//  Thin async client for the OpenParliament server. Every call is a single
//  request; retry and fallback policy belong to `ParliamentStore`.
//

import Foundation

struct ParliamentAPI {

    enum APIError: LocalizedError {
        case unreachable(URL)
        case status(Int)
        case decoding(Error)

        var errorDescription: String? {
            switch self {
            case .unreachable(let url):
                "Couldn’t reach the server at \(url.host() ?? url.absoluteString)."
            case .status(let code):
                "The server answered with an error (\(code))."
            case .decoding(let error):
                "The server sent data the app couldn’t read. \(error.localizedDescription)"
            }
        }
    }

    let baseURL: URL
    var deviceID: UUID = DeviceIdentity.current
    var session: URLSession = .shared

    // MARK: - Reads

    func health() async throws -> HealthDTO {
        try await send("GET", "api/health")
    }

    /// Members, bills, schemes and speeches in one round trip.
    func snapshot() async throws -> SnapshotDTO {
        try await send("GET", "api/snapshot")
    }

    func followedBillIDs() async throws -> [String] {
        let follows: [FollowDTO] = try await send("GET", "api/follows")
        return follows.map(\.billID)
    }

    // MARK: - Writes

    func follow(billID: String) async throws {
        try await sendWithoutBody("PUT", "api/follows/\(billID)")
    }

    func unfollow(billID: String) async throws {
        try await sendWithoutBody("DELETE", "api/follows/\(billID)")
    }

    // MARK: - Transport

    private func request(_ method: String, _ path: String) -> URLRequest {
        var request = URLRequest(url: baseURL.appending(path: path))
        request.httpMethod = method
        request.timeoutInterval = 8
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(deviceID.uuidString.lowercased(), forHTTPHeaderField: "X-Device-ID")
        return request
    }

    private func perform(_ request: URLRequest) async throws -> Data {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.unreachable(baseURL)
        }
        guard let http = response as? HTTPURLResponse else { throw APIError.unreachable(baseURL) }
        guard (200..<300).contains(http.statusCode) else { throw APIError.status(http.statusCode) }
        return data
    }

    private func send<Response: Decodable>(_ method: String, _ path: String) async throws -> Response {
        let data = try await perform(request(method, path))
        do {
            return try JSONDecoder().decode(Response.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }

    private func sendWithoutBody(_ method: String, _ path: String) async throws {
        _ = try await perform(request(method, path))
    }
}
