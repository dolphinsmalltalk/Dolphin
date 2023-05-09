"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Refactory.Browser.RBParseTreeRule'
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
	searchTree := RBPatternParser parseMethod: aString!

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
	searchTree := RBPatternParser parseExpression: aString onError: nil!

searchTree
	^searchTree!

sentMessages
	^searchTree sentMessages! !
!Refactory.Browser.RBParseTreeRule categoriesForMethods!
canMatch:!matching!public! !
context!accessing!private! !
foundMatchFor:!matching!public! !
methodSearchString:!initialize/release!public! !
owner:!initialize/release!public! !
performOn:!matching!public! !
searchString:!initialize/release!public! !
searchTree!accessing!public! !
sentMessages!accessing!public! !
!

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
!Refactory.Browser.RBParseTreeRule class categoriesForMethods!
methodSearch:!instance creation!public! !
new!instance creation!public! !
search:!instance creation!public! !
!

