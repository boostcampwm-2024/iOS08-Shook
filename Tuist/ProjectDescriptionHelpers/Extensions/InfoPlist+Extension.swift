import ProjectDescription

extension InfoPlist {
    static var demoDefulat: InfoPlist = .extendingDefault(with: [
        "UIMainStoryboardFile": "",
        "UILaunchStoryboardName": "LaunchScreen",
        "ENABLE_TESTS": .boolean(true),
        "SECRETS": [
            "ACCESS_KEY" : "$(ACCESS_KEY)",
            "SECRET_KEY": "$(SECRET_KEY)"
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
            "SECRETS": [
                "ACCESS_KEY": "$(ACCESS_KEY)",
                "SECRET_KEY": "$(SECRET_KEY)",
                "PORT": "${PORT}",
                "HOST": "${HOST}"
            ]
        ]
    )
}
