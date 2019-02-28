//
//  Constants.swift
//  Unhidden
//
//  Created by Rayhan Nabi on 2/22/19.
//  Copyright © 2019 Rayhan. All rights reserved.
//

import Cocoa

struct Constants {
  
  struct Colors {
    static var switchOn = NSColor(calibratedRed: 69/255, green: 220/255, blue: 92/255, alpha: 1.0)
    static var switchOff = NSColor(calibratedRed: 255/255, green: 102/255, blue: 102/255, alpha: 1.0)
  }
  
  struct Commands {
    static var read = "defaults read com.apple.finder AppleShowAllFiles"
    static var writeYes = "defaults write com.apple.finder AppleShowAllFiles Yes"
    static var writeNo = "defaults write com.apple.finder AppleShowAllFiles No"
    static var killallPath = "/usr/bin/killall"
    static var finder = "Finder"
  }
  
}

struct Strings {
  static var hiddenFileOn = "Hidden files are not shown"
  static var hiddenFileOff = "Hidden files are visible now"
}
