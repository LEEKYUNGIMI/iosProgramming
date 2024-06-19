//
//  ViewController.swift
//  Project
//
//  Created by 이경미 on 2024/06/16.
//
import UIKit
class HomeViewController: UIViewController{
    
@IBOutlet weak var calendarButton: UIButton!

@IBOutlet weak var todoButton: UIButton!

override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    calendarButton.setTitle("캘린더", for:  .normal)
    
    todoButton.setTitle("투두리스트", for: .normal)
    
    // Do any additional setup after loading the view.
}

@IBAction func openCalendar(_ sender: UIButton) {
    print("캘린더버튼눌림")
    guard let calendarVC = self.storyboard?.instantiateViewController(identifier: "CalendarViewController") else{return}
    self.present(calendarVC,animated: true)
}

@IBAction func openTodoList(_ sender: UIButton) {
    print("투두리스트버튼눌림")
    guard let todoVC = self.storyboard?.instantiateViewController(identifier: "TodoListViewController") else{return}
    self.present(todoVC, animated: true)
}

}
