//
//  ChangeChecklistColorViewController.swift
//  ProjectTest
//
//  Created by Mariam Khan on 5/16/21.
//

// CITATIONS:
// 1. https://www.youtube.com/watch?v=DBWu6TnhLeY - Protocol Delegate Method
// 2. https://stackoverflow.com/questions/26961274/how-can-i-make-a-button-have-a-rounded-border-in-swift - UI Button Rounded Corner Extension
// 3.https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values - UI Color Extension

import Foundation
import UIKit

// MARK: Protocol for Background Color Changing
protocol colorSelectionDelegate {
    func didTapColor(color: UIColor)
}

// View Controller for Choosing Color to Change Background of Checklist View Controller to
class ChangeChecklistColorViewController: UIViewController {
    
    // MARK: Variables
    var selectionDelegate: colorSelectionDelegate!
    let defaults = UserDefaults.standard
    
    // MARK: Button Outlets
    // Forest Green Button
    @IBAction func forestGreenTapped(_ sender: UIButton) {
        selectionDelegate.didTapColor(color: UIColor(rgb:0x859588) )
        UserDefaults.standard.set(0x859588, forKey: "background_color_hex")
        dismiss(animated: true, completion: nil)
    }
    
    // Spring Green Button
    @IBAction func springGreenTapped(_ sender: UIButton) {
        selectionDelegate.didTapColor(color: UIColor(rgb: 0xb6b9ae))
        UserDefaults.standard.set(0xb6b9ae, forKey: "background_color_hex")
        dismiss(animated: true, completion: nil)
    }
    
    // Coral Pink Button
    @IBAction func coralPinkTapped(_ sender: UIButton) {
        selectionDelegate.didTapColor(color: UIColor(rgb: 0xcb836d))
        UserDefaults.standard.set(0xcb836d, forKey: "background_color_hex")
        dismiss(animated: true, completion: nil)
    }
    
    // Blush Pink Button
    @IBAction func blushPinkTapped(_ sender: UIButton) {
        selectionDelegate.didTapColor(color: UIColor(rgb: 0xfee3d8))
        UserDefaults.standard.set(0xfee3d8, forKey: "background_color_hex")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: View Loading Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: Extensions
// Rounded Button Extension
@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

// UI Color Extension
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
