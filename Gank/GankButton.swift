//
//  GankButton.swift <- PHButton.swift
//  Gank
//
//  Created by Vlado on 3/24/16.
//  Copyright © 2016 ProductHunt. All rights reserved.
//

import Cocoa

// 按钮，鼠标进入按钮区域会显示为手指状态
class GankButton: NSButton {

	fileprivate let cursor = NSCursor.pointingHand() // 手指鼠标
	fileprivate var normalStateImage: NSImage? // 正常状态下的图片 off state
	fileprivate var highlightedStateImage: NSImage? // 高亮状态下的图片 on state
	fileprivate var trackingArea: NSTrackingArea? // 在指定区域内鼠标进入的时候变成手指

	override func resetCursorRects() {
		addCursorRect(bounds, cursor: cursor)
		cursor.set()
	}

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		commonInit()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		commonInit()
	}

	func commonInit() {
	}

	func setImages(_ normalImage: String, highlitedImage: String) {
		self.setButtonType(.momentaryChange)

		normalStateImage = NSImage(named: normalImage)
		highlightedStateImage = NSImage(named: highlitedImage)
	}

	func resetTrackingArea() {
		trackingArea = nil

		if let normalStateImage = normalStateImage {
			image = normalStateImage
		}
	}

	fileprivate func createTrackingAreaIfNeeded() {
		if trackingArea == nil {
			trackingArea = NSTrackingArea(rect: CGRect.zero, options: [.inVisibleRect, .mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
		}
	}

	override func updateTrackingAreas() {
		super.updateTrackingAreas()

		createTrackingAreaIfNeeded()

		if !trackingAreas.contains(trackingArea!) {
			addTrackingArea(trackingArea!)
		}
	}

	override func mouseEntered(with theEvent: NSEvent) {
		if let highlightedImage = highlightedStateImage {
			image = highlightedImage
		}
	}

	override func mouseExited(with theEvent: NSEvent) {
		if let normalStateImage = normalStateImage {
			image = normalStateImage
		}
	}
}
