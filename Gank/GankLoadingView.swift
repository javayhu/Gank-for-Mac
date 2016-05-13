//
//  GankLoadingView.swift <- PHLoadingView.swift
//  Gank
//
//  Created by Vlado on 3/17/16.
//  Copyright © 2016 ProductHunt. All rights reserved.
//

import Cocoa

//加载界面的状态，分别是 正在加载，出现错误，内容为空，空闲状态
enum LoadingState {
	case Loading, Error, Empty, Idle
}

//加载界面
class GankLoadingView: NSView {

	@IBOutlet weak var loadingIndicator: NSProgressIndicator! // 进度圈
	@IBOutlet weak var loadingLabel: NSTextField! // 提示信息
	@IBOutlet weak var reload: GankButton! // 重新加载按钮

	var currentState: LoadingState? // 当前状态

	override func awakeFromNib() {
		super.awakeFromNib()

		wantsLayer = true
		layer?.backgroundColor = NSColor.gankWhiteColor().CGColor
	}

	// 显示某个状态
	func showState(state: LoadingState) {
		switch state {
		case .Loading:
			hidden = false
			reload.hidden = true
			loadingIndicator.hidden = false
			loadingIndicator.startAnimation(nil)
			loadingLabel.stringValue = "客官，请稍等..."
			currentState = .Loading

		case .Error:
			hidden = false
			reload.hidden = false
			loadingIndicator.hidden = true
			loadingIndicator.stopAnimation(nil)
			loadingLabel.stringValue = "客官，出错啦!!!"
			currentState = .Error

		case .Empty:
			hidden = false
			reload.hidden = false
			loadingIndicator.hidden = true
			loadingIndicator.stopAnimation(nil)
			loadingLabel.stringValue = "客官，没货啦..."
			currentState = .Empty

		case .Idle:
			hidden = true
			loadingIndicator.stopAnimation(nil)
			currentState = .Idle
		}
	}

	@IBAction func toggleReloadButton(sender: NSView) {
		showState(.Loading)

		// 发送加载数据的请求
		NSNotificationCenter.defaultCenter().postNotificationName("Reload", object: nil)
	}
}
