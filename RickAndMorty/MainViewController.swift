//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Hüdahan Altun on 31.03.2023.
//

import UIKit
import RickMortySwiftApi
class MainViewController: UIViewController{

   //ekran size değerleri en başta alınıyor ve değişmeden kalıyor bunlar TV cell yapılandırılmasında kullanılacak
    let screenWidthG = UIScreen.main.bounds.width
    let screenHeightG = UIScreen.main.bounds.height
    
    @IBOutlet weak var collectionViewWorldTypes: UICollectionView!
    @IBOutlet weak var tableViewCharacterTypes: UITableView!
    
    var temp = ["hüdahan","hüdahan2"]//deneme listesi
    
    let rmClient = RMClient()//cliend başlatıldı
    
    var RMLocations:[RMLocationModel] = [RMLocationModel]()//url get isteğine bağlı olarak gelecek RM dünyalarının tutulacağı dizi.
    
    var residentsURL:[String] = [String]()//CV'ye tıklayınca gelen residents bilg tutulacağı liste
    var RMCharacters:[RMCharacterModel] = [RMCharacterModel]()//her bir residentUrl get işlemi yapılınca gelen karakterlerin tutulacağı liste
    
    
    func fetchDataLoc(completionHandler: @escaping (Result<[RMLocationModel], Error>) -> Void) {
        //async fonksiyonun viewDidload içerisinde kullanılması için oluşturulan
        Task {
            do {
                let locations = try await rmClient.location().getAllLocations()
                completionHandler(.success(locations))
                
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let logo = UIImage(named: "RickandMortyNavBar"){
        
            let imageView = UIImageView(image:logo)
            imageView.contentMode = .scaleAspectFit
            self.navigationItem.titleView = imageView
        }
        
        //dünyalar viewdidload ile birlikte gelecek
        fetchDataLoc { result in
                switch result {
                case .success(let locations):
                    // Veri işleme işlemleri burada yapılır
                    self.RMLocations = locations.shuffled()//rastgele sırada alıyoruz.
                    self.collectionViewWorldTypes.reloadData()//CV güncellenecek
                    print("lokasyonlar alındı: \(locations)")
                case .failure(let error):
                    print(error)
                }
            
            }
        
        
        structureCVCell()
        //protocol bağlantıları
        tableViewCharacterTypes.delegate = self
        tableViewCharacterTypes.dataSource = self
        collectionViewWorldTypes.delegate = self
        collectionViewWorldTypes.dataSource = self
        //TV ve CV arkaplan renkleri
        collectionViewWorldTypes.backgroundColor = .black
        tableViewCharacterTypes.backgroundColor = .black
    }
    
   
 
}



extension MainViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return RMCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell",for:indexPath) as! TableViewCellCharacters

        //cell tasarım
        cell.characterLabel.lineBreakMode = .byWordWrapping
        cell.characterLabel.numberOfLines = 2
        cell.characterImage.frame.size = CGSize(width: screenHeightG/5, height: screenHeightG/5)
        cell.characterLabel.textColor = UIColor(rgb:0xb2dae4)//rickblue
        cell.characterLabel.text = RMCharacters[indexPath.row].name
        cell.genderIconImage.image = UIImage(named: RMCharacters[indexPath.row].gender)
        cell.genderIconImage.frame.size = CGSize(width: screenHeightG/15, height: screenHeightG/15)
        
       
        //resim dosyası alma işlemleri
        if let imageURL = URL(string: RMCharacters[indexPath.row].image) {
            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                
                if(error != nil || data == nil){
                    
                    print("resim verileri alınamadı!")
                    return
                }
                
                if let imageData = data {
                    DispatchQueue.main.async {
                        cell.characterImage.image = UIImage(data: imageData)
                    }
                }
            }.resume()
        }

        //cell border tasarım
        cell.layer.borderColor = UIColor(rgb: 0x39ff14).cgColor//portal green
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //TV cell boyutunu cihazın yatay ve dikey konumuna göre ayarladık.
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        
        var rowHeight:CGFloat = screenHeight/5
        let currentDevice = UIDevice.current

        if currentDevice.orientation.isPortrait {
            // Dikey modda
            rowHeight = screenHeight/5
        } else if currentDevice.orientation.isLandscape {
            // Yatay modda
            rowHeight = screenWidth/5
        }
        
        
        return rowHeight
    }
}

extension MainViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RMLocations.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let location = RMLocations[indexPath.row]//location'ı al
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "worldCell", for: indexPath)
        as! CollectionViewCellLocations
        
        //Cell içi label tasarımı
        cell.worldName.textColor = UIColor(rgb:0xf8fe76)//morty yellow
        cell.worldName.text = location.name//ismi cell'e yazdır.
        let genislik = self.collectionViewWorldTypes.frame.size.width
        let maxSize = CGSize(width: genislik/2-5, height: 50)
        let fitSize = cell.worldName.sizeThatFits(maxSize)
        cell.worldName.frame.size = fitSize
        cell.worldName.textAlignment = .center
        
        //Cell border tasarım
        cell.layer.borderColor = UIColor(rgb: 0x39ff14).cgColor//portal green
        cell.backgroundColor = .black
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 7
        return cell
    
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        residentsURL = RMLocations[indexPath.row].residents// dünyaya göre tek bir karakter veren url listesi
        
        tableViewCharacterTypes.reloadData()
        DispatchQueue.main.async {
            
        }
        Task {// cv içinde async fonks çalıştırmak için kullanılacak yapı
                do {
                    let result = try await self.getCharacterByWorld()
                    RMCharacters = result
                    tableViewCharacterTypes.reloadData()
                    print("Asenkron görev tamamlandı. Sonuç: \(result)")
                } catch {
                    print("Asenkron görev hata ile tamamlandı: \(error)")
                }
            }
    }

}

extension MainViewController{
    
    func structureCVCell(){//CVdeki hücrenin tasarımı
        let design:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        design.scrollDirection = .horizontal
        let genislik = self.collectionViewWorldTypes.frame.size.width
        design.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        design.minimumLineSpacing = 5
        design.minimumInteritemSpacing = 10
        let hücreGenislik = genislik/2
        design.itemSize = CGSize(width: hücreGenislik, height: 50)
        collectionViewWorldTypes.collectionViewLayout = design
    }
    
    func getCharacterByWorld()async throws->[RMCharacterModel]{

        var rmCharacter:[RMCharacterModel] = [RMCharacterModel]()// geçici liste
        
        for i in residentsURL.indices{// url sayısı kdr döngü

            
            let string = residentsURL[i]

            //"Https://rickandmortyapi.com/api/character/2" buradaki 2 gibi sayıları alabiliyorıuz.
            // Regex patterni(regular expression ile url in sonundaki id'leri alıyoruz)
            let pattern = "/character/(\\d+)"

            if let range = string.range(of: pattern, options: .regularExpression) {
                // Eşleşen kısmın alt dizesini al
                let match = String(string[range])
                print("Eşleşme: \(match)")
                
                // Sayıyı al (Grup 1)
                if let numberRange = match.range(of: "\\d+", options: .regularExpression) {
                    let number = String(match[numberRange])
                    let character = try await rmClient.character().getCharacterByID(id: Int(number)!)
                    rmCharacter.append(character)
                    print("rakam: \(number)")
                }
            }
        
        }
        
        return rmCharacter
    }
}

