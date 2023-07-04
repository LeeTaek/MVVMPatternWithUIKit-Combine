//
//  UIControl+Combine.swift
//  testCombine
//
//  Created by leetaek on 2023/07/04.
//

import Combine
import UIKit

extension UIControl {
  func publisher(for event: UIControl.Event) -> UIControlPublisher {
    return UIControlPublisher(control: self, events: event)
  }
  
  struct UIControlPublisher: Publisher {
    typealias Output = UIControl
    typealias Failure = Never
    
    private let control: UIControl
    private let events: UIControl.Event
    
    init(control: UIControl, events: UIControl.Event) {
      self.control = control
      self.events = events
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIControl == S.Input {
      let subscription = UIControlSubscription(subscriber: subscriber, control: control, events: events)
      subscriber.receive(subscription: subscription)
    }
  }
}


final class UIControlSubscription<S: Subscriber>: Subscription where S.Input == UIControl, S.Failure == Never {
  private var subscriber: S?
  private var control: UIControl
  private var events: UIControl.Event
  
  init(subscriber: S, control: UIControl, events: UIControl.Event) {
    self.subscriber = subscriber
    self.control = control
    self.events = events
    
    self.control.addTarget(self, action: #selector(eventHandler), for: events)
  }
  
  func request(_ demand: Subscribers.Demand) {
  }
  
  func cancel() {
    subscriber = nil
    control.removeTarget(self, action: #selector(eventHandler), for: events)
  }
  
  @objc private func eventHandler() {
    _ = subscriber?.receive(control)
  }
}


