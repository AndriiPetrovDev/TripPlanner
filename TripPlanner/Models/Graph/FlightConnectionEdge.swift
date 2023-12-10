//
//  FlightConnectionEdge.swift
//  TripPlanner
//
//  Created by Andrii Petrov on 09.12.2023.
//

import Foundation

final class FlightConnectionEdge {
  weak var from: CityNode?
  weak var to: CityNode?
  let price: Double

  init(from: CityNode, to: CityNode, price: Double) {
    self.from = from
    self.to = to
    self.price = price
  }
}
