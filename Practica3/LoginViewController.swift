//
//  LoginViewController.swift
//  Practica3
//
//  Created by Salvador Gómez Moya on 05/06/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var correo: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Regístrate o inicia sesión"
        

        
      
           
            
      
        
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func registrar(_ sender: UIButton) {
        
        if let email = correo.text, let pass = password.text{
            
            Auth.auth().createUser(withEmail: email, password: pass){(result,error) in
            
                    if let result = result, error == nil{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "Lista")
                                        
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                 
                 
                }else{
                    let alert = UIAlertController(title: "Error", message: "Se ha producido un problema para registrar al usuario. \(error?.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
    
 
 
    
    @IBAction func iniciar(_ sender: UIButton) {
        if let email = correo.text, let pass = password.text{
            
            Auth.auth().signIn(withEmail: email, password: pass){(result,error) in
                
              
                    if let result = result, error == nil{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "Lista")
                      //  self.present(vc, animated: true)
                        
                      /*  let defaults = UserDefaults.standard
                        
                        defaults.set(email, forKey: "email")
                        defaults.synchronize()*/
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                  
                   
                }else{
                    let alert = UIAlertController(title: "Error", message: "Se ha producido un problema para registrar al usuario. \(error?.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
    
}
