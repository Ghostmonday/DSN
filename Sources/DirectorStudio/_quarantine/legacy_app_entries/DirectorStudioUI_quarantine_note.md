# Quarantine Note: DirectorStudioUI/DirectorStudioUI.swift

**Date**: 2025-01-20
**Reason**: Duplicate @main entrypoint - canonical app entry is DirectorStudioApp/DirectorStudioAppApp.swift
**Original Path**: Sources/DirectorStudioUI/DirectorStudioUI.swift
**Quarantine Action**: Move entire Sources/DirectorStudioUI/ directory to quarantine

## Original Purpose
- Contains duplicate @main struct DirectorStudioApp
- Contains SwiftUI view implementations that should be in main app

## Rollback Instructions
```bash
cp -r Sources/DirectorStudio/_quarantine/DirectorStudioUI Sources/
```

## Retention Window
14 days - review for extraction of view implementations into main app

