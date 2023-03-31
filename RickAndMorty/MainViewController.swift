//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Hüdahan Altun on 31.03.2023.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let logo = UIImage(named: "RickandMortyNavBar"){
        
            let imageView = UIImageView(image:logo)
            imageView.contentMode = .scaleAspectFit
            self.navigationItem.titleView = imageView
        }
        
        
       
    }


}

