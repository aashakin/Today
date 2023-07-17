//
//  ReminderListViewController.swift
//  Today
//
//  Created by Aleksandr on 17.07.2023.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    typealias ReminderCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>

    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = listLayout()
        collectionView.dataSource = dataSource
        let initialSnapshot = makeSnapshot(from: Reminder.sampleData)
        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func reminderCellRegistration() -> ReminderCellRegistration {
        UICollectionView.CellRegistration {
            (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
            let reminder = Reminder.sampleData[indexPath.item]
            
            // Cell Content Configuration
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = reminder.title
            contentConfiguration.textProperties.color = .darkGray
            cell.contentConfiguration = contentConfiguration
            
            // Cell Background Configuration
            var backgroundConfiguration = cell.defaultBackgroundConfiguration()
            backgroundConfiguration.cornerRadius = 8
            cell.backgroundConfiguration = backgroundConfiguration
        }
    }
    
    private func makeDataSource() -> DataSource {
        let cellRegistration = reminderCellRegistration()
        return DataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    private func makeSnapshot(from data: [Reminder]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(data.map { $0.title })
        return snapshot
    }
}

