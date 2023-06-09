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
    
    let rmClient = RMClient()//client başlatıldı
    
    var RMLocations:[RMLocationModel] = [RMLocationModel]()//url get isteğine bağlı olarak gelecek RM dünyalarının tutulacağı dizi.
    
    var residentsURL:[String] = [String]()//CV'ye tıklayınca gelen residents bilg tutulacağı liste
    var RMCharacters:[RMCharacterModel] = [RMCharacterModel]()//her bir residentUrl get işlemi yapılınca gelen karakterlerin tutulacağı liste
    
    var pagenumber = 1// ilk 20 lokasyon fetch isteği için gereken int değer. ayrıca diğer sayfaların görüntülenmesi içinde oluşturuldu.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRMLogo()//NavBar a RM logosu gösterir
        
        //page = 1 dünyaları viewdidload ile birlikte gelecek
        getRMLocByPageNum(pagenum: 1) { result in
                switch result {
                case .success(let locations):
                    // Veri işleme işlemleri burada yapılır
                    self.RMLocations = locations.reversed().reversed()//url'den gelen sıra ile alıyoruz.
                    self.collectionViewWorldTypes.reloadData()//CV güncellenecek
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let character = sender as? RMCharacterModel{
            //detailVC sayfasına tıklanılan hücredeki karakter nesnesini yolluyoruz.
            let goToDetailPage = segue.destination as! DetailViewController
            goToDetailPage.character = character
        }
    }
    
    func loadRMLogo(){//Nav bara RM logosu gösterir.
        if let logo = UIImage(named: "RickandMortyNavBar"){
        
            let imageView = UIImageView(image:logo)
            imageView.contentMode = .scaleAspectFit
            self.navigationItem.titleView = imageView
        }
    }
}


//MARK: - TableView Protocol Fonksiyonları
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
        
        //cell border tasarım
        cell.layer.borderColor = UIColor(rgb: 0x39ff14).cgColor//portal green
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5
        
        //basit animasyon yapısı
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.5, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.0,1.0,1)
            },completion: { finished in
                UIView.animate(withDuration: 0.3, animations: {
                    cell.layer.transform = CATransform3DMakeScale(1,1,1)
                })
        })
                
        //resim dosyası alma işlemleri
        if let imageURL = URL(string: RMCharacters[indexPath.row].image) {
            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                
                if(error != nil || data == nil){
                    print("Resim verileri alınamadı!)")
                    return
                }
    
                if let imageData = data {
                    DispatchQueue.main.async {
                        cell.characterImage.image = UIImage(data: imageData)
                    }
                }
            }.resume()
        }
        return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tıklanılan hücredeki karakter nesnesini alıp yollayacağız.
        let character = RMCharacters[indexPath.row]
        
        self.performSegue(withIdentifier: "MainToDetail", sender: character)
    }
}

//MARK: - CollectionView Protocol Fonksiyonları
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
        RMCharacters.removeAll()//her seferinde yeni dünyaya tıklayınca listeyi sıfırlaki yeni içerik gelirken ekran temiz gözüksün
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = .lightGray // Seçili hücre rengi atandı
        }
        
        //tableview içeriği yüklenmeye başlamadan önce loading için activityIndcatorView oluşturuldu.Kullanıcı deneyimi için uzun süren loading işlemlerinde kullanıcıya bilgi verilir.
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor(rgb: 0x39ff14)
        tableViewCharacterTypes.tableHeaderView = activityIndicatorView
        activityIndicatorView.startAnimating()// animasyon başlar
        tableViewCharacterTypes.reloadData()
        
        let noResultsLabel = UILabel()//tableview üzerinde hiçbir içerik olmaması durumunda kullanıcıya bilgi verilmesi için basit label yaratıldı.
        noResultsLabel.text = ""//içeriği en başta boş olacak
        tableViewCharacterTypes.backgroundView = noResultsLabel// label tableview'e eklendi
        
        //tıklanılan dünyaya göre o dünyadaki karakterlerin gelmesi
        Task {// cv içinde async fonks çalıştırmak için kullanılacak yapı
            do {
                let result = try await self.getCharacterByWorld()
                RMCharacters = result
                activityIndicatorView.stopAnimating()// url get işlemi bitip Tableview'a veri gelince animasyon durur.
                tableViewCharacterTypes.reloadData()
                print("Asenkron görev tamamlandı. Sonuç: \(result)")
                
                if result.isEmpty{// hiç veri gelmez ise "sonuç bulunamadı" bildirimi gösterilir.
                    noResultsLabel.text = "Gösterilecek karakter bulunamadı."
                    noResultsLabel.textAlignment = .center
                    noResultsLabel.textColor = UIColor(rgb: 0x39ff14)
                    noResultsLabel.numberOfLines = 0 // Birden fazla satır kullanabilmesi için numberOfLines özelliğini 0 olarak ayarlayın
                    
                    tableViewCharacterTypes.backgroundView = noResultsLabel
                }
            } catch {
                print("Asenkron görev hata ile tamamlandı: \(error)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = .clear // Seçimi kaldırınca hücre rengi temizlenir.
        }
    }
    
    
}

//MARK: - UICollectionView Scroll Fonksiyonu
extension MainViewController{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {//görünen en son cell'i tespit etme mantığıyla CV'nin sonuna gelince yeni location yüklemesi yapan fonks.
        
        let visibleCells = collectionViewWorldTypes.indexPathsForVisibleItems // görünen cell'ler alındı
            if let currentIndexPath = visibleCells.first {//ilkini al
                
                if (currentIndexPath.item == RMLocations.count - 1){// rmloc cell sayısı 20 sıra 19 görününce sonda oldğumuz anlaşılıyor
                    
                    //index path sıfırlama ve scrollu sol başa kaydırma
                    let indexPath = IndexPath(item: 0, section: 0)
                    collectionViewWorldTypes.scrollToItem(at: indexPath, at: .left, animated: true)
                    RMLocations.removeAll()//liste  yeni lokasyonlar geleceği için temizlenmeli
                    
                    pagenumber += 1// yeni lok gelmesi içn url get page num increment edilir.
                    
                    if(pagenumber < 7){// toplam 6 sayfa gösterilecek

                        //1-6 sayfaları tekrar al ve RMloc ' a yükle
                        getRMLocByPageNum(pagenum:pagenumber) { result in
                                switch result {
                                case .success(let locations):
                                    self.RMLocations = locations.reversed().reversed()
                                    self.collectionViewWorldTypes.reloadData()
                                case .failure(let error):
                                    print(error)
                                }
                            }
                    }else{
                        // son sayfa yı görüntüleyince artık CV'nin sonuna gidilince ilk sayfa gtekrar görüntülenmeli
                        pagenumber = 1//bu yüzden page number 1 e setlenir
                        
                        getRMLocByPageNum(pagenum:pagenumber) { result in
                                switch result {
                                case .success(let locations):
                                    self.RMLocations = locations.reversed().reversed()
                                    self.collectionViewWorldTypes.reloadData()
                                case .failure(let error):
                                    print(error)
                                }
                            }
                    }
                }
            }
    }

}

//MARK: - MainVC tasarım fonksiyonları
extension MainViewController{
    
    func structureCVCell(){//CVdeki hücrenin  ekran üzerindeki tasarımı.
        
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
}

//MARK: - Rick and Morty API fonksiyonları
extension MainViewController{
    
    func getCharacterByWorld()async throws->[RMCharacterModel]{//karakterleri dünyaya göre alan fonks.

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
                
                // Sayıyı al sonra karakteri al
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
    
    func getRMLocByPageNum(pagenum:Int,completionHandler: @escaping (Result<[RMLocationModel], Error>) -> Void) {
        //async fonksiyonun viewDidload içerisinde kullanılması için oluşturulan
        Task {
            do {
                let locations = try await rmClient.location().getLocationsByPageNumber(pageNumber: pagenum)//veriler alındı
                completionHandler(.success(locations))
                
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
}

