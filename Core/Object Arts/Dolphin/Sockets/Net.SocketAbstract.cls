"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Net.SocketAbstract'
	instanceVariableNames: 'port descriptor'
	classVariableNames: ''
	imports: #(#{OS.WinSocketConstants})
	classInstanceVariableNames: ''
	classConstants: {}!

Net.SocketAbstract guid: (Core.GUID fromString: '{e811faf7-4001-4b49-bda0-90a3ffae784f}')!

Net.SocketAbstract isNonInstantiable: true!

Net.SocketAbstract comment: 'This class is the abstract superclass of all sockets classes for TCP/IP network communication.'!

!Net.SocketAbstract categoriesForClass!Windows Sockets! !

!Net.SocketAbstract methodsFor!

asParameter
	"Answer the receiver in a form suitable for passing to an external function."

	descriptor isNull ifTrue: [self errorSocketClosed].
	^descriptor!

close
	"Close the socket."

	descriptor isNull ifTrue: [^self].
	Ws2_32 closesocket: descriptor.
	descriptor := nil!

create
	"Private - Create a new socket."

	| sd |
	sd := Ws2_32
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
	name := SOCKADDR_IN new
				sin_family: AF_INET;
				yourself.
	nameLength := Int32 new
				value: name size;
				yourself.
	Ws2_32
		getsockname: self asParameter
		name: name
		namelen: nameLength.
	^name port!

socketError
	"Private - Raise a <SocketError> in response to an error in a non-overlapped socket library call."

	SocketError signalWith: Ws2_32 wsaGetLastError!

socketErrorOverlap
	"Private - Raise a <SocketError> in response to an error in an overlapped socket library call."

	SocketError signalWith: Processor activeProcess lastError! !

!Net.SocketAbstract categoriesForMethods!
asParameter!converting!public! !
close!operations!public! !
create!operations!private! !
descriptor:!initializing!private! !
errorSocketClosed!operations!private! !
finalize!finalizing!private! !
initialize!initializing!private! !
isOpen!public!testing! !
port!accessing!public! !
port:!accessing!private! !
printOn:!printing!public! !
queryPort!accessing!public! !
socketError!exceptions!private! !
socketErrorOverlap!operations!private! !
!

