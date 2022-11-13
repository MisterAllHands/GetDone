//
//  Categories.swift
//  ToDo-App
//
//  Created by TTGMOTSF on 10/11/2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
