//
//  Todo.swift
//  Project
//
//  Created by 이경미 on 2024/06/17.
//

import Foundation

struct Todo{
    var title: String
    var date: Date
    var isComplated: Bool
    
    init(title:String, date:Date){
        self.title = title
        self.date = date
        self.isComplated = false
    }
}
