//
//  ShellResult.swift
//  RNShell
//
//  Created by Rayhan Nabi on 2/22/19.
//  Copyright © 2019 Rayhan. All rights reserved.
//

import Foundation

public struct ShellResult {
  
  public let outputs: [String]?
  public let errors: [String]?
  public let status: Int
  
  public var firstLineOfOutput: String? {
    return outputs?.first
  }
  
  public var firstLineOfError: String? {
    return errors?.first
  }
  
  public init(outputs: [String]?, errors: [String]?, status: Int) {
    self.outputs = outputs
    self.errors = errors
    self.status = status
  }
  
}
