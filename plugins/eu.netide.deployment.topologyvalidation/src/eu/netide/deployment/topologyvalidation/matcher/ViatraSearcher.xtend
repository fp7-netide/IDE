package eu.netide.deployment.topologyvalidation.matcher

import eu.netide.deployment.topologyvalidation.restrictiontopology.ARootTopoModule
import java.util.HashMap
import java.util.LinkedList
import java.util.Map
import java.util.function.Function
import java.util.function.Predicate

public class ViatraSearcher<T extends ARootTopoModule> {

	private Function<Map<String, Object>, T> creator
	private Class<? extends ARootTopoModule> clazz
	private Map<String, Class<?>> paramTypeMap
	private Map<Class<?>, Object> typeLimitMap

	new(Class<T> clazz, Function<Map<String, Object>, T> creator) {
		this.clazz = clazz
		this.creator = creator
		calculateParameterTypeMap(clazz)
		typeLimitMap = new HashMap<Class<?>, Object>
	}

	/*
	 * TOOD: introduce timeout and limitation functions
	 */
	def LinkedList<MatchResult> search(String modelURI, Integer maxInt) {
		val results = new LinkedList<MatchResult>

		search(modelURI, maxInt)[
			results.add(it)
		]

		return results
	}
	def void search(String modelURI, Integer maxInt, Predicate<MatchResult> func) {
		typeLimitMap.put(Integer, maxInt)

		val permutations = calculateParameterPermutations

		for (parameterMap: permutations) {
			var flexTopology = creator.apply(parameterMap)
			val matches = flexTopology.process(modelURI)
			if (!matches.empty) {
				func.test(new MatchResult(matches, parameterMap))
			}
		}
	}

	def private process(T flexTopo, String modelURI) {
		flexTopo.generateTopoRestriction();
		// flexTopo.render("model/MyTest.topology");
		flexTopo.generateViatraQuery(ViatraManager.GENERATED_PATTERN_PATH);

		val vm = new ViatraManager();
		vm.setImportedModelUri("model/TestCase1.topology");
		vm.getMatchSet();
	}

	def private calculateParameterTypeMap(Class<T> clazz) {
		paramTypeMap = new HashMap<String, Class<?>>()
		clazz.declaredFields.forEach [
			paramTypeMap.put(it.name, it.type)
		]
	}

	def private HashMap<String, Object> calculateInitialParameterMap() {
		val paramMap = new HashMap<String, Object>
		paramTypeMap.forEach[name, type|
			paramMap.put(name, type.initialValue)
		]
		return paramMap
	}

	def private getInitialValue(Class<?> type) {

		if (type == Integer)
			return 1
		else if (type == String)
			return ""

	}

	// default limit check is true
	def private dispatch checkLimit(Object obj) {
		return true
	}

	def private dispatch checkLimit(Integer obj) {
		val limit = typeLimitMap.get(Integer) as Integer
		return limit >= obj
	}

	def private Boolean checkLimits(HashMap<String, Object> map) {
		for (value : map.values) {
			if (!value.checkLimit)
				return false
		}
		return true
	}

	def private calculateParameterPermutations() {
		val permutations = new LinkedList<HashMap<String, Object>>

		// inital permutation
		var paramMap = this.calculateInitialParameterMap()
		paramMap.checkLimits
		permutations.add(paramMap)

		var allLimitsReached = false
		while (!allLimitsReached) {
			allLimitsReached = true

			for (key : paramTypeMap.keySet()) {
				val type = paramTypeMap.get(key)
				if (type == Integer) {

					paramMap = new HashMap<String, Object>(paramMap)
					val oldVal = paramMap.get(key) as Integer
					paramMap.put(key, oldVal+1)
					val check = paramMap.checkLimits
					if (check) {
						permutations.add(paramMap)
					}

					if (allLimitsReached)
						allLimitsReached = !check
				}
			}
		}

		return permutations
	}
}
