//
//  Data.swift
//  Todoey
//
//  Created by Scott Wachtler on 6/12/18.
//  Copyright © 2018 Scott Wachtler. All rights reserved.
//

import Foundation
import RealmSwift

class Data : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
    
    
}
