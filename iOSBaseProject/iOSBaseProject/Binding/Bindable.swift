//
//  Bindable.swift
//  iOSBaseProject
//
//  Created by Andre Jordan on 2023-01-20.
//

import Foundation

/**
    Class that lets us listen to updates of the value of type T
    T: the type of value we want to listen to
 */
class Bindable<T> {
    
    typealias DynamicCompletion = ((T) -> Void)
    
    var value: T {
        didSet {
            self.notify()
        }
    }
    
    private var observers = [String: DynamicCompletion]()
    
    init(_ value: T) {
        self.value = value
    }
    
    public func addObserver(_ observer: NSObject, completion: @escaping DynamicCompletion) {
        observers[observer.description] = completion
    }
    
    public func addAndNotify(observer: NSObject, completion: @escaping DynamicCompletion) {
        self.addObserver(observer, completion: completion)
        self.notify()
    }
    
    public func removeObserver(_ observer: NSObject) {
        observers.removeValue(forKey: observer.description)
    }
    
    private func notify() {
        observers.forEach({ $0.value(value) })
    }
    
    deinit {
        observers.removeAll()
    }
 
}
