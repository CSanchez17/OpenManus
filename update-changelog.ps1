# Accept commit message as parameter
param(
    [Parameter(Mandatory=$false)]
    [string]$CommitMessage = ""
)

# Check if this is a recursive execution
$isRecursiveExecution = $env:CHANGELOG_SCRIPT_RUNNING -eq "1"
if ($isRecursiveExecution) {
    Write-Host "[DEBUG] Detected recursive execution, exiting..." -ForegroundColor Gray
    exit 0
}

# Set environment variable to prevent recursive execution
$env:CHANGELOG_SCRIPT_RUNNING = "1"

# Function to validate commit message format
function Test-CommitMessage {
    param([string]$Message)
    Write-Host "[DEBUG] Testing commit message: '$Message'" -ForegroundColor Gray
    $isValid = $Message -match '^(added|changed|fixed|removed):'
    Write-Host "[DEBUG] Message validation result: $isValid" -ForegroundColor Gray
    return $isValid
}

# Function to update changelog
function Update-Changelog {
    param([string]$CommitMessage)

    Write-Host "[DEBUG] Attempting to update changelog with message: '$CommitMessage'" -ForegroundColor Gray

    if ($CommitMessage -match '^(added|changed|fixed|removed):(.+)$') {
        $commitType = $matches[1]
        $description = $matches[2].Trim()

        # Read the CHANGELOG.md file
        $changelogPath = "CHANGELOG.md"
        $changelogContent = Get-Content $changelogPath

        # Find the [Unreleased] section
        $unreleasedIndex = $changelogContent.IndexOf("## [Unreleased]")
        if ($unreleasedIndex -ge 0) {
            # Map commit types to changelog sections
            $sectionMap = @{
                'added' = '### Added'
                'changed' = '### Changed'
                'fixed' = '### Fixed'
                'removed' = '### Removed'
            }

            # Get the appropriate section
            $section = $sectionMap[$commitType]

            # Find the section
            $sectionContent = $changelogContent[$unreleasedIndex..$changelogContent.Length]
            $sectionIndex = $sectionContent.IndexOf($section)

            if ($sectionIndex -ge 0) {
                $sectionIndex += $unreleasedIndex
            } else {
                # Section doesn't exist, create all sections after [Unreleased]
                $newSections = @(
                    "### Added",
                    "### Changed",
                    "### Fixed",
                    "### Removed"
                )

                # Insert new sections after [Unreleased]
                $updatedContent = $changelogContent[0..$unreleasedIndex] +
                                "" +  # Empty line after [Unreleased]
                                $newSections +
                                $changelogContent[($unreleasedIndex + 1)..$changelogContent.Length]

                # Update content and recalculate section index
                $changelogContent = $updatedContent
                $sectionContent = $changelogContent[$unreleasedIndex..$changelogContent.Length]
                $sectionIndex = $sectionContent.IndexOf($section) + $unreleasedIndex
            }

            # Create the new changelog entry
            $newEntry = "- $description"

            # Insert the new entry after the section header
            $updatedContent = $changelogContent[0..$sectionIndex] +
                            $newEntry +
                            $changelogContent[($sectionIndex + 1)..$changelogContent.Length]

            # Write back to the file
            $updatedContent | Set-Content $changelogPath

            return $true
        } else {
            Write-Host "[ERROR] Could not find [Unreleased] section in CHANGELOG.md" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "[ERROR] Invalid commit message format" -ForegroundColor Red
        return $false
    }
}

try {
    Write-Host "[DEBUG] Starting script execution" -ForegroundColor Gray
    Write-Host "[DEBUG] Initial commit message: '$CommitMessage'" -ForegroundColor Gray

    # If no commit message provided, ask for one
    if ([string]::IsNullOrEmpty($CommitMessage)) {
        Write-Host "[DEBUG] No commit message provided, entering prompt loop" -ForegroundColor Gray
        do {
            $CommitMessage = Read-Host "Enter your commit message (e.g., 'added/changed/fixed/removed: description')"
            Write-Host "[DEBUG] User entered: '$CommitMessage'" -ForegroundColor Gray

            if (-not (Test-CommitMessage $CommitMessage)) {
                Write-Host "[WARNING] Commit message must start with one of: added:, changed:, fixed:, removed:" -ForegroundColor Yellow
            }
        } while (-not (Test-CommitMessage $CommitMessage))
        Write-Host "[DEBUG] Valid commit message received: '$CommitMessage'" -ForegroundColor Gray
    }

    # Get staged files
    Write-Host "[DEBUG] Checking for staged changes" -ForegroundColor Gray
    $stagedChanges = git diff --cached --name-only

    if (-not $stagedChanges) {
        # If nothing is staged, stage all changes
        Write-Host "[INFO] No staged changes found. Staging all changes..." -ForegroundColor Yellow
        git add .
    }

    # Update the changelog
    if (Update-Changelog $CommitMessage) {
        # Stage the CHANGELOG.md
        git add CHANGELOG.md

        # Commit all changes with --no-verify to bypass hooks
        git commit --no-verify -m $CommitMessage
        Write-Host "[SUCCESS] Changes committed successfully!" -ForegroundColor Green

        # Clear the environment variable
        $env:CHANGELOG_SCRIPT_RUNNING = $null
        exit 0
    } else {
        Write-Host "[ERROR] Failed to update changelog." -ForegroundColor Red
        # Clear the environment variable
        $env:CHANGELOG_SCRIPT_RUNNING = $null
        exit 1
    }
} catch {
    Write-Host "[ERROR] An error occurred: $_" -ForegroundColor Red
    # Clear the environment variable
    $env:CHANGELOG_SCRIPT_RUNNING = $null
    exit 1
}
