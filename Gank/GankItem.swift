//
//  GankItem.swift
//  Gank
//
//  Created by hujiawei on 2016/5/12.
//  Copyright © 2016年 Tsinghua University. All rights reserved.
//

import Foundation
import SwiftyJSON

//干货，只是解析了返回数据中的需要字段
class GankItem {

	var type: String // 分类
	var url: String // 对应网址
	var desc: String // 描述
	var who: String // 推荐人

	init(type: String, url: String, desc: String, who: String) {
		self.type = type
		self.url = url
		self.desc = desc
		self.who = who
	}

	// 将返回的json串中的一个item转换成GankItem
	class func parse(item: JSON) -> GankItem {
		return GankItem(type: item["type"].stringValue, url: item["url"].stringValue,
			desc: item["desc"].stringValue, who: item["who"].stringValue)
	}

}

//扩展的用于界面显示的方法和属性
extension GankItem {

	var typeImageMap: [String: String] {
		return ["iOS": "icon-ios", "Android": "icon-android", "前端": "icon-html5",
			"瞎推荐": "icon-slack", "福利": "icon-image", "休息视频": "icon-video"] // 不同类型对应的图片
	}

	var textWho: String {
		return self.who == "" ? "who" : self.who
	}

	var textDesc: String {
		return self.desc
	}

	var imageType: String {
		return self.typeImageMap[self.type] ?? "icon-gank"
	}

}

//使用String(gankItem)可以得到该string，用于打印查看信息
extension GankItem: CustomStringConvertible {
	var description: String {
		return "{type=\(type), desc=\(desc), who=\(who), url=\(url)}"
	}
}
