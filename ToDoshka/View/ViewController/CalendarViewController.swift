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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .backPrimary
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.reuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func reloadContent() {
        updateDates()
        
        collectionView.reloadData()
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
        
        updateDates()
       
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func updateDates() {
        var dates = viewModel.unicalDateArray()
        dates.append("Другое")
        print(dates)
        dateArray = dates
    }
    
    private func bindViewModel() {
        viewModel.$todoItems
            .receive(on: RunLoop.main)
            .sink {[weak self] _ in
                self?.reloadContent()
            }
            .store(in: &cancellables)
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
        return cell
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
}
