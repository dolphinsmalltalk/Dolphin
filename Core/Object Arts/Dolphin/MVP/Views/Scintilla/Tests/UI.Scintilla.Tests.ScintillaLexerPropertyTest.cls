"Filed out from Dolphin Smalltalk"!

UI.Scintilla.Tests.ScintillaLexerMetadataTest
	subclass: #'UI.Scintilla.Tests.ScintillaLexerPropertyTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Scintilla.Tests.ScintillaLexerPropertyTest guid: (Core.GUID fromString: '{1b677d4d-c0bc-462a-8bc4-8a83f2b32b67}')!

UI.Scintilla.Tests.ScintillaLexerPropertyTest comment: ''!

!UI.Scintilla.Tests.ScintillaLexerPropertyTest methodsFor!

testViewId
	| prop1 prop2 view originalMethod testMethod |
	view := Object new.
	prop1 := LexerProperty view: view id: 1.
	self assert: prop1 view identicalTo: view.
	self assert: prop1 id equals: 1.
	originalMethod := LexerProperty class lookupMethod: #view:id:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	prop2 := testMethod value: LexerProperty withArguments: {view. 1}.
	self assert: prop2 view identicalTo: view.
	self assert: prop2 id equals: 1! !

!UI.Scintilla.Tests.ScintillaLexerPropertyTest categoriesForMethods!
testViewId!public!unit tests! !
!

