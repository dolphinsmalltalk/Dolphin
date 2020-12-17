"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'OS.WSockLibrary'
	instanceVariableNames: 'wsaData'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.WSockLibrary guid: (Core.GUID fromString: '{87b4c589-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.WSockLibrary comment: '** This class is part of the old asynchronous Sockets Connection package which has been superseded by the Dolphin Sockets package **

This is the ExternalLibrary class to represent the Win32 System DLL, WSOCK32.DLL. 
This library contains functions pertaining to the use of TCP/IP sockets under Windows.'!
!OS.WSockLibrary categoriesForClass!External-Libraries-Sockets!Windows Sockets! !
!OS.WSockLibrary methodsFor!

accept: p1 addr: p2 addrlen: p3
	"SOCKET PASCAL FAR accept (
		SOCKET s,
		struct sockaddr FAR *addr,
		int FAR *addrlen);"

	<stdcall: dword accept dword lpvoid lpvoid>
	^self invalidCall: _failureCode!

bind: p1 addr: p2 namelen: p3
	"int PASCAL FAR bind (
		SOCKET s,
		const struct sockaddr FAR *addr,
		int namelen);"

	<stdcall: sdword bind dword lpvoid lpvoid>
	^self invalidCall: _failureCode!

close
	"We've finished using the socket system."

	wsaData notNil 
		ifTrue: 
			[wsaData := nil.
			self wsaCleanup].
	super close!

closesocket: p1
	"int PASCAL FAR closesocket (
		SOCKET s);"

	<stdcall: sdword closesocket dword>
	^self invalidCall: _failureCode!

connect: p1 name: p2 namelen: p3
	"int PASCAL FAR connect (
		SOCKET s,
		const struct sockaddr FAR *name,
		int namelen);"

	<overlap stdcall: sdword connect dword lpvoid lpvoid>
	^self invalidCall: _failureCode!

gethostbyaddr: p1 len: p2 type: p3
	"struct hostent FAR * PASCAL FAR gethostbyaddr(
		const char FAR * addr,
		int len,
		int type);"

	<overlap stdcall: HOSTENT* gethostbyaddr lpstr sdword sdword>
	^self invalidCall: _failureCode!

gethostbyname: aString
	"Answer host information corresponding to a host name from the host database.

		struct hostent FAR * PASCAL FAR gethostbyname(
			const char FAR * name);"

	<overlap stdcall: HOSTENT* gethostbyname lpstr>
	^self invalidCall: _failureCode!

gethostname: p1 namelen: p2
	"int PASCAL FAR gethostname (
		char FAR * name,
		int namelen);"

	<stdcall: sdword gethostname lpvoid sdword>
	^self invalidCall: _failureCode!

getpeername: p1 name: p2 namelen: p3
	"int PASCAL FAR getpeername (
		SOCKET s,
		struct sockaddr FAR *name,
		int FAR * namelen);"

	<stdcall: sdword getpeername dword lpvoid lpvoid>
	^self invalidCall: _failureCode!

getprotobyname: p1
	"struct protoent FAR * PASCAL FAR getprotobyname( 
		const char FAR *name 	
		);"

	<stdcall: PROTOENT* getprotobyname lpvoid>
	^self invalidCall: _failureCode!

getprotobynumber: p1
	"struct protoent FAR * PASCAL FAR getprotobynumber( 
		int proto 	
		);"

	<stdcall: PROTOENT* getprotobynumber sdword>
	^self invalidCall: _failureCode!

getservbyname: name proto: proto
	"Answer service information corresponding to a service name and protocol.
	proto can be nil to answer the first service entry with a matching name.

		struct servent FAR * getservbyname ( 
			const char FAR *name,	
			const char FAR *proto 	
		);"

	<stdcall: SERVENT* getservbyname lpstr lpstr>
	^self invalidCall: _failureCode!

getservbyport: port proto: proto
	"Answer service information corresponding to a port and protocol.
	If proto is nil, then answers the first service entry which matches the port.

		struct servent FAR * getservbyport ( 
			int port,	
			const char FAR *proto 	
		);"

	<stdcall: SERVENT* getservbyport sdword lpstr>
	^self invalidCall: _failureCode!

getsockname: p1 name: p2 namelen: p3
	"int PASCAL FAR getsockname (
		SOCKET s,
		struct sockaddr FAR *name,
		int FAR * namelen);"

	<stdcall: sdword getsockname dword lpvoid lpvoid>
	^self invalidCall: _failureCode!

getsockopt: p1 level: p2 optname: p3 optval: p4 optlen: p5
	"int PASCAL FAR getsockopt (
		SOCKET s,
		int level,
		int optname,
		char FAR * optval,
		int FAR *optlen);"

	<stdcall: sdword getsockopt dword sdword sdword lpvoid lpvoid>
	^self invalidCall: _failureCode!

htonl: p1
	"u_long PASCAL FAR htonl (
		u_long hostlong);"

	<stdcall: dword htonl dword>
	^self invalidCall: _failureCode!

htons: p1
	"u_short PASCAL FAR htons (
		u_short hostshort);"

	<stdcall: word htons word>
	^self invalidCall: _failureCode!

inet_addr: p1
	"unsigned long PASCAL FAR inet_addr (
		const char FAR * cp);"

	<stdcall: dword inet_addr lpvoid>
	^self invalidCall: _failureCode!

inetntoa: p1
	"char FAR * PASCAL FAR inet_ntoa (
		struct in_addr in);"

	<stdcall: lpvoid inet_ntoa lpvoid>
	^self invalidCall: _failureCode!

initialize
	"Private - Initialize the library - note the is called when the library is opened or re-opened."

	| version res |
	version := 1 bitOr: (1 bitShift: 8).
	wsaData := WSADATA new.
	res := self wsaStartup: version lpWSAData: wsaData.
	res = 0
		ifFalse: 
			[wsaData := nil.
			Net.SocketError signalWith: res]!

ioctlsocket: p1 cmd: p2 argp: p3
	"int PASCAL FAR ioctlsocket (
		SOCKET s,
		long cmd,
		u_long FAR *argp);"

	<stdcall: sdword ioctlsocket dword sdword lpvoid>
	^self invalidCall: _failureCode!

listen: p1 backlog: p2
	"int PASCAL FAR listen (
		SOCKET s,
		int backlog);"

	<stdcall: sdword listen dword sdword>
	^self invalidCall: _failureCode!

ntohl: p1
	"u_long PASCAL FAR ntohl (
		u_long netlong);"

	<stdcall: dword ntohl dword>
	^self invalidCall: _failureCode!

ntohs: p1
	"u_short PASCAL FAR ntohs (
		u_short netshort);"

	<stdcall: word ntohs word>
	^self invalidCall: _failureCode!

recv: p1 buf: p2 len: p3 flags: p4
	"int PASCAL FAR recv (
		SOCKET s,
		char FAR * buf,
		int len,
		int flags);"

	<stdcall: sdword recv dword lpvoid sdword sdword>
	^self invalidCall: _failureCode!

recvfrom: p1 buf: p2 len: p3 flags: p4 from: p5 fromlen: p6
	"int PASCAL FAR recvfrom (
		SOCKET s,
		char FAR * buf,
		int len,
		int flags,
		struct sockaddr FAR *from,
		int FAR * fromlen);"

	<stdcall: sdword recvfrom dword lpvoid sdword sdword lpvoid lpvoid>
	^self invalidCall: _failureCode!

select: p1 readfds: p2 writefds: p3 exceptfds: p4 timeout: p5
	"int PASCAL FAR select (
		int nfds,
		fd_set FAR *readfds,
		fd_set FAR *writefds,
		fd_set FAR *exceptfds,
		const struct timeval FAR *timeout);"

	<stdcall: sdword select sdword lpvoid lpvoid lpvoid lpvoid>
	^self invalidCall: _failureCode!

send: p1 buf: p2 len: p3 flags: p4
	"int PASCAL FAR send (
		SOCKET s,
		const char FAR * buf,
		int len,
		int flags);"

	<stdcall: sdword send dword lpvoid sdword sdword>
	^self invalidCall: _failureCode!

sendto: p1 buf: p2 len: p3 flags: p4 to: p5 tolen: p6
	"int PASCAL FAR sendto (
		SOCKET s,
		const char FAR * buf,
		int len,
		int flags,
		const struct sockaddr FAR *to,
		int tolen);"

	<stdcall: sdword sendto dword lpvoid sdword sdword lpvoid sdword>
	^self invalidCall: _failureCode!

setsockopt: p1 level: p2 optname: p3 optval: p4 optlen: p5
	"int PASCAL FAR setsockopt (
		SOCKET s,
		int level,
		int optname,
		const char FAR * optval,
		int optlen);"

	<stdcall: sdword setsockopt dword sdword sdword lpvoid sdword>
	^self invalidCall: _failureCode!

shutdown: p1 how: p2
	"int PASCAL FAR shutdown (
		SOCKET s,
		int how);"

	<stdcall: sdword shutdown dword sdword>
	^self invalidCall: _failureCode!

socket: p1 type: p2 protocol: p3
	"SOCKET PASCAL FAR socket (int af, int type, int protocol);"

	<stdcall: dword socket sdword sdword sdword>
	^self invalidCall: _failureCode!

wsaAsyncGetHostByAddr: p1 wMsg: p2 addr: p3 len: p4 type: p5 buf: p6 buflen: p7
	"HANDLE PASCAL FAR WSAAsyncGetHostByAddr(HWND hWnd, u_int wMsg,
                                        const char FAR * addr, int len, int type,
                                        char FAR * buf, int buflen);"

	<stdcall: handle WSAAsyncGetHostByAddr handle dword lpvoid sdword sdword lpvoid sdword>
	^self invalidCall: _failureCode!

wsaAsyncGetHostByName: p1 wMsg: p2 name: p3 buf: p4 buflen: p5
	"HANDLE PASCAL FAR WSAAsyncGetHostByName(HWND hWnd, u_int wMsg,
                                        const char FAR * name, char FAR * buf,
                                        int buflen);"

	<stdcall: handle WSAAsyncGetHostByName handle dword lpvoid lpvoid sdword>
	^self invalidCall: _failureCode!

wsaAsyncGetProtoByName: p1 wMsg: p2 name: p3 buf: p4 buflen: p5
	"HANDLE WSAAsyncGetProtoByName ( 
		HWND hWnd,	
		u_int wMsg,	
		const char FAR *name,	
		char FAR *buf,	
		int buflen 	
		);"

	<stdcall: handle WSAAsyncGetProtoByName handle dword lpvoid lpvoid sdword>
	^self invalidCall: _failureCode!

wsaAsyncGetProtoByNumber: p1 wMsg: p2 number: p3 buf: p4 buflen: p5
	"HANDLE WSAAsyncGetProtoByNumber ( 
		HWND hWnd,	
		u_int wMsg,	
		int number,	
		char FAR *buf,	
		int buflen 	
		);"

	<stdcall: handle WSAAsyncGetProtoByNumber handle dword sdword lpvoid sdword>
	^self invalidCall: _failureCode!

wsaAsyncGetServByName: p1 wMsg: p2 name: p3 proto: p4 buf: p5 buflen: p6
	"HANDLE WSAAsyncGetServByName ( 
		HWND hWnd,	
		u_int wMsg,	
		const char FAR *name,	
		const char FAR *proto,	
		char FAR *buf,	
		int buflen 	
		);"

	<stdcall: handle WSAAsyncGetServByName handle dword lpvoid lpvoid lpvoid sdword>
	^self invalidCall: _failureCode!

wsaAsyncGetServByPort: p1 wMsg: p2 port: p3 proto: p4 buf: p5 buflen: p6
	"HANDLE WSAAsyncGetServByPort ( 
		HWND hWnd,	
		u_int wMsg,	
		int port,	
		const char FAR *proto,	
		char FAR *buf,	
		int buflen 	
		);"

	<stdcall: handle WSAAsyncGetServByPort handle dword sdword lpvoid lpvoid sdword>
	^self invalidCall: _failureCode!

wsaAsyncSelect: p1 hWnd: p2 wMsg: p3 lEvent: p4
	"int PASCAL FAR WSAAsyncSelect(
		SOCKET s,
		HWND hWnd,
		u_int wMsg,
		long lEvent);"

	<stdcall: sdword WSAAsyncSelect dword handle dword sdword>
	^self invalidCall: _failureCode!

wsaCancelAsyncRequest: p1
	"int WSACancelAsyncRequest( 
		HANDLE hAsyncTaskHandle 	
		);"

	<stdcall: sdword WSACancelAsyncRequest handle>
	^self invalidCall: _failureCode!

wsaCancelBlockingCall
	"int WSACancelBlockingCall(void);"

	<stdcall: sdword WSACancelBlockingCall>
	^self invalidCall: _failureCode!

wsaCleanup
	"int WSACleanup(void);"

	<stdcall: sdword WSACleanup>
	^self invalidCall: _failureCode!

wsaGetLastError
	"int WSAGetLastError(void);"

	<stdcall: sdword WSAGetLastError>
	^self invalidCall: _failureCode!

wsaIsBlocking
	"BOOL WSAIsBlocking(void);"

	<stdcall: bool WSAIsBlocking>
	^self invalidCall: _failureCode!

wsaSetLastError: p1
	"void WSASetLastError( 
		int iError 	
		);"

	<stdcall: void WSASetLastError sdword>
	^self invalidCall: _failureCode!

wsaStartup: p1 lpWSAData: p2
	"int WSAStartup(
		WORD wVersionRequested,
		LPWSADATA lpWSAData
		);"

	<stdcall: sdword WSAStartup word lpvoid>
	^self invalidCall: _failureCode! !
!OS.WSockLibrary categoriesFor: #accept:addr:addrlen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #bind:addr:namelen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #close!public!realizing/unrealizing! !
!OS.WSockLibrary categoriesFor: #closesocket:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #connect:name:namelen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #gethostbyaddr:len:type:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #gethostbyname:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #gethostname:namelen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #getpeername:name:namelen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #getprotobyname:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #getprotobynumber:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #getservbyname:proto:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #getservbyport:proto:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #getsockname:name:namelen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #getsockopt:level:optname:optval:optlen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #htonl:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #htons:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #inet_addr:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #inetntoa:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #initialize!initializing!private! !
!OS.WSockLibrary categoriesFor: #ioctlsocket:cmd:argp:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #listen:backlog:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #ntohl:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #ntohs:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #recv:buf:len:flags:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #recvfrom:buf:len:flags:from:fromlen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #select:readfds:writefds:exceptfds:timeout:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #send:buf:len:flags:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #sendto:buf:len:flags:to:tolen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #setsockopt:level:optname:optval:optlen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #shutdown:how:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #socket:type:protocol:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #wsaAsyncGetHostByAddr:wMsg:addr:len:type:buf:buflen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #wsaAsyncGetHostByName:wMsg:name:buf:buflen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #wsaAsyncGetProtoByName:wMsg:name:buf:buflen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #wsaAsyncGetProtoByNumber:wMsg:number:buf:buflen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #wsaAsyncGetServByName:wMsg:name:proto:buf:buflen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #wsaAsyncGetServByPort:wMsg:port:proto:buf:buflen:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #wsaAsyncSelect:hWnd:wMsg:lEvent:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #wsaCancelAsyncRequest:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #wsaCancelBlockingCall!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #wsaCleanup!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #wsaGetLastError!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #wsaIsBlocking!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #wsaSetLastError:!public!win32 functions-sockets library! !
!OS.WSockLibrary categoriesFor: #wsaStartup:lpWSAData:!public!win32 functions-sockets library! !

!OS.WSockLibrary class methodsFor!

fileName
	"Answer the host system file name of the external library which the 
	receiver represents"

	^'WSOCK32'! !
!OS.WSockLibrary class categoriesFor: #fileName!constants!public! !

