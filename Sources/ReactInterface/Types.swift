public protocol ReactNode {}

public protocol ReactComponent: ReactNode {
    func render() -> (any ReactNode)?
}
