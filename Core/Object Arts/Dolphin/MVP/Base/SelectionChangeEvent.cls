"Filed out from Dolphin Smalltalk X6"!

Event subclass: #SelectionChangeEvent
	instanceVariableNames: 'newSelections oldSelections cause'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SelectionChangeEvent guid: (GUID fromString: '{D0986742-3873-4DCE-8E8F-6693994A4F26}')!
SelectionChangeEvent comment: ''!
!SelectionChangeEvent categoriesForClass!Kernel-Objects! !
!SelectionChangeEvent methodsFor!

canIntercept
	^self subclassResponsibility!

cause
	^cause ifNil: [#unknown]!

cause: aSymbol
	"Record the cause of the selection changing, one of:
		 #unknown (e.g. for programmatic changes)
		#mouse or
		#keyboard (for user initiated actions through those input devices)."

	cause := aSymbol!

newSelection
	^self newSelections notEmpty ifTrue: [self newSelections first]!

newSelection: anObject
	self newSelections: (Array with: anObject)!

newSelections
	^newSelections ifNil: [#()]!

newSelections: anArray
	newSelections := anArray!

oldSelection
	^self oldSelections notEmpty ifTrue: [self oldSelections first]!

oldSelection: anObject
	self oldSelections: (Array with: anObject)!

oldSelections
	^oldSelections ifNil: [#()]!

oldSelections: anArray
	oldSelections := anArray!

value
	^self subclassResponsibility! !
!SelectionChangeEvent categoriesFor: #canIntercept!public!testing! !
!SelectionChangeEvent categoriesFor: #cause!accessing!public! !
!SelectionChangeEvent categoriesFor: #cause:!accessing!public! !
!SelectionChangeEvent categoriesFor: #newSelection!accessing!public! !
!SelectionChangeEvent categoriesFor: #newSelection:!accessing!public! !
!SelectionChangeEvent categoriesFor: #newSelections!accessing!public! !
!SelectionChangeEvent categoriesFor: #newSelections:!accessing!public! !
!SelectionChangeEvent categoriesFor: #oldSelection!accessing!public! !
!SelectionChangeEvent categoriesFor: #oldSelection:!accessing!public! !
!SelectionChangeEvent categoriesFor: #oldSelections!accessing!public! !
!SelectionChangeEvent categoriesFor: #oldSelections:!accessing!public! !
!SelectionChangeEvent categoriesFor: #value!accessing!public! !

