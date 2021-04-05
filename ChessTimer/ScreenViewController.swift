// Created by Manuel Lopez on 3/6/21.

import UIKit

class ScreenViewController: UIViewController, TimePickerDelegate {

  // MARK: PROPERTIES
  var timer: Timer?
  var playerOne = Player(startTime: 600, timeRemaining: 600)
  var playerTwo = Player(startTime: 600, timeRemaining: 600)

  @IBOutlet var timerLabelTop: UILabel!
  @IBOutlet var timerLabelBottom: UILabel!
  @IBOutlet var topButton: UIButton!
  @IBOutlet var bottomButton: UIButton!


  // MARK: INITIALIZER
  override func viewDidLoad() {
    super.viewDidLoad()

    timerLabelTop.text = "\(timeFormatted(playerOne.startTime))"
    timerLabelTop.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    timerLabelBottom.text = "\(timeFormatted(playerTwo.startTime))"
  }

  // MARK: METHODS
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
      topButton.backgroundColor = .red
    }

    if playerOne.isTurn, playerOne.timeRemaining > 0 {
      playerOne.timeRemaining -= 1
    }

    if playerTwo.isTurn, playerTwo.timeRemaining == 0 {
      bottomButton.backgroundColor = .red
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

  @IBAction func restartButton(_ sender: UIButton) {
    restart()
  }

  func restart() {
    timer?.invalidate()
    playerOne.timeRemaining = playerOne.startTime
    playerTwo.timeRemaining = playerTwo.startTime
    playerOne.isTurn = false
    playerTwo.isTurn = false
    timerLabelTop.text = "\(timeFormatted(playerOne.startTime))"
    timerLabelBottom.text = "\(timeFormatted(playerTwo.startTime))"
    topButton.backgroundColor = .white
    bottomButton.backgroundColor = .white
  }

  @IBAction func pauseButton(_ sender: UIButton) {
    timer?.invalidate()
    playerOne.isTurn = false
    playerTwo.isTurn = false
  }

  @IBAction func setTimeButton(_ sender: UIButton) {
    print("Gear pressed")

    let timePickerVC = storyboard?.instantiateViewController(identifier: "TimePickerViewController") as! TimePickerViewController
    present(timePickerVC, animated: true, completion: nil)

    timePickerVC.timePickerDelegate = self
  }

  @IBAction func endTurnTop(_ sender: UIButton) {
    print("Top button pressed")
    print("Player One time remaining: \(playerOne.timeRemaining)")

    if playerOne.isTurn == false && playerTwo.isTurn == false {
      timer = startTimer()
    }

    playerOne.isTurn = false
    playerTwo.isTurn = true

    topButton.backgroundColor = .systemGray5
    bottomButton.backgroundColor = UIColor(red: 0.117, green: 0.796, blue: 0.882, alpha: 1)
  }
  @IBAction func endTurnBottom(_ sender: UIButton) {
    print("Bottom button pressed")
    print("Player Two time remaining: \(playerTwo.timeRemaining)")

    if playerOne.isTurn == false && playerTwo.isTurn == false {
      timer = startTimer()
    }

    playerTwo.isTurn = false
    playerOne.isTurn = true

    topButton.backgroundColor = UIColor(red: 0.117, green: 0.796, blue: 0.882, alpha: 1)
    bottomButton.backgroundColor = .systemGray5
  }

  func timeSelected(timeInterval: TimeInterval) {
    print("PROTOCOL ACCESSED SUCCESSFULLY: \(timeInterval)")
    playerOne.startTime = timeInterval
    timerLabelTop.text = "\(timeFormatted(playerOne.startTime))"
    playerTwo.startTime = timeInterval
    timerLabelBottom.text = "\(timeFormatted(playerTwo.startTime))"
    restart()
  }
}
