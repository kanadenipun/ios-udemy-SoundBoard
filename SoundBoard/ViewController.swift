//
//  ViewController.swift
//  SoundBoard
//
//  Created by NIPUN KANADE on 04/08/17.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioFile : URL?
    var audioSession : AVAudioSession?
    
    
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var fileNameTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
    }
    
    func setupRecorder(){
        do{
            
            audioSession = AVAudioSession.sharedInstance()
            try audioSession!.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession!.overrideOutputAudioPort(.speaker)
            try audioSession!.setActive(true)
        }
        catch let err as NSError{
            print("Error occured in audio session " + String(describing: err))
        }
        
        
        let basePath : String = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true).first!
        let pathComponents = [basePath, "recording.m4a"]
        audioFile = NSURL.fileURL(withPathComponents: pathComponents)
        
        print("#############  AUDIO URL ###############")
        print(audioFile?.absoluteString)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            try audioRecorder = AVAudioRecorder(url: audioFile!, settings: settings)
            audioRecorder!.prepareToRecord()
            
        }    catch let err as NSError{
            print("Error occured in audio recorder " + String(describing: err))
        }
        
    }
    
    @IBAction func recordButtonTapped(_ sender: Any, forEvent event: UIEvent) {
        
        print("record button tapped")
        
        if(audioRecorder!.isRecording){
            recordButton.setTitle("Record", for: .normal)
            audioRecorder?.stop()
            print("Recording stopped")
            
        }else{
            recordButton.setTitle("Stop", for: .normal)
            audioRecorder?.record()
            print("Recording Started")

        }
        
    
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        
        print(audioFile?.absoluteString)
        
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioFile!)
            audioPlayer!.play()
        }catch let err as NSError{
            print("Error in playing the file : " + String(describing: err))
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
}

