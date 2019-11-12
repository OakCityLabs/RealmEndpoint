//
//  RealmResultsProvider.swift
//  RealmEndpoint
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import Foundation
import RealmSwift

public protocol RealmResultsProvider {
    associatedtype ObjType: Object
    var config: Realm.Configuration { get }
    var resultsFactory: ((Realm) -> Results<ObjType>)? { get }
    var dataTags: [RealmEndpointTaggable] { get }
    var results: Results<ObjType>? { get }
}

public extension RealmResultsProvider where ObjType: RealmEndpointBaseObject {

    var results: Results<ObjType>? {
        guard let realm = try? Realm(configuration: config) else {
            assertionFailure("Could not create realm.")
            return nil
        }
        return results(from: realm)
    }
    
    private func results(from realm: Realm) -> Results<ObjType> {
        if let extractorFactory = resultsFactory {
            return extractorFactory(realm)
        }
        
        var results = realm.objects(ObjType.self)
        for dataTag in dataTags {
            results = results.filter("ANY realmTags.objId = %@", dataTag.objId)
        }
        return results
    }
}
