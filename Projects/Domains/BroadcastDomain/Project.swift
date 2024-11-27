import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.BroadcastDomain.rawValue,
    targets: [
        .interface(module: .domain(.BroadcastDomain)),
        .implements(module: .domain(.BroadcastDomain), dependencies: [
            .domain(target: .BroadcastDomain, type: .interface),
            .domain(target: .BaseDomain)
        ]),
        .testing(module: .domain(.BroadcastDomain), dependencies: [
            .domain(target: .BroadcastDomain, type: .interface)
        ]),
        .tests(module: .domain(.BroadcastDomain), dependencies: [
            .domain(target: .BroadcastDomain),
            .domain(target: .BroadcastDomain, type: .testing)
        ])
    ]
)
