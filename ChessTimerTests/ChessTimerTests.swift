// Created by Manuel Lopez on 3/6/21.

import XCTest
@testable import ChessTimer

class ChessActionHandlerTests: XCTestCase {

  func test_actionsForState_onStateOnlyStartsTimer() {
    XCTAssertEqual(StateActionHandler.actions(for: .on), [.startTimer])
  }

  func test_actionsForState_offStateInvalidatesTimer() {
    XCTAssertTrue(StateActionHandler.actions(for: .off).contains(.invalidateTimer))
  }

  func test_actionsForState_offStateTurnsPlayerOneOff() {
    XCTAssertTrue(StateActionHandler.actions(for: .off).contains(.playerOneOff))
  }

  func test_actionsForState_offStateTurnsPlayerTwoOff() {
    XCTAssertTrue(StateActionHandler.actions(for: .off).contains(.playerTwoOff))
  }

  func test_actionsForState_restartStateInvalidatesTimer() {
    XCTAssertTrue(StateActionHandler.actions(for: .restart).contains(.invalidateTimer))
  }

  func test_actionsForState_restartStateResetsPlayerTimeRemaining() {
    XCTAssertTrue(StateActionHandler.actions(for: .restart).contains(.resetPlayerTimeRemaining))
  }

  func test_actionsForState_restartStateTurnsPlayerOneOff() {
    XCTAssertTrue(StateActionHandler.actions(for: .restart).contains(.playerOneOff))
  }

  func test_actionsForState_restartStateTurnsPlayerTwoOff() {
    XCTAssertTrue(StateActionHandler.actions(for: .restart).contains(.playerTwoOff))
  }

  func test_actionsForState_restartStateResetsTimerLabel() {
    XCTAssertTrue(StateActionHandler.actions(for: .restart).contains(.resetTimerLabel))
  }

  func test_actionsForState_restartStateResetsTurnButton() {
    XCTAssertTrue(StateActionHandler.actions(for: .restart).contains(.resetTurnButton))
  }

  func test_actionsForState_playerOneTurnStateTurnsPlayerOneOn() {
    XCTAssertTrue(StateActionHandler.actions(for: .playerOneTurn).contains(.playerOneOn))
  }

  func test_actionsForState_playerOneTurnStateTurnsPlayerTwoOff() {
    XCTAssertTrue(StateActionHandler.actions(for: .playerOneTurn).contains(.playerTwoOff))
  }

  func test_actionsForState_playerTwoTurnStateTurnsPlayerOneOff() {
    XCTAssertTrue(StateActionHandler.actions(for: .playerTwoTurn).contains(.playerOneOff))
  }

  func test_actionsForState_playerTwoTurnStateTurnsPlayerTwoOn() {
    XCTAssertTrue(StateActionHandler.actions(for: .playerTwoTurn).contains(.playerTwoOn))
  }

  func test_actionsForState_gameInProgressStateUpdatesTimeRemainingLabel() {
    XCTAssertTrue(StateActionHandler.actions(for: .gameInProgress).contains(.updateTimeRemainingLabel))
  }

  func test_actionsForState_gameInProgressStateEndsTurn() {
    XCTAssertTrue(StateActionHandler.actions(for: .gameInProgress).contains(.endTurn))
  }

}
