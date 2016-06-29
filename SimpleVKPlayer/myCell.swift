import UIKit
import VK_ios_sdk




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
        
        self.backgroundColor = UIColor(red: 243/255, green: 40/255, blue: 100/255, alpha: 1.0)
        // Configure the view for the selected state
    }
    
}