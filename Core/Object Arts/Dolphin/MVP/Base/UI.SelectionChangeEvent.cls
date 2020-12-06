"Filed out from Dolphin Smalltalk 7"!

UI.Event subclass: #'UI.SelectionChangeEvent'
	instanceVariableNames: 'newSelections oldSelections cause'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.SelectionChangeEvent guid: (Core.GUID fromString: '{d0986742-3873-4dce-8e8f-6693994a4f26}')!
UI.SelectionChangeEvent isNonInstantiable: true!
UI.SelectionChangeEvent comment: ''!
!UI.SelectionChangeEvent categoriesForClass!Kernel-Objects! !
!UI.SelectionChangeEvent methodsFor!

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
!UI.SelectionChangeEvent categoriesFor: #canIntercept!public!testing! !
!UI.SelectionChangeEvent categoriesFor: #cause!accessing!public! !
!UI.SelectionChangeEvent categoriesFor: #cause:!initializing!public! !
!UI.SelectionChangeEvent categoriesFor: #newSelection!accessing!public! !
!UI.SelectionChangeEvent categoriesFor: #newSelection:!initializing!public! !
!UI.SelectionChangeEvent categoriesFor: #newSelections!accessing!public! !
!UI.SelectionChangeEvent categoriesFor: #newSelections:!initializing!public! !
!UI.SelectionChangeEvent categoriesFor: #oldSelection!accessing!public! !
!UI.SelectionChangeEvent categoriesFor: #oldSelection:!initializing!public! !
!UI.SelectionChangeEvent categoriesFor: #oldSelections!accessing!public! !
!UI.SelectionChangeEvent categoriesFor: #oldSelections:!initializing!public! !
!UI.SelectionChangeEvent categoriesFor: #value!accessing!public! !

