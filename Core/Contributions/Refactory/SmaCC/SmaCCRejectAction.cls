"Filed out from Dolphin Smalltalk XP"!

SmaCCAction subclass: #SmaCCRejectAction
	instanceVariableNames: ''
	classVariableNames: 'Reject'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCRejectAction guid: (GUID fromString: '{368C3752-8BD0-4A1C-92A6-FF25EA423434}')!
SmaCCRejectAction comment: 'SmaCCRejectAction represents a reject action in the parsing tables.'!
!SmaCCRejectAction categoriesForClass!SmaCC Runtime! !
!SmaCCRejectAction methodsFor!

id
	^2r11! !
!SmaCCRejectAction categoriesFor: #id!accessing!public! !

!SmaCCRejectAction class methodsFor!

initialize
	Reject := self basicNew!

new
	^Reject!

releaseObjects
	Reject := nil!

uninitialize
	self releaseObjects! !
!SmaCCRejectAction class categoriesFor: #initialize!class initialization!public! !
!SmaCCRejectAction class categoriesFor: #new!instance creation!public! !
!SmaCCRejectAction class categoriesFor: #releaseObjects!class initialization!public! !
!SmaCCRejectAction class categoriesFor: #uninitialize!class hierarchy-removing!public! !

