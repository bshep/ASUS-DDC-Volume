//
//  AppDelegate.swift
//  ASUS Volume
//
//  Created by Bruce Sheplan on 5/27/18.
//  Copyright © 2018 Bruce Sheplan. All rights reserved.
//

import Cocoa
import Foundation

let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet weak var VolumeControlMenuBar: NSMenu!
	@IBOutlet weak var sliderMenuItem: NSMenuItem!
	@IBOutlet weak var statusSlider: NSSlider!
	@IBOutlet weak var volumeMenuItem: NSMenuItem!
	@IBOutlet weak var beepMenuItem: NSMenuItem!
	@IBOutlet weak var monitorsSubMenu: NSMenu!
	@IBOutlet weak var startOnLoginMenuItem: NSMenuItem!
	
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
		
		// find out if we are enabled at login
		let startOnLoginEnabled = (itemReferencesInLoginItems() != nil)
		
		if startOnLoginEnabled {
			startOnLoginMenuItem.state = NSControl.StateValue.on
		} else {
			startOnLoginMenuItem.state = NSControl.StateValue.off
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
	
	@IBAction func startOnLoginMenuItemAction(_ sender: NSMenuItem) {
		if sender.state == NSControl.StateValue.on {
			sender.state = NSControl.StateValue.off
			toggleLaunchAtStartup(state: false)
		} else {
			sender.state = NSControl.StateValue.on
			toggleLaunchAtStartup(state: true)
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
	
	func toggleLaunchAtStartup(state: Bool? = false) {
		let itemReferences = itemReferencesInLoginItems()
		let shouldBeToggled = (itemReferences.existingReference == nil) || state!
		if let loginItemsRef = LSSharedFileListCreate( nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileList? {
			if shouldBeToggled {
				let appUrl : CFURL = NSURL.fileURL(withPath: Bundle.main.bundlePath) as CFURL
				print("Add login item")
				LSSharedFileListInsertItemURL(loginItemsRef, itemReferences.lastReference, nil, nil, appUrl, nil, nil)
				
			} else {
				let itemRef = itemReferences.existingReference
				print("Remove login item")
				LSSharedFileListItemRemove(loginItemsRef,itemRef);
			}
		}
	}
	
	func itemReferencesInLoginItems() -> (existingReference: LSSharedFileListItem?, lastReference: LSSharedFileListItem?) {
		let appURL : NSURL = NSURL.fileURL(withPath: Bundle.main.bundlePath) as NSURL
		if let loginItemsRef = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileList? {
			
			let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray
			let lastItemRef: LSSharedFileListItem = loginItems.lastObject as! LSSharedFileListItem
			
			for (index, _) in loginItems.enumerated() {
				let currentItemRef: LSSharedFileListItem = loginItems.object(at: index) as! LSSharedFileListItem
				if let itemURL = LSSharedFileListItemCopyResolvedURL(currentItemRef, 0, nil) {
					if (itemURL.takeRetainedValue() as NSURL).isEqual(appURL) {
						return (currentItemRef, lastItemRef)
					}
				}
			}
			
			return (nil, lastItemRef)
		}
		
		return (nil, nil)
	}
}

