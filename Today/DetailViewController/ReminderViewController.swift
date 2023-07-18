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
            listConfiguration.headerMode = .firstItemInSection
            return UICollectionViewCompositionalLayout.list(using: listConfiguration)
        }
        
        super.init(collectionViewLayout: makeLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        collectionView.dataSource = dataSource
        updateSnapshotForViewing()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            updateSnapshotForEditing()
        } else {
            updateSnapshotForViewing()
        }
    }
    
    private func makeDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        return DataSource(collectionView: collectionView) { collectionView, indexPath, row in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: row)
        }
    }
    
    private func updateSnapshotForViewing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.view])
        snapshot.appendItems([.header(""), .title, .date, .time, .notes], toSection: .view)
        dataSource.apply(snapshot)
    }
    
    private func updateSnapshotForEditing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.title, .date, .notes])
        snapshot.appendItems([
            .header(Section.title.name),
            .editableText(reminder.title)
        ], toSection: .title)
        snapshot.appendItems([
            .header(Section.date.name),
            .editableDate(reminder.dueDate)
        ], toSection: .date)
        snapshot.appendItems([
            .header(Section.notes.name),
            .editableText(reminder.notes)
        ], toSection: .notes)
        dataSource.apply(snapshot)
    }
    
    func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section")
        }
        return section
    }
    
    private func setupNavigationBar() {
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
        navigationItem.rightBarButtonItem = editButtonItem
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
    }
}
