//
//  CameraDiagnosticViewController.swift
//  Diagnostic
//
//  Created by Romain Mullot on 11/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import RMUI
import RMCore

final class CameraDiagnosticViewController: BaseViewController<CameraDiagnosticViewModel>, AVCapturePhotoCaptureDelegate {

    // MARK: - IBOutlets

    private var captureSession = AVCaptureSession()
    private let cameraOutput = AVCapturePhotoOutput()
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    private let cameraQueue = DispatchQueue(label: Constants.cameraNameQueue, attributes: [])
    private var imageView: UIImageView?

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraButton: RMButton!
    @IBOutlet weak var lampButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.accessibilityIdentifier = UITestingIdentifiers.cameraButton.rawValue
        viewModel.propertyChanged = { [weak self] name in self?.viewModelPropertyChanged(name) }
        viewModel.askPermissionForCamera { (granted) in
          guard granted, let captureDevice = CameraService.bestDevice(in: .back) else {
              self.displayErrorLabel(error: Constants.errorCameraUnavailable)
              return
          }
          self.startDeviceCapture(captureDevice: captureDevice)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      viewModel.forceSwitchOffLamp()
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      refreshCameraFrame()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshCameraFrame()
    }

    // MARK: - IBAction Events

    @IBAction func toggleLampEvent() {
        guard viewModel.toggleLamp() else { return }
        lampButton.backgroundColor = viewModel.lampActivated ? UIColor.activatedLampBackgroundColor : UIColor.disactivatedLampBackgroundColor
        lampButton.setTitleColor(viewModel.lampActivated ? UIColor.activatedLampTitleColor : UIColor.disactivatedLampTitleColor, for: .normal)
    }

    @IBAction func takePictureEvent() {
        cameraButton.isEnabled = false
        lampButton.isEnabled = false
        cameraView.flashAnimation()
        let settings = AVCapturePhotoSettings()

        if let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first {
            let previewFormat = [
                kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                kCVPixelBufferWidthKey as String: cameraView.bounds.width * UIScreen.main.scale,
                kCVPixelBufferHeightKey as String: cameraView.bounds.height * UIScreen.main.scale
                ] as [String: Any]
            settings.previewPhotoFormat = previewFormat
            cameraQueue.async {
                self.cameraOutput.capturePhoto(with: settings, delegate: self)
            }
        }
    }

    // MARK: - AVCapturePhotoCaptureDelegate Methods

    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            displayErrorLabel(error: "error occure : \(error.localizedDescription)")
            return
        }

        if let cgImage = photo.previewCGImageRepresentation()?.takeUnretainedValue() {
            let image = UIImage(cgImage: cgImage, scale: 1, orientation: UIDevice.current.orientation.imageOrientation)
            displayPhoto(image)
        }

    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
    }

    // iOS system method. Useless to use swiftlint for that declaration method
    // swiftlint:disable function_parameter_count
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
    // swiftlint:enable function_parameter_count
      if let error = error {
          displayErrorLabel(error: "error occure : \(error.localizedDescription)")
          return
      }
      let image = CameraService.imageFromSampleBuffer(photoSampleBuffer: previewPhotoSampleBuffer)
      displayPhoto(image)

    }

    // MARK: - Private Methods

    private func displayErrorLabel(error: String) {
      errorLabel.text = error
      errorLabel.isHidden = error.isEmpty
      cameraButton.isEnabled = error.isEmpty
    }

    private func displayPhoto(_ image: UIImage) {
      if imageView == nil {
          imageView = UIImageView()
          imageView!.alpha = 0
          imageView!.contentMode = .scaleAspectFill
          cameraView.addSubViewWithAutoresizingConstrainst(view: imageView!)
      }
      imageView!.image = image
      self.imageView!.setNeedsLayout()
      self.imageView!.layoutIfNeeded()
      imageView!.fadeIn()
      cameraButton.isEnabled = true
      viewModel.finishDiagnostic(photoBase64: image.encodePhotoBase64())
    }

    private func refreshCameraFrame() {
      if let cameraPreviewLayer = cameraPreviewLayer {
          cameraPreviewLayer.frame = cameraView.layer.bounds
          CameraService.updateOrientation(videoLayer: cameraPreviewLayer)
      }
    }

    private func viewModelPropertyChanged(_ name: String) {
      switch name {
      case CameraDiagnosticViewModel.PropertyNames.errorMessage.rawValue:
          displayErrorLabel(error: viewModel.errorMessage)
      case CameraDiagnosticViewModel.PropertyNames.titleMessage.rawValue:
           titleLabel.text =  viewModel.titleMessage
      default:
          break
      }
    }

  private func startDeviceCapture(captureDevice: AVCaptureDevice) {

    do {
      // Get an instance of the AVCaptureDeviceInput class using the previous device object.
      let input = try AVCaptureDeviceInput(device: captureDevice)

      // Set the input device on the capture session.

      if self.captureSession.canAddInput(input) {
        self.captureSession.addInput(input)
      }

      // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
      self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
      if let cameraPreviewLayer = self.cameraPreviewLayer {
        cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.refreshCameraFrame()
        self.cameraView.layer.addSublayer(cameraPreviewLayer)
        self.cameraView.bringSubviewToFront(self.lampButton)
      }

      if self.captureSession.canAddOutput(self.cameraOutput) {
        self.captureSession.addOutput(self.cameraOutput)
      }

    } catch {
      // If any error occurs, simply print it out and don't continue any more.
      print(error)
      self.displayErrorLabel(error: Constants.errorCameraUnavailable)
      return
    }

    // Start video capture.
    self.captureSession.startRunning()
  }
}
