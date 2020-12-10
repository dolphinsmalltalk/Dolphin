"Filed out from Dolphin Smalltalk 7"!

UI.Tests.PresenterTest subclass: #'Tools.Tests.MethodWorkspaceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.MethodWorkspaceTest guid: (Core.GUID fromString: '{e5dadb09-1b76-4a90-a763-95cc11d735d8}')!
Tools.Tests.MethodWorkspaceTest comment: ''!
!Tools.Tests.MethodWorkspaceTest categoriesForClass!Unclassified! !
!Tools.Tests.MethodWorkspaceTest methodsFor!

classToTest
	"Although we want to test MethodWorkspace, it has to be created within a MethodBrowser to give it context."

	^MethodBrowser!

testSelectedOrNearestNode
	| env workspace node |
	env := Refactory.Browser.BrowserEnvironment new forClass: MethodWorkspace selectors: #(#selectedNode).
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
!Tools.Tests.MethodWorkspaceTest categoriesFor: #classToTest!helpers!private! !
!Tools.Tests.MethodWorkspaceTest categoriesFor: #testSelectedOrNearestNode!public! !

