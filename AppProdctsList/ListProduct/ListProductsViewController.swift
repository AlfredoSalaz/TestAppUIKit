//
//  ListProductsViewController.swift
//  AppProdctsList
//
//  Created by Alfredo Salazar on 06/06/22.
//

import UIKit

class ListProductsViewController: UIViewController {
    
    @IBOutlet weak var tableListProducts: UITableView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var txtSinResultados: UILabel?

    var productos: Productos?
    var producto = Producto.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator?.startAnimating()
        txtSinResultados?.isHidden = true
        tableListProducts?.delegate = self
        loadListproduct()
    }
    
    @IBAction func cancelAction(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }

    private func loadListproduct(){
        guard let url = URL(string: "http://alb-dev-ekt-875108740.us-east-1.elb.amazonaws.com/sapp/productos/plp/1/ad2fdd4bbaec4d15aa610a884f02c91a") else{return}
        
        let session = URLSession.shared.dataTask(with: url){
            (data, response, error) in
            guard let data = data else {return}
            do{
                let respuesta = try JSONDecoder().decode(Productos.self, from: data)
                self.productos = respuesta
                DispatchQueue.main.async {
                    self.reloadTable()
                    print("success")
                }
            }catch{
                self.txtSinResultados?.isHidden = false
                self.activityIndicator?.stopAnimating()
                self.activityIndicator?.isHidden = true
                print("Ocurrio un error")
            }
        }
        session.resume()
    }
    private func reloadTable(){
        tableListProducts?.reloadData()
        activityIndicator?.stopAnimating()
        activityIndicator?.isHidden = true
    }
}

extension ListProductsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productos?.resultado?.productos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableListProducts?.dequeueReusableCell(withIdentifier: "cell") as! ListProductsTableViewCell
        let data = productos?.resultado?.productos?[indexPath.row]
        cell.nameProduct?.text = data?.nombre
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = productos?.resultado?.productos?[indexPath.row]
        
        producto.id = data?.id
        producto.nombre = data?.nombre
        producto.precioFinal = data?.precioFinal
        producto.urlImagenes = data?.urlImagenes
        producto.categoria = productos?.resultado?.categoria
        producto.codigoCategoria = data?.codigoCategoria
        dismiss(animated: true, completion: nil)
    }
    
}
