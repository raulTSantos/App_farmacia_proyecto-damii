//
//  AuthViewController.swift
//  App_Farmacia_damii
//
//  Created by RaulMacOS on 12/3/21.
//  Copyright © 2021 RaulMacOS. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class AuthViewController: UIViewController {
    
    @IBOutlet weak var txtClave: UITextField!
    
    @IBOutlet weak var txtNombre: UITextField!
    
    @IBOutlet weak var txtApellido: UITextField!
    
    @IBOutlet weak var txtTelefono: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtComfirmaClave: UITextField!

  //  private let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnRegistrarAction(_ sender: Any) {
        if txtNombre.text?.isEmpty == true {
            mensaje(titulo: "Campo Vacio", texto: "Ingrese un nombre")
            return
        }
        if txtApellido.text?.isEmpty == true {
            mensaje(titulo: "Campo Vacio", texto: "Ingrese su apellido")
            return
        }
        if txtTelefono.text?.isEmpty == true || (txtTelefono.text?.characters.count)! < 9{
            mensaje(titulo: "Campo Vacio", texto: "Ingrese un numero telefonico de 8 o mas digitos")
            return
        }
        if txtEmail.text?.isEmpty == true {
            mensaje(titulo: "Error", texto: "Ingrese un correo valido")
            return
        }
        if txtClave.text?.isEmpty == true || (txtClave.text?.characters.count)! <= 8{
            mensaje(titulo: "Error", texto: "Ingrese un password de minimo 8 caracteres")
            return
        }
        if (txtComfirmaClave.text != txtClave.text ) {
            mensaje(titulo: "Error", texto: "Contraseña no coincide")
            return
        }
        singUp()

    }
    
    @IBAction func ingresarAction(_ sender: Any) {
        if txtEmail.text?.isEmpty == true {
            mensaje(titulo: "Error", texto: "Ingrese un correo valido")
            return
        }
        if txtClave.text?.isEmpty == true {
            mensaje(titulo: "Error", texto: "Ingrese un password")
            return
        }
        login()
    }
    
    @IBAction func googleAuthAction(_ sender: Any) {
    }
    
    
    @IBAction func facebookAuthAction(_ sender: Any) {
    }
    
    func singUp(){
        
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtClave.text!) {(authResult ,error) in
            if let result = authResult  , error == nil {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                 let viewc = storyboard.instantiateViewController(withIdentifier: "busquedaProducto") as! ProductoViewController
                 viewc.userPerfil = self.txtEmail.text!
                 self.navigationController?.pushViewController(viewc, animated: true)
                
               /* let newUser = self.db.collection("usuario").document()
                newUser.setData(["email":self.txtEmail.text ?? "","clave":self.txtClave.text ?? "",
                                 "nombre":self.txtNombre.text ?? "","apellido":self.txtApellido.text ?? "",
                                 "telefono":self.txtTelefono.text ?? ""]){error in
                                    if error == nil {
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let viewc = storyboard.instantiateViewController(withIdentifier: "busquedaProducto") as! ProductoViewController
                                        viewc.userPerfil = self.txtEmail.text!
                                        self.navigationController?.pushViewController(viewc, animated: true)
                                    } else {
                                        print("no se registroooooo")
                                    }
                                    
                }*/
                print(result)
                
            }else{
                let alert = UIAlertController ( title: "Error", message: "Se ha producido un Error", preferredStyle: .alert)
                alert.addAction(UIAlertAction (title: "Aceptar", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func login(){
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtClave.text!){
            (result ,error) in
            if let result = result , error == nil {
                print(result)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewc = storyboard.instantiateViewController(withIdentifier: "busquedaProducto") as! ProductoViewController
                viewc.userPerfil = self.txtEmail.text!
                self.navigationController?.pushViewController(viewc, animated: true)
                
            }else{
                let alert = UIAlertController ( title: "Error", message: "Se ha producido un Error", preferredStyle: .alert)
                alert.addAction(UIAlertAction (title: "Aceptar", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    
    func mensaje( titulo:String ,texto:String ){
        let alertaController = UIAlertController(title: titulo, message: texto, preferredStyle: .alert)
        alertaController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present(alertaController, animated: true, completion: nil)
     }
}
