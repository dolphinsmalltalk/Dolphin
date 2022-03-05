"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #MethodWorkspaceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodWorkspaceTest guid: (GUID fromString: '{e5dadb09-1b76-4a90-a763-95cc11d735d8}')!
MethodWorkspaceTest comment: ''!
!MethodWorkspaceTest categoriesForClass!Unclassified! !
!MethodWorkspaceTest methodsFor!

classToTest
	"Although we want to test MethodWorkspace, it has to be created within a MethodBrowser to give it context."

	^MethodBrowser!

testSelectedOrNearestNode
	| env workspace node |
	env := BrowserEnvironment new forClass: MethodWorkspace selectors: #(#selectedNode).
	presenter methods: env.
	presenter selectMethod: env allMethods first.
	self waitForInputIdle.
	workspace := presenter sourcePresenter.
	workspace selectionRange: (1 to: 0).
	node := workspace selectedNode.
	self assert: node isMethod.
	workspace selectionRange: (1 to: 1).
	node := workspace selectedNode.
	self assert: node isMethod.
	workspace selectionRange: (2 to: 1).
	node := workspace selectedNode.
	self assert: node isMethod.
	workspace selectionRange: (22 to: 21).
	node := workspace selectedNode.
	self assert: node isMethod.
	workspace selectionRange: (221 to: 220).
	node := workspace selectedNode.
	self assert: node isVariable! !
!MethodWorkspaceTest categoriesForMethods!
classToTest!helpers!private! !
testSelectedOrNearestNode!public! !
!

