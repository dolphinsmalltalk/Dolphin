"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.AbstractIN_ADDR'
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
			aPuttableStream nextPutAll: (Ws2_32
						inet_ntop: self class addressFamily
						pAddr: self
						pStringBuf: buf
						stringBufSize: buf size)]!

printFieldsOn: aStream
	self isNull ifTrue: [aStream nextPutAll: 'NULL'] ifFalse: [self displayOn: aStream]! !
!OS.AbstractIN_ADDR categoriesForMethods!
displayOn:!displaying!public! !
printFieldsOn:!development!printing!private! !
!

!OS.AbstractIN_ADDR class methodsFor!

addressFamily
	^self subclassResponsibility!

fromString: aString
	| answer ret |
	answer := self newBuffer.
	ret := Ws2_32
				inet_pton: self addressFamily
				pszAddrString: aString
				pAddrBuf: answer.
	ret <= 0
		ifTrue: 
			[ret == 0
				ifTrue: [InvalidFormat signalWith: self]
				ifFalse: [Net.SocketError signalWith: Ws2_32 wsaGetLastError]].
	^answer! !
!OS.AbstractIN_ADDR class categoriesForMethods!
addressFamily!constants!public! !
fromString:!public! !
!

