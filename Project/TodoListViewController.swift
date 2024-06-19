import UIKit

class TodoListViewController: UIViewController, UITableViewDelegate {
    
    var todos: [[String: Any]] = []
    
    let tableView = UITableView()
    let textField = UITextField()
    let addButton = UIButton(type: .system)
    let backButton = UIButton(type: .system)
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTitleLabel()
        setupTableView()
        setupInputFields()
        setupBackButton()
        
        loadTodos()
    }
    
    func setupTitleLabel() {
        titleLabel.text = "투두리스트"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
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
    
    @objc func addTodo() {
        guard let text = textField.text, !text.isEmpty else { return }
        
        let newTodo: [String: Any] = ["title": text, "date": Date(), "isCompleted": false]
        todos.append(newTodo)
        UserDefaults.standard.set(todos, forKey: "todos")
        
        textField.text = ""
        tableView.reloadData()
    }
    
    func loadTodos() {
        guard let todoDicts = UserDefaults.standard.array(forKey: "todos") as? [[String: Any]] else { return }
        todos = todoDicts
        tableView.reloadData()
    }
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let todo = todos[indexPath.row]
        
        if let title = todo["title"] as? String, let date = todo["date"] as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            cell.textLabel?.text = "\(title) - \(dateString)"
        }
        
        let completeButton = UIButton(type: .system)
        completeButton.setTitle("완료", for: .normal)
        completeButton.addTarget(self, action: #selector(completeTodo), for: .touchUpInside)
        completeButton.tag = indexPath.row
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            completeButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
            completeButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
        
        return cell
    }
    
    @objc func completeTodo(sender: UIButton) {
        let index = sender.tag
        todos.remove(at: index)
        UserDefaults.standard.set(todos, forKey: "todos")
        tableView.reloadData()
    }
}

