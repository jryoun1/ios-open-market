import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    static let identifier = "GridCollectionViewCell"
    
    let itemImage: UIImageView = {
        let itemImage = UIImageView()
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        return itemImage
    }()
    
    let itemName: UILabel = {
        let itemName = UILabel()
        itemName.translatesAutoresizingMaskIntoConstraints = false
        itemName.font = UIFont.boldSystemFont(ofSize: 15)
        return itemName
    }()
    
    let itemPrice: UILabel = {
        let itemPrice = UILabel()
        itemPrice.translatesAutoresizingMaskIntoConstraints = false
        itemPrice.font = UIFont.boldSystemFont(ofSize: 10)
        itemPrice.textColor = .gray
        return itemPrice
    }()
    
    let itemDiscountedPrice: UILabel = {
        let itemDiscountedPrice = UILabel()
        itemDiscountedPrice.translatesAutoresizingMaskIntoConstraints = false
        itemDiscountedPrice.font = UIFont.boldSystemFont(ofSize: 10)
        itemDiscountedPrice.textColor = .red
        return itemDiscountedPrice
    }()
    
    let itemStock: UILabel = {
        let itemStock = UILabel()
        itemStock.translatesAutoresizingMaskIntoConstraints = false
        itemStock.font = UIFont.boldSystemFont(ofSize: 10)
        itemStock.textColor = .gray
        return itemStock
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addContentView()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addContentView() {
        contentView.addSubview(itemImage)
        contentView.addSubview(itemName)
        contentView.addSubview(itemPrice)
        contentView.addSubview(itemDiscountedPrice)
        contentView.addSubview(itemStock)
    }
    
    private func configureAutoLayout() {
        NSLayoutConstraint.activate([
            itemImage.topAnchor.constraint(equalTo: self.topAnchor),
            itemImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            itemImage.widthAnchor.constraint(equalToConstant: 100),
            itemImage.heightAnchor.constraint(equalToConstant: 100),
            itemImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            itemName.topAnchor.constraint(equalTo: itemImage.bottomAnchor),
            itemName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            itemPrice.topAnchor.constraint(equalTo: itemDiscountedPrice.bottomAnchor),
            itemPrice.heightAnchor.constraint(equalTo: itemName.heightAnchor),
            itemPrice.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            itemStock.topAnchor.constraint(equalTo: itemPrice.bottomAnchor),
            itemStock.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            itemDiscountedPrice.topAnchor.constraint(equalTo: itemName.bottomAnchor),
            itemDiscountedPrice.heightAnchor.constraint(equalTo: itemName.heightAnchor),
            itemDiscountedPrice.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
