//
//  ViewController.swift
//  Bookstore2
//
//  Created by user190856 on 4/6/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!;
    var managedObjectContext: NSManagedObjectContext!;
    
    @IBAction func addNew(_ sender: UIBarButtonItem) {
        let book: Book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: managedObjectContext) as! Book;
        book.title = "My Book " + String(loadBooks().count);
        do {
            try managedObjectContext.save();
        } catch let error as NSError {
            NSLog("My Error: %@", error);
        }
        myTableView.reloadData();
    }
    @IBAction func removeItem(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate;
        managedObjectContext = appDelegate.persistentContainer.viewContext as NSManagedObjectContext;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadBooks().count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        else {
            return UITableViewCell();
        }
        
        let book: Book = loadBooks()[indexPath.row];
        cell.textLabel?.text = book.title;
        return cell;
    }
    

    func loadBooks() -> [Book] {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest();
        let titleSort: NSSortDescriptor = NSSortDescriptor(key:"title", ascending: true);
        fetchRequest.sortDescriptors = [titleSort];
        var result: [Book] = [];
        
        do {
            result = try managedObjectContext.fetch(fetchRequest);
        } catch {
            NSLog("My Error: %@", error as NSError);
        }
        return result;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let book: Book = loadBooks()[indexPath.row];
            managedObjectContext.delete(book);
            myTableView.reloadData();
        }
    }

}

