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
	@IBOutlet weak var beepMenuItem: NSMenuItem!
	@IBOutlet weak var monitorsSubMenu: NSMenu!
	
	var currentVolume: Int32 = 0
	var beepEnable: String = "on"

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		if let button = statusItem.button {
			button.image = NSImage(named:NSImage.Name("VolumeButtonImage"))
		}
		

		restoreSettings()
		constructMenu()
	}
	
	
	func restoreSettings() {
		// Read Volume Setting
		let savedVolume = Int32(UserDefaults.standard.integer(forKey: "SavedVolume"))
		
		print("Retrieved Volume: \(savedVolume)")
		
		if savedVolume > 0 && savedVolume <= 100 {
			currentVolume = savedVolume
		} else {
			currentVolume = 50
		}
		
		volumeMenuItem.title = "Volume: \(currentVolume)"
		statusSlider.intValue = currentVolume
		updateVolume(1, currentVolume)
		
		
		// Read Beep Setting
		let savedBeepEnable = UserDefaults.standard.string(forKey: "EnableBeep") ?? ""
		
		if savedBeepEnable == "on" || savedBeepEnable == "" {
			beepEnable = "on"
			beepMenuItem.state = NSControl.StateValue.on
		} else {
			beepEnable = "off"
			beepMenuItem.state = NSControl.StateValue.off
		}
		
		
	}

	func saveSettings() {
		UserDefaults.standard.set(currentVolume, forKey: "SavedVolume")
		UserDefaults.standard.set(beepEnable, forKey: "EnableBeep")
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
		
		if beepEnable == "on" {
			NSSound.beep()
		}
		
	}
	@IBAction func menuItemBeepChanged(_ sender: NSMenuItem) {
		if sender.state == NSControl.StateValue.on {
			sender.state = NSControl.StateValue.off
			beepEnable = "off"
		} else {
			sender.state = NSControl.StateValue.on
			beepEnable = "on"
		}
		
		
	}
	
	@IBAction func menuMonitorsAction(_ sender: NSMenuItem) {
//
//		for menu in sender.parent.item
//
//		for screen in NSScreen.screens {
//			let screenNumber = description.object(forKey: "NSScreenNumber")  as! Int
//
//			if sender.tag == screenNumber {
//				print "found screen"
//			}
//		}
//
//
	}
	
	
	func constructMenu() {
		var newMenu : NSMenuItem
		
		for screen in NSScreen.screens {
			newMenu = NSMenuItem()
			
			let description = screen.deviceDescription as NSDictionary
			let resolution = description.object(forKey: NSDeviceDescriptionKey.size) as! NSSize
			let screenNumber = description.object(forKey: "NSScreenNumber")  as! Int
			
			let resolutionString = "Screen - \(Int32(resolution.width))x\(Int32(resolution.height))"
			
			newMenu.title = resolutionString
			newMenu.action = #selector(menuMonitorsAction(_:))
			newMenu.tag = screenNumber
			
			monitorsSubMenu.addItem(newMenu)
			
		}
		
		statusSlider.setFrameSize(NSSize(width: 60, height: 100))
		sliderMenuItem.view = statusSlider
	
		statusItem.menu = VolumeControlMenuBar
	}
}

