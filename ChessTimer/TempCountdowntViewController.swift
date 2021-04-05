// Created by Manuel Lopez on 4/5/21.
// Copyright © 2021 Airbnb Inc. All rights reserved.

import UIKit

class TempCountdowntViewController: UIViewController {

  var labelTimerTop: UILabel
  var labelTimerBottom: UILabel

  init() {
    labelTimerTop = UILabel()
    labelTimerBottom = UILabel()

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(labelTimerTop)
    labelTimerTop.text = "labelTimerTop"
    labelTimerTop.translatesAutoresizingMaskIntoConstraints = false
    labelTimerTop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    labelTimerTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

    view.addSubview(labelTimerBottom)
    labelTimerBottom.text = "labelTimerBottom"
    labelTimerBottom.translatesAutoresizingMaskIntoConstraints = false
    labelTimerBottom.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    labelTimerBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

  }

}
