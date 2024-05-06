"Filed out from Dolphin Smalltalk"!

Object subclass: #ScintillaListItem
	instanceVariableNames: 'text icon'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ScintillaListItem guid: (GUID fromString: '{a81939ba-1e36-4fe9-9be0-575c3c7f91df}')!

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

!ScintillaListItem categoriesForMethods!
displayOn:!displaying!public! !
displayString!displaying!public! !
icon!accessing!public! !
text!accessing!public! !
text:icon:!initializing!private! !
!

!ScintillaListItem class methodsFor!

icon
	^ScintillaView icon!

text: aString icon: anIcon
	^self new text: aString icon: anIcon! !

!ScintillaListItem class categoriesForMethods!
icon!constants!development!public! !
text:icon:!initializing!public! !
!

