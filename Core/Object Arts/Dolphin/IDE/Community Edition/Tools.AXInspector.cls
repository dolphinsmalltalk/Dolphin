"Filed out from Dolphin Smalltalk 7"!

Tools.BasicInspector subclass: #'Tools.AXInspector'
	instanceVariableNames: 'collection'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.AXInspector guid: (Core.GUID fromString: '{c06f3b62-0868-11d3-93af-00a024ca708a}')!
Tools.AXInspector comment: 'AXInspector is a <compositePresenter> that implements a specialised inspect facility onto a <IDispatch>. This attempts to display the IDispatch properties.

'!
!Tools.AXInspector categoriesForClass!MVP-Presenters! !
!Tools.AXInspector methodsFor!

count
	"Private - Answer the number of indexed variables in the receiver."

	collection isNil 
		ifTrue: [collection := [self selfField contents] on: Error do: [:e | #()]].
	^collection size!

getField: anInteger
	"Private - Answer the field of the receiver's object which has the key at index
	anInteger in the field list (1 based)."

	| instSize |
	instSize := self selfField class instSize.
	^anInteger > instSize 
		ifTrue: 
			[| var |
			(var := self variableNamesList at: anInteger + 1) isInteger 
				ifFalse: [self selfField getProperty: var]
				ifTrue: [collection at: var]]
		ifFalse: [self selfField instVarAt: anInteger]!

getFieldList
	"Private - Answer the list of fields to be displayed in the instance variable list
	of the InspectorShell. Numeric indices for the elements of the 
	OrderedCollection are answered"

	| ti |
	self selfField isNil ifTrue: [^#()].
	ti := self selfField typeInfoIfNone: [].
	^self selfField class allInstVarNames 
		, ((self selfField isNull or: [ti isNil]) 
				ifTrue: [#()]
				ifFalse: [ti inspectableProperties collect: [:i | i name]]) 
			, (1 to: self count)!

setField: anInteger to: anObject
	"Private - Determine the field of the receiver's object which has the key at index
	anInteger in the field list, and set its value to anObject."

	anInteger > self selfField class instSize 
		ifTrue: 
			[| var |
			(var := self variableNamesList at: anInteger + 1) isInteger 
				ifTrue: [Sound warningBeep]
				ifFalse: [self selfField setProperty: var value: anObject]]
		ifFalse: [super setField: anInteger to: anObject]!

unableToDisplayVariableErrorFormatString
	"Private - Answer the format string used to construct the error message text to be
	displayed in place of a variable value when a variable is selected that cannot be
	printed."

	^'Unable to access or display <1s> [<3s>]'! !
!Tools.AXInspector categoriesFor: #count!accessing!private! !
!Tools.AXInspector categoriesFor: #getField:!accessing!private! !
!Tools.AXInspector categoriesFor: #getFieldList!accessing!private! !
!Tools.AXInspector categoriesFor: #setField:to:!accessing!private! !
!Tools.AXInspector categoriesFor: #unableToDisplayVariableErrorFormatString!constants!private! !

