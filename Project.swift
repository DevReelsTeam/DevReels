import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project Factory
protocol ProjectFactory {
    var projectName: String { get }
    var dependencies: [TargetDependency] { get }
    
    func generateTarget() -> [Target]
    func generateConfigurations() -> Settings
}

// MARK: - Base Project Factory
class BaseProjectFactory: ProjectFactory {
    let projectName: String = "DevReels"
    
    let deploymentTarget: ProjectDescription.DeploymentTarget = .iOS(targetVersion: "14.0", devices: [.iphone])
    
    let dependencies: [TargetDependency] = [
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "RxKeyboard"),
        .external(name: "SnapKit"),
        .external(name: "Then"),
        .external(name: "FirebaseAuth"),
        .external(name: "FirebaseDatabase"),
        .external(name: "FirebaseFirestore"),
        .external(name: "FirebaseStorage"),
        .external(name: "FirebaseMessaging"),
        .external(name: "Swinject")
//        .target(name: "내부모듈")    // 모듈만들경우 사용
    ]
    
    let infoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "1.0.1",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
    ]
    
    let baseSettings: [String: SettingValue] = [
        :
    ]
    
    let releaseSetting: [String: SettingValue] = [:]
    
    let debugSetting: [String: SettingValue] = [:]
    
    func generateConfigurations() -> Settings {
        return Settings.settings(
            base: baseSettings,
            configurations: [
              .release(
                name: "Release",
                settings: releaseSetting
              ),
              .debug(
                name: "Debug",
                settings: debugSetting
              )
            ],
            defaultSettings: .recommended
          )
    }
    
    func generateTarget() -> [Target] {
        [
            Target(
                name: projectName,
                platform: .iOS,
                product: .app,
                bundleId: "com.team.\(projectName)",
                deploymentTarget: deploymentTarget,
                infoPlist: .extendingDefault(with: infoPlist),
                sources: ["\(projectName)/Sources/**"],
                resources: "\(projectName)/Resources/**",
                entitlements: "\(projectName).entitlements",
                scripts: [.pre(path: "Scripts/SwiftLintRunScript.sh", arguments: [], name: "SwiftLint")],
                dependencies: dependencies
            )
//            Target(
//                name: "내부모듈이름",
//                platform: .iOS,
//                product: .framework,
//                bundleId: "com.team.\(projectName).내부모듈이름",
//                deploymentTarget: deploymentTarget,
//                sources: ["내부모듈이름/Sources/**"]
//                ,
//                dependencies: [
//                    .external(name: "SnapKit")
//                ]
//            )
        ]
    }
}

// MARK: - Project
let factory = BaseProjectFactory()

let project: Project = .init(
    name: factory.projectName,
    organizationName: factory.projectName,
    settings: factory.generateConfigurations(),
    targets: factory.generateTarget()
)

