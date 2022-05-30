//
//  ActionsViewController.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import UIKit
import RxSwift
import RxDataSources

class ActionsViewController: BaseViewController {
    typealias DataSource = RxCollectionViewSectionedAnimatedDataSource<Section>
    typealias Section = SingleAnimatableSectionModel<Item>
    typealias Item = ActionsViewModel.ItemModel
    
    //MARK: - Properties
    private var collectionView: BaseCollectionView!
    private var loadingView: UIView!
    private var moreLoadingView: UIView!
    private var feedbackButton: UIButton!
    
    var viewModel: ActionsViewModel!
    private lazy var dataSource = generateDataSource()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        subscribe()
        subscribeViewModel()
    }
}

//MARK: - Subscriptions
extension ActionsViewController {
    func subscribe() {
        collectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        collectionView.rx
            .modelSelected(Item.self)
            .bind(to: viewModel.itemSelectedTrigger)
            .disposed(by: bag)
                
        collectionView.rx
            .nearBottom(offset: 0)
            .bind(to: viewModel.loadMoreTrigger)
            .disposed(by: bag)
        
        feedbackButton.rx.tap
            .bind(to: viewModel.output.feedback)
            .disposed(by: bag)
    }
    
    func subscribeViewModel() {
        viewModel.items
            .asDriver()
            .map { [Section(items: $0)] }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: viewModel.bag)
        
        viewModel.isLoading
            .asDriver()
            .drive(with: self, onNext: { owner, isLoading in
                owner.showLoading(isLoading)
            })
            .disposed(by: viewModel.bag)

        viewModel.isMoreLoading
            .asDriver()
            .drive(with: self, onNext: { owner, isLoading in
                owner.collectionView.footerView = isLoading ? owner.moreLoadingView : nil
            })
            .disposed(by: viewModel.bag)
    }
}

//MARK: - Private
extension ActionsViewController {
    private func showLoading(_ isLoading: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = isLoading ? 1.0 : 0.0
        }
    }
}

//MARK: - DataSource
extension ActionsViewController {
    private func generateDataSource() -> DataSource {
        return DataSource(animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade),
                          configureCell: configureCell())
    }
    
    private func configureCell() -> DataSource.ConfigureCell {
        return { _, collectionView, indexPath, item in
            let cell: ActionsActionCell = collectionView.cell(indexPath: indexPath)
            cell.configure(with: item.action)
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ActionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = dataSource[indexPath]
        let cellWidth = collectionView.bounds.width
        return ActionsActionCell.cellSize(for: cellWidth, with: item.action)
    }
}

//MARK: - UI
extension ActionsViewController {
    private func makeUI() {
        view.backgroundColor = .color(named: .backgroundSecondary)
        title = "Акции"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        collectionView = makeCollectionView()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.bottom.right.equalToSuperview()
        }
        
        loadingView = LoadingView()
        loadingView.backgroundColor = .color(named: .backgroundSecondary)
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.bottom.right.equalToSuperview()
        }
        
        moreLoadingView = UIView()
        moreLoadingView.snp.makeConstraints {
            $0.height.equalTo(100)
        }
        
        let loadingLabel = UILabel()
        loadingLabel.text = "Секундочку, загружаем"
        loadingLabel.font = .appFont(style: .regular, size: 12)
        loadingLabel.textColor = .color(named: .textSecondary)
        moreLoadingView.addSubview(loadingLabel)
        loadingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }
        
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.startAnimating()
        moreLoadingView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.top.equalTo(loadingLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.footerView = moreLoadingView
        
        feedbackButton = UIButton()
        feedbackButton.setTitle(nil, for: .normal)
        feedbackButton.setImage(.image(named: .feedbackIcon), for: .normal)
        feedbackButton.backgroundColor = .color(named: .main)
        feedbackButton.roundCorners(with: 26)
        view.addSubview(feedbackButton)
        feedbackButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(42)
            $0.width.height.equalTo(52)
        }
    }
    
    private func makeCollectionView() -> BaseCollectionView {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        
        let collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cellType: ActionsActionCell.self)
        
        return collectionView
    }
}
