import UIKit

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var selectedDate = Date()
    var todos: [Todo] = []{
        didSet{
            tableView.reloadData()
        }
    }
   
    let datePicker = UIDatePicker()
    let tableView = UITableView()
    let textField = UITextField()
    let addButton = UIButton(type: .system)
    let backButton = UIButton(type: .system)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "캘린더"
       
        setupDatePicker()
        setupTableView()
        setupInputFields()
        setupBackButton()
    }
   
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
       
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
   
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
       
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
    }
   
    func setupInputFields() {
        textField.placeholder = "New Todo"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
       
        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(addTodo), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
       
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10),
            textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
           
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
        ])
    }

    func setupBackButton() {
        backButton.setTitle("뒤로가기", for: .normal)
        backButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
       
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }

    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
   
    @objc func dateChanged() {
        selectedDate = datePicker.date
        tableView.reloadData()
    }
   
    @objc func addTodo() {
        guard let text = textField.text, !text.isEmpty else { return }
        
        var todos = UserDefaults.standard.array(forKey: "todos") as? [[String: Any]] ?? []
        let newTodo: [String:Any] = ["title":text, "date":selectedDate]
        //let newTodo = Todo(title: text, date: selectedDate)
        todos.append(newTodo)
        UserDefaults.standard.set(todos, forKey: "todos")
        
        textField.text = ""
        //tableView.reloadData()
        print("할 일 추가됨:",newTodo)
    }
   
    // MARK: - UITableViewDataSource
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return todos.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }.count
        return todos.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //let filteredTodos = todos.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
       // cell.textLabel?.text = filteredTodos[indexPath.row].title
        cell.textLabel?.text = todos[indexPath.row].title
        return cell
    }
}
