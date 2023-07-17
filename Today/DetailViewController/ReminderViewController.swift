//
//  ReminderViewController.swift
//  Today
//
//  Created by Aleksandr on 17.07.2023.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    
    var reminder: Reminder
    
    private lazy var dataSource = makeDataSource()
    
    init(reminder: Reminder) {
        self.reminder = reminder
        
        func makeLayout() -> UICollectionViewCompositionalLayout {
            var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            listConfiguration.showsSeparators = false
            return UICollectionViewCompositionalLayout.list(using: listConfiguration)
        }
        
        super.init(collectionViewLayout: makeLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = dataSource
        updateSnapshot()
    }
    
    func text(for row: Row) -> String? {
        switch row {
        case .date: return reminder.dueDate.dayText
        case .notes: return reminder.notes
        case .time: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .title: return reminder.title
        }
    }
    
    private func makeDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        return DataSource(collectionView: collectionView) { collectionView, indexPath, row in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: row)
        }
    }
    
    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems([.title, .date, .time, .notes], toSection: 0)
        return snapshot
    }
    
    private func updateSnapshot() {
        let snapshot = makeSnapshot()
        dataSource.apply(snapshot)
    }
}
