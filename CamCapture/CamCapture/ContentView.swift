//
//  ContentView.swift
//  CamCapture
//
//  Created by Jason Clemens on 4/20/20.
//  Copyright © 2020 ExecutiveChef. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation
import Photos

class CameraView: UIView {
    private static var instance: CameraView? = nil
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
        CameraView.instance = self;
        
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
    
    public static func snapPhoto(displayOn: ContentView) {
        DispatchQueue.main.async {
            guard let camView = CameraView.instance else { print("nil CameraView instance"); return }
            guard let photoOutput = camView.photoOutput else { print("nil photoOutput"); return }
            guard let photoOutputConnection = photoOutput.connection(with: .video) else { print("couldn't get photoOutputConnection"); return }
            if let orientation = UIDevice.current.orientation.asVideoOrientation {
                photoOutputConnection.videoOrientation = orientation
            }
            let photoSettings = AVCapturePhotoSettings()
            photoSettings.flashMode = .auto
            let photoProcessor = PhotoCaptureProcessor(contentView: displayOn)
            CameraView.capturesInProgress.insert(photoProcessor)
            photoOutput.capturePhoto(with: photoSettings, delegate: photoProcessor)
        }
    }
}

class PhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    static var lastPhoto: AVCapturePhoto? = nil
    var contentView: ContentView
    
    init(contentView: ContentView) {
        self.contentView = contentView
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        PhotoCaptureProcessor.lastPhoto = photo
        if error != nil {
            print(error!)
            return
        }
        //TODO Use visual recognition somewhere in this method
        guard let imageData = photo.fileDataRepresentation() else { print("nil fileDataRepresentation"); return }
        guard let uiImage = UIImage(data: imageData) else { print("UIImage nil"); return }
        contentView.capturedImage = Image(uiImage: uiImage)
        
        CameraView.capturesInProgress.remove(self)
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

struct CameraViewRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: CameraView, context: UIViewRepresentableContext<CameraViewRepresentable>) {
    }
    
    func makeUIView(context: UIViewRepresentableContext<CameraViewRepresentable>) -> CameraView {
        CameraView()
    }
    
    typealias UIViewType = CameraView
}

struct ContentView: View {
    @State var capturedImage: Image?
    var body: some View {
        VStack {
            if (self.capturedImage == nil) {
                CameraViewRepresentable()
                .gesture(TapGesture().onEnded {
                    print("Tapped.")
                    CameraView.snapPhoto(displayOn: self)
                })
            }
            else {
                self.capturedImage!
                .resizable()
                    .aspectRatio(contentMode: .fit)
                    .gesture(TapGesture().onEnded {
                        print("Tapped.")
                        self.capturedImage = nil
                    })
                    .gesture(LongPressGesture().onEnded {_ in 
                        print("Saving.")
                        PhotoCaptureProcessor.saveRecentToLibrary()
                        self.capturedImage = nil
                    })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
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
