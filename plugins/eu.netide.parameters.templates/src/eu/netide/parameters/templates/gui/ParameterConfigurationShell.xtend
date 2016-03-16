package eu.netide.parameters.templates.gui

import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import com.fasterxml.jackson.databind.node.JsonNodeFactory
import com.fasterxml.jackson.databind.node.ObjectNode
import com.fasterxml.jackson.databind.node.TextNode
import eu.netide.parameters.language.paramschema.AtomicType
import eu.netide.parameters.language.paramschema.BasicType
import eu.netide.parameters.language.paramschema.CompositeType
import eu.netide.parameters.language.paramschema.Enum
import eu.netide.parameters.language.paramschema.Keyval
import eu.netide.parameters.language.paramschema.ListType
import eu.netide.parameters.language.paramschema.ParameterSchema
import eu.netide.parameters.language.paramschema.Type
import eu.netide.parameters.language.paramschema.TypeReference
import java.util.HashMap
import java.util.List
import org.eclipse.core.resources.IFile
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.swt.SWT
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.events.SelectionListener
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Combo
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.Shell
import org.eclipse.swt.widgets.Text
import org.eclipse.xtend.lib.annotations.Accessors

class ParameterConfigurationShell extends Shell {

	HashMap<String, ParameterSchema> schemas
	ParameterConfigurationShell shell
	Composite composite;
	@Accessors(PUBLIC_GETTER)
	ObjectNode root;

	IFile file

	new(Display display, HashMap<String, ParameterSchema> schemas, IFile file) {
		super(display, SWT.SHELL_TRIM)
		this.shell = this
		this.file = file
		this.schemas = schemas
		createControl(shell)
	}

	new(Display display, HashMap<String, ParameterSchema> schemas, IFile file, ObjectNode node) {
		this(display, schemas, file)
		populate(node)
	}

	def createControl(Shell shell) {
		var layout = new GridLayout(1, true)
		shell.layout = layout
		shell.setSize(400, 600)
		val comp = new Composite(shell, SWT.NONE)
		comp.layout = new GridLayout(1, true)
		comp.layoutData = new GridData(SWT.FILL, SWT.FILL, true, false)
		this.composite = comp

		this.schemas.forEach [ k, v |
			var gridlayout = new GridLayout(2, true)
			var groupData = new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1);
			val group = new Group(comp, SWT.NONE)
			group.layoutData = groupData
			group.layout = gridlayout
			group.text = k.replaceAll("_", " ").split(" ").map[toFirstUpper].reduce[p1, p2|p1 + " " + p2]
			group.setData("name", k)
			makeTypeGroup(group, v.paramspec.parameters)
		]

		var btncomp = new Composite(shell, SWT.NONE)
		btncomp.layout = new GridLayout(2, true)
		var cancel = new Button(btncomp, SWT.NONE)
		cancel.text = "Cancel"
		cancel.addSelectionListener(new SelectionListener() {
			override widgetSelected(SelectionEvent e) { cancel() }

			override widgetDefaultSelected(SelectionEvent e) { cancel() }

		})
		var ok = new Button(btncomp, SWT.NONE)
		ok.text = "Save"
		ok.addSelectionListener(new SelectionListener() {
			override widgetDefaultSelected(SelectionEvent e) { save() }

			override widgetSelected(SelectionEvent e) { save() }
		})

	}

	def void makeTypeGroup(Composite parent, List<Keyval> types) {
		types.forEach [ e |
			if (e.type instanceof AtomicType) {
				var type = e.type as AtomicType
				var label = new Label(parent, SWT.NONE)
				label.text = String.format("%s (%s)", e.name.prettyfy, type.name)
				makeAtomicType(parent, e.name, type, e.defaultValue)

			} else if (e.type instanceof Enum) {
				var type = e.type as Enum
				var label = new Label(parent, SWT.NONE)
				label.text = e.name.prettyfy
				makeEnumType(parent, e.name, type, e.defaultValue)

			} else if (e.type instanceof TypeReference) {
				var type = (e.type as TypeReference)
				if (type.type instanceof BasicType) {
					var btype = type.type as BasicType
					var label = new Label(parent, SWT.NONE)
					label.text = String.format("%s (%s)", e.name.prettyfy, btype.name)

					if (btype.atomictype instanceof AtomicType) {
						makeAtomicType(parent, e.name, btype.atomictype as AtomicType, e.defaultValue)
					}
					if (btype.atomictype instanceof Enum) {
						makeEnumType(parent, e.name, btype.atomictype as Enum, e.defaultValue)
					}

				} else if (type.type instanceof CompositeType) {
					var ctype = type.type as CompositeType
					var group = new Group(parent, SWT.NONE)
					group.layout = new GridLayout(2, true)
					group.layoutData = new GridData(SWT.FILL, SWT.FILL, true, false, 2, 1)
					group.setData("name", e.name)

					group.text = e.name.prettyfy
					makeTypeGroup(group, ctype.innertypes)
				}
			} else if (e.type instanceof ListType) {
				var ltype = e.type as ListType
				var group = new Group(parent, SWT.NONE)
				group.layout = new GridLayout(2, false)
				group.layoutData = new GridData(SWT.FILL, SWT.FILL, true, false, 2, 1)
				group.text = e.name.prettyfy
				makeListType(group, ltype.type)
			} else {
				new Label(parent, SWT.NONE)
			}
		]
	}

	def makeListType(Group group, Type type) {
		var list = new org.eclipse.swt.widgets.List(group, SWT.BORDER)
		list.layoutData = new GridData(SWT.FILL, SWT.FILL, true, false)

		var comp = new Composite(group, SWT.NONE)
		comp.layout = new GridLayout(1, true)
		list.layoutData = new GridData(SWT.FILL, SWT.FILL, true, false)

		var add = new Button(comp, SWT.NONE)
		add.text = "Add"

		var remove = new Button(comp, SWT.NONE)
		remove.text = "Remove"

	}

	def makeEnumType(Composite parent, String name, Enum type, String defaultValue) {
		val box = new Combo(parent, SWT.READ_ONLY)
		type.values.forEach[v|box.add(v)]
		box.layoutData = new GridData(SWT.FILL, SWT.FILL, true, false)
		box.setData("name", name)
		box.text = defaultValue ?: box.items.get(0)
	}

	def makeAtomicType(Composite parent, String name, AtomicType type, String defaultValue ) {
		if (type.name == "Integer" || type.name == "String" || type.name == "Float") {
			var text = new Text(parent, SWT.BORDER)
			text.layoutData = new GridData(SWT.FILL, SWT.FILL, true, false)
			text.setData("name", name)
			text.text = defaultValue ?: ""
		} else if (type.name == "Boolean") {
			var check = new Button(parent, SWT.CHECK)
			check.setData("name", name)
			check.selection = (defaultValue != null && defaultValue == "true")
		}
	}

	def save() {
		var om = new ObjectMapper();
		root = JsonNodeFactory.instance.objectNode

		writeNode(root, this.composite)
		om.enable(SerializationFeature.INDENT_OUTPUT);
		om.writerWithDefaultPrettyPrinter.writeValue(file.location.toFile, root)
		// om.writeTree(new JsonFactory().createGenerator(file.location.toFile, JsonEncoding.UTF8), root)
		file.refreshLocal(1, new NullProgressMonitor)
		this.shell.close

	}

	def void writeNode(ObjectNode node, Composite comp) {
		for (c : comp.children) {
			if (c instanceof Group && c.getData("name") != null) {
				var subnode = JsonNodeFactory.instance.objectNode
				node.set(c.getData("name") as String, subnode)
				writeNode(subnode, c as Group)
			} else if (c instanceof Text) {
				var text = JsonNodeFactory.instance.textNode((c as Text).text)
				node.set(c.getData("name") as String, text)
			} else if (c instanceof Button) {
				var text = JsonNodeFactory.instance.textNode("" + (c as Button).selection)
				node.set(c.getData("name") as String, text)
			} else if (c instanceof Combo) {
				var text = JsonNodeFactory.instance.textNode("" + (c as Combo).text)
				node.set(c.getData("name") as String, text)
			}
		}
	}

	def populate(ObjectNode node) {
		readNode(node, this.composite)
	}

	def void readNode(ObjectNode node, Composite comp) {
		for (c : comp.children) {
			if (c instanceof Group && c.getData("name") != null) {
				if (node.has(c.getData("name") as String)) {
					var subnode = node.get(c.getData("name") as String) as ObjectNode
					readNode(subnode, c as Group)
				}
			} else if (c instanceof Text) {
				if (node.has(c.getData("name") as String)) {
					(c as Text).text = (node.get(c.getData("name") as String) as TextNode).textValue
				}
			} else if (c instanceof Button) {
				if (node.has(c.getData("name") as String)) {
					(c as Button).selection = (node.get(c.getData("name") as String) as TextNode).textValue == "true"
				}
			} else if (c instanceof Combo) {
				if (node.has(c.getData("name") as String)) {
					(c as Combo).text = (node.get(c.getData("name") as String) as TextNode).textValue
				}
			}
		}
	}

	def cancel() {
		this.shell.close
	}

	override void checkSubclass() {
		// Disable the check that prevents subclassing of SWT components
	}

	def prettyfy(String s) {
		s.replaceAll("_", " ").split(" ").map[toFirstUpper].reduce[p1, p2|p1 + " " + p2]
	}

}
