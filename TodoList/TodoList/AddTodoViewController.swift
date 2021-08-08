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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // datePicker 속성설정
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400)
        datePicker.locale = Locale(identifier: "Korean")
        createDatePicker()
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
        
        addTableView.reloadData()
    }
    
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
            print(todo.todoArray)
            print(todo.todoDictionary)
        }
    }
}

extension AddTodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

class AddListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addCellLabel: UILabel!
    
    @IBAction func deleteButton(_ sender: Any) {
        
    }
    
}
