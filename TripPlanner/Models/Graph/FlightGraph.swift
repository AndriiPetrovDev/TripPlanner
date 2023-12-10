//
//  FlightGraph2.swift
//  TripPlanner
//
//  Created by Andrii Petrov on 09.12.2023.
//

import Foundation

final class FlightGraph {
  private(set) var cities: [String: CityNode] = [:]

  func addConnection(_ connection: FlightConnection) {
    let fromCity = addCity(name: connection.from, coordinate: connection.coordinates.from)
    let toCity = addCity(name: connection.to, coordinate: connection.coordinates.to)
    let connection = FlightConnectionEdge(from: fromCity, to: toCity, price: connection.price)

    fromCity.connections.append(connection)
  }

  func findCheapestRoute(from startName: String, to endName: String) -> (cost: Double, path: [CityNode]) {
    // Ensure the start city exists
    guard let start = cities[startName],
          let end = cities[endName] else {
      return (Double.greatestFiniteMagnitude, [])
    }

    guard startName != endName else {
      return (0, [start])
    }

    // Dictionary to store the minimum cost to reach each city
    var minimumCosts = [String: Double]()
    // Dictionary to store the predecessor of each city on the cheapest path
    var predecessors = [String: String]()
    // PriorityQueue to select the next city to process based on the current cost
    var priorityQueue = PriorityQueue<CityNode>(sort: { minimumCosts[$0.name, default: Double.greatestFiniteMagnitude] < minimumCosts[
      $1.name,
      default: Double.greatestFiniteMagnitude
    ] })

    // Initialize costs and enqueue all cities
    for city in cities.values {
      minimumCosts[city.name] = city.name == startName ? 0 : Double.greatestFiniteMagnitude
      priorityQueue.enqueue(city)
    }

    // Dijkstra's algorithm
    while let city = priorityQueue.dequeue() {
      for edge in city.connections {
        let newCost = minimumCosts[city.name]! + edge.price
        if let toEdge = edge.to,
           newCost < minimumCosts[toEdge.name, default: Double.greatestFiniteMagnitude] {
          minimumCosts[toEdge.name] = newCost
          predecessors[toEdge.name] = city.name
          priorityQueue.enqueue(toEdge) // Reorder the priority queue
        }
      }
    }

    // Constructing the path from end to start
    var path: [CityNode] = []
    var currentCityName = endName
    while let predecessorName = predecessors[currentCityName], let currentCity = cities[currentCityName] {
      path.insert(currentCity, at: 0)
      currentCityName = predecessorName
      if currentCityName == startName, let startCity = cities[startName] {
        path.insert(startCity, at: 0)
        break
      }
    }

    let totalCost = minimumCosts[endName] ?? Double.greatestFiniteMagnitude
    return (totalCost, path)
  }

  private func addCity(name: String, coordinate: Coordinate) -> CityNode {
    if let city = cities[name] {
      return city
    } else {
      let city = CityNode(name: name, coordinate: coordinate)
      cities[name] = city
      return city
    }
  }
}

