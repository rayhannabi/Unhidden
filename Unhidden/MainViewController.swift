//
//  MainViewController.swift
//  Unhidden
//
//  Created by Rayhan on 9/17/17.
//  Copyright © 2017 Rayhan. All rights reserved.
//

import Cocoa
import RNShell

class MainViewController: NSViewController {
  
  lazy var window: NSWindow! = self.view.window
  
  @IBOutlet weak var settingsSwitch: OGSwitch!

  
  // MARK: - Life cycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    settingsSwitch.delegate = self
    settingsSwitch.isOn = false
    checkCurrentStatus()
  }
  
  override func viewWillAppear() {
    window.titlebarAppearsTransparent = true
    window.titleVisibility = .hidden
  }
  
  // MARK: - Private methods
  
  fileprivate func checkCurrentStatus() {
    let shellForStatus = RNShell()
    let result = shellForStatus.run(command: Constants.Commands.read)
    
    guard let output = result.firstLineOfOutput else {
      return
    }
    
    switch output {
    case "YES", "Yes", "yes":
      setSwitchOn()
    case "NO", "No", "no":
      setSwitchOff()
    default:
      return
    }
  }
  
  fileprivate func setSwitch(to state: OGSwitchState) {
    switch state {
    case .on:
      settingsSwitch.setOn(isOn: true, animated: true)
    case .off:
      settingsSwitch.setOn(isOn: false, animated: true)
    }
  }
  
  fileprivate func setHiddenFileSettings(value: Bool) -> Bool {
    let shell = RNShell()
    let command = value ? Constants.Commands.writeYes : Constants.Commands.writeNo
    let result = shell.run(command: command)
    
    if result.firstLineOfError != nil &&
      result.status != 0 {
      return false
    }
    
    return true
  }
  
  fileprivate func setSwitchOn() {
    let success = setHiddenFileSettings(value: true)
    if success {
      setSwitch(to: .on)
    }
  }
  
  fileprivate func setSwitchOff() {
    let success = setHiddenFileSettings(value: false)
    if success {
      setSwitch(to: .off)
    }
  }
  
  fileprivate func relaunchFinder() {
    let shell = RNShell(path: Constants.Commands.killallPath)
    shell.run(command: Constants.Commands.finder)
  }
  
}

// MARK: - OGSwitchDelegate

extension MainViewController: OGSwitchDelegate {
  
  func didToggle(_ switch: OGSwitch) {
    switch settingsSwitch.isOn {
    case true:
      toggleSettings(to: true)
    case false:
      toggleSettings(to: false)
    }
  }
  
  fileprivate func toggleSettings(to value: Bool) {
    if setHiddenFileSettings(value: value) {
      relaunchFinder()
    }
  }
  
}
