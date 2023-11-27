//
//  Pokemon.swift
//  MobileDayExample
//
//  Created by Chad Garrett on 2023/11/27.
//

import Foundation
import RealmSwift

final class Pokemon: Object, Codable {
    @Persisted var name: String
    @Persisted var level: Int
    @Persisted var experience: Int
}
