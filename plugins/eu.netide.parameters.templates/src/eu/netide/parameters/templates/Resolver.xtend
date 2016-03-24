package eu.netide.parameters.templates

import com.fasterxml.jackson.databind.JsonNode
import com.fasterxml.jackson.databind.node.ArrayNode
import com.fasterxml.jackson.databind.node.BigIntegerNode
import com.fasterxml.jackson.databind.node.BinaryNode
import com.fasterxml.jackson.databind.node.BooleanNode
import com.fasterxml.jackson.databind.node.DecimalNode
import com.fasterxml.jackson.databind.node.DoubleNode
import com.fasterxml.jackson.databind.node.IntNode
import com.fasterxml.jackson.databind.node.LongNode
import com.fasterxml.jackson.databind.node.NullNode
import com.fasterxml.jackson.databind.node.ObjectNode
import com.fasterxml.jackson.databind.node.TextNode
import com.github.jknack.handlebars.ValueResolver
import java.util.AbstractMap
import java.util.Set

public class Resolver implements ValueResolver {

	private static Resolver instance

	def static getInstance() {
		if (instance == null)
			instance = new Resolver
		return instance
	}

	override resolve(Object context, String name) {
		var Object value
		if (context instanceof ArrayNode) {
			try {
				value = resolve(((context as ArrayNode)).get(Integer.parseInt(name)))
			} catch (NumberFormatException ex) {
				value = null
			}

		} else if (context instanceof JsonNode) {
			value = resolve(((context as JsonNode)).get(name))
		}
		return if(value === null) UNRESOLVED else value
	}

	override resolve(Object context) {
		if (context instanceof JsonNode) {
			return resolve((context as JsonNode))
		}
		return UNRESOLVED
	}

	def private Object resolve(JsonNode node) {
		// binary node
		var newnode = switch node {
			ObjectNode: node.toObjectMap
			TextNode: node.textValue
			BinaryNode: node.binaryValue
			BooleanNode: node.booleanValue
			IntNode: node.intValue
			DoubleNode: node.doubleValue
			BigIntegerNode: node.bigIntegerValue
			DecimalNode: node.decimalValue
			LongNode: node.longValue
			NullNode: null
			default: node
			
		}
		return newnode
	}



	 def private toObjectMap(ObjectNode node) {
		
		return new AbstractMap<String, Object>() {
			override Object get(Object key) {
				return resolve(node.get((key as String)))
			}

			override size() {
				return node.size()
			}

			override entrySet() {
				val set = newHashSet()
				node.fields.forEach[e | set.add(e)]
				return set as Set
			}
		}
	}

	override propertySet(Object context) {
		if (context instanceof ObjectNode) {
			val node = (context as ObjectNode)
			var names = node.fieldNames()
			val result = newLinkedHashMap()
			names.forEach[k |
				result.put(k, resolve(node, k))
			]
			return result.entrySet()
		}
		return newHashSet()
	}

}
