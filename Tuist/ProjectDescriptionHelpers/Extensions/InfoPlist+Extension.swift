import ProjectDescription

extension InfoPlist {
    static var demoDefulat: InfoPlist = .extendingDefault(with: [
        "UIMainStoryboardFile": "",
        "UILaunchStoryboardName": "LaunchScreen",
        "ENABLE_TESTS": .boolean(true),
        "NSAppTransportSecurity": [
            "NSAllowsArbitraryLoads": .boolean(true)
        ],
        "SECRETS": [
            "ACCESS_KEY" : "$(ACCESS_KEY)",
            "SECRET_KEY": "$(SECRET_KEY)",
            "PORT": "${PORT}",
            "HOST": "${HOST}"
        ]
    ])
    
    static var projectDefault: InfoPlist = .extendingDefault(
        with: [
            "UILaunchStoryboardName": "Resources/LaunchScreen",
            "UIApplicationSceneManifest": [
                "UIApplicationSupportsMultipleScenes": false,
                "UISceneConfigurations": [
                    "UIWindowSceneSessionRoleApplication": [
                        [
                            "UISceneConfigurationName": "Default Configuration",
                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                        ],
                    ]
                ]
            ],
            "UIUserInterfaceStyle": "Dark",
            "NSAppTransportSecurity": [
                "NSAllowsArbitraryLoads": .boolean(true)
            ],
            "SECRETS": [
                "ACCESS_KEY": "$(ACCESS_KEY)",
                "SECRET_KEY": "$(SECRET_KEY)",
                "PORT": "${PORT}",
                "HOST": "${HOST}",
                "CDN_DOMAIN": "$(CDN_DOMAIN)",
                "PROFILE_ID": "$(PROFILE_ID)",
                "CDN_INSTANCE_NO": "$(CDN_INSTANCE_NO)"
            ]
        ]
    )
}
