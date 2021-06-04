// Created by Manuel Lopez on 4/7/21.

import UIKit

class TimePickerViewController: UIViewController {

  // MARK: - Properties
  let datePicker: UIDatePicker
  let stackView: UIStackView
  var confirmButton: UIButton
  var cancelButton: UIButton
  var xmarkImage = UIImage(systemName: "xmark")
  var checkmarkImage = UIImage(systemName: "checkmark")
  weak var timePickerDelegate: TimePickerDelegate?

  init() {
    datePicker = UIDatePicker()
    stackView = UIStackView()
    confirmButton = UIButton()
    cancelButton = UIButton()

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor =
      UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
          return .systemGray5
        default:
          return .white
        }
      }

    let heavyConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .heavy)
    xmarkImage = xmarkImage?.withConfiguration(heavyConfiguration)
    checkmarkImage = checkmarkImage?.withConfiguration(heavyConfiguration)

    // MARK: datePicker
    datePicker.datePickerMode = .countDownTimer
    view.addSubview(datePicker)
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    datePicker.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    datePicker.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true

    // MARK: cancelButton
    cancelButton.setImage(xmarkImage, for: .normal)
    cancelButton.addTarget(self, action: #selector(cancelButtonTapped(sender:)), for: .touchUpInside)

    // MARK: confirmButton
    confirmButton.setImage(checkmarkImage, for: .normal)
    confirmButton.addTarget(self, action: #selector(confirmButtonTapped(sender:)), for: .touchUpInside)

    // MARK: stackView
    view.addSubview(stackView)
    stackView.axis = NSLayoutConstraint.Axis.horizontal
    stackView.distribution = UIStackView.Distribution.fillEqually

    stackView.addArrangedSubview(cancelButton)
    stackView.addArrangedSubview(confirmButton)

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.topAnchor.constraint(equalTo: datePicker.bottomAnchor).isActive = true
    stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
  }

  // MARK: - Methods
  @objc func cancelButtonTapped(sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }

  @objc func confirmButtonTapped(sender: UIButton) {
    timePickerDelegate?.timeSelected(timeInterval: datePicker.countDownDuration)
    dismiss(animated: true, completion: nil)
  }
}
