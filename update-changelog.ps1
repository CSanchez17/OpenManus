# Accept commit message as parameter
param(
    [Parameter(Mandatory=$false)]
    [string]$CommitMessage = ""
)

# Function to validate commit message format
function Test-CommitMessage {
    param([string]$Message)
    return $Message -match '^(added|changed|fixed|removed):'
}

# Function to update changelog
function Update-Changelog {
    param([string]$CommitMessage)

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
            Write-Host "❌ Could not find [Unreleased] section in CHANGELOG.md" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "❌ Invalid commit message format" -ForegroundColor Red
        return $false
    }
}

try {
    # If no commit message provided, ask for one
    if ([string]::IsNullOrEmpty($CommitMessage)) {
        do {
            $CommitMessage = Read-Host "Enter your commit message (e.g., 'added/changed/fixed/removed: description')"
            if (-not (Test-CommitMessage $CommitMessage)) {
                Write-Host "Commit message must start with one of: added:, changed:, fixed:, removed:" -ForegroundColor Yellow
            }
        } while (-not (Test-CommitMessage $CommitMessage))
    }

    # Get staged files
    $stagedChanges = git diff --cached --name-only

    if (-not $stagedChanges) {
        # If nothing is staged, stage all changes
        Write-Host "📝 No staged changes found. Staging all changes..." -ForegroundColor Yellow
        git add .
    }

    # Update the changelog
    if (Update-Changelog $CommitMessage) {
        # Stage the CHANGELOG.md
        git add CHANGELOG.md

        # Commit all changes
        git commit -m $CommitMessage
        Write-Host "✅ Changes committed successfully!" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "❌ Failed to update changelog." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ An error occurred: $_" -ForegroundColor Red
    exit 1
}
