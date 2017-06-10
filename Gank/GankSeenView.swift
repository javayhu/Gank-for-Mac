//
//  GankSectionCell.swift <- PHSeenView.swift
//  Gank
//
//  Created by Vlado on 3/17/16.
//  Copyright © 2016 ProductHunt. All rights reserved.
//

import Cocoa

//表示没看过的小圆点，暂时没有利用
class GankSeenView: NSView {

	override func awakeFromNib() {
		super.awakeFromNib()

		wantsLayer = true
		layer?.backgroundColor = NSColor.gankOrangeColor().cgColor
	}

	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)

		layer?.cornerRadius = dirtyRect.size.height / 2 // 小圆点
	}
}
