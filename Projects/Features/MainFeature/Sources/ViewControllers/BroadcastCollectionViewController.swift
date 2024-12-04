import Combine
import UIKit

import BaseFeature
import BaseFeatureInterface
import DesignSystem
import EasyLayout
import LiveStreamFeatureInterface
import MainFeatureInterface

public class BroadcastCollectionViewController: BaseViewController<BroadcastCollectionViewModel> {
    private enum Section: Int, Hashable {
        case empty, large, small
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Channel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Channel>
    
    private let input = BroadcastCollectionViewModel.Input()
    private var cancellables = Set<AnyCancellable>()
    
    private let refreshControl = SHRefreshControl()
    private let rightBarButton: UIBarButtonItem = UIBarButtonItem()
    
    private let layout = setupCollectionViewCompositionalLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private var dataSource: DataSource?
    private var factory: LiveStreamViewControllerFactory?
    private var settingFactory: SettingViewControllerFactory?
    private var broadcastFactory: BroadcastViewControllerFactory?
    
    private let transitioning = CollectionViewCellTransitioning()
    
    private let dataLoadView = BroadcastCollectionLoadView()
    
    var selectedThumbnailView: ThumbnailView? {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return nil }
        let cell = collectionView.cellForItem(at: indexPath)
        guard let thumbnailViewContainer = cell as? ThumbnailViewContainer else { return nil }
        return thumbnailViewContainer.thumbnailView
    }

    public init(
        viewModel: BroadcastCollectionViewModel,
        factory: (any LiveStreamViewControllerFactory)? = nil,
        settingFactory: (any SettingViewControllerFactory)? = nil,
        broadcastFactory: (any BroadcastViewControllerFactory)? = nil
    ) {
        self.factory = factory
        self.settingFactory = settingFactory
        self.broadcastFactory = broadcastFactory
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        input.fetch.send()
        registerObserver()
    }
    
    public override func setupViews() {
        rightBarButton.title = "방송하기"

        navigationItem.title = "실시간 리스트"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = rightBarButton
        
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.register(EmptyBroadcastCollectionViewCell.self, forCellWithReuseIdentifier: EmptyBroadcastCollectionViewCell.identifier)
        collectionView.register(LargeBroadcastCollectionViewCell.self, forCellWithReuseIdentifier: LargeBroadcastCollectionViewCell.identifier)
        collectionView.register(SmallBroadcastCollectionViewCell.self, forCellWithReuseIdentifier: SmallBroadcastCollectionViewCell.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
                        
        view.addSubview(collectionView)
        view.addSubview(dataLoadView)
    }
    
    public override func setupStyles() {
        rightBarButton.tintColor = DesignSystemAsset.Color.mainGreen.color
    }
    
    public override func setupLayouts() {
        collectionView.ezl.makeConstraint {
            $0.diagonal(to: view)
        }
        
        dataLoadView.ezl.makeConstraint {
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
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(forName: NotificationName.startStreaming, object: nil, queue: nil) { [weak self] _ in
            self?.showBroadcastUIView()
        }
        NotificationCenter.default.addObserver(forName: NotificationName.finishStreaming, object: nil, queue: nil) { [weak self] _ in
            self?.dismissBroadcastView()
        }
    }
}

// MARK: - CollectionView Delegate
extension BroadcastCollectionViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let channel = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let viewController = factory?.make(channelID: channel.id, title: channel.name, owner: channel.owner, description: channel.description) else { return }

        /// 히어로 애니메이션 전환 적용
        viewController.modalPresentationStyle = .overFullScreen
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
            case .empty:
                let size = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.8)
                )
                let item = NSCollectionLayoutItem(layoutSize: size)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
                
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
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, channel in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            
            switch section {
            case .empty:
                guard let emptyCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: EmptyBroadcastCollectionViewCell.identifier,
                    for: indexPath
                ) as? EmptyBroadcastCollectionViewCell else {
                    return UICollectionViewCell()
                }
                return emptyCell
                
            case .large:
                guard let largeCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: LargeBroadcastCollectionViewCell.identifier,
                    for: indexPath
                ) as? LargeBroadcastCollectionViewCell else {
                    return UICollectionViewCell()
                }
                largeCell.configure(channel: channel)
                return largeCell
                
            case .small:
                guard let smallCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SmallBroadcastCollectionViewCell.identifier,
                    for: indexPath
                ) as? SmallBroadcastCollectionViewCell else {
                    return UICollectionViewCell()
                }
                smallCell.configure(channel: channel)
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
        dataLoadView.isHidden = true
        
        var snapshot = Snapshot()
        snapshot.appendSections([.empty, .large])

        if channels.isEmpty {
            snapshot.appendItems([Channel(id: "Empty", title: "Empty")], toSection: .empty)
        } else {
            let largeSectionItems = Array(channels.prefix(3))
            snapshot.appendItems(largeSectionItems, toSection: .large)

            if channels.count > 3 {
                let smallSectionItems = Array(channels.suffix(from: 3))
                snapshot.appendSections([.small])
                snapshot.appendItems(smallSectionItems, toSection: .small)
            }
        }
        
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
}

// MARK: - CollectionView Methods
extension BroadcastCollectionViewController {
    @objc private func didTapRightBarButton() {
        guard let settingUIViewController = settingFactory?.make() else { return }
        let settingNavigationController = UINavigationController(rootViewController: settingUIViewController)
        navigationController?.present(settingNavigationController, animated: true)
    }
    
    private func showBroadcastUIView() {
        guard let broadcastViewController = broadcastFactory?.make() else { return }
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.addChild(broadcastViewController)
        self.view.addSubview(broadcastViewController.view)
        broadcastViewController.view.frame = self.view.bounds
        broadcastViewController.didMove(toParent: self)
    }
    
    private func dismissBroadcastView() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let broadcastViewController = children.first(where: { $0 is BroadcastViewController }) else { return }
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                broadcastViewController.view.alpha = 0 }, completion: { _ in
                    broadcastViewController.willMove(toParent: nil)
                    broadcastViewController.view.removeFromSuperview()
                    broadcastViewController.removeFromParent()
                }
            )
            navigationController?.setNavigationBarHidden(false, animated: false)
            input.fetch.send()
        }
    }
}
