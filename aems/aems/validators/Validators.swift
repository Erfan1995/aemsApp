//
//  Validators.swift
//  aems
//
//  Created by aems aems on 6/8/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import Foundation
class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}
protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}
enum ValidatorType {
    
    case password
    case matchPassword(password: String)
    case username
    case voteNumber
    case requiredField(field: String)
    case phone
    case pollsterCode
}
enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .password: return PasswordValidator()
        case .matchPassword(let password): return matchPasswordValidator(password)
        case .username: return UserNameValidator()
        case .voteNumber: return voteNumberValidator()
        case .requiredField(let fieldName): return RequiredFieldValidator(fieldName)
        case .phone: return phoneValidator()
        case .pollsterCode: return pollsterCodeValidator()
        }
    }
}
struct pollsterCodeValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw
            ValidationError(" pollster code  is required")
        }
        guard let voteNumber = Int(value) else{throw
            ValidationError("pollster code must be a number")
        }
        return value
    }
    
}
struct matchPasswordValidator: ValidatorConvertible {
    private let firstPassword: String
    init(_ password: String) {
        firstPassword = password
    }
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {
            throw ValidationError("confirm password cannot be empty")
        }
        guard firstPassword == value else {
            throw ValidationError("passwords don't match")
        }
        return value
    }
}
struct voteNumberValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw
            ValidationError(" vote number is required")
        }
        guard let voteNumber = Int(value) else{throw
            ValidationError("vote must be a number")
        }
        guard value.count > 200 else {throw
            ValidationError("vote can't be more than 200")
        }
        
        return value
    }
}


class phoneValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError("Phone is required")}
        guard let phone = Int(value) else {throw ValidationError("Phone must be a number!")}
        guard value.count == 10 else {throw ValidationError("phone number should be 10 digits")}
       
        return value
    }
}

struct RequiredFieldValidator: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {
            throw ValidationError("Required field " + fieldName)
        }
        return value
    }
}

struct UserNameValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else{
            throw ValidationError("Username is required")
        }
        guard value.count >= 3 else {
            throw ValidationError("Username must contain more than three characters" )
        }
        guard value.count < 18 else {
            throw ValidationError("Username shoudn't conain more than 18 characters" )
        }
        
        return value
    }
}

struct PasswordValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError("Password is Required")}
        guard value.count >= 6 else { throw ValidationError("Password must have at least 6 characters") }
        return value
    }
}


