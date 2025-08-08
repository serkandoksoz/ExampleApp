//
//  ToasterProvider.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 2.12.2024.
//

import UIKit

struct ToasterAlert: Route {
    let message: String
    let type: ToasterProvider.ToastType
}

struct ToasterProvider {
    
    enum ToastType {
        case success
        case error
        case info
        
        var backgroundColor: UIColor {
            switch self {
            case .success: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            case .error: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            case .info: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .success:
                return UIImage(systemName: "checkmark")?
                    .withRenderingMode(.alwaysTemplate)
            case .error:
                return UIImage(systemName: "exclamationmark")?
                    .withRenderingMode(.alwaysTemplate)
            case .info:
                return UIImage(systemName: "checkmark")?
                    .withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    // MARK: - Constants
    
    private struct Theme {
        static let maxWidthPadding: CGFloat = 64
        static let contentPadding: CGFloat = 32
        static let verticalPadding: CGFloat = 8
        static let horizontalPadding: CGFloat = 16
        static let iconSize: CGFloat = 20
        static let iconSpacing: CGFloat = 8
        static let cornerRadiusMultiplier: CGFloat = 0.428
    }
    
    // MARK: - Public Methods
    
    func makeUIViewController(message: String, type: ToastType) -> UIView {
        let containerView = makeContainerView(type: type)
        let stackView = makeStackView()
        
        if let icon = type.icon {
            let iconView = makeIconView(icon: icon)
            stackView.addArrangedSubview(iconView)
        }
        
        let messageLabel = makeMessageLabel(text: message)
        stackView.addArrangedSubview(messageLabel)
        
        containerView.addSubview(stackView)
        setupConstraints(container: containerView, stack: stackView)
        setupCornerRadius(container: containerView, stack: stackView)
        
        return containerView
    }
    
    // MARK: - Private Methods
    
    private func makeContainerView(type: ToastType) -> UIView {
        let view = UIView()
        view.backgroundColor = type.backgroundColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func makeStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Theme.iconSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    private func makeIconView(icon: UIImage) -> UIImageView {
        let imageView = UIImageView(image: icon)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Theme.iconSize),
            imageView.heightAnchor.constraint(equalToConstant: Theme.iconSize)
        ])
        
        return imageView
    }
    
    private func makeMessageLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setupConstraints(container: UIView, stack: UIStackView) {
        let maxWidth = UIScreen.main.bounds.width - Theme.maxWidthPadding
        let maxContentWidth = maxWidth - Theme.contentPadding
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: Theme.verticalPadding),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Theme.verticalPadding),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Theme.horizontalPadding),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Theme.horizontalPadding),
            stack.widthAnchor.constraint(lessThanOrEqualToConstant: maxContentWidth)
        ])
    }
    
    private func setupCornerRadius(container: UIView, stack: UIStackView) {
        let estimatedHeight = stack.bounds.height + (Theme.verticalPadding * 2)
        container.layer.cornerRadius = estimatedHeight * Theme.cornerRadiusMultiplier
        
        container.layoutIfNeeded()
        container.layer.cornerRadius = container.bounds.height * Theme.cornerRadiusMultiplier
    }
} 
