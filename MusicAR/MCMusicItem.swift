//
//  MCMusicItem.swift
//  MusicAR
//
//  Created by Michael Coleman on 1/07/17.
//  Copyright © 2017 Michael Coleman. All rights reserved.
//

import UIKit
import SceneKit
import MediaPlayer


class MCMusicItem: SCNNode {
    var media : MPMediaItem
    var musicNode : SCNBox
    var texture : SCNMaterial
    var isPlaying : Bool = false
    var isShowingDetails : Bool = false
    var labelNode : SCNNode = SCNNode()
    var artworkImage : UIImage
    
    
    init(mediaItem : MPMediaItem){
        artworkImage = UIImage()
        media = mediaItem
        musicNode = SCNBox(width: 0.05, height: 0.002, length: 0.05, chamferRadius: 0.0)
        
        texture = SCNMaterial()
        if let artworkImage = media.artwork?.image(at: CGSize(width: 0, height:0)){
            texture.diffuse.contents = artworkImage
        }else{
            
            
            texture.diffuse.contents = UIImage(named: "texture.png")
        }
        musicNode.materials[0] = texture
        
        super.init()
        self.geometry = musicNode
        
        self.name = "Music"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showDetails(){
        let songNameString = NSMutableAttributedString(string: self.media.title!)
        songNameString.addAttribute(.foregroundColor, value: UIColor.white, range: NSMakeRange(0, songNameString.length))
        songNameString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: NSMakeRange(0, songNameString.length))
        
        let art = media.artwork?.image(at: CGSize(width: 0, height: 0))
        
        
        UIGraphicsBeginImageContext(CGSize(width: (art?.size.width)!, height: (art?.size.height)!))
        
        art?.draw(at: CGPoint.zero)
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(UIColor.black.cgColor)
        ctx?.setAlpha(0.5)
        ctx?.fill(CGRect(x: 0, y: 0, width: (art?.size.width)!, height: (art?.size.height)!))
        ctx?.setAlpha(1)
        
        
        songNameString.draw(in: CGRect(x: 10, y: 10, width: 100, height: 100))
        
        
        
        let detailsImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Could possibly fade by adding texture and animating alpha.
        texture.diffuse.contents = detailsImage
        
        isShowingDetails = true
        
        
        
    }
    
    func hideDetails(){
        let art = media.artwork?.image(at: CGSize(width: 0, height: 0))
        
        texture.diffuse.contents = art
        
        self.isShowingDetails = false
    }
    
    func runPlayAction(){
        
        var moveUpAction = SCNAction.move(to: SCNVector3Make(self.position.x, 0.05, self.position.z), duration: 0.5)
        var rotateAction = SCNAction.rotateBy(x: 0, y: 6, z: 0, duration: 2)
        var rotateForeverAction = SCNAction.repeatForever(rotateAction)
        self.runAction(moveUpAction)
        self.runAction(rotateForeverAction)
     
    }
    
    func stopPlayAction(){
        self.removeAllActions()
        
        var moveDownAction = SCNAction.move(to: SCNVector3Make(self.position.x, 0, self.position.z), duration: 0.5)
        var removeRotationAction = SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.1)
        var removeAllAction = SCNAction.run { (node) in
            self.removeAllActions()
        }
        var groupAction = SCNAction.sequence([removeRotationAction, moveDownAction, removeAllAction])
        self.runAction(groupAction)
        
    }
    
}
