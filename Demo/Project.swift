import ProjectDescription

enum Meta {
    static let appName = "KeyboardManDemo"
    static let developmentTeam = Environment.developmentTeam?.string
    static let organizationName = "nixzhu"
    static let destinations: Destinations = [.iPhone, .iPad]
    static let deploymentTargets: DeploymentTargets = .iOS("13.0")
    static let swiftVersion = "6.0"
    static let appCategory = "public.app-category.developer-tools"
    static let appVersion = Environment.appVersion?.string ?? "1.0.0"
    static let buildNumber = Environment.buildNumber?.string ?? "1"

    static var appBundleID: String {
        "demo.nixzhu.\(appName)"
    }

    static func appExtensionBundleID(name: String) -> String {
        "\(appBundleID).\(name)"
    }

    static func projectBaseSettingsDictionary() -> SettingsDictionary {
        var settingsDictionary = SettingsDictionary()
            .swiftVersion(swiftVersion)
            .enableUserScriptSandboxing(true)
            .swiftEmitLocStrings(true)
            .assetCatalogCompilerGenerateAssetSymbols(true)
            .assetCatalogCompilerGenerateSwiftAssetSymbolExtensions(false)

        if let developmentTeam {
            settingsDictionary = settingsDictionary.automaticCodeSigning(
                devTeam: developmentTeam
            )
        }

        return settingsDictionary
    }

    static func appBaseSettingsDictionary() -> SettingsDictionary {
        appExtensionBaseSettingsDictionary()
            .appCategory(appCategory)
    }

    static func appExtensionBaseSettingsDictionary() -> SettingsDictionary {
        SettingsDictionary()
            .marketingVersion(appVersion)
            .currentProjectVersion(buildNumber)
    }
}

let project = Project(
    name: Meta.appName,
    organizationName: Meta.organizationName,
    options: .options(
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
    ),
    packages: [
        .package(path: ".."),
    ],
    settings: .settings(
        base: Meta.projectBaseSettingsDictionary(),
        defaultSettings: .recommended
    ),
    targets: [
        .target(
            name: Meta.appName,
            destinations: Meta.destinations,
            product: .app,
            // swiftformat:disable acronyms
            bundleId: Meta.appBundleID,
            // swiftformat:enable acronyms
            deploymentTargets: Meta.deploymentTargets,
            infoPlist: .extendingDefault(with: [
                "LSApplicationCategoryType": .string(Meta.appCategory),
                "CFBundleShortVersionString": .string(Meta.appVersion),
                "CFBundleVersion": .string(Meta.buildNumber),
                "ITSAppUsesNonExemptEncryption": false,
                "UILaunchScreen": [:],
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": false,
                    "UISceneConfigurations": [
                        "UIWindowSceneSessionRoleApplication": [
                            [
                                "UISceneConfigurationName": "DefaultConfiguration",
                                "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                            ],
                        ],
                    ],
                ],
            ]),
            sources: [
                "Targets/App/Sources/**",
            ],
            resources: [
                "Targets/App/Resources/**",
            ],
            dependencies: [
//                .target(name: "KeyboardMan"),
                .package(product: "KeyboardMan"),
            ],
            settings: .settings(
                base: Meta.appBaseSettingsDictionary(),
                debug: SettingsDictionary()
                    .swiftCompilationMode(.singlefile)
                    .swiftOptimizationLevel(.oNone),
                release: SettingsDictionary()
                    .swiftCompilationMode(.wholemodule)
                    .swiftOptimizationLevel(.o),
                defaultSettings: .recommended
            )
        ),
//        .target(
//            name: "KeyboardMan",
//            destinations: Meta.destinations,
//            product: .framework,
//            // swiftformat:disable acronyms
//            bundleId: Meta.appExtensionBundleID(name: "KeyboardMan"),
//            // swiftformat:enable acronyms
//            deploymentTargets: Meta.deploymentTargets,
//            infoPlist: .extendingDefault(with: [
//                "CFBundleShortVersionString": .string(Meta.appVersion),
//                "CFBundleVersion": .string(Meta.buildNumber),
//            ]),
//            sources: [
//                "../Sources/KeyboardMan/**",
//            ],
//            settings: .settings(
//                base: Meta.appExtensionBaseSettingsDictionary(),
//                debug: SettingsDictionary()
//                    .swiftCompilationMode(.singlefile)
//                    .swiftOptimizationLevel(.oNone),
//                release: SettingsDictionary()
//                    .swiftCompilationMode(.wholemodule)
//                    .swiftOptimizationLevel(.o),
//                defaultSettings: .recommended
//            )
//        ),
    ]
)

extension Environment.Value {
    fileprivate var string: String? {
        if case .string(let value) = self {
            value.isEmpty ? nil : value
        } else {
            nil
        }
    }
}

extension SettingsDictionary {
    fileprivate func enableUserScriptSandboxing(
        _ value: Bool
    ) -> SettingsDictionary {
        var info = self
        info["ENABLE_USER_SCRIPT_SANDBOXING"] = .init(booleanLiteral: value)
        return info
    }

    fileprivate func swiftEmitLocStrings(_ value: Bool) -> SettingsDictionary {
        var info = self
        info["SWIFT_EMIT_LOC_STRINGS"] = .init(booleanLiteral: value)
        return info
    }

    /// https://developer.apple.com/documentation/bundleresources/information-property-list/lsapplicationcategorytype
    fileprivate func appCategory(_ value: String) -> SettingsDictionary {
        var info = self
        info["INFOPLIST_KEY_LSApplicationCategoryType"] = .string(value)
        return info
    }

    fileprivate func assetCatalogCompilerGenerateAssetSymbols(
        _ value: Bool
    ) -> SettingsDictionary {
        var info = self
        info["ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS"] = .init(booleanLiteral: value)
        return info
    }

    fileprivate func assetCatalogCompilerGenerateSwiftAssetSymbolExtensions(
        _ value: Bool
    ) -> SettingsDictionary {
        var info = self
        info["ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS"] = .init(
            booleanLiteral: value
        )
        return info
    }
}
