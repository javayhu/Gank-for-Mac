//
//  OpenUrlAction.swift
//  Gank
//
//  Created by hujiawei on 2016/5/13.
//  Copyright © 2016年 Tsinghua University. All rights reserved.
//

import Cocoa

//打开网址链接的操作
class OpenUrlAction {

	class func perform(withPath path: String, closeAfterLaunch: Bool = false) {
		perform(withUrl: NSURL(string: path)!, closeAfterLaunch: closeAfterLaunch)
	}

	class func perform(withUrl url: NSURL, closeAfterLaunch: Bool = false) {
		let handle = NSWorkspace.sharedWorkspace().openURL(url)

		if handle && closeAfterLaunch {
			PopoverAction.close()
		}
	}

}