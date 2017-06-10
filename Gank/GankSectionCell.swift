//
//  GankSectionCell.swift <- PHSectionCell.swift
//  Gank
//
//  Created by Vlado on 3/16/16.
//  Copyright © 2016 ProductHunt. All rights reserved.
//

import Cocoa

//表格的显示时间的区域单元格组件，标示符是 sectionCellIdentifier
class GankSectionCell: NSTableCellView {

	class func view(_ tableView: NSTableView, owner: AnyObject?, subject: AnyObject?) -> NSView? {
		guard let section = subject as? String else {
			return nil
		}

		let view = tableView.make(withIdentifier: "sectionCellIdentifier", owner: owner) as! GankSectionCell
		view.textField?.stringValue = section
		return view
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		wantsLayer = true
		layer?.backgroundColor = NSColor.gankWhiteColor().cgColor
	}
}
