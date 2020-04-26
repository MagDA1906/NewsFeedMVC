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
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var resourceLabel: UILabel!
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var backView: UIView!
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureSelf()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        descriptionLabel.text = ""
        resourceLabel.text = ""
        dateLabel.text = ""
        newsImageView.image = nil
    }
}

// MARK: - Internal Functions

extension DefaultNewsTableViewCell {
    
    func setupWithModel(_ model: NewsModel) {
        
        titleLabel.text = model.newsTitle
        descriptionLabel.text = model.newsDescription
        resourceLabel.text = model.newsResource
        dateLabel.text = model.formattedDate
        
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
        
        configureLabels()
        configureView()
        configureImageView()
    }
    
    func configureLabels() {
        
        titleLabel.numberOfLines = 3
        descriptionLabel.numberOfLines = 2
        resourceLabel.numberOfLines = 1
        dateLabel.numberOfLines = 1
    }
    
    func configureView() {
        
        backView.layer.borderWidth = 1
        backView.layer.borderColor = SourceColors.commonDarkGreyColor.cgColor
        backView.layer.cornerRadius = 8
        backView.layer.masksToBounds = true
    }
    
    func configureImageView() {
        
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.layer.cornerRadius = 8
        newsImageView.layer.masksToBounds = true
    }
}
