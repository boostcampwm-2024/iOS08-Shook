import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Module.EasyLayoutModule.rawValue,
    targets: [
        .implements(module: .module(.EasyLayoutModule)),
        .demo(module: .module(.EasyLayoutModule), dependencies: [
            .module(target: .EasyLayoutModule)
        ])
    ]
)
