import UIKit

class ListTableViewController: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        return tableView
    }()
    
    var itemList: ItemList?
    var itemManager: ItemManager = ItemManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTableData()
        tableView.reloadData()
        
        addSubView()
        configureAutoLayout()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func addSubView() {
        view.addSubview(tableView)
    }
    
    func configureAutoLayout() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: guide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
    
    func loadTableData() {
        ItemManager.shared.loadData(method: .get, path: .items, param: 1) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    itemList = try JSONDecoder().decode(ItemList.self, from: data)
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
    
extension ListTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.items.count ?? 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        
        let stringOfStock: String = String(itemList?.items[indexPath.row].stock ?? 1000)
        let convertedStock: String = "잔여수량: " + stringOfStock
        let outOfStock: String = "품절"
        
        let stringOfPrice: String = String(itemList?.items[indexPath.row].price ?? 1000)
        let priceCurrency: String = itemList?.items[indexPath.row].currency ?? "USD"
        
        let discountPrice = itemList?.items[indexPath.row].discountedPrice ?? 500
        let discountedPrice: String = String(discountPrice)
    
        let url = URL(string: (itemList?.items[indexPath.row].thumbnails[0]))
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.itemImage.image = image
                }
            }
        }.resume()
        
        cell.itemName.text = itemList?.items[indexPath.row].title ?? "값 없음"
        cell.itemPrice.text = priceCurrency + " " + stringOfPrice
        if stringOfStock == "0" {
            cell.itemStock.text = outOfStock
            cell.itemStock.textColor = .yellow
        } else {
            cell.itemStock.text = convertedStock
        }
        if discountPrice != 0 {
            cell.itemDiscountedPrice.textColor = .red
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discountedPrice)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.itemDiscountedPrice.text = priceCurrency + " " + discountedPrice
        } else {
            cell.itemDiscountedPrice.isHidden = true
        }

        return cell
    }
}
