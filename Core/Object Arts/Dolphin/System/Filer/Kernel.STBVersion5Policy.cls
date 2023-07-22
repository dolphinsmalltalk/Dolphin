"Filed out from Dolphin Smalltalk"!

Kernel.STBVersion3Policy
	subclass: #'Kernel.STBVersion5Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBVersion5Policy guid: (Core.GUID fromString: '{5514d6ae-d32f-459b-8eb4-79c07ca815a1}')!
Kernel.STBVersion5Policy comment: ''!
!Kernel.STBVersion5Policy methodsFor!

classLocatorStringFor: aClass
	"Private - In STB v5, class locator strings are full names"

	^aClass fullName!

readClassWithPrefix: anInteger
	| locatorString |
	locatorString := Utf8String new: (anInteger bitShift: STBFiler.PrefixLocatorLenUnshift).
	1 to: locatorString size do: [:i | locatorString basicAt: i put: stream next].
	^filer classLocator locateClass: (FullBindingReference
				pathString: locatorString
				path: nil
				private: false)!

readObjectWithPrefix: anInteger
	| anObject newObjectIndex class |
	anInteger == 0 ifTrue: [^nil].	"optimize for nil"

	"SmallInteger?"
	(anInteger allMask: STBFiler.PrefixSmallIntegerMask) ifTrue: [^anInteger bitShift: -1].
	(anInteger allMask: STBFiler.PrefixDataMask)
		ifFalse: 
			[^(anInteger allMask: STBFiler.PrefixCharacterMask)
				ifTrue: [Character value: (anInteger bitShift: STBFiler.PrefixRefUnshift)]
				ifFalse: [filer objectAt: (anInteger bitShift: STBFiler.PrefixRefUnshift)]].

	"Ascertain the class of the object."
	class := (anInteger allMask: STBFiler.PrefixClassMask)
				ifTrue: [self readClassDataWithPrefix: anInteger]
				ifFalse: [filer classAt: (anInteger bitShift: STBFiler.PrefixRefUnshift)].

	"Now read the object data."
	newObjectIndex := filer readMap size + 1.
	anObject := class
				stbReadFrom: filer
				format: (filer converters lookup: class)
				size: (class isVariable ifTrue: [filer stream nextInt32] ifFalse: [0]).

	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: filer at: newObjectIndex! !
!Kernel.STBVersion5Policy categoriesForMethods!
classLocatorStringFor:!accessing!helpers!operations!private! !
readClassWithPrefix:!operations!private! !
readObjectWithPrefix:!accessing!public! !
!

