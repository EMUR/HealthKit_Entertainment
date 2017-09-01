//
//  TargetViewController.swift
//  HealthKitDemo
//
//  Created by E on 8/27/17.
//  Copyright © 2017 E. All rights reserved.
//

import UIKit

protocol updateTargetDelegate: class {
    func updateTarget()
}

class TargetViewController: UIViewController {
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var numLabel: UILabel!
    weak var del:updateTargetDelegate?
    
    override func viewWillLayoutSubviews() {
        
        if(ViewController.burnTargetCal == 500)
        {
            self.segControl.selectedSegmentIndex = 0
        }else if(ViewController.burnTargetCal == 750)
        {
            self.segControl.selectedSegmentIndex = 1

        }else
        {
            self.segControl.selectedSegmentIndex = 2
        }
        
        updateText()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateText() {
        numLabel.text = "\(Double(ViewController.burnTargetCal))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressOption(_ sender: Any) {
        switch segControl.selectedSegmentIndex {
        case 0:
            ViewController.burnTargetCal = 500
            updateText()
            break
        
        case 1:
            ViewController.burnTargetCal = 750
            updateText()
            break
            
        case 2:
            ViewController.burnTargetCal = 1050
            updateText()
            break
            
        default:
            print("huh?")
        }
    }
    
    @IBAction func close(_ sender: Any) {
        del?.updateTarget()
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
