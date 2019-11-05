//
//  File.swift
//  
//
//  Created by Jay Lyerly on 11/5/19.
//

import Foundation
import RealmSwift

public extension Realm {
    
//    func remove(tags: [DataTaggable], from type: RealmEndpointObject.Type, in realm: Realm) {
//        realm.beginWrite()
//        remove(tags: tags, from: type)
//        do {
//            try realm.commitWrite()
//        } catch {
//            assertionFailure("Failed to commit write. \(error)")
//            realm.cancelWrite()
//        }
//    }
    
    func remove(tags: [DataTaggable],
                from type: RealmEndpointObject.Type,
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

//    func add(tags: [DataTaggable], to objs: [RealmEndpointObject], in realm: Realm) {
//        realm.beginWrite()
//        add(tags: tags, to: objs)
//        do {
//            try realm.commitWrite()
//        } catch {
//            assertionFailure("Failed to commit write. \(error)")
//            realm.cancelWrite()
//        }
//    }
    
    func add(tags: [DataTaggable],
             to objs: [RealmEndpointObject],
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

extension Object {
    
    func validObject() -> Self? {
        if super.isInvalidated {          // hmmm, self.invalidated confuses the compiler
            return nil
        } else {
            return self
        }
    }
    
}
