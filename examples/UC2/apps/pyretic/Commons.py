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
###        Name: Commons.py
###      Author: Elisa Rojas - elisa.rojas@telcaria.com
### Description: Global variables for Pyretic Modules
###############################################################################################

# Pyretic libraries
from pyretic.lib import *
from pyretic.lib.corelib import *
from pyretic.lib.std import *

################### IP Setup ##################
# Hosts
ipp1 = IPAddr('10.0.1.11')
ipp2 = IPAddr('10.0.1.12')
ipp3 = IPAddr('10.0.1.13')
ipp4 = IPAddr('10.0.1.14')
ipp5 = IPAddr('10.0.1.15')

###############################################

# Switches IDs
SW1_ID  = 1
SW2_ID  = 2
SW3_ID  = 3
SW4_ID  = 4
SW1b_ID  = 5
SW2b_ID  = 6
SW3b_ID  = 7
SW4b_ID  = 8

# Protocols
ICMP = 1
TCP  = 6
UDP  = 17
IP   = 0x0800

# Messages
ERROR = -1

# Monitoring Interval period (in seconds)
MonitoringInterval = 5
