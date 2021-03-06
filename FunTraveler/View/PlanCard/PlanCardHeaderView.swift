//
//  PlanCardHeaderView.swift
//  PlanningCardTest
//
//  Created by 林翊婷 on 2022/4/9.
//

import UIKit

protocol PlanCardHeaderViewDelegate: AnyObject {
    
    func switchDayButton(index: Int)
    
    func tapToInviteFriends(_ button: UIButton)
    
    func passingSelectedDepartmentTime(_ headerView: PlanCardHeaderView, _ selectedDepartmentTime: String)
}

class PlanCardHeaderView: UITableViewHeaderFooterView {
    weak var delegate: PlanCardHeaderViewDelegate?
    
    @IBOutlet weak private var titleLabel: UILabel!
    
    @IBOutlet weak private var dateLabel: UILabel!
    
    @IBOutlet weak private var ownerImageView: UIImageView!
    
    @IBOutlet weak private var departmentPickerView: TimePickerView!
    
    @IBOutlet weak private var selectionView: SegmentControlView!
    
    @IBOutlet weak private var collectionView: UICollectionView!
    
    @IBOutlet weak private var inviteButton: UIButton!
    
    var selectedDepartmentTimesClosure: ((_ selectedDepartmentTimes: String) -> Void)?
    private var tripData: Trip?
    
    private var departmentTimes = PickerConstant.departmentTimes
    
    private var firstTime: String?
    private var selectedDepartmentTimes: String?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundConfiguration = nil
        ownerImageView.layer.cornerRadius = ownerImageView.frame.width/2
        ownerImageView.contentMode = .scaleAspectFill
        ownerImageView.layer.borderWidth = 2
        ownerImageView.layer.borderColor = UIColor.themeApricot?.cgColor
        contentView.backgroundColor = UIColor.themeLightBlue
        contentView.layer.cornerRadius = 12
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func layoutHeaderView(data: Trip) {
        collectionView.registerCellWithNib(identifier: String(
            describing: FriendsCollectionViewCell.self), bundle: nil)
        
        self.firstTime = data.schedules?.first?.first?.startTime
        if data.user.imageUrl == "" {
            ownerImageView.image = UIImage.asset(.defaultUserImage)
        } else {
            ownerImageView.loadImage(data.user.imageUrl, placeHolder: UIImage.asset(.imagePlaceholder))
        }
        
        titleLabel.text = data.title
        
        guard let startDate = data.startDate,
              let endtDate = data.endDate else { return }
        dateLabel.text = "\(startDate) - \(endtDate)"
        self.tripData = data
        
        departmentPickerView.picker.delegate = self
        departmentPickerView.picker.dataSource = self
        departmentPickerView.delegate = self
        
        departmentPickerView.timeTextField.text = data.schedules?.first?.first?.startTime
        
        selectionView.delegate = self
        selectionView.dataSource = self
        
        inviteButton.addTarget(target, action: #selector(tapToInvite(_:)), for: .touchUpInside)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc func tapToInvite(_ sender: UIButton) {
        delegate?.tapToInviteFriends(sender)
    }
    
    func reloadCollectionView() {
        self.collectionView.reloadData()
    }
}

// MARK: - TimePicker in HeaderView
extension PlanCardHeaderView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return departmentTimes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(departmentTimes[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedDepartmentTimes = departmentTimes[row]
    }
}

extension PlanCardHeaderView: TimePickerViewDelegate {
    func donePickerViewAction() {
        delegate?.passingSelectedDepartmentTime(self, selectedDepartmentTimes ?? "9:00")
    }
}

extension PlanCardHeaderView: SegmentControlViewDataSource {
    
    func configureNumberOfButton(_ selectionView: SegmentControlView) -> Int {
        tripData?.days ?? 1
    }
}

@objc extension PlanCardHeaderView: SegmentControlViewDelegate {
    func didSelectedButton(_ selectionView: SegmentControlView, at index: Int) {
        delegate?.switchDayButton(index: index)
    }
}

extension PlanCardHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tripData?.editors.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: FriendsCollectionViewCell.self),
            for: indexPath) as? FriendsCollectionViewCell else { return UICollectionViewCell() }
        guard let editors = tripData?.editors else { return UICollectionViewCell() }
        cell.layoutCell(data: editors, index: indexPath.row)
        
        return cell
    }
}

extension PlanCardHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(5)
    }
}
