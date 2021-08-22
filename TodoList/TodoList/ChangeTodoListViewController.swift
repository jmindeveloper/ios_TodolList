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
        tableView.dataSource = self
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
                
        dateLabel.text = currentDate
        dateLabel2.text = currentDate
        currentDateArray = todo.todoDictionary[currentDate]!
        print(currentDateArray.count)

    }
    
    @objc func deleteBtnAction(_ sender: UIButton) { // 삭제

        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        currentDateArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        todo.todoDictionary[currentDate] = currentDateArray

        todo.memoDictionary[currentDate]?.remove(at: indexPath.row)
        if (todo.todoDictionary[currentDate]?.isEmpty) != nil { // todoDictionary에 lastStr키의 배열이 존재할때
            if (todo.todoDictionary[currentDate]?.isEmpty)! { // todoDictionary에 lastStr키의 배열이 비어있을때
                guard let firstIndex = todo.todoArray.firstIndex(of: currentDate) else { return }
                todo.todoArray.remove(at: firstIndex) // todoArray에 lastStr 값 삭제
                todo.todoDictionary[currentDate] = nil // todoDictionry에 lastStr키 삭제
                todo.memoDictionary[currentDate] = nil
                print(todo.todoArray)
                todo.storage()
            }
        }
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
        cell.deleteButton.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
        return cell
    }
}

extension ChangeTodoListViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        return
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
}

class ChangeCell: UITableViewCell {
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    
}
