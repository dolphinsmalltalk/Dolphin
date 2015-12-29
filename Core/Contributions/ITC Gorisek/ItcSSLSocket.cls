"Filed out from Dolphin Smalltalk X6.2"!

Socket subclass: #ItcSSLSocket
	instanceVariableNames: 'method ctx handle'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ItcSSLSocket guid: (GUID fromString: '{A9DDC2AC-1737-49A0-AC5C-835609ED6020}')!
ItcSSLSocket comment: 'A subclass of Socket that can connect via the SSL protocol using the OpenSSL libraries.

Author: Chris Double
mailto: chris@double.co.nz
http://www.double.co.nz/smalltalk'!
!ItcSSLSocket categoriesForClass!Unclassified! !
!ItcSSLSocket methodsFor!

basicConnect
	"Private - Attempt a socket connection to a host and establish a SSL client to server session."

	self
		basicConnectSSL: #sslv23ClientMethod;
		registerDescriptor;
		allowAsyncEvents!

basicConnectSocket
	"Private - Attempt a normal socket connection to a host."

	| result socketAddress |
	self create.
	(socketAddress := SOCKADDR_IN new)
		sin_family: AF_INET;
		sin_port: (WSockLibrary default htons: self port);
		sin_addr: (IN_ADDR address: self address).
	result := WSockLibrary default 
				connect: self asParameter
				name: socketAddress asParameter
				namelen: socketAddress byteSize.
	result = 0 
		ifFalse: 
			["The call is overlapped, so any error that occurred will have been stored into the Process
		 by the overlapped call primitive"
			SocketError signalWith: Processor activeProcess lastError]!

basicConnectSSL: clientConnectMethod 
	"Private - Establish SSL session with given SSL client connect method.
	Sometimes SSL session can not be set-up if #sslv23ClientMethod is used.
	In that case it will try again with the #sslv3ClientMethod."

	| result errorCode |
	self basicConnectSocket.
	
	[method := clientConnectMethod == #sslv23ClientMethod 
				ifTrue: [LIBSSL32Library default sslv23ClientMethod]
				ifFalse: [LIBSSL32Library default sslv3ClientMethod].
	ctx := LIBSSL32Library default sslCtxNew: method.
	handle := LIBSSL32Library default sslNew: ctx.
	(result := LIBSSL32Library default sslSetFd: handle descriptor: self descriptor) <= 0 
		ifTrue: [self sslError].
	(result := LIBSSL32Library default sslConnect: handle) = 1 
		ifFalse: 
			[ItcSystemManager logDevTimeError: 'SSL connect error result=' , result printString.
			ItcSystemManager 
				logDevTimeError: ['SSL state=' , (LIBSSL32Library default sslStateStringLong: handle) printString].
			"SSL_ERROR_SYSCALL-5"
			errorCode := LIBSSL32Library default sslGetError: handle code: result.
			(errorCode = 5 and: [clientConnectMethod == #sslv23ClientMethod]) 
				ifTrue: 
					[(errorCode := LIBEAY32Library default errGetError) = 0 
						ifTrue: 
							["no error, this happens without any reason on some servers (maybe a bug in OpenSSL),
							try the workaround by connecting again with #sslv3ClientMethod"
							ItcSystemManager logDevTimeError: 'SSL reconnecting with another method #sslv3ClientMethod'.
							self releaseSSL.
							self descriptor notNil ifTrue: [WSockLibrary default closesocket: self descriptor].
							self basicConnectSSL: #sslv3ClientMethod]
						ifFalse: [self sslError: errorCode]]
				ifFalse: [self sslErrorFromResult: errorCode]]] 
			ifCurtailed: 
				[self releaseSSL.
				self descriptor notNil ifTrue: [WSockLibrary default closesocket: self descriptor]]!

basicReceiveByteArray: anInteger 
	"Private - Reads anInteger bytes from the socket.
	Answers a ByteArray representing the bytes read."

	| bytesReceived byteArray errorCode nrTries |
	byteArray := ByteArray new: anInteger.
	nrTries := 0.
	
	[bytesReceived := LIBSSL32Library default 
				sslRead: handle
				buffer: byteArray
				length: byteArray size.
	bytesReceived > 0 
		ifTrue: 
			["Success."
			^byteArray copyFrom: 1 to: bytesReceived].
	bytesReceived = 0 
		ifTrue: 
			["Socket has been closed."
			SocketClosed signal].
	"Some other error."
	errorCode := LIBSSL32Library default sslGetError: handle code: bytesReceived.
	"repeat if SSL_ERROR_WANT_READ is returned"
	errorCode = 2 and: [nrTries < 3000]] 
			whileTrue: 
				[(Delay forMilliseconds: 100) wait.
				ItcSystemManager logDevTimeError: 'SSL_ERROR_WANT_READ - repeating request'.
				nrTries := nrTries + 1].
	self sslErrorFromResult: errorCode!

basicSendByteArray: aByteArray 
	"Private - Sends aByteArray through the socket."

	| result errorCode nrTries |
	nrTries := 0.
	
	[result := LIBSSL32Library default 
				sslWrite: handle
				buffer: aByteArray
				length: aByteArray size.
	result >= 0 ifTrue: [^result].

	"Some other error."
	errorCode := LIBSSL32Library default sslGetError: handle code: result.
	"repeat if SSL_ERROR_WANT_WRITE is returned"
	errorCode = 3 and: [nrTries < 3000]] 
			whileTrue: 
				[(Delay forMilliseconds: 100) wait.
				ItcSystemManager logDevTimeError: 'SSL_ERROR_WANT_WRITE - repeating request'.
				nrTries := nrTries + 1].
	self sslErrorFromResult: errorCode!

close
	"Close the socket."

	handle isNil ifFalse: [LIBSSL32Library default sslShutdown: handle].
	super close.
	self releaseSSL!

initialize
	"Private - Initialize the receiver."

	super initialize.
        method := nil.
	ctx := nil.
	handle := nil.
!

releaseSSL
	"Private - Release SSL handles."

	handle isNil ifFalse: [LIBSSL32Library default sslFree: handle].
	handle := nil.
	ctx isNil ifFalse: [LIBSSL32Library default sslCtxFree: ctx].
	ctx := nil.
	method := nil!

sslError
	self sslError: LIBEAY32Library default errGetError!

sslError: errorCode 
	| errorString |
	ItcSystemManager logDevTimeError: 'SSL ERROR STRING FOR CODE=' , errorCode asWebString.
	errorString := ByteArray new: 256.
	LIBEAY32Library default errErrorString: errorCode buf: errorString.
	self sslError: errorCode descriptor: errorString asString!

sslError: errorCode descriptor: description 
	self error: '[SSL-' , errorCode asWebString , '] ' , description asWebString!

sslErrorFromResult: errorResult 
	ItcSystemManager logDevTimeError: 'SSL ERROR RESULT=' , errorResult asWebString.
	errorResult = 1 
		ifTrue: 
			["SSL_ERROR_SSL - find more infor in the error queue"
			ItcSystemManager logDevTimeError: 'SSL_ERROR_SSL'.
			^self sslError].
	errorResult = 5 
		ifTrue: 
			["SSL_ERROR_SYSCALL - find more infor in the error queue"
			ItcSystemManager logDevTimeError: 'SSL_ERROR_SYSCALL'.
			^self sslError].
	errorResult = 2 ifTrue: [^self sslError: 'E2' descriptor: 'SSL_ERROR_WANT_READ'].
	errorResult = 3 ifTrue: [^self sslError: 'E3' descriptor: 'SSL_ERROR_WANT_WRITE'].
	self sslError: 'E' , errorResult printString
		descriptor: 'Unknown error, see file SSL.H for more about this error code.'! !
!ItcSSLSocket categoriesFor: #basicConnect!private! !
!ItcSSLSocket categoriesFor: #basicConnectSocket!private! !
!ItcSSLSocket categoriesFor: #basicConnectSSL:!private! !
!ItcSSLSocket categoriesFor: #basicReceiveByteArray:!private! !
!ItcSSLSocket categoriesFor: #basicSendByteArray:!private! !
!ItcSSLSocket categoriesFor: #close!public! !
!ItcSSLSocket categoriesFor: #initialize!private! !
!ItcSSLSocket categoriesFor: #releaseSSL!private! !
!ItcSSLSocket categoriesFor: #sslError!private! !
!ItcSSLSocket categoriesFor: #sslError:!private! !
!ItcSSLSocket categoriesFor: #sslError:descriptor:!private! !
!ItcSSLSocket categoriesFor: #sslErrorFromResult:!private! !

