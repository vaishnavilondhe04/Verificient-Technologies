
import UIKit

struct Product: Decodable {
    let image:String
    let title:String
    var rating: Rating
    let description:String
}

struct Rating: Decodable {
    var rate : Double
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var arrdata = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getdata()
    }
    
    func getdata(){
        let url = URL(string: "https://fakestoreapi.com/products")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do{if error == nil{
                self.arrdata = try JSONDecoder().decode([Product].self, from: data!)
                
                for mainarr in self.arrdata{
                    print(mainarr.image,":",mainarr.title,":",mainarr.description,":")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }
                
            }catch{
                print("Error in get json data")
            }
            
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrdata.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        cell.titleLbl.text = (arrdata[indexPath.row].title)
        cell.ratingLbl.text = String("Rating: \(arrdata[indexPath.row].rating.rate)")
        
        let imgURL = URL.init(string: arrdata[indexPath.row].image )
        let imageData = try? Data.init(contentsOf: imgURL!)
        cell.img.image = UIImage.init(data: imageData!)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        secondVC.product = arrdata[indexPath.row]
        secondVC.delegate = self
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}

extension ViewController: SecondViewControllerProtocol {
    func updateRating(product: Product?, productIndex: Int) {
        guard let product = product else {
            print("Product missing")
            return
        }
        arrdata.remove(at: productIndex)
        arrdata.insert(product,
                       at: productIndex)
        tableView.reloadData()
    }
}

