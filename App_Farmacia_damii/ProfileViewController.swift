//
//  ViewController.swift
//  App_Farmacia_damii
//
//  Created by RaulMacOS on 12/2/21.
//  Copyright © 2021 RaulMacOS. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
//import FacebookLogin
import FirebaseFirestore

enum ProviderType: String {
    case basic
    case google
    case facebook
    
}

class ProfileViewController: UIViewController {
    
     var email = ""
    
    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtDNI: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtDireccion: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    
    @IBOutlet weak var txtNacimiento: UITextField!
    
    
    @IBOutlet weak var btnGrabar: UIButton!
    @IBOutlet weak var btnEliminarCuenta: UIButton!
    
    private let base = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationItem.setHidesBackButton(true, animated: false)
        txtEmail.text = email
      getUser()
    }
    
    
    @IBAction func btnGrabarAction(_ sender: Any) {
        //,"nacimiento":self.txt.text ?? "
        let updateUser = self.base.collection("usuario").document(self.txtEmail.text ?? "")
        updateUser.setData(["email":self.txtEmail.text ?? "","clave":self.txtClave.text ?? "",
                         "nombre":self.txtNombres.text ?? "","apellido":self.txtApellidos.text ?? "",
                         "telefono":self.txtTelefono.text ?? "","direccion":self.txtDireccion.text ?? "",
                         "dni":self.txtDNI.text ?? "","nacimiento":self.txtNacimiento.text ?? ""]){error in
                            if error == nil {
                                let user = Auth.auth().currentUser
                               /* user?.updateEmail(to: self.txtEmail.text ?? "", completion: { (error) in
                                    if error != nil {
                                        print("error al cambiar email")
                                    }else{
                                        print("email cambiado")
                                    }
                                })*/
                                user?.updatePassword(to: self.txtClave.text ?? "", completion: { (error) in
                                    if error != nil {
                                        print("error al cambiar contraseñaaa")
                                    }else{
                                        print("contraseñaaa cambiado")
                                    }
                                })
                                self.mensaje(titulo: "Aviso", texto: "Actualizado")
                            } else {
                                print("no se registroooooo")
                            }
        }
    }
    
    @IBAction func btnEliminarAction(_ sender: Any) {
        base.collection("usuario").document(self.txtEmail.text ?? "").delete(){error in
            if error == nil {
                  let user = Auth.auth().currentUser
                user?.delete(completion: { (error) in
                    if error != nil {
                        print("error al eliminar auth")
                    }else{
                        print("eliminado auth")
                       // self.mensaje(titulo: "Aviso", texto: "se elimino")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewc = storyboard.instantiateViewController(withIdentifier: "login")
                        self.navigationController?.pushViewController(viewc, animated: true)
                    }
                })
                
            }else {
                 self.mensaje(titulo: "Aviso", texto: "No se elimino")
            }
        }
       
    }
    private func getUser(){
        base.collection("usuario").document(email).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot, error == nil {
                if let nombre = document.get("nombre") as? String{
                    self.txtNombres.text = nombre
                }
                if let app = document.get("apellido") as? String{
                   self.txtApellidos.text = app
                }
                if let tel = document.get("telefono") as? String{
                   self.txtTelefono.text = tel
                }
                if let dni = document.get("dni") as? String{
                    self.txtDNI.text = dni
                }
                if let dir = document.get("direccion") as? String{
                    self.txtDireccion.text = dir
                }
                if let nac = document.get("nacimiento") as? String{
                   self.txtNacimiento.text = nac
                }
                if let pass = document.get("clave") as? String{
                    self.txtClave.text = pass
                }
            }else{
                 print("este es errrorrrrr")
            }
            
        }

    }
    
    func mensaje( titulo:String ,texto:String ){
        let alertaController = UIAlertController(title: titulo, message: texto, preferredStyle: .alert)
        alertaController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present(alertaController, animated: true, completion: nil)
    }
    /* base.collection("usuario").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
     
     if let err = error {
     print(err)
     }else{
     for document in querySnapshot!.documents{
     let dc =  document.data()
     self.txtNombres.text = dc["nombre"] as? String
     self.txtApellidos.text = dc["apellido"] as? String
     self.txtTelefono.text = dc["telefono"] as? String
     self.txtClave.text = dc["clave"] as? String
     print("este es : \(dc)")
     
     }
     }
     }*/
    
  /*  private let email: String
    private let provider: ProviderType
    
    @IBOutlet weak var txtProducto: UITextField!
    
    private let db = Firestore.firestore()
    
    init(email: String , provider: ProviderType){
        
        self.email = email
        self.provider = provider
        
        super.init(nibName: nil , bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        //emailLabel.text = email
        //providerlabel.text = provider.rawValue
        title = "Inicio"
        print(email)
        print(provider.rawValue)
        //Guardamos los datos del usuartio con userdefaults
        
        let defaults = UserDefaults.standard
        defaults.set(email , forKey:"email" )
        defaults.set(provider.rawValue , forKey: "provider")
        defaults.synchronize()
    }
    
    
    @IBAction func agregarAction(_ sender: Any) {
        view.endEditing(true)
        
        db.collection("userdata").document(email).setData( [
            "producto" : txtProducto.text ?? ""
            ])
        
        self.txtProducto.text = ""
        
    }
    
    @IBAction func eliminarAction(_ sender: Any) {
        view.endEditing(true)
        db.collection("userdata").document(email).delete()
        self.txtProducto.text = ""
    }
    @IBAction func buscarAction(_ sender: Any) {
        view.endEditing(true)
        
        db.collection("userdata").document(email).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot, error == nil {
                if let producto = document.get("producto") as? String{
                    self.txtProducto.text = producto
                }
                
            }
            
        }
        
    }
    @IBAction func cerrarSesionAction(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
        
        
        switch provider {
            
        case .basic :
            firebaseLogOut()
            
        case .google:
            firebaseLogOut()
            GIDSignIn.sharedInstance()?.signOut()
            
        case .facebook:
            firebaseLogOut()
            //let loginManager = LoginManager()
            //loginManager.logOut()
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    
    private func firebaseLogOut(){
        do{
            try Auth.auth().signOut()
        }catch{
            //se ha producido un error
            
        }
    }*/

}

