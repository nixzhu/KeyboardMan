import ProjectDescription

let tuist = Tuist(
    project: .tuist(
        compatibleXcodeVersions: [
            .upToNextMajor("16.0"),
            .upToNextMajor("26.0"),
        ],
        swiftVersion: "6.0",
        generationOptions: .options(
            resolveDependenciesWithSystemScm: true,
            disablePackageVersionLocking: true
        )
    )
)
