"Filed out from Dolphin Smalltalk"!

Kernel.STLLegacyOutFiler
	subclass: #'Kernel.STLOutFiler5'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.STLOutFiler5 guid: (Core.GUID fromString: '{d957aa21-9a85-4b10-b385-aae6060f6245}')!

Kernel.STLOutFiler5 comment: '`STLOutFiler5` is a `STLOutFiler` for writing object graphs in the STL 5 format. This was an interim format supporting namespaces that was used in some pre-production versions of Dolphin 8.'!

!Kernel.STLOutFiler5 categoriesForClass!System-Binary storage! !

!Kernel.STLOutFiler5 methodsFor!

inFilerClass
	^STLInFiler5!

saveCharacter: aCharacter
	"Serialize a <Character> to the object stream."

	"STL 4/5 wrongly wrote all characters, even non-atomic ones, directly as literals to the stream. Only the byte characters should have been written this way as this will not preserved identity for non-byte characters."

	stream nextPut: aCharacter!

saveFloat: aFloat
	"Serialize a <Float> to the object stream."

	"In STL 5 Floats are stored in literal form if finite, and as raw bytes if not."

	aFloat isFinite ifTrue: [self writeLiteral: aFloat] ifFalse: [self saveObject: aFloat]! !

!Kernel.STLOutFiler5 categoriesForMethods!
inFilerClass!constants!private! !
saveCharacter:!operations!public! !
saveFloat:!operations!public! !
!

!Kernel.STLOutFiler5 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	"Answer the version number of the format produced by the receiver."

	^5! !

!Kernel.STLOutFiler5 class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

