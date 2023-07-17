//
//  Imagemodel.swift
//  LoginUI
//
//  Created by Odles on 17/07/23.
//

import Foundation
 

struct Imagemodel : Codable {
    var total : Int?
    var total_pages : Int?
    var results : [Results]?
}

struct Results : Codable {
    var urls : url?
}
struct url : Codable {
    var full : String?
}

