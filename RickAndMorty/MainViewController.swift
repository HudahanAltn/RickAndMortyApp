//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Hüdahan Altun on 31.03.2023.
//

import UIKit

class MainViewController: UIViewController{

   
    @IBOutlet weak var collectionViewWorldTypes: UICollectionView!
    @IBOutlet weak var tableViewCharacterTypes: UITableView!
    
    var temp = ["hüdahan","hüdahan2"]
    var safeAreaWidth:CGFloat = 0.0
    var safeAreaHeight:CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let logo = UIImage(named: "RickandMortyNavBar"){
        
            let imageView = UIImageView(image:logo)
            imageView.contentMode = .scaleAspectFit
            self.navigationItem.titleView = imageView
        }
        
        
    
        tableViewCharacterTypes.delegate = self
        tableViewCharacterTypes.dataSource = self
        collectionViewWorldTypes.delegate = self
        collectionViewWorldTypes.dataSource = self
    }
    
   
 
}



extension MainViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return temp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell",for:indexPath)
        cell.textLabel?.text = temp[indexPath.row]
        return cell
    }
}

extension MainViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "worldCell", for: indexPath)
        
        return cell
    }
    
    
}
