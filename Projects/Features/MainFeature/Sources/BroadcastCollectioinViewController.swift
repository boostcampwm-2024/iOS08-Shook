import Combine
import UIKit

import BaseFeature
import BaseFeatureInterface
import DesignSystem
import EasyLayoutModule

public class BroadcastCollectionViewController: BaseViewController<BroadcastCollectionViewModel> {
    private enum Section: Int, Hashable {
        case big
        case small
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private let input = BroadcastCollectionViewModel.Input()
    private var cancellables = Set<AnyCancellable>()
    
    private let refreshControl = UIRefreshControl()
    private let rightBarButton: UIBarButtonItem = UIBarButtonItem()
    private let layout = setupCollectionViewCompositionalLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private var dataSource: DataSource?
    
    public override init(viewModel: BroadcastCollectionViewModel) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        input.fetch.send()
    }
    
    public override func setupViews() {
        rightBarButton.title = "방송하기"

        navigationItem.title = "실시간 리스트"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = rightBarButton
        
        collectionView.refreshControl = refreshControl
        
        collectionView.register(BigCollectionViewCell.self, forCellWithReuseIdentifier: BigCollectionViewCell.identifier)
        collectionView.register(SmallCollectionViewCell.self, forCellWithReuseIdentifier: SmallCollectionViewCell.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        view.addSubview(collectionView)
    }
    
    public override func setupStyles() {
        rightBarButton.style = .plain
    }
    
    public override func setupLayouts() {
        collectionView.ezl.makeConstraint {
            $0.diagonal(to: view)
        }
    }
    
    public override func setupActions() {
        refreshControl.addAction(UIAction { [weak self] _ in
            self?.input.fetch.send()
        }, for: .valueChanged)
        rightBarButton.target = self
        rightBarButton.action = #selector(didTapRightBarButton)
    }
    
    public override func setupBind() {
        let output = viewModel.transform(input: input)
        output.items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.applySnapshot(with: items)
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func didTapRightBarButton() {
        let settingUIViewController = SettingUIViewController(viewModel: viewModel)
        let settingNavigationController = UINavigationController(rootViewController: settingUIViewController)
        navigationController?.present(settingNavigationController, animated: true)
    }
}

extension BroadcastCollectionViewController {
    private static func setupCollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _  in
            let section = Section(rawValue: sectionIndex) ?? .small
            switch section {
            case .big:
                let size = NSCollectionLayoutSize(
                    widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                    heightDimension: NSCollectionLayoutDimension.estimated(250)
                )
                let item = NSCollectionLayoutItem(layoutSize: size)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16)
                section.interGroupSpacing = 8
                
                return section
            
            case .small:
                let size = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(103)
                )
                let item = NSCollectionLayoutItem(layoutSize: size)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                section.interGroupSpacing = 8
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(20)
                )
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                
                section.boundarySupplementaryItems = [header]
                return section
            }
        }
    }
}

extension BroadcastCollectionViewController {
    private func setupDataSource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            
            switch section {
            case .big:
                guard let bigCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BigCollectionViewCell.identifier,
                    for: indexPath
                ) as? BigCollectionViewCell else {
                    return UICollectionViewCell()
                }
                bigCell.configure(image: item.image, title: item.title, subtitle: item.subtitle1)
                return bigCell
                
            case .small:
                guard let smallCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SmallCollectionViewCell.identifier,
                    for: indexPath
                ) as? SmallCollectionViewCell else {
                    return UICollectionViewCell()
                }
                smallCell.configure(image: item.image, title: item.title, subtitle1: item.subtitle1, subtitle2: item.subtitle2)
                return smallCell
            }
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "Header",
                for: indexPath
            )
            
            if indexPath.section == 1 {
                let label = UILabel()
                label.font = .setFont(.body1())
                label.text = "나머지 리스트"
                header.addSubview(label)
                label.ezl.makeConstraint {
                    $0.diagonal(to: header)
                }
            }
            
            return header
        }
    }
    
    private func applySnapshot(with items: [Item]) {
        var snapshot = Snapshot()
        
        let bigSectionItems = Array(items.prefix(3))
        snapshot.appendSections([.big])
        snapshot.appendItems(bigSectionItems, toSection: .big)
        
        if items.count > 3 {
            let smallSectionItems = Array(items.suffix(from: 3))
            snapshot.appendSections([.small])
            snapshot.appendItems(smallSectionItems, toSection: .small)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true) { [weak self] in
            if self?.refreshControl.isRefreshing == true {
                self?.refreshControl.endRefreshing()
            }
        }
    }
}
