//
//  AddTodoViewController.swift
//  TodoList
//
//  Created by J_Min on 2021/08/07.
//

import UIKit

class AddTodoViewController: UIViewController {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var addTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var lastStr = ""
    
    let datePicker = UIDatePicker()
    let todo = Todo()
    let cellController = AddListTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // datePicker 속성설정
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400)
        datePicker.locale = Locale(identifier: "Korean")
        createDatePicker()
        
        addTableView.dragInteractionEnabled = true
        addTableView.dragDelegate = self
        addTableView.dropDelegate = self
    }
    
    // CustomToolBar
    func creatToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: true)
        return toolBar
    }
    
    func createDatePicker() {
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = creatToolBar()
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        self.dateLabel.text = formatter.string(from: datePicker.date)
        // test
        
        let str = dateTextField.text!
        
        defer {
            lastStr = str
            print(todo.todoArray)
            print(todo.todoDictionary)
        }
        
        if todo.todoArray.contains(str) != true {
            todo.todoArray.append(str)
            todo.todoDictionary[str] = []
        }
        
        if (todo.todoDictionary[lastStr]?.isEmpty) != nil {
            if (todo.todoDictionary[lastStr]?.isEmpty)! {
                guard let firstIndex = todo.todoArray.firstIndex(of: lastStr) else { return }
                todo.todoArray.remove(at: firstIndex)
                todo.todoDictionary[lastStr] = nil
            }
        }
        
        todoTextField.text = ""
        
        guard let firstIndex = todo.todoArray.firstIndex(of: str) else { return }
        todo.currentDate = todo.todoArray[firstIndex]
        todo.dictionaryIndex = todo.todoDictionary[todo.currentDate] ?? []
        
        addTableView.reloadData()
    }
    
    @objc func deleteBtnAction(_ sender: UIButton) {
        let str = dateTextField.text!
        let point = sender.convert(CGPoint.zero, to: addTableView)
        guard let indexPath = addTableView.indexPathForRow(at: point) else { return }
        todo.dictionaryIndex.remove(at: indexPath.row)
        addTableView.deleteRows(at: [indexPath], with: .automatic)
        todo.todoDictionary[str] = todo.dictionaryIndex
    }
    
    // action
    @IBAction func addButton(_ sender: Any) {
        let str = dateTextField.text!
        let str2 = todoTextField.text!
        var a = false
        var b = false
        if str == "" {
            let alert = UIAlertController(title: nil, message: "날짜를 입력해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            a = true
        }
        if a == true {
            if str2 == "" {
                let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                b = true
            }
        }
        if a == true , b == true {
            todo.todoDictionary[str]?.append(str2)
            if todo.todoArray.contains("") {
                todo.todoArray.removeFirst()
            }
//            print(todo.todoArray)
//            print(todo.todoDictionary)
        }
        
        guard let firstIndex = todo.todoArray.firstIndex(of: str) else { return }
        todo.currentDate = todo.todoArray[firstIndex]
        todo.dictionaryIndex = todo.todoDictionary[todo.currentDate] ?? []
        
        addTableView.reloadData()
        print(todo.dictionaryIndex)
    }
}

extension AddTodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.dictionaryIndex.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addListCell", for: indexPath) as? AddListTableViewCell else {
            return UITableViewCell()
        }
        cell.addCellLabel.text = todo.dictionaryIndex[indexPath.row]
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let str = dateTextField.text!
        
        let moveCell = todo.dictionaryIndex[sourceIndexPath.row]
        todo.dictionaryIndex.remove(at: sourceIndexPath.row)
        todo.dictionaryIndex.insert(moveCell, at: destinationIndexPath.row)
        todo.todoDictionary[str] = todo.dictionaryIndex
    }
}

// drag and drop
extension AddTodoViewController: UITableViewDragDelegate, UITableViewDropDelegate {
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

class AddListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var addCellLabel: UILabel!
    
}
