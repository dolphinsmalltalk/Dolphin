"Filed out from Dolphin Smalltalk"!

Bag subclass: #IdentityBag
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdentityBag guid: (GUID fromString: '{fb43e6dd-9db4-448c-966d-a932ceab3751}')!
IdentityBag comment: 'Dolphin doesn''t have an IdentityBag class (it isn''t necessary because Bag''s can work in identity comparison mode if instantiated with `#identityNew[:]`), but the class is referred to directly by the STON tests.'!
!IdentityBag categoriesForClass!Collections-Unordered! !
!IdentityBag class methodsFor!

identityNew: anInteger
	"Answer a new instance of the receiver with sufficient initial capacity for anInteger unique
	elements, which uses identity as the comparison for identifying duplicate elements."

	^self basicNew contents: (IdentityDictionary new: anInteger)!

new
	"Answer a new instance of the receiver with default initial capacity, 
	which uses equality as the comparison for identifying duplicate elements."

	^self identityNew! !
!IdentityBag class categoriesForMethods!
identityNew:!instance creation!public! !
new!instance creation!public! !
!

