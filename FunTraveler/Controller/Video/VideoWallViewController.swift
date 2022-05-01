//
//  VideoWallViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/18.
//

import UIKit
import AVKit

class VideoWallViewController: UIViewController {
    
    private var videoDataSource: [Video] = []
    
    let containerView: UIView = {
        let view = UIView()
        return view }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        
        collectionView.register(UINib(nibName: String(
            describing: VideoWallHeaderView.self), bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "Header")
        
        setupSearchBar()
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    private func setupSearchBar() {
        
        searchController.searchBar.placeholder = "搜尋..."
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.barTintColor = .themeRed
        searchController.searchBar.tintColor = .themeRed

        searchController.searchBar.searchTextField.backgroundColor = .themeApricotDeep
     
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .themeRed
        textFieldInsideSearchBar?.attributedPlaceholder = NSAttributedString(string: textFieldInsideSearchBar?.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .themeApricotDeep
        showLoadingView()
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.playFirstVisibleVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.playFirstVisibleVideo(false)
    }
    
    func setUpUI() {
        self.view.backgroundColor = .white
        setupContainerView()
        setupCollectionView()
        
    }
    private func showLoadingView() {
        let loadingView = LoadingView()
        view.layoutLoadingView(loadingView, view)
    }
    
}

extension VideoWallViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind
                        kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
                as? VideoWallHeaderView else { return UICollectionReusableView() }
        
        headerView.layoutHeaderView(data: videoDataSource, section: indexPath.section)

        return headerView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return videoDataSource.count
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath)
                as? VideoCollectionViewCell else {  return UICollectionViewCell() }
        
        cell.configure(videoDataSource[indexPath.section].url)
        
        cell.layoutCell(data: videoDataSource[indexPath.section], index: indexPath.section)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.headerReferenceSize = CGSize(width: 0, height: 60)
        
        return CGSize(width: collectionView.frame.width, height: 600)
    }
    
}

extension VideoWallViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        playFirstVisibleVideo()
    }
    
}

extension VideoWallViewController {
    
    func playFirstVisibleVideo(_ shouldPlay: Bool = true) {
        // 1.
        let cells = collectionView.visibleCells.sorted {
            collectionView.indexPath(for: $0)?.item ?? 0 < collectionView.indexPath(for: $1)?.item ?? 0
        }
        // 2.
        let videoCells = cells.compactMap({ $0 as? VideoCollectionViewCell })
        if videoCells.count > 0 {
            // 3.
            let firstVisibileCell = videoCells.first(where: { checkVideoFrameVisibility(ofCell: $0) })
            // 4.
            for videoCell in videoCells {
                if shouldPlay && firstVisibileCell == videoCell {
                    videoCell.play()
                } else {
                    videoCell.pause()
                }
            }
        }
    }
    
    func checkVideoFrameVisibility(ofCell cell: VideoCollectionViewCell) -> Bool {
        var cellRect = cell.containerView.bounds
        cellRect = cell.containerView.convert(cell.containerView.bounds, to: collectionView.superview)
        return collectionView.frame.contains(cellRect)
    }
    
}

extension VideoWallViewController {
    // MARK: - GET Videos
    private func fetchData() {
        let videoProvider = VideoProvider()
        videoProvider.fetchVideo(completion: { [weak self] result in
            
            switch result {
                
            case .success(let videoData):
                self?.videoDataSource = videoData
                self?.collectionView.reloadData()
                
            case .failure:
                print("[CameraVC] GET video失敗！")
            }
        })
    }
}

extension VideoWallViewController {
    func setupContainerView() {
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        
    }
    
    func setupCollectionView() {
        containerView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive  = true
    }
    
}

extension VideoWallViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("TextDidEndEditing")
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("SearchButtonClicked")

        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange")
//        postToSearchTrip(searchText: searchText)
//        if searchText.isEmpty {
//            fetchData()
//        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("點了取消按鈕")
//        fetchData()
    }
}
