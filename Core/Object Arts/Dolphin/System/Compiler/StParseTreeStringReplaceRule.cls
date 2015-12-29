"Filed out from Dolphin Smalltalk 2000 release 5.00"!

StParseTreeReplaceRule subclass: #StParseTreeStringReplaceRule
	instanceVariableNames: 'replaceTree'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StParseTreeStringReplaceRule comment: ''!

StParseTreeStringReplaceRule guid: (GUID fromString: '{BBDB2681-B086-4CDC-9EFD-14D33492C0AA}')!

!StParseTreeStringReplaceRule categoriesForClass!Refactory-ParseTree Matching! !
!StParseTreeStringReplaceRule methodsFor!

foundMatchFor: aProgramNode 
	| newTree |
	newTree := replaceTree copyInContext: self context.
	newTree copyCommentsFrom: aProgramNode.
	^newTree!

methodReplaceString: replaceString 
	replaceTree := SmalltalkParser parseRewriteMethod: replaceString!

replaceString: replaceString 
	replaceTree := SmalltalkParser parseRewriteExpression: replaceString.
	searchTree isSequence = replaceTree isSequence 
		ifFalse: 
			[searchTree isSequence 
				ifTrue: [replaceTree := StSequenceNode statements: (Array with: replaceTree)]
				ifFalse: [searchTree := StSequenceNode statements: (Array with: searchTree)]]!

searchFor: searchString replaceWith: replaceString 
	self searchString: searchString.
	self replaceString: replaceString!

searchFor: searchString replaceWith: replaceString when: aBlock 
	self searchFor: searchString replaceWith: replaceString.
	verificationBlock := aBlock!

searchForMethod: searchString replaceWith: replaceString 
	self methodSearchString: searchString.
	self methodReplaceString: replaceString!

searchForMethod: searchString replaceWith: replaceString when: aBlock 
	self searchForMethod: searchString replaceWith: replaceString.
	verificationBlock := aBlock!

searchForTree: aBRProgramNode replaceWith: replaceNode 
	searchTree := aBRProgramNode.
	replaceTree := replaceNode!

searchForTree: aBRProgramNode replaceWith: replaceString when: aBlock 
	self searchForTree: aBRProgramNode replaceWith: replaceString.
	verificationBlock := aBlock! !
!StParseTreeStringReplaceRule categoriesFor: #foundMatchFor:!matching!public! !
!StParseTreeStringReplaceRule categoriesFor: #methodReplaceString:!initialize/release!public! !
!StParseTreeStringReplaceRule categoriesFor: #replaceString:!initialize/release!public! !
!StParseTreeStringReplaceRule categoriesFor: #searchFor:replaceWith:!initialize/release!public! !
!StParseTreeStringReplaceRule categoriesFor: #searchFor:replaceWith:when:!initialize/release!public! !
!StParseTreeStringReplaceRule categoriesFor: #searchForMethod:replaceWith:!initialize/release!public! !
!StParseTreeStringReplaceRule categoriesFor: #searchForMethod:replaceWith:when:!initialize/release!public! !
!StParseTreeStringReplaceRule categoriesFor: #searchForTree:replaceWith:!initialize/release!public! !
!StParseTreeStringReplaceRule categoriesFor: #searchForTree:replaceWith:when:!initialize/release!public! !

!StParseTreeStringReplaceRule class methodsFor!

searchFor: searchString replaceWith: replaceString 
	^self new searchFor: searchString replaceWith: replaceString!

searchFor: searchString replaceWith: replaceString when: aBlock 
	^self new 
		searchFor: searchString
		replaceWith: replaceString
		when: aBlock!

searchForMethod: searchString replaceWith: replaceString
	^self new searchForMethod: searchString replaceWith: replaceString!

searchForMethod: searchString replaceWith: replaceString when: aBlock 
	^self new 
		searchForMethod: searchString
		replaceWith: replaceString
		when: aBlock!

searchForTree: searchString replaceWith: replaceString 
	^self new searchForTree: searchString replaceWith: replaceString!

searchForTree: searchString replaceWith: replaceString when: aBlock 
	^self new 
		searchForTree: searchString
		replaceWith: replaceString
		when: aBlock! !
!StParseTreeStringReplaceRule class categoriesFor: #searchFor:replaceWith:!instance creation!public! !
!StParseTreeStringReplaceRule class categoriesFor: #searchFor:replaceWith:when:!instance creation!public! !
!StParseTreeStringReplaceRule class categoriesFor: #searchForMethod:replaceWith:!instance creation!public! !
!StParseTreeStringReplaceRule class categoriesFor: #searchForMethod:replaceWith:when:!instance creation!public! !
!StParseTreeStringReplaceRule class categoriesFor: #searchForTree:replaceWith:!instance creation!public! !
!StParseTreeStringReplaceRule class categoriesFor: #searchForTree:replaceWith:when:!instance creation!public! !

