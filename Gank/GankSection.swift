//
//  GankSection.swift
//  Gank
//
//  Created by hujiawei on 2016/5/13.
//  Copyright © 2016年 Tsinghua University. All rights reserved.
//

import Foundation

//干货的日报
class GankSection {

	var date: String? // 日期，从http://gank.io/api/day/history接口获取的原始字符串，例如2016-05-13
	var items: [GankItem]? // 数据

	init(date: String?, items: [GankItem]?) {
		self.date = date
		self.items = items
	}

	convenience init(date: String?) {
		self.init(date: date, items: nil)
	}

}

extension GankSection {
	// 构造成每日数据所需的结构，将“-”替换成“/”即可
	func urlSuffix() -> String? {
		if let date = self.date {
			return date.replacingOccurrences(of: "-", with: "/")
		}
		return nil
	}
}
