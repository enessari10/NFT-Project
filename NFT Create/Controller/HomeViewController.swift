//
//  ViewController.swift
//  NFT Create
//
//  Created by Enes on 24.01.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var homeTableView: UITableView!
    var getData = GetDataClass()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
    }
    @IBAction func createButtonPressed(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "BackgroundUIViewController") as! BackgroundUIViewController
        resultViewController.title = "Backgrounds"
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
   
    
}




extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as? SliderTableViewCell else { fatalError()}
            return cell
        } else if indexPath.row == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "allCategoriesCell", for: indexPath) as? AllCategoryTableViewCell else { fatalError()}
            return cell
        } else if indexPath.row >= 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryTableViewCell else { fatalError()}
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 242
        }else if indexPath.row == 1{
            return 160
        }else if indexPath.row >= 2{
            return 165
        }else{
            return 165
        }
        
    }
}

