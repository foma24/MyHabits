import UIKit

class HabitViewController: UIViewController, UIColorPickerViewControllerDelegate {
    @IBOutlet weak var colorPickerButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var deleteButton: UIButton!
    
    let colorPicker = UIColorPickerViewController()
    let currentDate = Date()
    
    var habitIndex: Int? = nil
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Save or Edit
        let habitArray = HabitsStore.shared.habits
        if habitIndex == nil {
            title = "Save"
            deleteButton.isHidden = true
        } else {
            title = "Edit"
            deleteButton.isHidden = false
            titleTextField.text = habitArray[habitIndex!].name
            colorPickerButton.backgroundColor = habitArray[habitIndex!].color
            datePicker.date = habitArray[habitIndex!].date
        }
        
        //color button as circle
        colorPickerButton.layer.cornerRadius = 0.5*colorPickerButton.bounds.size.width
        
        //Current time in label
        timeLabel.text = "Every day at \(dateFormatterFunc())"
    }
    
    //MARK: - colorPickerButtonPressed
    @IBAction func colorPickerButtonPressed(_ sender: Any) {
        colorPicker.delegate = self
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    //MARK: - date picker choosed
    @IBAction func datePickerChoosed(_ sender: Any) {
        timeLabel.text = "Every day at \(dateFormatterFunc())"
    }
    
    //MARK: - delete button pressed
    @IBAction func deleteHabitPressed(_ sender: Any) {
        showAlertDelete()
    }
    
    //MARK: - save button pressed
    @IBAction func saveHabitPressed(_ sender: Any) {
        if titleTextField.text == "" {
            showAlertMissedTitle()
        } else {
            if habitIndex == nil {
                let newHabit = Habit(name: "\(titleTextField.text ?? "No title")",
                                     date: datePicker.date,
                                     color: colorPickerButton.backgroundColor!)
                let store = HabitsStore.shared
                store.habits.append(newHabit)
                
                print("New habit name", newHabit.name)
                print("New habit time", newHabit.date)
                print("New habit color", newHabit.color)
                
                _ = navigationController?.popViewController(animated: true)
            } else {
                let habitArray = HabitsStore.shared.habits
                habitArray[habitIndex!].name = titleTextField.text ?? ""
                habitArray[habitIndex!].color = colorPickerButton.backgroundColor!
                habitArray[habitIndex!].date = datePicker.date
                _ = navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK: - color Picker
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        colorPickerButton.backgroundColor = color
    }
    
    //MARK: - date formatter
    func dateFormatterFunc()->String {
        datePicker.datePickerMode = .time
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        let choosedTime = dateFormatter.string(from: datePicker.date)
        
        return choosedTime
    }
    
    //MARK: - Alerts
    func showAlertMissedTitle() {
        let alertController = UIAlertController(title: nil, message: "Habit title is missed", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertDelete() {
        var habitArray = HabitsStore.shared.habits
        let alertController = UIAlertController(title: nil, message: "Delete habit ?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Delete", style: .default) { (action) in
            let deleteIndex = HabitsStore.shared.habits.firstIndex(of: habitArray[self.habitIndex!])
            if let index = deleteIndex{
                HabitsStore.shared.habits.remove(at: index)
                habitArray.remove(at: self.habitIndex!)
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ok.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
}
