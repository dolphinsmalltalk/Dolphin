"Filed out from Dolphin Smalltalk"!

Graphics.ImageFromResourceInitializer
	subclass: #'Graphics.ImageFromStringResourceInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.ImageFromStringResourceInitializer guid: (Core.GUID fromString: '{3ca705c5-7cef-418b-8fa4-8bdacfbcad4a}')!

Graphics.ImageFromStringResourceInitializer comment: ''!

!Graphics.ImageFromStringResourceInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: 
			[self species == anObject species
				and: [(identifier compareOrdinals: anObject identifier ignoringCase: true) == 0 and: [module = anObject module]]]!

hash
	"Answer the <integer> hash value for the receiver."

	^identifier hashOrdinalsIgnoringCase!

tryLoadFromFile: anImage extent: aPoint
	^anImage
		loadFromFile: (FileLocator default localFileSpecFor: identifier)
		extent: aPoint
		flags: (flags bitAnd: ##(LR_SHARED bitInvert))! !

!Graphics.ImageFromStringResourceInitializer categoriesForMethods!
=!comparing!public! !
hash!comparing!public! !
tryLoadFromFile:extent:!private!realizing/unrealizing! !
!

