import UIKit
import VK_ios_sdk






class ConnectInternet: UIViewController {
    
    
    
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    
    
    @IBAction func actionRefreshBtn(sender: UIButton) {
        checkInternetStatus()
    }
    
    @IBAction func actionCloseBtn(sender: UIButton) {
        exit(0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //refreshBtn.backgroundColor = UIColor.clearColor()
        refreshBtn.layer.cornerRadius = 5
        //refreshBtn.layer.borderWidth = 1
        refreshBtn.layer.backgroundColor = UIColor(red: 32/255, green: 175/255, blue: 0/255, alpha: 1.0).CGColor
        
        
        //closeBtn.backgroundColor = UIColor.clearColor()
        closeBtn.layer.cornerRadius = 5
        //closeBtn.layer.borderWidth = 1
        //closeBtn.layer.borderColor = UIColor.redColor().CGColor
        closeBtn.layer.backgroundColor = UIColor(red: 204/255, green: 0/255, blue: 0/255, alpha: 1.0).CGColor
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkInternetStatus()
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    func checkInternetStatus() {
        if Reachability.isConnectedToNetwork() == true {
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Main") as! ViewController
            self.presentViewController(vc, animated: true, completion: nil)
            
        } else {
            
            
            
        }
    }
}


