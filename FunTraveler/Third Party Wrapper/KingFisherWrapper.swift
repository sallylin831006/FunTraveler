//
//  KingFisherWrapper.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/17.
//

import Foundation
import Kingfisher

extension UIImageView {

    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {

        guard urlString != nil else { return }
        
        let url = URL(string: urlString!)

        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}
