"Filed out from Dolphin Smalltalk 7"!

UI.Tests.ScintillaLexerMetadataTest subclass: #'UI.Tests.ScintillaLexerPropertyTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ScintillaLexerPropertyTest guid: (Core.GUID fromString: '{1b677d4d-c0bc-462a-8bc4-8a83f2b32b67}')!
UI.Tests.ScintillaLexerPropertyTest comment: ''!
!UI.Tests.ScintillaLexerPropertyTest categoriesForClass!Unclassified! !
!UI.Tests.ScintillaLexerPropertyTest methodsFor!

testViewId
	| prop1 prop2 view originalMethod testMethod |
	view := Object new.
	prop1 := Smalltalk.ScintillaLexerProperty view: view id: 1.
	self assert: prop1 view identicalTo: view.
	self assert: prop1 id equals: 1.
	originalMethod := Smalltalk.ScintillaLexerProperty class lookupMethod: #view:id:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	prop2 := testMethod value: Smalltalk.ScintillaLexerProperty withArguments: {view. 1}.
	self assert: prop2 view identicalTo: view.
	self assert: prop2 id equals: 1! !
!UI.Tests.ScintillaLexerPropertyTest categoriesFor: #testViewId!public!unit tests! !

