//
//  AvatarSetupViewController.swift
//  Habitica
//
//  Created by Phillip on 01.08.17.
//  Copyright © 2017 Phillip Thelen. All rights reserved.
//

import UIKit

public enum AvatarCustomizationCategory {
    case body, skin, hair, extras
}

public enum AvatarCustomizationSubcategory {
    case none, size, shirt, bangs, ponytail, color, flower, glasses, wheelchair
    
    var text: String {
        switch self {
        case .size:
            return NSLocalizedString("Size", comment: "")
        case .shirt:
            return NSLocalizedString("Shirt", comment: "")
        case .bangs:
            return NSLocalizedString("Bangs", comment: "")
        case .ponytail:
            return NSLocalizedString("Ponytail", comment: "")
        case .color:
            return NSLocalizedString("Color", comment: "")
        case .flower:
            return NSLocalizedString("Flower", comment: "")
        case .glasses:
            return NSLocalizedString("Glasses", comment: "")
        case .wheelchair:
            return NSLocalizedString("Wheelchair", comment: "")
        default:
            return ""
        }
    }
}

class AvatarSetupViewController: UIViewController, TypingTextViewController {

    @IBOutlet weak var bodyButton: UIStackView!
    @IBOutlet weak var bodyImageView: UIImageView!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var skinButton: UIStackView!
    @IBOutlet weak var skinImageView: UIImageView!
    @IBOutlet weak var skinLabel: UILabel!
    @IBOutlet weak var hairButton: UIStackView!
    @IBOutlet weak var hairImageView: UIImageView!
    @IBOutlet weak var hairLabel: UILabel!
    @IBOutlet weak var extrasButton: UIStackView!
    @IBOutlet weak var extrasImageView: UIImageView!
    @IBOutlet weak var extrasLabel: UILabel!
    @IBOutlet weak var selectionCaretOffset: NSLayoutConstraint!
    @IBOutlet weak var speechbubbleView: SpeechbubbleView!
    
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var randomizeButton: UIButton!
    @IBOutlet weak var subCategoryContainer: UIStackView!
    @IBOutlet weak var contentContainer: UIStackView!
    
    @IBOutlet var contentCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryHeight: NSLayoutConstraint!
    
    var sharedManager: HRPGManager?
    var user: User?
    
    var currentCategory: AvatarCustomizationCategory = .body {
        didSet {
            updateCategoryButtons()
            setSubCategories(getSubcategoriesForCurrentCategory())
            updateContent()
        }
    }
    
    var currentSubcategory: AvatarCustomizationSubcategory = .none {
        didSet {
            updateSubcategoryButtons()
            updateContent()
        }
    }
    var content: [SetupCustomization] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let delegate = UIApplication.shared.delegate as? HRPGAppDelegate {
            sharedManager = delegate.sharedManager
            user = sharedManager?.getUser()
            user?.setAvatarSubview(avatarView, showsBackground: false, showsMount: false, showsPet: false)
        }
        
        let bodyGesture = UITapGestureRecognizer(target: self, action: #selector(setBodyCategory))
        bodyButton.addGestureRecognizer(bodyGesture)
        let skinGesture = UITapGestureRecognizer(target: self, action: #selector(setSkinCategory))
        skinButton.addGestureRecognizer(skinGesture)
        let hairGesture = UITapGestureRecognizer(target: self, action: #selector(setHairCategory))
        hairButton.addGestureRecognizer(hairGesture)
        let extrasGesture = UITapGestureRecognizer(target: self, action: #selector(setExtrasCategory))
        extrasButton.addGestureRecognizer(extrasGesture)
        
        let buttonBackground = #imageLiteral(resourceName: "DiamondButton").resizableImage(withCapInsets: UIEdgeInsets(top: 18, left: 15, bottom: 18, right: 15))
        randomizeButton.setBackgroundImage(buttonBackground, for: .normal)
        
        let randomizeGesture = UITapGestureRecognizer(target: self, action: #selector(randomizeButtonTapped))
        randomizeButton.addGestureRecognizer(randomizeGesture)
        
        if self.view.frame.size.height <= 568 {
            contentHeight.constant = 120
            categoryHeight.constant = 85
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentCategory = .body
    }
    
    func setBodyCategory() {
        currentCategory = .body
    }
    
    func setSkinCategory() {
        currentCategory = .skin
    }
    
    func setHairCategory() {
        currentCategory = .hair
    }
    
    func setExtrasCategory() {
        currentCategory = .extras
    }
    
    func randomizeButtonTapped() {
        guard let user = self.user else {
            return
        }
        var updateData = [String: String]()
        updateData["preferences.size"] = chooseRandomKey(SetupCustomizationRepository.getCustomizations(category: .body, subcategory: .size, user: user), weighFirstOption: false)
        updateData["preferences.shirt"] = chooseRandomKey(SetupCustomizationRepository.getCustomizations(category: .body, subcategory: .shirt, user: user), weighFirstOption: false)
        updateData["preferences.skin"] = chooseRandomKey(SetupCustomizationRepository.getCustomizations(category: .skin, subcategory: .color, user: user), weighFirstOption: false)
        updateData["preferences.hair.color"] = chooseRandomKey(SetupCustomizationRepository.getCustomizations(category: .hair, subcategory: .color, user: user), weighFirstOption: false)
        updateData["preferences.hair.base"] = chooseRandomKey(SetupCustomizationRepository.getCustomizations(category: .hair, subcategory: .ponytail, user: user), weighFirstOption: false)
        updateData["preferences.hair.bangs"] = chooseRandomKey(SetupCustomizationRepository.getCustomizations(category: .hair, subcategory: .bangs, user: user), weighFirstOption: false)
        updateData["preferences.hair.flower"] = chooseRandomKey(SetupCustomizationRepository.getCustomizations(category: .extras, subcategory: .flower, user: user), weighFirstOption: true)
        updateData["preferences.chair"] = chooseRandomKey(SetupCustomizationRepository.getCustomizations(category: .extras, subcategory: .wheelchair, user: user), weighFirstOption: true)
        
        self.sharedManager?.updateUser(updateData, refetchUser: false, onSuccess: {[weak self] in
            self?.updateActiveCustomizations()
            }, onError: nil)
    }
    
    func chooseRandomKey(_ items: [SetupCustomization], weighFirstOption: Bool) -> String {
        if items.count == 0 {
            return ""
        }
        if weighFirstOption {
            if Int(arc4random_uniform(10)) > 3 {
                return items[0].key
            }
        }
        return items[Int(arc4random_uniform(UInt32(items.count)))].key
    }

    private func setSubCategories(_ subcategories: [AvatarCustomizationSubcategory]) {
        subCategoryContainer.arrangedSubviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        if subcategories.count == 0 {
            return
        }
        
        for subcategory in subcategories {
            let button = UIButton()
            button.setTitleColor(.white, for: .normal)
            button.setTitle(subcategory.text.uppercased(), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.alpha = 0.5
            button.addTarget(self, action: #selector(subcategoryTapped(_:)), for: .touchUpInside)
            subCategoryContainer.addArrangedSubview(button)
        }
        
        currentSubcategory = subcategories[0]
    }

    private func updateCategoryButtons() {
        let selectedFrame = getActiveCategoryButton().frame
        let caretOffset = selectedFrame.origin.x + (selectedFrame.size.width / 2) - 10
        
        selectionCaretOffset.constant = caretOffset
        UIView.animate(withDuration: 0.2) {[weak self] in
            if self?.currentCategory == .body {
                self?.bodyImageView.alpha = 1.0
                self?.bodyLabel.alpha = 1.0
            } else {
                self?.bodyImageView.alpha = 0.5
                self?.bodyLabel.alpha = 0.5
            }
            if self?.currentCategory == .skin {
                self?.skinImageView.alpha = 1.0
                self?.skinLabel.alpha = 1.0
            } else {
                self?.skinImageView.alpha = 0.5
                self?.skinLabel.alpha = 0.5
            }
            if self?.currentCategory == .hair {
                self?.hairImageView.alpha = 1.0
                self?.hairLabel.alpha = 1.0
            } else {
                self?.hairImageView.alpha = 0.5
                self?.hairLabel.alpha = 0.5
            }
            if self?.currentCategory == .extras {
                self?.extrasImageView.alpha = 1.0
                self?.extrasLabel.alpha = 1.0
            } else {
                self?.extrasImageView.alpha = 0.5
                self?.extrasLabel.alpha = 0.5
            }
            
            self?.view.layoutIfNeeded()
        }
    }
    
    private func updateSubcategoryButtons() {
        let activeIndex = getSubcategoriesForCurrentCategory().index(of: currentSubcategory)
        UIView.animate(withDuration: 0.2) {[weak self] in
            guard let weakSelf = self else {
                return
            }
            for (index, view) in weakSelf.subCategoryContainer.arrangedSubviews.enumerated() {
                if let button = view as? UIButton {
                    if index == activeIndex {
                        button.alpha = 1.0
                        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
                    } else {
                        button.alpha = 0.5
                        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                    }
                }
            }
        }
    }
    
    private func getSubcategoriesForCurrentCategory() -> [AvatarCustomizationSubcategory] {
        switch currentCategory {
        case .body:
            return [.size, .shirt]
        case .skin:
            return [.color]
        case .hair:
            return [.color, .bangs, .ponytail]
        case .extras:
            return [.glasses, .flower, .wheelchair]
        }
    }
    
    func subcategoryTapped(_ sender: UIButton!) {
        guard let activeIndex = subCategoryContainer.arrangedSubviews.index(of: sender) else {
            return
        }
        currentSubcategory = getSubcategoriesForCurrentCategory()[activeIndex]
    }
    
    private func updateContent() {
        contentContainer.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        if let user = self.user {
            content = SetupCustomizationRepository.getCustomizations(category: currentCategory, subcategory: currentSubcategory, user: user)
            for item in content {
                let view = SetupCustomizationItemView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                view.setItem(item)
                view.setActive(isCustomizationActive(item), animated: false)
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setupCustomizationTapped(_:)))
                view.addGestureRecognizer(tapGestureRecognizer)
                contentContainer.addArrangedSubview(view)
            }
            contentCenterConstraint.isActive = content.count <= 5
        }
    }
    
    func setupCustomizationTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        guard let activeIndex = contentContainer.arrangedSubviews.index(of: view) else {
            return
        }
        let activeCustomization = content[activeIndex]
        if activeCustomization.path == "glasses" {
            var key: String?
            if activeCustomization.key.characters.count == 0 {
                key = user?.equipped.eyewear
            } else {
                key = activeCustomization.key
            }
            self.sharedManager?.equipObject(key, withType: "equipped", onSuccess: {[weak self] in
                self?.updateActiveCustomizations()
                }, onError: nil)
        } else {
            self.sharedManager?.updateUser(["preferences."+activeCustomization.path: activeCustomization.key], refetchUser: false, onSuccess: {[weak self] in
                self?.updateActiveCustomizations()
                }, onError: nil)
        }
    }
    
    private func updateActiveCustomizations() {
        for (index, item) in content.enumerated() {
            if let contentView = contentContainer.arrangedSubviews[index] as? SetupCustomizationItemView {
                contentView.setActive(isCustomizationActive(item), animated: false)
            }
        }
        
        if let user = self.user {
            user.setAvatarSubview(avatarView, showsBackground: false, showsMount: false, showsPet: false)
        }
    }
    
    private func getActiveCategoryButton() -> UIView {
        switch currentCategory {
        case .body:
            return bodyButton
        case .skin:
            return skinButton
        case .hair:
            return hairButton
        case .extras:
            return extrasButton
        }
    }

    private func isCustomizationActive(_ customization: SetupCustomization) -> Bool {
        if let user = self.user {
            switch customization.subcategory {
            case .size:
                return customization.key == user.preferences.size ?? ""
            case .shirt:
                return customization.key == user.preferences.shirt ?? ""
            case .color:
                if customization.category == .skin {
                    return customization.key == user.preferences.skin ?? ""
                } else {
                    return customization.key == user.preferences.hairColor ?? ""
                }
            case .ponytail:
                return customization.key == user.preferences.hairBase ?? ""
            case .bangs:
                return customization.key == user.preferences.hairBangs ?? ""
            case .flower:
                return customization.key == user.preferences.hairFlower ?? ""
            case .glasses:
                return customization.key == user.equipped.eyewear ?? ""
            case .wheelchair:
                return "chair_"+customization.key == user.preferences.chair ?? "" || customization.key == user.preferences.chair ?? "" || (customization.key == "none" && user.preferences.chair == nil)
            default:
                return false
            }
        }
        return false
    }
    
    func startTyping() {
        speechbubbleView.animateTextView()
    }
}
