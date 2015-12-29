"Filed out from Dolphin Smalltalk 2000 release 5.00"!

Inspector subclass: #DBResultSetInspector
	instanceVariableNames: ''
	classVariableNames: 'DotDotDot'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DBResultSetInspector guid: (GUID fromString: '{87B4C692-026E-11D3-9FD7-00A0CC3E4A32}')!
DBResultSetInspector comment: 'A DBResultSetInspector is a specialized inspector for viewing a <DBResultSet>. The results are interrogated from the underlying database as required, thus alleviating the need to pull a possibly large set of data into memory in one fell swoop.

Class Variables:
	DotDotDot	<readableString> representing the continuation element.

'!
!DBResultSetInspector categoriesForClass!Development!MVP-Presenters!ODBC Interface! !
!DBResultSetInspector methodsFor!

getField: anInteger
	"Private - Answer the field of the receiver's object at index anInteger."

	^self selfField atIndex: anInteger!

getFieldList
	"Private - Answer an OrderedCollection of keys for filling the inspector variable list."

	^OrderedCollection with: DotDotDot!

onVariableNameSelected
	"Private - A selection has been made in the index pane.
	The index pane for this kind of inspector grows dynamically
	as the user scrolls through it."

	"Get rid of this DotDotDot nonsense when ListSelectorModels can talk indices"

	| furtherRow newIndex selection |
	#todo.
	selection := variableNamesPresenter selectionIfNone: [].
	selection = DotDotDot 
		ifFalse: [super onVariableNameSelected]
		ifTrue: 
			[newIndex := (variableNamesPresenter model list indexOf: selection) - 1.
			furtherRow := self selfField atIndex: newIndex.
			variableNamesPresenter model remove: DotDotDot.
			furtherRow == nil 
				ifTrue: 
					[newIndex > 1 ifTrue: [variableNamesPresenter selection: newIndex - 1]]
				ifFalse: 
					[variableNamesPresenter model add: newIndex.
					variableNamesPresenter selection: newIndex.
					variableNamesPresenter model add: DotDotDot]]! !
!DBResultSetInspector categoriesFor: #getField:!accessing!private! !
!DBResultSetInspector categoriesFor: #getFieldList!accessing!private! !
!DBResultSetInspector categoriesFor: #onVariableNameSelected!event handling!private! !

!DBResultSetInspector class methodsFor!

initialize
	"Private - Initialize the DotDotDot class variable.
	This variable gives us the ability to remove '...' from
	the field list, as #remove: works on IDENTITY."

	DotDotDot := '...'! !
!DBResultSetInspector class categoriesFor: #initialize!initializing!private! !

