package eu.netide.deployment.topologyvalidation.restrictiontopology

import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors

class ValSwitch extends ARestrictable implements IModule {

	public static final String GATE_IDENTIFIER = "gate"

	@Accessors protected String name = ""
	@Accessors protected Map<String, IGate> gates = new HashMap<String, IGate>

	new(String n) {
		name = n
		this.gates.put(GATE_IDENTIFIER, new Gate(this))
	}

	new(String n, String r) {
		this(n)
		addRestriction(new Restriction(r))
	}

	override List<Connection> resolve() {
		emptyList
	}

	override getGateConnectors() {
		emptyList()
	}

}
