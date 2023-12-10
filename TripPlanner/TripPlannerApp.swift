//
//  TripPlannerApp.swift
//  TripPlanner
//
//  Created by Andrii Petrov on 06.12.2023.
//

import SwiftUI

@main
struct TripPlannerApp: App {
  var body: some Scene {
    WindowGroup {
      TripPlannerView(viewModel: TripPlannerViewModel())
    }
  }
}
