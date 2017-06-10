//
//  NSColor+Gank.swift <- NSColor+ProductHunt.swift
//  Gank
//
//  Created by Vlado on 3/24/16.
//  Copyright © 2016 ProductHunt. All rights reserved.
//

import Cocoa

//颜色值的扩展
extension NSColor {

	class func gankWhiteColor() -> NSColor {
		return NSColor.white
	}

	class func gankHighlightColor() -> NSColor {
		return NSColor(calibratedRed: 249 / 255, green: 249 / 255, blue: 249 / 255, alpha: 1)
	}

	class func gankOrangeColor() -> NSColor {
		return NSColor(calibratedRed: 228 / 255, green: 81 / 255, blue: 39 / 255, alpha: 1)
	}

	class func gankGrayColor() -> NSColor {
		return NSColor(calibratedRed: 153 / 255, green: 153 / 255, blue: 153 / 255, alpha: 1)
	}

	class func gankLightGrayColor() -> NSColor {
		return NSColor(calibratedRed: 204 / 255, green: 204 / 255, blue: 208 / 255, alpha: 1)
	}
}
