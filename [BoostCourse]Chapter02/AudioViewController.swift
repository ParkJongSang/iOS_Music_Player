//
//  AudioViewController.swift
//  [BoostCourse]Chapter02
//
//  Created by 박종상 on 2020/02/09.
//  Copyright © 2020 박종상. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController, AVAudioPlayerDelegate {

    var audioPlayer : AVAudioPlayer!
    var timer : Timer!
    
    @IBOutlet weak var timeSlideBar: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBAction func touchPlayBtn(_ sender: UIButton) {
        
        if sender.currentImage == #imageLiteral(resourceName: "button_play"){
            audioPlayer.play()
            sender.setImage(#imageLiteral(resourceName: "button_pause.pdf"), for: .normal)
            updateTimer()
        }else{
            audioPlayer.pause()
            sender.setImage(#imageLiteral(resourceName: "button_play.pdf"), for: .normal)
            invalidateTimer()
        }

    }
    
    @IBAction func touchSlider(_ sender: UISlider) {
        makeTimeLabel(time: TimeInterval(sender.value))
        if sender.isTracking { return }
        self.audioPlayer.currentTime = TimeInterval(sender.value)
    }
    
    func makeTimeLabel(time:TimeInterval){
        let min:Int = Int(time/60)
        let sec:Int = Int(time.truncatingRemainder(dividingBy: 60))
        let mil:Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        
        let timeText = String(format: "%02ld:%02ld:%02ld", min, sec, mil)
        
        timeLabel.text = timeText
    }
    
    func updateTimer(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {[unowned self](timer:Timer) in
            if self.timeSlideBar.isTracking { return }
            self.makeTimeLabel(time: self.audioPlayer.currentTime)
            self.timeSlideBar.value = Float(self.audioPlayer.currentTime)
            
            if self.audioPlayer.isPlaying == false{
                self.playBtn.setImage(#imageLiteral(resourceName: "button_play.pdf"), for: .normal)
            }else{
                self.playBtn.setImage(#imageLiteral(resourceName: "button_pause"), for: .normal)
            }
        })
        self.timer.fire()
    }
    
    func invalidateTimer(){
        self.timer.invalidate();
        self.timer = nil;
    }
    
    func endMusic(){
        self.playBtn.setImage(#imageLiteral(resourceName: "button_play.pdf"), for: .normal)
        self.timeSlideBar.value = 0
        makeTimeLabel(time: 0)
        self.invalidateTimer()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let soundAsset : NSDataAsset = NSDataAsset(name : "sound") else {
            print("음원없음");
            return;
        }
        do{
            self.audioPlayer = try AVAudioPlayer(data: soundAsset.data)
            self.audioPlayer.delegate = self
        }catch{
            print("initailize fail")
        }
        
        self.timeSlideBar.maximumValue = Float(self.audioPlayer.duration);
        self.timeSlideBar.minimumValue = 0;
        self.timeSlideBar.value = Float(self.audioPlayer.currentTime);

        playBtn.setImage(#imageLiteral(resourceName: "button_play.pdf"), for: .normal)
    }

}
