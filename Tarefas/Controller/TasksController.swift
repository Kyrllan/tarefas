//
//  TasksController.swift
//  Tarefas
//
//  Created by Kyrllan Nogueira on 01/05/19.
//  Copyright © 2019 Kyrllan Nogueira. All rights reserved.
//

import UIKit

class TasksController: UITableViewController {
    
    var taskStore: TaskStore! {
        didSet {
            taskStore.tasks = TasksUtility.fetch() ?? [[Task](), [Task]()]
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
    }
    
    
    //adiciona cabeçalho das Sections, fazendo elas aparecerem na tabela
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Fazer" : "Feito"
    }

    // MARK: Delegate and Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.tasks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.tasks[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            guard let isDone = self.taskStore.tasks[indexPath.section][indexPath.row].isDone else { return }
            self.taskStore.removeTasks(at: indexPath.row, isDone: isDone)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1450980392, blue: 0.168627451, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .normal, title: nil) { (action, sourceView, completionHandler) in
            
            self.taskStore.tasks[0][indexPath.row].isDone = true
            
            let doneTask = self.taskStore.removeTasks(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.taskStore.add(doneTask, at: 0, isDone: true)
            
            tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            
            completionHandler(true)
            
        }
        
        doneAction.image = #imageLiteral(resourceName: "done")
        doneAction.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.7529411765, blue: 0.09411764706, alpha: 1)
        
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
        
    }

    

    
    @IBAction func add(_ sender: UIBarButtonItem) {
        // Criar alerta
        let alertController = UIAlertController(title: "Adicionar Tarefa", message: nil, preferredStyle: .alert)
        
        // Setar açoes
        let addAction = UIAlertAction(title: "Adicionar", style: .default) { _ in
        // Pegar o textfield
            guard let name = alertController.textFields?.first?.text else { return }
        // Criar a Tarefa
            let newTask = Task.init(name: name)
        // Adicionar a tarefa
            self.taskStore.add(newTask, at: 0)
        // Recarregar tableview
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        
            
        }
        addAction.isEnabled = false
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        // Adicionar o campo de texto
        alertController.addTextField { textField in
            textField.placeholder = "Nome da tarefa"
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        // Adicionar as açoes no alerta
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        // Apresentar o Alerta
        present(alertController, animated: true)
        
        
    }
    
    @objc private func handleTextChanged(_ sender: UITextField) {
        
        // Pegar o alerta controller e adicionar ação
        guard let alertController = presentedViewController as? UIAlertController,
                let addAction = alertController.actions.first,
                let text = sender.text
                else { return }
        
        // Habilitar ação adicionada se o campo de texto for vazio ou só contiver espaços em branco
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    
    }
    
    
    
    
}

