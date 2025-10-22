//
//  PipelineView.swift
//  DirectorStudioUI
//
//  Created by DirectorStudio on $(date)
//  Copyright © 2025 DirectorStudio. All rights reserved.
//

import SwiftUI
import DirectorStudio

/// Pipeline Orchestrator UI - Complete pipeline configuration and execution
struct PipelineView: View {
    @State private var storyInput: String = ""
    @State private var isProcessing: Bool = false
    @State private var currentModule: String = ""
    @State private var pipelineProgress: Double = 0.0
    @State private var estimatedTimeRemaining: String = ""
    @State private var liveResults: [String: Any] = [:]
    @State private var showResults: Bool = false
    @State private var errorMessage: String?
    @State private var moduleSettings: ModuleSettings = ModuleSettings()
    @State private var showAdvancedSettings: Bool = false
    
    // New state for pipeline completion and prompt display
    @State private var pipelineComplete: Bool = false
    @State private var finalPrompts: [DirectorStudio.PromptSegment] = []
    @StateObject private var videoSettings = VideoGenerationSettings()
    
    private let guiAbstraction = GUIAbstraction()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if pipelineComplete {
                    // Results View - Show generated prompts
                    resultsView
                } else if !isProcessing {
                    // Configuration View
                    configurationView
                } else {
                    // Processing View
                    processingView
                }
            }
            .navigationTitle("Pipeline Orchestrator")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if isProcessing {
                        Button("Cancel") {
                            cancelProcessing()
                        }
                        .foregroundColor(.red)
                    } else if pipelineComplete {
                        Button("Back") {
                            pipelineComplete = false
                            finalPrompts = []
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Configuration View
    
    private var configurationView: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Story Input
                storyInputSection
                
                // Module Configuration
                moduleConfigurationSection
                
                // Advanced Settings
                if showAdvancedSettings {
                    advancedSettingsSection
                }
                
                // Run Pipeline Button
                runPipelineButtonSection
                
                // Export Options
                exportOptionsSection
            }
            .padding()
        }
    }
    
    // MARK: - Processing View
    
    private var processingView: some View {
        VStack(spacing: 20) {
            // Progress Overview
            progressOverviewSection
            
            // Current Module
            currentModuleSection
            
            // Live Results Preview
            if !liveResults.isEmpty {
                liveResultsSection
            }
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Results View
    
    private var resultsView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Success Header
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                    
                    Text("Pipeline Complete!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Generated \(finalPrompts.count) prompts ready for video generation")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                // Results Summary
                VStack(alignment: .leading, spacing: 16) {
                    Text("Results Summary")
                        .font(.headline)
                    
                    ForEach(liveResults.keys.sorted(), id: \.self) { key in
                        if let value = liveResults[key] {
                            HStack {
                                Text(key)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Text(String(describing: value))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding()
                            .background(Color.systemGray6)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
                
                // Generated Prompts
                VStack(alignment: .leading, spacing: 16) {
                    Text("Generated Prompts")
                        .font(.headline)
                    
                    ForEach(finalPrompts, id: \.id) { prompt in
                        PromptCardView(
                            prompt: prompt,
                            videoSettings: videoSettings
                        )
                    }
                }
                .padding()
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: { 
                        pipelineComplete = false
                        finalPrompts = []
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Run Again")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Story-to-Video Pipeline")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Configure and run the complete pipeline to transform your story into a video")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Story Input Section
    
    private var storyInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Story Input")
                .font(.headline)
            
            TextEditor(text: $storyInput)
                .frame(minHeight: 200)
                .padding(8)
                .background(Color.systemGray6)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.systemGray4, lineWidth: 1)
                )
            
            if storyInput.isEmpty {
                Text("Enter your story here...")
                    .foregroundColor(.secondary)
                    .font(.caption)
            } else {
                Text("\(storyInput.count) characters")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
    }
    
    // MARK: - Module Configuration Section
    
    private var moduleConfigurationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Pipeline Configuration")
                    .font(.headline)
                
                Spacer()
                
                Button("Advanced") {
                    showAdvancedSettings.toggle()
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            VStack(spacing: 12) {
                // Segmentation Module
                ModuleToggleView(
                    title: "Story Segmentation",
                    description: "Break story into video segments",
                    isEnabled: $moduleSettings.segmentationEnabled
                )
                
                // Story Analysis Module
                ModuleToggleView(
                    title: "Story Analysis",
                    description: "Analyze narrative structure and themes",
                    isEnabled: $moduleSettings.storyAnalysisEnabled
                )
                
                // Rewording Module
                ModuleToggleView(
                    title: "Text Rewording",
                    description: "Transform text for video narration",
                    isEnabled: $moduleSettings.rewordingEnabled
                )
                
                // Taxonomy Module
                ModuleToggleView(
                    title: "Cinematic Enrichment",
                    description: "Add cinematic metadata and shot types",
                    isEnabled: $moduleSettings.taxonomyEnabled
                )
                
                // Continuity Module
                ModuleToggleView(
                    title: "Continuity Validation",
                    description: "Ensure visual and narrative continuity",
                    isEnabled: $moduleSettings.continuityEnabled
                )
                
            }
        }
        .padding()
        .background(Color.systemBackground)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.systemGray4, lineWidth: 1)
        )
    }
    
    // MARK: - Advanced Settings Section
    
    private var advancedSettingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Video Generation Settings")
                .font(.headline)
            
            VStack(spacing: 16) {
                // Duration slider
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Duration")
                            .font(.subheadline)
                        Spacer()
                        Text("\(videoSettings.duration)s")
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(value: Binding(
                        get: { Double(videoSettings.duration) },
                        set: { videoSettings.duration = Int($0) }
                    ), in: 3...20, step: 1) {
                        Text("Duration")
                    }
                    .tint(.purple)
                    
                    Text("POLLO supports 3-20 second videos")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Resolution picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Resolution")
                        .font(.subheadline)
                    
                    Picker("Resolution", selection: $videoSettings.resolution) {
                        ForEach(VideoGenerationSettings.VideoResolution.allCases, id: \.self) { res in
                            Text(res.displayName).tag(res)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Processing mode
                VStack(alignment: .leading, spacing: 8) {
                    Text("Processing Mode")
                        .font(.subheadline)
                    
                    Picker("Processing Mode", selection: $videoSettings.processingMode) {
                        ForEach(VideoGenerationSettings.ProcessingMode.allCases, id: \.self) { mode in
                            Text(mode.displayName).tag(mode)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Cost estimate
                HStack {
                    Text("Estimated Cost per Video")
                        .font(.subheadline)
                    Spacer()
                    Text("$\(videoSettings.calculateCost(), specifier: "%.2f")")
                        .foregroundColor(.orange)
                        .fontWeight(.medium)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("POLLO API Configuration")
                    .font(.headline)
                
                SecureField("API Key", text: $videoSettings.polloAPIKey)
                    .textContentType(.password)
                
                if !videoSettings.polloAPIKey.isEmpty {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("API Key Configured")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("Enter your Pollo.ai API key to enable video generation")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Link("Get API Key from Pollo.ai", 
                     destination: URL(string: "https://pollo.ai/dashboard/api-keys")!)
                    .font(.caption)
            }
        }
        .padding()
        .background(Color.systemGray6)
        .cornerRadius(8)
    }
    
    // MARK: - Run Pipeline Button Section
    
    private var runPipelineButtonSection: some View {
        VStack(spacing: 12) {
            Button(action: runPipeline) {
                HStack {
                    Image(systemName: "play.circle.fill")
                    Text("Run Pipeline")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(canRunPipeline ? Color.blue : Color.systemGray4)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(!canRunPipeline)
            
            if !canRunPipeline {
                Text("Please enter a story and enable at least one module")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // MARK: - Export Options Section
    
    private var exportOptionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Export Options")
                .font(.headline)
            
            HStack(spacing: 12) {
                Button(action: exportAsJSON) {
                    HStack {
                        Image(systemName: "doc.text")
                        Text("Export JSON")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.systemGray6)
                    .foregroundColor(.primary)
                    .cornerRadius(8)
                }
                
                Button(action: exportAsPDF) {
                    HStack {
                        Image(systemName: "doc.richtext")
                        Text("Export PDF")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.systemGray6)
                    .foregroundColor(.primary)
                    .cornerRadius(8)
                }
            }
        }
    }
    
    // MARK: - Progress Overview Section
    
    private var progressOverviewSection: some View {
        VStack(spacing: 16) {
            Text("Pipeline Progress")
                .font(.title2)
                .fontWeight(.semibold)
            
            // Overall Progress Bar
            VStack(spacing: 8) {
                ProgressView(value: pipelineProgress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .scaleEffect(1.2, anchor: .center)
                
                Text("\(Int(pipelineProgress * 100))% Complete")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            
            // Estimated Time
            if !estimatedTimeRemaining.isEmpty {
                Text("Estimated time remaining: \(estimatedTimeRemaining)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.systemGray6)
        .cornerRadius(8)
    }
    
    // MARK: - Current Module Section
    
    private var currentModuleSection: some View {
        VStack(spacing: 12) {
            Text("Current Module")
                .font(.headline)
            
            if !currentModule.isEmpty {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    
                    Text(currentModule)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                }
                .padding()
                .background(Color.systemBackground)
                .cornerRadius(8)
            }
        }
    }
    
    // MARK: - Live Results Section
    
    private var liveResultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Live Results")
                .font(.headline)
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(liveResults.keys.sorted(), id: \.self) { key in
                        if let value = liveResults[key] {
                            HStack {
                                Text(key)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Text(String(describing: value))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color.systemGray6)
                            .cornerRadius(6)
                        }
                    }
                }
            }
            .frame(maxHeight: 200)
        }
    }
    
    // MARK: - Computed Properties
    
    private var canRunPipeline: Bool {
        !storyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (moduleSettings.segmentationEnabled ||
         moduleSettings.storyAnalysisEnabled ||
         moduleSettings.rewordingEnabled ||
         moduleSettings.taxonomyEnabled ||
         moduleSettings.continuityEnabled)
    }
    
    // MARK: - Actions
    
    private func runPipeline() {
        guard canRunPipeline else { return }
        
        isProcessing = true
        errorMessage = nil
        pipelineProgress = 0.0
        currentModule = ""
        liveResults = [:]
        pipelineComplete = false
        finalPrompts = []
        
        Task {
            do {
                var currentSegments: [DirectorStudio.GUISegment] = []
                var storyAnalysis: DirectorStudio.StoryAnalysis?
                var continuityIssues: [DirectorStudio.ContinuityIssue] = []
                
                // Step 1: Story Segmentation
                if moduleSettings.segmentationEnabled {
                    await MainActor.run {
                        currentModule = "Story Segmentation"
                        pipelineProgress = 0.1
                    }
                    
                    currentSegments = try await guiAbstraction.segmentStory(story: storyInput)
                    
                    await MainActor.run {
                        liveResults["Story Segmentation"] = "Generated \(currentSegments.count) segments"
                    }
                }
                
                // Step 2: Story Analysis
                if moduleSettings.storyAnalysisEnabled {
                    await MainActor.run {
                        currentModule = "Story Analysis"
                        pipelineProgress = 0.3
                    }
                    
                    storyAnalysis = try await guiAbstraction.analyzeStory(story: storyInput)
                    
                    await MainActor.run {
                        liveResults["Story Analysis"] = "Genre: \(storyAnalysis?.genre ?? "Unknown"), Target: \(storyAnalysis?.targetAudience ?? "Unknown")"
                    }
                }
                
                // Step 3: Text Rewording (if segments exist)
                if moduleSettings.rewordingEnabled && !currentSegments.isEmpty {
                    await MainActor.run {
                        currentModule = "Text Rewording"
                        pipelineProgress = 0.5
                    }
                    
                    // Reword each segment
                    for (index, segment) in currentSegments.enumerated() {
                        let rewordedSegment = try await guiAbstraction.rewordSegment(
                            id: segment.id,
                            style: .modernizeOldEnglish
                        )
                        currentSegments[index] = rewordedSegment
                    }
                    
                    await MainActor.run {
                        liveResults["Text Rewording"] = "Reworded \(currentSegments.count) segments"
                    }
                }
                
                // Step 4: Cinematic Enrichment
                if moduleSettings.taxonomyEnabled && !currentSegments.isEmpty {
                    await MainActor.run {
                        currentModule = "Cinematic Enrichment"
                        pipelineProgress = 0.7
                    }
                    
                    currentSegments = try await guiAbstraction.enrichSegmentsWithTaxonomy()
                    
                    await MainActor.run {
                        liveResults["Cinematic Enrichment"] = "Enhanced \(currentSegments.count) segments with cinematic tags"
                    }
                }
                
                // Step 5: Continuity Validation
                if moduleSettings.continuityEnabled && !currentSegments.isEmpty {
                    await MainActor.run {
                        currentModule = "Continuity Validation"
                        pipelineProgress = 0.9
                    }
                    
                    continuityIssues = try await guiAbstraction.validateContinuity()
                    
                    await MainActor.run {
                        liveResults["Continuity Validation"] = "Found \(continuityIssues.count) continuity issues"
                    }
                }
                
                // Pipeline Complete - Stop at prompt generation
                await MainActor.run {
                    pipelineProgress = 1.0
                    currentModule = "Pipeline Complete"
                    isProcessing = false
                    pipelineComplete = true
                    
                    // Convert GUISegments to PromptSegments for display
                    finalPrompts = currentSegments.map { guiSegment in
                        DirectorStudio.PromptSegment(
                            index: guiSegment.index,
                            duration: guiSegment.duration,
                            content: guiSegment.content,
                            characters: guiSegment.characters,
                            setting: guiSegment.setting,
                            action: guiSegment.action,
                            continuityNotes: "",
                            location: "",
                            props: [],
                            tone: ""
                        )
                    }
                    
                    // Add final summary
                    liveResults["Pipeline Summary"] = "Successfully processed \(getEnabledModules().count) modules"
                    if let analysis = storyAnalysis {
                        liveResults["Final Analysis"] = "Genre: \(analysis.genre), Target: \(analysis.targetAudience)"
                    }
                }
                
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isProcessing = false
                    liveResults["Error"] = error.localizedDescription
                }
            }
        }
    }
    
    private func cancelProcessing() {
        isProcessing = false
        pipelineProgress = 0.0
        currentModule = ""
        liveResults = [:]
    }
    
    private func getEnabledModules() -> [String] {
        var modules: [String] = []
        
        if moduleSettings.segmentationEnabled { modules.append("Story Segmentation") }
        if moduleSettings.storyAnalysisEnabled { modules.append("Story Analysis") }
        if moduleSettings.rewordingEnabled { modules.append("Text Rewording") }
        if moduleSettings.taxonomyEnabled { modules.append("Cinematic Enrichment") }
        if moduleSettings.continuityEnabled { modules.append("Continuity Validation") }
        
        return modules
    }
    
    private func exportAsJSON() {
        // Export pipeline results as JSON
        let exportData: [String: Any] = [
            "story": storyInput,
            "settings": [
                "targetDuration": moduleSettings.targetDuration
            ],
            "results": liveResults,
            "prompts": finalPrompts.map { prompt in
                [
                    "index": prompt.index,
                    "duration": prompt.duration,
                    "content": prompt.content,
                    "characters": prompt.characters,
                    "setting": prompt.setting,
                    "action": prompt.action
                ]
            }
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            #if os(iOS)
            UIPasteboard.general.string = jsonString
            #endif
        }
    }
    
    private func exportAsPDF() {
        // Export pipeline results as PDF (placeholder)
        print("Export as PDF functionality would be implemented here")
    }
}

/// Module Toggle View
struct ModuleToggleView: View {
    let title: String
    let description: String
    @Binding var isEnabled: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}

/// Module Settings
struct ModuleSettings {
    // Module toggles (stopping at prompt generation - NO VIDEO GENERATION)
    var segmentationEnabled: Bool = true
    var storyAnalysisEnabled: Bool = true
    var rewordingEnabled: Bool = false
    var taxonomyEnabled: Bool = true
    var continuityEnabled: Bool = true
    
    // Basic pipeline settings only
    var targetDuration: Double = 120.0
}

/// Preview
struct PipelineView_Previews: PreviewProvider {
    static var previews: some View {
        PipelineView()
    }
}
