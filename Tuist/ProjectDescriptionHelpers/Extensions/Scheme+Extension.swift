import ProjectDescription
import EnvironmentPlugin

// MARK: - Module

extension Scheme {
    static func makeScheme(configuration: ConfigurationName, name: String) -> Scheme {
        return Scheme.scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: configuration,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: configuration),
            archiveAction: .archiveAction(configuration: configuration),
            profileAction: .profileAction(configuration: configuration),
            analyzeAction: .analyzeAction(configuration: configuration)
        )
    }
    static func makeDemoScheme(configuration: ConfigurationName, name: String) -> Scheme {
        return Scheme.scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)Demo"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: configuration,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)Demo"])
            ),
            runAction: .runAction(configuration: configuration),
            archiveAction: .archiveAction(configuration: configuration),
            profileAction: .profileAction(configuration: configuration),
            analyzeAction: .analyzeAction(configuration: configuration)
        )
    }
}

// MARK: - Project

extension Scheme {
    static let projectDebugScheme: Scheme =  .scheme(
            name: "\(env.name)-DEBUG",
            shared: true,
            buildAction: .buildAction(targets: ["\(env.name)"]),
            testAction: TestAction.targets(
                ["\(env.name)"],
                configuration: .debug,
                options: TestActionOptions.options(
                    coverage: true,
                    codeCoverageTargets: ["\(env.name)"]
                )
            ),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        )
    
    static let projectReleaseScheme: Scheme = .scheme(
        name: "\(env.name)-RELEASE",
        shared: true,
        buildAction: .buildAction(targets: ["\(env.name)"]),
        testAction: nil,
        runAction: .runAction(configuration: .release),
        archiveAction: .archiveAction(configuration: .release),
        profileAction: .profileAction(configuration: .release),
        analyzeAction: .analyzeAction(configuration: .release)
    )
}
