"Filed out from Dolphin Smalltalk 7"!

Tools.RefactoringTool subclass: #'Tools.MethodRefactoringTool'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.MethodRefactoringTool guid: (Core.GUID fromString: '{10c7f39b-1ac8-431a-bdc8-4ed608d35a1c}')!
Tools.MethodRefactoringTool comment: 'MethodRefactoringTool implements method refactorings for a browser.

There are a number of browser (or browser like tools) that display lists of methods and which support method level refactorings, for example the class & method browsers, the debugger (where the list of methods is those on the stack), and the package browser. This class encapsulates method-level refactoring behaviour so that it does not need to be duplicated in all those places.
'!
!Tools.MethodRefactoringTool categoriesForClass!Unclassified! !
!Tools.MethodRefactoringTool methodsFor!

addParameter
	"Command to invoke the Add Parameter to Method refactoring."

	presenter 
		performMethodRenameRefactoring: [:method | self systemModel addParameterToMethod: method]!

allMethodTemps
	^self parseTree ifNil: [#()] ifNotNil: [:ast | ast allTemporaryVariableNodes]!

buildTempsMenu: aMenu command: aSymbol identifiers: aCollection 
	aMenu clear.
	aCollection do: 
			[:each | 
			aMenu addCommand: (MessageSend 
						receiver: self
						selector: aSymbol
						argument: each)
				description: each name].
	"If there is only a single item, make it the default."
	aMenu size = 1 ifTrue: [(aMenu itemAt: 1) isDefault: true]!

canPushDownMethods
	^presenter hasEditableMethodsSelected 
		and: [presenter selectedMethods allSatisfy: [:each | each methodClass subclasses notEmpty]]!

canPushUpMethods
	^presenter hasEditableMethodsSelected 
		and: [presenter selectedMethods allSatisfy: [:each | each methodClass superclass notNil]]!

inlineAllSelfSends
	"Private - Invoke the 'Inline all Self Sends' method refactoring to in-line all
	self sends of the currently selected method."

	presenter performMethodsRefactoring: 
			[:methods | 
			self systemModel inlineAllSelfSendsOf: methods within: presenter searchEnvironment]
		name: 'Inline Self Sends'!

methodArguments
	^self parseTree ifNil: [#()] ifNotNil: [:ast | ast arguments]!

methodTemps
	^self parseTree 
		ifNil: [#()]
		ifNotNil: [:ast | ast allDefinedVariableNodes difference: ast arguments]!

moveMethod
	"Private - Invoke the 'Move to Component' method refactoring to move the selected method to
	the class of some variable in that method's scope."

	| variable |
	variable := self systemModel selectTargetVariableOf: presenter selectedMethod methodClass
				parseTree: self parseTree.
	variable isNil ifTrue: [^self].
	presenter performMethodRefactoring: 
			[:method | 
			self systemModel 
				moveToComponent: method selector
				in: method methodClass
				variable: variable]!

onAboutToDisplayMenu: aMenu 
	"The pop-up <Menu>, popup, is about to be displayed.
	This is our opportunity to update it, e.g. to add/remove items."

	| name |
	name := aMenu name.
	name == #removeParameterMenu 
		ifTrue: 
			[self 
				buildTempsMenu: aMenu
				command: #removeParameter:
				identifiers: self methodArguments.
			"By default remove the last param"
			aMenu notEmpty ifTrue: [(aMenu itemAt: aMenu size) isDefault: true].
			^true].
	name == #inlineParameterMenu 
		ifTrue: 
			[self 
				buildTempsMenu: aMenu
				command: #inlineParameter:
				identifiers: self methodArguments.
			^true].
	name == #renameTempMenu 
		ifTrue: 
			[self 
				buildTempsMenu: aMenu
				command: #renameTemporary:
				identifiers: self methodTemps.
			^true].
	name == #renameParameterMenu 
		ifTrue: 
			[self 
				buildTempsMenu: aMenu
				command: #renameTemporary:
				identifiers: self methodArguments.
			^true].
	name == #convertTempToInstVarMenu 
		ifTrue: 
			[self 
				buildTempsMenu: aMenu
				command: #convertTempToInstVar:
				identifiers: self allMethodTemps.
			^true].
	"Not a refactoring menu"
	^false!

pushDownMethods
	"Private - Pushes down the selected method into all subclasses that don't implement the
	method, but only if the method's class is abstract."

	^self pushMethods: false!

pushMethods: aBoolean
	"Pushes up or down the selected methods, depending on the <boolean> argument."

	^presenter
		performMethodsRefactoring: [:methods | self systemModel pushMethods: methods up: aBoolean]
		name: ('Push Methods <1?Up:Down>' expandMacrosWith: aBoolean)!

pushUpMethods
	"Private - Pushes up the selected method into the superclass. If the superclass is abstract
	and already defines the method, then the superclass' method will be copied down into the
	other subclasses that don't already define the method."

	^self pushMethods: true!

queryCommand: aCommandQuery command: aCommand 
	| method selector |
	selector := aCommand asSymbol.
	#methodRefactoringsMenu == selector 
		ifTrue: 
			[aCommandQuery isEnabled: true.
			^true].
	(#(#safeRemoveMethods #inlineAllSelfSends) identityIncludes: selector) 
		ifTrue: 
			[aCommandQuery isEnabled: presenter hasEditableMethodsSelected.
			^true].
	#moveMethod == selector 
		ifTrue: 
			[aCommandQuery isEnabled: presenter canMoveMethods.
			^true].
	(#(#renameMethod #renameMethodReferences #addParameter) identityIncludes: selector) 
		ifTrue: 
			[aCommandQuery isEnabled: presenter hasRefactorableMethodSelected.
			^true].
	#pushUpMethods == selector 
		ifTrue: 
			[aCommandQuery isEnabled: (Keyboard default isShiftDown not and: [self canPushUpMethods]).
			^true].
	#pushDownMethods == selector 
		ifTrue: 
			[aCommandQuery isEnabled: (Keyboard default isShiftDown not and: [self canPushDownMethods]).
			^true].
	method := presenter selectedMethod.
	(#(#removeParameterMenu #inlineParameterMenu #renameParameterMenu) identityIncludes: selector) 
		ifTrue: 
			[aCommandQuery isEnabled: (presenter hasRefactorableMethodSelected 
						and: [method isNil or: [method argumentCount > 0]]).
			^true].
	(#(#convertTempToInstVarMenu #renameTempMenu) identityIncludes: selector) 
		ifTrue: 
			[aCommandQuery 
				isEnabled: (presenter hasRefactorableMethodSelected and: [method isNil or: [method tempCount > 0]]).
			^true].
	^false!

renameItCommand
	"Private - Answer the appropriate rename command for the context sensitive 'Rename It' command, given
	the current focus and in the receiver."

	^Message selector: #renameMethod!

renameMethod
	"Initiate a 'Rename' method refactoring against the selected method to rename
	all implementors and senders."

	self renameMethod: presenter selectedMethod!

renameMethod: aCompiledMethod 
	presenter 
		performMethodRenameRefactoring: [:method | self systemModel renameMethod: aCompiledMethod]!

renameMethodReferences
	"Initiate a 'Rename References' method refactoring against the selected method to rename
	all senders. Note that this may not preserve behaviour, but is occassionally useful when (for example)
	removing a duplicate method."

	presenter 
		performMethodRenameRefactoring: [:method | self systemModel renameMethodReferences: method]!

safeRemoveMethods
	"Invoke the 'Remove Method' refactoring"

	presenter performMethodsRefactoring: [:methods | self systemModel safeRemoveMethods: methods]
		name: 'Safe Remove Methods'! !
!Tools.MethodRefactoringTool categoriesFor: #addParameter!commands!public!refactoring! !
!Tools.MethodRefactoringTool categoriesFor: #allMethodTemps!event handling!menus!public! !
!Tools.MethodRefactoringTool categoriesFor: #buildTempsMenu:command:identifiers:!helpers!menus!private! !
!Tools.MethodRefactoringTool categoriesFor: #canPushDownMethods!public!refactoring!testing! !
!Tools.MethodRefactoringTool categoriesFor: #canPushUpMethods!public!refactoring!testing! !
!Tools.MethodRefactoringTool categoriesFor: #inlineAllSelfSends!commands!private!refactoring! !
!Tools.MethodRefactoringTool categoriesFor: #methodArguments!event handling!menus!public! !
!Tools.MethodRefactoringTool categoriesFor: #methodTemps!event handling!menus!public! !
!Tools.MethodRefactoringTool categoriesFor: #moveMethod!commands!private!refactoring! !
!Tools.MethodRefactoringTool categoriesFor: #onAboutToDisplayMenu:!event handling!menus!public! !
!Tools.MethodRefactoringTool categoriesFor: #pushDownMethods!commands!private!refactoring! !
!Tools.MethodRefactoringTool categoriesFor: #pushMethods:!public!refactoring! !
!Tools.MethodRefactoringTool categoriesFor: #pushUpMethods!commands!public!refactoring! !
!Tools.MethodRefactoringTool categoriesFor: #queryCommand:command:!commands!private! !
!Tools.MethodRefactoringTool categoriesFor: #renameItCommand!constants!private!refactoring! !
!Tools.MethodRefactoringTool categoriesFor: #renameMethod!public!refactoring! !
!Tools.MethodRefactoringTool categoriesFor: #renameMethod:!commands!public!refactoring! !
!Tools.MethodRefactoringTool categoriesFor: #renameMethodReferences!commands!public!refactoring! !
!Tools.MethodRefactoringTool categoriesFor: #safeRemoveMethods!commands!public!refactoring! !

