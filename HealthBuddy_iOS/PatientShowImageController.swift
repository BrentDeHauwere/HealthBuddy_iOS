//
//  PatientShowImageController.swift
//  HealthBuddy_iOS
//
//  Created by Eli on 20/04/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit

class PatientShowImageController: UIViewController,UIScrollViewDelegate {
    var image:UIImage!;
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.scrollView.minimumZoomScale = 1;
        self.scrollView.maximumZoomScale = 6;
        self.imageV.image = image;
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
