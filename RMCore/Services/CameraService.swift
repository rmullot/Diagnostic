//
//  CameraService.swift
//  RMCore
//
//  Created by Romain Mullot on 12/12/2018.
//  Copyright © 2018 Romain Mullot. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol CameraServiceProtocol {
    static func bestDevice(in position: AVCaptureDevice.Position) -> AVCaptureDevice?
    static func imageFromSampleBuffer(photoSampleBuffer: CMSampleBuffer?) -> UIImage
    static func toggleTorch(isOn: Bool) -> Bool
    static func updateOrientation(videoLayer: AVCaptureVideoPreviewLayer)
}

public final class CameraService: CameraServiceProtocol {

  // MARK: - Static Methods

 public static func bestDevice(in position: AVCaptureDevice.Position) -> AVCaptureDevice? {
  #if targetEnvironment(simulator)
  print("Missing capture devices.")
  return nil
  #else
  var deviceTypes: [AVCaptureDevice.DeviceType] = [.builtInWideAngleCamera]
  if #available(iOS 10.2, *) { deviceTypes.append(.builtInDualCamera) }
  if #available(iOS 11.1, *) { deviceTypes.append(.builtInTrueDepthCamera) }

  let session = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: .video, position: .unspecified)
  let devices = session.devices
  guard let device = devices.first(where: { device in device.position == position }) else { return nil }
  return device
  #endif
  }

  public static func imageFromSampleBuffer(photoSampleBuffer: CMSampleBuffer?) -> UIImage {
    var image = UIImage()

    // Get a CMSampleBuffer's Core Video image buffer for the media data
    guard let photoSampleBuffer = photoSampleBuffer, let imageBuffer = CMSampleBufferGetImageBuffer(photoSampleBuffer) else { return image }

    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, [])

    // Get the number of bytes per row for the pixel buffer
    let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
    let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
    // Get the pixel buffer width and height
    let width = CVPixelBufferGetWidth(imageBuffer)
    let height = CVPixelBufferGetHeight(imageBuffer)

    // Create a device-dependent RGB color space
    let colorSpace = CGColorSpaceCreateDeviceRGB()

    let bitmapInfo: CGBitmapInfo = [.byteOrder32Little, CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)]

    // Create a bitmap graphics context with the sample buffer data
    // Create a Quartz image from the pixel data in the bitmap graphics context
    if let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue),
      let quartzImage = context.makeImage() {
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer, [])
        image = UIImage(cgImage: quartzImage)
    }
    return image
  }

  @discardableResult
  public static func toggleTorch(isOn: Bool) -> Bool {
    guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return false }

    if device.hasTorch {
        do {
            try device.lockForConfiguration()
            device.torchMode = isOn ? .on : .off
            device.unlockForConfiguration()
            return true
        } catch {
            print("Torch could not be used")
        }
    } else {
        print("Torch is not available")
    }
    return false
  }

  public static func updateOrientation(videoLayer: AVCaptureVideoPreviewLayer) {
    var orientation: AVCaptureVideoOrientation?
    switch UIDevice.current.orientation {
    case .landscapeLeft:
        orientation = AVCaptureVideoOrientation.landscapeRight
    case .landscapeRight:
        orientation = AVCaptureVideoOrientation.landscapeLeft
    case .portrait:
        orientation = AVCaptureVideoOrientation.portrait
    case .portraitUpsideDown:
        orientation = AVCaptureVideoOrientation.portraitUpsideDown
    case .faceDown, .faceUp, .unknown:
        break
    }
    if let orientation = orientation {
        videoLayer.connection?.videoOrientation = orientation
    }
  }

 // MARK: - Private Methods

  private init() { }
}
