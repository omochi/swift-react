package protocol _AnyHookWrapper {
    var _anyHookObject: any _AnyHookObject { get }
}

package protocol _AnyHookObject: AnyObject {
    func _take(fromAnyHookObject object: any _AnyHookObject)
}
