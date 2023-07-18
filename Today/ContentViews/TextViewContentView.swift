//
//  TextViewContentView.swift
//  Today
//
//  Created by Aleksandr on 18.07.2023.
//

import UIKit

class TextViewContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        var onChange: (String) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            TextViewContentView(self)
        }
    }
    
    var configuration: UIContentConfiguration {
        didSet {
            configure(with: configuration)
        }
    }
    
    let textView = UITextView()
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(textView, height: 200)
        textView.backgroundColor = .clear
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    func configure(with configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textView.text = configuration.text
    }
}

extension TextViewContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let configuration = configuration as? Configuration else { return }
        configuration.onChange(textView.text)
    }
}

extension UICollectionViewListCell {
    func textViewConfiguration() -> TextViewContentView.Configuration {
        TextViewContentView.Configuration()
    }
}
