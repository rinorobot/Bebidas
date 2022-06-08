//
//  ViewController.swift
//  Practica3
//
//  Created by Salvador Gómez Moya on 28/03/22.
// Actualización: 5 de junio de 2022

import UIKit
import MessageUI
import FirebaseAuth

class ViewController: UIViewController,UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var compartir: UIButton!
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    
    @IBOutlet weak var ingredientes: UITextView!
    
    @IBOutlet weak var instrucciones: UITextView!
    
    var datos = [[String:Any]]()
    
    var index = 0
    
    var titulo = ""
    
    var usuario = ""
    
    var imagen_detalle = UIImage()
    
    var ingredientes_detalle = ""
    
    var datos_detalle = Data()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var drink_list = [Drink]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllDrinks()
        
        usuario = (Auth.auth().currentUser?.email)!
        
        
       
      
              
        
        nombre.text = drink_list[index].name
        
        titulo = nombre.text!
        ingredientes.text = drink_list[index].ingredients
        
        ingredientes_detalle = ingredientes.text!
        
        instrucciones.text = drink_list[index].directions
        
        
        let urlCarpeta = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
        let nombreImagen = drink_list[index].name
        let ruta = urlCarpeta?.appendingPathComponent("\(nombreImagen!).jpg")
                
        if FileManager.default.fileExists(atPath: ruta!.path){
            do{
               let bytes = try Data(contentsOf: ruta!)
                
                datos_detalle = bytes
                
                imagen.image =   UIImage(data: bytes)
                
                imagen_detalle = imagen.image!
                            
            }catch{
                print("No funcionó la carga de la imagen local")
                print(error.localizedDescription)
            }
        }else{
            print("No se encontró la imagen")
             let nameImage = drink_list[index].image
           imagen.image = UIImage(named: nameImage ?? "drink")
            imagen_detalle = imagen.image!
        }
       
     
        
        
        
          print("url de la carpeta: \(urlCarpeta)")
          print("Ruta de la imagen detalle: \(drink_list[index].image!)")
        print(drink_list.count)
        
        
    }
    
    func getAllDrinks(){
        
        do{
            drink_list = try context.fetch(Drink.fetchRequest())
        }catch{
            
        }
        
        
    }
    
    
    

    @IBAction func compartir(_ sender: Any) {
        
       
        
        let alert = UIAlertController(title: "Compartir", message: "¿Cómo prefieres compartir?", preferredStyle: .alert)
        let ac1 = UIAlertAction(title: "Redes sociales", style: .default,handler: {action in
            
            let compartir_elementos = UIActivityViewController(activityItems: [self.imagen_detalle,self.titulo,self.ingredientes_detalle], applicationActivities: nil)
            
            self.present(compartir_elementos, animated: true)
            
        })
            
                let ac2 = UIAlertAction(title: "Correo", style: .default, handler: { action in
                    
                    if MFMailComposeViewController.canSendMail(){
                        
                      let vc = MFMailComposeViewController()
                        vc.delegate = self
                        vc.setSubject(self.titulo)
                        vc.setToRecipients([self.usuario])
                        vc.setMessageBody(self.ingredientes_detalle, isHTML: false)
                        self.present(UINavigationController(rootViewController: vc), animated: true)
                    }else{
                        print("No se puede enviar correo")
                    }
                
                    
              
                    
                })
                alert.addAction(ac1)
                alert.addAction(ac2)
                self.present(alert, animated: true)
        
        
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

