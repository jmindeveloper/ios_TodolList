//
//  ViewController.swift
//  TodoList
//
//  Created by J_Min on 2021/08/04.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {

    var date: [String] = []
    
    @IBOutlet weak var calendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendar.appearance.titleDefaultColor = .green
        calendar.appearance.titleWeekendColor = .red
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.locale = Locale(identifier: "ko_kr")
        
    }

    @IBAction func Btn(_ sender: Any) {
        guard let modalPresentView = self.storyboard?.instantiateViewController(identifier: "testViewController") as? TestViewController else { return }
        self.present(modalPresentView, animated: true, completion: nil)
        modalPresentView.dateArray = self.date
        
    }
    
}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        let nextPage = TestViewController()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        self.date.append(dateString)
//        print(dateString)
//        print(self.date)
        
    }
}

class TestViewController: UIViewController {
    
    var dateArray: [String] = []
//    let vc = ViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        print(self.dateArray)
    }
}


extension TestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.cellLbl.text = "\(self.dateArray[indexPath.row])"
        
        return cell
    }
    
}

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellLbl: UILabel!
}
