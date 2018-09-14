# csc458 notes :weary: :weary: :weary:

## Table of Contents

- [1.1: Applications](#1.1-applications)
- [1.2: Requirements](#1.2-requirements)
- [1.3: Network Architecture](#1.3-network-architecture)

## 1.1 Applications
\- Forms of applications:
* Enable users to view pages full of textual and graphical objects.
* Delivery of "streaming" audio and video.
* Real-time audio and video.

\- Uniform Resource Locator (**URL**): provides a way of identifying all the 
possible objects that can be viewed.

---
## 1.2 Requirements
- Scalable Connectivity: by introducing nodes, links, networks and routers

- Cost-Effective Resource Sharing: by Statistical Multiplexing

- Support for Common Services: by introducing channels
---
### Links and Nodes
\- **Link**: directly connected by some physical medium (cable or optical fiber). We call such a physical medium a **link**.

\- **Node**: refer to the hardware the link connects.

Physical links are sometimes limited to a pair of nodes (said to be <em>point-to-point</em>) , while in other cases more than two nodes may share 
a single physical link (said to be <em>multiple-access</em>). It is often the case that multiple-access links are limited in size (geographical distance / num. of nodes).

---
### Switched Network

\- The fundamental idea of packet switching is to multiplex multiple flows of data over a
single physical link.

\- **Switched network**: formed by nodes that are attached to at leat two 
links and run software that forwards data received on one link out on another.

\- The important feature of packet-switched networks is that the nodes in such a network send
<em>discrete blocks</em> of data to each other. These blocks of data correspond to some piece of 
application data. We call each block of data either a **packet** or a **message**.

\- Difference between packet-switched and circuit-switched network:

<strong>Packet-switched</strong> networks typically use a strategy called **store-and-forward**. 
Each node in a store-and-forward network receives a complete packet over some link, stores the 
packet in its internal memory, and then forwards the complete packet to the next node.

In contrast, a **circuit-switched** network first establishes a dedicated circuit across a sequence of links and then allows the source node to send a stream of bits across thie circuit to
a destination node.

---
### Clouds
<img align="centre" src="./img/cloud.png" width="500">

- The nodes on the inside are called **switches**, their primary function is to store and 
forward packets.
- The nodes on the outside of the cloud that use the network are called **hosts**, and they 
support users and run application programs.

The cloud is a placeholder for any of the networking technologies covered above.

A set of independent networks (clouds) are interconnected to form an <em>internetwork</em>, or
internet for short. We can recursively build arbitrarily large networks by interconnecting 
clouds to form larger clouds.

---
### Routers and Routing
<img align="centre" src="./img/router.png" width="500">

\- A node that is connected to two or more networks (the clouds) is commonly called a **router** 
or **gateway**. It forwards message from one network to another.

\- Each node must be able to say which of the other nodes on the network it wants to communicate
with. This is done by assigning an **address** to each node. The network can use a node's address
to distinguish it from the other nodes. When a source node wants the network to deliver a 
message to a certain destination node, it specifies the address of the destination node, then the
switches and routers of the network use this address to decide how to forward the message toward
the destination. This process is called **routing**.

---
### Statistical Multiplexing / Cost-Effective Resource Sharing

\- **Multiplexing**: a system resource is shared among multiple users. Data being sent by 
multiple users can be multiplexed over the physical links that make up a network.

\- Different methods for multiplexing flows onto one physical link:
- <em>synchronous time-division multiplexing</em> (STDM): divide time into equal-sized quanta
and, in a round-robin fasion, give each flow a chance to send its data over the physical link.

- <em>frequency-division multiplexing</em> (FDM): transmit each flow over the physical link at
a different frequency.

Two methods above are limited in two ways:
1. if one of the flows does not have any data to send, its share of the physical link remains 
idle.
2. both STDM and FDM are limited to situations in which the maximum number of flows is fixed and
known ahead of time since it's not practical to resize the quantum or add new frequencies duing
the transmition.

\- **Statistical Multiplexing** is like STDM in that the physical link is shared over time, 
however, data is transmitted from each flow on demand rather than during a predetermined time 
slot i.e. it gets to transmit the data without waiting for its quantum of come around.

\- Statistical multiplexing has a mechanism to ensure that all the flows eventually get their
turn to transmit over the physical link. It defines an **upper bound** on the size of the
block of data that each flow is permitted to transmit at a given time. This <em>limited-size</em>
block of data is typically referred to as a **packet** (which differs from an arbitrarily large <em>message</em>).

\- Because a packet-switched network limits the maximum size of packets, a host may not be able 
to send a complete message in one packet. The source may need to fragment the message into 
several packets, with the receiver reassambling the packets back into the origianl message.

\- If the switch receives packets faster than the shared link can accommodate, it is forced to buffer these packets in its memory.

\- **Congestion**: if a switch receives packets faster than it can send for an extended 
period of time, then the switch will eventually run out of buffer space, and some packets will 
have to be dropped.

---
### Channel
\- We can think of the <em>channel</em> as being like a pipe connecting two applications, so that
a sending application can put data in one end and expect that data to be delivered by the network
to the application at the other end of the pipe.

\- The process that requests access to the file is called the **client**, the process that 
supports access to the file is caled the **server**.

Reading a file involves the client sending a small request message to a server and the server
responding with a large message that contains the data in the file.

Writing a file involves the client sending a large message containing the data to be written to
the server, and the server responds with a small message confirming that the write to disk has
taken place.

---
### Reliablity

\- Problems: machines crash and later are rebooted, fibers are cut, electrical interference 
corrupts bits in the data being transmitted, switches run out of buffer space.

\- Three general classes of failure: 
- <em>bit erros</em>: a 1 is turned into a 0 or vice versa. If several consecutive bits are
corrupted, it's called <em>burst error</em>.

- A complete packet is lost by the network. If the packet contains an uncorrectable bit error, then it will be dropped. Can also be dropped if a switch's buffer is overloaded.

- A physical link is cut, or the computer it is connected to crashes.


---
## 1.3 Network Architecture

### Layering
\- Layering provides an **abstraction** for applications that hides the complexity of the 
network.

You start with the services offered by the underlying hardware and then add a sequence of layers,
each providing a higher level of services. The services provided at the high layers are 
implemented in terms of the services provided by the low layers.

\- Layering provides two features:
- It decomposes the problem of building a network into more manageable components.
- It provides a more modular design, e.g. if you decide that you want to add some new service, 
you may only need to modify the functionality at one layer.

---
### Protocals
\- The abstract objects that make up the layers of a network system are called **protocals**. It
provides a communication service that higher-level objects use to exchange messges.

<img align="centre" src="./img/interface.png" width="500">

\- Each protocal defines 2 different interfaces:
1. <em>Service interface</em> defines the operations that local objects can perform on the 
protocal. (e.g. HTTP supports an operation to fetch a page of hypertext from a remote server.)

2. <em>Peer interface</em> defines the form and meaning of messages exchanged between protocal
peers to implement the communication service. (e.g. HTTP defines how a GET cmd is formatted. )

Peer-to-peer communication is indirect -- each protocal communicates with its peer by passing
messages to some lower-level protocal, which in turn delivers the message to its peer.

We call the set of rules governing the form and content of a protocal graph a **network architecture**.

---
### Encapsulation

\- A **header** is a small data structure that is used among peers to communicate with each 
other. The exact format for the header is defined by its protocal specification. The data 
being transmitted is called the message's **body**/payload.

---
### Multiplexing and Demultiplexing
\- The header contains the <em>demultiplexing key</em> that records the application to which
the message belongs. When the message is delivered to the host, it strips its header, examines
the demux key, and demultiplexes the message to the correct application.

---
### The 7-Layer Model
<img align="centre" src="./img/7layer.png" width="500">

- **Physical** layer handles the transmission of raw bits over a communication link.

- **Data link** layer then collects a stream of bits into a larger aggregate called a <em>frame</em>. (Network adapters / device drivers typically implemented in this layer.)

-  **Network** layer handles routing among nodes within a packet-switched network. At this layer,
the unit of data exchanged is typically called **packet**.

The lower three layers are implemented on all network nodes. The transport layer and higher
layers typically run only on the end hosts and not on the intermediate switches or routers.

- **Transport** layer then implements a process-to-process channel. Here, the unit of data
exchanged is commonly called a **message** rather than a packet or a frame.

- Session layer provides a name space that is used to tie together the potentially different
transport streams that are part of a single application e.g. manage an audio stream and video
stream that are being combined in a teleconferencing application.

- Presentation layer is concerned with the format of data exchanged.

- Application layer protocals include things like HTTP which enables web browsers to request 
pages from web servers.

---
### Internet Architecture
<img align="centre" src="./img/internet.png" width="500">

- At the lowest level is a wide variety of network protocals. These protocals are implemented by
a combination of hardware (e.g. network adapter)and software (e.g. driver).

- The second layer consists of a single protocal -- **IP** which supports the interconnection
of multiple networking technologies into a single, logical internetwork.

- The third layer contains **TCP** (transmission control protocal) and **UDP** (user datagram 
protocal). TCP provides a reliable byte-stream channel, and UDP provides an unreliable datagram
(message) delivery channel. These two protocals are sometimes called end-to-end protocals.

- Running above the transport layer is a range of application protocals, such as HTTP, FTP, and
SMTP.

The internet architecture has these features:
1. The application is free to bypass the defined transport layers and to directly use IP or one
of the underlying networks.

2. IP defines a common method for exchanging packets among a wide collection of networks. Above 
IP there can be arbitrarily many transport protocals, each offering a different channel 
abstraction to applications. Thus, the issue of delivering messages from host to host is 
completely seperated from the issue of providing a useful process-to-process communication
service.