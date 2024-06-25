//
//  ProfileResponse.swift
//  knowyourflag
//
//  Created by Chris James on 25/06/2024.
//

import Foundation

struct ProfileResponse: Decodable {
    var id: Int
    var email: String
    var name: String
}
