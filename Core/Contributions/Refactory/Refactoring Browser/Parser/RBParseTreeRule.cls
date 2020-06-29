"Filed out from Dolphin Smalltalk 7"!

Object subclass: #RBParseTreeRule
	instanceVariableNames: 'searchTree owner'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!RBParseTreeRule categoriesFor: #canMatch:!matching!public! !
!RBParseTreeRule categoriesFor: #context!accessing!private! !
!RBParseTreeRule categoriesFor: #foundMatchFor:!matching!public! !
!RBParseTreeRule categoriesFor: #methodSearchString:!initialize/release!public! !
!RBParseTreeRule categoriesFor: #owner:!initialize/release!public! !
!RBParseTreeRule categoriesFor: #performOn:!matching!public! !
!RBParseTreeRule categoriesFor: #searchString:!initialize/release!public! !
!RBParseTreeRule categoriesFor: #sentMessages!accessing!public! !

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
!RBParseTreeRule class categoriesFor: #methodSearch:!instance creation!public! !
!RBParseTreeRule class categoriesFor: #new!instance creation!public! !
!RBParseTreeRule class categoriesFor: #search:!instance creation!public! !

