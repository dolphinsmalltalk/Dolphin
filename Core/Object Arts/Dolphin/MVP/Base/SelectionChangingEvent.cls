"Filed out from Dolphin Smalltalk X6"!

SelectionChangeEvent subclass: #SelectionChangingEvent
	instanceVariableNames: 'permit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SelectionChangingEvent guid: (GUID fromString: '{CF88CA57-DC8C-46E6-BEAB-59FE115EB945}')!
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

