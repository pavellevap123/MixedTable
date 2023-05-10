//
//  ViewController.swift
//  MixedTable
//
//  Created by Pavel Paddubotski on 10.05.23.
//

import UIKit

class CellModel {
    let title: String
    var isCheckmarked : Bool
    
    init(title: String, isCheckmarked: Bool) {
        self.title = title
        self.isCheckmarked = isCheckmarked
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var cellsData = [CellModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    
        navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleTapped))
        navigationItem.title = "Task 4"
        
        populateCells()
    }
    
    private func populateCells() {
        for i in 1...30 {
            cellsData.append(CellModel(title: String(i), isCheckmarked: false))
        }
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as! Cell
        cell.textLabel?.text = cellsData[indexPath.row].title
        if cellsData[indexPath.row].isCheckmarked {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if cellsData[indexPath.row].isCheckmarked || indexPath.row == 0 {
            cellsData[indexPath.row].isCheckmarked.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        else {
            cellsData[indexPath.row].isCheckmarked.toggle()
            tableView.reloadRows(at: [indexPath], with: .top)
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            cellsData = rearrange(array: cellsData, fromIndex: indexPath.row, toIndex: 0)
        }
    }
    
    
    
    @objc private func shuffleTapped(_ sender: UIBarButtonItem) {
        let shuffledPositionsArray = cellsData.map { Int($0.title)! - 1 }.shuffled()
        
        tableView.beginUpdates()
        for (i, _) in cellsData.enumerated() {
            tableView.moveRow(at: IndexPath(row: i, section: 0), to: IndexPath(row: shuffledPositionsArray[i], section: 0))
            cellsData = rearrange(array: cellsData, fromIndex: i, toIndex: shuffledPositionsArray[i])
        }
        tableView.endUpdates()
        tableView.reloadData()
    }
    
    private func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T>{
        var arr = array
        let element = arr.remove(at: fromIndex)
        arr.insert(element, at: toIndex)

        return arr
    }
}

class Cell: UITableViewCell {
    static let identifier = String(describing: Cell.self)
    
    override func prepareForReuse() {
        textLabel?.text = ""
        accessoryType = .none
    }
}

