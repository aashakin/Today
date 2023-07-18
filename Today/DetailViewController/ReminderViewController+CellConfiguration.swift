//
//  ReminderViewController+CellConfiguration.swift
//  Today
//
//  Created by Aleksandr on 18.07.2023.
//

import UIKit

extension ReminderViewController {
    func defaultConfiguration(for cell: UICollectionViewListCell, at row: Row) -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        return contentConfiguration
    }
    
    func headerConfiguration(for cell: UICollectionViewListCell, with title: String) -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = title
        return contentConfiguration
    }
    
    func titleConfiguration(for cell: UICollectionViewListCell, with title: String?) -> TextFieldContentView.Configuration {
        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.text = title
        contentConfiguration.onChange = { [weak self] title in
            self?.workingReminder.title = title
        }
        return contentConfiguration
    }
    
    func notesConfiguration(for cell: UICollectionViewListCell, with text: String?) -> TextViewContentView.Configuration {
        var contentConfiguration = cell.textViewConfiguration()
        contentConfiguration.text = text
        contentConfiguration.onChange = { [weak self] text in
            self?.workingReminder.notes = text
        }
        return contentConfiguration
    }
    
    func dateConfiguration(for cell: UICollectionViewListCell, with date: Date) -> DatePickerContentView.Configuration {
        var contentConfiguration = cell.dateConfiguration()
        contentConfiguration.date = date
        contentConfiguration.onChange = { [weak self] date in
            self?.workingReminder.dueDate = date
        }
        return contentConfiguration
    }
    
    private func text(for row: Row) -> String? {
        switch row {
        case .date: return reminder.dueDate.dayText
        case .notes: return reminder.notes
        case .time: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .title: return reminder.title
        default: return nil
        }
    }
}
