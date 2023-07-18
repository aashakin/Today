//
//  ReminderViewController+DataSource.swift
//  Today
//
//  Created by Aleksandr on 17.07.2023.
//

import UIKit

extension ReminderViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        switch (section, row) {
        case (_, .header(let title)):
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = title
            cell.contentConfiguration = contentConfiguration
        case (.view, _):
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = text(for: row)
            contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
            contentConfiguration.image = row.image
            cell.contentConfiguration = contentConfiguration
        default:
            fatalError("Unexpected combination of section and row")
        }
        
        cell.tintColor = .todayPrimaryTint
    }
}
