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

	private let cursor = NSCursor.pointingHandCursor() // 手指鼠标
	private var normalStateImage: NSImage? // 正常状态下的图片 off state
	private var highlightedStateImage: NSImage? // 高亮状态下的图片 on state
	private var trackingArea: NSTrackingArea? // 在指定区域内鼠标进入的时候变成手指

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

	func setImages(normalImage: String, highlitedImage: String) {
		self.setButtonType(.MomentaryChangeButton)

		normalStateImage = NSImage(named: normalImage)
		highlightedStateImage = NSImage(named: highlitedImage)
	}

	func resetTrackingArea() {
		trackingArea = nil

		if let normalStateImage = normalStateImage {
			image = normalStateImage
		}
	}

	private func createTrackingAreaIfNeeded() {
		if trackingArea == nil {
			trackingArea = NSTrackingArea(rect: CGRect.zero, options: [.InVisibleRect, .MouseEnteredAndExited, .ActiveAlways], owner: self, userInfo: nil)
		}
	}

	override func updateTrackingAreas() {
		super.updateTrackingAreas()

		createTrackingAreaIfNeeded()

		if !trackingAreas.contains(trackingArea!) {
			addTrackingArea(trackingArea!)
		}
	}

	override func mouseEntered(theEvent: NSEvent) {
		if let highlightedImage = highlightedStateImage {
			image = highlightedImage
		}
	}

	override func mouseExited(theEvent: NSEvent) {
		if let normalStateImage = normalStateImage {
			image = normalStateImage
		}
	}
}
