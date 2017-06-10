//
//  GankViewController.swift
//  Gank
//
//  Created by Vlado on 3/14/16.
//  Copyright © 2016 ProductHunt. All rights reserved.
//

import Cocoa
import SwiftyTimer

//主界面窗口
class GankViewController: NSViewController, NSUserNotificationCenterDelegate {

	@IBOutlet weak var tableView: NSTableView! // 表格组件
	@IBOutlet weak var loadingView: GankLoadingView! // 加载界面
	@IBOutlet weak var lastUpdatedLabel: NSTextField! // 上次更新时间
	@IBOutlet weak var homeButton: GankButton! // 首页按钮
	@IBOutlet weak var settingsButton: GankButton! // 设置按钮

	var currentDate = 0 // 当前需要加载的日报的编号
	var sections = [GankSection]() // 干货日报
	var items = [AnyObject]() // 数据列表
	let gankAPI = GankAPI() // 干货API工具类
	let format = DateFormatter() // 格式化更新时间

	override func viewDidLoad() {
		super.viewDidLoad()

		view.wantsLayer = true
		view.layer?.backgroundColor = NSColor.gankWhiteColor().cgColor

		format.dateFormat = "yyyy-MM-dd HH:mm:ss" // 更新时间的显示格式
		// tableView.intercellSpacing = NSSize.zero // 列表单元格间隔为0
		lastUpdatedLabel.stringValue = "" // 初始时为空字符串
		loadingView.showState(.loading) // 进入之后首先显示加载界面

		// 关于发送系统通知
		NSUserNotificationCenter.default.delegate = self

		// 注册监听，前者是用于加载某日的数据，后者是用于加载日期列表
		NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "Reload"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(reloadSections), name: NSNotification.Name(rawValue: "ReloadSections"), object: nil)

		NotificationCenter.default.post(name: Notification.Name(rawValue: "Reload"), object: nil) // 发送加载数据的请求
	}

	// 加载日期列表
	func reloadSections() {
		gankAPI.loadAllDates {
			[unowned self] data in

			if data is NSError {
				return self.loadingView.showState(.error)
			}

			let sectionList = data as! [GankSection]
			if sectionList.isEmpty { // 如果sections是空那就是没有数据，当然这不太可能发生，这里是为了避免请求的死循环
				self.loadingView.showState(.empty) // 这里可以不用考虑之前的sections是什么
			} else { // 如果sectionList不为空，那么就表示sections中有数据
				if self.sections.count == 0 { // sections之前为空，设置为加载到的数据列表，并重新请求加载数据（加载日期列表中第一个日期的数据）
					self.sections = sectionList
					// self.sections.removeFirst() // 测试使用
					NotificationCenter.default.post(name: Notification.Name(rawValue: "Reload"), object: nil)
				} else if self.sections.count > 0 && self.sections.count < sectionList.count { // sections之前不为空，但是却有最新的数据来了
					self.sections = sectionList
					self.currentDate = 0
					self.items = [] // 为了简便，最新的数据来了就清空原来的列表数据，加载当前最新的数据，此时不用更新界面，等数据加载到了自然更新
					NotificationCenter.default.post(name: Notification.Name(rawValue: "Reload"), object: nil)
					self.sendNotification()
				} // 另一种情况是两次请求的数据没有变化，那么就不做任何处理
			}
		}
	}

	// 加载某日的数据，每次数据加载的请求发送之后这个方法就会被触发
	func reloadData() {
		if self.sections.count > 0 { // 如果日期列表不为空就加载当前已经加载到的日期对应的数据
			gankAPI.loadDateGanks(sections[currentDate]) {
				[unowned self] data in

				if data is NSError {
					return self.loadingView.showState(.error)
				}

				let itemList = data as! [GankItem]
				print("Reloaded Data Ganks \(self.sections[self.currentDate].date!)")
				self.items.append(self.sections[self.currentDate].date! as AnyObject)
				itemList.forEach { self.items.append($0) }
				self.updateUI()
				self.loadingView.showState(self.items.count > 0 ? .idle : .empty)
				self.currentDate += 1
			}
		} else { // 如果日期列表为空就先加载日期列表sections
			reloadSections()
		}
	}

	// NSUserNotificationCenterDelegate
	// http://stackoverflow.com/questions/11814903/send-notification-to-mountain-lion-notification-center
	func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
		return true
	}

	// 发送系统通知
	func sendNotification() {
		let notification = NSUserNotification()
		notification.title = "干货集中营"
		notification.informativeText = "客官，有新的干货啦，快点趁热吃了吧!"
		// notification.contentImage = NSImage(named: "AppIcon") // 并非用来设置通知的logo
		notification.soundName = NSUserNotificationDefaultSoundName
		NSUserNotificationCenter.default.deliver(notification)
	}

	// 刷新界面
	func updateUI() {
		tableView.reloadData()
		lastUpdatedLabel.stringValue = "更新时间: \(format.string(from: Date()))"
	}

	// MARK: Actions
	@IBAction func toggleGankButton(_ sender: AnyObject) {
		OpenUrlAction.perform(withPath: "https://gank.io/", closeAfterLaunch: true)
	}

	@IBAction func toggleSettingsButton(_ sender: NSView) {
		SettingAction.makeSettingMenu(sender)
	}
}

// 列表的数据源
extension GankViewController: NSTableViewDataSource {

	func numberOfRows(in aTableView: NSTableView) -> Int {
		return items.count
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		loadOlderIfNeeded(row) // 判断是否需要加载更早的数据
		return GankSectionCell.view(tableView, owner: self, subject: items[row]) ?? GankItemCell.view(tableView, owner: self, subject: items[row])
	}

	fileprivate func loadOlderIfNeeded(_ row: Int) {
		if items.count - row == 1 { // ph设置的值是15，我这里设置的是下拉到底时才触发加载新数据，节省流量
			NotificationCenter.default.post(name: Notification.Name(rawValue: "Reload"), object: nil)
		}
	}

}

// 列表的动作代理
extension GankViewController: NSTableViewDelegate {

	func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
		return (items[row] as? String) != nil // 显示日期的是GroupRow
	}

	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return (items[row] as? String) != nil ? 45 : tableView.rowHeight // GroupRow高度是45
	}

	func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		if loadingView.currentState != LoadingState.idle { // 在出错界面中点击item无效，不执行任何操作
			return true
		}
		if let item = items[row] as? GankItem {
			OpenUrlAction.perform(withPath: item.visitUrl)
		}
		return true
	}

}

