"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.StringFormatFromFlagsInitializer
	subclass: #'Graphics.Gdiplus.StringFormatGenericDerivedInitializer'
	instanceVariableNames: 'genericInitializer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.StringFormatGenericDerivedInitializer guid: (Core.GUID fromString: '{9b493598-409d-42dc-8ae1-2f50d113ab6a}')!

Graphics.Gdiplus.StringFormatGenericDerivedInitializer comment: ''!

!Graphics.Gdiplus.StringFormatGenericDerivedInitializer methodsFor!

applyAdditionalAttributes: aHandle
	flags == self defaultFlags ifFalse: [Gdip gdipSetStringFormatFlags: aHandle flags: flags].
	super applyAdditionalAttributes: aHandle!

basicCreateHandle
	^self class cloneHandle: genericInitializer basicCreateHandle!

defaultAlignment
	^genericInitializer defaultAlignment!

defaultDigitSubstitution
	^genericInitializer defaultDigitSubstitution!

defaultFlags
	^genericInitializer defaultFlags!

defaultHotkeyPrefix
	^genericInitializer defaultHotkeyPrefix!

defaultLineAlignment
	^genericInitializer defaultLineAlignment!

defaultTrimming
	^genericInitializer defaultTrimming!

genericInitializer: aStringFormatGenericInitializer
	genericInitializer := aStringFormatGenericInitializer! !

!Graphics.Gdiplus.StringFormatGenericDerivedInitializer categoriesForMethods!
applyAdditionalAttributes:!attributes!private!realizing/unrealizing! !
basicCreateHandle!private!realizing/unrealizing! !
defaultAlignment!constants!private! !
defaultDigitSubstitution!constants!private! !
defaultFlags!constants!private! !
defaultHotkeyPrefix!constants!private! !
defaultLineAlignment!constants!private! !
defaultTrimming!constants!private! !
genericInitializer:!initializing!private! !
!

