//
//  TodoListViewController.swift
//  TodoList
//
//  Created by J_Min on 2021/08/07.
//

import UIKit

class TodoListViewController: UIViewController {
    
    let todo = Todo.shared // 싱글톤
    var currentIndex: String = ""
    var todoArraySorted: [String] = []
    var pickerView = UIPickerView()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "오늘도 열심히!"
        
        print("viewdidload")
        
        // pageControl
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        print(pageControl.currentPage)

        // swipe
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        // 불러오기
        todo.todoArray = UserDefaults.standard.array(forKey: "todoArray") as? [String] ?? [""]
        todo.todoDictionary = UserDefaults.standard.dictionary(forKey: "todoDictionary") as? [String: [String]] ?? [:]
        print(todo.todoArray)
        print(todo.todoDictionary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentIndex = todo.todoArray[pageControl.currentPage]
        todo.dictionaryIndex = todo.todoDictionary[currentIndex] ?? []
        pageControl.numberOfPages = todo.todoArray.count
        tableView.reloadData()
        print(pageControl.numberOfPages)
        
        todoArraySorted = todo.todoArray.sorted(by: <)
        
        self.dateLabel.setTitle(todoArraySorted[pageControl.currentPage], for: .normal)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) { // 스와이프했을때 실행할 함수
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                if (pageControl.currentPage < pageControl.numberOfPages - 1) {
                    pageControl.currentPage = pageControl.currentPage + 1
                }
            case UISwipeGestureRecognizer.Direction.right: // 오른쪽스와이프
                if (pageControl.currentPage > 0) {
                    pageControl.currentPage = pageControl.currentPage - 1
                }
            default:

                break
            }
            currentIndex = todoArraySorted[pageControl.currentPage]
            todo.dictionaryIndex = todo.todoDictionary[currentIndex] ?? []
            self.dateLabel.setTitle(todoArraySorted[pageControl.currentPage], for: .normal)
            tableView.reloadData()
        }
    }

    
//    @objc func stateButton(sender: UIButton) {
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let action1 = UIAlertAction(title: "완료", style: .default) { _ in
//            let image = UIImage(named: "circle.fill")
//            image?.withTintColor(.darkGray)
//            sender.setImage(image, for: .normal)
//        }
//        let action2 = UIAlertAction(title: "진행중", style: .default) { _ in
//            let image = UIImage(named: "circle.lefthalf.fill")
//            image?.withTintColor(.darkGray)
//            sender.setImage(image, for: .normal)
//        }
//        let action3 = UIAlertAction(title: "진행전", style: .default) { _ in
//            let image = UIImage(named: "circle")
//            image?.withTintColor(.darkGray)
//            sender.setImage(image, for: .normal)
//        }
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//        alert.addAction(action1)
//        alert.addAction(action2)
//        alert.addAction(action3)
//        alert.addAction(cancelAction)
//        self.present(alert, animated: true, completion: nil)
//    }
    
    @IBAction func pageChanged(_ sender: Any) {
        currentIndex = todoArraySorted[pageControl.currentPage]
        todo.dictionaryIndex = todo.todoDictionary[currentIndex] ?? []
        tableView.reloadData()
    }
    
    @IBAction func dateChangeButton(_ sender: Any) {
        
        let pickerAlert = UIAlertController(title: "날짜를 선택해주세요", message: "\n\n\n\n\n", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.currentIndex = self.todoArraySorted[self.pageControl.currentPage]
            self.todo.self.dictionaryIndex = self.todo.todoDictionary[self.currentIndex] ?? []
            self.tableView.reloadData()
            self.dateLabel.setTitle(self.currentIndex, for: .normal)
        }
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        pickerAlert.view.addSubview(pickerFrame)
        pickerFrame.delegate = self
        pickerFrame.dataSource = self
        pickerAlert.addAction(okAction)
        
        self.present(pickerAlert, animated: true, completion: nil)
        
    }
    
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.dictionaryIndex.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.detailLabel.text = todo.dictionaryIndex[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension TodoListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return todoArraySorted.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return todoArraySorted[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let a = todoArraySorted[row]
        pageControl.currentPage = todoArraySorted.firstIndex(of: a) ?? 0
    }
}

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var stateButtonImage: UIButton!
    
    }

