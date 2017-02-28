"Filed out from Dolphin Smalltalk 7"!

EmbeddedCheckButton subclass: #EmbeddedRadioButton
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmbeddedRadioButton guid: (GUID fromString: '{326BF942-1142-4A1D-A365-F4B0DDA88FFE}')!
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
!EmbeddedRadioButton categoriesFor: #basicWindowStyle!constants!private! !
!EmbeddedRadioButton categoriesFor: #defaultIStateId!constants!public! !
!EmbeddedRadioButton categoriesFor: #iPartId!constants!public! !
!EmbeddedRadioButton categoriesFor: #iStateFor:enabled:hot:!displaying!private! !
!EmbeddedRadioButton categoriesFor: #uStateFor:enabled:!displaying!private! !

!EmbeddedRadioButton class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^RadioButton defaultIcon! !
!EmbeddedRadioButton class categoriesFor: #icon!constants!public! !

