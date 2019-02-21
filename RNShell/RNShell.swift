//
//  RNShell.swift
//  RNShell
//
//  Created by Rayhan Nabi on 2/22/19.
//  Copyright © 2019 Rayhan. All rights reserved.
//

import Cocoa

public protocol RNShellDelegate: AnyObject {
  func didFinishRunning(_ shell: RNShell, result: ShellResult)
}

public class RNShell {
  
  private let defaultPath = "/usr/bin/env"
  
  private let process:        Process
  private let outputPipe:     Pipe
  private let errorPipe:      Pipe
  
  weak var delegate:          RNShellDelegate?
  private(set) var command:   String
  private(set) var path:      String
  
  // MARK: - Initializer
  
  init(path: String? = nil) {
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
  
  private func launchProcess() {
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
    
    delegate?.didFinishRunning(self, result: shellResult)
  }
  
  // MARK: - Public instance methods
  
  func run(command: String) {
    self.command = command
    
    let arguments = command.components(separatedBy: .whitespaces)
    process.arguments = arguments
    
    DispatchQueue.main.async {
      self.launchProcess()
    }
  }
  
}
