"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #AbstractIN_ADDR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractIN_ADDR guid: (GUID fromString: '{92297cf1-48a8-4480-aa8b-8c04d20683c3}')!
AbstractIN_ADDR isAbstract: true!
AbstractIN_ADDR comment: '<AbstractIN_ADDR> is an abstract <ExternalStructure> class providing common behavior for the IN_ADDR and IN6_ADDR structures, that provide binary representations of IPv4 and IPv6 addresses, respectively.'!
!AbstractIN_ADDR categoriesForClass!Win32-Structs! !
!AbstractIN_ADDR methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	In this case we print the address in the standard IPv4 or IPv6 format."

	self isNull
		ifTrue: [aPuttableStream display: nil]
		ifFalse: 
			[| buf |
			buf := String newFixed: WinSocketConstants.INET6_ADDRSTRLEN.
			aPuttableStream nextPutAll: (WS2_32Library default
						inet_ntop: self class addressFamily
						pAddr: self
						pStringBuf: buf
						stringBufSize: buf size)]!

printFieldsOn: aStream
	self isNull ifTrue: [aStream nextPutAll: 'NULL'] ifFalse: [self displayOn: aStream].
	self displayOn: aStream! !
!AbstractIN_ADDR categoriesFor: #displayOn:!displaying!public! !
!AbstractIN_ADDR categoriesFor: #printFieldsOn:!development!printing!private! !

!AbstractIN_ADDR class methodsFor!

addressFamily
	^self subclassResponsibility!

fromString: aString
	| answer ret lib |
	answer := self newBuffer.
	lib := WS2_32Library default.
	ret := lib
				inet_pton: self addressFamily
				pszAddrString: aString
				pAddrBuf: answer.
	ret <= 0
		ifTrue: 
			[ret == 0
				ifTrue: [InvalidFormat signalWith: self]
				ifFalse: [SocketError signalWith: lib wsaGetLastError]].
	^answer! !
!AbstractIN_ADDR class categoriesFor: #addressFamily!constants!public! !
!AbstractIN_ADDR class categoriesFor: #fromString:!public! !

