//
//  FutureExtension.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/28/22.
//

import Foundation
import Combine

/// Extension of `Future` that allows for async functions to be converted into a `Future` object.
/// - Parameters:
///   - asyncFunc: An async function that returns an Output and throws an Error.
extension Future where Failure == Error {

    /// Convenience initializer for creating a `Future` object from an async function.
      /// - Parameter asyncFunc: The async function to be converted into a `Future` object.
    convenience init(asyncFunc: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let result = try await asyncFunc()
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
