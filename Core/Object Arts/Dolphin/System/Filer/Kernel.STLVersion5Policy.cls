"Filed out from Dolphin Smalltalk"!

Kernel.STLVersionPolicy
	subclass: #'Kernel.STLVersion5Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLVersion5Policy guid: (Core.GUID fromString: '{fd7ff8a8-b50f-4fa1-a6cc-07ee71373f69}')!
Kernel.STLVersion5Policy comment: ''!
!Kernel.STLVersion5Policy methodsFor!

literalPrinterClass
	^STLPrinter!

readClassData: anSTBFiler prefix: anInteger
	"As of STL5 the class refs are printed into the STL as BindingReferences. These are true literals (so don't need the ##() expressions to be embedded in the literal array) but need to be resolved back to the class by sending them #value. Note that the resolved binding is cached by the literal BindingReference object, so this is still relatively efficient after the first run through."

	^(anInteger allMask: STBFiler.PrefixNonZeroVersionMask)
		ifTrue: 
			[| versionBeingRead stream |
			stream := anSTBFiler stream.
			versionBeingRead := stream next.
			anSTBFiler
				registerClass: stream next value
				version: versionBeingRead
				prefix: anInteger]
		ifFalse: 
			[anSTBFiler
				registerClass: anSTBFiler stream next value
				version: 0
				prefix: anInteger]!

readObject: anSTBInFiler withPrefix: anInteger
	"In STL version 5 and later, the input stream won't contain encoded nil's or Characters, as these are written as literals. SmallIntegers are still encoded though, as this is necessary to distinguish these from the prefix values."

	| anObject newObjectIndex class |
	"SmallInteger?"
	(anInteger allMask: STBFiler.PrefixSmallIntegerMask)
		ifTrue: 
			["Encoded in the prefix"
			^anInteger bitShift: -1].
	(anInteger allMask: STBFiler.PrefixDataMask)
		ifFalse: 
			["Must be an object reference"
			^anSTBInFiler objectAt: (anInteger bitShift: STBFiler.PrefixRefUnshift)].

	"Ascertain the class of the object."
	class := (anInteger allMask: STBFiler.PrefixClassMask)
				ifTrue: [self readClassData: anSTBInFiler prefix: anInteger]
				ifFalse: 
					["Previously encountered class"
					anSTBInFiler classAt: (anInteger bitShift: STBFiler.PrefixRefUnshift)].

	"Now read the object data."
	newObjectIndex := anSTBInFiler readMap size + 1.
	anObject := class stbReadFrom: anSTBInFiler format: (anSTBInFiler converters lookup: class).

	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: anSTBInFiler at: newObjectIndex!

registerPredefinedObjects: anSTLFiler
	"Private - Post version 3, don't pre-register standard objects with literal representation as we write these directly to the stream."! !
!Kernel.STLVersion5Policy categoriesForMethods!
literalPrinterClass!public! !
readClassData:prefix:!helpers!public! !
readObject:withPrefix:!accessing!public! !
registerPredefinedObjects:!private! !
!

