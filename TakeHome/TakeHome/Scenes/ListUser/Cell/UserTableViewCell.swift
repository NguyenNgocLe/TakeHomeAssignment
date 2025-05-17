//
//  UserTableViewCell.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import UIKit
import SDWebImage

class UserTableViewCell: UITableViewCell {
    
    static let identifier = "\(UserTableViewCell.self)"
    // MARK: - Outlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var linkedInLabel: UILabel!
    @IBOutlet weak var containerImageView: UIView!
    @IBOutlet weak var borderView: UIView!
    
    // MARK: - Load nib
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLinkedInProfileAttribute()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupContainerView()
        setupContainerImageView()
        setupImageView()
    }
    
    private func setupContainerView() {
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
    }
    
    private func setupContainerImageView() {
        containerImageView.backgroundColor = .black.withAlphaComponent(0.2)
        containerImageView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
    }
    
    private func setupImageView() {
        borderView.layer.borderWidth = 1
        borderView.clipsToBounds = true
        borderView.layer.borderColor = UIColor.black.cgColor
        avatarImageView.contentMode = .scaleToFill
        borderView.layer.cornerRadius = borderView.frame.height/2
    }
    
    private func setupLinkedInProfileAttribute() {
        let text = CommonString.profileUrl
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: (text as NSString).range(of: text))
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: (text as NSString).range(of: text))
        linkedInLabel.attributedText = attributedString
    }
    
    func setupData(model: UserCellModel) {
        if let url = URL(string: model.imageViewURL) {
            avatarImageView.sd_setImage(with: url)
        } else {
            avatarImageView.image = UIImage(systemName: "person")
        }
        userNameLabel.text = model.name
    }
}
