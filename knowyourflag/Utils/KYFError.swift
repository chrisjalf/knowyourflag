//
//  KYFError.swift
//  knowyourflag
//
//  Created by Chris James on 16/06/2024.
//

import Foundation

enum KYFError: String, Error {
    case invalidUrl = "Url is invalid"
    case unableToComplete = "Unable to complete your request"
    case unableToEncode = "Unable to encode request"
    case invalidData = "Data received from the server is invalid"
    case unableToDecode = "Unable to decode data received from the server"
    case error = "Something went wrong"
}
