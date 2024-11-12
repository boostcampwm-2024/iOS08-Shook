import ProjectDescription

let config = Config(
    plugins: [    
		.local(path: .relativeToRoot("Plugin/TemplatePlugin")),    
		.local(path: .relativeToRoot("Plugin/ConfigurationPlugin")),
    ],
    generationOptions: .options()
)
