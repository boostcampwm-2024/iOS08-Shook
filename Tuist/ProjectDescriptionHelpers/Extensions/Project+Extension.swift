import ConfigurationPlugin
import DependencyPlugin
import EnvironmentPlugin
import Foundation
import ProjectDescription

public extension Project {
    
    static let project: Project = Project(
            name: env.name,
            organizationName: env.organizationName,
            packages: [],
            settings: .settings(base: .makeProjectSetting(), configurations: generationEnvironment.configurations, defaultSettings: .recommended),
            targets: [.projectTarget, .projectTestTarget],
            schemes: [.projectDebugScheme, .projectReleaseScheme]
    )
    
    
    static func module(
        name: String,
        options: Options = .options(),
        packages: [Package] = [],
        settings: Settings = .settings(
            base: baseSetting,
            configurations: generationEnvironment.configurations,
            defaultSettings: .recommended
        ),
        targets: [Target],
        fileHeaderTemplate: FileHeaderTemplate? = nil,
        additionalFiles: [FileElement] = [],
        resourceSynthesizers: [ResourceSynthesizer] = .default
    ) -> Project {
        return Project(
            name: name,
            organizationName: env.organizationName,
            options: options,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: targets.contains { $0.product == .app } ?
                [.makeScheme(configuration: .debug, name: name), .makeDemoScheme(configuration: .debug, name: name)] :
                [.makeScheme(configuration: .debug, name: name)],
            fileHeaderTemplate: fileHeaderTemplate,
            additionalFiles: additionalFiles,
            resourceSynthesizers: resourceSynthesizers
        )
    }
}

