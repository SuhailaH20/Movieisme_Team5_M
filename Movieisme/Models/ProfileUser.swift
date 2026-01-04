//
//  ProfileUser.swift
//  Movieisme
//
//  Created by شهد عبدالله القحطاني on 08/07/1447 AH.


import Foundation

struct ProfileUser {
    var firstName: String
    var lastName: String
    var email: String
    var imageName: String
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
