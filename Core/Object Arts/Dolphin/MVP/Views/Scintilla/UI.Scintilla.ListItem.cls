"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Scintilla.ListItem'
	instanceVariableNames: 'text icon'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.ListItem guid: (Core.GUID fromString: '{a81939ba-1e36-4fe9-9be0-575c3c7f91df}')!
UI.Scintilla.ListItem comment: '`UI.Scintilla.ListItem`s can be used to wrap items inserted into auto-completion and user lists in `ScintillaView`s when the `#displayString` and `#icon` methods of the underlying object does not provide the text and icon (respectively) that are desired in the pop-up list.

## Instance Variables:
  `text`		`<string>` displayed as the text of the item in the list
  `icon`		`<Icon>` displayed alongside the item text when the list is shown with icons
'!
!UI.Scintilla.ListItem categoriesForClass!Kernel-Objects! !
!UI.Scintilla.ListItem methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: text!

displayString
	^text!

icon
	^icon!

printOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		basicPrint: self;
		nextPut: $(;
		print: text;
		nextPutAll: ', ';
		print: icon;
		nextPut: $)!

text
	^text!

text: aString icon: anIcon
	text := aString.
	icon := anIcon! !
!UI.Scintilla.ListItem categoriesForMethods!
displayOn:!displaying!public! !
displayString!displaying!public! !
icon!accessing!public! !
printOn:!displaying!public! !
text!accessing!public! !
text:icon:!initializing!private! !
!

!UI.Scintilla.ListItem class methodsFor!

icon
	^ScintillaView icon!

text: aString icon: anIcon
	^self new text: aString icon: anIcon! !
!UI.Scintilla.ListItem class categoriesForMethods!
icon!constants!development!public! !
text:icon:!initializing!public! !
!

