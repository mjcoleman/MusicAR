//
//  ViewController.swift
//  MusicAR
//
//  Created by Michael Coleman on 1/07/17.
//  Copyright © 2017 Michael Coleman. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import MediaPlayer

class ARViewController: UIViewController, ARSCNViewDelegate{

    @IBOutlet var sceneView: ARSCNView!
    var musicItems : [MCMusicItem] = []
    var mediaPlayer : MPMusicPlayerController = MPMusicPlayerController.applicationMusicPlayer
    var musicGrid : MCMusicGrid?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.automaticallyUpdatesLighting = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        
        // Run the view's session
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        mediaPlayer.stop()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    
    func createMusicItems(_ collection : MPMediaItemCollection){
        for item in collection.items{
            let musicItem = MCMusicItem(mediaItem: item)
            musicItems.append(musicItem)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: sceneView)
            let hits = sceneView.hitTest(touchLocation, options: nil)
            
            if let hitMusic = hits.first{
                if(hitMusic.node.name == "Music"){
                    let musicNode : MCMusicItem = hitMusic.node as! MCMusicItem
                    if musicNode.isPlaying{
                        mediaPlayer.stop()
                        musicNode.isPlaying = false
                        musicNode.stopPlayAction()
                    }else{
                        mediaPlayer.setQueue(with: MPMediaItemCollection.init(items: [musicNode.media]))
                        mediaPlayer.play()
                        musicNode.isPlaying = true
                        musicNode.runPlayAction()
                    
                    }
                }
            }
        }
    }
    

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        if let pov = sceneView.pointOfView{
            for node in sceneView.nodesInsideFrustum(of: pov){
                if node.name == "Music"{
                    let musicNode : MCMusicItem = node as! MCMusicItem
                    var nodePoint = CGPoint(x: CGFloat(node.position.y), y: CGFloat(node.position.z))
                    var cameraPoint = CGPoint(x: CGFloat(pov.position.y), y: CGFloat(pov.position.z))
                    //print(self.getDistanceBetweenPoints(first: nodePoint, second: cameraPoint))
                    
                    if self.getDistanceBetweenPoints(first: nodePoint, second: cameraPoint) > 0.4{
                        if(!musicNode.isShowingDetails){
                            musicNode.showDetails()
                        }
                    }else{
                        if(musicNode.isShowingDetails){
                            musicNode.hideDetails()
                        }
                    }
                }
                
            }
        }
        
    }
    
    // When a plane is detected, make a planeNode for it
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        
        
         let grid = MCMusicGrid(musicItems: self.musicItems, w: planeAnchor.extent.x, h: planeAnchor.extent.z)
        grid.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
       // grid.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        // ARKit owns the node corresponding to the anchor, so make the plane a child node.
        node.addChildNode(grid)
    }
    
    // When a detected plane is updated, make a new planeNode
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Remove existing plane nodes
        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
        
        
         let grid = MCMusicGrid(musicItems: self.musicItems, w: planeAnchor.extent.x, h: planeAnchor.extent.z)
        grid.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
       // grid.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        node.addChildNode(grid)
    }
    
    // When a detected plane is removed, remove the planeNode
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
         //Remove existing plane nodes
        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
    
    func getDistanceBetweenPoints(first : CGPoint, second : CGPoint)->CGFloat{
        return CGFloat(hypotf(Float(second.x - first.x), Float(second.y - first.y)))
    }
    
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    
    
}
