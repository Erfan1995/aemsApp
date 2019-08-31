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
            ValidationError(" کود مرکز رای دهی ضروری است!")
        }
        guard let voteNumber = Int(value) else{throw
            ValidationError("کود مرکز رای دهی باید عدد باشد!")
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
            throw ValidationError("تکرار کلمه عبور ضروری می باشد!")
        }
        guard firstPassword == value else {
            throw ValidationError("کلمات عبور باهم تطابق ندارد!")
        }
        return value
    }
}

class phoneValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError("شماره تماس ضروری می باشد!")}
        guard let phone = Int(value) else {throw ValidationError("شماره تماس باشد عدد باشد!")}
        guard value.count == 10 else {throw ValidationError("شماره تماس باید ۱۰ عدد باشد!")}
       
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
            throw ValidationError("فورم نباید خالی باشد! " + fieldName)
        }
        return value
    }
}

struct UserNameValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else{
            throw ValidationError("نام ضروری می باشد!")
        }
        guard value.count >= 3 else {
            throw ValidationError("نام باید بیشتر از سه حرف داشته باشد!" )
        }
        guard value.count < 18 else {
            throw ValidationError("نام باید کمتر از ۱۸ حرف داشته باشد!" )
        }
        
        return value
    }
}

struct PasswordValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError("کلمه عبور ضروری می باشد!")}
        guard value.count >= 6 else { throw ValidationError("کلمه عبور حداقل باید ۶ حرف باشد!") }
        return value
    }
}


