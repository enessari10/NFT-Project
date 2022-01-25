//
//  AnimationClass.swift
//  NFT Create
//
//  Created by Enes on 25.01.2022.
//

import Foundation
import Lottie

class AnimationClass{
    var vc = HomeViewController()

    func animationStart(){
        vc.animationView!.isHidden = false
        vc.animationView = .init(name: "lottie-loading")
        vc.animationView!.frame = vc.view.bounds
        vc.animationView!.contentMode = .scaleAspectFit
        vc.animationView!.loopMode = .loop
        vc.animationView!.animationSpeed = 0.5
        vc.view.addSubview(vc.animationView!)
        vc.animationView!.play()
        
    }
    
    func animationStop(){
        vc.animationView!.stop()
        vc.animationView.isHidden = true
    }
}
