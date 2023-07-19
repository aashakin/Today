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
    var progress: CGFloat {
        let chunkSize = 1.0 / CGFloat(filteredReminders.count)
        return filteredReminders.reduce(0.0) {
            let chunk = $1.isComplete ? chunkSize : 0
            return $0 + chunk
        }
    }
    
    var headerView: ProgressHeaderView?
    
    private let filterControl = UISegmentedControl(items: [
        ReminderFilter.today.name,
        ReminderFilter.future.name,
        ReminderFilter.all.name
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupFilter()
        setupProgressView()
        setupCollectionView()
        updateSnapshot()
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = filteredReminders[indexPath.item].id
        pushDetailViewForReminder(withId: id)
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard elementKind == ProgressHeaderView.elementKind,
              let progressView = view as? ProgressHeaderView
        else {
            return
        }
        progressView.progress = progress
    }
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout = makeLayout()
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = .todayGradientTodayBegin
    }
    
    private func setupFilter() {
        filterControl.selectedSegmentIndex = filter.rawValue
        filterControl.addTarget(self, action: #selector(didChangeFilter(_:)), for: .valueChanged)
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.headerMode = .supplementary
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
    
    private func setupProgressView() {
        let headerRegistration = UICollectionView.SupplementaryRegistration(
            elementKind: ProgressHeaderView.elementKind,
            handler: supplementaryRegistrationHandler
        )
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
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
    
    private func supplementaryRegistrationHandler(progressView: ProgressHeaderView,
                                                  elementKind: String,
                                                  indexPath: IndexPath) {
        headerView = progressView
    }
}

