//
//  ViewController.swift
//  BabyImage
//
//  Created by lch on 13/09/2020.
//  Copyright © 2020 lch. All rights reserved.
//

import Cocoa
import SDWebImage
import AVFoundation
import Carbon

class ViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var leftBtn: NSButton!
    @IBOutlet weak var rightBtn: NSButton!
    @IBOutlet weak var changeAudio: NSButton!
    
    
    var player: AVAudioPlayer?
    var currentIndex : NSInteger!
    var currentAudioIndex : NSInteger!
    var imageURLs : Array<URL>!
    var audioURLs : Array<URL>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentIndex = 0;
        self.currentAudioIndex = 0;

        self.imageURLs = try? FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: "/var/hehuoya.com/baobao/imgs"), includingPropertiesForKeys: [URLResourceKey.nameKey], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        
        self.audioURLs = try? FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: "/var/hehuoya.com/baobao/audios"), includingPropertiesForKeys: [URLResourceKey.nameKey], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        
        self.view.addSubview(self.imageView!)
        
        let imgURL : URL = imageURLs[self.currentIndex]
        let imgstr = imgURL.absoluteString
        showImage(url: imgstr)
        self.play(path: self.audioURLs[0])
        // Do any additional setup after loading the view.
    }
    
    func showImage(url:String) {
        let _url = URL(string: url)
        self.imageView?.sd_setImage(with: _url, completed: { (image, error, type, url) in
        })
    }
    
    //播放
    func play(path:URL) {
        do {
            if player != nil {
                player?.stop()
                player = nil
            }
            player = try AVAudioPlayer(contentsOf: path)
            player!.play()
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
        }
    }
    
    @IBAction func handleAction(_ sender: NSButton) {
        if sender == self.leftBtn {
            if self.currentIndex > 0 {
                self.currentIndex -= 1
            }
            print("left")
            let imgURL : URL = imageURLs[self.currentIndex]
            let imgstr = imgURL.absoluteString
            showImage(url: imgstr)
        }
        else if sender == self.rightBtn {
            if self.imageURLs.count > self.currentIndex+1 {
                self.currentIndex += 1
            }
            let imgURL : URL = imageURLs[self.currentIndex]
            let imgstr = imgURL.absoluteString
            showImage(url: imgstr)
            
        }
        else if sender == self.changeAudio {
            if self.currentAudioIndex >= 0 && self.audioURLs.count > self.currentAudioIndex + 1 {
                self.currentAudioIndex += 1
            }
            else {
                self.currentAudioIndex = 0
            }
            self.play(path: self.audioURLs[self.currentAudioIndex])
        }
    }
    
      

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func keyDown(with event: NSEvent) {
        let keycode = event.keyCode
        if (keycode == kVK_Space || keycode == kVK_RightArrow) { //space
            if self.imageURLs.count > self.currentIndex+1 {
                self.currentIndex += 1
            }
        }
        else {
            if self.currentIndex > 0 {
                self.currentIndex -= 1
            }
        }
        let imgURL : URL = imageURLs[self.currentIndex]
        let imgstr = imgURL.absoluteString
        showImage(url: imgstr)
    }


}

