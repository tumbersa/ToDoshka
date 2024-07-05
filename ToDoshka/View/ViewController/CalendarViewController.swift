//
//  CalendarViewController.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 05.07.2024.
//

import UIKit
import Combine

final class CalendarViewController: UIViewController {
    
    private var viewModel: ToDoListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var dateArray: [String] = []
    private var todoItems: [String : [TodoItem]] = [:]
    
    private var prevSelectedIndexPath = IndexPath(row: 0, section: 0)
    private var viewIsDidAppear = false
    private var selectedIndexPath: IndexPath?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .backPrimary
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.reuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .backPrimary
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DateTableViewCell.self, forCellReuseIdentifier: DateTableViewCell.reuseId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func reloadContent() {
        updateData()
        
        collectionView.reloadData()
        tableView.reloadData()
        
    }
    
    init(viewModel: ToDoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateData()
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewIsDidAppear = true
        
        if dateArray.count > 0 {
            updateCollectionViewSelection()
        }
    }
    
    private func updateData() {
        var dates = viewModel.unicalDateArray()
        dates.append("Другое")
        print(dates)
        dateArray = dates
        
        
        for i in dateArray {
            if i == "Другое" {
                todoItems[i] = viewModel.todoItems.filter{$0.deadline == nil}
            } else {
                todoItems[i] = viewModel.todoItems.filter{
                    if let dateDeadline = $0.deadline {
                        return DateConverterHelper.dateFormatterShort.string(from: dateDeadline).split(separator: " ").joined(separator: "\n") == i
                    } else {
                        return false
                    }
                }
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.$todoItems
            .receive(on: RunLoop.main)
            .sink {[weak self] _ in
                self?.reloadContent()
                self?.updateCollectionViewSelection()
            }
            .store(in: &cancellables)
    }
    
    private func updateCollectionViewSelection() {
        if viewIsDidAppear {
            let visibleSections = tableView.indexPathsForVisibleRows?.map { $0.section } ?? []
            let topVisibleSection = visibleSections.min() ?? 0
            
            collectionView(collectionView, didSelectItemAt: IndexPath(row: topVisibleSection, section: 0))
            collectionView.scrollToItem(at: IndexPath(row: topVisibleSection, section: 0), at: .left, animated: true)
        }
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = dateArray.count
        print(count)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.reuseID, for: indexPath) as! DateCollectionViewCell
        cell.configure(text: dateArray[indexPath.row])
        cell.isUserInteractionEnabled = false
        
        if indexPath == selectedIndexPath {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                cell.selected()
            } else {
                cell.isSelected = false
                cell.deselected()
            }
        
        
        return cell
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell else { return }
        cell.selected()
        
        selectedIndexPath = indexPath
        
        if indexPath != prevSelectedIndexPath {
            self.collectionView(collectionView, didDeselectItemAt: prevSelectedIndexPath)
            prevSelectedIndexPath = indexPath
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell else { return }
        cell.deselected()
    }
}

extension CalendarViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dateArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems[dateArray[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.reuseId, for: indexPath)
        if let todoItem = todoItems[dateArray[indexPath.section]]?[indexPath.row] {
               let text = todoItem.text
               
            if todoItem.isFinished {
                let attributedString = NSAttributedString(string: text, attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ])
                
                cell.textLabel?.attributedText = attributedString
                cell.textLabel?.textColor = .lightGray
            } else {
                cell.textLabel?.text = text
            }
           }
        
        if (todoItems[dateArray[indexPath.section]]?.count ?? -1) - 1 == 0 {
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else if indexPath.row == 0 {
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 10
        } else if indexPath.row == (todoItems[dateArray[indexPath.section]]?.count ?? -1) - 1{
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 10
        }
        
        
        print(dateArray[indexPath.section])
        print(todoItems[dateArray[indexPath.section]]?[indexPath.row].text)
        return cell
    }
    
    
}

extension CalendarViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCollectionViewSelection()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        27
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 27))
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = dateArray[section].split(separator: "\n").joined(separator: " ")
        label.textColor = .secondaryLabel
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -7),
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {[weak self] _, _, completion in
            guard let self else { return }
            if let item = todoItems[dateArray[indexPath.section]]?[indexPath.row] {
                viewModel.markAsNotComplete(item: item)
            }
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "x.circle")?.withTintColor(.white)
        deleteAction.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let confirmAction = UIContextualAction(style: .normal, title: nil) {[weak self] _, _, completion in
            guard let self else { return }
            if let item = todoItems[dateArray[indexPath.section]]?[indexPath.row] {
                viewModel.markAsComplete(item: item)
            }
        }
        
        confirmAction.backgroundColor = .systemGreen
        confirmAction.image = .checkMarkSwipe
        
        let config = UISwipeActionsConfiguration(actions: [confirmAction])
        return config
    }
}
