//
//  ViewModel.swift
//  testCombine
//
//  Created by leetaek on 2023/07/03.
//

import Foundation
import Combine

protocol Bindable {
  associatedtype Input
  associatedtype Output
  
  func transform(input: Input) -> Output
}


final class ViewModel: Bindable  {

  struct Input {
    let userName: AnyPublisher<String, Never>
    let password: AnyPublisher<String, Never>
    let passwordReenter: AnyPublisher<String, Never>
  }
  
  struct Output {
    let buttonIsValid: AnyPublisher<Bool, Never>
  }
  
  func transform(input: Input) -> Output {
    let buttonStatePublisher = input.userName
      .combineLatest(input.password, input.passwordReenter)
      .print()
      .map { user, password, reenter in
        user.count > 2 &&
        password.count > 3 &&
        password == reenter
      }
      .eraseToAnyPublisher()
    
    return Output(buttonIsValid: buttonStatePublisher)
  }
  
  
}
