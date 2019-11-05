//
//  File.swift
//  
//
//  Created by Jay Lyerly on 11/5/19.
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
