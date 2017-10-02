	//
//  MCMusicGrid.swift
//  MusicAR
//
//  Created by Michael Coleman on 1/07/17.
//  Copyright © 2017 Michael Coleman. All rights reserved.
//

import UIKit
import SceneKit
    
class MCMusicGrid: SCNNode {
    
    var gridPlane : SCNPlane = SCNPlane()
    

    init(musicItems : [MCMusicItem], w :Float, h:Float){
        super.init()
       gridPlane = SCNPlane(width: CGFloat(w), height: CGFloat(h))
        
        var item = 0
        var xPos : Float = 0
        var zPos : Float = 0
        var yPos : Float = 0
        
        for i in 0...5{
            for j in 0...5{
                if(musicItems[item].isPlaying){
                    yPos = 0.05
                    
                }else{
                    yPos = 0
                }
                musicItems[item].position = SCNVector3.init(xPos, yPos, zPos)
                
                xPos = xPos + 0.055
                self.addChildNode(musicItems[item])
                item = item + 1
            }
            
            xPos = 0
            zPos = zPos + 0.055
        }
        
        gridPlane.firstMaterial?.transparency=0.0
        self.geometry = gridPlane
        
        self.name = "Grid"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
