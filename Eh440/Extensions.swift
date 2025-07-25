//
//  Extensions.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-15.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit

extension Data {
    func writeToFile(_ path: String, atomically: Bool) -> Bool {
        
        do {
            try write(to: URL(fileURLWithPath: path), options: .atomic)
            return true
        } catch {
        } // do
        
        return false
    }
}
extension Date {
    
    var year: Int {
////        let components = NSCalendar.current.components([.Year], fromDate: self)
////        let components = NSCalendar.current.dateComponents([.year], from: self as Date)
////        return components.year
        return NSCalendar.current.component(.year, from: self as Date)
    }
    
}

extension Dictionary {
    func mergedWith(otherDictionary: [Key: Value]) -> [Key: Value] {
        var mergedDict: [Key: Value] = [:]
        [self, otherDictionary].forEach { dict in
            for (key, value) in dict {
                mergedDict[key] = value
            }
        }
        return mergedDict
    }

}

extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        if let pixelData = self.cgImage?.dataProvider?.data {
            let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
            
            let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
            
            let r = CGFloat(data[pixelInfo+0]) / CGFloat(255.0)
            let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
            let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
            let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
            
            return UIColor(red: b, green: g, blue: r, alpha: a)
        } else {
            //IF something is wrong I returned WHITE, but change as needed
            return UIColor.white
        }
        
/*
////        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.cgImage!)!)
        let pixelData = CGDataProviderCopyData(CGImage.dataProvider(self.cgImage!)!)
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
  
 
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
*/
    }
    func crop(bounds: CGRect) -> UIImage?
    {
        let imageRef = self.cgImage!.cropping(to: bounds)
        return UIImage(cgImage: imageRef!, scale: 0.0, orientation: self.imageOrientation)
//        return UIImage(CGImage: CGImageCreateWithImageInRect(self.CGImage!, bounds)!,
//                       scale: 0.0, orientation: self.imageOrientation)
    }
    
    func checkColor(c: UIColor) -> Bool {
        //        print("R: \(c.red) G: \(c.green) B: \(c.blue)")
        if (c.redval < 0.09 && c.greenval < 0.09 && c.blueval < 0.09) {
            return true
        }
        return false
    }
    func cropLetterBox() -> UIImage? {
        print("Crop letter")
        var topIndex = CGFloat(0)
        
////        while (checkColor(c: getPixelColor(pos: CGPointMake(CGFloat(arc4random_uniform(UInt32(size.width))), topIndex)))) {
        while (checkColor(c: getPixelColor(pos: CGPoint(x: CGFloat(arc4random_uniform(UInt32(size.width))), y: topIndex)))) {
            //            print("Found black...top= \(topIndex)")
            topIndex += 1
        }
        
        var bottomIndex = self.size.height
        var bottomCount = CGFloat(0)
////        while (checkColor(c: getPixelColor(pos: CGPointMake(CGFloat(arc4random_uniform(UInt32(size.width))), bottomIndex)))) {
        while (checkColor(c: getPixelColor(pos: CGPoint(x: CGFloat(arc4random_uniform(UInt32(size.width))), y: bottomIndex)))) {
            //            print("Found black...top= \(bottomIndex)")
            bottomIndex -= 1
            bottomCount += 1
        }
        
        print("Top: \(topIndex) Bottom: \(bottomCount)")
        var offset = topIndex
        if bottomCount < offset {
            offset = bottomCount
        } // if
        
//        let test = CGRect(x: 0, y: topIndex, width: self.size.width, height: bottomIndex - topIndex)
        let test = CGRect(x: 0, y: offset, width: self.size.width, height: self.size.height - (2*offset))
        return crop(bounds: test)
    }
    
    func cropToSquare() -> UIImage? {
////        let size = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale)
        let size = CGSize(width: self.size.width * self.scale, height: self.size.height * self.scale)
        let shortest = min(size.width, size.height)
        let left: CGFloat = size.width > shortest ? (size.width-shortest)/2 : 0
        let top: CGFloat = size.height > shortest ? (size.height-shortest)/2 : 0
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
////        let insetRect = CGRectInset(rect, left, top)
        let insetRect = rect.insetBy(dx: left, dy: top)
        return crop(bounds: insetRect)
    }
}
extension UIView {
    func addBorderTop(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: size, color: color)
    }
    func addBorderBottom(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
    }
    func addBorderLeft(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: size, height: frame.height, color: color)
    }
    func addBorderRight(size: CGFloat, color: UIColor) {
        addBorderUtility(x: frame.width - size, y: 0, width: size, height: frame.height, color: color)
    }
    private func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
}

extension UIColor{
    
    var redval: CGFloat{
        return CIColor(color: self).red
////        return CGColorGetComponents(self.CGColor)[0]
    }
    
    var greenval: CGFloat{
        return CIColor(color: self).green
////        return CGColorGetComponents(self.CGColor)[1]
    }
    
    var blueval: CGFloat{
        return CIColor(color: self).blue
////        return CGColorGetComponents(self.CGColor)[2]
    }
    
    var alphaval: CGFloat{
        return CIColor(color: self).alpha
////        return CGColorGetComponents(self.CGColor)[3]
    }
}

extension String {
    
    // MARK: - sub String
    func substringFromIndex(index: Int) -> String
    {
        if (index < 0 || index > self.characters.count)
        {
            print("index \(index) out of bounds")
            return ""
        }
        //return self.substringFromIndex(index: self.startIndex.advancedBy(index))
        let indexNum = self.index(self.startIndex, offsetBy: index)
        return self.substring(from: indexNum)
    }
    func substring(location: Int, length: Int) -> String? {
        guard characters.count >= location + length else { return nil }
        let start = index(startIndex, offsetBy: location)
        let end = index(startIndex, offsetBy: location + length)
        return substring(with: start..<end)
    }
    func substringToIndex(index: Int) -> String
    {
        if (index < 0 || index > self.characters.count)
        {
            print("index \(index) out of bounds")
            return ""
        }
        let indexNum = self.index(self.startIndex, offsetBy: index)
        return self.substring(to: indexNum)
////        return self.substringToIndex(self.startIndex.advancedBy(index))
    }
    func trim() -> String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
//        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    func indexOfTest(_ target: String) -> Int? {
        return self.range(of: target)?.lowerBound.encodedOffset
/*
        if let range = self.rangeOfString(target) {
            return startIndex.distanceTo(range.startIndex)
        } else {
            return nil
        }
 */
    }
    
    func lastIndexOf(target: String) -> Int? {
        return self.range(of: target)?.upperBound.encodedOffset
/*
        if let range = self.rangeOfString(target, options: .BackwardsSearch) {
            return startIndex.distanceTo(range.startIndex)
        } else {
            return nil
        }
 */
    }
    func startsWith(string: String) -> Bool {
        return self.starts(with: string)
/*
        guard let range = rangeOfString(string, options:[.AnchoredSearch, .CaseInsensitiveSearch]) else {
            return false
        }
        return range.startIndex == startIndex
 */
    }
//    func contains(find: String) -> Bool{
//        return self.rangeOfString(find) != nil
//    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return lowercased().contains(find.lowercased())
//        return self.rangeOfString(find, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
    }
}

