//
//  RealmTag.swift
//  RealmEndpoint
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import Foundation
import RealmSwift

open class RealmTag: Object {
    
    @objc open dynamic var objId: String = ""
    @objc open dynamic var name: String = ""
    
    override public static func primaryKey() -> String? {
        return "objId"
    }
}

public extension RealmTag {
    class func create(fromTags tags: [DataTaggable], in realm: Realm) throws {
        realm.beginWrite()
        tags.forEach { (tag) in
            let value: [String: Any] = [
                "objId": tag.objId,
                "name": tag.name
            ]
            realm.create(RealmTag.self, value: value, update: .modified)
        }
        try realm.commitWrite()
    }
}
