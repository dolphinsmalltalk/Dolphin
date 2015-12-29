"Filed out from Dolphin Smalltalk XP 2002 release 5.02"!

Object subclass: #RBParseTreeRule
	instanceVariableNames: 'searchTree owner'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBParseTreeRule guid: (GUID fromString: '{1A6390DF-C5E5-4C38-A2FA-300EA0CDDBFF}')!
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
	self context empty.
	^((searchTree match: aProgramNode inContext: self context) 
		and: [self canMatch: aProgramNode]) 
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

