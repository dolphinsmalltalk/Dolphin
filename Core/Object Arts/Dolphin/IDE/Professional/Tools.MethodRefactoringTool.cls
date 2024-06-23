"Filed out from Dolphin Smalltalk"!

Tools.RefactoringTool
	subclass: #'Tools.MethodRefactoringTool'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.MethodRefactoringTool guid: (Core.GUID fromString: '{10c7f39b-1ac8-431a-bdc8-4ed608d35a1c}')!

Tools.MethodRefactoringTool comment: 'MethodRefactoringTool implements method refactorings for a browser.

There are a number of browser (or browser like tools) that display lists of methods and which support method level refactorings, for example the class & method browsers, the debugger (where the list of methods is those on the stack), and the package browser. This class encapsulates method-level refactoring behaviour so that it does not need to be duplicated in all those places.
'!

!Tools.MethodRefactoringTool methodsFor!

addParameter
	"Command to invoke the Add Parameter to Method refactoring."

	<commandQuery: #queryRefactorSelectedMethod:>
	presenter
		performMethodRenameRefactoring: [:method | self developmentSystem addParameterToMethod: method]!

allMethodTemps
	^self parseTree ifNil: [#()] ifNotNil: [:ast | ast allTemporaryVariableNodes]!

buildConvertTempToInstVarMenu: aMenu
	self
		buildTempsMenu: aMenu
		command: #convertTempToInstVar:
		identifiers: self allMethodTemps!

buildInlineParameterMenu: aMenu
	self
		buildTempsMenu: aMenu
		command: #inlineParameter:
		identifiers: self methodArguments!

buildRemoveParameterMenu: aMenu
	self
		buildTempsMenu: aMenu
		command: #removeParameter:
		identifiers: self methodArguments.
	"By default remove the last param"
	aMenu notEmpty ifTrue: [(aMenu itemAt: aMenu size) isDefault: true]!

buildRenameParameterMenu: aMenu
	self
		buildTempsMenu: aMenu
		command: #renameTemporary:
		identifiers: self methodArguments!

buildRenameTempMenu: aMenu
	self
		buildTempsMenu: aMenu
		command: #renameTemporary:
		identifiers: self methodTemps!

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

canMoveMethods
	^presenter canMoveMethods!

canPushDownMethods
	^presenter hasEditableMethodsSelected 
		and: [presenter selectedMethods allSatisfy: [:each | each methodClass subclasses notEmpty]]!

canPushUpMethods
	^presenter hasEditableMethodsSelected 
		and: [presenter selectedMethods allSatisfy: [:each | each methodClass superclass notNil]]!

convertTempToInstVarMenu
	<commandQuery: #queryConvertTempToInstVarMenu:>
	<menuPopulator: #buildConvertTempToInstVarMenu:>
	!

hasEditableMethodsSelected
	^presenter hasEditableMethodsSelected!

inlineAllSelfSends
	"Invoke the 'Inline all Self Sends' method refactoring to in-line all
	self sends of the currently selected method."

	<commandQuery: #hasEditableMethodsSelected>
	presenter performMethodsRefactoring: 
			[:methods |
			self developmentSystem inlineAllSelfSendsOf: methods within: presenter searchEnvironment]
		name: 'Inline Self Sends'!

inlineParameterMenu
	<commandQuery: #queryRefactorParameter:>
	<menuPopulator: #buildInlineParameterMenu:>
	!

methodArguments
	^self parseTree ifNil: [#()] ifNotNil: [:ast | ast arguments]!

methodRefactoringsMenu
	"Always enabled"!

methodTemps
	^self parseTree 
		ifNil: [#()]
		ifNotNil: [:ast | ast allDefinedVariableNodes difference: ast arguments]!

moveMethod
	"Invoke the 'Move to Component' method refactoring to move the selected method to
	the class of some variable in that method's scope."

	<commandQuery: #canMoveMethods>
	| variable |
	variable := self developmentSystem selectTargetVariableOf: presenter selectedMethod methodClass
				parseTree: self parseTree.
	variable isNil ifTrue: [^self].
	presenter performMethodRefactoring: 
			[:method | 
			self developmentSystem 
				moveToComponent: method selector
				in: method methodClass
				variable: variable]!

pushDownMethods
	"Pushes down the selected method into all subclasses that don't implement the
	method, but only if the method's class is abstract."

	<commandQuery: #queryPushDownMethods:>
	^self pushMethods: false!

pushMethods: aBoolean
	"Pushes up or down the selected methods, depending on the <boolean> argument."

	^presenter
		performMethodsRefactoring: [:methods | self developmentSystem pushMethods: methods up: aBoolean]
		name: ('Push Methods <1?Up:Down>' expandMacrosWith: aBoolean)!

pushUpMethods
	"Private - Pushes up the selected method into the superclass. If the superclass is abstract
	and already defines the method, then the superclass' method will be copied down into the
	other subclasses that don't already define the method."

	<commandQuery: #queryPushUpMethods:>
	^self pushMethods: true!

queryConvertTempToInstVarMenu: aCommandQuery
	aCommandQuery
		isEnabled: (presenter hasRefactorableMethodSelected and: [self allMethodTemps notEmpty])!

queryPushDownMethods: aCommandQuery
	aCommandQuery isEnabled: (Keyboard default isShiftDown not and: [self canPushDownMethods])!

queryPushUpMethods: aCommandQuery
	aCommandQuery isEnabled: (Keyboard default isShiftDown not and: [self canPushUpMethods])!

queryRefactorParameter: aCommandQuery
	| method |
	method := presenter selectedMethod.
	aCommandQuery isEnabled: (presenter hasRefactorableMethodSelected
				and: [method isNil or: [method argumentCount > 0]])!

queryRefactorSelectedMethod: aCommandQuery
	presenter hasRefactorableMethodSelected ifFalse: [^self].
	aCommandQuery
		beEnabled;
		expandMenuTextWith: presenter selectedMethod!

queryRefactorTemp: aCommandQuery
	aCommandQuery isEnabled: (presenter hasRefactorableMethodSelected and: [self methodTemps notEmpty])!

removeParameterMenu
	<commandQuery: #queryRefactorParameter:>
	<menuPopulator: #buildRemoveParameterMenu:>
	!

renameItCommand
	"Private - Answer the appropriate rename command for the context sensitive 'Rename It' command, given
	the current focus and in the receiver."

	^Message selector: #renameMethod!

renameMethod
	"Initiate a 'Rename' method refactoring against the selected method to rename
	all implementors and senders."

	<commandQuery: #queryRefactorSelectedMethod:>
	self renameMethod: presenter selectedMethod!

renameMethod: aCompiledMethod 
	presenter 
		performMethodRenameRefactoring: [:method | self developmentSystem renameMethod: aCompiledMethod]!

renameMethodReferences
	"Initiate a 'Rename References' method refactoring against the selected method to rename
	all senders. Note that this may not preserve behaviour, but is occassionally useful when (for example)
	removing a duplicate method."

	<commandQuery: #queryRefactorSelectedMethod:>
	presenter
		performMethodRenameRefactoring: [:method | self developmentSystem renameMethodReferences: method]!

renameParameterMenu
	<commandQuery: #queryRefactorParameter:>
	<menuPopulator: #buildRenameParameterMenu:>
	!

renameTempMenu
	<commandQuery: #queryRefactorTemp:>
	<menuPopulator: #buildRenameTempMenu:>
	! !

!Tools.MethodRefactoringTool categoriesForMethods!
addParameter!commands-actions!public!refactoring! !
allMethodTemps!event handling!menus!public! !
buildConvertTempToInstVarMenu:!commands-menus!private! !
buildInlineParameterMenu:!commands-menus!private! !
buildRemoveParameterMenu:!commands-menus!private! !
buildRenameParameterMenu:!commands-menus!private! !
buildRenameTempMenu:!commands-menus!private! !
buildTempsMenu:command:identifiers:!helpers!menus!private! !
canMoveMethods!commands-queries!private! !
canPushDownMethods!commands-queries!public! !
canPushUpMethods!commands-queries!public! !
convertTempToInstVarMenu!commands-menus!public! !
hasEditableMethodsSelected!commands-queries!private! !
inlineAllSelfSends!commands-actions!public!refactoring! !
inlineParameterMenu!commands-menus!public! !
methodArguments!event handling!menus!public! !
methodRefactoringsMenu!commands-menus!public! !
methodTemps!event handling!menus!public! !
moveMethod!commands-actions!public!refactoring! !
pushDownMethods!commands-actions!public! !
pushMethods:!public!refactoring! !
pushUpMethods!commands-actions!public! !
queryConvertTempToInstVarMenu:!commands-queries!private! !
queryPushDownMethods:!commands-queries!private! !
queryPushUpMethods:!commands-queries!private! !
queryRefactorParameter:!commands-queries!private! !
queryRefactorSelectedMethod:!commands-queries!private! !
queryRefactorTemp:!commands-queries!private! !
removeParameterMenu!commands-menus!public! !
renameItCommand!commands-mappings!constants!private!refactoring! !
renameMethod!public!refactoring! !
renameMethod:!commands-actions!public! !
renameMethodReferences!commands-actions!public!refactoring! !
renameParameterMenu!commands-menus!public! !
renameTempMenu!commands-menus!public! !
!

