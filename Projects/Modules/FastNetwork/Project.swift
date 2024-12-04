import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Module.FastNetwork.rawValue,
    targets: [
        .interface(module: .module(.FastNetwork)),
        .implements(module: .module(.FastNetwork), dependencies: [
            .module(target: .FastNetwork, type: .interface),
        ]),
        .testing(module: .module(.FastNetwork), dependencies: [
            .module(target: .FastNetwork, type: .interface)
        ]),
        .tests(module: .module(.FastNetwork), dependencies: [
            .module(target: .FastNetwork),
            .module(target: .FastNetwork, type: .testing)
        ]),
        .demo(module: .module(.FastNetwork), dependencies: [
            .module(target: .FastNetwork),
            .module(target: .FastNetwork, type: .testing)
        ])
    ]
)
