import DependencyPlugin
import EnvironmentPlugin
import ProjectDescription
import ConfigurationPlugin
import TemplatePlugin

// MARK: - Project

extension Target {
    static let projectTarget: Target = .target(
        name: env.name,
        destinations: [.iPhone],
        product: .app,
        productName: env.name,
        bundleId: env.bundleID,
        deploymentTargets: env.deploymentTargets,
        infoPlist: .projectDefault,
        sources: .sources,
        resources: .resources,
        entitlements: .dictionary(
            ["com.apple.security.application-groups": .array([.string("group.kr.codesquad.boostcamp9.Shook")])]
        ),
        scripts: generationEnvironment.scripts,
        dependencies: [
            .domain(target: .LiveStationDomain),
            .feature(target: .MainFeature),
            .feature(target: .LiveStreamFeature),
            .target(name: "BroadcastExtension")
        ],
        settings: .settings(base: .makeProjectSetting(), configurations: generationEnvironment.configurations, defaultSettings: .recommended),
        environmentVariables: [:] // 환경변수 설정
    )
    
    static let projectTestTarget: Target = .target(
        name: "\(env.name)Tests",
        destinations: [.iPhone],
        product: .unitTests,
        bundleId: "\(env.bundleID)Tests",
        deploymentTargets: env.deploymentTargets,
        infoPlist: .default,
        sources: .unitTests,
        dependencies: [
            .target(name: env.name)
        ]
    )
    
    public static let broadcastExtension: Target = .target(
        name: "BroadcastExtension",
        destinations: [.iPhone],
        product: .appExtension,
        bundleId: env.bundleID + ".BroadcastUploadExtension",
        deploymentTargets: env.deploymentTargets,
        infoPlist: .extendingDefault(with: [
            "CFBundleDisplayName": "$(PRODUCT_NAME)",
            "NSExtension" : [
                "NSExtensionPointIdentifier": "com.apple.broadcast-services-upload",
                "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).SampleHandler",
                "RPBroadcastProcessMode": "RPBroadcastProcessModeSampleBuffer"
            ]
        ]),
        sources: "BroadcastUploadExtension/Sources/**",
        entitlements: .dictionary(
            ["com.apple.security.application-groups": .array([.string("group.kr.codesquad.boostcamp9.Shook")])]
        ),
        dependencies: [
            .sdk(name: "ReplayKit", type: .framework, status: .required),
            .SPM.HaishinKit,
        ]
    )
}


// MARK: - Interface
public extension Target {
    static func interface(module: ModulePaths, spec: TargetSpec) -> Target {
        spec.with {
            $0.sources = .interface
        }
        .toTarget(with: module.targetName(type: .interface), product: .framework)
    }
    
    static func interface(module: ModulePaths, dependencies: [TargetDependency] = []) -> Target {
        TargetSpec(sources: .interface, dependencies: dependencies)
            .toTarget(with: module.targetName(type: .interface), product: .framework)
    }
    
    static func interface(name: String, spec: TargetSpec) -> Target {
        spec.with {
            $0.sources = .interface
        }
        .toTarget(with: "\(name)Interface", product: .framework)
    }
    
    static func interface(name: String, dependencies: [TargetDependency] = []) -> Target {
        TargetSpec(sources: .interface, dependencies: dependencies)
            .toTarget(with: "\(name)Interface", product: .framework)
    }
}

// MARK: - Implements
public extension Target {
    static func implements(
        module: ModulePaths,
        product: Product = .staticLibrary,
        spec: TargetSpec
    ) -> Target {
        spec.with {
            $0.sources = .sources
        }
        .toTarget(with: module.targetName(type: .sources), product: product)
    }
    
    static func implements(
        module: ModulePaths,
        product: Product = .staticLibrary,
        dependencies: [TargetDependency] = []
    ) -> Target {
        TargetSpec(sources: .sources, dependencies: dependencies)
            .toTarget(with: module.targetName(type: .sources), product: product)
    }
    
    static func implements(
        name: String,
        product: Product = .staticLibrary,
        spec: TargetSpec
    ) -> Target {
        spec.with {
            $0.sources = .sources
        }
        .toTarget(with: name, product: product)
    }
    
    static func implements(
        name: String,
        product: Product = .staticLibrary,
        dependencies: [TargetDependency] = []
    ) -> Target {
        TargetSpec(sources: .sources, dependencies: dependencies)
            .toTarget(with: name, product: product)
    }
}

// MARK: - Testing
public extension Target {
    static func testing(module: ModulePaths, spec: TargetSpec) -> Target {
        spec.with {
            $0.sources = .testing
        }
        .toTarget(with: module.targetName(type: .testing), product: .framework)
    }
    
    static func testing(module: ModulePaths, dependencies: [TargetDependency] = []) -> Target {
        TargetSpec(sources: .testing, dependencies: dependencies)
            .toTarget(with: module.targetName(type: .testing), product: .framework)
    }
    
    static func testing(name: String, spec: TargetSpec) -> Target {
        spec.with {
            $0.sources = .testing
        }
        .toTarget(with: "\(name)Testing", product: .framework)
    }
    
    static func testing(name: String, dependencies: [TargetDependency] = []) -> Target {
        TargetSpec(sources: .testing, dependencies: dependencies)
            .toTarget(with: "\(name)Testing", product: .framework)
    }
}

// MARK: - Tests
public extension Target {
    static func tests(module: ModulePaths, spec: TargetSpec) -> Target {
        spec.with {
            $0.sources = .unitTests
        }
        .toTarget(with: module.targetName(type: .unitTest), product: .unitTests)
    }
    
    static func tests(module: ModulePaths, dependencies: [TargetDependency] = []) -> Target {
        TargetSpec(sources: .unitTests, dependencies: dependencies)
            .toTarget(with: module.targetName(type: .unitTest), product: .unitTests)
    }
    
    static func tests(name: String, spec: TargetSpec) -> Target {
        spec.with {
            $0.sources = .unitTests
        }
        .toTarget(with: "\(name)Tests", product: .unitTests)
    }
    
    static func tests(name: String, dependencies: [TargetDependency] = []) -> Target {
        TargetSpec(sources: .unitTests, dependencies: dependencies)
            .toTarget(with: "\(name)Tests", product: .unitTests)
    }
}

// MARK: - Demo
public extension Target {
    static func demo(module: ModulePaths, spec: TargetSpec) -> Target {
        spec.with {
            $0.sources = .demoSources
            $0.settings = .settings(
                base: (spec.settings?.base ?? [:])
                    .merging(["OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable"]),
                configurations: generationEnvironment.configurations,
                defaultSettings: spec.settings?.defaultSettings ?? .recommended
            )
            $0.infoPlist = spec.infoPlist ?? .default
        }
        .toTarget(with: module.targetName(type: .demo), product: .app)
    }
    
    static func demo(module: ModulePaths, dependencies: [TargetDependency] = []) -> Target {
        TargetSpec(
            infoPlist: .demoDefulat,
            sources: .demoSources,
            dependencies: dependencies,
            settings: .settings(
                base: ["OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable"],
                configurations: generationEnvironment.configurations
            )
        )
        .toTarget(with: module.targetName(type: .demo), product: .app)
    }
    
    static func demo(name: String, spec: TargetSpec) -> Target {
        spec.with {
            $0.sources = .demoSources
            $0.settings = .settings(
                base: (spec.settings?.base ?? [:])
                    .merging(["OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable"]),
                configurations: generationEnvironment.configurations,
                defaultSettings: spec.settings?.defaultSettings ?? .recommended
            )
            $0.infoPlist = spec.infoPlist ?? .demoDefulat
        }
        .toTarget(with: "\(name)Demo", product: .app)
    }
    
    static func demo(name: String, dependencies: [TargetDependency] = []) -> Target {
        TargetSpec(
            infoPlist: .demoDefulat,
            sources: .demoSources,
            dependencies: dependencies,
            settings: .settings(
                base: ["OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable"],
                configurations: generationEnvironment.configurations
            )
        )
        .toTarget(with: "\(name)Demo", product: .app)
    }
}
