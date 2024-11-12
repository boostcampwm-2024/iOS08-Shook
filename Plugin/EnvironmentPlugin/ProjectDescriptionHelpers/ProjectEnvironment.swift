import Foundation
import ProjectDescription

public struct ProjectEnvironment {
    public let name: String
    public let organizationName: String
    public let deploymentTargets: DeploymentTargets
    public let destinations : Destinations
//    public let baseSetting: SettingsDictionary

   
}

public let env = ProjectEnvironment(
    name: "Shook",
    organizationName: "kr.codesquad.boostcamp9.Shook",
    deploymentTargets: .iOS("16.0"),
    destinations: [.iPhone]
//    baseSetting: SettingsDictionary()
//        .marketingVersion("3.2.0")
//        .currentProjectVersion("0")
//        .debugInformationFormat(DebugInformationFormat.dwarfWithDsym)
//        .otherLinkerFlags(["-ObjC"])
//        .bitcodeEnabled(false)
)
