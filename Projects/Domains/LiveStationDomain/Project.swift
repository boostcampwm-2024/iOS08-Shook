import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.LiveStationDomain.rawValue,
    targets: [
        .interface(module: .domain(.LiveStationDomain)),
        .implements(module: .domain(.LiveStationDomain), dependencies: [
            .domain(target: .LiveStationDomain, type: .interface),
            .domain(target: .BaseDomain),
        ]),
        .testing(module: .domain(.LiveStationDomain), dependencies: [
            .domain(target: .LiveStationDomain, type: .interface),
        ]),
    ]
)
