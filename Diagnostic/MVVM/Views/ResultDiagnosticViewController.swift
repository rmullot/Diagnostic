//
//  ResultDiagnosticViewController.swift
//  Diagnostic
//
//  Created by Romain Mullot on 13/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import UIKit
import RMUI

final class ResultDiagnosticViewController: BaseViewController<ResultDiagnosticViewModel> {

    @IBOutlet weak var consoleTextView: UITextView!
    @IBOutlet weak var newDiagnosticButton: RMButton!
    @IBOutlet weak var sendButton: RMButton!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
      super.viewDidLoad()
      viewModel.propertyChanged = { [weak self] name in self?.viewModelPropertyChanged(name) }
      sendButton.isEnabled = false
      viewModel.loadDiagnostic()
      // Do any additional setup after loading the view.
    }

    @IBAction func sendEvent() {
      if viewModel.isSendingDiagnosticAvailable {
        sendButton.isEnabled = false
        viewModel.sendDiagnostic()
      }
    }

    @IBAction func newDiagnosticEvent() {
      viewModel.newDiagnostic()
    }

    private func viewModelPropertyChanged(_ name: String) {
      switch name {
      case ResultDiagnosticViewModel.PropertyNames.log.rawValue:
          consoleTextView.text.append(viewModel.log)
      case ResultDiagnosticViewModel.PropertyNames.readyToSend.rawValue:
          sendButton.isEnabled = true
      default:
          break
      }
    }
}
