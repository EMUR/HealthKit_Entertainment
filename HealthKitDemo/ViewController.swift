//
//  ViewController.swift
//  HealthKitDemo
//
//  Created by E on 8/22/17.
//  Copyright © 2017 E. All rights reserved.
//

import UIKit
import HealthKit



extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

@IBDesignable
class ProgressCircle : UIView
{
    
    var burned = 0
    func drawCanvas1(width: CGFloat = 0) {
        
        let progress: CGFloat = 180 - width
        
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 20, y: 20, width: self.bounds.width/1.1, height:  self.bounds.width/1.1))
        UIColor.lightGray.withAlphaComponent(0.3).setStroke()
        ovalPath.lineWidth = 8.5
        ovalPath.lineCapStyle = .round
        ovalPath.stroke()
        
        
        //// Oval 2 Drawing
        let oval2Rect = CGRect(x: 20, y: 20, width:  self.bounds.width/1.1, height:  self.bounds.width/1.1)
        let oval2Path = UIBezierPath()
        oval2Path.addArc(withCenter: CGPoint(x: oval2Rect.midX, y: oval2Rect.midY), radius: oval2Rect.width / 2, startAngle: -180 * CGFloat.pi/180, endAngle: -progress * CGFloat.pi/180, clockwise: true)
        
        UIColor.init(hex: "2E8B57").setStroke()
        oval2Path.lineWidth = 8.5
        oval2Path.lineCapStyle = .round
        oval2Path.stroke()
    }
    
    func updateProgress(steps: Double!) throws
    {
        let value = try (Double(ViewController.getBurntCal())/Double(ViewController.burnTargetCal)) * 360
        try drawCanvas1(width: CGFloat(value) )
    }
    
    func reset()
    {
        drawCanvas1(width: 0.0)
    }
    
    override func draw(_ rect: CGRect) {

        do {
             try updateProgress(steps: ViewController.walkingDistance)
        }
        catch
        {
            reset()
        }
    }
}

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, updateTargetDelegate {
    
    
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var stepsCount: UILabel!
    var callHealthKit = true
    static var user:Profile!
    let group = DispatchGroup()
    static var  burnTargetCal = 500
    @IBOutlet weak var circle: ProgressCircle!
    static var walkingDistance = 0.0
    
    let modalTransition = ModalTransition()
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return modalTransition
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return modalTransition
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        stepsCount.textColor = UIColor.init(hex: "2E8B57")
        if(!setupProfile())
        {
            callHealthKit = true
        }else
        {
            callHealthKit = false
        } 
    }
    
    class func getBurntCal() throws -> Double
    {
        if(ViewController.user == nil)
        {
            throw NSError.init()
        }
        return ((ViewController.user.getWeight() * 0.453592) * 9.8 * (ViewController.walkingDistance * 1609.34)) * 0.000239006
    }
    
    func setupProfile() ->Bool
    {
        
        let healthKitStore = HKHealthStore()
        do {
            let d = try healthKitStore.dateOfBirthComponents()
            var dd = 0
            var step = 0
            
            if(d.month! < Calendar.current.component(.month, from: Date()))
            {
                dd = Calendar.current.component(.year, from: Date()) - d.year!
            }else if (d.month! == Calendar.current.component(.month, from: Date()))
            {
                if(d.day! >= Calendar.current.component(.day, from: Date()))
                {
                    dd = Calendar.current.component(.year, from: Date()) - d.year!
                }
                else
                {
                    dd = Calendar.current.component(.year, from: Date()) - d.year! - 1
                }
            }
            else
            {
                dd = Calendar.current.component(.year, from: Date()) - d.year! - 1
            }
            
            let g = try healthKitStore.biologicalSex().biologicalSex.rawValue
            var h = 0.0
            var w = 0.0
            var gg:Profile.GenderTypes!
            
            if (g == 1)
            {
                gg = Profile.GenderTypes.Female
            }else if ( g == 2)
            {
                gg = Profile.GenderTypes.Male
            }else
            {
                gg = Profile.GenderTypes.Other
            }
            
            group.enter()
            
            
            
            self.getMostRecentSample(for: HKSampleType.quantityType(forIdentifier: .height)!, completion: { (a, e) in
                h  = (a?.quantity.doubleValue(for: HKUnit.foot()))!
            })
            
            self.getMostRecentSample(for: HKSampleType.quantityType(forIdentifier: .bodyMass)!, completion: { (a, e) in
                w = (a?.quantity.doubleValue(for: HKUnit.pound()))!
            })
            
            self.getTodaysSummery(for: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), unit: HKUnit.mile() ,completion: { (walked) in
                ViewController.walkingDistance = walked
            })
            
            self.getTodaysSummery(for: HKQuantityType.quantityType(forIdentifier: .stepCount), unit: HKUnit.count(), completion: { (steps) in
                step = Int(steps)
                self.group.leave()
            })
            
            group.notify(queue: .main) {
                
                ViewController.user = Profile(Age: dd, Gender: gg, Weight: w, Height: h, Steps: step)
                self.stepsCount.text = "\(step)"
                do {
                self.calLabel.text = try String(format: "%.1f", ViewController.getBurntCal())
                } catch { self.calLabel.text = "0" }
                self.circle.setNeedsDisplay()
            }
            
            
        } catch
        {
            return false
        }
        
        return true
    }
    
    func getTodaysSummery(for type:HKQuantityType!, unit u:HKUnit!, completion: @escaping (Double) -> Void) {
        let stepsQuantityType = type
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType!, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            
            guard let result = result else {
                completion(resultCount)
                return
            }
            
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: u)
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        
        HKHealthStore().execute(query)
    }
    
    func getMostRecentSample(for sampleType: HKSampleType,
                             completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                              end: Date(),
                                                              options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)
        
        let limit = 1
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: mostRecentPredicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                                            
                                            DispatchQueue.main.async {
                                                
                                                guard let samples = samples,
                                                    let mostRecentSample = samples.first as? HKQuantitySample else {
                                                        
                                                        completion(nil, error)
                                                        return
                                                }
                                                
                                                completion(mostRecentSample, nil)
                                            }
        }
        
        HKHealthStore().execute(sampleQuery)
    }
    
    private func predicateForSamplesToday() -> NSPredicate
    {
        let (starDate, endDate): (Date, Date) = self.datesFromToday()
        
        let predicate: NSPredicate = HKQuery.predicateForSamples(withStart: starDate, end: endDate, options: HKQueryOptions.strictStartDate)
        
        return predicate
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if(callHealthKit)
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "GetAccessViewController") as! GetAccessViewController
            
            self.present(vc, animated: true) {
                self.callHealthKit = false
                _ = self.setupProfile()
            }
        }
    }

    
    private func datesFromToday() -> (Date, Date)
    {
        let calendar = Calendar.current
        
        let nowDate = Date()
        
        let starDate: Date = calendar.startOfDay(for: nowDate)
        let endDate: Date = calendar.date(byAdding: Calendar.Component.day, value: 1, to: starDate)!
        
        return (starDate, endDate)
    }
    
    func updateTarget() {
        self.circle.setNeedsDisplay()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "target")
        {
            let vc = segue.destination as! TargetViewController
            vc.del = self
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


