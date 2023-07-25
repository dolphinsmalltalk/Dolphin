"Filed out from Dolphin Smalltalk"!

Kernel.STBVersionPolicy
	subclass: #'Kernel.STBVersionPolicyForNamespaces'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBVersionPolicyForNamespaces guid: (Core.GUID fromString: '{783e6dfc-52d1-464a-bcfb-31708fb33b29}')!
Kernel.STBVersionPolicyForNamespaces isNonInstantiable: true!
Kernel.STBVersionPolicyForNamespaces comment: ''!
!Kernel.STBVersionPolicyForNamespaces methodsFor!

classLocatorStringFor: aClass
	"Private - In STB v5, class locator strings are full names"

	^aClass fullName!

lastPredefined
	"Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^LastPredefinedClassRef!

readClassWithPrefix: anInteger
	| locatorString |
	locatorString := Utf8String new: (anInteger bitShift: STxFiler.PrefixLocatorLenUnshift).
	1 to: locatorString size do: [:i | locatorString basicAt: i put: stream next].
	^filer classLocator locateClass: (FullBindingReference
				pathString: locatorString
				path: nil
				private: false)!

readObjectSize: aClass
	"As of STB version 3, the out-filer only writes the object size for indexable objects."

	^aClass isVariable ifTrue: [stream nextInt32] ifFalse: [0]!

readObjectWithPrefix: anInteger
	| anObject newObjectIndex class |
	anInteger == 0 ifTrue: [^nil].	"optimize for nil"

	"SmallInteger?"
	(anInteger allMask: STxFiler.PrefixSmallIntegerMask) ifTrue: [^anInteger bitShift: -1].
	(anInteger allMask: STxFiler.PrefixDataMask)
		ifFalse: 
			[^(anInteger allMask: STxFiler.PrefixCharacterMask)
				ifTrue: [Character value: (anInteger bitShift: STxFiler.PrefixRefUnshift)]
				ifFalse: [filer objectAt: (anInteger bitShift: STxFiler.PrefixRefUnshift)]].

	"Ascertain the class of the object."
	class := (anInteger allMask: STxFiler.PrefixClassMask)
				ifTrue: [self readClassDataWithPrefix: anInteger]
				ifFalse: [filer classAt: (anInteger bitShift: STxFiler.PrefixRefUnshift)].

	"Now read the object data."
	newObjectIndex := filer readMap size + 1.
	anObject := class
				stbReadFrom: filer
				format: (filer converters lookup: class)
				size: (class isVariable ifTrue: [filer stream nextInt32] ifFalse: [0]).

	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: filer at: newObjectIndex! !
!Kernel.STBVersionPolicyForNamespaces categoriesForMethods!
classLocatorStringFor:!accessing!helpers!operations!private! !
lastPredefined!public! !
readClassWithPrefix:!operations!private! !
readObjectSize:!public! !
readObjectWithPrefix:!accessing!public! !
!

