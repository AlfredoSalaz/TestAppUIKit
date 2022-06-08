//
//  HomeViewController.swift
//  AppProdctsList
//
//  Created by Alfredo Salazar on 06/06/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var lblnameProduct: UILabel?
    @IBOutlet weak var lblpriceProduct: UILabel?
    @IBOutlet weak var lblCategoryProduct: UILabel?
    @IBOutlet weak var viewCard: UIView?
    @IBOutlet weak var lblCodigoCategoria: UILabel?
    @IBOutlet weak var collectionView: UICollectionView?

    var urlImagenes: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView?.delegate = self
        viewCard?.layer.borderWidth = 1
        viewCard?.layer.borderColor = UIColor.blue.cgColor
    }

    @IBAction func loadProducts(_ sender: Any){
        let sto = UIStoryboard(name: "ListProductsStoryboard", bundle: nil)
        let vc = sto.instantiateViewController(identifier: "list") as ListProductsViewController
        present(vc, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        loadDataProduct()
    }
    func loadDataProduct(){
        let producto = Producto.shared
        if producto.nombre != "" && producto.nombre != nil{
            viewCard?.isHidden = false
            lblnameProduct?.text = producto.nombre
            lblCategoryProduct?.text = "CATEGORIA: \(producto.categoria ?? "")"
            lblpriceProduct?.text = "$\(producto.precioFinal ?? 0.0)"
            urlImagenes = producto.urlImagenes ?? []
            lblCodigoCategoria?.text = "Codigo categoria: \(producto.codigoCategoria ?? "")"
            DispatchQueue.main.async {
                self.loadImages()
            }
        }else{
            viewCard?.isHidden = true
        }
        
    }
    func loadImages(){
        collectionView?.reloadData()
    }

}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlImagenes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        let url = URL(string: urlImagenes[indexPath.row])
        cell.isHidden = false
        cell.activityIndicator.startAnimating()
        guard let urls = url else {
            return UICollectionViewCell()
        }
        cell.imageProduct.load(url: urls)
        cell.activityIndicator.stopAnimating()
        cell.activityIndicator.isHidden = true
        return cell
    }
    
    
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
