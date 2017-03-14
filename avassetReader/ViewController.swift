//
//  ViewController.swift
//  avassetReader
//
//  Created by Miguel  Saldana on 3/13/17.
//  Copyright © 2017 miguelDSP. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {

    @IBOutlet weak var waveFormView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // ...
        
        let url = Bundle.main.url(forResource: "sample2", withExtension: "m4a")
        let file = try! AVAudioFile(forReading: url!)
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false)
        print(file.fileFormat.channelCount)
        let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: UInt32(file.length))
        try! file.read(into: buf)
        
        // this makes a copy, you might not want that
         readFile.arrayFloatValues = Array(UnsafeBufferPointer(start: buf.floatChannelData?[0], count:Int(buf.frameLength)))
        
   //     print("floatArray \(readFile.arrayFloatValues)\n")
        //self.waveFormView.setNeedsDisplay()
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

