//
//  SaveViewController.swift
//  NFT Create
//
//  Created by Enes on 25.01.2022.
//

import UIKit

class SaveViewController: UIViewController {

    @IBOutlet var saveImageView: UIImageView!
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveImageView.image = selectedImage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
