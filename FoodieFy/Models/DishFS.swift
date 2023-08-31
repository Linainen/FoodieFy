//
//  PlateFS.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 25.08.23.
//

import Foundation

struct DishFS {
    let name: String?
    let description: String?
    let category: String?
    let price: Double?
    var isPopular: Bool?
    var isNew: Bool?
    
    var priceDescription: String {
        return "\(price ?? 0) BYN"
    }
}
