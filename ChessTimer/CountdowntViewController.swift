// Created by Manuel Lopez on 4/5/21.

import UIKit

enum State {
  case on
  case off
  case restart
  case playerOneTurn
  case playerTwoTurn
  case gameInProgress
}

final class StateActionHandler {
  enum Action {
    case playerOneOn
    case playerOneOff
    case resetPlayerTimeRemaining
    case playerTwoOn
    case playerTwoOff
    case startTimer
    case invalidateTimer
    case resetTimerLabel
    case resetTurnButton
    case updateTimeRemainingLabel
    case endTurn
    }

  static func actions(for state: State) -> [Action] {
    switch state {
    case .on:
      return [.startTimer]
    case .off:
      return [.invalidateTimer, .playerOneOff, .playerTwoOff]
    case .restart:
      return [.invalidateTimer, .resetPlayerTimeRemaining, .playerOneOff, .playerTwoOff, .resetTimerLabel, .resetTurnButton]
    case .playerOneTurn:
      return [.playerOneOn, .playerTwoOff]
    case .playerTwoTurn:
      return [.playerOneOff, .playerTwoOn]
    case .gameInProgress:
      return [.updateTimeRemainingLabel, .endTurn]
    }
  }
}

class CountdowntViewController: UIViewController, TimePickerDelegate {

  // MARK: - Properties
  var timer: Timer?
  let playerOne: Player
  let playerTwo: Player
  let timerLabelTop: UILabel
  let timerLabelBottom: UILabel
  let stackView: UIStackView
  let setTimeButton: UIButton
  let pauseTimeButton: UIButton
  let restartTimeButton: UIButton
  let endTurnButtonTop: UIButton
  let endTurnButtonBottom: UIButton
  var gearImage = UIImage(systemName: "gearshape.fill")
  var pauseImage = UIImage(systemName: "pause")
  var arrowClockwiseImage = UIImage(systemName: "arrow.clockwise")
  var state = State.off {
    didSet {
      let actions = StateActionHandler.actions(for: state)
      for action in actions {
        switch action {
        case .startTimer:
          timer = startTimer()
        case .invalidateTimer:
          timer?.invalidate()
        case .playerOneOff:
          playerOne.isTurn = false
        case .playerTwoOff:
          playerTwo.isTurn = false
        case .playerOneOn:
          playerOne.isTurn = true
          endTurnButtonTop.backgroundColor = UIColor(red: 0.117, green: 0.796, blue: 0.882, alpha: 1) // Cyan color
          endTurnButtonBottom.backgroundColor = .systemGray5
        case .playerTwoOn:
          playerTwo.isTurn = true
          endTurnButtonTop.backgroundColor = .systemGray5
          endTurnButtonBottom.backgroundColor = UIColor(red: 0.117, green: 0.796, blue: 0.882, alpha: 1) // Cyan color
        case .resetPlayerTimeRemaining:
          playerOne.timeRemaining = playerOne.startTime
          playerTwo.timeRemaining = playerTwo.startTime
        case .resetTimerLabel:
          timerLabelTop.text = "\(timeFormatted(playerOne.startTime))"
          timerLabelBottom.text = "\(timeFormatted(playerTwo.startTime))"
        case .resetTurnButton:
          endTurnButtonTop.backgroundColor = .white
          endTurnButtonBottom.backgroundColor = .white
          endTurnButtonTop.isEnabled = true
          endTurnButtonBottom.isEnabled = true
        case .updateTimeRemainingLabel:
          if playerOne.isTurn, playerOne.timeRemaining > 0 {
            playerOne.timeRemaining -= 1
            timerLabelTop.text = "\(timeFormatted(playerOne.timeRemaining))"
          }
          if playerTwo.isTurn, playerTwo.timeRemaining > 0 {
            playerTwo.timeRemaining -= 1
            timerLabelBottom.text = "\(timeFormatted(playerTwo.timeRemaining))"
          }
        case .endTurn:
          if playerOne.isTurn, playerOne.timeRemaining == 0 {
            endTurnButtonTop.backgroundColor = .red
            timer?.invalidate()
            endTurnButtonTop.isEnabled = false
            endTurnButtonBottom.isEnabled = false
          }

          if playerTwo.isTurn, playerTwo.timeRemaining == 0 {
            endTurnButtonBottom.backgroundColor = .red
            timer?.invalidate()
            endTurnButtonTop.isEnabled = false
            endTurnButtonBottom.isEnabled = false
          }
        }
      }
    }
  }

  init() {
    playerOne = Player(startTime: 5)
    playerTwo = Player(startTime: 5)
    timerLabelTop = UILabel()
    timerLabelBottom = UILabel()
    stackView = UIStackView()
    setTimeButton = UIButton()
    pauseTimeButton = UIButton()
    restartTimeButton = UIButton()
    endTurnButtonTop = UIButton()
    endTurnButtonBottom = UIButton()

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // MARK: Button set up
    let heavyConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .heavy)
    gearImage = gearImage?.withConfiguration(heavyConfiguration)
    pauseImage = pauseImage?.withConfiguration(heavyConfiguration)
    arrowClockwiseImage = arrowClockwiseImage?.withConfiguration(heavyConfiguration)

    setTimeButton.setImage(gearImage, for: .normal)
    setTimeButton.addTarget(self, action: #selector(setTimeButtonPressed), for: .touchUpInside)
    pauseTimeButton.setImage(pauseImage, for: .normal)
    pauseTimeButton.addTarget(self, action: #selector(pauseButtonPressed), for: .touchUpInside)
    restartTimeButton.setImage(arrowClockwiseImage, for: .normal)
    restartTimeButton.addTarget(self, action: #selector(restartTimeButtonPressed), for: .touchUpInside)

    // MARK: buttonEndTurnTop
    endTurnButtonTop.addTarget(self, action: #selector(endTurnTopButtonPressed), for: .touchUpInside)
    view.addSubview(endTurnButtonTop)
    endTurnButtonTop.translatesAutoresizingMaskIntoConstraints = false
    endTurnButtonTop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    endTurnButtonTop.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    endTurnButtonTop.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    endTurnButtonTop.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true

    // MARK: buttonEndTurnBottom
    endTurnButtonBottom.addTarget(self, action: #selector(endTurnBottomButtonPressed), for: .touchUpInside)
    view.addSubview(endTurnButtonBottom)
    endTurnButtonBottom.translatesAutoresizingMaskIntoConstraints = false
    endTurnButtonBottom.topAnchor.constraint(equalTo: endTurnButtonTop.bottomAnchor).isActive = true
    endTurnButtonBottom.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    endTurnButtonBottom.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    endTurnButtonBottom.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    // MARK: labelTimerTop
    view.addSubview(timerLabelTop)
    timerLabelTop.text = "\(timeFormatted(playerOne.startTime))"
    timerLabelTop.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    timerLabelTop.font = timerLabelTop.font.withSize(60)
    timerLabelTop.translatesAutoresizingMaskIntoConstraints = false
    timerLabelTop.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    timerLabelTop.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6).isActive = true

    // MARK: labelTimerBottom
    view.addSubview(timerLabelBottom)
    timerLabelBottom.text = "\(timeFormatted(playerTwo.startTime))"
    timerLabelBottom.font = timerLabelBottom.font.withSize(60)
    timerLabelBottom.translatesAutoresizingMaskIntoConstraints = false
    timerLabelBottom.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    timerLabelBottom.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1.6).isActive = true

    // MARK: stackView
    view.addSubview(stackView)
    stackView.axis = NSLayoutConstraint.Axis.horizontal
    stackView.distribution = UIStackView.Distribution.fillEqually

    stackView.addArrangedSubview(setTimeButton)
    stackView.addArrangedSubview(pauseTimeButton)
    stackView.addArrangedSubview(restartTimeButton)

    stackView.backgroundColor = .white
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
  }

  // MARK: - METHODS
  func timeFormatted(_ totalSeconds: TimeInterval) -> String {
    let seconds: Int = Int(totalSeconds) % 60
    let minutes: Int = Int((totalSeconds / 60)) % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }

  func startTimer() -> Timer {
    let countdownTimer = Timer.scheduledTimer(
      timeInterval: 1.0,
      target: self,
      selector: #selector(updateTime),
      userInfo: nil,
      repeats: true)

    return countdownTimer
  }

  @objc func updateTime() {
    state = State.gameInProgress
  }

  @objc func endTurnTopButtonPressed(_ sender: UIButton) {
    if playerOne.isTurn == false && playerTwo.isTurn == false {
      state = State.on
    }
    state = State.playerTwoTurn
  }

  @objc func endTurnBottomButtonPressed(_ sender: UIButton) {
    if playerOne.isTurn == false && playerTwo.isTurn == false {
      state = State.on
    }
    state = State.playerOneTurn
  }

  @objc func setTimeButtonPressed(_ sender: UIButton) {
    let timePickerVC = TimePickerViewController()
    present(timePickerVC, animated: true, completion: nil)
    timePickerVC.timePickerDelegate = self
  }

  @objc func pauseButtonPressed(_ sender: UIButton) {
    state = State.off
  }

  @objc func restartTimeButtonPressed(_ sender: UIButton) {
    state = State.restart
  }

  func timeSelected(timeInterval: TimeInterval) {
    playerOne.startTime = timeInterval
    playerTwo.startTime = timeInterval
    state = State.restart
  }
}
