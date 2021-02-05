import UIKit

class GridCollectionViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .init(x: 0, y:0, width: 300, height: 300), collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    var itemList: ItemList?
    var itemManager: ItemManager = ItemManager.shared
    
    let semaphore = DispatchSemaphore(value: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCollectionData()
        
        semaphore.wait()
        
        addSubView()
        configureAutoLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func addSubView() {
        view.addSubview(collectionView)
    }
    
    func configureAutoLayout() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: guide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
    
    func loadCollectionData() {
        ItemManager.shared.loadData(method: .get, path: .items, param: 1) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    itemList = try JSONDecoder().decode(ItemList.self, from: data)
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        semaphore.signal()
    }
}

extension GridCollectionViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as! GridCollectionViewCell
        
        let stringOfStock: String = String(itemList?.items[indexPath.row].stock ?? 1000)
        let convertedStock: String = "잔여수량: " + stringOfStock
        
        let stringOfPrice: String = String(itemList?.items[indexPath.row].price ?? 1000)
        let priceCurrency: String = itemList?.items[indexPath.row].currency ?? "USD" + stringOfPrice
        let outOfStock: String = "품절"
        
        let discountPrice: String = String(itemList?.items[indexPath.row].discountedPrice ?? 500)
        
//        let url = URL(string: (itemList?.items[indexPath.row].thumbnails[0])!)
//        URLSession.shared.dataTask(with: url!) { (data, response, error) in
//            if let data = data, let image = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    cell.itemImage.image = image
//                }
//            }
//        }.resume()
        
        cell.itemName.text = itemList?.items[indexPath.row].title ?? "값 없음"
        cell.itemPrice.text = priceCurrency + " " + stringOfPrice
        if stringOfStock == "0" {
            cell.itemStock.text = outOfStock
            cell.itemStock.textColor = .yellow
        } else {
            cell.itemStock.text = convertedStock
        }
        if discountPrice != "0" {
            cell.itemDiscountedPrice.text = priceCurrency + " " + discountPrice
            cell.itemDiscountedPrice.textColor = .red
        } else {
            cell.itemDiscountedPrice.isHidden = true
        }
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 6.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width / 2) - 10

        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
