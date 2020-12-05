"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Refactory.Browser.RBParseTreeRule'
	instanceVariableNames: 'searchTree owner'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBParseTreeRule guid: (Core.GUID fromString: '{1a6390df-c5e5-4c38-a2fa-300ea0cddbff}')!
Refactory.Browser.RBParseTreeRule comment: ''!
!Refactory.Browser.RBParseTreeRule categoriesForClass!Refactory-ParseTree Matching! !
!Refactory.Browser.RBParseTreeRule methodsFor!

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
!Refactory.Browser.RBParseTreeRule categoriesFor: #canMatch:!matching!public! !
!Refactory.Browser.RBParseTreeRule categoriesFor: #context!accessing!private! !
!Refactory.Browser.RBParseTreeRule categoriesFor: #foundMatchFor:!matching!public! !
!Refactory.Browser.RBParseTreeRule categoriesFor: #methodSearchString:!initialize/release!public! !
!Refactory.Browser.RBParseTreeRule categoriesFor: #owner:!initialize/release!public! !
!Refactory.Browser.RBParseTreeRule categoriesFor: #performOn:!matching!public! !
!Refactory.Browser.RBParseTreeRule categoriesFor: #searchString:!initialize/release!public! !
!Refactory.Browser.RBParseTreeRule categoriesFor: #sentMessages!accessing!public! !

!Refactory.Browser.RBParseTreeRule class methodsFor!

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
!Refactory.Browser.RBParseTreeRule class categoriesFor: #methodSearch:!instance creation!public! !
!Refactory.Browser.RBParseTreeRule class categoriesFor: #new!instance creation!public! !
!Refactory.Browser.RBParseTreeRule class categoriesFor: #search:!instance creation!public! !

