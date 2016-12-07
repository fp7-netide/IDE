import eu.netide.deployment.topologyvalidation.matcher.ViatraSearcher

class Searcher {
	def static void main(String[] args) {

		// initialize searcher
		val vs = new ViatraSearcher<Clos>(Clos)[
			return new Clos("TestClos", it)
		]

		// run search function
		// there is also a lambda based version to hook into the search tree ;)
		val results = vs.search("model/TestCase1.topology", 5)

		println("Results:")
		println("")

		results.forEach[result|

			// output matched switch count
			println("Switches matched:")
			println(result.matches.head.parameterNames.size)

			// output result count
			println("Count of different matches:")
			println(result.matches.size)

			// output valid parameters
			println("FlexTopo Parameters used to find matches:")
			println(result.parameterMap)

			println("")
			println("##############")
		]
	}
}