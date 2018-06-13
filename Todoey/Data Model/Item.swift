//
//  Item.swift
//  Todoey
//
//  Created by Scott Wachtler on 6/12/18.
//  Copyright © 2018 Scott Wachtler. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self , property: "items")
    
}
