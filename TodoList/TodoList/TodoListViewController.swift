//
//  TodoListViewController.swift
//  TodoList
//
//  Created by J_Min on 2021/08/07.
//

import UIKit

class TodoListViewController: UIViewController {
    
    let todo = Todo.shared
    var currentIndex: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "오늘도 열심히!"
        
        print("viewdidload")
        
        // pageControl
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black

        // swipe
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentIndex = todo.todoArray[pageControl.currentPage]
        todo.dictionaryIndex = todo.todoDictionary[currentIndex] ?? []
        pageControl.numberOfPages = todo.todoArray.count
        tableView.reloadData()
        print(pageControl.numberOfPages)
        
        // swipe
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        self.view.addGestureRecognizer(swipeRight)
        
        self.dateLabel.text = todo.todoArray[pageControl.currentPage]
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
            currentIndex = todo.todoArray[pageControl.currentPage]
            todo.dictionaryIndex = todo.todoDictionary[currentIndex] ?? []
            self.dateLabel.text = todo.todoArray[pageControl.currentPage]
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
        
        currentIndex = todo.todoArray[pageControl.currentPage]
        todo.dictionaryIndex = todo.todoDictionary[currentIndex] ?? []
        tableView.reloadData()
        
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

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var stateButtonImage: UIButton!
    
    }

