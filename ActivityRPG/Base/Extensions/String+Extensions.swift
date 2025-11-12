//
//  String+Extensions.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 09/11/2025.
//

import Foundation

extension String {
    var firstUppercased: String {
        guard let first = first else { return self }
        return first.uppercased() + dropFirst()
    }
}
