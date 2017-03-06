package eu.netide.zmq.hub.server

import org.eclipse.ui.PlatformUI
import org.eclipse.xtend.lib.annotations.Accessors
import org.zeromq.ZMQ
import org.zeromq.ZMQException
import org.zeromq.ZMQ.Context

class ZmqSendReceiveHub implements IZmqSendReceiveHub {

	var Context ctx
	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)
	private String address

	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER)
	private String name

	new(String name, String address) {
		this.name = name
		this.address = address

	}

	new(String address) {
		this("", address)
	}

	override void send(String msg) {
//		var ctx = ZMQ.context(1)
		if (ctx == null) ctx = ZMQ.context(1)
		var req = ctx.socket(ZMQ.REQ)
		req.receiveTimeOut = 100
		try {
			req.connect(address)
			req.send(msg.bytes, 0)
			req.recv()
		} catch (ZMQException e) {
			e.printStackTrace
		} catch (ArrayIndexOutOfBoundsException e) {
			e.printStackTrace
		} catch (Exception e) {
			e.printStackTrace
		} finally {
			req.close
		}
	}

	override void send(String msg, (String)=>void success) {
		var t = new Thread("Sending") {
			override run() {
				super.run()
				var ctx = ZMQ.context(1)
				var req = ctx.socket(ZMQ.REQ)
				req.receiveTimeOut = 100
				try {
					req.connect(address)
					req.send(msg.bytes, 0)
					val received = req.recv()
					if (received != null) {
						success.apply(new String(received))
					}
				} catch (ZMQException e) {
//					req = ctx.socket(ZMQ.REQ)
				} catch (ArrayIndexOutOfBoundsException e) {
					e.printStackTrace
				} finally {
					req.close
					ctx.close
				}

			}

		}
		PlatformUI.workbench.activeWorkbenchWindow.shell.display.asyncExec(t)

	}

	public override getName() {
		return name
	}

}
