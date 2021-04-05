// Created by Manuel Lopez on 3/7/21.

import UIKit

class Player {

  // MARK: Properties
  var startTime: TimeInterval
  var timeRemaining: TimeInterval
  var isTurn: Bool

  // MARK: Methods


  init(startTime: TimeInterval, timeRemaining: TimeInterval, isTurn: Bool = false) {
    self.startTime = startTime
    self.timeRemaining = timeRemaining
    self.isTurn = isTurn
  }
}
