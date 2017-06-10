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

	let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength) // 状态栏的应用按钮，或者用 -2
	let popover = NSPopover() // 点击状态栏应用按钮弹出的主界面窗口
	var refreshTimer: Timer? // 定时器用于刷新数据

	// 应用启动之后
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// 设置状态栏的应用图标
		if let button = statusItem.button {
			button.image = NSImage(named: "icon-statusbar")
			button.action = #selector(togglePopover) // AppDelegate.togglePopover(_:)
		}

		// 设置弹出的主界面
		popover.contentViewController = GankViewController(nibName: "GankViewController", bundle: nil)
		popover.behavior = .transient
		popover.animates = false
		popover.appearance = NSAppearance(named: NSAppearanceNameAqua) // since os x 10.9

		// 设置定时器每隔10分钟发送数据请求 10.minutes
		refreshTimer = Timer.every(10.minutes) { // seconds
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadSections"), object: nil)
		}
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		refreshTimer?.invalidate() // 关闭定时器
		refreshTimer = nil
		if let controller = popover.contentViewController { // 取消监听
			NotificationCenter.default.removeObserver(controller)
		}
	}

	// 打开或者关闭弹出窗口
	func togglePopover() {
		PopoverAction.toggle()
	}

	// 打开github进入应用源码
	func openGithubLink() {
		OpenUrlAction.perform(withPath: "https://github.com/hujiaweibujidao/Gank-for-Mac")
	}

	// 打开我的博客
	func openBlogLink() {
		OpenUrlAction.perform(withPath: "https://javayhu.me/")
	}

	// 退出应用
	func quit() {
		NSApplication.shared().terminate(self)
	}

}

