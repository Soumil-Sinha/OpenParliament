//
//  APIConfiguration.swift
//  OpenParliament
//
//  Where the app finds the OpenParliament server. The simulator shares the
//  Mac's network, so the default `localhost` reaches a server started with
//  `npm start`; on a physical device, set the Mac's LAN address in Settings.
//

import Foundation

enum APIConfiguration {

    static let defaultBaseURL = URL(string: "http://localhost:8080")!

    private static let storageKey = "apiBaseURL"
    private static let environmentKey = "OPENPARLIAMENT_API_URL"

    /// Resolution order: launch environment (for UI tests and screenshots),
    /// then the address saved in Settings, then the local default.
    static var baseURL: URL {
        if let override = ProcessInfo.processInfo.environment[environmentKey],
           let url = URL(string: override) {
            return url
        }
        if let saved = UserDefaults.standard.string(forKey: storageKey),
           let url = URL(string: saved) {
            return url
        }
        return defaultBaseURL
    }

    /// Persists a new server address. Passing nil restores the default.
    static func save(_ url: URL?) {
        UserDefaults.standard.set(url?.absoluteString, forKey: storageKey)
    }

    /// Accepts "192.168.1.20:8080" as well as a full URL.
    static func parse(_ text: String) -> URL? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let withScheme = trimmed.contains("://") ? trimmed : "http://\(trimmed)"
        guard let url = URL(string: withScheme), url.host() != nil else { return nil }
        return url
    }
}
