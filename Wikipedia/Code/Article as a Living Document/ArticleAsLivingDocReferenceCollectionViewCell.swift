import UIKit

class ArticleAsLivingDocReferenceCollectionViewCell: ArticleAsLivingDocHorizontallyScrollingCell {
    
    private let titleLabel = UILabel()
    private var reference: ArticleAsLivingDocViewModel.Event.Large.Reference? = nil
    private var iconTitleBadge: IconTitleBadge?
    
    override func sizeThatFits(_ size: CGSize, apply: Bool) -> CGSize {
        
        let adjustedMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        var availableTitleWidth = size.width - adjustedMargins.left - adjustedMargins.right
        let availableDescriptionWidth = availableTitleWidth
        
        if let iconTitleBadge = iconTitleBadge {
            let maximumBadgeWidth = min(size.width - adjustedMargins.right - adjustedMargins.left, size.width / 3)
            let iconBadgeOrigin = CGPoint(x: size.width - adjustedMargins.right, y: adjustedMargins.top)
            let iconBadgeFrame = iconTitleBadge.wmf_preferredFrame(at: iconBadgeOrigin, maximumWidth: maximumBadgeWidth, alignedBy: .forceLeftToRight, apply: false)
            if (apply) {
                let iconTitleBadgeX = size.width - adjustedMargins.right - iconBadgeFrame.width
                iconTitleBadge.frame = CGRect(x: iconTitleBadgeX, y: iconBadgeFrame.minY, width: iconBadgeFrame.width, height: iconBadgeFrame.height)
            }
            let titleBadgeSpacing = CGFloat(10)
            availableTitleWidth -= iconBadgeFrame.width + titleBadgeSpacing
        }
        
        let titleOrigin = CGPoint(x: adjustedMargins.left, y: adjustedMargins.top)
        let titleFrame = titleLabel.wmf_preferredFrame(at: titleOrigin, maximumWidth: availableTitleWidth, alignedBy: .forceLeftToRight, apply: apply)
        
        let titleDescriptionSpacing = CGFloat(10)
        let descriptionOrigin = CGPoint(x: adjustedMargins.left, y: titleFrame.maxY + titleDescriptionSpacing)
        
        let descriptionTextViewFrame = descriptionTextView.wmf_preferredFrame(at: descriptionOrigin, maximumWidth: availableDescriptionWidth, alignedBy: .forceLeftToRight, apply: apply)
        
        let finalSize = CGSize(width: size.width, height: descriptionTextViewFrame.maxY + adjustedMargins.bottom)
        
        if (apply) {
            layer.shadowPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: finalSize), cornerRadius: backgroundView?.layer.cornerRadius ?? 0).cgPath
        }
        
        return finalSize
    }
    
    override func setup() {
        
        super.setup()
        descriptionTextView.textContainer.maximumNumberOfLines = 0
        contentView.addSubview(titleLabel)
        //adding icon badge in configure
    }
    
    override func reset() {
        super.reset()
        iconTitleBadge?.removeFromSuperview()
        iconTitleBadge = nil
        titleLabel.text = nil
    }
    
    private func createIconTitleBadgeForReference(reference: ArticleAsLivingDocViewModel.Event.Large.Reference) {
        guard let year = reference.accessDateYearDisplay else {
            return
        }
        
        let configuration = IconTitleBadge.Configuration(title: year, icon: .sfSymbol(name: "clock.fill"))
        let iconTitleBadge = IconTitleBadge(configuration: configuration, frame: .zero)
        contentView.addSubview(iconTitleBadge)
        self.iconTitleBadge = iconTitleBadge
    }
    
    override func configure(change: ArticleAsLivingDocViewModel.Event.Large.ChangeDetail, theme: Theme, delegate: ArticleAsLivingDocHorizontallyScrollingCellDelegate) {
        
        super.configure(change: change, theme: theme, delegate: delegate)
        
        switch change {
        case .reference(let reference):
            self.reference = reference
            createIconTitleBadgeForReference(reference: reference)
            titleLabel.text = reference.type
        default:
            assertionFailure("ArticleAsLivingDocReferenceCollectionViewCell configured with unexpected type")
            return
        }
        
        updateFonts(with: traitCollection)
        apply(theme: theme)
    }
    
    override func updateFonts(with traitCollection: UITraitCollection) {
        super.updateFonts(with: traitCollection)
        titleLabel.font = UIFont.wmf_font(.semiboldSubheadline, compatibleWithTraitCollection: traitCollection)
        iconTitleBadge?.updateFonts(with: traitCollection)
    }
    
    override func apply(theme: Theme) {
        super.apply(theme: theme)
        titleLabel.textColor = theme.colors.secondaryText
        iconTitleBadge?.apply(theme: theme)
    }
}