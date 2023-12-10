//
//  MapView.swift
//  TripPlanner
//
//  Created by Andrii Petrov on 06.12.2023.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
  var cities: [CityNode]

  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    return mapView
  }

  func updateUIView(_ uiView: MKMapView, context: Context) {
    uiView.removeAnnotations(uiView.annotations)
    uiView.removeOverlays(uiView.overlays)

    let annotations = createAnnotations(for: cities)
    uiView.addAnnotations(annotations)

    let polyline = createPolyline(for: cities)
    uiView.addOverlay(polyline)

    let zoomRect = mapRect(for: annotations, and: polyline)
    uiView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView

    init(_ parent: MapView) {
      self.parent = parent
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      let identifier = "CustomAnnotation"

      var view: MKMarkerAnnotationView
      if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
        dequeuedView.annotation = annotation
        view = dequeuedView
      } else {
        view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      }

      if annotation is StartAnnotation {
        view.markerTintColor = .white
        view.glyphText = "🛫" // Start
      } else if annotation is FinishAnnotation {
        view.markerTintColor = .white
        view.glyphText = "🛬" // Finish
      } else if annotation is MiddleAnnotation {
        view.markerTintColor = .gray
        view.glyphText = "⚫️" // Middle
      }

      view.canShowCallout = true
      return view
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      if let polyline = overlay as? MKPolyline {
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
      }
      return MKOverlayRenderer(overlay: overlay)
    }
  }

  func createAnnotations(for cities: [CityNode]) -> [MKAnnotation] {
    var annotations: [MKPointAnnotation] = []

    for (index, city) in cities.enumerated() {
      let annotation: MKPointAnnotation

      if index == 0 {
        annotation = StartAnnotation()
      } else if index == cities.count - 1 {
        annotation = FinishAnnotation()
      } else {
        annotation = MiddleAnnotation()
      }

      annotation.title = city.name
      annotation.coordinate = CLLocationCoordinate2D(latitude: city.coordinate.lat, longitude: city.coordinate.long)
      annotations.append(annotation)
    }

    return annotations
  }

  func createPolyline(for cities: [CityNode]) -> MKPolyline {
    let coordinates = cities.map { CLLocationCoordinate2D(latitude: $0.coordinate.lat, longitude: $0.coordinate.long) }
    return MKPolyline(coordinates: coordinates, count: coordinates.count)
  }

  func mapRect(for annotations: [MKAnnotation], and polyline: MKPolyline) -> MKMapRect {
    var zoomRect = MKMapRect.null

    for annotation in annotations {
      let annotationPoint = MKMapPoint(annotation.coordinate)
      let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
      zoomRect = zoomRect.union(pointRect)
    }

    let polylineRect = polyline.boundingMapRect
    zoomRect = zoomRect.union(polylineRect)

    return zoomRect
  }
}

final class StartAnnotation: MKPointAnnotation {
  // Custom properties if needed
}

final class FinishAnnotation: MKPointAnnotation {
  // Custom properties if needed
}

final class MiddleAnnotation: MKPointAnnotation {
  // Custom properties if needed
}
