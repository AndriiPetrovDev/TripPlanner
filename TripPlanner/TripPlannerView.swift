//
//  TripPlannerView.swift
//  TripPlanner
//
//  Created by Andrii Petrov on 06.12.2023.
//
import SwiftUI

struct TripPlannerView: View {
  @ObservedObject var viewModel: TripPlannerViewModel

  @State var departureInput: String = ""

  @FocusState private var isDepartureInputFocused: Bool

  @State private var activeTextFieldFrame: CGRect = .zero
  @State private var showSuggestions = false

  var body: some View {
    NavigationView {
      VStack {
        HStack {
          VStack {
            // Departure City Picker
            if !viewModel.availableCities.isEmpty {
              Text("Departure City")
              Picker("Departure City", selection: $viewModel.selectedDeparture) {
                ForEach(viewModel.availableCities, id: \.self) { city in
                  Text(city).tag(city)
                }
              }
              .pickerStyle(MenuPickerStyle())
            }
          }

          Spacer()
          Text("➡")
            .font(.title)
          Spacer()

          VStack {
            // Destination City Picker
            if !viewModel.availableCities.isEmpty {
              Text("Destination City")
              Picker("Destination City", selection: $viewModel.selectedDestination) {
                ForEach(viewModel.availableCities, id: \.self) { city in
                  Text(city).tag(city)
                }
              }
              .pickerStyle(MenuPickerStyle())
            }
          }
        }

        Spacer()

        Text("Cheapest Route")
          .font(.headline)
        Text(viewModel.tripDescription)
          .multilineTextAlignment(.center)
        if let price = viewModel.cheapestRoutePrice {
          Text(price)
            .font(.largeTitle)
        }

        mapView
      }
      .navigationBarTitle("Trip Planner", displayMode: .inline)
      .padding()
    }
  }

  private var mapView: some View {
    MapView(cities: viewModel.selectedCityNodes)
  }
}

#Preview {
  TripPlannerView(viewModel: TripPlannerViewModel())
}
