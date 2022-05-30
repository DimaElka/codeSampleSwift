//
//  String+Validation.swift
//  Mir
//
//  Created by Dmitry Rogov on 07.12.2021.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
      let emailRegEx = "[A-Z0-9a-z._-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,3}"

      let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
      return emailPred.evaluate(with: self)
    }
}
