
//
//  PopoverAction.swift
//  Gank
//
//  Created by hujiawei on 2016/5/12.
//  Copyright © 2016年 Tsinghua University. All rights reserved.
//

import Foundation
import Cocoa

//打开或者关闭窗口的操作
class PopoverAction {

	// 静态计算型属性，监听用户的点击事件，在窗口外点击要关闭窗口
	fileprivate class var eventMonitor: EventMonitor? {
		return EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { event in
			close()
		}
	}

	// AppDelegate
	fileprivate class var appDelegate: AppDelegate {
		return NSApplication.shared().delegate as! AppDelegate
	}

	class func toggle() {
		if appDelegate.popover.isShown {
			close()
		} else {
			show()
		}
	}

	class func close() {
		if !appDelegate.popover.isShown {
			return
		}

		appDelegate.popover.close()
		eventMonitor?.stop()
	}

	class func show() {
		NSRunningApplication.current().activate(options: NSApplicationActivationOptions.activateIgnoringOtherApps)

		guard let button = appDelegate.statusItem.button else {
			return
		}

		appDelegate.popover.show(relativeTo: button.frame, of: button, preferredEdge: .minY)
		eventMonitor?.start()
	}
}
