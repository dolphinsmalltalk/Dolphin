"Filed out from Dolphin Smalltalk 7"!

UI.SelectionChangeEvent subclass: #'UI.SelectionChangingEvent'
	instanceVariableNames: 'permit'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.SelectionChangingEvent guid: (Core.GUID fromString: '{cf88ca57-dc8c-46e6-beab-59fe115eb945}')!
UI.SelectionChangingEvent comment: ''!
!UI.SelectionChangingEvent categoriesForClass!MVP-Views-Events! !
!UI.SelectionChangingEvent methodsFor!

canIntercept
	^true!

setSource: aWindow
	permit := true.
	super setSource: aWindow!

value
	^permit!

value: aBoolean
	permit := aBoolean! !
!UI.SelectionChangingEvent categoriesFor: #canIntercept!public!testing! !
!UI.SelectionChangingEvent categoriesFor: #setSource:!initializing!private! !
!UI.SelectionChangingEvent categoriesFor: #value!accessing!public! !
!UI.SelectionChangingEvent categoriesFor: #value:!accessing!public! !

!UI.SelectionChangingEvent class methodsFor!

new
	^self shouldNotImplement! !
!UI.SelectionChangingEvent class categoriesFor: #new!instance creation!public! !

