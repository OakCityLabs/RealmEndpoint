//
//  Realm.swift
//  RealmEndpoint
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import Foundation
import RealmSwift

public extension Realm {
    
    func remove(tags: [DataTaggable],
                from type: RealmEndpointBaseObject.Type,
                inTransaction: Bool = true) throws {
        if inTransaction {
            beginWrite()
        }
        
        for tag in tags {
            let realmTag = tag.realmTag(realm: self)
            let taggedObjects = objects(type)
                .filter("ANY realmTags.objId = %@", tag.objId)
            for taggedObject in taggedObjects {
                if let realmTag = realmTag,
                    let idx = taggedObject.realmTags.index(of: realmTag) {
                    taggedObject.realmTags.remove(at: idx)
                }
            }
        }
        
        if inTransaction {
            try commitWrite()
        }
    }
    
    func add(tags: [DataTaggable],
             to objs: [RealmEndpointBaseObject],
             inTransaction: Bool = true) throws {
        if inTransaction {
            beginWrite()
        }
        
        for tag in tags {
            let realmTag = tag.realmTag(realm: self)
            for obj in objs {
                // Only add if it doesn't already have the tag
                if let realmTag = realmTag, !obj.realmTags.contains(realmTag) {
                    obj.realmTags.append(realmTag)
                }
            }
        }
        
        if inTransaction {
            try commitWrite()
        }
    }
    
}

