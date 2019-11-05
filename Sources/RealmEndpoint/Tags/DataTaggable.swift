//
//  File.swift
//  
//
//  Created by Jay Lyerly on 11/5/19.
//

import Foundation
import RealmSwift

public protocol DataTaggable {
    var objId: String { get }
    var name: String { get }
    func realmTag(realm: Realm) -> RealmTag?
}

public extension DataTaggable {
    func realmTag(realm: Realm) -> RealmTag? {
        return realm.object(ofType: RealmTag.self, forPrimaryKey: objId)
    }
}
