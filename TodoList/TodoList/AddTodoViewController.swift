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
    let todo = Todo.shared // singletone
    let cellController = AddListTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // datePicker 속성설정
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400)
        datePicker.locale = Locale(identifier: "Korean")
        createDatePicker()
        // tableview drag and drop
        addTableView.dragInteractionEnabled = true
        addTableView.dragDelegate = self
        addTableView.dropDelegate = self
        
        // 네비게이션바 백버튼 커스텀
        self.navigationController?.navigationBar.tintColor = .darkGray
        self.navigationController?.navigationBar.topItem?.title = "Back"
        
        todo.currentDate = ""
        todo.dictionaryIndex = []
    }
    
    // CustomToolBar
    func creatToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: true)
        return toolBar
    }
    // dateTextFied 터치시 inputView, toolBar
    func createDatePicker() {
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = creatToolBar()
    }
    // done button 클릭시
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        self.dateLabel.text = formatter.string(from: datePicker.date)
        
        let str = dateTextField.text!
        
        defer { // 함수 종료시 실행
            lastStr = str // lastStr을 현재 date 로 바꾸기
            print(todo.todoArray)
            print(todo.todoDictionary)
        }
        
        if todo.todoArray.contains(str) != true { // todoArray에 str이 없을때
            todo.todoArray.append(str) // todoArray에 str 저장
            todo.todoDictionary[str] = [] // todoDictionary의 key에 str 저장
        }
        
        if (todo.todoDictionary[lastStr]?.isEmpty) != nil { // todoDictionary에 lastStr키의 배열이 존재할때
            if (todo.todoDictionary[lastStr]?.isEmpty)! { // todoDictionary에 lastStr키의 배열이 비어있을때
                guard let firstIndex = todo.todoArray.firstIndex(of: lastStr) else { return }
                todo.todoArray.remove(at: firstIndex) // todoArray에 lastStr 값 삭제
                todo.todoDictionary[lastStr] = nil // todoDictionry에 lastStr키 삭제
            }
        }
        
        todoTextField.text = "" // todoTextField.text 비우기
        
        guard let firstIndex = todo.todoArray.firstIndex(of: str) else { return } // firstIndex값에 str값 index 저장
        todo.currentDate = todo.todoArray[firstIndex] // currentDate에 firstIndex값에 해당하는 값 저장
        todo.dictionaryIndex = todo.todoDictionary[todo.currentDate] ?? [] // dictionaryIndex에 todoDictionary의 currentDate값에 해당하는 key의 배열 저장
        
        addTableView.reloadData()
    }
    
    @objc func deleteBtnAction(_ sender: UIButton) {
        let str = dateTextField.text!
        let point = sender.convert(CGPoint.zero, to: addTableView)
        guard let indexPath = addTableView.indexPathForRow(at: point) else { return }
        todo.dictionaryIndex.remove(at: indexPath.row)
        addTableView.deleteRows(at: [indexPath], with: .automatic)
        todo.todoDictionary[str] = todo.dictionaryIndex // todoDictionary에 삭제된 배열인 dictionaryIndex 업데이트
    }
    
    // action
    @IBAction func addButton(_ sender: Any) {
        let str = dateTextField.text!
        let str2 = todoTextField.text!
        var a = false
        var b = false
        if str == "" { // str이 빈값일때
            let alert = UIAlertController(title: nil, message: "날짜를 입력해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            a = true // 빈값이 아니면 a = true
        }
        if a == true { // a == true일때
            if str2 == "" { // str2값이 빈값일때
                let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                b = true // str2가 빈값이 아닐때 b = true
            }
        }
        if a == true , b == true { // a와 b가 모두 true 일때
            todo.todoDictionary[str]?.append(str2) // todoDictionary의 str키의 배열에 str2 저장
            if todo.todoArray.contains("") {
                todo.todoArray.removeFirst()
            }
//            print(todo.todoArray)
//            print(todo.todoDictionary)
        }
        
        guard let firstIndex = todo.todoArray.firstIndex(of: str) else { return } // firstIndex값에 str값 index 저장
        todo.currentDate = todo.todoArray[firstIndex] // currentDate에 firstIndex값에 해당하는 값 저장
        todo.dictionaryIndex = todo.todoDictionary[todo.currentDate] ?? [] // dictionaryIndex에 todoDictionary의 currentDate값에 해당하는 key의 배열 저장
        
        todoTextField.text = ""
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
    // 셀 삭제
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
