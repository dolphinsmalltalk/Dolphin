"Filed out from Dolphin Smalltalk 7"!

EmbeddedCheckButton subclass: #EmbeddedCheckBox
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
EmbeddedCheckBox guid: (GUID fromString: '{611f80ae-2e05-4e6f-b0c8-a0adbd00ff31}')!
EmbeddedCheckBox comment: ''!
!EmbeddedCheckBox categoriesForClass!MVP-Views! !
!EmbeddedCheckBox methodsFor!

basicWindowStyle
	"Private - Answer a basic default style to use when creating a checkbox."

	^BS_AUTOCHECKBOX!

defaultIStateId

	^CBS_UNCHECKEDNORMAL!

iPartId

	^BP_CHECKBOX!

is3State
	"Answer whether the receiver is a 3-state check box that can be 'dimmed' as well as checked
	and unchecked."

	^(self baseStyle bitAnd: BS_TYPEMASK) = BS_AUTO3STATE!

is3State: aBoolean 
	"Set whether the receiver is a 3-state check box that can be 'dimmed' as well as checked
	and unchecked."

	self baseStyle: (aBoolean ifTrue: [BS_AUTO3STATE] ifFalse: [self basicWindowStyle])
		maskedBy: BS_TYPEMASK!

iStateFor: aValue enabled: aBoolean hot: hBoolean

	^(aBoolean or: [self isAlwaysDrawnEnabled])
	ifTrue: 
		[(hBoolean & aBoolean)
		ifTrue: 
			[aValue isNil
				ifTrue: [CBS_MIXEDHOT]
				ifFalse: [aValue ifTrue: [CBS_CHECKEDHOT] ifFalse: [CBS_UNCHECKEDHOT]]]
		ifFalse: 
			[aValue isNil
				ifTrue: [CBS_MIXEDNORMAL]
				ifFalse: [aValue ifTrue: [CBS_CHECKEDNORMAL] ifFalse: [CBS_UNCHECKEDNORMAL]]]]
	ifFalse: 
		[aValue isNil
			ifTrue: [CBS_MIXEDDISABLED]
			ifFalse: [aValue ifTrue: [CBS_CHECKEDDISABLED] ifFalse: [CBS_UNCHECKEDDISABLED]]]!

uStateFor: aValue enabled: aBoolean

	| uState |

	aValue isNil 
		ifTrue: [uState := DFCS_BUTTON3STATE]
		ifFalse: [uState := DFCS_BUTTONCHECK].

	(aBoolean or: [self isAlwaysDrawnEnabled]) ifFalse: [uState := uState | DFCS_INACTIVE].
	
	^aValue == false
		ifTrue: [uState] 
		ifFalse: [uState | DFCS_CHECKED]! !
!EmbeddedCheckBox categoriesFor: #basicWindowStyle!constants!private! !
!EmbeddedCheckBox categoriesFor: #defaultIStateId!constants!public! !
!EmbeddedCheckBox categoriesFor: #iPartId!constants!public! !
!EmbeddedCheckBox categoriesFor: #is3State!accessing!public! !
!EmbeddedCheckBox categoriesFor: #is3State:!accessing!public! !
!EmbeddedCheckBox categoriesFor: #iStateFor:enabled:hot:!drawing!private! !
!EmbeddedCheckBox categoriesFor: #uStateFor:enabled:!drawing!private! !

!EmbeddedCheckBox class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^CheckBox icon! !
!EmbeddedCheckBox class categoriesFor: #icon!constants!public! !

