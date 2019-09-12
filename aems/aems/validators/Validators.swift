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
        case .requiredField(let fieldName): return RequiredFieldValidator(fieldName)
        case .phone: return phoneValidator()
        case .pollsterCode: return pollsterCodeValidator()
        }
    }
}
struct pollsterCodeValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw
            ValidationError(AppLanguage().Locale(text: "required"))
        }
        if Int(value) == nil {
            throw ValidationError(AppLanguage().Locale(text: "number"))
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
            throw ValidationError(AppLanguage().Locale(text: "required"))
        }
        guard firstPassword == value else {
            throw ValidationError(AppLanguage().Locale(text: "donotMatch"))
        }
        return value
    }
}

class phoneValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError(AppLanguage().Locale(text: "requied"))}
        if Int(value) == nil{
            throw ValidationError(AppLanguage().Locale(text: "number"))
        }
        guard value.count == 10 else {throw ValidationError(AppLanguage().Locale(text: "size10"))}
       
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
            throw ValidationError("\(AppLanguage().Locale(text: "required"))" + fieldName)
        }
        return value
    }
}

struct UserNameValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else{
            throw ValidationError(AppLanguage().Locale(text: "required"))
        }
        guard value.count >= 3 else {
            throw ValidationError(AppLanguage().Locale(text: "min3"))
        }
        guard value.count < 18 else {
            throw ValidationError(AppLanguage().Locale(text: "max18") )
        }
        
        return value
    }
}

struct PasswordValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError(AppLanguage().Locale(text: "required"))}
        guard value.count >= 6 else { throw ValidationError(AppLanguage().Locale(text: "min6")) }
        return value
    }
}


