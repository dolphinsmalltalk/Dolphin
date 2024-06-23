"Filed out from Dolphin Smalltalk"!

Kernel.STBLegacyOutFiler
	subclass: #'Kernel.STBOutFiler5'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.STBOutFiler5 guid: (Core.GUID fromString: '{41a6dbc5-86f4-4ff3-bc85-06852ecadf15}')!

Kernel.STBOutFiler5 comment: '`STBOutFiler5` is an `STBOutFiler` for writing the STB 5 binary object serialization format.

STB 5 was an interim format used in early versions of Dolphin 8. It introduced support for classes located by fully-qualified names (i.e. for namespaces).'!

!Kernel.STBOutFiler5 categoriesForClass!System-Binary storage! !

!Kernel.STBOutFiler5 methodsFor!

inFilerClass
	^STBInFiler5! !

!Kernel.STBOutFiler5 categoriesForMethods!
inFilerClass!constants!private! !
!

!Kernel.STBOutFiler5 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	^5! !

!Kernel.STBOutFiler5 class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

