//
//  VideoWallViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/18.
//

import UIKit
import AVKit

class VideoWallViewController: UIViewController {
    
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.footerReferenceSize = .zero
        layout.headerReferenceSize = .zero
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setUpDataSource()
        containerView.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        collectionView.registerCellWithNib(identifier: String(describing: HeaderView.self), bundle: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .themeApricotDeep
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
    
    var videoDataSource: [String] = []
    
    func setUpDataSource() {
        videoDataSource = [
            "https://travel-schedule-images.s3.ap-northeast-1.amazonaws.com/6B6A5E7E-127B-4DED-805B-7F3DCE5512BF.MOV",
            "https://travel-schedule-images.s3.ap-northeast-1.amazonaws.com/6B6A5E7E-127B-4DED-805B-7F3DCE5512BF.MOV",
            "https://travel-schedule-images.s3.ap-northeast-1.amazonaws.com/6B6A5E7E-127B-4DED-805B-7F3DCE5512BF.MOV",
            "https://travel-schedule-images.s3.ap-northeast-1.amazonaws.com/6B6A5E7E-127B-4DED-805B-7F3DCE5512BF.MOV",
            "https://travel-schedule-images.s3.ap-northeast-1.amazonaws.com/6B6A5E7E-127B-4DED-805B-7F3DCE5512BF.MOV",
            "https://travel-schedule-images.s3.ap-northeast-1.amazonaws.com/6B6A5E7E-127B-4DED-805B-7F3DCE5512BF.MOV",
            "https://travel-schedule-images.s3.ap-northeast-1.amazonaws.com/6B6A5E7E-127B-4DED-805B-7F3DCE5512BF.MOV",
            "https://travel-schedule-images.s3.ap-northeast-1.amazonaws.com/6B6A5E7E-127B-4DED-805B-7F3DCE5512BF.MOV"
        ]
        
        collectionView.reloadData()
    }
    
}

extension VideoWallViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath) as? VideoCollectionViewCell else {  return UICollectionViewCell() }
        cell.configure(videoDataSource[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 500)
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
