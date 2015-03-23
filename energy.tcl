###############################################################

##################################################################
#	    Setting the Default Parameters			 #
##################################################################

set val(chan)		Channel/WirelessChannel
set val(prop)		Propagation/TwoRayGround
set val(netif)		Phy/WirelessPhy
set val(mac)            Mac/802_11
set val(ifq)		Queue/DropTail/PriQueue
set val(ll)		LL
set val(ant)            Antenna/OmniAntenna
set val(x)		500	
set val(y)		500	
set val(ifqlen)		50		
set val(nn)		7		
set val(stop)		10.0		
set val(rp)             AODV
set val(energymodel)    EnergyModel
set val(initialenergy)  20                        

##################################################################
#	    Creating New Instance of a Scheduler		 #
##################################################################

set ns_		[new Simulator]

##################################################################
#		Creating Trace files				 #
##################################################################

set tracefd	[open energy.tr w]
$ns_ trace-all $tracefd

##################################################################
#	        Creating NAM Trace files			 #
##################################################################

set namtrace [open energy.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)

set prop	[new $val(prop)]

set topo	[new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

##################################################################
#	                 802.11b Settings			 #
##################################################################

Phy/WirelessPhy set freq_ 2.4e+9
Mac/802_11 set dataRate_ 11.0e6 

##################################################################
#	                 802.11g Settings			 #
##################################################################

#Phy/WirelessPhy set freq_ 2.4e+9
#Mac/802_11 set dataRate_ 54.0e6                   
        
##################################################################
#		Node Configuration				 #
##################################################################

        $ns_ node-config -adhocRouting $val(rp) \
			 -llType $val(ll) \
			 -macType $val(mac) \
			 -ifqType $val(ifq) \
			 -ifqLen $val(ifqlen) \
			 -antType $val(ant) \
			 -propType $val(prop) \
			 -phyType $val(netif) \
			 -channelType $val(chan) \
			 -topoInstance $topo \
			 -agentTrace ON \
			 -routerTrace ON \
			 -macTrace ON \
			 -energyModel $val(energymodel) \
			 -idlePower 0.005 \
			 -rxPower 1.0 \
			 -txPower 5.0 \
          		 -sleepPower 0.0001 \
          		 -transitionPower 0.002 \
          		 -transitionTime 0.005 \
			 -initialEnergy $val(initialenergy)

##################################################################
#		Creating Nodes					 #
##################################################################

#for {set i 0} {$i < $val(nn) } {incr i} {
#     set node_($i) [$ns_ node]	
#     $node_($i) random-motion 0	
#}

$ns_ node-config -ifqLen 300
set node_(0) [$ns_ node]
$node_(0) set X_ 444
$node_(0) set Y_ 324
$node_(0) set Z_ 0.0
$ns_ initial_node_pos $node_(0) 40

$ns_ node-config -ifqLen 40
set node_(1) [$ns_ node]
$node_(1) set X_ 681
$node_(1) set Y_ 321
$node_(1) set Z_ 0.0
$ns_ initial_node_pos $node_(1) 40

$ns_ node-config -ifqLen 30
set node_(2) [$ns_ node]
$node_(2) set X_ 363
$node_(2) set Y_ 560
$node_(2) set Z_ 0.0
$ns_ initial_node_pos $node_(2) 40

$ns_ node-config -ifqLen 20
set node_(3) [$ns_ node]
$node_(3) set X_ 207
$node_(3) set Y_ 339
$node_(3) set Z_ 0.0
$ns_ initial_node_pos $node_(3) 40

$ns_ node-config -ifqLen 10
set node_(4) [$ns_ node]
$node_(4) set X_ 336
$node_(4) set Y_ 100
$node_(4) set Z_ 0.0
$ns_ initial_node_pos $node_(4) 40

$ns_ node-config -ifqLen 5
set node_(5) [$ns_ node]
$node_(5) set X_ 807
$node_(5) set Y_ 533
$node_(5) set Z_ 0.0
$ns_ initial_node_pos $node_(5) 40

$ns_ node-config -ifqLen 2
set node_(6) [$ns_ node]
$node_(6) set X_ 920
$node_(6) set Y_ 291
$node_(6) set Z_ 0.0
$ns_ initial_node_pos $node_(6) 40

##################################################################
#		Initial Positions of Nodes			 #
##################################################################

#for {set i 0} {$i < $val(nn)} {incr i} {
#	$ns_ initial_node_pos $node_($i) 40
#}

##################################################################
#		Topology Design				 	 #
##################################################################

$ns_ at 4.0 "$node_(0) setdest 10.0 10.0 20.0"
$ns_ at 4.0 "$node_(6) setdest 310.0 10.0 20.0"
$ns_ at 4.0 "$node_(1) setdest 10.0 160.0 20.0"
$ns_ at 4.0 "$node_(4) setdest 160.0 160.0 20.0"
$ns_ at 4.0 "$node_(2) setdest 10.0 310.0 20.0"
$ns_ at 4.0 "$node_(5) setdest 310.0 310.0 20.0"
$ns_ at 4.0 "$node_(3) setdest 10.0 460.0 20.0"

##################################################################
#		Generating Traffic				 #
##################################################################

set tcp0 [new Agent/TCP]
set sink0 [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp0
$ns_ attach-agent $node_(6) $sink0
$ns_ connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns_ at 0.0 "$ftp0 start" 
$ns_ at 10.0 "$ftp0 stop"

set tcp1 [new Agent/TCP]
set sink1 [new Agent/TCPSink]
$ns_ attach-agent $node_(1) $tcp1
$ns_ attach-agent $node_(6) $sink1
$ns_ connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns_ at 0.0 "$ftp1 start" 
$ns_ at 10.0 "$ftp1 stop"


set tcp2 [new Agent/TCP]
set sink2 [new Agent/TCPSink]
$ns_ attach-agent $node_(2) $tcp2
$ns_ attach-agent $node_(6) $sink2
$ns_ connect $tcp2 $sink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns_ at 0.0 "$ftp2 start" 
$ns_ at 10.0 "$ftp2 stop"

set tcp3 [new Agent/TCP]
set sink3 [new Agent/TCPSink]
$ns_ attach-agent $node_(3) $tcp3
$ns_ attach-agent $node_(6) $sink3
$ns_ connect $tcp3 $sink3
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3
$ns_ at 0.0 "$ftp3 start" 
$ns_ at 10.0 "$ftp3 stop"

set tcp4 [new Agent/TCP]
set sink4 [new Agent/TCPSink]
$ns_ attach-agent $node_(4) $tcp4
$ns_ attach-agent $node_(6) $sink4
$ns_ connect $tcp4 $sink4
set ftp4 [new Application/FTP]
$ftp4 attach-agent $tcp4
$ns_ at 0.0 "$ftp4 start" 
$ns_ at 10.0 "$ftp4 stop"

set tcp5 [new Agent/TCP]
set sink5 [new Agent/TCPSink]
$ns_ attach-agent $node_(5) $tcp5
$ns_ attach-agent $node_(6) $sink5
$ns_ connect $tcp5 $sink5
set ftp5 [new Application/FTP]
$ftp5 attach-agent $tcp5
$ns_ at 0.0 "$ftp5 start" 
$ns_ at 10.0 "$ftp5 stop"

$ns_ at 10.0 "finish"

proc finish {} {
    global ns_ tracefd namtrace
  $ns_ flush-trace
 close $tracefd
close $namtrace
exec nam energy.nam &
exit 0
}
##################################################################
#		Simulation Termination				 #
##################################################################

for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at $val(stop) "$node_($i) reset";
}
$ns_ at $val(stop) "puts \"NS EXITING...\" ; $ns_ halt"

puts "Starting Simulation..."

$ns_ run
