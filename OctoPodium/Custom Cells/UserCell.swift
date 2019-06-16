//  UserCell.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit
import Xtensions

class UserRankingCell: UITableViewCell, Reusable {

    private var stackViewWithSmallImageConstraint: NSLayoutConstraint!
    private var stackViewWithBigImageLeadingConstraint: NSLayoutConstraint!

    private let stackView: UIStackView = create {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 10
    }

    private let rankingImageView: UIImageView = create {
        $0.constrain(width: 34)
        $0.constrain(height: 40)
    }
    private let rankingLabel: UILabel = create {
        $0.textColor = UIColor(hex: 0xAAAAAA)
        $0.font = UIFont.systemFont(ofSize: 11)
        $0.textAlignment = .center
    }

    private let bigImageBorderView: UIView = create {
        $0.backgroundColor = UIColor(hex: 0xF7F7F7)
        $0.constrainSize(equalTo: 40)
        $0.cornerRadius = 20
    }

    private let userAvatarBigImageView: UIImageView = create {
        $0.constrainSize(equalTo: 34)
        $0.cornerRadius = 34 / 2
    }

    private let smallImageBorderView: UIView = create {
        $0.backgroundColor = UIColor(hex: 0xECF0F1)
        $0.constrainSize(equalTo: 30)
        $0.cornerRadius = 15
    }

    private let userAvatarSmallImageView: UIImageView = create {
        $0.constrainSize(equalTo: 26)
        $0.cornerRadius = 26 / 2
    }

    private let userLoginLabel: UILabel = create {
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = UIColor(hex: 0x313131)
    }
    private let numberOfStarsLabel: UILabel = create {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .light)
        $0.textColor = UIColor(hex: 0x313131)
    }

    private let starsLabel: UILabel = create {
        $0.font = UIFont.systemFont(ofSize: 9, weight: .light)
        $0.text = "★"
    }

    private var presenter: UserPresenter?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(rankingImageView)
        contentView.addSubview(rankingLabel)
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(bigImageBorderView)
        stackView.addArrangedSubview(smallImageBorderView)
        stackView.addArrangedSubview(userLoginLabel)
        stackView.addArrangedSubview(numberOfStarsLabel)
        stackView.addArrangedSubview(starsLabel)

        bigImageBorderView.addSubview(userAvatarBigImageView)
        smallImageBorderView.addSubview(userAvatarSmallImageView)

        stackViewWithSmallImageConstraint = stackView.leading(==, contentView.leadingAnchor, 60)
        stackViewWithSmallImageConstraint.isActive = false
        stackViewWithBigImageLeadingConstraint = stackView.leading(==, contentView.leadingAnchor, 54)

        rankingLabel.leading(==, rankingImageView, 1)
        rankingLabel.trailing(==, rankingImageView)
        rankingLabel.centerY(==, contentView)

        rankingImageView.leading(==, contentView, 10)
        rankingImageView.top(==, contentView)

        userAvatarBigImageView.centerX(==, bigImageBorderView)
        userAvatarBigImageView.centerY(==, bigImageBorderView)

        userAvatarSmallImageView.centerX(==, smallImageBorderView)
        userAvatarSmallImageView.centerY(==, smallImageBorderView)

        stackView.setCustomSpacing(13, after: userAvatarSmallImageView)
        stackView.setCustomSpacing(13, after: userAvatarBigImageView)
        stackView.setCustomSpacing(0, after: numberOfStarsLabel)
        stackView.constrain(referringTo: contentView, leading: nil, trailing: -5)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        userAvatarBigImageView.image = nil
        userAvatarSmallImageView.image = nil
    }

    func render(with userPresenter: UserPresenter) {
        presenter = userPresenter
        let isPodium = userPresenter.isInPodium
        rankingImageView.isHidden = !isPodium
        bigImageBorderView.isHidden = !isPodium
        smallImageBorderView.isHidden = isPodium
        rankingLabel.isHidden = isPodium

        stackViewWithBigImageLeadingConstraint.isActive = false
        stackViewWithSmallImageConstraint.isActive = false

        stackViewWithBigImageLeadingConstraint.isActive = isPodium
        stackViewWithSmallImageConstraint.isActive = !isPodium
        layoutIfNeeded()

        starsLabel.textColor = isPodium ? UIColor(hex: 0x313131) : UIColor(hex: 0xAAAAAA)
        numberOfStarsLabel.textColor = isPodium ? UIColor(hex: 0x313131) : UIColor(hex: 0x555555)
        userLoginLabel.textColor = isPodium ? UIColor(hex: 0x313131) : .black
        userLoginLabel.font = isPodium ? UIFont.systemFont(ofSize: 16, weight: .semibold) : UIFont.systemFont(ofSize: 17)

        contentView.backgroundColor = isPodium ? UIColor(hex: 0xF7F7F7) : .clear

        if isPodium, let imageName = userPresenter.rankingImageName {
            rankingImageView.image = UIImage(named: imageName)
        }

        let imageView = isPodium ? userAvatarBigImageView : userAvatarSmallImageView
        if let avatar = userPresenter.avatarUrl {
            imageView.fetchAndLoad(avatar)
        }

        rankingLabel.text = "\(userPresenter.ranking)"
        userLoginLabel.text = userPresenter.login
        numberOfStarsLabel.text = "\(userPresenter.stars)"
    }
}

extension UserRankingCell: CellWithAvatar {
    
    var avatar: UIImageView {
        return presenter?.isInPodium == true ? userAvatarBigImageView : userAvatarSmallImageView
    }
}
