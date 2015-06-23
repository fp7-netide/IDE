#!/usr/bin/python

""" 
 Copyright (c) 2014, NetIDE Consortium (Create-Net (CN), Telefonica Investigacion Y Desarrollo SA (TID), Fujitsu 
 Technology Solutions GmbH (FTS), Thales Communications & Security SAS (THALES), Fundacion Imdea Networks (IMDEA),
 Universitaet Paderborn (UPB), Intel Research & Innovation Ireland Ltd (IRIIL) )
 
 All rights reserved. This program and the accompanying materials
 are made available under the terms of the Eclipse Public License v1.0
 which accompanies this distribution, and is available at
 http://www.eclipse.org/legal/epl-v10.html
 
 Authors:
	Elisa Rojas
"""

###############################################################################################
###        Name: UC2_IITS_NetManager.py
###      Author: Elisa Rojas - elisa.rojas@telcaria.com
### Description: Pyretic Implementation of NetIDE UC2 - Main Module
###############################################################################################

import os

# Pyretic libraries
from pyretic.lib.std     import *
from pyretic.lib.corelib import *

# Generic Pyretic Modules
from Commons          import *
from pyretic.modules.mac_learner      import mac_learner
from Monitor          import Monitor
from RoutingSystem    import RoutingSystem

### Main class for UC2 Integrated IT System Implementation
class UC2_IITS_NetManager(DynamicPolicy):
	def __init__(self):
		super(UC2_IITS_NetManager, self).__init__()
		self.policy = None

		# Initialize and Start
		self.SetInitialState()

	# Initial configuration of DC Application
	def SetInitialState(self):
		# RS configuration

		#Switches IDs
		self.EdgeSwitches = [SW1_ID, SW2_ID, SW1b_ID, SW2b_ID]
		self.AggrSwitches = [SW3_ID, SW3b_ID]
		self.CoreSwitches = [SW4_ID, SW4b_ID] 
		self.SwitchIDs = [SW1_ID, SW2_ID, SW3_ID, SW4_ID, SW1b_ID, SW2b_ID, SW3b_ID, SW4b_ID] 
		#self.SwitchIDs = [self.EdgeSwitches, self.AggrSwitches, self.CoreSwitches]

		#Final host IPs
		self.HostIPs = [ipp1, ipp2, ipp3, ipp4, ipp5] 

		return self.Start()

	# Dynamically update enforced policy based on the last values of all the modules
	def Start(self):
		# Handle ARP
		ARPPkt = match(ethtype=ARP_TYPE)

		# Instantiate Rerouting System
		RS  = RoutingSystem(self.SwitchIDs, self.HostIPs) # self.LB_Device, self.ClientIPs, self.ServerIPs, self.PublicIP

		self.policy = 	(
					#( ARPPkt >> mac_learner() ) +				# ARP - L2 Learning Switches
					RS +         				                # Routing System
					Monitor(MonitoringInterval)				# Monitoring
				)

		return self.policy

################################################################################
### Bootstrap Use Case
################################################################################
def main():
	return UC2_IITS_NetManager()
