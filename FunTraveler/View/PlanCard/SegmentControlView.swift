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
    
    @objc optional func shouldSelectedButton(_ selectionView: SegmentControlView, at index: Int) -> Bool
}

class SegmentControlView: UIView {
    
    let indicatorView = UIView()
    let button = UIButton()
    
    weak var dataSource: SegmentControlViewDataSource?
    weak var delegate: SegmentControlViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .themeApricot
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureButton()
    }
    
    func configureButton() {
        guard let numberOfButton = dataSource?.configureNumberOfButton(self) else { return }
//        if numberOfButton < 1 {
//            print("numberOfButton數量有誤！")
//            return
//        }
        for num in 0...numberOfButton - 1 {
            // SET BUTTON POSITION
            let dayButton = UIButton()
            
            let width = UIScreen.main.bounds.width/CGFloat(numberOfButton) * 5/6
            dayButton.frame = CGRect(x: CGFloat(num)*(width), y: 0, width: width, height: 20)
            
            dayButton.backgroundColor = .clear
            dayButton.setTitle("Day \(num + 1)", for: .normal)
            // SET BUTTON TITLE
            
//            guard let buttonTitle = dataSource?.configureDetailOfButton(self) else { return }
//            var title = "1"
//            if buttonTitle.isEmpty {
//                title = "DAY1"
//            } else {
//                title = buttonTitle[num].title
//            }
//            dayButton.setTitle("\(title)", for: .normal)
//            dayButton.setTitle("按鈕", for: .normal)

            // SET BUTTON TITLE COLOR & FONT
            let colorOfText = UIColor.themeRed

            dayButton.setTitleColor(colorOfText, for: .normal)
            
            dayButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
            dayButton.tag = num
            
            dayButton.addTarget(self, action: #selector(tapDayButton), for: .touchUpInside)
            
            self.addSubview(dayButton)
            
            // SET INDICATOR
            indicatorView.frame = CGRect(x: 0, y: 25, width: width, height: 5)

            let colorOfindicator = UIColor.themeRed
            
            indicatorView.backgroundColor = colorOfindicator
            
            self.addSubview(indicatorView)
            
        }
        
    }
    
    @objc func tapDayButton(sender: UIButton) {
        
        guard let numberOfButton = dataSource?.configureNumberOfButton(self) else { return }

        let width = UIScreen.main.bounds.width/CGFloat(numberOfButton)
        let index = sender.tag + 1
        
        if delegate?.shouldSelectedButton?(self, at: index) == false {
            return
        }
        delegate?.didSelectedButton?(self, at: index)
        
        UIView.transition(with: self, duration: 0.3, options: [.curveEaseOut], animations: {
            self.indicatorView.frame = CGRect(x: sender.frame.minX, y: 25, width: width * 5/6, height: 5)

        })
    }
   
}
