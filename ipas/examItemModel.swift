//
//  examItemModel.swift
//  ipas
//
//  Created by 韋儒朱 on 2018/12/6.
//  Copyright © 2018年 韋儒朱. All rights reserved.
//

import UIKit

class examItemModel {
    
    var topic: String?
    var answer: String?
    var item_A: String?
    var item_B: String?
    var item_C: String?
    var item_D: String?
    
    init(topic: String?, answer: String?, item_A: String?, item_B: String?, item_C: String?, item_D: String?){
        self.topic = topic
        self.answer = answer
        self.item_A = item_A
        self.item_B = item_B
        self.item_C = item_C
        self.item_D = item_D
    }
}
