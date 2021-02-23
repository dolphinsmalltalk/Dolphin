"Filed out from Dolphin Smalltalk 7"!

UI.Event subclass: #'UI.LabelEditEvent'
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
!UI.LabelEditEvent categoriesFor: #cancel!accessing!public! !
!UI.LabelEditEvent categoriesFor: #cancel:!public! !
!UI.LabelEditEvent categoriesFor: #item!accessing!public! !
!UI.LabelEditEvent categoriesFor: #item:!accessing!private! !
!UI.LabelEditEvent categoriesFor: #object!accessing!public! !
!UI.LabelEditEvent categoriesFor: #object:!initialization!private! !
!UI.LabelEditEvent categoriesFor: #setSource:!initializing!private! !
!UI.LabelEditEvent categoriesFor: #text!accessing!public! !
!UI.LabelEditEvent categoriesFor: #text:!accessing!public! !

