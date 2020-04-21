//
//  CameraContentView.swift
//  CamCapture
//
//  Created by Jason Clemens on 4/20/20.
//  Copyright © 2020 ExecutiveChef. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation
import Photos

class CameraView2: UIView {
	private static var instance: CameraView2? = nil
	public static var capturesInProgress = Set<PhotoCaptureProcessor>()
	
	private var captureSession: AVCaptureSession?
	private var photoOutput: AVCapturePhotoOutput?
	
	init() {
		super.init(frame: .zero)
		var allowedAccess = false
		let blocker = DispatchGroup()
		blocker.enter()
		AVCaptureDevice.requestAccess(for: .video) { flag in
			allowedAccess = flag
			blocker.leave()
		}
		blocker.wait()
		if (!allowedAccess) {
			print("!!! NO ACCESS TO CAMERA")
			return
		}
		let session = AVCaptureSession()
		session.beginConfiguration()
		let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
		guard videoDevice != nil, let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), session.canAddInput(videoDeviceInput) else {
			print("!!! NO CAMERA DETECTED")
			return
		}
		session.addInput(videoDeviceInput)
		
		self.photoOutput = AVCapturePhotoOutput()
		self.photoOutput!.isHighResolutionCaptureEnabled = false
		self.photoOutput!.isLivePhotoCaptureEnabled = false
		guard session.canAddOutput(self.photoOutput!) else {
			session.commitConfiguration()
			self.captureSession = session
			print("!!! UNABLE TO ADD PHOTO OUTPUT")
			return
		}
		//session.sessionPreset = .photo //enable this if you don't like settings
		session.addOutput(self.photoOutput!)
		session.commitConfiguration()
		self.captureSession = session
		CameraView2.instance = self;
		
	}
	
	override class var layerClass: AnyClass {
		AVCaptureVideoPreviewLayer.self
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var videoPreviewLayer: AVCaptureVideoPreviewLayer {
		return layer as! AVCaptureVideoPreviewLayer
	}
	
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		if self.superview != nil {
			self.videoPreviewLayer.session = self.captureSession
			self.videoPreviewLayer.videoGravity = .resizeAspectFill
			self.captureSession?.startRunning()
		} else {
			self.captureSession?.stopRunning()
		}
	}
	
	public static func snapPhoto(didRecognizeIngredient: @escaping (String?) -> ()) {
		if capturesInProgress.isEmpty {
			DispatchQueue.main.async {
				guard let camView = CameraView2.instance else { print("nil CameraView2 instance"); didRecognizeIngredient(nil); return }
				guard let photoOutput = camView.photoOutput else { print("nil photoOutput"); didRecognizeIngredient(nil); return }
				guard let photoOutputConnection = photoOutput.connection(with: .video) else { print("couldn't get photoOutputConnection"); didRecognizeIngredient(nil); return }
				if let orientation = UIDevice.current.orientation.asVideoOrientation {
					photoOutputConnection.videoOrientation = orientation
				}
				let photoSettings = AVCapturePhotoSettings()
				photoSettings.flashMode = .auto
				let photoProcessor = PhotoCaptureProcessor(didRecognizeIngredient: didRecognizeIngredient)
				CameraView2.capturesInProgress.insert(photoProcessor)
				photoOutput.capturePhoto(with: photoSettings, delegate: photoProcessor)
			}
		} else {
			didRecognizeIngredient(nil)
		}
	}
}

class PhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
	static var lastPhoto: AVCapturePhoto? = nil
	
	private var didRecognizeIngredient: (String?) -> ()

	init(didRecognizeIngredient: @escaping (String?) -> ()) {
		self.didRecognizeIngredient = didRecognizeIngredient
	}
	
	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		PhotoCaptureProcessor.lastPhoto = photo
		if error != nil {
			print(error!)
			self.didRecognizeIngredient(nil)
			return
		}
		//Use visual recognition and pass in result to self.didRecognizeIngredient
		IngredientRecognition.instance.recognizeIngredient(photoFile: photo.fileDataRepresentation()!, callback: self.didRecognizeIngredient)
		
		CameraView2.capturesInProgress.remove(self)
	}
	
	public static func saveRecentToLibrary() {
		if PhotoCaptureProcessor.lastPhoto != nil {
			saveToLibrary(photo: PhotoCaptureProcessor.lastPhoto!)
		}
	}
	
	private static func saveToLibrary(photo: AVCapturePhoto) {
		PHPhotoLibrary.requestAuthorization { status in
			guard status == .authorized else { return }
			PHPhotoLibrary.shared().performChanges( {
				let creationRequest = PHAssetCreationRequest.forAsset()
				creationRequest.addResource(with: .photo, data: photo.fileDataRepresentation()!, options: nil)
			})
		}
	}
}

struct CameraView2Representable: UIViewRepresentable {	
	func updateUIView(_ uiView: CameraView2, context: UIViewRepresentableContext<CameraView2Representable>) {
	}
	
	func makeUIView(context: UIViewRepresentableContext<CameraView2Representable>) -> CameraView2 {
		CameraView2()
	}
	
	typealias UIViewType = CameraView2
}

extension UIDeviceOrientation {
	var asVideoOrientation: AVCaptureVideoOrientation? {
		get {
			switch self {
			case .portrait: return .portrait
			case .portraitUpsideDown: return .portraitUpsideDown
			case .landscapeLeft: return .landscapeRight
			case .landscapeRight: return .landscapeLeft
			case .faceDown: return .portrait
			case .faceUp: return .portrait
			default: return nil
			}
			
		}
	}
}
