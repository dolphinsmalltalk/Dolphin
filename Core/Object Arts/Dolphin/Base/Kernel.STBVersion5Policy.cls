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
	"In STB v5, class locator strings are full names"

	^aClass fullName!

readClass: anSTBInFiler prefix: anInteger
	| locatorString stream |
	locatorString := Utf8String new: (anInteger bitShift: STBFiler.PrefixLocatorLenUnshift).
	stream := anSTBInFiler stream.
	1 to: locatorString size do: [:i | locatorString basicAt: i put: stream next].
	^anSTBInFiler classLocator locateClass: (FullBindingReference
				pathString: locatorString
				path: nil
				private: false)!

readObject: anSTBInFiler withPrefix: anInteger
	| anObject newObjectIndex class |
	anInteger == 0 ifTrue: [^nil].	"optimize for nil"

	"SmallInteger?"
	(anInteger allMask: STBFiler.PrefixSmallIntegerMask) ifTrue: [^anInteger bitShift: -1].
	(anInteger allMask: STBFiler.PrefixDataMask)
		ifFalse: 
			[^(anInteger allMask: STBFiler.PrefixCharacterMask)
				ifTrue: [Character value: (anInteger bitShift: STBFiler.PrefixRefUnshift)]
				ifFalse: [anSTBInFiler objectAt: (anInteger bitShift: STBFiler.PrefixRefUnshift)]].

	"Ascertain the class of the object."
	class := (anInteger allMask: STBFiler.PrefixClassMask)
				ifTrue: [self readClassData: anSTBInFiler prefix: anInteger]
				ifFalse: [anSTBInFiler classAt: (anInteger bitShift: STBFiler.PrefixRefUnshift)].

	"Now read the object data."
	newObjectIndex := anSTBInFiler readMap size + 1.
	anObject := class
				stbReadFrom: anSTBInFiler
				format: (anSTBInFiler converters lookup: class)
				size: (class isVariable ifTrue: [anSTBInFiler stream nextInt32] ifFalse: [0]).

	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: anSTBInFiler at: newObjectIndex! !
!Kernel.STBVersion5Policy categoriesForMethods!
classLocatorStringFor:!public! !
readClass:prefix:!operations!private! !
readObject:withPrefix:!accessing!public! !
!

