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
    @IBOutlet private weak var newsDescriptionText: UITextView!
    @IBOutlet private weak var linkLabel: UILabel!
    
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
        newsDescriptionText.text = ""
        newsImageView.image = nil
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

// MARK: - Internal Functions

extension ExtendedNewsTableViewCell {
    
    func getViewForTap() -> UIView {
        return viewForTap
    }
    
    func setupWithModel(_ model: NewsModel) {
        
        linkLabel.text = model.newsLink
        newsResourceLabel.text = getTextSeparatedBySpaceFromModel(model)
        
        newsTitleLabel.text = model.newsTitle
        newsDescriptionText.text = model.newsDescription
        
        if model.imageURL.isEmpty {
            newsImageView.image = SourceImages.emptyPhotoImage
        } else {
            let url = model.imageURL
            ServiceAPI.shared.getImageBy(model.imageURL as NSString) { (image) in
                DispatchQueue.main.async {
                    if url == model.imageURL {
                        self.newsImageView.image = image
                    }
                }
            }
        }
        
        if model.isViewed {
            backView.backgroundColor = SourceColors.commonLightGreyColor
            newsDescriptionText.backgroundColor = SourceColors.commonLightGreyColor
        } else {
            backView.backgroundColor = UIColor.white
            newsDescriptionText.backgroundColor = UIColor.white
        }
    }
}

// MARK: - Private Functions

private extension ExtendedNewsTableViewCell {
    
    func configureSelf() {
        
        backgroundColor = SourceColors.commonBackgroundColor
        contentView.frame = contentView.frame.insetBy(dx: 4, dy: 4)
        
        configureLabels()
        configureTextView()
        configureView()
    }
    
    func configureLabels() {
        
        newsResourceLabel.textColor = SourceColors.commonBackgroundColor
        newsResourceLabel.numberOfLines = 0
        
        newsTitleLabel.textColor = SourceColors.commonDarkGreyColor
        newsTitleLabel.numberOfLines = 0
        
        linkLabel.textColor = SourceColors.commonDarkBlueColor
        linkLabel.numberOfLines = 0
    }
    
    func configureTextView() {
        
        newsDescriptionText.isEditable = false
    }
    
    func configureView() {
        
        backView.layer.borderWidth = 2
        backView.layer.borderColor = SourceColors.commonLightGreyColor.cgColor
        backView.layer.cornerRadius = 8
        backView.layer.masksToBounds = true
        
        viewForTap.alpha = 0.0
    }
    
    func getTextSeparatedBySpaceFromModel(_ model: NewsModel) -> String {
        var separatedString = model.newsResource
        separatedString.getCharBeforeSpace()
        return separatedString
    }
}












