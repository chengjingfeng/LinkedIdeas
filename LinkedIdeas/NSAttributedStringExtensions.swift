//
//  NSAttributedStringExtensions.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 03/07/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

extension NSAttributedString {
  // Mark: - Computed Properties
  var maxRange: NSRange { return NSMakeRange(0, length) }
  
  var isStrikedThrough: Bool {
    get {
      var range = maxRange
      let strikeValue = attribute(NSStrikethroughStyleAttributeName, at: 0, effectiveRange: &range) as? Int
      return strikeValue == NSUnderlineStyle.styleSingle.rawValue
    }
  }
  
  var isBold: Bool {
    return (font.fontDescriptor.symbolicTraits & UInt32(NSFontTraitMask.boldFontMask.rawValue)) != 0
  }
  
  var defaultFont: NSFont { return NSFont(name: "Helvetica", size: 12)! }
  
  var font: NSFont {
    var range = maxRange
    let _font = attribute(NSFontAttributeName, at: 0, effectiveRange: &range) as? NSFont
    if let _font = _font {
      return _font
    } else {
      return defaultFont
    }
  }
  
  var fontSize: Int { return Int(font.pointSize) }
  
  var fontColor: NSColor {
    var range = maxRange
    let color = attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: &range) as? NSColor
    if let color = color {
      return color
    } else {
      return NSColor.black
    }
  }
  
  // Mark: - Convenience Initializers
  convenience init(attributedString:NSAttributedString, strikeThrough:Bool) {
    var strikeStyle: NSUnderlineStyle = NSUnderlineStyle.styleNone
    if strikeThrough { strikeStyle = NSUnderlineStyle.styleSingle }
    
    let _tempCopy = attributedString.mutableCopy() as! NSMutableAttributedString
    _tempCopy.addAttribute(
      NSStrikethroughStyleAttributeName,
      value: strikeStyle.rawValue,
      range: attributedString.maxRange
    )
    self.init(attributedString: _tempCopy as NSAttributedString)
  }
  
  convenience init(attributedString:NSAttributedString, bold:Bool) {
    var newFont: NSFont!
    
    if bold {
      newFont = NSFontManager.shared().convert(attributedString.font, toHaveTrait: .boldFontMask)
    } else {
      newFont = NSFontManager.shared().convert(attributedString.font, toNotHaveTrait: .boldFontMask)
    }
    
    let _tempCopy = attributedString.mutableCopy() as! NSMutableAttributedString
    _tempCopy.addAttribute(NSFontAttributeName, value: newFont, range: attributedString.maxRange)
    
    self.init(attributedString: _tempCopy as NSAttributedString)
  }
  
  convenience init(attributedString:NSAttributedString, fontColor: NSColor) {
    let _tempCopy = attributedString.mutableCopy() as! NSMutableAttributedString
    _tempCopy.addAttribute(NSForegroundColorAttributeName, value: fontColor, range: attributedString.maxRange)
    
    self.init(attributedString: _tempCopy as NSAttributedString)
  }
  
  convenience init(attributedString:NSAttributedString, fontSize: Int) {
    let newFont: NSFont = NSFontManager.shared().convert(
      attributedString.font, toSize: CGFloat(fontSize))
    let _tempCopy = attributedString.mutableCopy() as! NSMutableAttributedString
    _tempCopy.addAttribute(NSFontAttributeName, value: newFont, range: attributedString.maxRange)
    
    self.init(attributedString: _tempCopy as NSAttributedString)
  }
}