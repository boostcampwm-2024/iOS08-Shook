#!/usr/bin/swift
import Foundation


func handleSIGINT(_ signal: Int32) { 
    exit(0)
}

signal(SIGINT, handleSIGINT) // ctrl+C 입력시 동작 

let fileManager = FileManager.default

/// 폴더 생성
func makeDirectory(_ path: String) {
    
    do {
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
    } catch {
        fatalError("❌ failed to create directory: \(path)")
    }
    
}

/// 파일 생성
func writeContentInFile(path: String, content: String) {
    let fileURL = URL(fileURLWithPath: path)
    let data = Data(content.utf8)

    do {
        try data.write(to: fileURL)
    } catch {
        fatalError("❌ failed to create File: \(path)")
    }
    
}

// 파일 업데이트
func updateFileContent(
    filePath: String,
    finding findingString: String,
    inserting insertString: String
) {
    let fileURL = URL(fileURLWithPath: filePath)
    
    do {
        var fileString = try String(contentsOf: fileURL, encoding: .utf8)
        if let range = fileString.range(of: findingString)?.upperBound {
            fileString.insert(contentsOf: insertString, at: range)
        } else {
            fileString.append(insertString)
        }
        try fileString.write(to: fileURL, atomically: true, encoding: .utf8)
    } catch {
        print("❌ Error: \(error)")
    }
}


/// Plugins.swift 파일 생성
func makePluginSwift(_ pluginName: String) {
    
    let prefix = pluginName.prefix(1).lowercased()

    let suffix = pluginName.dropFirst()
    
    let variableString = String(prefix) + suffix

    let pluginSwift = """
import ProjectDescription
let \(variableString)Plugin = Plugin(name: "\(pluginName)Plugin")
"""
    
    writeContentInFile(path: "\(pluginRootPath)/Plugin.swift", content: pluginSwift)
    print("✅ Completed .swift file")
}

///
func generatePlugin(_ pluginName: String) {
    
    let helperPath : String = "\(pluginRootPath)/ProjectDescriptionHelpers"
    let emptyFileContent : String = """
"Empty"
"""
    makeDirectory(pluginRootPath)
    makePluginSwift(pluginName)
    makeDirectory(helperPath)
    writeContentInFile(path: "\(helperPath)/empty.swift", content: emptyFileContent) // 더미 파일
    registerToConfig(pluginName)
    print("✅ Completed all Task")
    
}

func registerToConfig(_ pluginName: String) {
    let path = "./Tuist/Config.swift"
    let content = """
    \n\t\t.local(path: .relativeToRoot("Plugin/\(pluginName)Plugin")),
"""
    updateFileContent(filePath: path, finding: "[",inserting: content)
    print("✅ Completed register to Config.swift")
}


// ✅ Entry Point

print("Enter plugin Name, do not include 'Plugin' suffix , ex) TempPlguin -> just enter Temp")
print()
print("PluginName:", terminator:"") 
let pluginName = readLine()!
let pluginRootPath = "./Plugin/\(pluginName)Plugin"

generatePlugin(pluginName)
print("------------------------------------------------------------------------------------------------------------------------")
print("Plugin Name: \(pluginName)")
print("Processing...")
print("------------------------------------------------------------------------------------------------------------------------")
print("✅  \(pluginName)Plugin is created successfully!")