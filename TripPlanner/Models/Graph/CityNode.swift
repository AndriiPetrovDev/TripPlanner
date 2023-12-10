//
//  CityNode.swift
//  TripPlanner
//
//  Created by Andrii Petrov on 09.12.2023.
//

import Foundation

final class CityNode {
  let name: String
  let coordinate: Coordinate
  var connections: [FlightConnectionEdge]

  init(name: String, coordinate: Coordinate) {
    self.name = name
    self.coordinate = coordinate
    connections = []
  }
}
