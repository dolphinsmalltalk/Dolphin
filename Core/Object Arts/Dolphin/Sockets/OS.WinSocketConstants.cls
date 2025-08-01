﻿"Filed out from Dolphin Smalltalk"!

Kernel.SharedPool
	subclass: #'OS.WinSocketConstants'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'AF_12844' -> 16r19.
			'AF_APPLETALK' -> 16r10.
			'AF_ATM' -> 16r16.
			'AF_BAN' -> 16r15.
			'AF_CCITT' -> 16rA.
			'AF_CHAOS' -> 16r5.
			'AF_CLUSTER' -> 16r18.
			'AF_DATAKIT' -> 16r9.
			'AF_DECnet' -> 16rC.
			'AF_DLI' -> 16rD.
			'AF_ECMA' -> 16r8.
			'AF_FIREFOX' -> 16r13.
			'AF_HYLINK' -> 16rF.
			'AF_ICLFXBM' -> 16r1F.
			'AF_IMPLINK' -> 16r3.
			'AF_INET' -> 16r2.
			'AF_INET6' -> 16r17.
			'AF_IPX' -> 16r6.
			'AF_IRDA' -> 16r1A.
			'AF_ISO' -> 16r7.
			'AF_LAT' -> 16rE.
			'AF_MAX' -> 16r20.
			'AF_NETBIOS' -> 16r11.
			'AF_NETDES' -> 16r1C.
			'AF_NS' -> 16r6.
			'AF_OSI' -> 16r7.
			'AF_PUP' -> 16r4.
			'AF_SNA' -> 16rB.
			'AF_TCNMESSAGE' -> 16r1E.
			'AF_TCNPROCESS' -> 16r1D.
			'AF_UNIX' -> 16r1.
			'AF_UNKNOWN1' -> 16r14.
			'AF_UNSPEC' -> 16r0.
			'AF_VOICEVIEW' -> 16r12.
			'FD_ACCEPT' -> 16r8.
			'FD_CLOSE' -> 16r20.
			'FD_CONNECT' -> 16r10.
			'FD_OOB' -> 16r4.
			'FD_READ' -> 16r1.
			'FD_WRITE' -> 16r2.
			'GAA_FLAG_INCLUDE_PREFIX' -> 16r10.
			'GAA_FLAG_SKIP_ANYCAST' -> 16r2.
			'GAA_FLAG_SKIP_DNS_SERVER' -> 16r8.
			'GAA_FLAG_SKIP_FRIENDLY_NAME' -> 16r20.
			'GAA_FLAG_SKIP_MULTICAST' -> 16r4.
			'GAA_FLAG_SKIP_UNICAST' -> 16r1.
			'INADDR_ANY' -> 16r0.
			'INADDR_BROADCAST' -> -16r1.
			'INADDR_LOOPBACK' -> 16r7F000001.
			'INADDR_NONE' -> -16r1.
			'INET_ADDRSTRLEN' -> 16r16.
			'INET6_ADDRSTRLEN' -> 16r41.
			'INVALID_SOCKET' -> 16rFFFFFFFF.
			'MAXGETHOSTSTRUCT' -> 16r400.
			'NET_ADDRESS_DNS_NAME' -> 16r1.
			'NET_ADDRESS_FORMAT_UNSPECIFIED' -> 16r0.
			'NET_ADDRESS_IPV4' -> 16r2.
			'NET_ADDRESS_IPV6' -> 16r3.
			'NET_STRING_ANY_ADDRESS' -> 16r109.
			'NET_STRING_ANY_ADDRESS_NO_SCOPE' -> 16r111.
			'NET_STRING_ANY_SERVICE' -> 16r222.
			'NET_STRING_ANY_SERVICE_NO_SCOPE' -> 16r242.
			'NET_STRING_IP_ADDRESS' -> 16r9.
			'NET_STRING_IP_ADDRESS_NO_SCOPE' -> 16r11.
			'NET_STRING_IP_NETWORK' -> 16r84.
			'NET_STRING_IP_SERVICE' -> 16r22.
			'NET_STRING_IP_SERVICE_NO_SCOPE' -> 16r42.
			'NET_STRING_IPV4_ADDRESS' -> 16r1.
			'NET_STRING_IPV4_NETWORK' -> 16r4.
			'NET_STRING_IPV4_SERVICE' -> 16r2.
			'NET_STRING_IPV6_ADDRESS' -> 16r8.
			'NET_STRING_IPV6_ADDRESS_NO_SCOPE' -> 16r10.
			'NET_STRING_IPV6_NETWORK' -> 16r80.
			'NET_STRING_IPV6_SERVICE' -> 16r20.
			'NET_STRING_IPV6_SERVICE_NO_SCOPE' -> 16r40.
			'NET_STRING_NAMED_ADDRESS' -> 16r100.
			'NET_STRING_NAMED_SERVICE' -> 16r200.
			'NI_DGRAM' -> 16r10.
			'NI_MAXHOST' -> 16r401.
			'NI_MAXSERV' -> 16r20.
			'NI_NAMEREQD' -> 16r4.
			'NI_NOFQDN' -> 16r1.
			'NI_NUMERICHOST' -> 16r2.
			'NI_NUMERICSERV' -> 16r8.
			'SO_ACCEPTCONN' -> 16r2.
			'SO_BROADCAST' -> 16r20.
			'SO_DEBUG' -> 16r1.
			'SO_DONTLINGER' -> -16r81.
			'SO_DONTROUTE' -> 16r10.
			'SO_ERROR' -> 16r1007.
			'SO_EXCLUSIVEADDRUSE' -> -16r5.
			'SO_GROUP_ID' -> 16r2001.
			'SO_GROUP_PRIORITY' -> 16r2002.
			'SO_KEEPALIVE' -> 16r8.
			'SO_LINGER' -> 16r80.
			'SO_MAX_MSG_SIZE' -> 16r2003.
			'SO_OOBINLINE' -> 16r100.
			'SO_RCVBUF' -> 16r1002.
			'SO_RCVLOWAT' -> 16r1004.
			'SO_RCVTIMEO' -> 16r1006.
			'SO_REUSEADDR' -> 16r4.
			'SO_SNDBUF' -> 16r1001.
			'SO_SNDLOWAT' -> 16r1003.
			'SO_SNDTIMEO' -> 16r1005.
			'SO_TYPE' -> 16r1008.
			'SO_USELOOPBACK' -> 16r40.
			'SOCK_DGRAM' -> 16r2.
			'SOCK_RAW' -> 16r3.
			'SOCK_RDM' -> 16r4.
			'SOCK_SEQPACKET' -> 16r5.
			'SOCK_STREAM' -> 16r1.
			'SOCKET_ERROR' -> -16r1.
			'SOL_SOCKET' -> 16rFFFF.
			'WSADESCRIPTION_LEN' -> 16r100.
			'WSASYS_STATUS_LEN' -> 16r80
		}!

OS.WinSocketConstants guid: (Core.GUID fromString: '{607ae505-f0cf-4dd6-af63-236bff9d5b02}')!

OS.WinSocketConstants isNonInstantiable: true!

OS.WinSocketConstants comment: ''!

