package eu.netide.zmq.hub.server

import java.beans.PropertyChangeListener
import java.beans.PropertyChangeSupport
import java.text.SimpleDateFormat
import java.util.Date
import java.util.List
import org.eclipse.core.databinding.observable.list.WritableList
import org.zeromq.ZMQ
import org.zeromq.ZMQ.Context
import org.zeromq.ZMQ.Socket
import org.zeromq.ZMQException
import eu.netide.lib.netip.NetIPConverter
import eu.netide.zmq.hub.client.IZmqRawListener
import eu.netide.zmq.hub.client.IZmqNetIpListener

class ZmqHub implements IZmqHub, Runnable {

	private List<IZmqRawListener> rawListeners = newArrayList
	private List<IZmqNetIpListener> netIpListeners = newArrayList
	private PropertyChangeSupport changes
	private Thread thread;
	private WritableList<LogMsg> log;

	var Socket sub
	var Context ctx

	private String address

	private String name

	new(String name, String address) {
		this.name = name
		this.address = address
		changes = new PropertyChangeSupport(this)
		log = WritableList.withElementType(typeof(StringBuilder))
	}

	new(String address) {
		this("", address)
	}

	override void run() {
		ctx = ZMQ.context(1)
		sub = ctx.socket(ZMQ.SUB)
		sub.connect(address)
		sub.subscribe("".bytes)

		try {
			while (!this.thread.interrupted) {
				val received = sub.recv(0)
				if (received != null) {
					val b = new StringBuilder();
					b.append("[");
					for (byte r : received) {
						b.append(Integer.toHexString(r))
						b.append(":")
					}
					b.deleteCharAt(b.length() - 1);
					b.append("]");
					send(received)
					log.realm.asyncExec(
						new Runnable() {
							override run() {
								var date = new Date()
								var ft = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss")
								try {
									log.add(
										new LogMsg(ft.format(date),
											NetIPConverter.parseConcreteMessage(received).toString))
								} catch (IllegalArgumentException e) {
									log.add(new LogMsg(ft.format(date), b.toString))
								}
							}

						})

				}
			}
		} catch (ZMQException e) {
			sub.close
		}

	}

	private def send(byte[] message) {
		try {
			val nipMessage = NetIPConverter.parseConcreteMessage(message)
			netIpListeners.forEach[update(nipMessage)]
		} catch (IllegalArgumentException e) {
			
		} finally {
			rawListeners.forEach[update(message)]
		}
	}

	override register(IZmqRawListener listener) {
		rawListeners.add(listener)
	}

	override register(IZmqNetIpListener listener) {
		netIpListeners.add(listener)
	}

	override remove(IZmqRawListener listener) {
		rawListeners.remove(listener)
	}

	override remove(IZmqNetIpListener listener) {
		rawListeners.remove(listener)
	}

	public override getRunning() {
		return if(this.thread != null) this.thread.alive else false
	}

	public def getLog() {
		return log
	}

	public override getName() {
		return name
	}

	public override setName(String name) {
		changes.firePropertyChange("name", this.name, this.name = name)
	}

	public override getAddress() {
		return address
	}

	public override setAddress(String address) {
		changes.firePropertyChange("address", this.address, this.address = address)
	}

	override setRunning(Boolean running) {
		if (running && !this.getRunning()) {
			this.thread = new Thread(this)
			this.thread.start
			changes.firePropertyChange("running", false, running)
		} else if (this.getRunning) {
			this.ctx.term
			this.thread.interrupt
			this.thread.join
			changes.firePropertyChange("running", true, running)
		}
	}

	public def void addPropertyChangeListener(PropertyChangeListener l) {
		changes.addPropertyChangeListener(l);
	}

	public def void addPropertyChangeListener(String propertyName, PropertyChangeListener listener) {
		changes.addPropertyChangeListener(propertyName, listener);
	}

	public def void removePropertyChangeListener(PropertyChangeListener l) {
		changes.removePropertyChangeListener(l);
	}

}
