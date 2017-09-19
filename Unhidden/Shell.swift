//
//  Shell.swift
//  Unhidden
//
//  Created by Rayhan on 9/17/17.
//  Copyright © 2017 Rayhan. All rights reserved.
//

import Foundation

class Shell {
    private var _commandPath: String
    private var _args: [String]
    
    init(withCommandPath commandPath: String, andArguments args: [String]) {
        _commandPath = commandPath
        _args = args
    }
    
    public func run() -> (output: [String], error: [String], exitCode: Int32) {
        var output: [String] = []
        var error: [String] = []
        
        // Creating task
        let process = Process()
        
        process.launchPath = _commandPath
        process.arguments = _args
        
        // output pipe
        let outPipe = Pipe()
        process.standardOutput = outPipe
        
        // error pipe
        let errorPipe = Pipe()
        process.standardError = errorPipe
        
        process.launch()
        
        // get output of the terminal process
        let outData = outPipe.fileHandleForReading.readDataToEndOfFile()
        output = String(data: outData, encoding: .utf8)!.components(separatedBy: "\n")
        
        // get error of the terminal process
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        error = String(data: errorData, encoding: .utf8)!.components(separatedBy: "\n")
        
        process.waitUntilExit()
        
        let status = process.terminationStatus
        
        return (output, error, status)
    }
}
