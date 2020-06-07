//
//  ExtendedNewsTableViewCell.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 01/11/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import UIKit

class ExtendedNewsTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let nibName = String(describing: ExtendedNewsTableViewCell.self)
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var newsResourceLabel: UILabel!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var newsDescriptionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var viewForTap: UIView!
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureSelf()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newsResourceLabel.text = ""
        newsTitleLabel.text = ""
        newsDescriptionLabel.text = ""
        dateLabel.text = ""
        newsImageView.image = nil
    }
}

// MARK: - Internal Functions

extension ExtendedNewsTableViewCell {
    
    func getViewForTap() -> UIView {
        return viewForTap
    }
    
    func setupWithModel(_ model: NewsModel) {
        
//        linkLabel.text = model.newsLink
        newsResourceLabel.text = getTextSeparatedBySpaceFromModel(model)
        
        newsTitleLabel.text = model.newsTitle
        newsDescriptionLabel.text = model.newsDescription
        newsResourceLabel.text = model.newsResource
        dateLabel.text = model.formattedDate
        
        print(newsDescriptionLabel.text!)
        
        // Using SDWebImage Pod
        if model.imageURL.isEmpty {
            newsImageView.image = SourceImages.emptyPhotoImage
            newsImageView.contentMode = .scaleAspectFit
        } else {
            newsImageView.sd_setImage(with: URL(string: model.imageURL), completed: nil)
        }
        
        if model.isViewed {
            backView.backgroundColor = SourceColors.commonLightGreyColor
            newsDescriptionLabel.backgroundColor = SourceColors.commonLightGreyColor
        } else {
            backView.backgroundColor = UIColor.white
            newsDescriptionLabel.backgroundColor = UIColor.white
        }
    }
}

// MARK: - Private Functions

private extension ExtendedNewsTableViewCell {
    
    func configureSelf() {
        
        configureLabels()
        configureView()
        configureImageView()
        configureViewForTap()
//        self.contentView.backgroundColor = UIColor.white
        self.contentView.backgroundColor = SourceColors.labelRedColor
    }
    
    func configureLabels() {
        
        newsResourceLabel.numberOfLines = 1
        
        newsTitleLabel.textColor = UIColor.white
        newsTitleLabel.numberOfLines = 3
        newsDescriptionLabel.numberOfLines = 0
        
        if let font = UIFont(name: "HelveticaNeue-Bold", size: 26), let text = newsTitleLabel.text {
            let  attributes = FontConfigurator.setAttributedTextWith(SourceColors.labelBorderColor, UIColor.white, -3.0, font)
            newsTitleLabel.attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        }
    }
    
    func configureView() {
        
        backView.layer.borderWidth = 1
        backView.layer.borderColor = SourceColors.commonDarkGreyColor.cgColor
        backView.layer.cornerRadius = 8
        backView.layer.masksToBounds = true
        
    }
    
    func configureImageView() {
        
        newsImageView.contentMode = .scaleAspectFill
    }
    
    func configureViewForTap() {
        
        viewForTap.layer.cornerRadius = viewForTap.bounds.height / 2
        viewForTap.layer.masksToBounds = true
        viewForTap.layer.borderColor = SourceColors.labelBorderColor.cgColor
        viewForTap.layer.borderWidth = 2
        viewForTap.backgroundColor = SourceColors.labelRedColor
    }
    
    func getTextSeparatedBySpaceFromModel(_ model: NewsModel) -> String {
        var separatedString = model.newsResource
        separatedString.getCharBeforeSpace()
        return separatedString
    }
}












