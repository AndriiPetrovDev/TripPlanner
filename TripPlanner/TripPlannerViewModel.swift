//
//  TripPlannerViewModel.swift
//  TripPlanner
//
//  Created by Andrii Petrov on 06.12.2023.
//

import Combine
import Foundation

final class TripPlannerViewModel: ObservableObject {
  @Published var cheapestRoutePrice: String?
  @Published var tripDescription: String = ""

  @Published var selectedDeparture: String = ""
  @Published var selectedDestination: String = ""

  @Published var selectedCityNodes: [CityNode] = []
  @Published var availableCities: [String] = []

  private let flightDataService = FlightDataService()
  private var graph = FlightGraph()

  private var cancellables = Set<AnyCancellable>()

  init() {
    fetchFlightConnections()
    setupSubscriptions()
  }

  private func fetchFlightConnections() {
    flightDataService.fetchFlightData()
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          // TODO: handle error
          print(error)
        }
      }, receiveValue: { [unowned self] connections in
        self.graph = FlightGraph()

        connections.forEach { connection in
          self.graph.addConnection(connection)
        }
        self.availableCities = Array(self.graph.cities.keys)
        self.selectedDeparture = self.availableCities.first ?? ""
        self.selectedDestination = self.availableCities.last ?? ""
      })
      .store(in: &cancellables)
  }

  private func setupSubscriptions() {
    $selectedDeparture
      .combineLatest($selectedDestination)
      .sink { [unowned self] selectedDeparture, selectedDestination in
        let result = graph.findCheapestRoute(from: selectedDeparture, to: selectedDestination)

        switch result.cost {
        case Double.greatestFiniteMagnitude:
          self.cheapestRoutePrice = nil
          self.tripDescription = "There is no route between these cities"
        case 0:
          self.tripDescription = "The departure and destination cities are the same"
          self.cheapestRoutePrice = nil
        default:
          self.cheapestRoutePrice = String(format: "%.2f $", result.cost)

          self.tripDescription = result.path.map(\.name).joined(separator: " -> ")
        }

        self.selectedCityNodes = result.path
      }
      .store(in: &cancellables)
  }
}
