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
        currentDateArray = todo.todoDictionary[currentDate] ?? []
        print(currentDateArray.count)
        
        // navigation
        self.navigationItem.title = "Todo 수정"
        let deleteImage = UIImage(systemName: "trash")
        let deleteButton = UIBarButtonItem(image: deleteImage, style: .plain, target: self, action: #selector(allDeleteButtonAction(_:)))
        deleteButton.tintColor = .darkGray
        self.navigationItem.rightBarButtonItem = deleteButton
        
        print("dictionaryINdex --> \(todo.dictionaryIndex)")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        todo.storage()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
    
    @objc func allDeleteButtonAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "경고", message: "\(currentDate)의 Todo를 전부 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            let currentDateIndex = self.todo.todoArray.firstIndex(of: self.currentDate)
            self.todo.todoArray.remove(at: currentDateIndex!)
            self.todo.todoDictionary[self.currentDate] = nil
            self.todo.memoDictionary[self.currentDate] = nil
            self.todo.stateDictionary[self.currentDate] = nil
            self.currentDateArray = []
            self.tableView.reloadData()
            self.todo.storage()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func deleteBtnAction(_ sender: UIButton) { // 삭제

        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        currentDateArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        todo.todoDictionary[currentDate] = currentDateArray

        todo.memoDictionary[currentDate]?.remove(at: indexPath.row)
        todo.stateDictionary[currentDate]?.remove(at: indexPath.row)
        if (todo.todoDictionary[currentDate]?.isEmpty) != nil { // todoDictionary에 lastStr키의 배열이 존재할때
            if (todo.todoDictionary[currentDate]?.isEmpty)! { // todoDictionary에 lastStr키의 배열이 비어있을때
                guard let firstIndex = todo.todoArray.firstIndex(of: currentDate) else { return }
                todo.todoArray.remove(at: firstIndex) // todoArray에 lastStr 값 삭제
                todo.todoDictionary[currentDate] = nil // todoDictionry에 lastStr키 삭제
                todo.memoDictionary[currentDate] = nil
                todo.stateDictionary[currentDate] = nil
                todo.storage()
            }
        }
        print("todoArray --> \(todo.todoArray)")
        print("todoDictionary --> \(todo.todoDictionary)")
        print("memoDictionary --> \(todo.memoDictionary)")
        print("stateDictionary --> \(todo.stateDictionary)")
        print("-----------------------------------------")
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        let str = textField.text!
        
        if str == "" { // str값이 빈값일때
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            if todo.todoArray.contains(currentDate) != true { // todoArray에 currentDate이 없을때
                todo.todoArray.append(currentDate) // todoArray에 currentDate 저장
                todo.todoDictionary[currentDate] = [str] // todoDictionary의 key에 currentDate 저장
                todo.memoDictionary[currentDate] = [""] // memoDictionary의 key에 currentDate 저장
                todo.stateDictionary[currentDate] = ["진행전"]
            } else {
                todo.todoDictionary[currentDate]?.append(str) // todoDictionary의 currentDate키의 배열에 str 저장
                todo.memoDictionary[currentDate]?.append("")
                todo.stateDictionary[currentDate]?.append("진행전")
            }
        }

        guard let firstIndex = todo.todoArray.firstIndex(of: currentDate) else { return } // firstIndex값에 str값 index 저장
        todo.currentDate = todo.todoArray[firstIndex] // currentDate에 firstIndex값에 해당하는 값 저장
        currentDateArray = todo.todoDictionary[todo.currentDate] ?? [] // currentDateArray에 todoDictionary의 currentDate값에 해당하는 key의 배열 저장
        
        textField.text = ""
        tableView.reloadData()
        todo.storage()
        print("todoArray --> \(todo.todoArray)")
        print("todoDictionary --> \(todo.todoDictionary)")
        print("memoDictionary --> \(todo.memoDictionary)")
        print("stateDictionary --> \(todo.stateDictionary)")
        print("-----------------------------------------")
        print("dictionaryINdex --> \(todo.dictionaryIndex)")
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
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let moveCell = currentDateArray[sourceIndexPath.row]
        guard let moveMemo = todo.memoDictionary[currentDate]?[sourceIndexPath.row] else { return }
        guard let moveState = todo.stateDictionary[currentDate]?[sourceIndexPath.row] else { return }
        currentDateArray.remove(at: sourceIndexPath.row)
        currentDateArray.insert(moveCell, at: destinationIndexPath.row)
        todo.memoDictionary[currentDate]?.remove(at: sourceIndexPath.row)
        todo.memoDictionary[currentDate]?.insert(moveMemo, at: destinationIndexPath.row)
        todo.stateDictionary[currentDate]?.remove(at: sourceIndexPath.row)
        todo.stateDictionary[currentDate]?.insert(moveState, at: destinationIndexPath.row)
        todo.todoDictionary[currentDate] = currentDateArray
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
