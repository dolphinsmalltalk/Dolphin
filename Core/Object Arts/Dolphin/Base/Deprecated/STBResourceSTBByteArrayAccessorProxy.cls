﻿"Filed out from Dolphin Smalltalk"!

Kernel.STxProxy
	subclass: #STBResourceSTBByteArrayAccessorProxy
	instanceVariableNames: 'bytes'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

STBResourceSTBByteArrayAccessorProxy guid: (Core.GUID fromString: '{87b4c6f0-026e-11d3-9fd7-00a0cc3e4a32}')!

STBResourceSTBByteArrayAccessorProxy comment: ''!

!STBResourceSTBByteArrayAccessorProxy categoriesForClass!System-Binary storage! !

!STBResourceSTBByteArrayAccessorProxy methodsFor!

bytes: aByteArray
	"Private - Set the receiver's bytes inst var to a ByteArray."

	bytes := aByteArray!

stbFixup: inFiler at: anInteger
	"Answer the object that this one represents.
	We propagate the codebase of the loading STBInFiler into the reconstituted
	accessor so that it can resolve any remote class references within its
	resource data."

	| accessor classLocator |
	classLocator := inFiler classLocator copyWithCodeBase.
	(accessor := ResourceSTBByteArrayAccessor onByteArray: bytes) classLocator: classLocator.

	self become: accessor! !

!STBResourceSTBByteArrayAccessorProxy categoriesForMethods!
bytes:!accessing!private! !
stbFixup:at:!converting!public! !
!

!STBResourceSTBByteArrayAccessorProxy class methodsFor!

forAccessor: aResourceSTBByteArrayAccessor
	"Answer a new initialized instance of the receiver encoding aResourceSTBByteArrayAccessor.
	This proxy allows us the opportunity to set up the accessor's classLocator to that held by the
	STBInFiler used to load it. This then enables the STBInFiler to generate a ClassStub for any
	remote class references embedded in the STB."

	^self basicNew
		bytes: aResourceSTBByteArrayAccessor byteArray;
		yourself! !

!STBResourceSTBByteArrayAccessorProxy class categoriesForMethods!
forAccessor:!instance creation!public! !
!

