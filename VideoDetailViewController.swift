//
//  VideoDetailViewController.swift
//  Created by Charles Dowd on 20/01/2016.
//

import Foundation
import AVKit
import AVFoundation

class VideoDetailViewController : NSObject {
    weak var avVideoViewController:AVPlayerViewController?
    var videoURL:NSURL!
    
    private var progressLevel:Float = 0.0 {
        didSet {
            NSLog("VideoDetailViewController.progressLevel \(progressLevel)")
            if let view = self.avVideoViewController?.view {
                MyProgressHUD.didSetProgessLevel(view, progressLevel: progressLevel)
            }
        }
    }
    
    
    override init() {
        super.init()
    }
    
    convenience init(avVideoViewController:AVPlayerViewController, videoURL:NSURL) {
        self.init()
        self.avVideoViewController = avVideoViewController
        self.videoURL = videoURL
        self.loadViewController()
    }
    
    private func loadViewController() {
        
        avVideoViewController?.player = AVPlayer(URL: videoURL)
        avVideoViewController?.showsPlaybackControls = true


        addObserverForURLLoad()
    }
    
    private func addObserverForURLLoad() {
        avVideoViewController?.player?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        progressLevel = 0.1
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object is AVPlayer && keyPath! == "status" && (object as! AVPlayer) == avVideoViewController?.player {
            if avVideoViewController?.player?.status == AVPlayerStatus.ReadyToPlay {
                NSLog("Play video now")
                avVideoViewController?.player?.play()
            } else if avVideoViewController?.player?.status == AVPlayerStatus.Failed {
                NSLog("Failed to load video")
            }
            progressLevel = 1.0
        }
    }
    
    deinit {
        self.avVideoViewController?.player?.removeObserver(self, forKeyPath: "status")
    }
    
}