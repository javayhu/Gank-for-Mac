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
	var date: String // 发布日期

	init(type: String, url: String, desc: String, who: String, date: String) {
		self.type = type
		self.url = url
		self.desc = desc
		self.who = who
		self.date = date
	}

	// 将返回的json串中的一个item转换成GankItem，时间 2016-05-13T11:08:37.42Z -> 2016-05-13
	class func parse(_ item: JSON) -> GankItem {
		let time = item["publishedAt"].stringValue
		return GankItem(type: item["type"].stringValue, url: item["url"].stringValue,
			desc: item["desc"].stringValue, who: item["who"].stringValue, date: time.substring(to: time.index(time.startIndex, offsetBy: 10)))
	}

}

//扩展的用于界面显示的方法和属性
extension GankItem {

	var typeImageMap: [String: String] { // 干货类型和对应的图片名称
		return ["iOS": "icon-ios", "Android": "icon-android", "前端": "icon-html5",
			"瞎推荐": "icon-slack", "福利": "icon-image", "休息视频": "icon-video"]
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

	var visitUrl: String { // 点击某个item需要访问的url
		if self.imageType != "icon-image" && self.imageType != "icon-video" {
			return self.url
		} else { // 图片和视频特殊处理，跳转到当天的干货数据页面
			return "https://gank.io/" + self.urlSuffix()
		}
	}

	// 构造成每日数据所需的结构，将“-”替换成“/”即可
	func urlSuffix() -> String {
		return date.replacingOccurrences(of: "-", with: "/")
	}
}

//使用String(gankItem)可以得到该string，用于打印查看信息
extension GankItem: CustomStringConvertible {
	var description: String {
		return "{type=\(type), desc=\(desc), who=\(who), url=\(url)}"
	}
}
