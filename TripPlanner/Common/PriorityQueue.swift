//
//  PriorityQueue.swift
//  TripPlanner
//
//  Created by Andrii Petrov on 10.12.2023.
//

import Foundation

struct PriorityQueue<T> {
  private var elements: [T]
  private let sort: (T, T) -> Bool

  init(sort: @escaping (T, T) -> Bool, elements: [T] = []) {
    self.sort = sort
    self.elements = elements
    self.elements.sort(by: sort)
  }

  mutating func enqueue(_ element: T) {
    elements.append(element)
    elements.sort(by: sort)
  }

  mutating func dequeue() -> T? {
    return elements.isEmpty ? nil : elements.removeFirst()
  }
}
