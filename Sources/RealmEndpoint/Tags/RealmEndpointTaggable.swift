//
//  RealmEndpointTaggable.swift
//  RealmEndpoint
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import Foundation
import RealmSwift

public protocol RealmEndpointTaggable {
    var objId: String { get }
    var name: String { get }
    func realmTag(realm: Realm) -> RealmTag?
}

public extension RealmEndpointTaggable {
    func realmTag(realm: Realm) -> RealmTag? {
        return realm.object(ofType: RealmTag.self, forPrimaryKey: objId)
    }
}
