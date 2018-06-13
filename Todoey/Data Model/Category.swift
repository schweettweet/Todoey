//
//  Category.swift
//  Todoey
//
//  Created by Scott Wachtler on 6/12/18.
//  Copyright © 2018 Scott Wachtler. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
