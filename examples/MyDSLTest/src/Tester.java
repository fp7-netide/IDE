import java.util.Collection;

import org.eclipse.viatra.query.runtime.api.IPatternMatch;

import Topology.Switch;
import eu.netide.deployment.topologyvalidation.matcher.ViatraManager;

public class Tester {

	public static void main(String[] args) {
		Clos c = new Clos("TestClos", 2, 2);

		c.generateTopoRestriction();
		c.render("model/MyTest.topology");
		c.generateViatraQuery(ViatraManager.GENERATED_PATTERN_PATH);

		ViatraManager vm = new ViatraManager();
		vm.setImportedModelUri("model/TestCase1.topology");
		Collection<? extends IPatternMatch> matches = vm.getMatchSet();

		IPatternMatch match = matches.iterator().next();	// get first match

		System.out.println(matches.size()); // print match count
		match.prettyPrint();

		System.out.println(match.specification().getParameters().get(0).getName());
		System.out.println(((Switch)match.get(0)).getName());
	}
}
