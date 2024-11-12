import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Module.ThirdPartyLibModule.rawValue,
    targets: [
        .interface(module: .module(.ThirdPartyLibModule)),
        .implements(module: .module(.ThirdPartyLibModule), dependencies: [
            .module(target: .ThirdPartyLibModule, type: .interface),
            .SPM.HaishinKit
        ]),
        .tests(module: .module(.ThirdPartyLibModule), dependencies: [
            .module(target: .ThirdPartyLibModule)
        ])
    ]
)