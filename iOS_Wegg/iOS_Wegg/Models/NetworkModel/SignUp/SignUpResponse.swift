//
//  SignUpResponse.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.01.
//

struct SignUpResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: SignUpResult
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case result
    }
}

struct SignUpResult: Decodable {
    let userID: Int
    let createdAt: String
    let contactFriends: [ContactFriend]?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case createdAt
        case contactFriends
    }
}

struct ContactFriend: Decodable {
    let friendID: Int
    let accountID: String
    let name: String
    let profileImage: String?
    let phone: String
    
    enum CodingKeys: String, CodingKey {
        case friendID = "friendId"
        case accountID = "accountId"
        case name
        case profileImage
        case phone
    }
}
