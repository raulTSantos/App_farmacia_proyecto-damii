//
//  ProductoTableViewCell.swift
//  App_Farmacia_damii
//
//  Created by RaulMacOS on 12/3/21.
//  Copyright © 2021 RaulMacOS. All rights reserved.
//

import UIKit

class ProductoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imagenProducto: UIImageView!
    @IBOutlet weak var txtCategoria: UILabel!
    @IBOutlet weak var txtNombreProd: UILabel!
    @IBOutlet weak var txtToma: UILabel!
    @IBOutlet weak var txtPrecio: UILabel!
    @IBOutlet weak var btnAdquirir: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let alert = UIAlertController ( title: "Error", message: "Se ha producido un Error", preferredStyle: .alert)
        alert.addAction(UIAlertAction (title: "Aceptar", style: .default))

    }
    
    
}
