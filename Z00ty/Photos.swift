//
//  Photos.swift
//  Z00ty
//
//  Created by GTPWTW on 2/24/15.
//  Copyright (c) 2015 pLandin. All rights reserved.
//

import UIKit

struct Photos {
    
    var phoneId: String
    var photoUrl: String
    var up: Int
    var down: Int
    var total: Int?
    var image: UIImage?
    
    init() {
        
        phoneId = ""
        photoUrl = ""
        up = 0
        down = 0
    }
}