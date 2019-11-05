//
//  RealmEndpointObject.swift
//  RealmEndpoint
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import Foundation
import RealmSwift

open class RealmEndpointObject: Object {
    @objc open dynamic var objId: String = "-1"

    open var realmTags = List<RealmTag>()

    override open class func primaryKey() -> String? {
        return "objId"
    }
    
}

public extension List where Element: RealmEndpointObject {
    
    func contains(item: Element) -> Bool {
        let idsList = self.map { return $0.objId }
        return idsList.contains(item.objId)
    }
    
}
