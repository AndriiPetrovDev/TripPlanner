//
//  FlightData.swift
//  TripPlanner
//
//  Created by Andrii Petrov on 09.12.2023.
//

import Foundation

struct FlightData: Decodable {
  let connections: [FlightConnection]
}
