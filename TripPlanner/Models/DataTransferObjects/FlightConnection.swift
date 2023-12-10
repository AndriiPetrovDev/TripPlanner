//
//  FlightConnection.swift
//  TripPlanner
//
//  Created by Andrii Petrov on 06.12.2023.
//

import Foundation

struct FlightConnection: Decodable, Identifiable {
  let from: String
  let to: String
  let price: Double
  let coordinates: Coordinates

  var id: String { "\(from)-\(to)" }
}
