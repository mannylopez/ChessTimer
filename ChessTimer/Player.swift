// Created by Manuel Lopez on 3/7/21.

import UIKit

class Player {

  // MARK: Properties
  var startTime: TimeInterval
  var timeRemaining: TimeInterval
  var isTurn: Bool

  // MARK: Methods
  init(startTime: TimeInterval) {
    self.startTime = startTime
    self.timeRemaining = startTime
    self.isTurn = false
  }
}
