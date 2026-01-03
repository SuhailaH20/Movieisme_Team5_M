//
//  Cast.swift
//  Movieisme
//
//  Created by Suhaylah hawsawi on 06/07/1447 AH.
//

import Foundation

struct Director: Codable {
    let name: String
    let image: String
}

struct Actor: Codable, Identifiable {
    var id = UUID()
    let name: String
    let image: String
}
