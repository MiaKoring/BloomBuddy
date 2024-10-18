//
//  AnyEquatableError.swift
//  BloomBuddy
//
//  Created by Mia Koring on 18.10.24.
//

struct AnyEquatableError: Equatable {
    public let error: (any Error)?
    private let errorEquality: (Any, Any) -> Bool
    
    init(_ error: (any Error)?) {
        self.error = error
        self.errorEquality = { first, second in
            guard let first = first as? any Error, let second = second as? any Error else {
                return false
            }
            return String(describing: first) == String(describing: second)
        }
    }
    
    static func == (lhs: AnyEquatableError, rhs: AnyEquatableError) -> Bool {
        lhs.errorEquality(lhs.error as Any, rhs.error as Any)
    }
}
