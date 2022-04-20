import UIKit

class HabitDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var detailTableView: UITableView!
    
    var habitIndex: Int = 0
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.delegate = self
        detailTableView.delegate = self
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = HabitsStore.shared.habits[habitIndex].name
        self.detailTableView.reloadData()
        
    }
    
    //MARK: - editButtonPressed
    @IBAction func editButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let habitVC = storyboard.instantiateViewController(withIdentifier: "HabitViewController") as! HabitViewController
        habitVC.habitIndex = self.habitIndex
        navigationController?.pushViewController(habitVC, animated: false)
    }
    
    //MARK: - table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! HabitDetailsTableViewCell
        
        let trackDate = HabitsStore.shared.trackDateString(forIndex: indexPath.row)
        cell.dateLabel.text = trackDate
        
        let indexHabits = HabitsStore.shared.habits[habitIndex]
        let date = HabitsStore.shared.dates[indexPath.row]
        let habit = HabitsStore.shared.habit(indexHabits, isTrackedIn: date)
        if habit {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}
