//
//  UIView+Combine.swift
//  testCombine
//
//  Created by leetaek on 2023/07/04.
//

import Combine
import UIKit

extension UIButton {
  func tapPublisher() -> AnyPublisher<Void,Never> {
    return publisher(for: .touchUpInside)
      .map{ _ in}
      .eraseToAnyPublisher()
  }
}

extension UITextField {
  func textPublisher() -> AnyPublisher<String, Never> {
    return publisher(for: .editingChanged)
      .map{ $0 as! UITextField }
      .map{ $0.text! }
      .eraseToAnyPublisher()
  }
}
