"Filed out from Dolphin Smalltalk"!

UI.Event
	subclass: #'UI.SelectionChangeEvent'
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
	newSelections := anObject ifNotNil: [{anObject}]!

newSelections
	^newSelections ?? #()!

newSelections: anArray
	newSelections := anArray!

oldSelection
	^self oldSelections notEmpty ifTrue: [self oldSelections first]!

oldSelection: anObject
	oldSelections := anObject ifNotNil: [{anObject}]!

oldSelections
	^oldSelections ?? #()!

oldSelections: anArray
	oldSelections := anArray!

value
	^self subclassResponsibility! !
!UI.SelectionChangeEvent categoriesForMethods!
canIntercept!public!testing! !
cause!accessing!public! !
cause:!initializing!public! !
newSelection!accessing!public! !
newSelection:!initializing!public! !
newSelections!accessing!public! !
newSelections:!initializing!public! !
oldSelection!accessing!public! !
oldSelection:!initializing!public! !
oldSelections!accessing!public! !
oldSelections:!initializing!public! !
value!accessing!public! !
!

