public protocol Hook {

}

protocol _AnyHookWrapper: Hook {
    associatedtype Object

    var object: Object { get }
    func prepare(object: Object?)
}

extension _AnyHookWrapper {
    func _prepareAny(object: Any?) {
        prepare(object: object.map { $0 as! Object })
    }
}
