"Filed out from Dolphin Smalltalk 7"!

HttpServerObject subclass: #HttpServerQueue
	instanceVariableNames: 'handle name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerQueue guid: (GUID fromString: '{90ebec82-337c-4398-b518-7c5c84ca6a7a}')!
HttpServerQueue comment: ''!
!HttpServerQueue categoriesForClass!Unclassified! !
!HttpServerQueue methodsFor!

close
	self lib httpCloseRequestQueue: handle.
	handle := nil!

handle
	^handle!

initializeName: aString
	name := aString.
	handle := self lib createRequestQueue: name! !
!HttpServerQueue categoriesFor: #close!public! !
!HttpServerQueue categoriesFor: #handle!public! !
!HttpServerQueue categoriesFor: #initializeName:!private! !

!HttpServerQueue class methodsFor!

named: aString
	^self new initializeName: aString; yourself! !
!HttpServerQueue class categoriesFor: #named:!public! !

