//
//  AppDelegate.swift
//  Practica3
//
//  Created by Salvador Gómez Moya on 28/03/22.
//

import UIKit
import CoreData
import FirebaseCore
import EncryptedCoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var ruta = URL(string: "")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if UserDefaults.standard.bool(forKey: "DBready"){
          
        } else {
          getDrinks()
        }
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func getDrinks() {
        var datos = [[String:Any]]()

        if let rutaAlArchivo = Bundle.main.url(forResource: "Drinks", withExtension: "plist"){
            ruta = rutaAlArchivo
            do{
                
                
              let bytes = try Data(contentsOf: rutaAlArchivo)
                let tmp = try PropertyListSerialization.propertyList(from: bytes, options: .mutableContainers, format: nil)
               datos = tmp as! [[String:Any]]
                
              //  print(datos)
                
                fillCoreData(datos)
                   
      }
      catch {
        print(error.localizedDescription)
      }
      let defaults = UserDefaults.standard
      defaults.set(true, forKey: "DBready")
    }
    }
    
    func fillCoreData(_ drinks: [[String:Any]]) {
      guard let entity = NSEntityDescription.entity(forEntityName: "Drink", in: persistentContainer.viewContext) else { return }
      for drink in drinks {
        let coreDataDrink = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext) as! Drink
        coreDataDrink.initializeWith(drink)
        saveContext()
      }
        
    }
    
    //MARK: - Core Data
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Drinks")
        let storeDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
        let ruta = storeDirectory.appendingPathComponent("Drinks.sqlite")
        
        print("la ruta de la bd es:::\(ruta)")
        
        let options = [EncryptedStorePassphraseKey: "123",/**/
                    EncryptedStoreDatabaseLocation:ruta,
                   EncryptedStoreFileManagerOption: EncryptedStoreFileManager.default()!
        ] as [String: Any]
        
        
        do{
            let description = try EncryptedStore.makeDescription(options: options, configuration: nil)
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores(completionHandler: {
                (storeDescription,error) in
                if let error = error as NSError?{
                  fatalError("Error sin resolver \(error), \(error.userInfo)")
                }
            })
        }catch{
            print("Error:"+error.localizedDescription)
        }
        
        return container
    }()
    
    func saveContext (){
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do{
                try context.save()
            }catch{
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
   /* func obtenInfo(){
        var datos = [[String:Any]]()
        if let rutaAlArchivo = Bundle.main.url(forResource: "Drinks", withExtension: "plist"){
            do{
              let bytes = try Data(contentsOf: rutaAlArchivo)
                let tmp = try PropertyListSerialization.propertyList(from: bytes, options: .mutableContainers, format: nil)
                datos = tmp as! [[String:Any]]
            //    let newDrink = Drink(context: context)
                         
        
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }*/

        
    


}

