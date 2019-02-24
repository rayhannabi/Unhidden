//
//  RNShell.swift
//  RNShell
//
//  Created by Rayhan Nabi on 2/22/19.
//  Copyright © 2019 Rayhan. All rights reserved.
//

import Cocoa

public class RNShell {
  
  private let defaultPath = "/usr/bin/env"
  
  private let process:        Process
  private let outputPipe:     Pipe
  private let errorPipe:      Pipe
  
  private(set) var command:   String
  private(set) var path:      String
  
  // MARK: - Initializer
  
  public init(path: String? = nil) {
    self.command = ""
    self.process = Process()
    self.outputPipe = Pipe()
    self.errorPipe = Pipe()
    
    if let unwrappedPath = path {
      self.path = unwrappedPath
    } else {
      self.path = defaultPath
    }
    
    setupProcess()
  }
  
  // MARK: - Private methods
  
  private func setupProcess() {
    process.launchPath = path
    process.standardOutput = outputPipe
    process.standardError = errorPipe
  }
  
  private func launchProcess() -> ShellResult {
    process.launch()
    
    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: outputData, encoding: .utf8)
    let error = String(data: errorData, encoding: .utf8)
    
    process.waitUntilExit()
    let outputResult = output != nil ? output!.components(separatedBy: .newlines) : nil
    let errorResult = error != nil ? error!.components(separatedBy: .newlines) : nil
    let shellResult = ShellResult(outputs: outputResult,
                                  errors: errorResult,
                                  status: Int(process.terminationStatus))
    return shellResult
  }
  
  // MARK: - Public instance methods
  @discardableResult
  public func run(command: String) -> ShellResult {
    self.command = command
    
    let arguments = command.components(separatedBy: .whitespaces)
    process.arguments = arguments
    
    return launchProcess()
  }
  
}
