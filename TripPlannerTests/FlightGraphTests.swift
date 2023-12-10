//
//  FlightGraphTests.swift
//  TripPlannerTests
//
//  Created by Andrii Petrov on 09.12.2023.
//

@testable import TripPlanner
import XCTest

final class FlightGraphTests: XCTestCase {
  var flightGraph: FlightGraph!

  override func setUp() {
    super.setUp()
    flightGraph = FlightGraph()

    let json = """
    {
      "connections": [
        {
          "from": "London",
          "to": "Tokyo",
          "coordinates": {
            "from": {
              "lat": 51.5285582,
              "long": -0.241681
            },
            "to": {
              "lat": 35.652832,
              "long": 139.839478
            }
          },
          "price": 220
        },
        {
          "from": "Tokyo",
          "to": "London",
          "coordinates": {
            "from": {
              "lat": 35.652832,
              "long": 139.839478
            },
            "to": {
              "lat": 51.5285582,
              "long": -0.241681
            }
          },
          "price": 200
        },
        {
          "from": "London",
          "to": "Porto",
          "price": 50,
          "coordinates": {
            "from": {
              "lat": 51.5285582,
              "long": -0.241681
            },
            "to": {
              "lat": 41.14961,
              "long": -8.61099
            }
          }
        },
        {
          "from": "Tokyo",
          "to": "Sydney",
          "price": 100,
          "coordinates": {
            "from": {
              "lat": 35.652832,
              "long": 139.839478
            },
            "to": {
              "lat": -33.865143,
              "long": 151.2099
            }
          }
        },
        {
          "from": "Sydney",
          "to": "Cape Town",
          "price": 200,
          "coordinates": {
            "from": {
              "lat": -33.865143,
              "long": 151.2099
            },
            "to": {
              "lat": -33.918861,
              "long": 18.4233
            }
          }
        },
        {
          "from": "Cape Town",
          "to": "London",
          "price": 800,
          "coordinates": {
            "from": {
              "lat": -33.918861,
              "long": 18.4233
            },
            "to": {
              "lat": 51.5285582,
              "long": -0.241681
            }
          }
        },
        {
          "from": "London",
          "to": "New York",
          "price": 400,
          "coordinates": {
            "from": {
              "lat": 51.5285582,
              "long": -0.241681
            },
            "to": {
              "lat": 40.73061,
              "long": -73.935242
            }
          }
        },
        {
          "from": "New York",
          "to": "Los Angeles",
          "price": 120,
          "coordinates": {
            "from": {
              "lat": 40.73061,
              "long": -73.935242
            },
            "to": {
              "lat": 34.052235,
              "long": -118.243683
            }
          }
        },
        {
          "from": "Los Angeles",
          "to": "Tokyo",
          "price": 150,
          "coordinates": {
            "from": {
              "lat": 34.052235,
              "long": -118.243683
            },
            "to": {
              "lat": 35.652832,
              "long": 139.839478
            }
          }
        }
      ]
    }
    """

    let jsonData = Data(json.utf8)

    let flightConnections = try! JSONDecoder().decode(FlightData.self, from: jsonData)

    for connection in flightConnections.connections {
      flightGraph.addConnection(connection)
    }
  }

  override func tearDown() {
    flightGraph = nil
    super.tearDown()
  }

  func testDirectFlight() {
    let result = flightGraph.findCheapestRoute(from: "London", to: "Tokyo")
    XCTAssertEqual(result.cost, 220)
  }

  func testIndirectCycleFlight() {
    let result = flightGraph.findCheapestRoute(from: "Tokyo", to: "London")
    XCTAssertEqual(result.cost, 200)
  }

  func testIndirectFlight() {
    let result = flightGraph.findCheapestRoute(from: "London", to: "Sydney")
    XCTAssertEqual(result.cost, 320)
  }

  func testIndirectCycleFlight1() {
    let result = flightGraph.findCheapestRoute(from: "London", to: "Cape Town")
    XCTAssertEqual(result.cost, 520)
  }

  func testIndirectCycleFlight2() {
    let result = flightGraph.findCheapestRoute(from: "Cape Town", to: "Porto")
    XCTAssertEqual(result.cost, 850)
  }

  func testIndirectCycleFlight3() {
    let result = flightGraph.findCheapestRoute(from: "Tokyo", to: "Sydney")
    XCTAssertEqual(result.cost, 100)
  }

  func testIndirectCycleFlight4() {
    let result = flightGraph.findCheapestRoute(from: "Sydney", to: "Tokyo")
    XCTAssertEqual(result.cost, 1220)
  }

  func testNoFlight() {
    let result = flightGraph.findCheapestRoute(from: "Porto", to: "Tokyo")
    XCTAssertEqual(result.cost, Double.greatestFiniteMagnitude)
    XCTAssertTrue(result.path.isEmpty)
  }
}
