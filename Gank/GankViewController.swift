//
//  GankViewController.swift
//  Gank
//
//  Created by Vlado on 3/14/16.
//  Copyright © 2016 ProductHunt. All rights reserved.
//

import Cocoa

//主界面窗口
class GankViewController: NSViewController {

	@IBOutlet weak var tableView: NSTableView! // 表格组件
	@IBOutlet weak var loadingView: GankLoadingView! // 加载界面
	@IBOutlet weak var lastUpdatedLabel: NSTextField! // 上次更新时间
	@IBOutlet weak var homeButton: GankButton! // 首页按钮
	@IBOutlet weak var settingsButton: GankButton! // 设置按钮

	var currentDate = 0 // 当前需要加载的日报的编号
	var sections = [GankSection]() // 干货日报
	var items = [AnyObject]() // 数据列表，包括
	let gankAPI = GankAPI() // 干货API工具类
	let format = NSDateFormatter() // 格式化更新时间

	override func viewDidLoad() {
		super.viewDidLoad()

		view.wantsLayer = true
		view.layer?.backgroundColor = NSColor.gankWhiteColor().CGColor

		format.dateFormat = "yyyy-MM-dd HH:mm:ss" // 更新时间的显示格式
		tableView.intercellSpacing = NSSize.zero // 列表单元格间隔为0
		lastUpdatedLabel.stringValue = "" // 初始时为空字符串
		loadingView.showState(.Loading) // 进入之后首先显示加载界面

		// 注册监听，原本是放在viewWillAppear中的，但是这样容易导致每次进入都会reload，此外这个监听并不取消，应用关闭自然取消
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadData), name: "Reload", object: nil)
		// 发送加载数据的请求
		NSNotificationCenter.defaultCenter().postNotificationName("Reload", object: nil)
	}

	// 重新加载数据
	func reloadData() {
		if self.sections.count > 0 { // 不为空就加载第一个section对应的数据
			self.gankAPI.loadDateGanks(sections[currentDate]) {
				[unowned self] data in

				if data is NSError {
					self.loadingView.showState(.Error)
				} else {
					let itemList = data as! [GankItem]
					print("Reloaded Data Ganks \(self.sections[self.currentDate].date!)")
					self.items.append(self.sections[self.currentDate].date!)
					itemList.forEach { self.items.append($0) }
					self.tableView.reloadData()
					self.updateUI()
					self.loadingView.showState(self.items.count > 0 ? .Idle : .Empty)
					self.currentDate += 1
				}
			}
		} else { // sections为空就先加载sections
			gankAPI.loadAllDates {
				[unowned self] data in

				if data is NSError {
					self.loadingView.showState(.Error)
				} else {
					self.sections = data as! [GankSection]
					if self.sections.isEmpty { // 如果sections是空那就是没有数据，当然这不可能发生，这是为了避免循环
						self.loadingView.showState(.Empty)
					} else { // 再次发送数据加载请求
						NSNotificationCenter.defaultCenter().postNotificationName("Reload", object: nil)
					}
				}
			}
		}
	}

	// 刷新界面
	func updateUI() {
		lastUpdatedLabel.stringValue = "更新时间: \(format.stringFromDate(NSDate()))"
	}

	// MARK: Actions
	@IBAction func toggleGankButton(sender: AnyObject) {
		OpenUrlAction.perform(withPath: "https://gank.io/", closeAfterLaunch: true)
	}

	@IBAction func toggleSettingsButton(sender: NSView) {
		SettingAction.makeSettingMenu(sender)
	}
}

// 列表的数据源
extension GankViewController: NSTableViewDataSource {

	func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
		return items.count
	}

	func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
		loadOlderIfNeeded(row) // 判断是否需要加载更早的数据
		return GankSectionCell.view(tableView, owner: self, subject: items[row]) ?? GankItemCell.view(tableView, owner: self, subject: items[row])
	}

	private func loadOlderIfNeeded(row: Int) {
		if items.count - row == 1 { // ph设置的值是15，我这里设置的是下拉到底时才触发加载新数据，节省流量
			NSNotificationCenter.defaultCenter().postNotificationName("Reload", object: nil)
		}
	}

}

// 列表的动作代理
extension GankViewController: NSTableViewDelegate {

	func tableView(tableView: NSTableView, isGroupRow row: Int) -> Bool {
		return (items[row] as? String) != nil // 显示日期的是GroupRow
	}

	func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return (items[row] as? String) != nil ? 45 : tableView.rowHeight // GroupRow高度是45
	}

	func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		if loadingView.currentState != LoadingState.Idle { // 在出错界面中点击item无效，不执行任何操作
			return true
		}
		if let item = items[row] as? GankItem {
			OpenUrlAction.perform(withPath: item.url)
		}
		return true
	}

}

