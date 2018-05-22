//
//  SaveImageManager.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/22.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class SaveImageManager {
    
    func saveImage(image: UIImage, imageFileName: String) -> Bool {
        guard let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image) else {return false}
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        
        
        do {
            try data.write(to: directory.appendingPathComponent(imageFileName)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    
    func getSavedImage(imageFileName: String)-> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(imageFileName).path)
        }
        return nil
    }
    
    
}
