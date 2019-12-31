import UIKit
import os.log

class Meal: NSObject, NSCoding { //add subclass NSObject, a base class, defines interface to runtime system
    
  
    //MARK: properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Archiving Paths
    //extra note so I can commit and push
    //create a file path to the data
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first! //should end up with one match
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        //constants correspond to one of Meal's properties
        //static keyword = constants belpng to the structure itself, not to instances of it
        //access these with structures's nmame: PropertyKey.name, etc
        
    }
    
    //MARK: Initialization
    //method that prepares an instance of a class for use
    init?(name: String, photo: UIImage?, rating: Int) {
        //init fails if no name or  if rating is negative
        if name.isEmpty || rating < 0 {
            return nil
        }
        //initialize the stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
    
    }

    //add comment
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {//prepares data to be archived
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    required convenience init?(coder aDecoder: NSCoder) {//unarchives data when the class is created. convenience means: secondary initializer, must call a designated initializer from the same calss
        // the question mark means it's a failable initizlizer that might return nil
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object", log: OSLog.default, type: .debug)
            return nil
        }
        //photo is optional, just use conditional cast
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        //? downcasts it-- if downcast fails, nil is assigned. no need for guard beacue photo is opional
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        //return value is Int, no need to downcast the decoded value and no optional to unrwrap.
        self.init(name: name, photo: photo, rating: rating)
        //has to call the init/ pass in the values of the constants you created to archive the saved data

    }
}

