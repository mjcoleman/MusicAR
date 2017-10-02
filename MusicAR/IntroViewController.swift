//
//  IntroViewController.swift
//  MusicAR
//
//  Created by Michael Coleman on 1/07/17.
//  Copyright © 2017 Michael Coleman. All rights reserved.
//

import UIKit
import MediaPlayer

class IntroViewController: UIViewController, MPMediaPickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - MediaPickerDelegate
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        mediaPicker.dismiss(animated: true, completion: nil)
        let arvc : ARViewController = self.storyboard?.instantiateViewController(withIdentifier: "arvc") as! ARViewController
        
        arvc.createMusicItems(mediaItemCollection)
        self.navigationController?.present(arvc, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func selectMusic(_ sender: Any) {
        let picker = MPMediaPickerController.init(mediaTypes: .anyAudio)
        picker.delegate = self
        picker.allowsPickingMultipleItems = true
        picker.prompt = "Pick A Playlist"
        self.present(picker, animated: true, completion: nil)
        
    }
    
}
