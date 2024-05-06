"Filed out from Dolphin Smalltalk"!

SelectionChangeEvent subclass: #SelectionChangingEvent
	instanceVariableNames: 'permit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!SelectionChangingEvent categoriesForMethods!
canIntercept!public!testing! !
setSource:!initializing!private! !
value!accessing!public! !
value:!accessing!public! !
!

!SelectionChangingEvent class methodsFor!

new
	^self shouldNotImplement! !

!SelectionChangingEvent class categoriesForMethods!
new!instance creation!public! !
!

