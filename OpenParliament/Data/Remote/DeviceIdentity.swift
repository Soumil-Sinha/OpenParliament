//
//  DeviceIdentity.swift
//  OpenParliament
//
//  Anonymous per-install identifier sent with follow requests, so the server
//  can keep each device's followed bills apart without any account or
//  personal data.
//

import Foundation

enum DeviceIdentity {

    private static let storageKey = "deviceID"

    static var current: UUID {
        if let stored = UserDefaults.standard.string(forKey: storageKey),
           let id = UUID(uuidString: stored) {
            return id
        }
        let id = UUID()
        UserDefaults.standard.set(id.uuidString, forKey: storageKey)
        return id
    }
}
