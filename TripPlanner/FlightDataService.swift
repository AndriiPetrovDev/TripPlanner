//
//  FlightDataService.swift
//  TripPlanner
//
//  Created by Andrii Petrov on 06.12.2023.
//

import Foundation
import Combine

final class FlightDataService {
    func fetchFlightData() -> AnyPublisher<[FlightConnection], Error> {
        guard let url = URL(string: "https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/connections.json") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: FlightData.self, decoder: JSONDecoder())
            .map { $0.connections }
            .eraseToAnyPublisher()
    }
}
