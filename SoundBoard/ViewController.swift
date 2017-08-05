//
//  ViewController.swift
//  SoundBoard
//
//  Created by NIPUN KANADE on 04/08/17.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioFile : URL?
    var audioSession : AVAudioSession?
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var fileNameTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupRecorder()
        saveButton.isEnabled = false;
        playButton.isEnabled = false;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell:CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)  as! CustomTableViewCell
       
        cell.cellLabel.text = "Hello"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected")
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
            playButton.isEnabled = true;
            saveButton.isEnabled = true;
            
        }else{
            recordButton.setTitle("Stop", for: .normal)
            audioRecorder?.record()
            print("Recording Started")
            playButton.isEnabled = false;
            saveButton.isEnabled = false;
        }
        
    
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioFile!)
            audioPlayer!.play()
        }catch let err as NSError{
            print("Error in playing the file : " + String(describing: err))
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: context)
        
        sound.name = fileNameTextField.text ?? "No Name"
        sound.audioFile = NSData(contentsOf: audioFile!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }
    
}

