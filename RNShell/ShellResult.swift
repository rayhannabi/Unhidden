//
//  ShellResult.swift
//  RNShell
//
//  Created by Rayhan Nabi on 2/22/19.
//  Copyright © 2019 Rayhan. All rights reserved.
//

import Foundation

public struct ShellResult {
  
  let outputs: [String]?
  let errors: [String]?
  let status: Int
  
  var firstLineOfOutput: String? {
    return outputs?.first
  }
  
  var firstLineOfError: String? {
    return errors?.first
  }
  
  init(outputs: [String]?, errors: [String]?, status: Int) {
    self.outputs = outputs
    self.errors = errors
    self.status = status
  }
  
}
