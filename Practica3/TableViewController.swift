//
//  TableViewController.swift
//  Practica3
//
//  Created by Salvador Gómez Moya on 28/03/22.
//

import UIKit

class TableViewController: UITableViewController {
    var datos = [[String:Any]]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var tableViewDrinks: UITableView!
    
    private var drink_list = [Drink]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewDrinks.reloadData()
        
        getAllDrinks()
       
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    //Coredata
    
    func getAllDrinks(){
        
        do{
            drink_list = try context.fetch(Drink.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableViewDrinks.reloadData()
            }
        }catch{
            
        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drink_list.count
    }
    
  

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        
        let drinks = drink_list[indexPath.row]
        

        cell.textLabel?.text = (drinks.name) ?? "\(indexPath.row)"
        
        
        let urlCarpeta = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
        let nombreImagen = drink_list[indexPath.row].name
        let ruta = urlCarpeta?.appendingPathComponent("\(nombreImagen!).jpg")
                
        if FileManager.default.fileExists(atPath: ruta!.path){
            do{
               let bytes = try Data(contentsOf: ruta!)
                cell.imageView?.image =   UIImage(data: bytes)
                            
            }catch{
                print("No funcionó la carga de la imagen local")
                print(error.localizedDescription)
            }
        }else{
          //  print("No se encontró la imagen")
            let nameImage = drink_list[indexPath.row].image
            cell.imageView?.image = UIImage(named: nameImage ?? "drink")
        }
       
        
        
       // cell.imageView?.image = UIImage(named: drinks.image ?? "\(indexPath.row)")
        
       

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
       "Bebidas"
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
   
   
    
  
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let detalleVC = segue.destination as! ViewController
        // Pass the selected object to the new view controller.
        if let indexPath = tableView.indexPathForSelectedRow {
            let drink = indexPath.row
            detalleVC.index = drink
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    

}
