//  Created by Alexander Skorulis on 31/7/2022.

import Foundation
import Knit

public final class InstanceAggregation<BaseType>: Behavior {
    private let isChild: (Any.Type) -> Bool
    public private(set) var factories = [(Resolver) -> BaseType?]()

    public init(isChild: @escaping (Any.Type) -> Bool) {
        self.isChild = isChild
    }

    public func container<Type, Service>(
        _ container: Container,
        didRegisterType type: Type.Type,
        toService entry: ServiceEntry<Service>,
        withName name: String?
    ) {
        guard isChild(Service.self) else { return }

        if factories.isEmpty {
            container.register([BaseType].self) { resolver in self.factories.compactMap { $0(resolver) } }
        }
        factories.append { $0.resolve(Service.self, name: name) as? BaseType }
    }
}
