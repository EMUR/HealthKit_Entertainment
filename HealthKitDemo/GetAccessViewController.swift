//
//  GetAccessViewController.swift
//  HealthKitDemo
//
//  Created by E on 8/22/17.
//  Copyright © 2017 E. All rights reserved.
//

import UIKit
import HealthKit

class GetAccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getAccess(_ sender: Any) {
        authorizeHealthKit { (done, error) in
            if(done)
            {
                self.dismiss(animated: true, completion: {
                    
                })
            }else
            {
                print(error)
            }
        }
    }
    
    func authorizeHealthKit(completion: @escaping (Bool, String) -> Swift.Void) {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false,"no healthKit")
            return
        }
        
        guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            let gender = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let steps = HKObjectType.quantityType(forIdentifier: .stepCount),
            let distance = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
                
                completion(false, "no data")
                return
        }
    

        let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex,
                                                        activeEnergy,
                                                        steps,
                                                        distance,
                                                        HKObjectType.workoutType()]
        
        let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                       bloodType,
                                                       gender,
                                                       bodyMassIndex,
                                                       height,
                                                       steps,
                                                       bodyMass,
                                                       distance,
                                                       HKObjectType.workoutType()]
        

        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead) { (success, error) in
                                                completion(success, "failed to get authorization")
        }
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
