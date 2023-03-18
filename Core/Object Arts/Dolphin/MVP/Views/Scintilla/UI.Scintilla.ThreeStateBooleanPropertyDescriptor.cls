"Filed out from Dolphin Smalltalk"!

UI.Scintilla.PropertyDescriptor
	subclass: #'UI.Scintilla.ThreeStateBooleanPropertyDescriptor'
	instanceVariableNames: 'flagsMask'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.ThreeStateBooleanPropertyDescriptor guid: (Core.GUID fromString: '{32c7fd36-f0c3-4d7b-83a2-5278270a3e8c}')!
UI.Scintilla.ThreeStateBooleanPropertyDescriptor comment: ''!
!UI.Scintilla.ThreeStateBooleanPropertyDescriptor methodsFor!

defaultFlags
	^NullableMask!

flagsMask
	^flagsMask!

flagsMask: anObject
	flagsMask := anObject!

getValueOfAttribute: aScintillaAttribute
	^aScintillaAttribute getThreeStateFlag: flagsMask!

setValueOfAttribute: aScintillaAttribute to: aBooleanOrNil
	^aScintillaAttribute setThreeStateFlag: flagsMask value: aBooleanOrNil!

shouldPrint: aScintillaAttribute
	^(self getValueOfAttribute: aScintillaAttribute) notNil!

valueFromLResult: anObject
	^anObject ~~ 0! !
!UI.Scintilla.ThreeStateBooleanPropertyDescriptor categoriesForMethods!
defaultFlags!private! !
flagsMask!private! !
flagsMask:!private! !
getValueOfAttribute:!private! !
setValueOfAttribute:to:!private! !
shouldPrint:!printing!private! !
valueFromLResult:!helpers!private! !
!

