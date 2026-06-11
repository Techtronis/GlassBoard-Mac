//
//  Scripts.swift
//  GlassBoard
//
//  Created by Alexis Jost on 10.06.2026.
//

import Foundation

@discardableResult func shell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()
    task.standardOutput = pipe
    
    task.launchPath = "/bin/zsh"
    task.arguments = ["-c", command]
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

@discardableResult func getInstalledPackages(_ command: String) -> [String] {
    let process = Process()
    process.launchPath = "/bin/zsh"
    process.arguments = ["-c", command]
    
    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe
    process.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""
    
    return output
        .components(separatedBy: "\n")
            .map { $0.replacingOccurrences(of: "package:", with: "") }
            .map { $0.replacingOccurrences(of: "\r", with: "") }
            .filter { !$0.isEmpty }
            .sorted()
}
