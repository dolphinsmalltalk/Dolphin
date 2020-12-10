"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.RefactoringTool'
	instanceVariableNames: 'presenter'
	classVariableNames: ''
	imports: #(#{Refactory.Browser private})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.RefactoringTool guid: (Core.GUID fromString: '{838c8c37-c249-4db4-b324-65cb5babdc40}')!
Tools.RefactoringTool isNonInstantiable: true!
Tools.RefactoringTool comment: 'RefactoringTool is the abstract class of plugins used to add refactoring functionality to browsers and other coding tools in the Dolphin IDE.

Note that RefactoringTool is neither a presenter nor a model, but it is a <commandTarget>.

Instance Variables:
	presenter		<presenter> hosting the refactoring tool. Its type will depend on the subclass.

'!
!Tools.RefactoringTool categoriesForClass!Unclassified! !
!Tools.RefactoringTool methodsFor!

convertTempToInstVar: aStVariableNode 
	"Private - Command to invoke the 'Convert to Instance Variable' code refactoring
	on the specified temporary variable name."

	presenter performMethodRefactoring: 
			[:method | 
			self systemModel 
				convertTemporaryToInstanceVariable: aStVariableNode name
				in: method methodClass
				selector: method selector]!

inlineParameter: aStVariableNode 
	presenter performMethodRenameRefactoring: 
			[:method | 
			self systemModel 
				inlineParameter: aStVariableNode name
				from: method selector
				in: method methodClass]!

onAboutToDisplayMenu: aMenu 
	"The pop-up <Menu> argument is about to be displayed. This is our opportunity to update it,
	e.g. to add/remove items."

	!

parseTree
	^presenter parseTree!

queryCommand: aCommandQuery
	"Private - Enter details about a potential command for the receiver into the
	<CommandQuery>."

	| selector cmd |
	cmd := aCommandQuery command.
	cmd isNil ifTrue: [^false].
	selector := cmd asSymbol.
	selector == #renameIt
		ifTrue: 
			[cmd := self renameItCommand.
			cmd isNil
				ifTrue: 
					[aCommandQuery
						isEnabled: false;
						text: (aCommandQuery commandDescription menuText expandMacrosWith: 'It').
					^true]].
	^self queryCommand: aCommandQuery command: cmd!

queryCommand: aCommandQuery command: aCommand 
	^self subclassResponsibility!

removeParameter: aStVariableNode 
	"Private - Command to invoke the 'Remove Method Parameter' refactoring on the specified
	argument name."

	presenter 
		performMethodRenameRefactoring: [:method | self removeParameter: aStVariableNode from: method]!

removeParameter: aStVariableNode from: method 
	^self systemModel 
		removeParameter: aStVariableNode name
		from: method selector
		in: method methodClass
		environment: presenter searchEnvironment!

renameIt
	"Context-sensitive #renameIt command, usually bound to the F2 key"

	self renameItCommand value: self!

renameItCommand
	^self subclassResponsibility!

renameTemporary: aStVariableNode 
	"Private - Invoke the 'Rename Temporary' code refactoring to rename the temporary variable
	identified by the specified variable node."

	presenter performMethodRefactoring: 
			[:method | 
			self systemModel 
				renameTemporary: aStVariableNode
				to: nil
				in: method methodClass
				selector: method selector]!

setPresenter: aPresenter 
	presenter := aPresenter!

systemModel
	^Smalltalk developmentSystem! !
!Tools.RefactoringTool categoriesFor: #convertTempToInstVar:!public!refactoring! !
!Tools.RefactoringTool categoriesFor: #inlineParameter:!private!refactoring! !
!Tools.RefactoringTool categoriesFor: #onAboutToDisplayMenu:!event handling!public! !
!Tools.RefactoringTool categoriesFor: #parseTree!accessing!private! !
!Tools.RefactoringTool categoriesFor: #queryCommand:!commands!public! !
!Tools.RefactoringTool categoriesFor: #queryCommand:command:!commands!private! !
!Tools.RefactoringTool categoriesFor: #removeParameter:!operations!private!refactoring! !
!Tools.RefactoringTool categoriesFor: #removeParameter:from:!operations!private!refactoring! !
!Tools.RefactoringTool categoriesFor: #renameIt!commands!public!refactoring! !
!Tools.RefactoringTool categoriesFor: #renameItCommand!private!refactoring! !
!Tools.RefactoringTool categoriesFor: #renameTemporary:!operations!private!refactoring! !
!Tools.RefactoringTool categoriesFor: #setPresenter:!initializing!private! !
!Tools.RefactoringTool categoriesFor: #systemModel!constants!public! !

Tools.RefactoringTool methodProtocol: #commandTarget attributes: #(#readOnly) selectors: #(#queryCommand:)!

!Tools.RefactoringTool class methodsFor!

forPresenter: aPresenter 
	^(self new)
		setPresenter: aPresenter;
		yourself! !
!Tools.RefactoringTool class categoriesFor: #forPresenter:!instance creation!public! !

