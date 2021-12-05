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
    
    private let email: String
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
    }

}

