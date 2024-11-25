import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Module.NetworkModule.rawValue,
    targets: [
        .interface(module: .module(.NetworkModule)),
        .implements(module: .module(.NetworkModule), dependencies: [
            .module(target: .NetworkModule, type: .interface),
        ]),
        .testing(module: .module(.NetworkModule), dependencies: [
            .module(target: .NetworkModule, type: .interface)
        ]),
        .tests(module: .module(.NetworkModule), dependencies: [
            .module(target: .NetworkModule),
            .module(target: .NetworkModule, type: .testing)
        ]),
        .demo(module: .module(.NetworkModule), dependencies: [
            .module(target: .NetworkModule),
            .module(target: .NetworkModule, type: .testing)
        ])
    ]
)
