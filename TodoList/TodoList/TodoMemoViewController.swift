//
//  TodoMemoViewController.swift
//  TodoList
//
//  Created by J_Min on 2021/08/16.
//

import UIKit

class TodoMemoViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var todoMemoTextView: UITextView!
    
    var dateString: String = ""
    var todoString: String = ""
    var memoString: String = ""
    var todoIndex: Int = 0
    let listVC = TodoListViewController()
    let todo = Todo.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoMemoTextView.delegate = self

        print("받은값 --> \(todoIndex)")
        dateLabel.text = dateString
        todoLabel.text = todoString
        todoMemoTextView.text = memoString
        placeHolderSetting()
        
        // textView
        todoMemoTextView.layer.borderColor = UIColor.lightGray.cgColor
        todoMemoTextView.layer.borderWidth = 2
        todoMemoTextView.layer.cornerRadius = 10
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard todoMemoTextView.text != "" else {
            let alert = UIAlertController(title: nil, message: "메모를 입력해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard todoMemoTextView.text != "메모를 입력해주세요" else {
            let alert = UIAlertController(title: nil, message: "메모를 입력해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        todo.memoDictionary[dateString]?[todoIndex] = todoMemoTextView.text
        todo.storage()
        print(todo.memoDictionary)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
    
    func placeHolderSetting() {
        if todoMemoTextView.text == "" {
            todoMemoTextView.text = "메모를 입력해주세요"
            todoMemoTextView.textColor = .lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if todoMemoTextView.textColor == .lightGray {
            todoMemoTextView.text = nil
            todoMemoTextView.textColor = .label
        }
    }
//    
//    func textViewDidChange(_ textView: UITextView) {
//        <#code#>
//    }
//    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            todoMemoTextView.text = "메모를 입력해주세요"
            todoMemoTextView.textColor = .lightGray
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard todoMemoTextView.text != "" else {
            let alert = UIAlertController(title: nil, message: "메모를 입력해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard todoMemoTextView.text != "메모를 입력해주세요" else {
            let alert = UIAlertController(title: nil, message: "메모를 입력해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        todo.memoDictionary[dateString]?[todoIndex] = todoMemoTextView.text
        todo.storage()
        print(todo.memoDictionary)
        self.navigationController?.popViewController(animated: true)
    }
    
}
