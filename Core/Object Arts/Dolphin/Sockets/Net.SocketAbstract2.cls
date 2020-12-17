"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SocketAbstract2
	instanceVariableNames: 'port descriptor'
	classVariableNames: ''
	poolDictionaries: 'WinSocketConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
SocketAbstract2 guid: (GUID fromString: '{e811faf7-4001-4b49-bda0-90a3ffae784f}')!
SocketAbstract2 comment: 'This class is the abstract superclass of all sockets classes for TCP/IP network communication.'!
!SocketAbstract2 categoriesForClass!Windows Sockets! !
!SocketAbstract2 methodsFor!

asParameter
	"Answer the receiver in a form suitable for passing to an external function."

	descriptor isNull ifTrue: [self errorSocketClosed].
	^descriptor!

close
	"Close the socket."

	descriptor isNull ifTrue: [^self].
	WS2_32Library default closesocket: descriptor.
	descriptor := nil!

create
	"Private - Create a new socket."

	| sd |
	sd := WS2_32Library default 
				socket: AF_INET
				type: SOCK_STREAM
				protocol: 0.
	sd = INVALID_SOCKET ifTrue: [^self socketError].
	descriptor := sd.
	self beFinalizable!

descriptor: anIntege 
	descriptor := anIntege asExternalHandle!

errorSocketClosed
	^SocketClosed signal!

finalize
	"Private - Sent when the object no longer has any strong references to it.
	Frees the external resources by closing the socket."

	self close!

initialize
	"Private - Initialize the receiver."

	self beFinalizable!

isOpen
	"Answer true if the receiver is open"

	^descriptor notNull!

port
	"Answer the port instance variable."

	^port!

port: anInteger 
	"Private - Set the port instance variable to anInteger."

	port := anInteger!

printOn: aStream 
	"Append, to aStream, a String whose characters are a description
	of the receiver as a developer would want to see it."

	aStream
		basicPrint: self;
		nextPut: $(;
		display: descriptor;
		nextPut: $)!

queryPort
	"Lookup the port using getsockname().  Answer the result as a SmallInteger,
	or signal a socket error."

	| name nameLength |
	name := (SOCKADDR_IN new)
				sin_family: AF_INET;
				yourself.
	nameLength := (SDWORD new)
				value: name size;
				yourself.
	(WS2_32Library default 
		getsockname: self asParameter
		name: name
		namelen: nameLength) = SOCKET_ERROR 
		ifTrue: [^self socketError].
	^name port!

socketError
	"Private - Raise a <SocketError> in response to an error in a non-overlapped socket library call."

	SocketError signalWith: WS2_32Library default wsaGetLastError!

socketErrorOverlap
	"Private - Raise a <SocketError> in response to an error in an overlapped socket library call."

	SocketError signalWith: Processor activeProcess lastError! !
!SocketAbstract2 categoriesFor: #asParameter!converting!public! !
!SocketAbstract2 categoriesFor: #close!operations!public! !
!SocketAbstract2 categoriesFor: #create!operations!private! !
!SocketAbstract2 categoriesFor: #descriptor:!initializing!private! !
!SocketAbstract2 categoriesFor: #errorSocketClosed!operations!private! !
!SocketAbstract2 categoriesFor: #finalize!finalizing!private! !
!SocketAbstract2 categoriesFor: #initialize!initializing!private! !
!SocketAbstract2 categoriesFor: #isOpen!public!testing! !
!SocketAbstract2 categoriesFor: #port!accessing!public! !
!SocketAbstract2 categoriesFor: #port:!accessing!private! !
!SocketAbstract2 categoriesFor: #printOn:!printing!public! !
!SocketAbstract2 categoriesFor: #queryPort!accessing!public! !
!SocketAbstract2 categoriesFor: #socketError!exceptions!private! !
!SocketAbstract2 categoriesFor: #socketErrorOverlap!operations!private! !

