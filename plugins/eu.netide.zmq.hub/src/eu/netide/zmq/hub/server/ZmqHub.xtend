package eu.netide.zmq.hub.server

import eu.netide.zmq.hub.client.IZmqHubListener
import java.beans.PropertyChangeListener
import java.beans.PropertyChangeSupport
import java.text.SimpleDateFormat
import java.util.Date
import java.util.List
import org.eclipse.core.databinding.observable.list.WritableList
import org.eclipse.xtend.lib.annotations.Accessors
import org.zeromq.ZMQ
import org.zeromq.ZMQ.Context
import org.zeromq.ZMQ.Socket
import org.zeromq.ZMQException

class ZmqHub implements IZmqHub, Runnable {

	private List<IZmqHubListener> listeners = newArrayList
	private PropertyChangeSupport changes
	private Thread thread;
	private WritableList log;

	var Socket sub
	var Context ctx

	@Accessors(PUBLIC_GETTER)
	private String address
	@Accessors(PUBLIC_GETTER)
	private String name

	new(String name, String address) {
		this.name = name
		this.address = address
		changes = new PropertyChangeSupport(this)
		log = WritableList.withElementType(typeof(StringBuilder))
	}
	
	new (String address) {
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
					listeners.forEach[update(received)]
					log.realm.asyncExec(new Runnable() {
						override run() {
							var date = new Date()
							var ft = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss")
							log.add(new LogMsg(ft.format(date), b.toString))
						}
					})
				}
			}
		} catch (ZMQException e) {
			sub.close
		}

	}
	

	override register(IZmqHubListener listener) {
		listeners.add(listener)
	}

	override remove(IZmqHubListener listener) {
		listeners.remove(listener)
	}

	public def getRunning() {
		return if(this.thread != null) this.thread.alive else false
	}

	public def getLog() {
		return log
	}
	
	public def setName(String name) {
		changes.firePropertyChange("name", this.name, this.name = name)
	}
	
	public def setAddress(String address) {
		changes.firePropertyChange("address", this.address, this.address = address)
	}

	public def setRunning(Boolean running) {
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
