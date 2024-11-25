import Combine
import UIKit

import BaseFeature
import BaseFeatureInterface
import DesignSystem
import EasyLayoutModule
import LiveStreamFeatureInterface

public class BroadcastCollectionViewController: BaseViewController<BroadcastCollectionViewModel> {
    private enum Section: Int, Hashable {
        case large, small
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Channel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Channel>
    
    private let input = BroadcastCollectionViewModel.Input()
    private var cancellables = Set<AnyCancellable>()
    
    private let refreshControl = UIRefreshControl()
    private let rightBarButton: UIBarButtonItem = UIBarButtonItem()
    
    private let layout = setupCollectionViewCompositionalLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private var dataSource: DataSource?
    private var factory: LiveStreamViewControllerFactory?
    
    private let transitioning = CollectionViewCellTransitioning()
    
    var selectedThumbnailView: ThumbnailView? {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return nil }
        let cell = collectionView.cellForItem(at: indexPath)
        guard let thumbnailViewContainer = cell as? ThumbnailViewContainer else { return nil }
        return thumbnailViewContainer.thumbnailView
    }

    public init(
        viewModel: BroadcastCollectionViewModel,
        factory: (any LiveStreamViewControllerFactory)? = nil
    ) {
        self.factory = factory
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
        
        collectionView.delegate = self
        
        collectionView.register(LargeBroadcastCollectionViewCell.self, forCellWithReuseIdentifier: LargeBroadcastCollectionViewCell.identifier)
        collectionView.register(SmallBroadcastCollectionViewCell.self, forCellWithReuseIdentifier: SmallBroadcastCollectionViewCell.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        view.addSubview(collectionView)
    }
    
    public override func setupStyles() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        collectionView.backgroundColor = .black
        
        rightBarButton.style = .plain
        rightBarButton.tintColor = DesignSystemAsset.Color.mainGreen.color
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
        output.channels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] channels in
                self?.applySnapshot(with: channels)
            }
            .store(in: &cancellables)
        
        output.showBroadcastUIView
            .sink { [weak self] _ in
                self?.showBroadcastUIView()
            }
            .store(in: &cancellables)
        
        output.dismissBroadcastUIView
            .sink { [weak self] _ in
                self?.dismissBroadcastUIView()
            }
            .store(in: &cancellables)
    }
}

// MARK: - CollectionView Delegate
extension BroadcastCollectionViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = factory?.make() else { return }
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.transitioningDelegate = transitioning
        present(viewController, animated: true)
    }
}

// MARK: - CollectionView CompositionalLayout
extension BroadcastCollectionViewController {
    private static func setupCollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _  in
            let section = Section(rawValue: sectionIndex) ?? .small
            switch section {
            case .large:
                let size = NSCollectionLayoutSize(
                    widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                    heightDimension: NSCollectionLayoutDimension.estimated(200)
                )
                let item = NSCollectionLayoutItem(layoutSize: size)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 24, trailing: 0)
                section.interGroupSpacing = 24
                
                return section
            
            case .small:
                let size = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(100)
                )
                let item = NSCollectionLayoutItem(layoutSize: size)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 24, trailing: 0)
                section.interGroupSpacing = 24
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(10)
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

// MARK: - CollectionView Diffable DataSource
extension BroadcastCollectionViewController {
    private func setupDataSource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            
            switch section {
            case .large:
                guard let bigCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: LargeBroadcastCollectionViewCell.identifier,
                    for: indexPath
                ) as? LargeBroadcastCollectionViewCell else {
                    return UICollectionViewCell()
                }
                bigCell.configure(image: item.image, title: item.name)
                return bigCell
                
            case .small:
                guard let smallCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SmallBroadcastCollectionViewCell.identifier,
                    for: indexPath
                ) as? SmallBroadcastCollectionViewCell else {
                    return UICollectionViewCell()
                }
                smallCell.configure(image: item.image, title: item.name)
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
                label.font = .setFont(.title())
                label.textColor = .white
                label.text = "나머지 리스트"
                header.addSubview(label)
                label.ezl.makeConstraint {
                    $0.horizontal(to: header, padding: 16)
                        .vertical(to: header)
                }
            }
            
            return header
        }
    }
    
    private func applySnapshot(with channels: [Channel]) {
        var snapshot = Snapshot()
        
        let bigSectionItems = Array(channels.prefix(3))
        snapshot.appendSections([.large])
        snapshot.appendItems(bigSectionItems, toSection: .large)
        
        if channels.count > 3 {
            let smallSectionItems = Array(channels.suffix(from: 3))
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

// MARK: - CollectionView Methods
extension BroadcastCollectionViewController {
    @objc private func didTapRightBarButton() {
        let settingUIViewController = SettingUIViewController(viewModel: viewModel)
        let settingNavigationController = UINavigationController(rootViewController: settingUIViewController)
        navigationController?.present(settingNavigationController, animated: true)
    }
    
    private func showBroadcastUIView() {
        let broadcastViewController = BroadcastUIViewController(viewModel: viewModel)
        present(broadcastViewController, animated: false)
    }
    
    private func dismissBroadcastUIView() {
        input.fetch.send()
    }
}
