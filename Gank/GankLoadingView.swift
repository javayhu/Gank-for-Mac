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
	case loading, error, empty, idle
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
		layer?.backgroundColor = NSColor.gankWhiteColor().cgColor
	}

	// 显示某个状态
	func showState(_ state: LoadingState) {
		switch state {
		case .loading:
			isHidden = false
			reload.isHidden = true
			loadingIndicator.isHidden = false
			loadingIndicator.startAnimation(nil)
			loadingLabel.stringValue = "客官，请稍等..."
			currentState = .loading

		case .error:
			isHidden = false
			reload.isHidden = false
			loadingIndicator.isHidden = true
			loadingIndicator.stopAnimation(nil)
			loadingLabel.stringValue = "客官，出错啦!!!"
			currentState = .error

		case .empty:
			isHidden = false
			reload.isHidden = false
			loadingIndicator.isHidden = true
			loadingIndicator.stopAnimation(nil)
			loadingLabel.stringValue = "客官，没货啦..."
			currentState = .empty

		case .idle:
			isHidden = true
			loadingIndicator.stopAnimation(nil)
			currentState = .idle
		}
	}

	@IBAction func toggleReloadButton(_ sender: NSView) {
		showState(.loading)

		// 发送加载数据的请求
		NotificationCenter.default.post(name: Notification.Name(rawValue: "Reload"), object: nil)
	}
}
