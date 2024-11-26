import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.ChattingDomain.rawValue,
    targets: [
        .interface(module: .domain(.ChattingDomain)),
        .implements(module: .domain(.ChattingDomain), dependencies: [
            .domain(target: .ChattingDomain, type: .interface),
            .domain(target: .BaseDomain)
        ]),
        .testing(module: .domain(.ChattingDomain), dependencies: [
            .domain(target: .ChattingDomain, type: .interface)
        ]),
        .tests(module: .domain(.ChattingDomain), dependencies: [
            .domain(target: .ChattingDomain),
            .domain(target: .ChattingDomain, type: .testing)
        ])
    ]
)
