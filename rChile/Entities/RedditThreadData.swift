//
//  RedditThreadData.swift
//  rChile
//
//  Created by Magik on 27/5/23.
//

import Foundation

// MARK: - RedditThreadData
struct RedditThreadData: Codable {
    let after: String
    let children: [Child]
}
