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
	@IBOutlet weak var VolumeControlMenuBar: NSMenu!
	@IBOutlet weak var sliderMenuItem: NSMenuItem!
	@IBOutlet weak var statusSlider: NSSlider!
	@IBOutlet weak var volumeMenuItem: NSMenuItem!

	var currentVolume: Int32 = 0

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		if let button = statusItem.button {
			button.image = NSImage(named:NSImage.Name("VolumeButtonImage"))
		}
		

		restoreSettings()
		constructMenu()
	}
	
	
	func restoreSettings() {
		var saveVal: Int32
			
		saveVal = Int32(UserDefaults.standard.integer(forKey: "SavedVolume"))
		
		print("Retrieved Volume: \(saveVal)")
		
		if saveVal > 0 && saveVal <= 100 {
			currentVolume = saveVal
		} else {
			currentVolume = 50
		}
		
		volumeMenuItem.title = "Volume: \(currentVolume)"
		updateVolume(1, currentVolume)
	}

	func saveSettings() {
		UserDefaults.standard.set(currentVolume, forKey: "SavedVolume")
	}

	
	func applicationWillTerminate(_ aNotification: Notification) {
		saveSettings()
	}

	
	@IBAction func menuItemQuit(_ sender: NSMenuItem) {
		NSApplication.shared.terminate(NSApplication.shared)
	}

	@IBAction func menuItemVolumeChanged(_ sender: NSSlider) {
		currentVolume = sender.intValue
		
		print("Slider Val: ", currentVolume)
		volumeMenuItem.title = "Volume: \(currentVolume)"
		updateVolume(1,currentVolume)

	}
	
	func constructMenu() {
		statusSlider.setFrameSize(NSSize(width: 60, height: 100))
		sliderMenuItem.view = statusSlider
	
		statusItem.menu = VolumeControlMenuBar
	}
}

