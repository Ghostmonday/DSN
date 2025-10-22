//
//  Telemetry.swift
//  DirectorStudio
//
//  MODULE: Telemetry
//  VERSION: 1.0.0
//  PURPOSE: Centralized telemetry and analytics tracking system
//

import Foundation

/// Centralized telemetry system for DirectorStudio modules
public actor Telemetry {
    
    public static let shared = Telemetry()
    
    private var registeredModules: Set<String> = []
    private var eventLog: [TelemetryEvent] = []
    private var isEnabled: Bool = true
    
    private init() {}
    
    /// Register a module for telemetry tracking
    public func register(module: String) {
        registeredModules.insert(module)
    }
    
    /// Check if a module is registered
    public func isRegistered(for module: String) -> Bool {
        return registeredModules.contains(module)
    }
    
    /// Log an event with optional metadata
    public func logEvent(_ name: String, metadata: [String: String] = [:]) {
        guard isEnabled else { return }
        
        let event = TelemetryEvent(
            name: name,
            timestamp: Date(),
            metadata: metadata
        )
        
        eventLog.append(event)
        
        // Log to console in development
        #if DEBUG
        print("[TELEMETRY] \(name) - \(metadata)")
        #endif
    }
    
    /// Get recent events for debugging
    public func getRecentEvents(count: Int = 100) -> [TelemetryEvent] {
        return Array(eventLog.suffix(count))
    }
    
    /// Clear event log
    public func clearLog() {
        eventLog.removeAll()
    }
    
    /// Enable/disable telemetry
    public func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }
}

/// Represents a telemetry event
public struct TelemetryEvent: Sendable, Codable {
    public let name: String
    public let timestamp: Date
    public let metadata: [String: String]
    
    public init(name: String, timestamp: Date, metadata: [String: String]) {
        self.name = name
        self.timestamp = timestamp
        self.metadata = metadata
    }
}

