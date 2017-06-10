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

	let API_TODAY = "https://gank.io/api/day/" // 获取指定日期干货数据的URL前缀
	let API_DATES = "https://gank.io/api/day/history" // 获取所有发过日报的日期列表

	// 加载指定日期的数据
	func loadDateGanks(_ section: GankSection, callback: @escaping CallBack) {
		print("Load Date Ganks")
		let url = API_TODAY + section.urlSuffix()!

        Alamofire.request(url, method: .get).responseJSON { response in
			// response.result是一个枚举，如果是Success的话有个关联值Value，如果是Failure的话有个关联值Error
			switch response.result {
			case .failure(let error):
				print("Load Date Ganks Failed")
				// print(error)
				callback(error as AnyObject) // 如果失败的话将错误error传给回调函数
			case .success:
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
				callback(itemList as AnyObject) // 如果成功的话将数据列表传给回调函数
			}
		} // responseJSON最后一个参数是闭包 completionHandler: Response<AnyObject, NSError> -> Void
	}

	// 加载所有发过日报的日期列表
	func loadAllDates(_ callback: @escaping CallBack) {
		print("Load All Dates")

        Alamofire.request(API_DATES, method: .get).responseJSON { response in
			switch response.result {
			case .failure(let error):
				print("Load All Dates Failed")
				// print(error)
				callback(error as AnyObject)
			case .success:
				print("Load All Dates Success")

				var sections = [GankSection]()
				if let value = response.result.value {
					let json = JSON(value), results = json["results"].arrayValue
					for date in results {
						sections.append(GankSection(date: date.stringValue))
					}
				}
				callback(sections as AnyObject)
			}
		}
	}

}
