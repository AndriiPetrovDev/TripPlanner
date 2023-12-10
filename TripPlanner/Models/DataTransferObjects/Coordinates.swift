//
//  Coordinates.swift
//  TripPlanner
//
//  Created by Andrii Petrov on 09.12.2023.
//

import Foundation

struct Coordinate: Decodable {
  let lat: Double
  let long: Double
}

struct Coordinates: Decodable {
  let from: Coordinate
  let to: Coordinate
}
