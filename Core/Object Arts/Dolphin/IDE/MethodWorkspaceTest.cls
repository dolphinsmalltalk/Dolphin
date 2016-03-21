"Filed out from Dolphin Smalltalk 7"!

PresenterTest subclass: #MethodWorkspaceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodWorkspaceTest guid: (GUID fromString: '{E5DADB09-1B76-4A90-A763-95CC11D735D8}')!
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
	presenter method: env allMethods first.
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
!MethodWorkspaceTest categoriesFor: #classToTest!helpers!private! !
!MethodWorkspaceTest categoriesFor: #testSelectedOrNearestNode!public! !

