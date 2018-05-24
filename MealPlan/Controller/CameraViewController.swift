//
//  CameraViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/15.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    let captureSession = AVCaptureSession()
    var previewLayer: CALayer!
    var captureDevice: AVCaptureDevice!
    var isTakePhoto = false
    var filter: CIFilter? = CIFilter(name: "CIColorInvert")//CIFilter!
    var popupButtonManager = PopupButtonManager()
    var popupButtons = [UIButton]()
    var selectedDate = ""
    var drawCameraLineManager = DrawCameraLineManager()
    lazy var context: CIContext = {
        if let eaglContext = EAGLContext(api: EAGLRenderingAPI.openGLES2){
            let options = [kCIContextWorkingColorSpace: NSNull()]
            return CIContext(eaglContext: eaglContext, options: options)
        } else {
            return CIContext()
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        configureButtons()
        //configurePopupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareCamera()
        moveButtonsToFront()
        configureCameraLines()
    }
    
    func configureCameraLines() {
        drawCameraLineManager.addCameraLines(on: self.previewLayer)
    }
    
    func moveButtonsToFront() {
        for button in self.popupButtons {
            self.view.bringSubview(toFront: button)
        }
    }
    
    func configurePopupButtons() {
        popupButtons = popupButtonManager.addButton(with: [#imageLiteral(resourceName: "instagram"),#imageLiteral(resourceName: "pig"),#imageLiteral(resourceName: "cabbage"),#imageLiteral(resourceName: "iTunesArtwork"),#imageLiteral(resourceName: "iTunesArtwork-1")], on: self.view)
        popupButtons[0].addTarget(self, action: #selector(mainButtonAction(_:)), for: .touchUpInside)
        popupButtons[1].addTarget(self, action: #selector(popupButton1Action(_:)), for: .touchUpInside)
        popupButtons[2].addTarget(self, action: #selector(popupButton2Action(_:)), for: .touchUpInside)
        popupButtons[3].addTarget(self, action: #selector(popupButton3Action(_:)), for: .touchUpInside)
        popupButtons[4].addTarget(self, action: #selector(popupButton4Action(_:)), for: .touchUpInside)
    }
    
    @objc func mainButtonAction(_ sender: UIButton) {
        popupButtonManager.mainButtonSelected = !popupButtonManager.mainButtonSelected
        if popupButtonManager.mainButtonSelected {
            popupButtonManager.showButtons(on: self.view)
        } else {
            popupButtonManager.hideButtons(on: self.view)
        }
    }
    
    @objc func popupButton1Action(_ sender: UIButton) {
        self.filter = CIFilter(name: "CIVignetteEffect")
    }
    
    @objc func popupButton2Action(_ sender: UIButton) {
        self.filter = CIFilter(name: "CIPhotoEffectMono")
    }
    
    @objc func popupButton3Action(_ sender: UIButton) {
        self.filter = CIFilter(name: "CIPhotoEffectChrome")
    }
    
    @objc func popupButton4Action(_ sender: UIButton) {
        self.filter = nil
    }
    
    
    func configureButtons() {
        let takePhotoButton = UIButton(frame: CGRect(x: self.view.frame.width/2 - 30, y: self.view.frame.height-80, width: 60, height: 60))
        takePhotoButton.addTarget(self, action: #selector(takePhoto(_:)), for: .touchUpInside)
        self.view.addSubview(takePhotoButton)
        takePhotoButton.setImage(#imageLiteral(resourceName: "shutter"), for: .normal)
        self.view.bringSubview(toFront: takePhotoButton)
        
        let cancelButton = UIButton(frame: CGRect(x: 20, y: self.view.frame.height-85, width: 50, height: 50))
        cancelButton.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        cancelButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        self.view.addSubview(cancelButton)
        self.view.bringSubview(toFront: cancelButton)
        
        let focusFilterButton = UIButton(frame: CGRect(x: self.view.frame.width/2 - 115, y: self.view.frame.height-130, width: 30, height: 30))
        focusFilterButton.addTarget(self, action: #selector(popupButton1Action(_:)), for: .touchUpInside)
        focusFilterButton.setImage(#imageLiteral(resourceName: "focus"), for: .normal)
        self.view.addSubview(focusFilterButton)
        self.view.bringSubview(toFront: focusFilterButton)
        
        let blackFilterButton = UIButton(frame: CGRect(x: self.view.frame.width/2 - 15, y: self.view.frame.height-130, width: 30, height: 30))
        blackFilterButton.addTarget(self, action: #selector(popupButton2Action(_:)), for: .touchUpInside)
        blackFilterButton.setImage(#imageLiteral(resourceName: "two-circles-sign-one-black-other-white"), for: .normal)
        self.view.addSubview(blackFilterButton)
        self.view.bringSubview(toFront: blackFilterButton)
        
        let lightFilterButton = UIButton(frame: CGRect(x: self.view.frame.width/2 + 85, y: self.view.frame.height-130, width: 30, height: 30))
        lightFilterButton.addTarget(self, action: #selector(popupButton3Action(_:)), for: .touchUpInside)
        lightFilterButton.setImage(#imageLiteral(resourceName: "light-bulb"), for: .normal)
        self.view.addSubview(lightFilterButton)
        self.view.bringSubview(toFront: lightFilterButton)
    }
    
    @objc func cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func prepareCamera() {
        captureSession.sessionPreset = .photo
        if let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            captureDevice = availableDevices
            beginSession()
        }
    }
    
    @objc func takePhoto(_ sender: UIButton) {
        isTakePhoto = true
    }
    
    func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }
        
        //self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = CALayer()
        
        previewLayer.bounds = CGRect(x: 0, y: 0, width: self.view.frame.height-150, height: self.view.frame.size.width)
        
        //previewLayer.position = CGPoint(x: self.view.frame.size.width / 2.0, y: self.view.frame.size.height / 2.0)
        
        
        previewLayer.setAffineTransform(CGAffineTransform.init(rotationAngle: CGFloat(M_PI/2.0)))
        previewLayer.frame.origin = CGPoint(x: 0, y: 0)
        self.view.layer.addSublayer(self.previewLayer)
        captureSession.startRunning()
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        
        dataOutput.alwaysDiscardsLateVideoFrames = true
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "com.kevinliao.captureQueue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            var outputImage = CIImage(cvPixelBuffer: imageBuffer)
            if let filter = filter {
                filter.setValue(outputImage, forKey: kCIInputImageKey)
                if let filterOutputImage = filter.outputImage {
                    outputImage = filterOutputImage
                }
            }
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
            
            DispatchQueue.main.async {
                self.previewLayer.contents = cgImage
            }
            
            if isTakePhoto {
                isTakePhoto = false
                
                if let image = self.getImageFromSampleBuffer(cgImage: cgImage) {
                    let photoVC = UIStoryboard(name: "MealPlan", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
                    photoVC.takenPhoto = image
                    photoVC.selectedDate = self.selectedDate
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(photoVC, animated: true)
                        self.stopCaptureSession()
//                        self.present(photoVC, animated: true, completion: {
//                            self.stopCaptureSession()
//                        })
                    }
                }
            }
        }
    }
    
    func getImageFromSampleBuffer (cgImage: CGImage?) -> UIImage? {
        if let outputImage = cgImage {
            return UIImage(cgImage: outputImage, scale: UIScreen.main.scale, orientation: .right)
        } else {
            return nil
        }
    }
    
    func stopCaptureSession() {
        self.captureSession.stopRunning()
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
    }

}
