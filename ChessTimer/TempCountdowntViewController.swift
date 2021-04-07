// Created by Manuel Lopez on 4/5/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

import UIKit

class TempCountdowntViewController: UIViewController {

  var timer: Timer?
  var playerOne: Player
  var playerTwo: Player
  var timerLabelTop: UILabel
  var timerLabelBottom: UILabel
  let stackView: UIStackView
  let setTimeButton: UIButton
  let pauseTimeButton: UIButton
  let restartTimeButton: UIButton
  let endTurnButtonTop: UIButton
  let endTurnButtonBottom: UIButton
  var gearImage = UIImage(systemName: "gearshape.fill")
  var pauseImage = UIImage(systemName: "pause")
  var arrowClockwiseImage = UIImage(systemName: "arrow.clockwise")

  init() {
    playerOne = Player(startTime: 600, timeRemaining: 600)
    playerTwo = Player(startTime: 600, timeRemaining: 600)
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
//    let largeConfiguration = UIImage.SymbolConfiguration(scale: .large)
//    let smallConfiguration = UIImage.SymbolConfiguration(scale: .small)

    let heavyConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .heavy)
    arrowClockwiseImage = arrowClockwiseImage?.withConfiguration(heavyConfiguration)
    gearImage = gearImage?.withConfiguration(heavyConfiguration)
    pauseImage = pauseImage?.withConfiguration(heavyConfiguration)

    setTimeButton.setImage(gearImage, for: .normal)
    pauseTimeButton.setImage(pauseImage, for: .normal)
    restartTimeButton.setImage(arrowClockwiseImage, for: .normal)

    // MARK: buttonEndTurnTop
//    buttonEndTurnTop.backgroundColor = .darkGray
    endTurnButtonTop.addTarget(self, action: #selector(endTurnTop), for: .touchUpInside)
    view.addSubview(endTurnButtonTop)
    endTurnButtonTop.translatesAutoresizingMaskIntoConstraints = false
    endTurnButtonTop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    endTurnButtonTop.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    endTurnButtonTop.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    endTurnButtonTop.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true

    // MARK: buttonEndTurnBottom
//    buttonEndTurnBottom.backgroundColor = .lightGray
    endTurnButtonBottom.addTarget(self, action: #selector(endTurnBottom), for: .touchUpInside)
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
//    labelTimerTop.backgroundColor = .green
    timerLabelTop.translatesAutoresizingMaskIntoConstraints = false
    timerLabelTop.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    timerLabelTop.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6).isActive = true

    // MARK: labelTimerBottom
    view.addSubview(timerLabelBottom)
    timerLabelBottom.text = "\(timeFormatted(playerTwo.startTime))"
    timerLabelBottom.font = timerLabelBottom.font.withSize(60)
//    labelTimerTop.backgroundColor = .green
    timerLabelBottom.translatesAutoresizingMaskIntoConstraints = false
    timerLabelBottom.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    timerLabelBottom.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1.6).isActive = true

    // MARK: StackView
    view.addSubview(stackView)
    stackView.axis = NSLayoutConstraint.Axis.horizontal
    stackView.distribution = UIStackView.Distribution.fillEqually

    stackView.addArrangedSubview(setTimeButton)
    stackView.addArrangedSubview(pauseTimeButton)
    stackView.addArrangedSubview(restartTimeButton)

    stackView.backgroundColor = .white
    stackView.translatesAutoresizingMaskIntoConstraints = false
//    stackView.topAnchor.constraint(equalTo: labelTimerTop.bottomAnchor).isActive = true
    stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

  }

  // MARK: - METHODS
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
    if playerOne.isTurn, playerOne.timeRemaining == 0 {
      endTurnButtonTop.backgroundColor = .red
    }

    if playerOne.isTurn, playerOne.timeRemaining > 0 {
      playerOne.timeRemaining -= 1
    }

    if playerTwo.isTurn, playerTwo.timeRemaining == 0 {
      endTurnButtonBottom.backgroundColor = .red
    }

    if playerTwo.isTurn, playerTwo.timeRemaining > 0 {
      playerTwo.timeRemaining -= 1
    }

    timerLabelTop.text = "\(timeFormatted(playerOne.timeRemaining))"

    timerLabelBottom.text = "\(timeFormatted(playerTwo.timeRemaining))"
  }

  func timeFormatted(_ totalSeconds: TimeInterval) -> String {
    let seconds: Int = Int(totalSeconds) % 60
    let minutes: Int = Int((totalSeconds / 60)) % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }

  @objc func endTurnTop(sender: UIButton) {
    print("topButton pressed")

    if playerOne.isTurn == false && playerTwo.isTurn == false {
      timer = startTimer()
    }

    playerOne.isTurn = false
    playerTwo.isTurn = true

    endTurnButtonTop.backgroundColor = .systemGray5
    endTurnButtonBottom.backgroundColor = UIColor(red: 0.117, green: 0.796, blue: 0.882, alpha: 1)

  }

  @objc func endTurnBottom(sender: UIButton) {
    print("bottomButton pressed")

    if playerOne.isTurn == false && playerTwo.isTurn == false {
      timer = startTimer()
    }

    playerTwo.isTurn = false
    playerOne.isTurn = true

    endTurnButtonTop.backgroundColor = UIColor(red: 0.117, green: 0.796, blue: 0.882, alpha: 1)
    endTurnButtonBottom.backgroundColor = .systemGray5
  }

}
