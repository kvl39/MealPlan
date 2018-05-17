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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareCamera()
        configureButtons()
    }
    
    func configureButtons() {
        let takePhotoButton = UIButton(frame: CGRect(x: self.view.frame.width/2 - 25, y: self.view.frame.height-50, width: 50, height: 50))
        takePhotoButton.addTarget(self, action: #selector(takePhoto(_:)), for: .touchUpInside)
        self.view.addSubview(takePhotoButton)
        takePhotoButton.setImage(#imageLiteral(resourceName: "pig"), for: .normal)
        self.view.bringSubview(toFront: takePhotoButton)
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
        
        previewLayer.position = CGPoint(x: self.view.frame.size.width / 2.0, y: self.view.frame.size.height / 2.0)
        
        previewLayer.setAffineTransform(CGAffineTransform.init(rotationAngle: CGFloat(M_PI/2.0)))
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
                    let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
                    photoVC.takenPhoto = image
                    
                    DispatchQueue.main.async {
                        self.present(photoVC, animated: true, completion: {
                            self.stopCaptureSession()
                        })
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
