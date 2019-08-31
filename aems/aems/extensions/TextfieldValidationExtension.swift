//
//  TextfieldValidationExtension.swift
//  aems
//
//  Created by aems aems on 6/8/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit.UITextField

extension UITextField {
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return try validator.validated(self.text!)
    }
}
