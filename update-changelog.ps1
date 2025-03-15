# Get the staged files and their content
$stagedChanges = git diff --cached --name-only

# If there are staged changes
if ($stagedChanges) {
    # Get the commit message from the user
    $commitMessage = Read-Host "Enter your commit message (e.g., 'feat: add new feature' or 'fix: resolve issue')"

    # Check if it's a feat or fix commit
    if ($commitMessage -match '^(feat|fix):') {
        $commitType = $matches[1]

        # Read the CHANGELOG.md file
        $changelogPath = "CHANGELOG.md"
        $changelogContent = Get-Content $changelogPath

        # Find the [Unreleased] section
        $unreleasedIndex = $changelogContent.IndexOf("## [Unreleased]")
        if ($unreleasedIndex -ge 0) {
            # Determine the appropriate section based on commit type
            $section = if ($commitType -eq "feat") { "### Added" } else { "### Fixed" }

            # Find the section
            $sectionContent = $changelogContent[$unreleasedIndex..$changelogContent.Length]
            $sectionIndex = $sectionContent.IndexOf($section)

            if ($sectionIndex -ge 0) {
                $sectionIndex += $unreleasedIndex
            } else {
                # Section doesn't exist, create it after [Unreleased]
                $newSections = @()
                if ($commitType -eq "feat") {
                    $newSections = @("### Added", "### Changed", "### Fixed")
                } else {
                    $newSections = @("### Fixed", "### Added", "### Changed")
                }

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
            $newEntry = "- $commitMessage"

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
        Write-Host "Commit message should start with 'feat:' or 'fix:'"
    }
}
else {
    Write-Host "No staged changes found. Stage your changes first with 'git add'"
}
