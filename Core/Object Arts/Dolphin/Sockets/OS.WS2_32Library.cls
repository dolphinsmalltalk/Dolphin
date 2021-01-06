"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'OS.WS2_32Library'
	instanceVariableNames: 'wsaData'
	classVariableNames: ''
	imports: #(#{OS.WinSocketConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.WS2_32Library guid: (Core.GUID fromString: '{d368efd5-8705-4c18-ada5-9a1e95868480}')!
OS.WS2_32Library comment: 'WS2_32Library is the <ExternalLibrary> class to represent the dynamic link library, ''WS2_32.dll''.It was generated generated from type information in the ''Windows Sockets 2 Type Library'' library. It contains methods for each of the functions defined by the corresponding module in that type library.

This library contains functions pertaining to the use of TCP/IP sockets under Windows through the Sockets 2 (blocking) API.

IDL definition follows:

[
	dllname("WS2_32.dll"), 
]
module WS2_32 {
	[entry(0x60000000)]
	unsigned int __stdcall accept(
		unsigned int s,
		sockaddr* addr,
		int* addrlen);
	[entry(0x60000001)]
	int __stdcall bind(
		unsigned int s,
		sockaddr* name,
		int namelen);
	[entry(0x60000002)]
	int __stdcall closesocket(
		unsigned int s);
	[entry(0x60000003)]
	int __stdcall connect(
		unsigned int s,
		sockaddr* name,
		int namelen);
	[entry(0x60000004)]
	int __stdcall ioctlsocket(
		unsigned int s,
		long cmd,
		unsigned long* argp);
	[entry(0x60000005)]
	int __stdcall getpeername(
		unsigned int s,
		sockaddr* name,
		int* namelen);
	[entry(0x60000006)]
	int __stdcall getsockname(
		unsigned int s,
		sockaddr* name,
		int* namelen);
	[entry(0x60000007)]
	int __stdcall getsockopt(
		unsigned int s,
		int level,
		int optname,
		CHAR* optval,
		int* optlen);
	[entry(0x60000008)]
	unsigned long __stdcall htonl(
		unsigned long hostlong);
	[entry(0x60000009)]
	unsigned short __stdcall htons(
		unsigned short hostshort);
	[entry(0x6000000a)]
	unsigned long __stdcall inet_addr(
		CHAR* cp);
	[entry(0x6000000b)]
	CHAR* __stdcall inet_ntoa(
		in_addr in);
	[entry(0x6000000c)]
	int __stdcall listen(
		unsigned int s,
		int backlog);
	[entry(0x6000000d)]
	unsigned long __stdcall ntohl(
		unsigned long netlong);
	[entry(0x6000000e)]
	unsigned short __stdcall ntohs(
		unsigned short netshort);
	[entry(0x6000000f)]
	int __stdcall recv(
		unsigned int s,
		CHAR* buf,
		int len,
		int flags);
	[entry(0x60000010)]
	int __stdcall recvfrom(
		unsigned int s,
		CHAR* buf,
		int len,
		int flags,
		sockaddr* from,
		int* fromlen);
	[entry(0x60000011)]
	int __stdcall select(
		int nfds,
		fd_set* readfds,
		fd_set* writefds,
		fd_set* exceptfds,
		timeval* timeout);
	[entry(0x60000012)]
	int __stdcall send(
		unsigned int s,
		CHAR* buf,
		int len,
		int flags);
	[entry(0x60000013)]
	int __stdcall sendto(
		unsigned int s,
		CHAR* buf,
		int len,
		int flags,
		sockaddr* to,
		int tolen);
	[entry(0x60000014)]
	int __stdcall setsockopt(
		unsigned int s,
		int level,
		int optname,
		CHAR* optval,
		int optlen);
	[entry(0x60000015)]
	int __stdcall shutdown(
		unsigned int s,
		int how);
	[entry(0x60000016)]
	unsigned int __stdcall socket(
		int af,
		int Type,
		int protocol);
	[entry(0x60000017)]
	hostent* __stdcall gethostbyaddr(
		CHAR* addr,
		int len,
		int Type);
	[entry(0x60000018)]
	hostent* __stdcall gethostbyname(
		CHAR* name);
	[entry(0x60000019)]
	int __stdcall gethostname(
		CHAR* name,
		int namelen);
	[entry(0x6000001a)]
	servent* __stdcall getservbyport(
		int Port,
		CHAR* proto);
	[entry(0x6000001b)]
	servent* __stdcall getservbyname(
		CHAR* name,
		CHAR* proto);
	[entry(0x6000001c)]
	protoent* __stdcall getprotobynumber(
		int number);
	[entry(0x6000001d)]
	protoent* __stdcall getprotobyname(
		CHAR* name);
	[entry(0x6000001e)]
	int __stdcall WSAStartup(
		unsigned short wVersionRequested,
		WSAData* lpWSAData);
	[entry(0x6000001f)]
	int __stdcall WSACleanup();
	[entry(0x60000020)]
	void __stdcall WSASetLastError(
		int iError);
	[entry(0x60000021)]
	int __stdcall WSAGetLastError();
	[entry(0x60000022)]
	long __stdcall WSAIsBlocking();
	[entry(0x60000023)]
	int __stdcall WSAUnhookBlockingHook();
	[entry(0x60000024)]
	int __stdcall WSASetBlockingHook(
		void* lpBlockFunc);
	[entry(0x60000025)]
	int __stdcall WSACancelBlockingCall();
	[entry(0x60000026)]
	void* __stdcall WSAAsyncGetServByName(
		wireHWND hWnd,
		unsigned int wMsg,
		CHAR* name,
		CHAR* proto,
		CHAR* buf,
		int buflen);
	[entry(0x60000027)]
	void* __stdcall WSAAsyncGetServByPort(
		wireHWND hWnd,
		unsigned int wMsg,
		int Port,
		CHAR* proto,
		CHAR* buf,
		int buflen);
	[entry(0x60000028)]
	void* __stdcall WSAAsyncGetProtoByName(
		wireHWND hWnd,
		unsigned int wMsg,
		CHAR* name,
		CHAR* buf,
		int buflen);
	[entry(0x60000029)]
	void* __stdcall WSAAsyncGetProtoByNumber(
		wireHWND hWnd,
		unsigned int wMsg,
		int number,
		CHAR* buf,
		int buflen);
	[entry(0x6000002a)]
	void* __stdcall WSAAsyncGetHostByName(
		wireHWND hWnd,
		unsigned int wMsg,
		CHAR* name,
		CHAR* buf,
		int buflen);
	[entry(0x6000002b)]
	void* __stdcall WSAAsyncGetHostByAddr(
		wireHWND hWnd,
		unsigned int wMsg,
		CHAR* addr,
		int len,
		int Type,
		CHAR* buf,
		int buflen);
	[entry(0x6000002c)]
	int __stdcall WSACancelAsyncRequest(
		void* hAsyncTaskHandle);
	[entry(0x6000002d)]
	int __stdcall WSAAsyncSelect(
		unsigned int s,
		wireHWND hWnd,
		unsigned int wMsg,
		long lEvent);
	[entry(0x6000002e)]
	unsigned int __stdcall WSAAccept(
		unsigned int s,
		sockaddr* addr,
		int* addrlen,
		void* lpfnCondition,
		unsigned long dwCallbackData);
	[entry(0x6000002f)]
	long __stdcall WSACloseEvent(
		unsigned long hEvent);
	[entry(0x60000030)]
	int __stdcall WSAConnect(
		unsigned int s,
		sockaddr* name,
		int namelen,
		WSABUF* lpCallerData,
		WSABUF* lpCalleeData,
		QualityOfService* lpSQOS,
		QualityOfService* lpGQOS);
	[entry(0x60000031)]
	unsigned long __stdcall WSACreateEvent();
	[entry(0x60000032)]
	int __stdcall WSADuplicateSocketA(
		unsigned int s,
		unsigned long dwProcessId,
		WSAPROTOCOL_INFOA* lpProtocolInfo);
	[entry(0x60000033)]
	int __stdcall WSADuplicateSocketW(
		unsigned int s,
		unsigned long dwProcessId,
		WSAPROTOCOL_INFOW* lpProtocolInfo);
	[entry(0x60000034)]
	int __stdcall WSAEnumNetworkEvents(
		unsigned int s,
		unsigned long hEventObject,
		WSANETWORKEVENTS* lpNetworkEvents);
	[entry(0x60000035)]
	int __stdcall WSAEnumProtocolsA(
		int* lpiProtocols,
		WSAPROTOCOL_INFOA* lpProtocolBuffer,
		unsigned long* lpdwBufferLength);
	[entry(0x60000036)]
	int __stdcall WSAEnumProtocolsW(
		int* lpiProtocols,
		WSAPROTOCOL_INFOW* lpProtocolBuffer,
		unsigned long* lpdwBufferLength);
	[entry(0x60000037)]
	int __stdcall WSAEventSelect(
		unsigned int s,
		unsigned long hEventObject,
		long lNetworkEvents);
	[entry(0x60000038)]
	long __stdcall WSAGetOverlappedResult(
		unsigned int s,
		WSAOVERLAPPED* lpOverlapped,
		unsigned long* lpcbTransfer,
		long fWait,
		unsigned long* lpdwFlags);
	[entry(0x60000039)]
	long __stdcall WSAGetQOSByName(
		unsigned int s,
		WSABUF* lpQOSName,
		QualityOfService* lpQOS);
	[entry(0x6000003a)]
	int __stdcall WSAHtonl(
		unsigned int s,
		unsigned long hostlong,
		unsigned long* lpnetlong);
	[entry(0x6000003b)]
	int __stdcall WSAHtons(
		unsigned int s,
		unsigned short hostshort,
		unsigned short* lpnetshort);
	[entry(0x6000003c)]
	int __stdcall WSAIoctl(
		unsigned int s,
		unsigned long dwIoControlCode,
		void* lpvInBuffer,
		unsigned long cbInBuffer,
		void* lpvOutBuffer,
		unsigned long cbOutBuffer,
		unsigned long* lpcbBytesReturned,
		WSAOVERLAPPED* lpOverlapped,
		void* lpCompletionRoutine);
	[entry(0x6000003d)]
	unsigned int __stdcall WSAJoinLeaf(
		unsigned int s,
		sockaddr* name,
		int namelen,
		WSABUF* lpCallerData,
		WSABUF* lpCalleeData,
		QualityOfService* lpSQOS,
		QualityOfService* lpGQOS,
		unsigned long dwFlags);
	[entry(0x6000003e)]
	int __stdcall WSANtohl(
		unsigned int s,
		unsigned long netlong,
		unsigned long* lphostlong);
	[entry(0x6000003f)]
	int __stdcall WSANtohs(
		unsigned int s,
		unsigned short netshort,
		unsigned short* lphostshort);
	[entry(0x60000040)]
	int __stdcall WSARecv(
		unsigned int s,
		WSABUF* lpBuffers,
		unsigned long dwBufferCount,
		unsigned long* lpNumberOfBytesRecvd,
		unsigned long* lpFlags,
		WSAOVERLAPPED* lpOverlapped,
		void* lpCompletionRoutine);
	[entry(0x60000041)]
	int __stdcall WSARecvDisconnect(
		unsigned int s,
		WSABUF* lpInboundDisconnectData);
	[entry(0x60000042)]
	int __stdcall WSARecvFrom(
		unsigned int s,
		WSABUF* lpBuffers,
		unsigned long dwBufferCount,
		unsigned long* lpNumberOfBytesRecvd,
		unsigned long* lpFlags,
		sockaddr* lpFrom,
		int* lpFromlen,
		WSAOVERLAPPED* lpOverlapped,
		void* lpCompletionRoutine);
	[entry(0x60000043)]
	long __stdcall WSAResetEvent(
		unsigned long hEvent);
	[entry(0x60000044)]
	int __stdcall WSASend(
		unsigned int s,
		WSABUF* lpBuffers,
		unsigned long dwBufferCount,
		unsigned long* lpNumberOfBytesSent,
		unsigned long dwFlags,
		WSAOVERLAPPED* lpOverlapped,
		void* lpCompletionRoutine);
	[entry(0x60000045)]
	int __stdcall WSASendDisconnect(
		unsigned int s,
		WSABUF* lpOutboundDisconnectData);
	[entry(0x60000046)]
	int __stdcall WSASendTo(
		unsigned int s,
		WSABUF* lpBuffers,
		unsigned long dwBufferCount,
		unsigned long* lpNumberOfBytesSent,
		unsigned long dwFlags,
		sockaddr* lpTo,
		int iTolen,
		WSAOVERLAPPED* lpOverlapped,
		void* lpCompletionRoutine);
	[entry(0x60000047)]
	long __stdcall WSASetEvent(
		unsigned long hEvent);
	[entry(0x60000048)]
	unsigned int __stdcall WSASocketA(
		int af,
		int Type,
		int protocol,
		WSAPROTOCOL_INFOA* lpProtocolInfo,
		unsigned int g,
		unsigned long dwFlags);
	[entry(0x60000049)]
	unsigned int __stdcall WSASocketW(
		int af,
		int Type,
		int protocol,
		WSAPROTOCOL_INFOW* lpProtocolInfo,
		unsigned int g,
		unsigned long dwFlags);
	[entry(0x6000004a)]
	unsigned long __stdcall WSAWaitForMultipleEvents(
		unsigned long cEvents,
		unsigned long* lphEvents,
		long fWaitAll,
		unsigned long dwTimeout,
		long fAlertable);
	[entry(0x6000004b)]
	int __stdcall WSAAddressToStringA(
		sockaddr* lpsaAddress,
		unsigned long dwAddressLength,
		WSAPROTOCOL_INFOA* lpProtocolInfo,
		LPSTR lpszAddressString,
		unsigned long* lpdwAddressStringLength);
	[entry(0x6000004c)]
	int __stdcall WSAAddressToStringW(
		sockaddr* lpsaAddress,
		unsigned long dwAddressLength,
		WSAPROTOCOL_INFOW* lpProtocolInfo,
		LPWSTR lpszAddressString,
		unsigned long* lpdwAddressStringLength);
	[entry(0x6000004d)]
	int __stdcall WSAStringToAddressA(
		LPSTR AddressString,
		int AddressFamily,
		WSAPROTOCOL_INFOA* lpProtocolInfo,
		sockaddr* lpAddress,
		int* lpAddressLength);
	[entry(0x6000004e)]
	int __stdcall WSAStringToAddressW(
		LPWSTR AddressString,
		int AddressFamily,
		WSAPROTOCOL_INFOW* lpProtocolInfo,
		sockaddr* lpAddress,
		int* lpAddressLength);
	[entry(0x6000004f)]
	int __stdcall WSALookupServiceBeginA(
		WSAQuerySetA* lpqsRestrictions,
		unsigned long dwControlFlags,
		void** lphLookup);
	[entry(0x60000050)]
	int __stdcall WSALookupServiceBeginW(
		WSAQuerySetW* lpqsRestrictions,
		unsigned long dwControlFlags,
		void** lphLookup);
	[entry(0x60000051)]
	int __stdcall WSALookupServiceNextA(
		void* hLookup,
		unsigned long dwControlFlags,
		unsigned long* lpdwBufferLength,
		WSAQuerySetA* lpqsResults);
	[entry(0x60000052)]
	int __stdcall WSALookupServiceNextW(
		void* hLookup,
		unsigned long dwControlFlags,
		unsigned long* lpdwBufferLength,
		WSAQuerySetW* lpqsResults);
	[entry(0x60000053)]
	int __stdcall WSANSPIoctl(
		void* hLookup,
		unsigned long dwControlCode,
		void* lpvInBuffer,
		unsigned long cbInBuffer,
		void* lpvOutBuffer,
		unsigned long cbOutBuffer,
		unsigned long* lpcbBytesReturned,
		void* lpCompletion);
	[entry(0x60000054)]
	int __stdcall WSALookupServiceEnd(
		void* hLookup);
	[entry(0x60000055)]
	int __stdcall WSAInstallServiceClassA(
		WSAServiceClassInfoA* lpServiceClassInfo);
	[entry(0x60000056)]
	int __stdcall WSAInstallServiceClassW(
		WSAServiceClassInfoW* lpServiceClassInfo);
	[entry(0x60000057)]
	int __stdcall WSARemoveServiceClass(
		GUID* lpServiceClassId);
	[entry(0x60000058)]
	int __stdcall WSAGetServiceClassInfoA(
		GUID* lpProviderId,
		GUID* lpServiceClassId,
		unsigned long* lpdwBufSize,
		WSAServiceClassInfoA* lpServiceClassInfo);
	[entry(0x60000059)]
	int __stdcall WSAGetServiceClassInfoW(
		GUID* lpProviderId,
		GUID* lpServiceClassId,
		unsigned long* lpdwBufSize,
		WSAServiceClassInfoW* lpServiceClassInfo);
	[entry(0x6000005a)]
	int __stdcall WSAEnumNameSpaceProvidersA(
		unsigned long* lpdwBufferLength,
		WSANAMESPACE_INFOA* lpnspBuffer);
	[entry(0x6000005b)]
	int __stdcall WSAEnumNameSpaceProvidersW(
		unsigned long* lpdwBufferLength,
		WSANAMESPACE_INFOW* lpnspBuffer);
	[entry(0x6000005c)]
	int __stdcall WSAGetServiceClassNameByClassIdA(
		GUID* lpServiceClassId,
		LPSTR lpszServiceClassName,
		unsigned long* lpdwBufferLength);
	[entry(0x6000005d)]
	int __stdcall WSAGetServiceClassNameByClassIdW(
		GUID* lpServiceClassId,
		LPWSTR lpszServiceClassName,
		unsigned long* lpdwBufferLength);
	[entry(0x6000005e)]
	int __stdcall WSASetServiceA(
		WSAQuerySetA* lpqsRegInfo,
		WSAESETSERVICEOP essoperation,
		unsigned long dwControlFlags);
	[entry(0x6000005f)]
	int __stdcall WSASetServiceW(
		WSAQuerySetW* lpqsRegInfo,
		WSAESETSERVICEOP essoperation,
		unsigned long dwControlFlags);
	[entry(0x60000060)]
	int __stdcall WSAProviderConfigChange(
		void** lpNotificationHandle,
		WSAOVERLAPPED* lpOverlapped,
		void* lpCompletionRoutine);
};
'!
!OS.WS2_32Library categoriesForClass!External-Libraries-Sockets!Windows Sockets! !
!OS.WS2_32Library methodsFor!

accept: s addr: addr addrlen: addrlen
	"Invoke the accept() function of the module wrapped by the receiver.

		unsigned int __stdcall accept(
			unsigned int s,
			sockaddr* addr,
			int* addrlen);"

	<overlap stdcall: handle accept handle void* sdword*>
	^self invalidCall: _failureCode!

bind: s name: name namelen: namelen
	"Invoke the bind() function of the module wrapped by the receiver.

		int __stdcall bind(
			unsigned int s,
			sockaddr* name,
			int namelen);"

	<overlap stdcall: errno bind handle void* sdword>
	^self invalidOverlappedCall: _failureCode!

close
	"We've finished using the socket system."

	wsaData notNil 
		ifTrue: 
			[wsaData := nil.
			self wsaCleanup].
	super close!

closesocket: s
	"Invoke the closesocket() function of the module wrapped by the receiver.

		int __stdcall closesocket(
			unsigned int s);"

	<stdcall: sdword closesocket handle>
	^self invalidCall: _failureCode!

connect: s name: name namelen: namelen
	"Invoke the connect() function of the module wrapped by the receiver.

		int __stdcall connect(
			unsigned int s,
			sockaddr* name,
			int namelen);"

	<overlap stdcall: errno connect handle void* sdword>
	^self invalidOverlappedCall: _failureCode!

gethostbyaddr: addr len: len type: type
	"Invoke the gethostbyaddr() function of the module wrapped by the receiver.

		hostent* __stdcall gethostbyaddr(
			CHAR* addr,
			int len,
			int Type);"

	<overlap stdcall: HOSTENT* gethostbyaddr lpvoid sdword sdword>
	^self invalidCall: _failureCode!

gethostbyname: name
	"Answer host information corresponding to a host name from the host database.

		hostent* __stdcall gethostbyname(
			CHAR* name);"

	<overlap stdcall: HOSTENT* gethostbyname lpstr>
	^self invalidCall: _failureCode!

gethostname: name namelen: namelen
	"Invoke the gethostname() function of the module wrapped by the receiver.

		int __stdcall gethostname(
			CHAR* name,
			int namelen);"

	<stdcall: errno GetHostNameW lpwstr sdword>
	^self invalidCall: _failureCode!

getpeername: s name: name namelen: namelen
	"Invoke the getpeername() function of the module wrapped by the receiver.

		int __stdcall getpeername(
			unsigned int s,
			sockaddr* name,
			int* namelen);"

	<stdcall: errno getpeername handle void* sdword*>
	^self invalidCall: _failureCode!

getprotobyname: name
	"Invoke the getprotobyname() function of the module wrapped by the receiver.

		protoent* __stdcall getprotobyname(
			CHAR* name);"

	<stdcall: PROTOENT* getprotobyname lpstr>
	^self invalidCall: _failureCode!

getprotobynumber: number
	"Invoke the getprotobynumber() function of the module wrapped by the receiver.

		protoent* __stdcall getprotobynumber(
			int number);"

	<stdcall: PROTOENT* getprotobynumber sdword>
	^self invalidCall: _failureCode!

getservbyname: name proto: proto
	"Invoke the getservbyname() function of the module wrapped by the receiver.

		servent* __stdcall getservbyname(
			CHAR* name,
			CHAR* proto);"

	<stdcall: SERVENT* getservbyname lpstr lpstr>
	^self invalidCall: _failureCode!

getservbyport: port proto: proto
	"Invoke the getservbyport() function of the module wrapped by the receiver.

		servent* __stdcall getservbyport(
			int Port,
			CHAR* proto);"

	<stdcall: SERVENT* getservbyport sdword lpstr>
	^self invalidCall: _failureCode!

getsockname: s name: name namelen: namelen
	"Invoke the getsockname() function of the module wrapped by the receiver.

		int __stdcall getsockname(
			unsigned int s,
			sockaddr* name,
			int* namelen);"

	<stdcall: errno getsockname handle void* sdword*>
	^self invalidCall: _failureCode!

getsockopt: s level: level optname: optname optval: optval optlen: optlen
	"Invoke the getsockopt() function of the module wrapped by the receiver.

		int __stdcall getsockopt(
			unsigned int s,
			int level,
			int optname,
			CHAR* optval,
			int* optlen);"

	<stdcall: errno getsockopt dword sdword sdword lpstr sdword*>
	^self invalidCall: _failureCode!

htonl: hostlong
	"Invoke the htonl() function of the module wrapped by the receiver.

		unsigned long __stdcall htonl(
			unsigned long hostlong);"

	<stdcall: dword htonl dword>
	^self invalidCall: _failureCode!

htons: hostshort
	"Invoke the htons() function of the module wrapped by the receiver.

		unsigned short __stdcall htons(
			unsigned short hostshort);"

	<stdcall: word htons word>
	^self invalidCall: _failureCode!

inet_addr: cp
	"Invoke the inet_addr() function of the module wrapped by the receiver.

		unsigned long __stdcall inet_addr(
			CHAR* cp);"

	<stdcall: dword inet_addr lpstr>
	^self invalidCall: _failureCode!

inet_ntop: saInteger pAddr: anIN_ADDR pStringBuf: aString stringBufSize: sizeInteger
	"Convert an IN_ADDR or IN6_ADDR to a string in canonical form."

	<stdcall: lpstr inet_ntop sdword void* lpstr sdword>
	^self invalidCall: _failureCode!

inet_pton: saInteger pszAddrString: aString pAddrBuf: anIN_ADDR
	"Convert an internet address expressed as a string to an IN_ADDR or IN6_ADDR."

	<stdcall: sdword inet_pton sdword lpstr void*>
	^self invalidCall: _failureCode!

initialize
	| version data |
	version := 2 bitOr: (0 bitShift: 8).
	data := WSADATA new.
	self wsaStartup: version lpWSAData: data.
	wsaData := data!

invalidCall: anInteger
	"Private - An invalid external call was attempted through one of the receiver's methods. The argument is the failure code from the external call primitive."

	^anInteger == SOCKET_ERROR ifTrue: [Net.SocketError signal] ifFalse: [super invalidCall: anInteger]!

invalidOverlappedCall: anInteger
	"Private - An invalid overlapped external call was attempted through one of the receiver's methods. The argument is the failure code from the external call primitive."

	^anInteger == SOCKET_ERROR
		ifTrue: [Net.SocketError signalWith: Processor activeProcess lastError]
		ifFalse: [super invalidCall: anInteger]!

ioctlsocket: s cmd: cmd argp: argp
	"Invoke the ioctlsocket() function of the module wrapped by the receiver.

		int __stdcall ioctlsocket(
			unsigned int s,
			long cmd,
			unsigned long* argp);"

	<stdcall: errno ioctlsocket dword sdword dword*>
	^self invalidCall: _failureCode!

listen: s backlog: backlog
	"Invoke the listen() function of the module wrapped by the receiver.

		int __stdcall listen(
			unsigned int s,
			int backlog);"

	<stdcall: errno listen dword sdword>
	^self invalidCall: _failureCode!

ntohl: netlong
	"Invoke the ntohl() function of the module wrapped by the receiver.

		unsigned long __stdcall ntohl(
			unsigned long netlong);"

	<stdcall: dword ntohl dword>
	^self invalidCall: _failureCode!

ntohs: netshort
	"Invoke the ntohs() function of the module wrapped by the receiver.

		unsigned short __stdcall ntohs(
			unsigned short netshort);"

	<stdcall: word ntohs word>
	^self invalidCall: _failureCode!

recv: s buf: buf len: len flags: flags
	"Invoke the recv() function of the module wrapped by the receiver.

		int __stdcall recv(
			unsigned int s,
			CHAR* buf,
			int len,
			int flags);"

	<overlap stdcall: sdword recv dword void* sdword sdword>
	^self invalidCall: _failureCode!

recvfrom: s buf: buf len: len flags: flags from: from fromlen: fromlen
	"Invoke the recvfrom() function of the module wrapped by the receiver.

		int __stdcall recvfrom(
			unsigned int s,
			CHAR* buf,
			int len,
			int flags,
			sockaddr* from,
			int* fromlen);"

	<overlap stdcall: sdword recvfrom dword void* sdword sdword void* sdword*>
	^self invalidCall: _failureCode!

select: nfds readfds: readfds writefds: writefds exceptfds: exceptfds timeout: timeout
	"Invoke the select() function of the module wrapped by the receiver.

		int __stdcall select(
			int nfds,
			fd_set* readfds,
			fd_set* writefds,
			fd_set* exceptfds,
			timeval* timeout);"

	<overlap stdcall: sdword select sdword FD_SET* FD_SET* FD_SET* TIMEVAL*>
	^self invalidCall: _failureCode!

send: s buf: buf len: len flags: flags
	"Invoke the send() function of the module wrapped by the receiver.

		int __stdcall send(
			unsigned int s,
			CHAR* buf,
			int len,
			int flags);"

	<overlap stdcall: sdword send dword void* sdword sdword>
	^self invalidCall: _failureCode!

sendto: s buf: buf len: len flags: flags to: to tolen: tolen
	"Invoke the sendto() function of the module wrapped by the receiver.

		int __stdcall sendto(
			unsigned int s,
			CHAR* buf,
			int len,
			int flags,
			sockaddr* to,
			int tolen);"

	<overlap stdcall: sdword sendto dword void* sdword sdword void* sdword>
	^self invalidCall: _failureCode!

setsockopt: s level: level optname: optname optval: optval optlen: optlen
	"Invoke the setsockopt() function of the module wrapped by the receiver.

		int __stdcall setsockopt(
			unsigned int s,
			int level,
			int optname,
			CHAR* optval,
			int optlen);"

	<stdcall: errno setsockopt dword sdword sdword lpvoid sdword>
	^self invalidCall: _failureCode!

shutdown: s how: how
	"Invoke the shutdown() function of the module wrapped by the receiver.

		int __stdcall shutdown(
			unsigned int s,
			int how);"

	<stdcall: sdword shutdown dword sdword>
	^self invalidCall: _failureCode!

socket: af type: type protocol: protocol
	"Invoke the socket() function of the module wrapped by the receiver.

		unsigned int __stdcall socket(
			int af,
			int Type,
			int protocol);"

	<stdcall: handle socket sdword sdword sdword>
	^self invalidCall: _failureCode!

wsaAddressToStringW: lpsaAddress dwAddressLength: dwAddressLength lpProtocolInfo: lpProtocolInfo lpszAddressString: lpszAddressString lpdwAddressStringLength: lpdwAddressStringLength
	"Invoke the WSAAddressToStringW() function of the module wrapped by the receiver.

		int __stdcall WSAAddressToStringA(
			[in]SOCKADDR* lpsaAddress,
			[in]unsigned long dwAddressLength,
			[in]void* lpProtocolInfo,
			[in, out]LPWSTR lpszAddressString,
			[in, out]unsigned long* lpdwAddressStringLength);"

	<stdcall: errno WSAAddressToStringW SOCKADDR* dword void* lpwstr dword*>
	^self invalidCall: _failureCode!

wsaCleanup
	"Invoke the WSACleanup() function of the module wrapped by the receiver.

		int __stdcall WSACleanup();"

	<stdcall: sdword WSACleanup>
	^self invalidCall: _failureCode!

wsaGetLastError
	"Invoke the WSAGetLastError() function of the module wrapped by the receiver.

		int __stdcall WSAGetLastError();"

	<stdcall: sdword WSAGetLastError>
	^self invalidCall: _failureCode!

wsaStartup: wVersionRequested lpWSAData: lpWSAData
	"Invoke the WSAStartup() function of the module wrapped by the receiver.

		int __stdcall WSAStartup(
			[in]unsigned short wVersionRequested,
			[out]WSAData* lpWSAData);"

	<stdcall: errno WSAStartup word WSADATA*>
	^_failureCode > 0
		ifTrue: [Net.SocketError signalWith: _failureCode]
		ifFalse: [super invalidCall: _failureCode]! !
!OS.WS2_32Library categoriesFor: #accept:addr:addrlen:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #bind:name:namelen:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #close!public!realizing/unrealizing! !
!OS.WS2_32Library categoriesFor: #closesocket:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #connect:name:namelen:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #gethostbyaddr:len:type:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #gethostbyname:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #gethostname:namelen:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #getpeername:name:namelen:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #getprotobyname:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #getprotobynumber:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #getservbyname:proto:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #getservbyport:proto:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #getsockname:name:namelen:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #getsockopt:level:optname:optval:optlen:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #htonl:!**auto generated**!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #htons:!**auto generated**!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #inet_addr:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #inet_ntop:pAddr:pStringBuf:stringBufSize:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #inet_pton:pszAddrString:pAddrBuf:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #initialize!initializing!private! !
!OS.WS2_32Library categoriesFor: #invalidCall:!exceptions!private! !
!OS.WS2_32Library categoriesFor: #invalidOverlappedCall:!exceptions!private! !
!OS.WS2_32Library categoriesFor: #ioctlsocket:cmd:argp:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #listen:backlog:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #ntohl:!**auto generated**!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #ntohs:!**auto generated**!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #recv:buf:len:flags:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #recvfrom:buf:len:flags:from:fromlen:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #select:readfds:writefds:exceptfds:timeout:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #send:buf:len:flags:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #sendto:buf:len:flags:to:tolen:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #setsockopt:level:optname:optval:optlen:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #shutdown:how:!**auto generated**!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #socket:type:protocol:!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #wsaAddressToStringW:dwAddressLength:lpProtocolInfo:lpszAddressString:lpdwAddressStringLength:!**auto generated**!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #wsaCleanup!**auto generated**!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #wsaGetLastError!**auto generated**!public!win32 functions-sockets library! !
!OS.WS2_32Library categoriesFor: #wsaStartup:lpWSAData:!public!win32 functions-sockets library! !

!OS.WS2_32Library class methodsFor!

fileName
	"Answer the host system file name of the external library which the 
	receiver represents"

	^'WS2_32'! !
!OS.WS2_32Library class categoriesFor: #fileName!constants!public! !

