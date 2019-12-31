import UIKit
import os.log //imports unified logging system --messages to console
//plus more control
//defines a custom subclass of UIViewController
//inherits everything ViewController
//that's why you use override, to override the viewcontroller class


class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Mark: Properties
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var photoImageView: UIImageView!
    
    @IBOutlet var ratingControl: RatingControl!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    
    //this is how it calls the code in the rating control file
    /*This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
    or constructed as part of adding a new meal.
    */
    var meal: Meal? //declares property on MVC that is an optional meal (that at any point it may be nil0
    //you only care about configring and passing the Meal if the Save button was tapped. 
    
    //goal: pass new Meal object to MealTableVIewController when user taps save button/discard when user taps cancel button. and in both, return to display the meal list -> use an unwind segue
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // handle text field's user input through delegate callback
        nameTextField.delegate  = self
        
        if let meal = meal{
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        updateSaveButtonState() //enables save button only if there's valid text
        
    }
    
//Mark: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { //may be [String : Any
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //disable save button while editing
        saveButton.isEnabled = false
    } //gets  alled when editing section begins
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         updateSaveButtonState()
         navigationItem.title = textField.text
     }
    
    
//Mark: Navigation -- related to navigation flow of the app
    @IBAction func cancel(_ sender: UIBarButtonItem) {
     //depends on style of presentation, modal or push, is how this VC is dismissed
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
       
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The mealviewcontroller is not inside a navigation controller")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: segue) //good habit
        guard let button = sender as? UIBarButtonItem, button == saveButton else {
            os_log("the save button was not pressed, cancelling", log: OSLog.default,  type: .debug)
            return
        }
        let name = nameTextField.text ?? "" //nil coalescing operator ??
        let photo = photoImageView.image
        let rating = ratingControl.rating
    
   /* Notice the nil coalescing operator (??) in the name line. The nil coalescing operator is used to return the value of an optional if the optional has a value, or return a default value otherwise. Here, the operator unwraps the optional String returned by nameTextField.text (which is optional because there may or may not be text in the text field), and returns that value if it’s a valid string. But if it’s nil, the operator the returns the empty string ("") instead.
 */
        //SET MEAL TO BE BE PASSED AFTER THE UNWIND SEGUE
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    

    
    
//Mark: Actions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
 

    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated:true, completion: nil)
    }
    
//MARK: Private Methods
    private func updateSaveButtonState() {
        //disable save button if the text field is empty;
        //helper method, enable save button if text field is not empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}

//you only need an outlet if you plan to access a value of modify the interface. ie, button won't by modified, so you don't need an outlet. It responds when tapped, so you need an outlet.
//ios apps: event-driven programming.


