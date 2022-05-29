//
//  PlanPickerViewController+Extension.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/13.
//

import UIKit

// MARK: - Long press
extension PlanPickerViewController {
    
    @objc func longPress(_ recognizer: UIGestureRecognizer) {
        guard let longPress = recognizer as? UILongPressGestureRecognizer else { return }
        let state = longPress.state
        let locationInView = longPress.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)
        struct Cell {
            static var cellSnapshot: UIView?
            static var cellIsAnimating: Bool = false
            static var cellNeedToShow: Bool = false
        }
        struct Path {
            static var initialIndexPath: IndexPath?
        }
        switch state {
        case UIGestureRecognizer.State.began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                guard let cell = tableView.cellForRow(at: indexPath!) as? PlanCardTableViewCell else { return }
                Cell.cellSnapshot  = snapshotOfCell(cell)
                var center = cell.center
                guard let cellSnapshot = Cell.cellSnapshot else { return }
                
                cellSnapshot.center = center
                cellSnapshot.alpha = 0.0
                tableView.addSubview(Cell.cellSnapshot!)
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    Cell.cellIsAnimating = true
                    cellSnapshot.center = center
                    cellSnapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    cellSnapshot.alpha = 0.98
                    cell.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        
                        Cell.cellIsAnimating = false
                        if Cell.cellNeedToShow {
                            Cell.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                cell.alpha = 1
                            })
                        } else {
                            cell.isHidden = true
                        }
                    }
                })
            }
            
        case UIGestureRecognizer.State.changed:
            guard let cellSnapshot = Cell.cellSnapshot else { return }
            
            if Cell.cellSnapshot != nil {
                var center = Cell.cellSnapshot!.center
                center.y = locationInView.y
                cellSnapshot.center = center
                if (indexPath != nil) && (indexPath != Path.initialIndexPath) {
                    schedule.insert(schedule.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
                    tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                    Path.initialIndexPath = indexPath
                    self.postData(days: self.currentDay, isFinished: false)
                }
                
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = tableView.cellForRow(at: Path.initialIndexPath!) as UITableViewCell?
                if Cell.cellIsAnimating {
                    Cell.cellNeedToShow = true
                } else {
                    cell?.isHidden = false
                    cell?.alpha = 0.0
                }
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    guard let cellSnapshot = Cell.cellSnapshot else { return }
                    cellSnapshot.center = (cell?.center)!
                    cellSnapshot.transform = CGAffineTransform.identity
                    cellSnapshot.alpha = 0.0
                    cell?.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        guard let cellSnapshot = Cell.cellSnapshot else { return }
                        Path.initialIndexPath = nil
                        cellSnapshot.removeFromSuperview()
                        Cell.cellSnapshot = nil
                    }
                })
            }
        }
        
    }
    
    func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot: UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
}
