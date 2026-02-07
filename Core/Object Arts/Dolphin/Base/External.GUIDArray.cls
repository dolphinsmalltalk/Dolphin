"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'External.GUIDArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.GUIDArray guid: (Core.GUID fromString: '{7bac3346-147f-4197-a91e-fae2700c2a97}')!

External.GUIDArray comment: ''!

!External.GUIDArray methodsFor!

basicUncheckedAt: anInteger
	^self elementClass fromAddress: bytes yourAddress + ((anInteger - 1) * GUID._GUID_Size) owner: self!

basicUncheckedAt: anInteger put: aGUID
	aGUID
		replaceBytesOf: bytes
		from: (anInteger - 1) * GUID._GUID_Size + 1
		to: anInteger * GUID._GUID_Size
		startingAt: 1.
	^aGUID! !

!External.GUIDArray categoriesForMethods!
basicUncheckedAt:!accessing!private! !
basicUncheckedAt:put:!accessing!private! !
!

!External.GUIDArray class methodsFor!

elementClass
	^GUID! !

!External.GUIDArray class categoriesForMethods!
elementClass!constants!public! !
!

