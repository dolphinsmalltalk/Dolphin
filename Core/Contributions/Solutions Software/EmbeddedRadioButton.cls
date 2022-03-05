"Filed out from Dolphin Smalltalk"!

EmbeddedCheckButton subclass: #EmbeddedRadioButton
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmbeddedRadioButton guid: (GUID fromString: '{326bf942-1142-4a1d-a365-f4b0dda88ffe}')!
EmbeddedRadioButton comment: ''!
!EmbeddedRadioButton categoriesForClass!MVP-Views! !
!EmbeddedRadioButton methodsFor!

basicWindowStyle
	^BS_AUTORADIOBUTTON!

defaultIStateId

	^RBS_UNCHECKEDNORMAL!

iPartId

	^BP_RADIOBUTTON!

iStateFor: aValue enabled: aBoolean hot: hBoolean

	^(aBoolean or: [self isAlwaysDrawnEnabled])
	ifTrue: 
		[(hBoolean & aBoolean)
			ifTrue: [aValue ifTrue: [RBS_CHECKEDHOT] ifFalse: [RBS_UNCHECKEDHOT]]
			ifFalse: [aValue ifTrue: [RBS_CHECKEDNORMAL] ifFalse: [RBS_UNCHECKEDNORMAL]]]
	ifFalse: 
		[aValue ifTrue: [RBS_CHECKEDDISABLED] ifFalse: [RBS_UNCHECKEDDISABLED]].!

uStateFor: aValue enabled: aBoolean

	| uState |

	uState := DFCS_BUTTONRADIO.

	(aBoolean or: [self isAlwaysDrawnEnabled]) ifFalse: [uState := uState | DFCS_INACTIVE].
	
	^aValue 
		ifTrue: [uState | DFCS_CHECKED] 
		ifFalse: [uState]! !
!EmbeddedRadioButton categoriesForMethods!
basicWindowStyle!constants!private! !
defaultIStateId!constants!public! !
iPartId!constants!public! !
iStateFor:enabled:hot:!drawing!private! !
uStateFor:enabled:!drawing!private! !
!

!EmbeddedRadioButton class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^RadioButton icon! !
!EmbeddedRadioButton class categoriesForMethods!
icon!constants!public! !
!

