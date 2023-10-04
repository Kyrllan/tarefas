//
//  TaskStore.swift
//  Tarefas
//
//  Created by Kyrllan Nogueira on 01/05/19.
//  Copyright © 2019 Kyrllan Nogueira. All rights reserved.
//

import Foundation

class TaskStore {
    
    var tasks = [[Task](), [Task]()]
    
    // adicionar tarefa
    func add(_ task: Task, at index: Int, isDone: Bool = false) {
        let section = isDone ? 1 : 0
        tasks[section].insert(task, at: index)
    }
    
    // remover tarefa
    @discardableResult func removeTasks(at index: Int, isDone: Bool = false) -> Task {
        let section = isDone ? 1 : 0
        return tasks[section].remove(at: index)
    }
}
