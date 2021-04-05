// Created by Manuel Lopez on 3/12/21.

import UIKit

class TimePickerViewController: UIViewController {
  // MARK: Properties
  @IBOutlet var datePicker: UIDatePicker!
  var timePickerDelegate: TimePickerDelegate?
  var timeRemaining: TimeInterval!

  // MARK: Methods
  @IBAction func cancelButton(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func confirmButton(_ sender: UIButton) {
    print("confirm button pressed")
    print("\(datePicker.countDownDuration)")

    timePickerDelegate?.timeSelected(timeInterval: datePicker.countDownDuration)

    print("self.datePicker.countDownDuration: \(self.datePicker.countDownDuration)")

    dismiss(animated: true, completion: nil)
  }

  // MARK: Initializer
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}
