# Get the staged files and their content
$stagedChanges = git diff --cached --name-only

# If there are staged changes
if ($stagedChanges) {
    # Get the commit message from the user
    $commitMessage = Read-Host "Enter your commit message (e.g., 'added/changed/fixed/removed: description')"

    # Check if it's a valid commit type
    if ($commitMessage -match '^(added|changed|fixed|removed):(.+)$') {
        $commitType = $matches[1]
        $description = $matches[2].Trim()  # Get the description part and trim whitespace

        # Read the CHANGELOG.md file
        $changelogPath = "CHANGELOG.md"
        $changelogContent = Get-Content $changelogPath

        # Find the [Unreleased] section
        $unreleasedIndex = $changelogContent.IndexOf("## [Unreleased]")
        if ($unreleasedIndex -ge 0) {
            # Map commit types to changelog sections (now they match exactly)
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

            # Create the new changelog entry (using only the description part)
            $newEntry = "- $description"

            # Insert the new entry after the section header
            $updatedContent = $changelogContent[0..$sectionIndex] +
                            $newEntry +
                            $changelogContent[($sectionIndex + 1)..$changelogContent.Length]

            # Write back to the file
            $updatedContent | Set-Content $changelogPath

            # Stage the CHANGELOG.md
            git add $changelogPath

            # Commit the changes
            git commit -m $commitMessage

            Write-Host "Changelog updated and changes committed!"
        }
        else {
            Write-Host "Could not find [Unreleased] section in CHANGELOG.md"
        }
    }
    else {
        Write-Host "Commit message should start with one of: added:, changed:, fixed:, removed:"
    }
}
else {
    Write-Host "No staged changes found. Stage your changes first with 'git add'"
}
