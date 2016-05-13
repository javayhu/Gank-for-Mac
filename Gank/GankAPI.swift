//
//  DataFetcher.swift
//  Gank
//
//  Created by hujiawei on 2016/5/11.
//  Copyright © 2016年 Tsinghua University. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//干货数据访问类
class GankAPI {

	typealias CallBack = (AnyObject?) -> Void

	// 获取指定日期干货数据的URL前缀
	let API_TODAY = "https://gank.io/api/day/"
	// 获取所有发过日报的日期列表
	let API_DATES = "https://gank.io/api/day/history"

	// 今天的数据访问的url后缀
	func buildTodayUrl() -> String {
		let format = NSDateFormatter()
		format.dateFormat = "yyyy/MM/dd"
		return format.stringFromDate(NSDate())
	}

	// 加载指定日期的数据
	func loadDateGanks(section: GankSection, callback: CallBack) {
		print("Load Date Ganks")

		// let section = GankSection(date: "2016-05-13")
		let url = API_TODAY + section.buildDayUrl()! // buildTodayUrl()

		Alamofire.request(.GET, url).responseJSON { response in
			// response.result是一个枚举，如果是Success的话有个关联值Value，如果是Failure的话有个关联值Error
			switch response.result {
			case .Failure(let error):
				print("Load Date Ganks Failed")
				print(error)
				callback(error) // 如果失败的话将错误error传给回调函数
			case .Success:
				print("Load Date Ganks Success")
				var itemList = [GankItem]()
				if let value = response.result.value {
					let json = JSON(value), results = json["results"], categories = json["category"]
					for category in categories.arrayValue {
						if let items = results[category.stringValue].array {
							itemList += items.map { return GankItem.parse($0) }
						}
					}
				}
				callback(itemList) // 如果成功的话将数据列表传给回调函数
			}
		} // responseJSON最后一个参数是闭包 completionHandler: Response<AnyObject, NSError> -> Void
	}

	// 加载所有发过日报的日期列表
	func loadAllDates(callback: CallBack) {
		print("Load All Dates")

		Alamofire.request(.GET, API_DATES).responseJSON { response in
			switch response.result {
			case .Failure(let error):
				print("Load All Dates Failed")
				print(error)
				callback(error)
			case .Success:
				print("Load All Dates Success")

				var sections = [GankSection]()
				if let value = response.result.value {
					let json = JSON(value), results = json["results"].arrayValue
					for date in results {
						sections.append(GankSection(date: date.stringValue))
					}
				}
				callback(sections)
			}
		}

	}

}
