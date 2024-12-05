import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Module.ChatSoketModule.rawValue,
    targets: [
        .interface(module: .module(.ChatSoketModule)),
        .implements(module: .module(.ChatSoketModule), dependencies: [
            .module(target: .ChatSoketModule, type: .interface)
        ]),
        .testing(module: .module(.ChatSoketModule), dependencies: [
            .module(target: .ChatSoketModule, type: .interface)
        ]),
        .tests(module: .module(.ChatSoketModule), dependencies: [
            .module(target: .ChatSoketModule),
            .module(target: .ChatSoketModule, type: .testing)
        ]),
        .demo(module: .module(.ChatSoketModule), dependencies: [
            .module(target: .ChatSoketModule),
            .module(target: .ChatSoketModule, type: .testing)
        ])
    ]
)
