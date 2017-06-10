//
//  GankScrollView.swift <- PHTableView.swift
//  Gank
//
//  Created by Vlado on 3/17/16.
//  Copyright © 2016 ProductHunt. All rights reserved.
//

import Cocoa

//滚动组件
class GankScrollView: NSScrollView {

	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)

		// 下面的代码在滚动组件的底部加上了1像素的横线
		let layer = CALayer()
		layer.borderColor = NSColor.windowBackgroundColor.cgColor
		layer.borderWidth = 1
		layer.frame = NSRect(x: 0, y: dirtyRect.size.height - 1, width: dirtyRect.size.width, height: 1)
		self.layer?.addSublayer(layer)
	}
}
