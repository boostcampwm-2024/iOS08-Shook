import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Module.EasyLayout.rawValue,
    targets: [
        .implements(module: .module(.EasyLayout)),
        .demo(module: .module(.EasyLayout), dependencies: [
            .module(target: .EasyLayout)
        ])
    ]
)
