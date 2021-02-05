import UIKit

class ListTableViewCell: UITableViewCell {

    static let identifier = "ListTableViewCell"
    
    let itemImage: UIImageView = {
        let itemImage = UIImageView()
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        return itemImage
    }()
    
    let itemName: UILabel = {
        let itemName = UILabel()
        itemName.translatesAutoresizingMaskIntoConstraints = false
        itemName.font = .preferredFont(forTextStyle: .headline)
        return itemName
    }()
    
    let itemPrice: UILabel = {
        let itemPrice = UILabel()
        itemPrice.translatesAutoresizingMaskIntoConstraints = false
        itemPrice.font = .preferredFont(forTextStyle: .body)
        itemPrice.textColor = .gray
        return itemPrice
    }()
    
    let itemDiscountedPrice: UILabel = {
        let itemDiscountedPrice = UILabel()
        itemDiscountedPrice.translatesAutoresizingMaskIntoConstraints = false
        itemDiscountedPrice.font = .preferredFont(forTextStyle: .body)
        itemDiscountedPrice.textColor = .red
        return itemDiscountedPrice
    }()
    
    let itemStock: UILabel = {
        let itemStock = UILabel()
        itemStock.translatesAutoresizingMaskIntoConstraints = false
        itemStock.font = .preferredFont(forTextStyle: .body)
        itemStock.textColor = .gray
        return itemStock
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        let margin: CGFloat = 5
        
        NSLayoutConstraint.activate([
            itemImage.topAnchor.constraint(equalTo: self.topAnchor),
            itemImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            itemImage.widthAnchor.constraint(equalToConstant: 50),
            itemImage.heightAnchor.constraint(equalToConstant: 50),
            
            itemName.topAnchor.constraint(equalTo: self.topAnchor),
            itemName.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: margin),
            
            itemPrice.topAnchor.constraint(equalTo: itemName.bottomAnchor),
            itemPrice.leadingAnchor.constraint(equalTo: itemDiscountedPrice.trailingAnchor, constant: margin),
            itemPrice.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            itemPrice.heightAnchor.constraint(equalTo: itemName.heightAnchor),
            
            itemStock.topAnchor.constraint(equalTo: self.topAnchor),
            itemStock.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            itemStock.heightAnchor.constraint(equalTo: itemName.heightAnchor),
            
            itemDiscountedPrice.topAnchor.constraint(equalTo: itemName.bottomAnchor),
            itemDiscountedPrice.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant: margin),
            itemPrice.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            itemPrice.heightAnchor.constraint(equalTo: itemName.heightAnchor)
        ])
    }
}
