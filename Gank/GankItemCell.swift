//
//  GankPostCell.swift <- PHPostCell.swift
//  Gank
//
//  Created by Vlado on 3/15/16.
//  Copyright © 2016 ProductHunt. All rights reserved.
//

import Cocoa

//表格的显示干货内容的单元格组件，标示符是 postCellIdentifier
class GankItemCell: NSTableCellView {

	@IBOutlet weak var typeImageView: NSImageView! // 干货类型图片
	@IBOutlet weak var whoLabel: NSTextField! // 干货推荐人
	@IBOutlet weak var descLabel: NSTextField! // 干货描述
	@IBOutlet weak var seenView: GankSeenView! // 是否已经看过，暂时没用

	fileprivate var item: GankItem? // 干货

	fileprivate let cursor = NSCursor.pointingHand()
	fileprivate var trackingArea: NSTrackingArea?
	fileprivate var mouseInside = false {
		didSet {
			updateUI()
		}
	}

	// 创建一个table cell view
	class func view(_ tableView: NSTableView, owner: AnyObject?, subject: AnyObject?) -> NSView {
		let view = tableView.make(withIdentifier: "postCellIdentifier", owner: owner) as! GankItemCell

		if let item = subject as? GankItem {
			view.setItem(item)
		}

		return view
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		commonInit()
	}

	fileprivate func commonInit() {
		wantsLayer = true

		typeImageView.wantsLayer = true
		typeImageView.layer?.masksToBounds = true
		typeImageView.layer?.cornerRadius = 3
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		trackingArea = nil
		mouseInside = false
	}

	override func resetCursorRects() {
		addCursorRect(bounds, cursor: cursor)
		cursor.set()
	}

	fileprivate func setItem(_ item: GankItem?) {
		guard let item = item else {
			return
		}

		self.item = item

		updateUI()
	}

	fileprivate func updateUI() {
		guard let item = item else {
			return
		}

		layer?.backgroundColor = mouseInside ? NSColor.gankHighlightColor().cgColor : NSColor.gankWhiteColor().cgColor

		seenView.isHidden = true

		whoLabel.stringValue = item.textWho
		descLabel.stringValue = item.textDesc
		typeImageView.image = NSImage(named: item.imageType)
	}

	fileprivate func createTrackingAreaIfNeeded() {
		if trackingArea == nil {
			trackingArea = NSTrackingArea(rect: CGRect.zero, options: [NSTrackingAreaOptions.inVisibleRect, NSTrackingAreaOptions.mouseEnteredAndExited, NSTrackingAreaOptions.activeAlways], owner: self, userInfo: nil)
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
		mouseInside = true
	}

	override func mouseExited(with theEvent: NSEvent) {
		mouseInside = false
	}
}
