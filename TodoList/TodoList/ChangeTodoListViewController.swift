//
//  ChangeTodoList.swift
//  TodoList
//
//  Created by J_Min on 2021/08/22.
//

import UIKit

class ChangeTodoListViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateLabel2: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let todo = Todo.shared
    var currentDateArray: [String] = []
    var currentDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 2
        tableView.layer.cornerRadius = 10
        self.tableView.dataSource = self
        
                
        dateLabel.text = currentDate
        dateLabel2.text = currentDate
        currentDateArray = todo.todoDictionary[currentDate]!
        print(currentDateArray.count)

    }
    
    @IBAction func addButton(_ sender: Any) {
        
    }
    
}

extension ChangeTodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "changeTodo", for: indexPath) as? ChangeCell else {
            return UITableViewCell()
        }
        cell.label.text = currentDateArray[indexPath.row]
        return cell
    }
}

class ChangeCell: UITableViewCell {
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    
}
