"Filed out from Dolphin Smalltalk"!

UI.Event
	subclass: #'UI.LabelEditEvent'
	instanceVariableNames: 'cancel item object text'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.LabelEditEvent guid: (Core.GUID fromString: '{97ba6e5b-5864-48d7-be5f-2ef33eaf09cb}')!

UI.LabelEditEvent isNonInstantiable: true!

UI.LabelEditEvent comment: ''!

!UI.LabelEditEvent categoriesForClass!Kernel-Objects! !

!UI.LabelEditEvent methodsFor!

cancel
	^cancel!

cancel: aBoolean
	cancel := aBoolean!

item
	^item!

item: aCCITEM
	item := aCCITEM!

object
	"Answer the object that has been or is about to be edited."

	^object!

object: anObject
	object := anObject!

setSource: aWindow
	cancel := false.
	super setSource: aWindow!

text
	^text ifNil: [item text]!

text: aString
	text := aString! !

!UI.LabelEditEvent categoriesForMethods!
cancel!accessing!public! !
cancel:!public! !
item!accessing!public! !
item:!accessing!private! !
object!accessing!public! !
object:!initialization!private! !
setSource:!initializing!private! !
text!accessing!public! !
text:!accessing!public! !
!

