//
//  RealmArrayResource.swift
//  RealmEndpoint
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import Endpoint
import Foundation
import RealmCoder
import RealmSwift

open class RealmArrayEndpoint<Payload>: Endpoint<[Payload]> where Payload: RealmEndpointBaseObject {

    public let config: Realm.Configuration
    public let dataTags: [RealmEndpointTaggable]
    public let resultsFactory: ((Realm) -> Results<Payload>)?
    private let postParse: (([Payload], Realm) -> Void)?

    public init(realmConfig: Realm.Configuration,
                dataTags: [RealmEndpointTaggable] = [],
                resultsFactory: ((Realm) -> Results<Payload>)? = nil,
                serverUrl: URL?,
                pathPrefix: String,
                method: EndpointHttpMethod = .get,
                objId: String? = nil,
                pathSuffix: String? = nil,
                queryParams: [String: String] = [:],
                formParams: [String: String] = [:],
                jsonParams: [String: Any] = [:],
                mimeTypes: [String] = ["application/json"],
                contentType: String? = nil,
                statusCodes: [Int] = Array(200..<300),
                username: String? = nil,
                password: String? = nil,
                body: Data? = nil,
                dateFormatter: DateFormatter? = nil,
                postParse: (([Payload], Realm) -> Void)? = nil) {
        
        config = realmConfig
        self.dataTags = dataTags
        self.resultsFactory = resultsFactory
        self.postParse = postParse

        super.init(serverUrl: serverUrl,
                   pathPrefix: pathPrefix,
                   method: method,
                   objId: objId,
                   pathSuffix: pathSuffix,
                   queryParams: queryParams,
                   formParams: formParams,
                   jsonParams: jsonParams,
                   mimeTypes: mimeTypes,
                   contentType: contentType,
                   statusCodes: statusCodes,
                   username: username,
                   password: password,
                   body: body,
                   dateFormatter: dateFormatter)
    }
    
    @discardableResult
    override open func parse(data: Data, page: Int = 1) throws -> [Payload] {
        let realm = try Realm(configuration: config)
        if page == 0 {
            try realm.remove(tags: dataTags, from: Payload.self)
        }
        let coder = RealmCoder(realm: realm, dateFormatter: dateFormatter)
        let objects = try coder.decodeArray(Payload.self, from: data)
        try realm.add(tags: dataTags, to: objects)
        if let postParse = postParse {
            realm.beginWrite()
            postParse(objects, realm)
            try realm.commitWrite()
        }
        return objects
    }

}

extension RealmArrayEndpoint: RealmResultsProvider {
    public typealias ObjType = Payload
}
