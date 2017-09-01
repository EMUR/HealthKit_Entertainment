//
//  Profile.swift
//  HealthKitDemo
//
//  Created by E on 8/22/17.
//  Copyright © 2017 E. All rights reserved.
//

import UIKit




class Profile {
    
    init(Age:Int,Gender:GenderTypes,Weight:Double!,Height:Double!, Steps:Int!) {
        self.age = Age
        self.gender = Gender
        self.weight = Weight
        self.height = Height
        self.stepsToday = Steps
    }
    
    enum GenderTypes : String
    {
        case Male
        case Female
        case Other
    }

    private var age:Int!
    private var gender:GenderTypes
    private var weight:Double!
    private var height:Double!
    private var stepsToday:Int!
    
    public func getAge() -> Int
    {
        return age;
    }
    
    public func getGender() -> String
    {
        return gender.rawValue
    }
    
    public func getWeight() -> Double
    {
        return weight
    }
    
    public func getHeight() -> Double
    {
        return height
    }
    
    public func getSteps() -> Int
    {
       return stepsToday
    }
    
    
    

}
