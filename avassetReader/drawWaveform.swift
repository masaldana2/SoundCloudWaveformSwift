//
//  Draw2dWaveform.swift
//  Beatmaker
//
//  Created by Miguel Saldana on 10/17/16.
//  Copyright © 2016 Miguel Saldana. All rights reserved.
//

import Foundation
import UIKit
import Accelerate
class DrawWaveform: UIView {
    
    
    override func draw(_ rect: CGRect) {
        self.convertToPoints()
        var f = 0
        print("draw")
        
        let aPath = UIBezierPath()
        let aPath2 = UIBezierPath()
        
        aPath.lineWidth = 2.0
        aPath2.lineWidth = 2.0
        
        aPath.move(to: CGPoint(x:0.0 , y:rect.height/2 ))
        aPath2.move(to: CGPoint(x:0.0 , y:rect.height ))
        
        
        // print(readFile.points)
        for _ in readFile.points{
                //separation of points
                var x:CGFloat = 2.5
                aPath.move(to: CGPoint(x:aPath.currentPoint.x + x , y:aPath.currentPoint.y ))
                
                //Y is the amplitude
                aPath.addLine(to: CGPoint(x:aPath.currentPoint.x  , y:aPath.currentPoint.y - (readFile.points[f] * 70) - 1.0))
                
                aPath.close()
                
                //print(aPath.currentPoint.x)
                x += 1
                f += 1
        }
       
        //If you want to stroke it with a Orange color
        UIColor.orange.set()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
        
        
        f = 0
        aPath2.move(to: CGPoint(x:0.0 , y:rect.height/2 ))
        
        //Reflection of waveform
        for _ in readFile.points{
            var x:CGFloat = 2.5
            aPath2.move(to: CGPoint(x:aPath2.currentPoint.x + x , y:aPath2.currentPoint.y ))
            
            //Y is the amplitude
            aPath2.addLine(to: CGPoint(x:aPath2.currentPoint.x  , y:aPath2.currentPoint.y - ((-1.0 * readFile.points[f]) * 50)))
            
            // aPath.close()
            aPath2.close()
            
            //print(aPath.currentPoint.x)
            x += 1
            f += 1
        }
        
        //If you want to stroke it with a Orange color with alpha2
        UIColor.orange.set()
        aPath2.stroke(with: CGBlendMode.normal, alpha: 0.5)
        //   aPath.stroke()
        
        //If you want to fill it as well
        aPath2.fill()
    }
    
    
    
    
    func readArray( array:[Float]){
        readFile.arrayFloatValues = array
    }
    
    func convertToPoints() {
        var processingBuffer = [Float](repeating: 0.0,
                                       count: Int(readFile.arrayFloatValues.count))
        let sampleCount = vDSP_Length(readFile.arrayFloatValues.count)
        //print(sampleCount)
        vDSP_vabs(readFile.arrayFloatValues, 1, &processingBuffer, 1, sampleCount);
        // print(processingBuffer)
        
        
        
        
        // convert do dB
        //    var zero:Float = 1;
        //    vDSP_vdbcon(floatArrPtr, 1, &zero, floatArrPtr, 1, sampleCount, 1);
        //    //print(floatArr)
        //
        //    // clip to [noiseFloor, 0]
        //    var noiseFloor:Float = -50.0
        //    var ceil:Float = 0.0
        //    vDSP_vclip(floatArrPtr, 1, &noiseFloor, &ceil,
        //                   floatArrPtr, 1, sampleCount);
        //print(floatArr)
        
        
        
        var multiplier = 1.0
        print(multiplier)
        if multiplier < 1{
            multiplier = 1.0
            
        }
        
        
        let samplesPerPixel = Int(150 * multiplier)
        let filter = [Float](repeating: 1.0 / Float(samplesPerPixel),
                             count: Int(samplesPerPixel))
        let downSampledLength = Int(readFile.arrayFloatValues.count / samplesPerPixel)
        var downSampledData = [Float](repeating:0.0,
                                      count:downSampledLength)
        vDSP_desamp(processingBuffer,
                    vDSP_Stride(samplesPerPixel),
                    filter, &downSampledData,
                    vDSP_Length(downSampledLength),
                    vDSP_Length(samplesPerPixel))
        
        // print(" DOWNSAMPLEDDATA: \(downSampledData.count)")
        
        //convert [Float] to [CGFloat] array
        readFile.points = downSampledData.map{CGFloat($0)}
        
        
    }
    
}


struct readFile {
    static var arrayFloatValues:[Float] = []
    static var points:[CGFloat] = []
    
}
