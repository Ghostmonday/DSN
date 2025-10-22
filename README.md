# DirectorStudio

**AI-Powered Cinematic Video Generation Engine**

[![Swift Version](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS-blue.svg)](https://developer.apple.com)
[![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen.svg)](https://github.com/Ghostmonday/DSN)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

---

**DirectorStudio** is a sophisticated, modular Swift-based engine designed for the programmatic generation of cinematic video content. It transforms raw text-based stories into detailed, production-ready video plans, complete with scene segmentation, cinematic taxonomy, and continuity analysis.

## ✨ Features

- **Modular Architecture**: A clean, scalable architecture built around a core `DirectorStudioKit` library.
- **AI-Powered Pipeline**: Leverages AI for advanced text analysis, scene interpretation, and creative rewording.
- **Cinematic Intelligence**: Enriches stories with cinematic metadata, including shot types, camera angles, and lighting cues.
- **Continuity Engine**: Ensures logical consistency across scenes, tracking characters, locations, and props.
- **Telemetry & Validation**: All modules are instrumented for telemetry and include built-in completion markers for robust validation.
- **Swift Package Manager**: Organized as a modern Swift Package for seamless integration with Xcode 15+.

## 🏗️ Architecture Overview

The repository is structured as a Swift Package with two primary targets:

- **`DirectorStudioKit`**: A comprehensive library containing all core modules, services, and data models. This is the heart of the engine.
- **`DirectorStudioApp`**: A lightweight SwiftUI application that depends on and demonstrates the functionality of `DirectorStudioKit`.

The `Modules/` directory contains the individual components of the pipeline:

| Module              | Description                                                                 |
| ------------------- | --------------------------------------------------------------------------- |
| **Core**            | Defines fundamental protocols, data models, and shared services.            |
| **DirectorStudioCore** | The central orchestrator that manages the pipeline and module execution. |
| **Segmentation**    | Breaks down long-form text into individual cinematic scenes.                |
| **Rewording**       | Uses AI to enhance and rewrite text with different stylistic tones.         |
| **StoryAnalysis**   | Performs deep analysis of narrative structure, characters, and themes.      |
| **Taxonomy**        | Enriches segments with a detailed cinematic taxonomy.                       |
| **Continuity**      | Validates and ensures continuity between scenes.                            |
| **VideoGeneration** | Generates video output based on the enriched scene data (conceptual).       |

## 🚀 Getting Started

### Prerequisites

- Xcode 15 or later
- macOS 13 or later

### Opening the Project

This project is a Swift Package, which can be opened directly in Xcode.

1.  Clone the repository:
    ```sh
    git clone https://github.com/Ghostmonday/DSN.git
    ```
2.  Navigate to the project's root directory:
    ```sh
    cd DSN/DirectorStudio
    ```
3.  Open the directory in Xcode:
    ```sh
    xed .
    ```

Xcode will automatically resolve the package dependencies and open the project. You can then select the `DirectorStudioApp` scheme and run it on a simulator or device.

## 🛠️ Development

### Building from the Command Line

You can build the project directly using Swift Package Manager:

```sh
swift build
```

### Running Tests

The repository includes a suite of unit tests to validate the functionality of the core modules.

```sh
swift test
```

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
