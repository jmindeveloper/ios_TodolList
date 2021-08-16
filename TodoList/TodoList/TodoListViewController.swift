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
    let formatter = DateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "오늘도 열심히!"
        
        print("viewdidload")
        
        // pageControl
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
        
        // navigationBackBarButtonItem Custom
        let backBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .darkGray
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        // 앱 실행시 현재날짜로 보여주기
        pageControl.numberOfPages = todo.todoArray.count
        todoArraySorted = todo.todoArray.sorted(by: <)
        formatter.dateFormat = "yyyy년 MM월 dd일"
        let currentDate = formatter.string(from: Date())
        let currentIndex = todoArraySorted.firstIndex(of: currentDate)
        pageControl.currentPage = currentIndex ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        let currentDate = formatter.string(from: Date())
        print(currentDate)
        if todo.todoArray.contains(currentDate) != true { // 오늘날짜에 해당하는 array값이 없으면
            todo.todoArray.append(currentDate) // array에 오늘날짜 추가하기
            todo.todoDictionary[currentDate] = [] // 딕셔너리에도 추가하기
            todo.memoDictionary[currentDate] = []
        }
        todoArraySorted = todo.todoArray.sorted(by: <)
        pageControl.numberOfPages = todo.todoArray.count
        print(pageControl.numberOfPages)
        setData()
        tableView.reloadData()
    }
    
    func setData() {
        currentIndex = todoArraySorted[pageControl.currentPage]
        todo.dictionaryIndex = todo.todoDictionary[currentIndex] ?? []
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
            setData()
            tableView.reloadData()
        }
    }
    
    @IBAction func pageChanged(_ sender: Any) {
        setData()
        tableView.reloadData()
    }
    
    @IBAction func dateChangeButton(_ sender: Any) {
        
        let pickerAlert = UIAlertController(title: "날짜를 선택해주세요", message: "\n\n\n\n\n", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.setData()
            self.tableView.reloadData()
        }
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        let a = todoArraySorted[pageControl.currentPage]
        print(a)
        if let indexPosition = todoArraySorted.firstIndex(of: a) {
            pickerFrame.selectRow(indexPosition, inComponent: 0, animated: true)
            print(indexPosition)
        }
        
//        pickerFrame.selectRow(3, inComponent: 0, animated: true)
        pickerAlert.view.addSubview(pickerFrame)
        pickerFrame.delegate = self
        pickerFrame.dataSource = self
        pickerAlert.addAction(okAction)
        
        self.present(pickerAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func leftButton(_ sender: Any) {
        if (pageControl.currentPage > 0) {
            pageControl.currentPage = pageControl.currentPage - 1
        }
        setData()
        tableView.reloadData()
        
    }
    
    @IBAction func rightButton(_ sender: Any) {
        if (pageControl.currentPage < pageControl.numberOfPages - 1) {
            pageControl.currentPage = pageControl.currentPage + 1
        }
        setData()
        tableView.reloadData()
    }
    @IBAction func removeAllData(_ sender: Any) {
        let alert = UIAlertController(title: "경고", message: "모든 Todo를 삭제하겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.todoArraySorted.removeAll()
            self.todo.todoArray.removeAll()
            self.todo.todoDictionary.removeAll()
            self.todo.memoDictionary.removeAll() 
            self.formatter.dateFormat = "yyyy년 MM월 dd일"
            let currentDate = self.formatter.string(from: Date())
            self.todo.todoArray.append(currentDate) // array에 오늘날짜 추가하기
            self.todo.todoDictionary[currentDate] = [] // 딕셔너리에도 추가하기
            self.todo.memoDictionary[currentDate] = []
            self.pageControl.numberOfPages = 0
            self.pageControl.currentPage = 0
            self.todoArraySorted = self.todo.todoArray.sorted(by: <)
            self.setData()
            self.tableView.reloadData()
            self.todo.storage()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func moveTodayDate(_ sender: Any) {
        formatter.dateFormat = "yyyy년 MM월 dd일"
        let currentDate = formatter.string(from: Date())
        let currentDateString = todoArraySorted.firstIndex(of: currentDate)
        pageControl.currentPage = currentDateString ?? 0
        setData()
        tableView.reloadData()
    }
    
}

extension TodoListViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memoVC = self.storyboard?.instantiateViewController(withIdentifier: "memoVC") as? TodoMemoViewController else { return }
        memoVC.dateString = todoArraySorted[pageControl.currentPage]
        memoVC.todoString = todo.todoDictionary[memoVC.dateString]![indexPath.row]
        memoVC.todoIndex = indexPath.row
        memoVC.memoString = todo.memoDictionary[memoVC.dateString]?[indexPath.row] ?? ""
        
        print("넘겨준값 --> \(indexPath.row)")
        
        self.navigationController?.pushViewController(memoVC, animated: true)
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

