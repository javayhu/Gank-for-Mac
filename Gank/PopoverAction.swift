
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
	private class var eventMonitor: EventMonitor? {
		return EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) { event in
			close()
		}
	}

	// AppDelegate
	private class var appDelegate: AppDelegate {
		return NSApplication.sharedApplication().delegate as! AppDelegate
	}

	class func toggle() {
		if appDelegate.popover.shown {
			close()
		} else {
			show()
		}
	}

	class func close() {
		if !appDelegate.popover.shown {
			return
		}

		appDelegate.popover.close()
		eventMonitor?.stop()
	}

	class func show() {
		NSRunningApplication.currentApplication().activateWithOptions(NSApplicationActivationOptions.ActivateIgnoringOtherApps)

		guard let button = appDelegate.statusItem.button else {
			return
		}

		appDelegate.popover.showRelativeToRect(button.frame, ofView: button, preferredEdge: .MinY)
		eventMonitor?.start()
	}
}
