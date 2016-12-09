package eu.netide.deployment.topologyvalidation.restrictiontopology

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

class GateConnector extends ARestrictable {
	@Accessors IGate left;

	@Accessors IGate right;

	@Accessors(PUBLIC_GETTER, PROTECTED_SETTER) protected boolean resolved = false;

	new(IGate left, IGate right) {
		this.left = left
		this.right = right
	}

	def List<Connection> resolve() {
		if (left === null || right === null) {
			return emptyList
		}

		return left.resolve(right, restrictions);
	}
}
