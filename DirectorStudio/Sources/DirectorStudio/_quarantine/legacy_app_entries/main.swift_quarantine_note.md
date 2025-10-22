# Quarantine Note: Sources/DirectorStudioCLI/main.swift

**Date**: 2025-01-20
**Reason**: CLI-only entrypoint - not needed for App Store iOS app
**Original Path**: Sources/DirectorStudioCLI/main.swift
**Quarantine Action**: Move entire Sources/DirectorStudioCLI/ directory to quarantine

## Original Purpose
- CLI command-line interface for DirectorStudio
- Uses ArgumentParser for command processing
- Testing and health check functionality

## Rollback Instructions
```bash
cp -r Sources/DirectorStudio/_quarantine/DirectorStudioCLI Sources/
```

## Retention Window
30 days - CLI may be useful for development/debugging

