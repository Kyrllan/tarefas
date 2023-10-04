//
//  TasksUtility.swift
//  Tarefas
//
//  Created by Kyrllan Nogueira on 02/05/19.
//  Copyright © 2019 Kyrllan Nogueira. All rights reserved.
//

import Foundation

class TasksUtility {
    
    private static let key = "task"
    
    private static func archive(_ tasks: [[Task]]) -> NSData {
        return NSKeyedArchiver.archivedData(withRootObject: tasks) as NSData
    }
    
    static func fetch() -> [[Task]]? {
        guard let unarchivedData = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: unarchivedData) as? [[Task]]
    }
    
    static func save(_ tasks: [[Task]]) {
        
        let archivedTasks = archive(tasks)
        
        UserDefaults.standard.set(archivedTasks, forKey: key)
        UserDefaults.standard.synchronize()
        
    }
    
    
}
