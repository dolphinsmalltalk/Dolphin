"Filed out from Dolphin Smalltalk"!

Kernel.STBInFiler2
	subclass: #'Kernel.STBInFiler3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.STBInFiler3 guid: (Core.GUID fromString: '{dc7c10d2-edd9-43d2-96ee-8b15da7f3a11}')!

Kernel.STBInFiler3 comment: '`STBInFiler3` is an `STBInFiler` for reading the STB 3 binary object serialization format.

STB 3 was introduced in Dolphin 6. The key difference from STB 2 was that an object size was only written for indexable objects, rather than all objects. This was done to reduce the size of the serialized data.'!

!Kernel.STBInFiler3 methodsFor!

readSizeOf: aClass
	"Read the indexable size of an object of the specified <Class> from the object stream."

	"As of STB version 3, the out-filer only writes the object size for indexable objects."

	^aClass isVariable ifTrue: [stream nextInt32] ifFalse: [0]! !

!Kernel.STBInFiler3 categoriesForMethods!
readSizeOf:!deserializing!public! !
!

!Kernel.STBInFiler3 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	^3! !

!Kernel.STBInFiler3 class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

