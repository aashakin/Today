//
//  ReminderListViewController.swift
//  Today
//
//  Created by Aleksandr on 17.07.2023.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    private lazy var dataSource = makeDataSource()
    
    var reminders: [Reminder] = Reminder.sampleData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = listLayout()
        collectionView.dataSource = dataSource
        updateSnapshot()
    }

    func updateSnapshot(reloading ids: [Reminder.ID] = []) {
        var snapshot = makeSnapshot(for: reminders)
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        dataSource.apply(snapshot)
    }
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func makeDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        return DataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    private func makeSnapshot(for data: [Reminder]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(data.map { $0.id })
        return snapshot
    }
}

