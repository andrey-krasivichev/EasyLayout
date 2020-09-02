//
//  EasyLayout.swift
//
//  Created by Andrey Krasivichev on 20.04.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

import UIKit

public extension UIView {
    final class ConstraintMaker {
        private weak var view: UIView?
        private var buildingItems: [ConstraintDescriptionItem] = []
        private var buildingFinishedItems: [ConstraintDescriptionItem] = []
        private var readyConstraints: [NSLayoutConstraint] = []
        private var nextItemsFinalizeCurrent: Bool = false
        
        fileprivate static func makeConstraints(view: UIView, closure: (_ make: ConstraintMaker) -> Void) -> [NSLayoutConstraint] {
            let maker = ConstraintMaker(view: view)
            closure(maker)
            let constraints: [NSLayoutConstraint] = maker.makeConstraints()
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(constraints)
            return constraints
        }

        init(view: UIView) {
            self.view = view
        }
        
        public var left: ConstraintMaker {
            finalizeCurrentItemsIfNeeded()
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.left))
            return self
        }
        
        public var right: ConstraintMaker {
            finalizeCurrentItemsIfNeeded()
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.right))
            return self
        }
        
        public var top: ConstraintMaker {
            finalizeCurrentItemsIfNeeded()
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.top))
            return self
        }
        
        public var bottom: ConstraintMaker {
            finalizeCurrentItemsIfNeeded()
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.bottom))
            return self
        }
        
        public var leading: ConstraintMaker {
            finalizeCurrentItemsIfNeeded()
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.leading))
            return self
        }
        
        public var trailing: ConstraintMaker {
            finalizeCurrentItemsIfNeeded()
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.trailing))
            return self
        }
        
        public var width: ConstraintMaker {
            finalizeCurrentItemsIfNeeded()
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.width))
            return self
        }
        
        public var height: ConstraintMaker {
            finalizeCurrentItemsIfNeeded()
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.height))
            return self
        }
        
        public var size: ConstraintMaker {
            finalizeCurrentItemsIfNeeded()
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.width))
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.height))
            return self
        }
        
        public var centerX: ConstraintMaker {
            finalizeCurrentItemsIfNeeded()
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.centerX))
            return self
        }
        
        public var centerY: ConstraintMaker {
            finalizeCurrentItemsIfNeeded()
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.centerY))
            return self
        }
        
        public var center: ConstraintMaker {
            finalizeCurrentItemsIfNeeded()
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.centerX))
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.centerY))
            return self
        }

        public var edges: ConstraintMaker {
            finalizeCurrentItemsIfNeeded()
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.left))
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.right))
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.top))
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.bottom))
            return self
        }
        
        public var vertically: ConstraintMaker {
            finalizeCurrentItemsIfNeeded()
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.top))
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.bottom))
            return self
        }
        
        public var horizontally: ConstraintMaker {
            finalizeCurrentItemsIfNeeded()
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.left))
            buildingItems.append(ConstraintDescriptionItem(firstView: view, attribute: NSLayoutConstraint.Attribute.right))
            return self
        }
        
        // equality funcs
        // MARK: UIView support
        @discardableResult
        public func equalTo(_ view: UIView) -> ConstraintMaker {
            buildingItems.applyRelation(NSLayoutConstraint.Relation.equal, secondView: view)
            nextItemsFinalizeCurrent = true
            return self
        }
        
        @discardableResult
        public func greaterOrEqualTo(_ view: UIView) -> ConstraintMaker {
            buildingItems.applyRelation(NSLayoutConstraint.Relation.greaterThanOrEqual, secondView: view)
            nextItemsFinalizeCurrent = true
            return self
        }
        
        @discardableResult
        public func lessOrEqualTo(_ view: UIView) -> ConstraintMaker {
            buildingItems.applyRelation(NSLayoutConstraint.Relation.lessThanOrEqual, secondView: view)
            nextItemsFinalizeCurrent = true
            return self
        }
        
        @discardableResult
        public func equalToSuperView() -> ConstraintMaker {
            guard let superView = view?.superview else {
                return self
            }
            return equalTo(superView)
        }
        
        @discardableResult
        public func greaterOrEqualToSuperView() -> ConstraintMaker {
            guard let superView = view?.superview else {
                return self
            }
            return greaterOrEqualTo(superView)
        }
        
        @discardableResult
        public func lessOrEqualToSuperView() -> ConstraintMaker {
            guard let superView = view?.superview else {
                return self
            }
            return lessOrEqualTo(superView)
        }
        
        // MARK: UIView anchors support
        @discardableResult
        public func equalTo(_ anchorAttribute: AnchorAttribute) -> ConstraintMaker {
            buildingItems.applyRelation(NSLayoutConstraint.Relation.equal, attribute: anchorAttribute)
            nextItemsFinalizeCurrent = true
            return self
        }
        
        @discardableResult
        public func greaterOrEqualTo(_ anchorAttribute: AnchorAttribute) -> ConstraintMaker {
            buildingItems.applyRelation(NSLayoutConstraint.Relation.greaterThanOrEqual, attribute: anchorAttribute)
            nextItemsFinalizeCurrent = true
            return self
        }
        
        @discardableResult
        public func lessOrEqualTo(_ anchorAttribute: AnchorAttribute) -> ConstraintMaker {
            buildingItems.applyRelation(NSLayoutConstraint.Relation.lessThanOrEqual, attribute: anchorAttribute)
            nextItemsFinalizeCurrent = true
            return self
        }
        
        // MARK: Float support
        @discardableResult
        public func equalTo(_ value: CGFloat) -> ConstraintMaker {
            buildingItems.applyRelation(NSLayoutConstraint.Relation.equal)
            buildingItems.applyConstant(value)
            nextItemsFinalizeCurrent = true
            return self
        }
        
        @discardableResult
        public func greaterOrEqualTo(_ value: CGFloat) -> ConstraintMaker {
            buildingItems.applyRelation(NSLayoutConstraint.Relation.greaterThanOrEqual)
            buildingItems.applyConstant(value)
            nextItemsFinalizeCurrent = true
            return self
        }
        
        @discardableResult
        public func lessOrEqualTo(_ value: CGFloat) -> ConstraintMaker {
            buildingItems.applyRelation(NSLayoutConstraint.Relation.lessThanOrEqual)
            buildingItems.applyConstant(value)
            nextItemsFinalizeCurrent = true
            return self
        }
        
        // MARK: Size support
        @discardableResult
        public func equalTo(_ size: CGSize) -> ConstraintMaker {
            for item in buildingItems {
                if item.firstViewAttribute == NSLayoutConstraint.Attribute.width {
                    item.firstViewToSecondRelation = NSLayoutConstraint.Relation.equal
                    item.constant = size.width
                }
                if item.firstViewAttribute == NSLayoutConstraint.Attribute.height {
                    item.firstViewToSecondRelation = NSLayoutConstraint.Relation.equal
                    item.constant = size.height
                }
            }
            nextItemsFinalizeCurrent = true
            return self
        }
        
        @discardableResult
        public func lessOrEqualTo(_ size: CGSize) -> ConstraintMaker {
            for item in buildingItems {
                if item.firstViewAttribute == NSLayoutConstraint.Attribute.width {
                    item.firstViewToSecondRelation = NSLayoutConstraint.Relation.lessThanOrEqual
                    item.constant = size.width
                }
                if item.firstViewAttribute == NSLayoutConstraint.Attribute.height {
                    item.firstViewToSecondRelation = NSLayoutConstraint.Relation.lessThanOrEqual
                    item.constant = size.height
                }
            }
            nextItemsFinalizeCurrent = true
            return self
        }
        
        @discardableResult
        public func greaterOrEqualTo(_ size: CGSize) -> ConstraintMaker {
            for item in buildingItems {
                if item.firstViewAttribute == NSLayoutConstraint.Attribute.width {
                    item.firstViewToSecondRelation = NSLayoutConstraint.Relation.greaterThanOrEqual
                    item.constant = size.width
                }
                if item.firstViewAttribute == NSLayoutConstraint.Attribute.height {
                    item.firstViewToSecondRelation = NSLayoutConstraint.Relation.greaterThanOrEqual
                    item.constant = size.height
                }
            }
            nextItemsFinalizeCurrent = true
            return self
        }
        
        @discardableResult
        public func multipliedBy(_ multiplier: CGFloat) -> ConstraintMaker {
            buildingItems.applyMultiplier(multiplier)
            nextItemsFinalizeCurrent = true
            return self
        }
        
        @discardableResult
        public func offset(_ value: CGFloat) -> ConstraintMaker {
            buildingItems.applyConstant(value)
            nextItemsFinalizeCurrent = true
            return self
        }
        
        @discardableResult
        public func inset(_ value: CGFloat) -> ConstraintMaker {
            for item in buildingItems {
                if item.firstViewAttribute == NSLayoutConstraint.Attribute.top || item.firstViewAttribute == NSLayoutConstraint.Attribute.left
                    || item.firstViewAttribute == NSLayoutConstraint.Attribute.leading {
                    item.constant = value
                }
                if item.firstViewAttribute == NSLayoutConstraint.Attribute.right || item.firstViewAttribute == NSLayoutConstraint.Attribute.trailing
                    || item.firstViewAttribute == NSLayoutConstraint.Attribute.bottom {
                    item.constant = -value
                }
            }
            nextItemsFinalizeCurrent = true
            return self
        }
        
        @discardableResult
        public func priority(_ priority: UILayoutPriority) -> ConstraintMaker {
            buildingItems.applyPriority(priority)
            nextItemsFinalizeCurrent = true
            return self
        }
        
        @discardableResult
        public func priority(_ priority: Float) -> ConstraintMaker {
            var priorityToSet = min(priority, UILayoutPriority.required.rawValue)
            priorityToSet = max(0.0, priorityToSet)
            buildingItems.applyPriority(UILayoutPriority(priorityToSet))
            nextItemsFinalizeCurrent = true
            return self
        }
        
        @discardableResult
        public func priorityRequired() -> ConstraintMaker {
            return priority(UILayoutPriority.required)
        }
        
        @discardableResult
        public func priorityHigh() -> ConstraintMaker {
            return priority(UILayoutPriority.defaultHigh)
        }
        
        @discardableResult
        public func priorityLow() -> ConstraintMaker {
            return priority(UILayoutPriority.defaultLow)
        }
        
        @discardableResult
        public func constraints() -> [NSLayoutConstraint] {
            let constraints: [NSLayoutConstraint] = buildingItems.makeConstraints()
            readyConstraints.append(contentsOf: constraints)
            buildingItems = []
            return constraints
        }
        
        // result
        fileprivate func makeConstraints() -> [NSLayoutConstraint] {
            let resultPrototypes: [ConstraintDescriptionItem] = buildingFinishedItems + buildingItems
            let constraints = readyConstraints
            buildingItems = []
            buildingFinishedItems = []
            readyConstraints = []
            return constraints + resultPrototypes.makeConstraints()
        }
        
        fileprivate func finalizeCurrentItemsIfNeeded() {
            guard nextItemsFinalizeCurrent else {
                return
            }
            nextItemsFinalizeCurrent = false
            let nextItems = buildingItems
            buildingItems = []
            buildingFinishedItems.append(contentsOf: nextItems)
        }
    }
    
    @discardableResult
    func makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> [NSLayoutConstraint] {
        return ConstraintMaker.makeConstraints(view: self, closure: closure)
    }
    
    final class AnchorAttribute {
        weak var view: UIView?
        fileprivate var attribute: NSLayoutConstraint.Attribute?
        fileprivate let preferrsSafeArea: Bool
        
        fileprivate init(view: UIView?, attribute: NSLayoutConstraint.Attribute? = nil, preferrsSafeArea: Bool = false) {
            self.view = view
            self.attribute = attribute
            self.preferrsSafeArea = preferrsSafeArea
        }
    }
    
    final class AnchorAttributes {
        weak var view: UIView?
        init(view: UIView) {
            self.view = view
        }
        
        public var left: AnchorAttribute {
            return AnchorAttribute(view: view, attribute: NSLayoutConstraint.Attribute.left)
        }
        
        public var right: AnchorAttribute {
            return AnchorAttribute(view: view, attribute: NSLayoutConstraint.Attribute.right)
        }
        
        public var top: AnchorAttribute {
            return AnchorAttribute(view: view, attribute: NSLayoutConstraint.Attribute.top)
        }
        
        public var bottom: AnchorAttribute {
            return AnchorAttribute(view: view, attribute: NSLayoutConstraint.Attribute.bottom)
        }
        
        public var leading: AnchorAttribute {
            return AnchorAttribute(view: view, attribute: NSLayoutConstraint.Attribute.leading)
        }
        
        public var trailing: AnchorAttribute {
            return AnchorAttribute(view: view, attribute: NSLayoutConstraint.Attribute.trailing)
        }
        
        public var width: AnchorAttribute {
            return AnchorAttribute(view: view, attribute: NSLayoutConstraint.Attribute.width)
        }
        
        public var height: AnchorAttribute {
            return AnchorAttribute(view: view, attribute: NSLayoutConstraint.Attribute.height)
        }
        
        public var centerX: AnchorAttribute {
            return AnchorAttribute(view: view, attribute: NSLayoutConstraint.Attribute.centerX)
        }
        
        public var centerY: AnchorAttribute {
            return AnchorAttribute(view: view, attribute: NSLayoutConstraint.Attribute.centerY)
        }
        
        public var safeArea: AnchorAttribute {
            return AnchorAttribute(view: view, preferrsSafeArea: true)
        }
    }
    
    /// cm = Constraint Maker Abbreviation
    var cm: AnchorAttributes {
        return AnchorAttributes(view: self)
    }
}

private class ConstraintDescriptionItem {
    weak var firstView: UIView?
    var firstViewAttribute: NSLayoutConstraint.Attribute
    weak var secondView: UIView?
    var secondViewAttribute: NSLayoutConstraint.Attribute?
    var firstViewToSecondRelation: NSLayoutConstraint.Relation?
    var multiplier: CGFloat = 1.0
    var constant: CGFloat = 0.0
    var priority: UILayoutPriority = UILayoutPriority.required
    var preferrsSafeArea: Bool = false
    
    init(firstView: UIView?, attribute: NSLayoutConstraint.Attribute) {
        self.firstView = firstView
        self.firstViewAttribute = attribute
    }
    
    func makeConstraint() -> NSLayoutConstraint? {
        let secondAttribute = secondViewAttribute ?? firstViewAttribute
        guard
            let firstView = firstView,
            let relation = firstViewToSecondRelation
            else {
                return nil
        }
        let toItem = preferrsSafeArea ? secondView?.safeAreaLayoutGuide : secondView
        let constraint: NSLayoutConstraint = NSLayoutConstraint(item: firstView, attribute: firstViewAttribute, relatedBy: relation,
                                                                toItem: toItem, attribute: secondAttribute, multiplier: multiplier,
                                                                constant: constant)
        constraint.priority = priority
        return constraint
    }
}

fileprivate extension Array where Element == ConstraintDescriptionItem {
    func makeConstraints() -> [NSLayoutConstraint] {
        var result: [NSLayoutConstraint] = []
        for item in self {
            if let constraint = item.makeConstraint() {
                result.append(constraint)
            }
        }
        return result
    }
    
    func applyConstant(_ offset: CGFloat) {
        for item in self {
            item.constant = offset
        }
    }
    
    func applyPriority(_ priority: UILayoutPriority) {
        for item in self {
            item.priority = priority
        }
    }
    
    func applyMultiplier(_ multiplier: CGFloat) {
        for item in self {
            item.multiplier = multiplier
        }
    }
    
    func applyRelation(_ relation: NSLayoutConstraint.Relation) {
        for item in self {
            item.firstViewToSecondRelation = relation
        }
    }
    
    func applyRelation(_ relation: NSLayoutConstraint.Relation, secondView: UIView?) {
        for item in self {
            item.secondView = secondView
            item.firstViewToSecondRelation = relation
        }
    }
    
    func applyRelation(_ relation: NSLayoutConstraint.Relation, attribute: UIView.AnchorAttribute) {
        for item in self {
            item.secondView = attribute.view
            item.secondViewAttribute = attribute.attribute
            item.firstViewToSecondRelation = relation
            item.preferrsSafeArea = attribute.preferrsSafeArea
        }
    }
}
