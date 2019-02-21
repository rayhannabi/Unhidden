//
//  RNShellTests.swift
//  RNShellTests
//
//  Created by Rayhan Nabi on 2/22/19.
//  Copyright © 2019 Rayhan. All rights reserved.
//

import XCTest
@testable import RNShell

class RNShellTests: XCTestCase {
  
  private var shell: RNShell!
  
  override func setUp() {
    super.setUp()
    shell = RNShell()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func test_shellInitialized() {
    XCTAssertNotNil(shell, "Shell instance should not be nil")
  }
  
}
