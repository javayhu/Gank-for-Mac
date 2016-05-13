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

	// 状态栏的应用按钮 NSVariableStatusItemLength 或者 -2
	let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
	// 点击状态栏应用按钮弹出的主界面窗口
	let popover = NSPopover()

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
	}

	func applicationWillTerminate(aNotification: NSNotification) {
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

}

