//
//  RealmResultsProvider.swift
//  RealmEndpoint
//
//  Created by Jay Lyerly on 11/5/19.
//  Copyright © 2019 Oak City Labs. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmResultsProvider {
    associatedtype ObjType: Object
    var results: Results<ObjType>? { get }
}
