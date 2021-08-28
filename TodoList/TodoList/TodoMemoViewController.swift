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
    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
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
    
        // keyboard notification
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.todoMemoTextView.contentInset
                inset.bottom = height
                strongSelf.todoMemoTextView.contentInset = inset
                
                inset = strongSelf.todoMemoTextView.horizontalScrollIndicatorInsets
                inset.bottom = height
                strongSelf.todoMemoTextView.scrollIndicatorInsets = inset
            }
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            
            var inset = strongSelf.todoMemoTextView.contentInset
            inset.bottom = 0
            strongSelf.todoMemoTextView.contentInset = inset
            
            inset = strongSelf.todoMemoTextView.horizontalScrollIndicatorInsets
            inset.bottom = 0
            strongSelf.todoMemoTextView.scrollIndicatorInsets = inset
        })
        
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
