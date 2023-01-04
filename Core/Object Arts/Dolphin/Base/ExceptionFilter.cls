"Filed out from Dolphin Smalltalk"!

Object subclass: #ExceptionFilter
	instanceVariableNames: 'outer discriminator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExceptionFilter guid: (GUID fromString: '{1017ab5c-fbec-4f7e-a741-9a36356eccc5}')!

ExceptionFilter comment: '`ExceptionFilter` is an `<exceptionSelector>` that can be used to further refine the set of exceptions matched by an outer `<exceptionSelector>` to include only those which satisfy a `<monadicValuable>` discriminator. The outer `<exceptionSelector>` is typically an `Exception` class, although it could be an `ExceptionSet`, another `ExceptionFilter`, or any other object that implements the ANSI `<exceptionSelector>` protocol.

For example:
```
	[self error: ''It''''s all going horribly wrong''] on: (Error matching: [:ex | ex messageText endsWith: ''horribly wrong'']) do: [:ex | ''Got one'']
```
	'!

!ExceptionFilter methodsFor!

, anExceptionSelector
	"Answer a new <exceptionSet> containing the receiver and the <exceptionSelector> argument."

	^ExceptionSet selectors: {self. anExceptionSelector}!

handles: anExceptionDescription
	"Answer whether the receiver matches the <exceptionDescription> argument."

	^(outer handles: anExceptionDescription) and: [discriminator value: anExceptionDescription]!

select: anExceptionSelector matching: aMonadicValuable
	outer := anExceptionSelector.
	discriminator := aMonadicValuable.
	^self! !

!ExceptionFilter categoriesForMethods!
,!combining!public! !
handles:!filtering!public! !
select:matching:!initializing!private! !
!

ExceptionFilter methodProtocol: #exceptionSelector attributes: #(#ansi #readOnly) selectors: #(#, #handles:)!

!ExceptionFilter class methodsFor!

select: anExceptionSelector matching: aMonadicValuable
	<primitive: 157>
	^self new select: anExceptionSelector matching: aMonadicValuable! !

!ExceptionFilter class categoriesForMethods!
select:matching:!instance creation!public! !
!

