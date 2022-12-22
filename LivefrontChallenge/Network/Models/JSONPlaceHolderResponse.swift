//
//  JSONPlaceHolderResponse.swift
//  LivefrontChallenge
//
//  Created by Kris Steigerwald on 12/22/22.
//

import Foundation

/// Represents a post with the following properties:
/// - `id`: The unique identifier for the post.
/// - `userId`: The unique identifier for the user who created the post.
/// - `title`: The title of the post.
/// - `body`: The body of the post.
struct JSONPlaceHolderResponse: Decodable {
  /// The unique identifier for the post.
  let id: Int
  /// The unique identifier for the user who created the post.
  let userId: Int
  /// The title of the post.
  let title: String
  /// The body of the post.
  let body: String
}
