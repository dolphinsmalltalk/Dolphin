"Filed out from Dolphin Smalltalk 7"!

Event subclass: #SelectionChangeEvent
	instanceVariableNames: 'newSelections oldSelections cause'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SelectionChangeEvent guid: (GUID fromString: '{d0986742-3873-4dce-8e8f-6693994a4f26}')!
SelectionChangeEvent isAbstract: true!
SelectionChangeEvent comment: ''!
!SelectionChangeEvent categoriesForClass!Kernel-Objects! !
!SelectionChangeEvent methodsFor!

canIntercept
	^self subclassResponsibility!

cause
	^cause ?? #unknown!

cause: aSymbol
	"Record the cause of the selection changing, one of:
		 #unknown (e.g. for programmatic changes)
		#mouse or
		#keyboard (for user initiated actions through those input devices)."

	cause := aSymbol!

newSelection
	^self newSelections notEmpty ifTrue: [self newSelections first]!

newSelection: anObject
	self newSelections: {anObject}!

newSelections
	^newSelections ?? #()!

newSelections: anArray
	newSelections := anArray!

oldSelection
	^self oldSelections notEmpty ifTrue: [self oldSelections first]!

oldSelection: anObject
	self oldSelections: {anObject}!

oldSelections
	^oldSelections ?? #()!

oldSelections: anArray
	oldSelections := anArray!

value
	^self subclassResponsibility! !
!SelectionChangeEvent categoriesFor: #canIntercept!public!testing! !
!SelectionChangeEvent categoriesFor: #cause!accessing!public! !
!SelectionChangeEvent categoriesFor: #cause:!initializing!public! !
!SelectionChangeEvent categoriesFor: #newSelection!accessing!public! !
!SelectionChangeEvent categoriesFor: #newSelection:!initializing!public! !
!SelectionChangeEvent categoriesFor: #newSelections!accessing!public! !
!SelectionChangeEvent categoriesFor: #newSelections:!initializing!public! !
!SelectionChangeEvent categoriesFor: #oldSelection!accessing!public! !
!SelectionChangeEvent categoriesFor: #oldSelection:!initializing!public! !
!SelectionChangeEvent categoriesFor: #oldSelections!accessing!public! !
!SelectionChangeEvent categoriesFor: #oldSelections:!initializing!public! !
!SelectionChangeEvent categoriesFor: #value!accessing!public! !

