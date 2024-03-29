//
//  CitySearchTableViewCell.swift
//  Under The Weather
//
//  Created by Matthew Lock on 27/05/2023.
//

import UIKit

class CitySearchTableViewCell: UITableViewCell {

    static let reuseIdentifier = "citySearchCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initViews() {
        addSubview(cityName)
        cityName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([cityName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                                     cityName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
                                     cityName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
                                     cityName.heightAnchor.constraint(equalToConstant: 30)])

        addSubview(countryName)
        countryName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([countryName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                                     countryName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
                                     countryName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
                                     countryName.heightAnchor.constraint(equalToConstant: 20)])

        filledCheckmarkIcon.translatesAutoresizingMaskIntoConstraints = false
    }

    let cityName: UILabel = {
        let cityName = UILabel()
        cityName.font = UIFont(name: "ComicNeueSansID", size: 20)
        return cityName
    }()

    let countryName: UILabel = {
        let countryName = UILabel()
        countryName.font = UIFont(name: "ComicNeueSansID", size: 12)
        return countryName
    }()

    let filledCheckmarkIcon: UIImageView = {
        let filledCheckmarkIcon = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 26)
        filledCheckmarkIcon.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
        filledCheckmarkIcon.tintColor = .systemGreen
        return filledCheckmarkIcon
    }()

}
