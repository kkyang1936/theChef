//
//  CameraView.swift
//  Chef2
//
//  Created by Jason Clemens on 4/20/20.
//  Copyright © 2020 ExecutiveChef. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation

class CameraView: UIView {
    private var captureSession: AVCaptureSession?
    
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
        session.commitConfiguration()
        self.captureSession = session
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
        if nil != self.superview {
            self.videoPreviewLayer.session = self.captureSession
            self.videoPreviewLayer.videoGravity = .resizeAspectFill
            self.captureSession?.startRunning()
        } else {
            self.captureSession?.stopRunning()
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
