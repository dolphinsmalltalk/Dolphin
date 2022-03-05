"Filed out from Dolphin Smalltalk"!

Object subclass: #RBParseTreeRule
	instanceVariableNames: 'searchTree owner'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBParseTreeRule guid: (GUID fromString: '{1a6390df-c5e5-4c38-a2fa-300ea0cddbff}')!
RBParseTreeRule comment: ''!
!RBParseTreeRule categoriesForClass!Refactory-ParseTree Matching! !
!RBParseTreeRule methodsFor!

canMatch: aProgramNode 
	^true!

context
	^owner context!

foundMatchFor: aProgramNode
	^aProgramNode!

methodSearchString: aString 
	searchTree := RBParser parseRewriteMethod: aString!

owner: aParseTreeSearcher
	owner := aParseTreeSearcher!

performOn: aProgramNode
	| ctx |
	ctx := self context.
	ctx empty.
	^((searchTree match: aProgramNode inContext: ctx) and: [self canMatch: aProgramNode])
		ifTrue: 
			[owner recusivelySearchInContext.
			self foundMatchFor: aProgramNode]
		ifFalse: [nil]!

searchString: aString 
	searchTree := RBParser parseRewriteExpression: aString!

sentMessages
	^searchTree sentMessages! !
!RBParseTreeRule categoriesForMethods!
canMatch:!matching!public! !
context!accessing!private! !
foundMatchFor:!matching!public! !
methodSearchString:!initialize/release!public! !
owner:!initialize/release!public! !
performOn:!matching!public! !
searchString:!initialize/release!public! !
sentMessages!accessing!public! !
!

!RBParseTreeRule class methodsFor!

methodSearch: aString 
	^(self new)
		methodSearchString: aString;
		yourself!

new
	^(super new)
		initialize;
		yourself!

search: aString 
	^(self new)
		searchString: aString;
		yourself! !
!RBParseTreeRule class categoriesForMethods!
methodSearch:!instance creation!public! !
new!instance creation!public! !
search:!instance creation!public! !
!

