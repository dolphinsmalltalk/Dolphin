"Filed out from Dolphin Smalltalk"!

Kernel.STLVersion3Policy
	subclass: #'Kernel.STLVersion4Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLVersion4Policy guid: (Core.GUID fromString: '{829de0cb-c85f-4efd-8394-07095db69f9d}')!
Kernel.STLVersion4Policy comment: ''!
!Kernel.STLVersion4Policy methodsFor!

readObjectWithPrefix: anInteger
	"In STL version 4 and later, the input stream won't contain encoded Characters, as these are written as literals. SmallIntegers are still encoded though, as this is necessary to distinguish these from the prefix values.
	STL 4 streams from 7.1 won't contain encoded nil's either, but some earlier streams with the same version will because the filer version wasn't incremented when the change was made to emit nil as a literal."

	| anObject newObjectIndex class |
	anInteger == 0 ifTrue: [^nil].	"optimize for nil"
	"SmallInteger?"
	(anInteger allMask: STBFiler.PrefixSmallIntegerMask) ifTrue: [^anInteger bitShift: -1].
	(anInteger allMask: STBFiler.PrefixDataMask)
		ifFalse: [^filer objectAt: (anInteger bitShift: STBFiler.PrefixRefUnshift)].

	"Ascertain the class of the object."
	class := (anInteger allMask: STBFiler.PrefixClassMask)
				ifTrue: [self readClassDataWithPrefix: anInteger]
				ifFalse: [filer classAt: (anInteger bitShift: STBFiler.PrefixRefUnshift)].

	"Now read the object data."
	newObjectIndex := filer readMap size + 1.
	anObject := class stbReadFrom: filer format: (filer converters lookup: class).

	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: filer at: newObjectIndex!

registerPredefinedObjects: anSTLFiler
	"Private - Post version 3, don't pre-register standard objects with literal representation as we write these directly to the stream."! !
!Kernel.STLVersion4Policy categoriesForMethods!
readObjectWithPrefix:!operations!public! !
registerPredefinedObjects:!initializing!private! !
!

!Kernel.STLVersion4Policy class methodsFor!

initialize
	"
	self initialize
	"

	Versions at: 4+1 put: self! !
!Kernel.STLVersion4Policy class categoriesForMethods!
initialize!class initialization!public! !
!

