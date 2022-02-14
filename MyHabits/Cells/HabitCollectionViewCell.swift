import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    var habitInCollection = {}
    
    var habit: Habit? {
        didSet {
            titleLabel.text = habit?.name
            titleLabel.textColor = habit?.color
            timeLabel.text = habit?.dateString
            countLabel.text = "Count: \(String(describing: habit!.trackDates.count))"
            doneButton.layer.cornerRadius = 0.5*doneButton.bounds.size.width
            
            switch habit?.isAlreadyTakenToday {
            case true:
                doneButton.layer.borderWidth = 0
                doneButton.backgroundColor = habit?.color
            default:
                doneButton.layer.borderWidth = 2
                doneButton.layer.borderColor = habit?.color.cgColor
            }
        }
    }
    
    //MARK: - doneButtonPressed
    @IBAction func doneButtonPressed(_ sender: Any) {
        switch habit!.isAlreadyTakenToday {
        case true:
            print("Already taken")
        case false:
            HabitsStore.shared.track(habit!)
            habitInCollection()
            doneButton.layer.borderWidth = 0
            doneButton.backgroundColor = habit?.color
        }
    }
}
