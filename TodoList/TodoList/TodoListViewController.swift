//
//  TodoListViewController.swift
//  TodoList
//
//  Created by J_Min on 2021/08/07.
//

import UIKit

class TodoListViewController: UIViewController {
    
    let todo = Todo.shared
    
    override func viewDidLoad() {
    }
    
}

class MainTableViewCell: UITableViewCell {
    
    let vc = TodoListViewController()
    
    @IBOutlet weak var stateButtonOulet: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBAction func stateButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "완료", style: .default) { _ in
            let image = UIImage(named: "circle.fill")
            self.stateButtonOulet.setImage(image, for: .normal)
        }
        let action2 = UIAlertAction(title: "진행중", style: .default) { _ in
            let image = UIImage(named: "circle.lefthalf.fill")
            self.stateButtonOulet.setImage(image, for: .normal)
        }
        let action3 = UIAlertAction(title: "진행전", style: .default) { _ in
            let image = UIImage(named: "circle")
            self.stateButtonOulet.setImage(image, for: .normal)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
