package eu.netide.verificator.views

import java.nio.ByteBuffer
import org.eclipse.xtend.lib.annotations.Accessors
import java.nio.ByteOrder

class NetIDEMessage {

	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)
	byte version
	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)
	byte type
	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)
	short length
	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)
	int xid
	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)
	int module_id
	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)
	long dpid
	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)
	long padding

	new(byte[] bytes) {
		var bb = ByteBuffer.allocate(bytes.length)
		bb.order(ByteOrder.BIG_ENDIAN)
		bb.put(bytes)
		
		this.version = bb.get(0)
		this.type = bb.get(1)
		this.length = bb.getShort(2)
		this.xid = bb.getInt(4)
		this.module_id = bb.getInt(8)
		this.dpid = bb.getLong(12)
	}
	
	public override toString() {
		'''
			Version: «String.format("0x%02X", version)»
			Type: «String.format("0x%02X", type)»
			Length: «length»
			XID: «String.format("0x%04X", xid)»
			MID: «String.format("0x%04X", module_id)»
			DPID: «String.format("0x%08X", dpid)»
		'''
	}
	
	

}
