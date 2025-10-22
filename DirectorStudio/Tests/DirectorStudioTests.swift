//
//  DirectorStudioTests.swift
//  DirectorStudioTests
//
//  Test suite for DirectorStudio modules
//

import XCTest
@testable import DirectorStudio

final class DirectorStudioTests: XCTestCase {
    
    var core: DirectorStudioCore!
    
    override func setUp() {
        super.setUp()
        core = DirectorStudioCore.shared
    }
    
    override func tearDown() {
        core = nil
        super.tearDown()
    }
    
    // MARK: - Core Tests
    
    func testCoreInitialization() {
        XCTAssertNotNil(core, "Core should be initialized")
        XCTAssertTrue(core.isComplete, "Core should be complete")
    }
    
    func testCoreModulesExist() {
        XCTAssertNotNil(core.segmentationModule, "Segmentation module should exist")
        XCTAssertNotNil(core.rewordingModule, "Rewording module should exist")
        XCTAssertNotNil(core.storyAnalysisModule, "Story analysis module should exist")
        XCTAssertNotNil(core.taxonomyModule, "Taxonomy module should exist")
        XCTAssertNotNil(core.continuityModule, "Continuity module should exist")
        XCTAssertNotNil(core.videoGenerationModule, "Video generation module should exist")
    }
    
    // MARK: - Module Completion Tests
    
    func testSegmentationModuleCompletion() {
        XCTAssertTrue(core.segmentationModule.isComplete, "Segmentation module should be complete")
    }
    
    func testRewordingModuleCompletion() {
        XCTAssertTrue(core.rewordingModule.isComplete, "Rewording module should be complete")
    }
    
    func testStoryAnalysisModuleCompletion() {
        XCTAssertTrue(core.storyAnalysisModule.isComplete, "Story analysis module should be complete")
    }
    
    // MARK: - Telemetry Tests
    
    func testTelemetryExists() {
        let telemetry = Telemetry.shared
        XCTAssertNotNil(telemetry, "Telemetry should exist")
    }
    
    // MARK: - Integration Tests
    
    func testProjectCreation() throws {
        let project = try core.createProject(name: "Test Project", description: "Test")
        XCTAssertNotNil(project, "Project should be created")
        XCTAssertEqual(project.name, "Test Project", "Project name should match")
    }
}

