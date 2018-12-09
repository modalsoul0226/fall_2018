# Lecture 5 Internet Topology

### Link-State Routing
- Topology information is flooded which causes high bandwidth and storage overhead.
- Entire path computed locally per node which causes high processing overhead in a large network.
- Minimizes some notion of total distance, works only if policy is shared and uniform.
- Typically used only inside an AS.

---
### Distance Vector
Advantages:
- Hides details of the network topology.
- Nodes determine only 'next hop' toward the dest.

Disadvantages:
- Minimizes some notion of total distance, which is difficult in an interdomain setting.
- Slow convergence due to the counting-to-infinity problem.

---
### Path Vector
- Extension of distance-vector routing.
- Path vector sends the entire path for each dest where distance vector sends distance metric per dest d.
- Node can easily detect a loop by looking for its own node identifier in the path.
- Node can simply discard paths with loops.

## Border Gateway Protocol (BGP)
- BGP is a path-vector routing protocol.
- BGP advertises complete paths.
- Paths with loops are detected locally and ignored.
- Local policies pick the preferred path among options.

---
### Incremental Protocol
- A node learns multiple paths to destination: stores all of the routes in a routing table, applies policy to select a single active route, and may advertise the route to its neighbors.
- Incremental updates: 1. Announcement: upon selecting a new active route, add node id to path and (optionally) advertise to each neighbor. 2. Withdrawal: if the active route is no longer available, send a withdrawal message to the neighbors. 

---
### BGP route selection summary
1. Highest Local Preference: enforce relationships e.g. prefer customer routes over peer routes.
2. Shortest AS path, i-BGP < e-BGP.
3. Lowest router ID.

---
### BGP policy
Import policy:
- Filter unwanted routes from neighbor, e.g. prefix that your customer doesn't own.
- Manipulate attributes to influence path selection, e.g. assign local preference to favored routes.

Export policy:
- Filter routes you don't want to tell your neighbor, e.g. don't tell a peer a route learned from other peer.
- Manipulate attributes to control what they see, e.g. make a path look artificially longer than it is.

<img src="./images/bgp_policy.png">

#### Import policy: local preference
- Favor one path over another. Override the influence of AS path length, apply local policies to prefer a path.
- Example: prefer customer over peer.

#### Import policy: Filtering
- Discard some route announcements.
- Examples: Discard route if prefix not owned by the cutomer. Discard route that contains other large ISP in AS path.

#### Export policy: Filtering
- Discard some route announcements.
- Examples: Don't announce routes from one peer to another. Don't announce routes for network-management hosts.

#### Export policy: Attribute Manipulation
- Modify attributes of the active route, i.e. to influence the way other AS's behave.
- Example: AS prepending. Artificially inflate the AS path length seen by others. To convince some AS's to send traffic another way.

---
### Joining BGP and IGP information
Border Gateway Protocol (**BGP**)
- Announces reachability to external destinations.
- Maps a destination prefix to an egress point, e.g. 128.112.0.0/16 reached via 192.0.2.1

Interior Gateway Protocol (**IGP**)
- Used to compute paths within the AS.
- Maps an egress point to an outgoing link, e.g. 192.0.2.1 reached via 10.10.10.10

---
### Causes of BGP Routing Changes
- **Topology changes**, e.g. equipment going up or down, deployment of new routers or sessions.
- **BGP session failures**, e.g. due to equipment failures, maintenance, etc. Or, due to congestion on the physical path.
- **Changes in routing policy**, e.g. reconfiguration of preferences, reconfiguration of router filters.
- **Persistent protocol oscillation**, e.g. conflicts between policies in different AS's.

---
#### BGP converges slowly
- Path vector avoids count-to-infinity. But, AS's still must explore many alternate paths to find the highest-ranked path that is still available.
- In practice, most popular destinations have very stable BGP routes, and most instability lies in a few unpopular destinations.
- Still, lower BGP convergence delay is a goal. High for important interactive applications.

---
### Conclusions
BGP is a routing protocol operating at a global scale, with tens of thousands of independent networks that each have their **own policy goals** and all want **fast convergence**.

Key features of BGP:
- Prefix-based path-vector protocol.
- Incremental updates (announcements and withdrawls)
- Policies applied at import and export of routes.
- Internal BGP to distribute information within AS.
- Interaction with the IGP to compute forwarding tables.


# Leture 6: Transport Protocol

Transport layer:
- Communication between processes (e.g. sockets).
- Relies on network layer and serves the application layer.

**Sender**: breaks application messages into segments, and passes to network layer.

**Receiver**: reassembles segments into messages, passes to application layer.

**UDP**:
- No-frills extension of 'best effort' IP.

**TCP**:
<img src="images/tcp_feat.png">

---
### Demultiplexing
Each IP datagram host received has:
- source and destination **IP address**.
- one transport-layer segment.
- source and destination **port number**.
- Host uses IP addresses and port numbers to direct segment to appropriate socket.

---
## UDP

#### Advantages:
- **Finer control** over what data is sent and when. As soon as an application process writes into the socket, UDP will package the data and send the packet.
- **No delay** for connection establishment. UDP just blasts away without any formal preliminaries which avoids introducing any unnecessary delays.
- No connection state. No allocation of buffers, parameters, sequence numbers, etc. making it easier to handle many active clients at once.
- **Smaller packet header overhead**. UDP header is only eight-bytes long.

#### Applications
- Multimedia streaming: retransmitting lost/corrupted packets is not worthwile, e.g. telephone calls, video conferencing, gaming.
- Simple query protocols like Domain Name System (DNS): overhead of connection establishment is overkill, easier to have application retransmit if needed.

---
## Transmission Control Protocol (TCP)

#### Support for Reliable Delivery
- Checksum: used to detect corrupted data at the receiver, leading the receiver to drop the packet.
- Sequence numbers: used to detect missing data, and for putting the data back in order.
- Retransmission: sender retransmits lost or corrupted data, timeout based on estimates of RTT.

---
### TCP Segment

A segment is sent when:
1. Segment full (Max Segment Size).
2. Not full, but times out, or
3. 'Pushed' by application.

- IP packet: no bigger than MTU, e.g. up to 1500 bytes on an Ethernet.
- TCP packet: TCP header is typically 20 bytes long.
- TCP segment: No more than Maximum Segment Size (MSS) bytes.


---
#### Initial Sequence Number (ISN)
TCP requires changing the ISN over time because:
- IP addresses and port numbers uniquely identify a connection. 
- Eventually, these port numbers do get used again,
- ... and there is a chance an old packet is still in flight
- ... and might be associated with the new connection.
- Set from a 32-bit clock that ticks every 4 microseconds, which only wraps around once every 4.55 hours.


---
#### Automatic Repeat Request (ARQ)
- Receiver sends ACK when it receives packet.
- Sender waits for ACK and timeouts if it does not arrive within some time period.

TCP sets timeout as a function of RTT:
- Expect ACK to arrive after an RTT.
- Smooth estimate: `EstimatedRTT = a * EstimatedRTT + (1 - a) * SampleRTT`.
- Compute timeout: `Timeout = 2 * EstimatedRTT`
- **Karn/Partridge** algorithm: only collect sample RTT's for segments sent one single time.

---
### Sliding window
Stop-and-wait is inefficient especially when delay-bandwidth product is high. However, sliding window allows a larger amount of data 'in flight'.

<img src="images/reader_writer.png">

TCP adds flow control to the sliding window, `ACK + WIN` is the sender's limit:
<img src="images/WIN.png" width=300px>

---
#### Receiver buffering
Window size:
- Amount that can be sent without ACK.
- Receiver needs to be able to store this amount of data.

Receiver advertises the window to the sender:
- Tells the sender the amount of free space left
- ... and the sender agrees not to exceed this amount.

---
#### Fast Retransmission
Sender retransmits data after **triple duplicate ACKs**:
- Although packet `n` might have been lost,
- ... packet `n + 1`, `n + 2`, and so on might get through.
- ACK says that receiver is still awaiting `n_th` packet, and repeated ACKs suggest that later packets have arrived.
- The sender views the duplicate ACKs as a hint that the `n_th` packet must have been lost and perform the retransmission.

Effectiveness of Fast Retransmission:
- Long data transfers: high likelihood of many packets in flight.
- High window size: high likelihood of many packets in flight.
- Low burstiness in packet losses: higher likelihood that later packets arrive successfully.
- Implications for web traffic: most web transfers are short, so often there aren't many packets in flight and more likely forcing users to 'reload' more often.


---
### Tearing down the connection
- FIN to close and receive remaining bytes.
- RST to close and not receive remaining bytes.
- Other hosts send a FIN ACK to acknowledge.

Sending a FIN `close()`:
- Process is done sending data via the socket.
- Process invokes `close()` to close the socket.
- Once TCP has sent all of the outstanding bytes, then TCP sends a FIN.

Receiving a FIN `EOF`:
- Process is reading data from the socket.
- Eventually, the attempt to read returns an `EOF`.

<img src="images/FIN.png">


---
# Lecture 7: Congestion Control

#### Flow control vs. Congestion control
- Flow control: keep one fast sender from overwhelming a slow receiver.
- Congestion control: keep a set of senders from overloading the network.
- A fast network feeding a low-capacity receiver -> flow control
- A slow network feeding a high-capacity receiver -> congestion control
  
Similar mechanisms:
- TCP flow control: receiver window
- TCP congestion control: congestion window
- TCP window: min{congestion window, receiver window}

---
#### Congestion is unavoidable
- Two packets arrive at the same time. The node can only transmit one, and either buffer or drop the other.
- If many packets arrive in a short period of time. The node cannot keep up with the arriving traffic, and the buffer may eventually overflow.
  
---
#### Advantages of having congestion:
- It makes efficient use of the link, and buffers in the routers are frequently occupied.
- If buffers are always empty, delay is low, but our usage of the network is low. If buffers are always occupied, delay is high, but we are using the network more efficiently.

### Congestion Collapse
Increase in network load results in a decrease of useful work done.
- Spurious retransmission of packets still in flight. Solution: better timers and TCP congestion control.
- Undelivered packets. Packets consume resources and are dropped elsewhere in network. Solution: congestion control for *all* traffic.

---
### Simple congestion detection
- Packet loss: timeout or triple-duplicate ACK
- Packet delay: RTT estimate

---
### TCP Congestion Control
- TCP implements **host-based**, **feedback-based**, **window-based** congestion control.
- TCP sources attempts to determine how much capacity is available.
- TCP sends packets, then reacts to observable events like packet loss.

#### Idea of TCP Congestion Control
- Each source determines the available capacity so it knows how many packets to have in transit.
- Congestion window: maximum number of unacknowledged bytes to have in transit. Send at the rate of the slowest component: receiver or network.
- Adapting the congestion window: decrease upon losing a packet, increase upon success.
- `LastByteSent - LastByteAcked <= cwnd`
- `rate ~= cwnd/RTT` bytes/s

---
#### Additive Increase, Multiplicative Decrease
- Increase linearly, decrease multiplicatively.
- A necessary condition for stability of TCP.
- Consequence of over-sized window are much worse than having an under-sized window.
- Increase: `cwnd += MSS * (MSS / cwnd)`
- Decrease: `cwnd \= 2` (never dropped below 1 MSS)