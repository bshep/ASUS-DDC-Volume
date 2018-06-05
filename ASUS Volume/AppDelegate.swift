//
//  AppDelegate.swift
//  ASUS Volume
//
//  Created by Bruce Sheplan on 5/27/18.
//  Copyright © 2018 Bruce Sheplan. All rights reserved.
//

import Cocoa

let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



	func applicationDidFinishLaunching(_ aNotification: Notification) {
		if let button = statusItem.button {
			button.image = NSImage(named:NSImage.Name("VolumeButtonImage"))
//			button.action = #selector(printQuote(_:))
		}
		
		constructMenu()
		
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	@objc func printQuote(_ sender: Any?) {
		
	}
	
	@objc func changeVolume(_ sender: NSSlider) {
		
		print("Slider Val: ", sender.intValue)
		updateVolume(1,sender.intValue)
	}
	
	func constructMenu() {
		let menu = NSMenu()
		let statusSlider = NSSlider(value: 50.0, minValue: 0.0, maxValue: 100.0, target: nil, action: #selector(changeVolume(_:)))
		let sliderMenuItem = NSMenuItem()
		
//		statusSlider.setFrameSize(NSSize(width: 100, height: 32))
		statusSlider.isContinuous = false
		sliderMenuItem.title = "Volume"
		sliderMenuItem.view = statusSlider

		
		menu.addItem(NSMenuItem(title: "Volume: ", action: nil, keyEquivalent: ""))
		menu.addItem(sliderMenuItem)
		menu.addItem(NSMenuItem.separator())
		menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
		
		statusItem.menu = menu
	}
}

