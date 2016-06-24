import UIKit

class myCell: UITableViewCell {
 
    @IBOutlet weak var cellTrackName: UILabel!
    @IBOutlet weak var timePlay: UILabel!
    @IBOutlet weak var isPlaying: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}