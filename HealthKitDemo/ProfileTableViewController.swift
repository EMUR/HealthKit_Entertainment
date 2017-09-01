//
//  ProfileTableViewController.swift
//  HealthKitDemo
//
//  Created by E on 8/24/17.
//  Copyright © 2017 E. All rights reserved.
//


extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}

import UIKit

class ProfileTableViewController: UITableViewController, UIViewControllerTransitioningDelegate{
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var age: UILabel!
    
    let modalTransition = ModalTransition()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return modalTransition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return modalTransition
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.alpha = 0.01
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
        self.age.text = "\(ViewController.user.getAge())"
        self.sex.text = ViewController.user.getGender()
        self.height.text = ViewController.user.getHeight().toString()
        self.weight.text = ViewController.user.getWeight().toString()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override var prefersStatusBarHidden: Bool{
        return true
    }

}
