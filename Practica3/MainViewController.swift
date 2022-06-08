//
//  MainViewController.swift
//  Practica3
//
//  Created by Salvador Gómez Moya on 05/04/22.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var ingredientsField: UITextField!
    
    @IBOutlet weak var directionsField: UITextField!
    
    @IBOutlet weak var agregarFoto: UIButton!
    
    @IBOutlet weak var usuario: UILabel!
    

    
    @IBOutlet weak var imagenBebida: UIImageView!
    
    var ruta = ""
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var drink_list = [Drink]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: true)
        
        
        
        usuario.text = Auth.auth().currentUser?.email
        
        
     
       
        
      

       
    }
    
    
   
    
    
    
    @IBAction func addDrink(_ sender: Any) {
        
       
          let name_drink = nameField!.text ?? ""
          let ingredients_drink = ingredientsField.text ?? ""
          let directions_drink = directionsField.text ?? ""
          
        //  self.createDrink(name: name_drink, directions: directions_drink, ingredients: ingredients_drink,"imagenBebida.image" )
          self.createDrink(name: name_drink, directions: directions_drink, ingredients: ingredients_drink, image: ruta)
          
          print("Ruta guardada: \(ruta)")
          
        
    }
    
    
    @IBAction func verTabla(_ sender:UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Tabla")
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
    //Coredata
    
    func getAllDrinks(){
        
        do{
            drink_list = try context.fetch(Drink.fetchRequest())
        }catch{
            
        }
        
        
    }
    
    func createDrink(name: String, directions: String, ingredients: String,image:String){
        let newDrink = Drink(context: context)
        newDrink.name = name
        newDrink.directions = directions
        newDrink.ingredients = ingredients
        newDrink.image = image
        
        do {
            try context.save()
            getAllDrinks()
        }catch{
            
        }
    }
    
    func deleteDrink(item: Drink){
        context.delete(item)
        
        do{
            try context.save()
        }catch{
            
        }
    }
    
    func upDateItem(item: Drink, newName: String){
        item.name = newName
        do{
            try context.save()
        }catch{
            
        }
    }
    
    
    @IBAction func elegirBebida(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
   
    
    
    
    @IBAction func cerrarSesion(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
           
        }catch{
            print("Se ha producido un error")
        }
        
    }
    
    
    
    
   
    
  
    
    
    
    
  
    

}

extension MainViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            imagenBebida.image = image
            
            let manager = FileManager()
            let nombre_imagen = nameField!.text
            let urlCarpeta = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
            let urlImage = urlCarpeta?.appendingPathComponent("\(nombre_imagen ?? "drink").jpg")
            ruta = urlImage!.path
            print("url de la imagen: \(urlImage!.path)")
            
            manager.createFile(atPath: urlImage!.path ,contents: imagenBebida.image?.pngData(), attributes: [FileAttributeKey.creationDate: Date()])
            
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
     
}
