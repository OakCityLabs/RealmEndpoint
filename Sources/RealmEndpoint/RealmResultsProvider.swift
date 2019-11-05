//
//  File.swift
//  
//
//  Created by Jay Lyerly on 11/5/19.
//

import Foundation
import RealmSwift

protocol RealmResultsProvider {
    associatedtype ObjType: Object
    var results: Results<ObjType>? { get }
}
