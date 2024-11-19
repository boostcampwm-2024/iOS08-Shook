import UIKit

import BaseFeature
import BaseFeatureInterface
import DesignSystem
import EasyLayoutModule

public class BroadcastCollectionViewModel: ViewModel {
    public init() { }
    public func transform(input: String) -> String { "" }
}

struct Item: Hashable {
    var image: UIImage?
    var title: String
    var subtitle1: String
    var subtitle2: String
}

public class BroadcastCollectionViewController: BaseViewController<BroadcastCollectionViewModel> {
    private enum Section: Int, Hashable {
        case big
        case small
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private let layout = setupCollectionViewCompositionalLayout()
    private let refreshControl = UIRefreshControl()
    
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
        setupBind()
    }
    
    public override func setupViews() {
        navigationItem.title = "실시간 리스트"
        view.addSubview(collectionView)
        collectionView.register(BigCollectionViewCell.self, forCellWithReuseIdentifier: BigCollectionViewCell.identifier)
        collectionView.register(SmallCollectionViewCell.self, forCellWithReuseIdentifier: SmallCollectionViewCell.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    }
    
    public override func setupLayouts() {
        collectionView.ezl.makeConstraint {
            $0.diagonal(to: view)
        }
    }
    
    public override func setupBind() { }
}

extension BroadcastCollectionViewController {
    private static func setupCollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _  in
            let section = Section(rawValue: sectionIndex) ?? .small
            switch section {
            case .big:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                section.interGroupSpacing = 8
                return section
                
            case .small:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                section.interGroupSpacing = 8
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(36)
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
                label.text = "어떤걸 해야하지?"
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
        
        let smallSectionItems = Array(items.suffix(from: 3))
        snapshot.appendSections([.small])
        snapshot.appendItems(smallSectionItems, toSection: .small)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
