import UIKit

class HabitsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var habitsCollectionView: UICollectionView!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //habitsCollectionView.delegate = self
        habitsCollectionView.dataSource = self
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        habitsCollectionView.reloadData()
    }
    
    //MARK: - collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return HabitsStore.shared.habits.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitCell", for: indexPath) as! HabitCollectionViewCell
            let habits = HabitsStore.shared.habits
            cell.habit = habits[indexPath.row]
            
            switch cell.habit?.isAlreadyTakenToday {
            case true:
                cell.doneButton.layer.borderWidth = 0
                cell.doneButton.backgroundColor = cell.habit?.color
            case false:
                cell.doneButton.layer.borderWidth = 2
                cell.doneButton.layer.borderColor = cell.habit?.color.cgColor
                cell.doneButton.backgroundColor = .white
            case .none:
                break
            case .some(_):
                break
            }

            cell.onChecked = {
                self.habitsCollectionView.reloadData()
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "progressCell", for: indexPath) as! ProgressCollectionViewCell
            cell.updateProgress()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section{
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let habitDetailsVC = storyboard.instantiateViewController(identifier: "HabitDetailsViewController") as? HabitDetailsViewController else { return }
            habitDetailsVC.habitIndex = indexPath.item
            self.navigationController?.pushViewController(habitDetailsVC, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        width = collectionView.frame.width - 16 * 2
        switch indexPath.section {
        case 0:
            return CGSize(width: width, height: 60)
        case 1:
            return CGSize(width: width, height: 130)
        default:
            return CGSize(width: width, height: 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionProgressInsert = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        let sectionHabitInsert = UIEdgeInsets(top: 22, left: 16, bottom: 12, right: 16)
        if section == 1 {
            return sectionProgressInsert
        } else {
            return sectionHabitInsert
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
