"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ScintillaListItem
	instanceVariableNames: 'text icon'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaListItem guid: (GUID fromString: '{A81939BA-1E36-4FE9-9BE0-575C3C7F91DF}')!
ScintillaListItem comment: 'ScintillaListItems can be used to populate auto-completion and user lists in ScintillaViews when the #displayString and #icon methods of the type being listed does not provide the text and icon (respectively) that are desired in the pop-up list.

Instance Variables:
	text		<string> displayed as the text of the item in the list
	icon		<Icon> displayed alongside the item text when the list is shown with icons
'!
!ScintillaListItem categoriesForClass!Kernel-Objects! !
!ScintillaListItem methodsFor!

displayOn: aStream
	^aStream nextPutAll: text!

displayString
	^text!

icon
	^icon!

text
	^text!

text: aString icon: anIcon
	text := aString.
	icon := anIcon! !
!ScintillaListItem categoriesFor: #displayOn:!displaying!public! !
!ScintillaListItem categoriesFor: #displayString!displaying!public! !
!ScintillaListItem categoriesFor: #icon!accessing!public! !
!ScintillaListItem categoriesFor: #text!accessing!public! !
!ScintillaListItem categoriesFor: #text:icon:!initializing!private! !

!ScintillaListItem class methodsFor!

icon
	^ScintillaView icon!

text: aString icon: anIcon
	^self new text: aString icon: anIcon! !
!ScintillaListItem class categoriesFor: #icon!constants!development!public! !
!ScintillaListItem class categoriesFor: #text:icon:!initializing!public! !

