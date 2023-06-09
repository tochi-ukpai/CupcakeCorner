//
//  Order.swift
//  CupcakeCorner
//
//  Created by Theós on 07/06/2023.
//

import SwiftUI

final class Order: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, address
    }
    
    enum AddressCodingKeys: CodingKey {
        case name, streetAddress, city, zip
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidAddress: Bool {
        !(name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty)
    }
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2
        
        // complicated cakes cost more
        cost += (Double(type) / 2)
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)

        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        
        var addressContainer = container.nestedContainer(keyedBy: AddressCodingKeys.self, forKey: .address)
        try addressContainer.encode(name, forKey: .name)
        try addressContainer.encode(streetAddress, forKey: .streetAddress)
        try addressContainer.encode(city, forKey: .city)
        try addressContainer.encode(zip, forKey: .zip)
        
        
    }
    
    init() { }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)

        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        
        
        let addressContainer = try container.nestedContainer(keyedBy: AddressCodingKeys.self, forKey: .address)
        
        name = try addressContainer.decode(String.self, forKey: .name)
        streetAddress = try addressContainer.decode(String.self, forKey: .streetAddress)
        city = try addressContainer.decode(String.self, forKey: .city)
        zip = try addressContainer.decode(String.self, forKey: .zip)
    }
}
