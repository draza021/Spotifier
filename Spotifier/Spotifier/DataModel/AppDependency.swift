//
//  AppDependency.swift
//  Spotifier
//
//  Created by Drago on 6/7/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import Foundation

struct AppDependency {
    var dataManager: DataManager?
    
    init(dataManager: DataManager? = nil) {
        self.dataManager = dataManager
    }
}


protocol NeedsDependency {
    var dependencies: AppDependency? { get set }
}




