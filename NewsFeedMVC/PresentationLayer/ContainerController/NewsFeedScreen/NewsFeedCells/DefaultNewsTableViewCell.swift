//
//  DefaultNewsTableViewCell.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 03/11/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import UIKit
import SDWebImage

class DefaultNewsTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let nibName = String(describing: DefaultNewsTableViewCell.self)
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var newsResourceLabel: UILabel!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    
    @IBOutlet private weak var newsImageView: UIImageView!
    
    @IBOutlet private weak var backView: UIView!
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureSelf()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newsResourceLabel.text = ""
        newsTitleLabel.text = ""
        newsImageView.image = nil
    }
}

// MARK: - Internal Functions

extension DefaultNewsTableViewCell {
    
    func setupWithModel(_ model: NewsModel) {
        
        newsResourceLabel.text = getTextSeparatedBySpaceFromModel(model)
        newsTitleLabel.text = model.newsTitle
        
        // Using SDWebImage Pod
            if model.imageURL.isEmpty {
              newsImageView.image = SourceImages.emptyPhotoImage
            } else {
              newsImageView.sd_setImage(with: URL(string: model.imageURL), completed: nil)
        }
        
        if model.isViewed {
            backView.backgroundColor = SourceColors.commonLightGreyColor
        } else {
            backView.backgroundColor = UIColor.white
        }
    }
}

// MARK: - Private Functions

private extension DefaultNewsTableViewCell {
    
    func configureSelf() {
        
        backgroundColor = SourceColors.commonBackgroundColor
        contentView.frame = contentView.frame.insetBy(dx: 4, dy: 4)
        
        configureLabels()
        configureView()
    }
    
    func configureLabels() {
        
        newsResourceLabel.textColor = SourceColors.commonBackgroundColor
        
        newsTitleLabel.numberOfLines = 5
        newsTitleLabel.textColor = SourceColors.commonDarkGreyColor
    }
    
    func configureView() {
        
        backView.layer.borderWidth = 2
        backView.layer.borderColor = SourceColors.commonLightGreyColor.cgColor
        backView.layer.cornerRadius = 8
        backView.layer.masksToBounds = true
    }
    
    func getTextSeparatedBySpaceFromModel(_ model: NewsModel) -> String {
        
        var separatedString = model.newsResource
        separatedString.getCharBeforeSpace()
        return separatedString
    }
}
