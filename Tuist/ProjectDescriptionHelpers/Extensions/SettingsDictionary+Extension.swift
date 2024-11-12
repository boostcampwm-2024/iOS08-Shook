import ProjectDescription

public let baseSetting: SettingsDictionary = SettingsDictionary()

extension SettingsDictionary {
    enum SettingProperty {
        case alternateAppIconNames(array: [String])
        
        var value: SettingsDictionary {
            switch self {
            case let .alternateAppIconNames(array):
                return ["ASSETCATALOG_COMPILER_ALTERNATE_APPICON_NAMES": .array(array)]
            }
        }
    }
}

extension SettingsDictionary {
    
    static func makeProjectSetting() -> SettingsDictionary {
        return baseSetting
            .swiftVersion("6.0")
    }
    
     func merging(property: SettingProperty) -> SettingsDictionary  {
         return self.merging(property.value)
    }

}


