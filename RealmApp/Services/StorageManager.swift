//
//  StorageManager.swift
//  RealmApp
//
//  Created by Alexey Efimov on 07.10.2021.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    let realm = try! Realm()
    
    private init() {}
    
    // MARK: - TaskList
    func save(_ taskLists: [TaskList]) {
        write {
            realm.add(taskLists)
        }
    }
    
    func save(_ taskList: TaskList) {
        write {
            realm.add(taskList)
        }
    }
    
    func delete(taskList: TaskList? = nil, task: Task? = nil) {
        write {
            if let taskList = taskList {
                realm.delete(taskList.tasks)
                realm.delete(taskList)
            }
            if let task = task {
                realm.delete(task)
            }
        }
    }
    
    func edit(taskList: TaskList? = nil, newValue: String, note: String? = nil, task: Task? = nil) {
        write {
            if let taskList = taskList {
                taskList.name = newValue
            }
            if let task = task, let note = note {
                task.name = newValue
                task.note = note
            }
        }
    }
    
    func done(taskList: TaskList? = nil, task: Task? = nil) {
        write {
            if let taskList = taskList {
                taskList.tasks.setValue(true, forKey: "isComplete")
            }
            if let task = task {
                    task.isComplete.toggle()
                    task.setValue(task.isComplete, forKey: "isComplete")
            }
        }
    }
    
    // MARK: - Tasks
    func save(_ task: Task, to taskList: TaskList) {
        write {
            taskList.tasks.append(task)
        }
    }
    
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch let error {
            print(error)
        }
    }
}
