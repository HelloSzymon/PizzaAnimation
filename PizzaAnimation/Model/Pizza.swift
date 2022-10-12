//
//  Pizza.swift
//  PizzaAnimation
//
//  Created by Szymon Wnuk on 11/10/2022.
//

import SwiftUI


    
// MARK: Pizza model and sample data

struct Pizza: Identifiable {
    var id: String = UUID().uuidString
    var pizzaImage: String
    var pizzaTitle: String
    var pizzaDescription: String
    var pizzaPrice: String
}

var pizzas: [Pizza] = [
Pizza(pizzaImage: "Pizza1", pizzaTitle: "Margharita", pizzaDescription: "Tomatoes, mozzarella di buffalla, basil", pizzaPrice: "PLN 15"),
Pizza(pizzaImage: "Pizza2", pizzaTitle: "Caprisiosa", pizzaDescription: "Tomatoes, mozzarella di buffalla, olives, salami, mushrooms, paprika", pizzaPrice: "PLN 20"),
Pizza(pizzaImage: "Pizza3", pizzaTitle: "Funghi", pizzaDescription: "Tomatoes, mozzarella di buffalla, mushrooms ,basil", pizzaPrice: "PLN 18"),
]
