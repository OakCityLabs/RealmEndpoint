//
//  RealmObjectEndpoint.swift
//  RealmEndpoint
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//
import Endpoint
import Foundation
import RealmCoder
import RealmSwift

open class RealmObjectEndpoint<Payload: RealmEndpointBaseObject>: Endpoint<Payload> {

    public let config: Realm.Configuration
    public let dataTags: [DataTaggable]
    public let resultsFactory: ((Realm) -> Results<Payload>)?
    private let postParse: ((Payload, Realm) -> Void)?
    
    override open var paging: Bool {         // single realm objects don't page
        return false
    }
    
    public init(realmConfig: Realm.Configuration,
                dataTags: [DataTaggable] = [],
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
                postParse: ((Payload, Realm) -> Void)? = nil) {
        
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
    override open func parse(data: Data, page: Int = 0) throws -> Payload {
        let realm = try Realm(configuration: config)
        if page == 0 {
            try realm.remove(tags: dataTags, from: Payload.self)
        }
        let coder = RealmCoder(realm: realm, dateFormatter: dateFormatter)
        let object = try coder.decode(Payload.self, from: data)
        try realm.add(tags: dataTags, to: [object])
        if let postParse = postParse {
            realm.beginWrite()
            postParse(object, realm)
            try realm.commitWrite()
        }
        return object
    }
    
}

extension RealmObjectEndpoint: RealmResultsProvider {
    public typealias ObjType = Payload
}

//extension RealmObjectEndpoint: RealmResultsProvider {
//    typealias ObjType = Payload
//
//    var results: Results<Payload>? {
//        guard let realm = try? Realm(configuration: config) else {
//            assertionFailure("Could not create realm.")
//            return nil
//        }
//        return results(from: realm)
//    }
//    
//    private func results(from realm: Realm) -> Results<Payload> {
//        if let extractClosure = extractorFactory {
//            return extractClosure(realm)
//        }
//        
//        var results = realm.objects(Payload.self)
//        for dataTag in dataTags {
//            results = results.filter("ANY realmTags.objId = %@", dataTag.objId)
//        }
//        return results
//    }
//}
