import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var percentsLabel: UILabel!
    @IBOutlet weak var progressViewOutlet: UIProgressView!
    
    //MARK: - Update progress bar in CV
    public func updateProgress() {
        progressViewOutlet.setProgress(HabitsStore.shared.todayProgress, animated: true)
        percentsLabel.text = "\(Int(HabitsStore.shared.todayProgress*100))%"
    }
}
