import UIKit

class ViewController: UIViewController {
    let segmentControlButton = UISegmentedControl(items: ["LIST", "GRID"])
    let enrollButton = UIButton()

    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var gridView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.isHidden = true
        
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        configureSegmentControl()
        configureEnrollButton()
        navigationItem.titleView = segmentControlButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: enrollButton)
    }

    func configureSegmentControl() {
        segmentControlButton.frame = CGRect(x: 0.0, y: 0.0, width: 100, height: 30)
        segmentControlButton.selectedSegmentIndex = 0
        segmentControlButton.addTarget(self, action: #selector(changeView), for: .valueChanged)
    }
    
    func configureEnrollButton() {
        enrollButton.translatesAutoresizingMaskIntoConstraints = false
        enrollButton.addTarget(self, action: #selector(moveToEnrollView), for: .touchUpInside)
        enrollButton.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    @objc private func changeView(_ segmentControl: UISegmentedControl) {
        if segmentControlButton.selectedSegmentIndex == 0 {
            listView.isHidden = false
            gridView.isHidden = true
        } else {
            listView.isHidden = true
            gridView.isHidden = false
        }
    }
    
    @objc func moveToEnrollView(sender: UIButton) {
        let enrollViewController = EnrollViewController()
        present(enrollViewController, animated: true, completion: nil)
    }
}
