//
//  EventMonitor.swift
//  Gank
//
//  Created by hujiawei on 2016/5/11.
//  Copyright © 2016年 Tsinghua University. All rights reserved.
//

import Cocoa

//监听用户的点击事件，当用户在弹出窗口外点击时要关闭窗口
class EventMonitor {

	fileprivate var monitor: AnyObject?
	fileprivate let mask: NSEventMask
	fileprivate let handler: (NSEvent?) -> () // 回调函数

	init(mask: NSEventMask, handler: @escaping (NSEvent?) -> ()) {
		self.mask = mask
		self.handler = handler
	}

	deinit {
		stop()
	}

	func start() {
		monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject
	}

	func stop() {
		if monitor != nil {
			NSEvent.removeMonitor(monitor!)
			monitor = nil
		}
	}

}

