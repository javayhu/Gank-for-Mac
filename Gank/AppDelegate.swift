//
//  AppDelegate.swift
//  Gank
//
//  Created by hujiawei on 2016/5/11.
//  Copyright © 2016年 Tsinghua University. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	// @IBOutlet weak var window: NSWindow! //没有window了，整个应用只有状态栏中的那个弹出窗口

	let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength) // 状态栏的应用按钮，或者用 -2
	let popover = NSPopover() // 点击状态栏应用按钮弹出的主界面窗口
	var refreshTimer: NSTimer? // 定时器用于刷新数据

	// 应用启动之后
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// 设置状态栏的应用图标
		if let button = statusItem.button {
			button.image = NSImage(named: "icon-statusbar")
			button.action = #selector(togglePopover) // AppDelegate.togglePopover(_:)
		}

		// 设置弹出的主界面
		popover.contentViewController = GankViewController(nibName: "GankViewController", bundle: nil)
		popover.behavior = .Transient
		popover.animates = false
		popover.appearance = NSAppearance(named: NSAppearanceNameAqua) // since os x 10.9

        //增加开机启动
        if !applicationIsInStartUpItems() {
            toggleLaunchAtStartup()
        }

        
		// 设置定时器每隔10分钟发送数据请求 10.minutes
		refreshTimer = NSTimer.every(10.minutes) { // seconds
			NSNotificationCenter.defaultCenter().postNotificationName("ReloadSections", object: nil)
		}
        
        
        
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		refreshTimer?.invalidate() // 关闭定时器
		refreshTimer = nil
		if let controller = popover.contentViewController { // 取消监听
			NSNotificationCenter.defaultCenter().removeObserver(controller)
		}
	}

	// 打开或者关闭弹出窗口
	func togglePopover() {
		PopoverAction.toggle()
	}

	// 打开github进入应用源码
	func openGithubLink() {
		OpenUrlAction.perform(withPath: "https://github.com/hujiaweibujidao/Gank")
	}

	// 打开我的博客
	func openBlogLink() {
		OpenUrlAction.perform(withPath: "https://hujiaweibujidao.github.io/")
	}

	// 退出应用
	func quit() {
		NSApplication.sharedApplication().terminate(self)
	}

    //增加开机启动 10.10
    func applicationIsInStartUpItems() -> Bool {
        return itemReferencesInLoginItems().existingReference != nil
    }
    
    func toggleLaunchAtStartup() {
        let itemReferences = itemReferencesInLoginItems()
        let shouldBeToggled = (itemReferences.existingReference == nil)
        let loginItemsRef = LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
            nil
            ).takeRetainedValue() as LSSharedFileListRef?
        
        if loginItemsRef != nil {
            if shouldBeToggled {
                if let appUrl: CFURLRef = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath) {
                    LSSharedFileListInsertItemURL(loginItemsRef, itemReferences.lastReference, nil, nil, appUrl, nil, nil)
                }
            } else {
                if let itemRef = itemReferences.existingReference {
                    LSSharedFileListItemRemove(loginItemsRef,itemRef);
                }
            }
        }
    }
    
    func itemReferencesInLoginItems() -> (existingReference: LSSharedFileListItemRef?, lastReference: LSSharedFileListItemRef?) {
        let  itemUrl : UnsafeMutablePointer<Unmanaged<CFURL>?> = UnsafeMutablePointer<Unmanaged<CFURL>?>.alloc(1)
        if let appUrl : NSURL = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath) {
            let loginItemsRef = LSSharedFileListCreate(
                nil,
                kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                nil
                ).takeRetainedValue() as LSSharedFileListRef?
            
            if loginItemsRef != nil {
                let loginItems = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray
                if(loginItems.count > 0) {
                    let lastItemRef = loginItems.lastObject as! LSSharedFileListItemRef
                    
                    for i in 0 ..< loginItems.count {
                        let currentItemRef = loginItems.objectAtIndex(i) as! LSSharedFileListItemRef
                        
                        if LSSharedFileListItemResolve(currentItemRef, 0, itemUrl, nil) == noErr {
                            if let urlRef: NSURL = itemUrl.memory?.takeRetainedValue() {
                                if urlRef.isEqual(appUrl) {
                                    return (currentItemRef, lastItemRef)
                                }
                            }
                        }
                    }
                    // The application was not found in the startup list
                    return (nil, lastItemRef)
                    
                } else  {
                    let addatstart: LSSharedFileListItemRef = kLSSharedFileListItemBeforeFirst.takeRetainedValue()
                    return(nil,addatstart)
                }
            }
        }
        
        return (nil, nil)
    }
}

