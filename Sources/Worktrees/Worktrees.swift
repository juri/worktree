import ArgumentParser
import Foundation

@main
struct Worktrees: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Git Worktrees helper",
        subcommands: [AddNewBranch.self]
    )
}

extension Worktrees {
    struct AddNewBranch: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Create a new worktree with a new branch",
            discussion: """
                Creates a new worktree, pointing at a new branch, starting from committish.

                You specify three arguments:

                - A prefix that's applied to the worktree name to form the branch name
                - The commit to branch off from
                - The worktree name

                The order of the arguments is designed for easy usage with git aliases.
                Example:

                [alias]
                    wta = !worktree add-new-branch username main

                Now running `git wta feature` will create brach `username/feature` starting from
                `main`, tracked in worktree `feature`.
            """
        )

        @Argument(help: "Branch prefix")
        var prefix: String

        @Argument(help: "Committish")
        var committish: String

        @Argument(help: "Folder name")
        var folder: String

        @Flag(help: "Don't strip duplicated prefix")
        var allowDuplicatePrefix: Bool = false

        mutating func run() throws {
            guard let git = try path(executable: "git") else {
                throw ValidationError("git not found in PATH")
            }
            if !self.allowDuplicatePrefix {
                if self.folder.hasPrefix(self.prefix) {
                    self.folder.removeFirst(self.prefix.count)
                }
            }
            let task = try Process.run(
                git,
                arguments: ["worktree", "add", "-b", "\(self.prefix)\(self.folder)", self.folder, self.committish]
            )
            task.waitUntilExit()
        }
    }
}

func path(executable: String) throws -> URL? {
    guard let path = ProcessInfo.processInfo.environment["PATH"] else { return nil }
    for folder in path.split(separator: ":") {
        let candidateURL = URL(filePath: "\(folder)/\(executable)", directoryHint: .notDirectory)
        if try candidateURL.checkResourceIsReachable() {
            return candidateURL
        }
    }
    return nil
}
