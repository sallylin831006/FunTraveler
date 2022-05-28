//
//  SegmentControlView.swift
//  DI-Part-1---Delegate_Sally
//
//  Created by 林翊婷 on 2022/3/28.
//

import UIKit

protocol SegmentControlViewDataSource: AnyObject {
    func configureNumberOfButton(_ selectionView: SegmentControlView) -> Int
    
}

@objc protocol SegmentControlViewDelegate: AnyObject {
    
    @objc optional func didSelectedButton(_ selectionView: SegmentControlView, at index: Int)
}

class SegmentControlView: UIView {
    
    let indicatorView = UIView()
    
    weak var dataSource: SegmentControlViewDataSource?
    weak var delegate: SegmentControlViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .themeLightBlue?.withAlphaComponent(0.5)
        self.layer.borderColor = UIColor.themeApricotDeep?.cgColor
        self.layer.borderWidth = 4
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureButton()
    }
    
    func configureButton() {
        guard let numberOfButton =  dataSource?.configureNumberOfButton(self) else { return }
        
        for num in 0...numberOfButton - 1 {
            // SET BUTTON POSITION
            let dayButton = UIButton()
            
            let width = self.frame.width/CGFloat(numberOfButton)
            let height = self.frame.height
            
            dayButton.frame = CGRect(x: CGFloat(num)*(width), y: 0, width: width, height: height)
            
            dayButton.setTitle("Day \(num + 1)", for: .normal)
            dayButton.contentHorizontalAlignment = .center
            
            dayButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
            dayButton.tag = num
            
            dayButton.addTarget(self, action: #selector(tapDayButton(_:)), for: .touchUpInside)
            
            self.addSubview(dayButton)
            
            //             SET INDICATOR
            indicatorView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            indicatorView.backgroundColor = .themePink
            self.insertSubview(indicatorView, at: 0)
            
        }
        
    }
    
    @objc func tapDayButton(_ sender: UIButton) {
        guard let numberOfButton = dataSource?.configureNumberOfButton(self) else { return }
        
        let index = sender.tag + 1
        
        delegate?.didSelectedButton?(self, at: index)
        let width = self.frame.width/CGFloat(numberOfButton)
        let height = self.frame.height
        UIView.transition(with: self, duration: 0.5, options: [.curveLinear], animations: {
            self.indicatorView.frame = CGRect(x: sender.frame.minX, y: 0, width: width, height: height)
            
        })
    }
    
}
