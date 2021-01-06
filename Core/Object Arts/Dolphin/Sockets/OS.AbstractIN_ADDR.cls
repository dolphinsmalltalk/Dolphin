"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'OS.AbstractIN_ADDR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.AbstractIN_ADDR guid: (Core.GUID fromString: '{92297cf1-48a8-4480-aa8b-8c04d20683c3}')!
OS.AbstractIN_ADDR isNonInstantiable: true!
OS.AbstractIN_ADDR comment: '`OS.AbstractIN_ADDR` is an abstract `External.Structure` class providing common behavior for the `OS.IN_ADDR` and `OS.IN6_ADDR` structures, that provide binary representations of IPv4 and IPv6 addresses, respectively.'!
!OS.AbstractIN_ADDR categoriesForClass!Win32-Structs! !
!OS.AbstractIN_ADDR methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	In this case we print the address in the standard IPv4 or IPv6 format."

	self isNull
		ifTrue: [aPuttableStream display: nil]
		ifFalse: 
			[| buf |
			buf := AnsiString newFixed: WinSocketConstants.INET6_ADDRSTRLEN.
			aPuttableStream nextPutAll: (WS2_32Library default
						inet_ntop: self class addressFamily
						pAddr: self
						pStringBuf: buf
						stringBufSize: buf size)]!

printFieldsOn: aStream
	self isNull ifTrue: [aStream nextPutAll: 'NULL'] ifFalse: [self displayOn: aStream]! !
!OS.AbstractIN_ADDR categoriesFor: #displayOn:!displaying!public! !
!OS.AbstractIN_ADDR categoriesFor: #printFieldsOn:!development!printing!private! !

!OS.AbstractIN_ADDR class methodsFor!

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
				ifFalse: [Net.SocketError signalWith: lib wsaGetLastError]].
	^answer! !
!OS.AbstractIN_ADDR class categoriesFor: #addressFamily!constants!public! !
!OS.AbstractIN_ADDR class categoriesFor: #fromString:!public! !

