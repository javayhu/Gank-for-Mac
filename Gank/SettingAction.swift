//
//  SettingAction.swift
//  Gank
//
//  Created by hujiawei on 2016/5/13.
//  Copyright © 2016年 Tsinghua University. All rights reserved.
//

import Cocoa
import Foundation

//点击设置按钮之后
class SettingAction {

	class func makeSettingMenu(_ sender: NSView) {
		let delegate = NSApplication.shared().delegate as! AppDelegate

		let menu = NSMenu()
		menu.addItem(NSMenuItem(title: "应用源码", action: #selector(delegate.openGithubLink), keyEquivalent: "g"))
		menu.addItem(NSMenuItem(title: "作者博客", action: #selector(delegate.openBlogLink), keyEquivalent: "b"))
		menu.addItem(NSMenuItem(title: "退出应用", action: #selector(delegate.quit), keyEquivalent: "q"))

		NSMenu.popUpContextMenu(menu, with: NSApp.currentEvent!, for: sender)
	}

}
