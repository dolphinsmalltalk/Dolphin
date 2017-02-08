"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #AbstractIN_ADDR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractIN_ADDR guid: (GUID fromString: '{92297CF1-48A8-4480-AA8B-8C04D20683C3}')!
AbstractIN_ADDR comment: ''!
!AbstractIN_ADDR categoriesForClass!Win32-Structs! !
!AbstractIN_ADDR methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it. In this case we print the address in the colon separated IPv6 format."

	| buf |
	buf := String newFixed: 46.
	aStream nextPutAll: (WS2_32Library default
				inet_ntop: self class addressFamily
				pAddr: self
				pStringBuf: buf
				stringBufSize: buf size).
	^self!

printFieldsOn: aStream limit: anInteger
	self isNull ifTrue: [^super printFieldsOn: aStream limit: anInteger].
	self displayOn: aStream! !
!AbstractIN_ADDR categoriesFor: #displayOn:!displaying!public! !
!AbstractIN_ADDR categoriesFor: #printFieldsOn:limit:!development!printing!private! !

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
				ifTrue: [self error: 'Invalid IP address string: ' , aString]
				ifFalse: [SocketError signalWith: lib wsaGetLastError]].
	^answer! !
!AbstractIN_ADDR class categoriesFor: #addressFamily!public! !
!AbstractIN_ADDR class categoriesFor: #fromString:!public! !

