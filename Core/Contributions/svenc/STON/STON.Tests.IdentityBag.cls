"Filed out from Dolphin Smalltalk"!

Core.Bag
	subclass: #'STON.Tests.IdentityBag'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.IdentityBag guid: (Core.GUID fromString: '{fb43e6dd-9db4-448c-966d-a932ceab3751}')!
STON.Tests.IdentityBag comment: 'Dolphin doesn''t have an IdentityBag class (it isn''t necessary because Bag''s can work in identity comparison mode if instantiated with `#identityNew[:]`), but the class is referred to directly by the STON tests.'!
!STON.Tests.IdentityBag categoriesForClass!Collections-Unordered! !
!STON.Tests.IdentityBag class methodsFor!

identityNew: anInteger
	"Answer a new instance of the receiver with sufficient initial capacity for anInteger unique
	elements, which uses identity as the comparison for identifying duplicate elements."

	^self basicNew contents: (IdentityDictionary new: anInteger)!

new
	"Answer a new instance of the receiver with default initial capacity, 
	which uses equality as the comparison for identifying duplicate elements."

	^self identityNew! !
!STON.Tests.IdentityBag class categoriesForMethods!
identityNew:!instance creation!public! !
new!instance creation!public! !
!

