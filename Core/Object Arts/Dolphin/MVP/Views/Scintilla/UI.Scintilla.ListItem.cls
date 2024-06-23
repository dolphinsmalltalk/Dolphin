"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Scintilla.ListItem'
	instanceVariableNames: 'object text icon'
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

= anObject
	^anObject == self or: 
			[anObject class == self class and: 
					["The names have to be unique within the list"
					anObject text = text]]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: text!

displayString
	^text!

hash
	^text hash!

icon
	^icon!

object
	^object!

object: anObject text: aString icon: anIcon
	object := anObject.
	text := aString.
	icon := anIcon!

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

text: aString 
	text := aString!

text: aString icon: anIcon
	text := aString.
	icon := anIcon! !

!UI.Scintilla.ListItem categoriesForMethods!
=!comparing!public! !
displayOn:!displaying!public! !
displayString!displaying!public! !
hash!comparing!public! !
icon!accessing!public! !
object!accessing!public! !
object:text:icon:!initializing!private! !
printOn:!displaying!public! !
text!accessing!public! !
text:!accessing!public! !
text:icon:!initializing!private! !
!

!UI.Scintilla.ListItem class methodsFor!

icon
	^ScintillaView icon!

object: anObject text: aString
	^self
		object: anObject
		text: aString
		icon: anObject icon!

object: anObject text: aString icon: anIcon
	<primitive: 157>
	^self new
		object: anObject
		text: aString
		icon: anIcon! !

!UI.Scintilla.ListItem class categoriesForMethods!
icon!constants!development!public! !
object:text:!instance creation!public! !
object:text:icon:!instance creation!public! !
!

