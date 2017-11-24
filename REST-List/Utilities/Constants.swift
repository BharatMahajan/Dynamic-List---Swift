//
//  Constants.swift
//  REST-List
//
//  Created by Er. Bharat Mahajan on 07/11/17.
//  Copyright © 2017 Er. Bharat Mahajan. All rights reserved.
//
import UIKit

struct Constants {
    static let baseURL = "http://www.mocky.io/v2/59f2e79c2f0000ae29542931"
    static let DateApiFormat = "yyyy-MM-dd HH:mm:ss"
    static let DateUIFormat = "MMM dd,yyyy"
 
}

class CommonFunctions{
    static func formatDate(datePublish: String?) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = Constants.DateApiFormat
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateUIFormat
        
        let date: Date? = dateFormatterGet.date(from: datePublish!)
        return dateFormatter.string(from: date!)
    }
}
