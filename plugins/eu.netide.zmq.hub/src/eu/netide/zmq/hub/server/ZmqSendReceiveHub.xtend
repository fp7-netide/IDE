package eu.netide.zmq.hub.server

import org.eclipse.xtend.lib.annotations.Accessors
import org.zeromq.ZMQ
import org.zeromq.ZMQ.Context
import org.zeromq.ZMQ.Socket
import org.zeromq.ZMQException

class ZmqSendReceiveHub implements IZmqSendReceiveHub {

	var Socket req
	var Context ctx

	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)
	private String address

	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)
	private String name

	new(String name, String address) {
		this.name = name
		this.address = address
		ctx = ZMQ.context(1)
		req = ctx.socket(ZMQ.REQ)
		req.connect(address)
	}

	new(String address) {
		this("", address)
	}

	override void send(String msg) {
		send(msg, [x | ])
	}

	override void send(String msg, (String)=>void success) {
		var t = new Thread() {
			override run() {
				super.run()

				try {
					req.connect(address)
					req.send(msg.bytes, 0)
					val received = req.recv(0)
					if (received != null) {
						success.apply(new String(received))
					}
				} catch (ZMQException e) {
					req = ctx.socket(ZMQ.REQ)
				}
				catch (ArrayIndexOutOfBoundsException e) {
				}

			}

		}
		t.start

	}

	public override getName() {
		return name
	}

}
