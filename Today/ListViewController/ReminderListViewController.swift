//
//  ReminderListViewController.swift
//  Today
//
//  Created by Aleksandr on 17.07.2023.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    lazy var dataSource = makeDataSource()
    
    var reminders: [Reminder] = Reminder.sampleData
    var filter: ReminderFilter = .today
    var filteredReminders: [Reminder] {
        return reminders.filter { filter.shouldInclude(date: $0.dueDate)}.sorted {
            $0.dueDate < $1.dueDate
        }
    }
    
    private let filterControl = UISegmentedControl(items: [
        ReminderFilter.today.name,
        ReminderFilter.future.name,
        ReminderFilter.all.name
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupFilter()
        setupCollectionView()
        updateSnapshot()
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = filteredReminders[indexPath.item].id
        pushDetailViewForReminder(withId: id)
        return false
    }
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout = makeLayout()
        collectionView.dataSource = dataSource
    }
    
    private func setupFilter() {
        filterControl.selectedSegmentIndex = filter.rawValue
        filterControl.addTarget(self, action: #selector(didChangeFilter(_:)), for: .valueChanged)
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions(for:)
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = filterControl
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(didPressAddButton(_:)))
        addButton.accessibilityLabel = NSLocalizedString("Add reminder", comment: "Add button accessibility label")
        navigationItem.rightBarButtonItem = addButton
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
    }
    
    private func makeDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        return DataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    private func pushDetailViewForReminder(withId id: Reminder.ID) {
        let reminder = reminder(withId: id)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.updateReminder(reminder)
            self?.updateSnapshot(reloading: [reminder.id])
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath,
              let id = dataSource.itemIdentifier(for: indexPath)
        else {
            return nil
        }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] _, _, completion in
            self?.deleteReminder(withId: id)
            self?.updateSnapshot()
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

