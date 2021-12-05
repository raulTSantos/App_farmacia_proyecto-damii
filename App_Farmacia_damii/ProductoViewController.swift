//
//  ProductoViewController.swift
//  App_Farmacia_damii
//
//  Created by RaulMacOS on 12/2/21.
//  Copyright © 2021 RaulMacOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
/*enum ProviderType: String {
    case basic
    case google
    case facebook
    
}*/
class ProductoViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , UISearchBarDelegate {
    
    @IBOutlet weak var tablaProducto: UITableView!
    @IBOutlet weak var buscadorProducto: UISearchBar!
    
    @IBOutlet weak var btnPerfil: UIButton!
    
    var userPerfil = ""
    // base de datos de producto
   // let dataProductos = Firestore.firestore()
    var productoObj = [Producto]()
    var currentProductoArray = [Producto]()
    
   // private let email: String
   // private let provider: ProviderType
    
    
   /* init(email: String , provider: ProviderType){
        
        self.email = email
        self.provider = provider
        
        super.init(nibName: nil , bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        setUpProductos()
        setUpSearchBar()
        btnPerfil.setTitle(userPerfil, for: .normal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentProductoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tablaProducto.dequeueReusableCell(withIdentifier: "cell") as? ProductoTableViewCell else{
            return UITableViewCell()
        }
        cell.txtNombreProd.text = currentProductoArray[indexPath.row].nombre
        cell.txtToma.text = currentProductoArray[indexPath.row].toma
        cell.txtPrecio.text = "$/ "+String(currentProductoArray[indexPath.row].precio)
        cell.txtCategoria.text = currentProductoArray[indexPath.row].categoria.rawValue
        cell.imagenProducto.image = UIImage(named: currentProductoArray[indexPath.row].image)
        cell.btnAdquirir.tag = indexPath.row
        cell.btnAdquirir.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    @objc func clickBtn(sender :UIButton){
        print("pulsado \(sender.tag)")
        let alert = UIAlertController ( title: "Inf", message: "Agregado a la compra", preferredStyle: .alert)
        alert.addAction(UIAlertAction (title: "Aceptar", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    private func setUpProductos(){
        productoObj.append(Producto(nombre: "Paracetamol", toma: "pastillas", precio: Double(1.20), categoria: .analgesico,image : "image01"))
        productoObj.append(Producto(nombre: "Paracetamol", toma: "pastillas", precio: Double(1.00), categoria: .analgesico,image : "image01"))
        productoObj.append(Producto(nombre: "Locepal", toma: "pastillas", precio: Double(1.80), categoria: .analgesico,image : "image01"))
        productoObj.append(Producto(nombre: "MigrañaDol", toma: "pastillas", precio: Double(1.20), categoria: .antidepresivo,image : "image01"))
        productoObj.append(Producto(nombre: "Pareacetamol", toma: "jarabe", precio: Double(1.50), categoria: .antidepresivo,image : "image01"))
        productoObj.append(Producto(nombre: "Antigripal", toma: "pastillas", precio: Double(1.50), categoria: .analgesico,image : "image01"))
        productoObj.append(Producto(nombre: "Loperamida", toma: "pastillas", precio: Double(3.20), categoria: .analgesico,image : "image01"))
        productoObj.append(Producto(nombre: "Ibuprofeno", toma: "jarabe", precio: Double(3.50), categoria: .analgesico,image : "image01"))
        productoObj.append(Producto(nombre: "Aciclovir", toma: "pastillas", precio: Double(3.20), categoria: .antimicotico,image : "image01"))
        productoObj.append(Producto(nombre: "Clotrimazol", toma: "pastillas", precio: Double(5.50), categoria: .antimicotico,image : "image01"))
         currentProductoArray = productoObj

    }

    private func setUpSearchBar(){
         buscadorProducto.delegate = self
    }
    /* search bar */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { // usamos variable searchText  en guard
        currentProductoArray = productoObj.filter({ dbProd -> Bool in
            switch buscadorProducto.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { return true}
                return  dbProd.nombre.lowercased().contains(searchText.lowercased())
            case 1:
                if searchText.isEmpty { return dbProd.categoria == .analgesico}
                return  dbProd.nombre.lowercased().contains(searchText.lowercased())
            case 2:
                if searchText.isEmpty { return dbProd.categoria == .antidepresivo}
                return  dbProd.nombre.lowercased().contains(searchText.lowercased())
            case 3:
                if searchText.isEmpty { return dbProd.categoria  == .antimicotico}
                return  dbProd.nombre.lowercased().contains(searchText.lowercased())

            default:
                return false
            }
            })
        
    
        tablaProducto.reloadData()
        }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            currentProductoArray = productoObj
        case 1:
            currentProductoArray = productoObj.filter({ dbProd -> Bool in
                dbProd.categoria == Categoria.analgesico
            })
        case 2:
            currentProductoArray = productoObj.filter({ dbProd -> Bool in
                dbProd.categoria == Categoria.antidepresivo
            })
        case 3:
            currentProductoArray = productoObj.filter({ dbProd -> Bool in
                dbProd.categoria == Categoria.antimicotico
            })
        default:
            break
        }
        tablaProducto.reloadData()
    }
    
    
    @IBAction func btnCerrarSesionAction(_ sender: Any) {
        firebaseLogOut()
    }
    
    @IBAction func btnProfileAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewc = storyboard.instantiateViewController(withIdentifier: "perfil") as! ProfileViewController
        viewc.email = userPerfil
        self.navigationController?.pushViewController(viewc, animated: true)
    }
    
    
   /* private func getData(){
        dataProductos.collection("producto").getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err)
            }else{
                for docProduct in querySnapshot!.documents{
                    self.productoObj.append(Producto(nombre: docProduct["nombre"] as? String ?? "", toma: docProduct["toma"] as? String ?? "", precio: docProduct["precio"] as? Double ?? 0 , categoria: ., image: <#T##String#>))
                }
            }
        }
    }*/

    private func firebaseLogOut(){
        do{
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
            /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewc = storyboard.instantiateViewController(withIdentifier: "login")
            viewc.modalPresentationStyle = .overFullScreen
            self.present(viewc, animated: true)*/
        }catch{
        }
    }
}
class Producto{
    let nombre:String
    let toma:String
    let precio : Double
    let categoria: Categoria
    let image: String
    init(nombre:String,toma:String,precio : Double,categoria: Categoria,image: String) {
        self.nombre = nombre
        self.toma = toma
        self.precio = precio
        self.categoria = categoria
        self.image = image
    }
}
enum Categoria : String{
    case analgesico = "analgesico"
    case antidepresivo = "antidepresivo"
    case antimicotico = "antimicotico"
}
