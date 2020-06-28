"Filed out from Dolphin Smalltalk 7"!

SelectionChangeEvent subclass: #SelectionChangingEvent
	instanceVariableNames: 'permit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SelectionChangingEvent guid: (GUID fromString: '{cf88ca57-dc8c-46e6-beab-59fe115eb945}')!
SelectionChangingEvent comment: ''!
!SelectionChangingEvent categoriesForClass!MVP-Views-Events! !
!SelectionChangingEvent methodsFor!

canIntercept
	^true!

setSource: aWindow
	permit := true.
	super setSource: aWindow!

value
	^permit!

value: aBoolean
	permit := aBoolean! !
!SelectionChangingEvent categoriesFor: #canIntercept!public!testing! !
!SelectionChangingEvent categoriesFor: #setSource:!initializing!private! !
!SelectionChangingEvent categoriesFor: #value!accessing!public! !
!SelectionChangingEvent categoriesFor: #value:!accessing!public! !

!SelectionChangingEvent class methodsFor!

new
	^self shouldNotImplement! !
!SelectionChangingEvent class categoriesFor: #new!instance creation!public! !

