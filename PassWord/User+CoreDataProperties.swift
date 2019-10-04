//
//  User+CoreDataProperties.swift
//  PassWord
//
//  Created by 泛白的红砖 on 2019/10/2.
//  Copyright © 2019 DaiJiAn. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var password: String?

}
