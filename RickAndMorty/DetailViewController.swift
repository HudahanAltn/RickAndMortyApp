//
//  DetailViewController.swift
//  RickAndMorty
//
//  Created by Hüdahan Altun on 31.03.2023.
//

import UIKit
import RickMortySwiftApi

class DetailViewController: UIViewController {

    
    var character:RMCharacterModel?//MainVC den gelen karakter verisini tutacak

    @IBOutlet weak var characterImageView: UIImageView!
    
    @IBOutlet weak var characterStatusTitle: UILabel!
    @IBOutlet weak var characterStatusLabel: UILabel!
    
    @IBOutlet weak var characterSpecyTitle: UILabel!
    @IBOutlet weak var characterSpecyLabel: UILabel!

    @IBOutlet weak var characterGenderTitle: UILabel!
    @IBOutlet weak var characterGenderLabel: UILabel!
    
    @IBOutlet weak var characterOriginTitle: UILabel!
    @IBOutlet weak var characterOriginLabel: UILabel!
    
    @IBOutlet weak var characterLocationTitle: UILabel!
    @IBOutlet weak var characterLocationLabel: UILabel!
    
    @IBOutlet weak var characterEpisodesTitle: UILabel!
    @IBOutlet weak var characterEpisodesLabel: UILabel!
    
    @IBOutlet weak var characterCreatedTitle: UILabel!
    @IBOutlet weak var characterCreatedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleColors()
        getCharacterDetails()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // aynı sayfada iken  cihaz dönüş yapınca değişen sayfa tasarımı
                   if size.width > size.height {//yatay

                       setHorizontalConstraint()
                   } else {//dikey
                       
                      setVerticalConstraint()
                   }

    }
    

    override func viewWillAppear(_ animated: Bool) {
        //sayfa açılışında cihaz duruşuna göre sayfa içeriği ayarlanır.
       let currentOrientation = UIDevice.current.orientation

        switch currentOrientation {
        case .portrait:
            print("Dikey duruş")
            setVerticalConstraint()
        case .landscapeLeft, .landscapeRight:
            print("yatay duruş")
            setHorizontalConstraint()
        default:
            print("Bilinmeyen duruş")
            let screenBounds = UIScreen.main.bounds
            let screenWidth = screenBounds.width
            let screenHeight = screenBounds.height

            if screenWidth > screenHeight{
                setHorizontalConstraint()
            }else{
                setVerticalConstraint()
            }
            
        }

        
        
    }
    


}

extension DetailViewController{

    func getEpisodes(episode:[String])->String{//gelen url'lerin sonlarındaki rakamı alıp direkt bölüm olarak yazdırdık.regular exprs kullandık.
        
        var episodes:String = String()
        
        for i in episode.indices{// url sayısı kdr döngü

            let string = episode[i]
            
            let pattern = "/episode/(\\d+)"

            if let range = string.range(of: pattern, options: .regularExpression) {
                // Eşleşen kısmın alt dizesini al
                let match = String(string[range])
                
                print("Eşleşme: \(match)")
                
                // Sayıyı al (Grup 1)
                if let numberRange = match.range(of: "\\d+", options: .regularExpression) {
                    
                    let number = String(match[numberRange])
                    episodes += "\(number). "
                    print("rakam: \(number)")
                }
            }
        
        }
        
        return episodes
    }
    
    
    
    
    
    
    func setHorizontalConstraint(){//cihaz yatay konumda iken constraintler
        
        //characterImageView Contraints
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        let _ = characterImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: +20.0).isActive = true

        let _ = characterImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -50).isActive = true
        let _ = characterImageView.heightAnchor.constraint(equalToConstant: 275.0).isActive = true
        let _ = characterImageView.widthAnchor.constraint(equalToConstant: 275.0).isActive = true

        //characterStatusTitle  and characterStatusLabel Constraint

        characterStatusTitle.translatesAutoresizingMaskIntoConstraints = false
        characterStatusLabel.translatesAutoresizingMaskIntoConstraints = false

        let _ = characterStatusTitle.bottomAnchor.constraint(equalTo: characterSpecyTitle.topAnchor,constant: -5.0).isActive=true
        let _ = characterStatusTitle.leftAnchor.constraint(equalTo: characterImageView.rightAnchor,constant: +20.0).isActive = true
        let _ = characterStatusTitle.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterStatusTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true

        let _ = characterStatusLabel.bottomAnchor.constraint(equalTo: characterSpecyLabel.topAnchor,constant: -5.0).isActive=true
        let _ = characterStatusLabel.leftAnchor.constraint(equalTo: characterStatusTitle.rightAnchor,constant: +20.0).isActive = true
        let _ = characterStatusLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterStatusLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

        //characterSpecyTitle  and characterSpecyLabel Constraint

        characterSpecyTitle.translatesAutoresizingMaskIntoConstraints = false
        characterSpecyLabel.translatesAutoresizingMaskIntoConstraints = false

        let _ = characterSpecyTitle.bottomAnchor.constraint(equalTo: characterGenderTitle.topAnchor,constant: -5.0).isActive=true
        let _ = characterSpecyTitle.leftAnchor.constraint(equalTo: characterImageView.rightAnchor,constant: +20.0).isActive = true
        let _ = characterSpecyTitle.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterSpecyTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true

        let _ = characterSpecyLabel.bottomAnchor.constraint(equalTo: characterGenderLabel.topAnchor,constant: -5.0).isActive=true
        let _ = characterSpecyLabel.leftAnchor.constraint(equalTo: characterSpecyTitle.rightAnchor,constant: +20.0).isActive = true
        let _ = characterSpecyLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterSpecyLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

        //characterGenderTitle and characterGenderLabel Constraints

        characterGenderTitle.translatesAutoresizingMaskIntoConstraints = false
        characterGenderLabel.translatesAutoresizingMaskIntoConstraints = false

        let _ = characterGenderTitle.bottomAnchor.constraint(equalTo: characterOriginTitle.topAnchor,constant: -5.0).isActive=true
        let _ = characterGenderTitle.leftAnchor.constraint(equalTo: characterImageView.rightAnchor,constant: +20.0).isActive = true
        let _ = characterGenderTitle.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterGenderTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true

        let _ = characterGenderLabel.bottomAnchor.constraint(equalTo: characterOriginLabel.topAnchor,constant: -5.0).isActive=true
        let _ = characterGenderLabel.leftAnchor.constraint(equalTo: characterGenderTitle.rightAnchor,constant: +20.0).isActive = true
        let _ = characterGenderLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterGenderLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

        //characterOriginTitle and characterOriginLabel Constraints

        characterOriginTitle.translatesAutoresizingMaskIntoConstraints = false
        characterOriginLabel.translatesAutoresizingMaskIntoConstraints = false

        let _ = characterOriginTitle.bottomAnchor.constraint(equalTo: characterLocationTitle.topAnchor,constant: -5.0).isActive=true
        let _ = characterOriginTitle.leftAnchor.constraint(equalTo: characterImageView.rightAnchor,constant: +20.0).isActive = true
        let _ = characterOriginTitle.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterOriginTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true

        let _ = characterOriginLabel.bottomAnchor.constraint(equalTo: characterLocationLabel.topAnchor,constant: -5.0).isActive=true
        let _ = characterOriginLabel.leftAnchor.constraint(equalTo: characterOriginTitle.rightAnchor,constant: +20.0).isActive = true
        let _ = characterOriginLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterOriginLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

        //characterLocationTitle and characterlocationLabel Constraints

        characterLocationTitle.translatesAutoresizingMaskIntoConstraints = false
        characterLocationLabel.translatesAutoresizingMaskIntoConstraints = false

        let _ = characterLocationTitle.bottomAnchor.constraint(equalTo: characterEpisodesTitle.topAnchor,constant: -5.0).isActive=true
        let _ = characterLocationTitle.leftAnchor.constraint(equalTo: characterImageView.rightAnchor,constant: +20.0).isActive = true
        let _ = characterLocationTitle.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterLocationTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true

        let _ = characterLocationLabel.bottomAnchor.constraint(equalTo: characterEpisodesLabel.topAnchor,constant: -5.0).isActive=true
        let _ = characterLocationLabel.leftAnchor.constraint(equalTo: characterLocationTitle.rightAnchor,constant: +20.0).isActive = true
        let _ = characterLocationLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterLocationLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true


        //characterEpisodesTitle and characterEpisodesLabel Constraints

        characterEpisodesTitle.translatesAutoresizingMaskIntoConstraints = false
        characterEpisodesLabel.translatesAutoresizingMaskIntoConstraints = false

        let _ = characterEpisodesTitle.bottomAnchor.constraint(equalTo: characterCreatedTitle.topAnchor,constant: -5.0).isActive = true
        let _ = characterEpisodesTitle.leftAnchor.constraint(equalTo: characterImageView.rightAnchor,constant: +20.0).isActive = true
        let _ = characterEpisodesTitle.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterEpisodesTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true

        let _ = characterEpisodesLabel.bottomAnchor.constraint(equalTo: characterCreatedLabel.topAnchor,constant: -5.0).isActive = true
        let _ = characterEpisodesLabel.leftAnchor.constraint(equalTo: characterEpisodesTitle.rightAnchor,constant: +20.0).isActive = true
        let _ = characterEpisodesLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterEpisodesLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

        //characterCreatedTitle and characterCreatedLabel Constraints

        characterCreatedTitle.translatesAutoresizingMaskIntoConstraints = false
        characterCreatedLabel.translatesAutoresizingMaskIntoConstraints = false

        let _ = characterCreatedTitle.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -100.0).isActive=true
        let _ = characterCreatedTitle.leftAnchor.constraint(equalTo: characterImageView.rightAnchor,constant: +20.0).isActive = true
        let _ = characterCreatedTitle.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterCreatedTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true

        let _ = characterCreatedLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -100.0).isActive=true
        let _ = characterCreatedLabel.leftAnchor.constraint(equalTo: characterCreatedTitle.rightAnchor,constant: +20.0).isActive = true
        let _ = characterCreatedLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterCreatedLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    func setVerticalConstraint(){ //cihaz dikey konumda iken constraintler
        
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        let _ = characterImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: +20.0).isActive = true

        let _ = characterImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: +50).isActive = true
        let _ = characterImageView.heightAnchor.constraint(equalToConstant: 275.0).isActive = true
        let _ = characterImageView.widthAnchor.constraint(equalToConstant: 275.0).isActive = true

        //characterStatusTitle  and characterStatusLabel Constraint

        characterStatusTitle.translatesAutoresizingMaskIntoConstraints = false
        characterStatusLabel.translatesAutoresizingMaskIntoConstraints = false

        let _ = characterStatusTitle.topAnchor.constraint(equalTo: characterImageView.bottomAnchor,constant: +20.0).isActive=true
        let _ = characterStatusTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: +20.0).isActive = true
        let _ = characterStatusTitle.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterStatusTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true

        let _ = characterStatusLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor,constant: +20.0).isActive=true
        let _ = characterStatusLabel.leftAnchor.constraint(equalTo: characterStatusTitle.rightAnchor,constant: +20.0).isActive = true
        let _ = characterStatusLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterStatusLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

        //characterSpecyTitle  and characterSpecyLabel Constraint

        characterSpecyTitle.translatesAutoresizingMaskIntoConstraints = false
        characterSpecyLabel.translatesAutoresizingMaskIntoConstraints = false

        let _ = characterSpecyTitle.topAnchor.constraint(equalTo: characterStatusTitle.bottomAnchor,constant: +5.0).isActive=true
        let _ = characterSpecyTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: +20.0).isActive = true
        let _ = characterSpecyTitle.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterSpecyTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true

        let _ = characterSpecyLabel.topAnchor.constraint(equalTo: characterStatusLabel.bottomAnchor,constant: +5.0).isActive=true
        let _ = characterSpecyLabel.leftAnchor.constraint(equalTo: characterSpecyTitle.rightAnchor,constant: +20.0).isActive = true
        let _ = characterSpecyLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterSpecyLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

        //characterGenderTitle and characterGenderLabel Constraints

        characterGenderTitle.translatesAutoresizingMaskIntoConstraints = false
        characterGenderLabel.translatesAutoresizingMaskIntoConstraints = false

        let _ = characterGenderTitle.topAnchor.constraint(equalTo: characterSpecyTitle.bottomAnchor,constant: +5.0).isActive=true
        let _ = characterGenderTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: +20.0).isActive = true
        let _ = characterGenderTitle.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterGenderTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true

        let _ = characterGenderLabel.topAnchor.constraint(equalTo: characterSpecyLabel.bottomAnchor,constant: +5.0).isActive=true
        let _ = characterGenderLabel.leftAnchor.constraint(equalTo: characterSpecyTitle.rightAnchor,constant: +20.0).isActive = true
        let _ = characterGenderLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterGenderLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

        //characterOriginTitle and characterOriginLabel Constraints

        characterOriginTitle.translatesAutoresizingMaskIntoConstraints = false
        characterOriginLabel.translatesAutoresizingMaskIntoConstraints = false

        let _ = characterOriginTitle.topAnchor.constraint(equalTo: characterGenderTitle.bottomAnchor,constant: +5.0).isActive=true
        let _ = characterOriginTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: +20.0).isActive = true
        let _ = characterOriginTitle.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterOriginTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true

        let _ = characterOriginLabel.topAnchor.constraint(equalTo: characterGenderLabel.bottomAnchor,constant: +5.0).isActive=true
        let _ = characterOriginLabel.leftAnchor.constraint(equalTo: characterOriginTitle.rightAnchor,constant: +20.0).isActive = true
        let _ = characterOriginLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterOriginLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

        //characterLocationTitle and characterlocationLabel Constraints

        characterLocationTitle.translatesAutoresizingMaskIntoConstraints = false
        characterLocationLabel.translatesAutoresizingMaskIntoConstraints = false

        let _ = characterLocationTitle.topAnchor.constraint(equalTo: characterOriginTitle.bottomAnchor,constant: +5.0).isActive=true
        let _ = characterLocationTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: +20.0).isActive = true
        let _ = characterLocationTitle.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterLocationTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true

        let _ = characterLocationLabel.topAnchor.constraint(equalTo: characterOriginLabel.bottomAnchor,constant: +5.0).isActive=true
        let _ = characterLocationLabel.leftAnchor.constraint(equalTo: characterOriginTitle.rightAnchor,constant: +20.0).isActive = true
        let _ = characterLocationLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterLocationLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true


        //characterEpisodeTitle and characterEpisodeLabel Constraints

        characterEpisodesTitle.translatesAutoresizingMaskIntoConstraints = false
        characterEpisodesLabel.translatesAutoresizingMaskIntoConstraints = false

        let _ = characterEpisodesTitle.topAnchor.constraint(equalTo: characterLocationTitle.bottomAnchor,constant: +5.0).isActive=true
        let _ = characterEpisodesTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: +20.0).isActive = true
        let _ = characterEpisodesTitle.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterEpisodesTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true

        let _ = characterEpisodesLabel.topAnchor.constraint(equalTo: characterLocationLabel.bottomAnchor,constant: +5.0).isActive=true
        let _ = characterEpisodesLabel.leftAnchor.constraint(equalTo: characterEpisodesTitle.rightAnchor,constant: +20.0).isActive = true
        let _ = characterEpisodesLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterEpisodesLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

        //characterCreatedTitle and characterCreatedLabel Constraints

        characterCreatedTitle.translatesAutoresizingMaskIntoConstraints = false
        characterCreatedLabel.translatesAutoresizingMaskIntoConstraints = false

        let _ = characterCreatedTitle.topAnchor.constraint(equalTo: characterEpisodesTitle.bottomAnchor,constant: +5.0).isActive=true
        let _ = characterCreatedTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: +20.0).isActive = true
        let _ = characterCreatedTitle.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterCreatedTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true

        let _ = characterCreatedLabel.topAnchor.constraint(equalTo: characterEpisodesLabel.bottomAnchor,constant: +5.0).isActive=true
        let _ = characterCreatedLabel.leftAnchor.constraint(equalTo: characterCreatedTitle.rightAnchor,constant: +20.0).isActive = true
        let _ = characterCreatedLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        let _ = characterCreatedLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
 
    func setTitleColors(){// sayfadaki labelların renklerini setlemek için kullandık
        let mortyYellow = UIColor(rgb:0xf8fe76)
        let portalGreen = UIColor(rgb:0x39ff14)
        let rickBlue = UIColor(rgb:0xb2dae4)
        self.view.backgroundColor = .black
        characterStatusTitle.textColor = portalGreen
        characterStatusLabel.textColor = rickBlue
        characterSpecyTitle.textColor = portalGreen
        characterSpecyLabel.textColor = rickBlue
        characterGenderTitle.textColor = portalGreen
        characterGenderLabel.textColor = rickBlue
        characterOriginTitle.textColor = portalGreen
        characterOriginLabel.textColor = rickBlue
        characterLocationTitle.textColor = portalGreen
        characterLocationLabel.textColor = rickBlue
        characterEpisodesTitle.textColor = portalGreen
        characterEpisodesLabel.textColor = rickBlue
        characterCreatedTitle.textColor = portalGreen
        characterCreatedLabel.textColor = rickBlue
        self.navigationController?.navigationBar.tintColor = portalGreen // back button color
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: mortyYellow]// navigation title color
    }
    
    func getCharacterDetails(){//karakter detaylarını almak için kullandık
        
        if let char = character{
            self.navigationItem.title = "\(char.name)".uppercased()
            self.characterStatusLabel.text = char.status
            self.characterSpecyLabel.text = char.species
            self.characterGenderLabel.text = char.gender
            self.characterOriginLabel.text = char.origin.name
            self.characterLocationLabel.text = char.location.name
            self.characterCreatedLabel.text = char.created
            
            if let imageURL = URL(string: char.image) {//resimler URL get ile geliyor
                URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                    
                    if(error != nil || data == nil){
                        
                        print("resim verileri alınamadı!")
                        
                        return
                    }
                    
                    if let imageData = data {
                        DispatchQueue.main.async {
                            self.characterImageView.image = UIImage(data: imageData)
                        }
                    }
                }.resume()
            }
            
            self.characterEpisodesLabel.text = getEpisodes(episode: char.episode)
        }
    }
}
