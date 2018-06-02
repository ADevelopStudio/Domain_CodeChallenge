// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import UIKit


public protocol LayoutItem { // `UIView`, `UILayoutGuide`
    var superview: UIView? { get }
}

extension UIView: LayoutItem {}
extension UILayoutGuide: LayoutItem {
    public var superview: UIView? { return self.owningView }
}

public extension LayoutItem { // Yalta methods available via `LayoutProxy`
    @nonobjc public var al: LayoutProxy<Self> { return LayoutProxy(base: self) }
}

public struct LayoutProxy<Base> {
    public let base: Base
}

extension LayoutProxy where Base: LayoutItem {

    // MARK: Anchors

    public var top: Anchor<AnchorTypeEdge, AnchorAxisVertical> { return Anchor(base, .top) }
    public var bottom: Anchor<AnchorTypeEdge, AnchorAxisVertical> { return Anchor(base, .bottom) }
    public var left: Anchor<AnchorTypeEdge, AnchorAxisHorizontal> { return Anchor(base, .left) }
    public var right: Anchor<AnchorTypeEdge, AnchorAxisHorizontal> { return Anchor(base, .right) }
    public var leading: Anchor<AnchorTypeEdge, AnchorAxisHorizontal> { return Anchor(base, .leading) }
    public var trailing: Anchor<AnchorTypeEdge, AnchorAxisHorizontal> { return Anchor(base, .trailing) }

    public var centerX: Anchor<AnchorTypeCenter, AnchorAxisHorizontal> { return Anchor(base, .centerX) }
    public var centerY: Anchor<AnchorTypeCenter, AnchorAxisVertical> { return Anchor(base, .centerY) }

    public var firstBaseline: Anchor<AnchorTypeBaseline, AnchorAxisVertical> { return Anchor(base, .firstBaseline) }
    public var lastBaseline: Anchor<AnchorTypeBaseline, AnchorAxisVertical> { return Anchor(base, .lastBaseline) }

    public var width: Anchor<AnchorTypeDimension, AnchorAxisHorizontal> { return Anchor(base, .width) }
    public var height: Anchor<AnchorTypeDimension, AnchorAxisVertical> { return Anchor(base, .height) }

    // MARK: Anchor Collections

    public func edges(_ edges: LayoutEdge...) -> AnchorCollectionEdges { return AnchorCollectionEdges(item: base, edges: edges) }
    public var edges: AnchorCollectionEdges { return AnchorCollectionEdges(item: base, edges: [.left, .right, .bottom, .top]) }
    public var center: AnchorCollectionCenter { return AnchorCollectionCenter(x: centerX, y: centerY) }
    public var size: AnchorCollectionSize { return AnchorCollectionSize(width: width, height: height) }
}

extension LayoutProxy where Base: UIView {
    public var margins: LayoutProxy<UILayoutGuide> { return base.layoutMarginsGuide.al }

    @available(iOS 11.0, tvOS 11.0, *)
    public var safeArea: LayoutProxy<UILayoutGuide> { return base.safeAreaLayoutGuide.al }
}


// MARK: Anchors

public class AnchorAxisHorizontal {} // phantom types
public class AnchorAxisVertical {}

public class AnchorTypeDimension {}
public class AnchorTypeCenter: AnchorTypeAlignment {}
public class AnchorTypeEdge: AnchorTypeAlignment {}
public class AnchorTypeBaseline: AnchorTypeAlignment {}

/// Includes `center`, `edge` and `baselines` anchors.
public protocol AnchorTypeAlignment {}

/// A type that represents one of the view's layout attributes (e.g. `left`,
/// `centerX`, `width`, etc). Use the anchor’s methods to construct constraints.
public struct Anchor<Type, Axis> { // type and axis are phantom types
    internal let item: LayoutItem
    internal let attribute: NSLayoutAttribute
    internal let offset: CGFloat

    init(_ item: LayoutItem, _ attribute: NSLayoutAttribute, _ offset: CGFloat = 0) {
        self.item = item
        self.attribute = attribute
        self.offset = offset
    }
}

extension Anchor {
    /// Returns a new anchor offset by a given amount.
    public func offsetting(by offset: CGFloat) -> Anchor<Type, Axis> {
        return Anchor<Type, Axis>(item, attribute, self.offset + offset)
    }
}

extension Anchor where Type: AnchorTypeAlignment {
    /// Aligns two anchors.
    @discardableResult public func align<Type: AnchorTypeAlignment>(with anchor: Anchor<Type, Axis>, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return Constraints.constrain(self, anchor, offset: offset, multiplier: multiplier, relation: relation)
    }
}

extension Anchor where Type: AnchorTypeEdge {
    /// Pins the edge to the same edge of the superview.
    @discardableResult public func pinToSuperview(inset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return _pin(to: item.superview!, attribute: attribute, inset: inset, relation: relation)
    }

    /// Pins the edge to the respected margin of the superview.
    @discardableResult public func pinToSuperviewMargin(inset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return _pin(to: item.superview!, attribute: attribute.toMargin, inset: inset, relation: relation)
    }

    /// Pins the edge to the respected edges of the given container.
    @discardableResult public func pin(to container: LayoutItem, inset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return _pin(to: container, attribute: attribute, inset: inset, relation: relation)
    }

    /// Pins the edge to the safe area of the view controller.
    /// Falls back to layout guides on iOS 10.
    @discardableResult public func pinToSafeArea(of vc: UIViewController, inset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        let item2: Any
        var attr2 = self.attribute
        if #available(iOS 11, tvOS 11, *) {
            item2 = vc.view.safeAreaLayoutGuide
        } else {
            switch attr2 {
            case .top:
                item2 = vc.topLayoutGuide
                attr2 = .bottom // pin self.top to topLayoutGuide.bottom
            case .bottom:
                item2 = vc.bottomLayoutGuide
                attr2 = .top // pin self.bottom to bottomLayoutGuide.top
            default: item2 = vc.view
            }
        }
        return _pin(to: item2, attribute: attr2, inset: inset, relation: relation)
    }

    private func _pin(to item2: Any, attribute attr2: NSLayoutAttribute, inset: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        let isInverted = [.trailing, .right, .bottom].contains(attribute)
        return Constraints.constrain(self, toItem: item2, attribute: attr2, offset: (isInverted ? -inset : inset), relation: (isInverted ? relation.inverted : relation))
    }
}

extension Anchor where Type: AnchorTypeCenter {
    /// Aligns the axis with a superview axis.
    @discardableResult public func alignWithSuperview(offset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return align(with: Anchor<Type, Axis>(self.item.superview!, self.attribute), offset: offset, relation: relation)
    }
}

extension Anchor where Type: AnchorTypeDimension {
    /// Sets the dimension to a specific size.
    @discardableResult public func set(_ constant: CGFloat, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return Constraints.constrain(item: item, attribute: attribute, relatedBy: relation, constant: constant)
    }

    @discardableResult public func match<Axis>(_ anchor: Anchor<AnchorTypeDimension, Axis>, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return Constraints.constrain(self, anchor, offset: offset, multiplier: multiplier, relation: relation)
    }
}


// MARK: Anchor Collections

public struct AnchorCollectionEdges {
    internal let item: LayoutItem
    internal let edges: [LayoutEdge]
    private var anchors: [Anchor<AnchorTypeEdge, Any>] { return edges.map { Anchor(item, $0.attribute) } }

    /// Pins the edges of the view to the edges of the superview so the the view
    /// fills the available space in a container.
    @discardableResult public func pinToSuperview(insets: UIEdgeInsets = .zero, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return anchors.map { $0.pinToSuperview(inset: insets.inset(for: $0.attribute), relation: relation) }
    }

    /// Pins the edges of the view to the margins of the superview so the the view
    /// fills the available space in a container.
    @discardableResult public func pinToSuperviewMargins(insets: UIEdgeInsets = .zero, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return anchors.map { $0.pinToSuperviewMargin(inset: insets.inset(for: $0.attribute), relation: relation) }
    }

    /// Pins the edges of the view to the edges of the given view so the the
    /// view fills the available space in a container.
    @discardableResult public func pin(to item2: LayoutItem, insets: UIEdgeInsets = .zero, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return anchors.map { $0.pin(to: item2, inset: insets.inset(for: $0.attribute), relation: relation) }
    }

    /// Pins the edges to the safe area of the view controller.
    /// Falls back to layout guides on iOS 10.
    @discardableResult public func pinToSafeArea(of vc: UIViewController, insets: UIEdgeInsets = .zero, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return anchors.map { $0.pinToSafeArea(of: vc, inset: insets.inset(for: $0.attribute), relation: relation) }
    }
}

public struct AnchorCollectionCenter {
    internal let x: Anchor<AnchorTypeCenter, AnchorAxisHorizontal>
    internal let y: Anchor<AnchorTypeCenter, AnchorAxisVertical>

    /// Centers the view in the superview.
    @discardableResult public func alignWithSuperview() -> [NSLayoutConstraint] {
        return [x.alignWithSuperview(), y.alignWithSuperview()]
    }

    /// Makes the axis equal to the other collection of axis.
    @discardableResult public func align(with anchors: AnchorCollectionCenter) -> [NSLayoutConstraint] {
        return [x.align(with: anchors.x), y.align(with: anchors.y)]
    }
}

public struct AnchorCollectionSize {
    internal let width: Anchor<AnchorTypeDimension, AnchorAxisHorizontal>
    internal let height: Anchor<AnchorTypeDimension, AnchorAxisVertical>

    /// Set the size of item.
    @discardableResult public func set(_ size: CGSize, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return [width.set(size.width, relation: relation), height.set(size.height, relation: relation)]
    }

    /// Makes the size of the item equal to the size of the other item.
    @discardableResult public func match(_ anchors: AnchorCollectionSize, insets: CGSize = .zero, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return [width.match(anchors.width, offset: -insets.width, multiplier: multiplier, relation: relation),
                height.match(anchors.height, offset: -insets.height, multiplier: multiplier, relation: relation)]
    }
}


// MARK: Constraints

public final class Constraints {
    internal(set) var constraints = [NSLayoutConstraint]()

    /// All of the constraints created in the given closure are automatically
    /// activated at the same time. This is more efficient then installing them
    /// one-be-one. More importantly, it allows to make changes to the constraints
    /// before they are installed (e.g. change `priority`).
    @discardableResult public init(_ closure: () -> Void) {
        Constraints._stack.append(self)
        closure() // create constraints
        Constraints._stack.removeLast()
        NSLayoutConstraint.activate(constraints)
    }

    /// Creates and automatically installs a constraint.
    internal static func constrain(item item1: Any, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation = .equal, toItem item2: Any? = nil, attribute attr2: NSLayoutAttribute? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        precondition(Thread.isMainThread, "Yalta APIs can only be used from the main thread")
        (item1 as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: item1, attribute: attr1, relatedBy: relation, toItem: item2, attribute: attr2 ?? .notAnAttribute, multiplier: multiplier, constant: constant)
        _install(constraint)
        return constraint
    }

    /// Creates and automatically installs a constraint between two anchors.
    internal static func constrain<T1, A1, T2, A2>(_ lhs: Anchor<T1, A1>, _ rhs: Anchor<T2, A2>, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return constrain(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: rhs.item, attribute: rhs.attribute, multiplier: multiplier, constant: offset - lhs.offset + rhs.offset)
    }

    /// Creates and automatically installs a constraint between an anchor and
    /// a given item.
    internal static func constrain<T1, A1>(_ lhs: Anchor<T1, A1>, toItem item2: Any?, attribute attr2: NSLayoutAttribute?, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return constrain(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: item2, attribute: attr2, multiplier: multiplier, constant: offset - lhs.offset)
    }

    private static var _stack = [Constraints]() // this is what enabled constraint auto-installing

    private static func _install(_ constraint: NSLayoutConstraint) {
        if _stack.isEmpty { // not creating a group of constraints
            constraint.isActive = true
        } else { // remember which constaints to install when group is completed
            let group = _stack.last!
            group.constraints.append(constraint)
        }
    }
}

// MARK: Misc

public enum LayoutEdge {
    case top, bottom, leading, trailing, left, right

    internal var attribute: NSLayoutAttribute {
        switch self {
        case .top: return .top;          case .bottom: return .bottom
        case .leading: return .leading;  case .trailing: return .trailing
        case .left: return .left;        case .right: return .right
        }
    }
}

internal extension NSLayoutAttribute {
    var toMargin: NSLayoutAttribute {
        switch self {
        case .top: return .topMargin;           case .bottom: return .bottomMargin
        case .leading: return .leadingMargin;   case .trailing: return .trailingMargin
        case .left: return .leftMargin          case .right: return .rightMargin
        default: return self
        }
    }
}

internal extension NSLayoutRelation {
    var inverted: NSLayoutRelation {
        switch self {
        case .greaterThanOrEqual: return .lessThanOrEqual
        case .lessThanOrEqual: return .greaterThanOrEqual
        case .equal: return self
        }
    }
}

internal extension UIEdgeInsets {
    func inset(for attribute: NSLayoutAttribute) -> CGFloat {
        switch attribute {
        case .top: return top; case .bottom: return bottom
        case .left, .leading: return left
        case .right, .trailing: return right
        default: return 0
        }
    }
}
