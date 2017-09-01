//
//  WorkingViewController.swift
//  HealthKitDemo
//
//  Created by E on 8/27/17.
//  Copyright © 2017 E. All rights reserved.
//

import UIKit

class WorkingViewController: UIViewController, UIViewControllerTransitioningDelegate {

    
    let modalTransition = ModalTransition()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return modalTransition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return modalTransition
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    var timer = Timer()
    var timeRunning = 0
    @IBOutlet weak var img: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
    }
    
    func animateImg()
    {
        if(timeRunning % 2 == 0)
        {
            UIView.animate(withDuration: 1.0) {
            self.img.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        }
        else
        {
            UIView.animate(withDuration: 1.0) {
                self.img.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stop(_ sender: Any) {
        timer.invalidate()
        self.dismiss(animated: true) {
            
        }
    }
    
    @objc func timerRunning()
    {
        timeRunning += 1
        let minutes = Int(timeRunning) / 60 % 60
        let seconds = Int(timeRunning) % 60
        timerLabel.text = "\(minutes):\(seconds)"
        animateImg()

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
