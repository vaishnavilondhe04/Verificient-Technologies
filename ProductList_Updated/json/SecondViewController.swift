
import UIKit

protocol SecondViewControllerProtocol: AnyObject {
    func updateRating(product: Product?, productIndex: Int)
}

class SecondViewController: UIViewController {
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var txtRate: UITextField!
    
    var product: Product?
    weak var delegate: SecondViewControllerProtocol?
    var productIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLbl.text = product?.description
        txtRate.text = "\(product?.rating.rate ?? 0.0)"
    }
    
    @IBAction func updateRatingAction() {
        let updatedRating = Double(self.txtRate.text ?? "0.0") ?? 0.0
        self.product?.rating.rate = updatedRating
        delegate?.updateRating(product: self.product, productIndex: productIndex)
        self.navigationController?.popViewController(animated: true)
    }
}
