"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Tools.RefactoringTool'
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

!Tools.RefactoringTool methodsFor!

convertTempToInstVar: aStVariableNode 
	"Private - Command to invoke the 'Convert to Instance Variable' code refactoring
	on the specified temporary variable name."

	presenter performMethodRefactoring: 
			[:method | 
			self developmentSystem 
				convertTemporaryToInstanceVariable: aStVariableNode name
				in: method methodClass
				selector: method selector]!

developmentSystem
	^SmalltalkSystem current!

inlineParameter: aStVariableNode 
	presenter performMethodRenameRefactoring: 
			[:method | 
			self developmentSystem 
				inlineParameter: aStVariableNode name
				from: method selector
				in: method methodClass]!

onAboutToDisplayMenu: aMenu
	"The pop-up <Menu> is about to be displayed. This is our opportunity to update it, e.g. to add/remove items.
	Note: Adding an item persists as the menu is not destroyed until the view is closed."

	self class commandAnnotations onAboutToDisplayMenu: aMenu for: self!

parseTree
	^presenter parseTree!

queryCommand: aCommandQuery
	"Enter details about a potential command for the receiver  into the <CommandQuery> argument."

	(self class commandAnnotations queryCommand: aCommandQuery ofTarget: self) ifTrue: [^true].
	(aCommandQuery canPerformAgainst: self) ifTrue: [aCommandQuery beEnabled].
	^false	"There was no specific enablement of the command at this level"!

queryContextCommand: aCommandQuery as: aCommandMessage
	| originalCommand |
	originalCommand := aCommandQuery commandDescription.
	aCommandQuery commandDescription: (originalCommand copy
				command: aCommandMessage;
				yourself).
	^[self queryCommand: aCommandQuery] ensure: [aCommandQuery commandDescription: originalCommand]!

queryRenameItCommand: aCommandQuery
	self renameItCommand ifNotNil: [:selector | self queryContextCommand: aCommandQuery as: selector]!

removeParameter: aStVariableNode 
	"Private - Command to invoke the 'Remove Method Parameter' refactoring on the specified
	argument name."

	presenter 
		performMethodRenameRefactoring: [:method | self removeParameter: aStVariableNode from: method]!

removeParameter: aStVariableNode from: method 
	^self developmentSystem 
		removeParameter: aStVariableNode name
		from: method selector
		in: method methodClass
		within: presenter searchEnvironment!

renameIt
	"Context-sensitive #renameIt command, usually bound to the F2 key."

	<commandQuery: #queryRenameItCommand:>
	| command |
	command := self renameItCommand.
	"Defer the action so that the wait cursor is not active during any in-place edit operation that might be initiated."
	[command value: self] postToMessageQueue!

renameItCommand
	^self subclassResponsibility!

renameTemporary: aStVariableNode 
	"Private - Invoke the 'Rename Temporary' code refactoring to rename the temporary variable
	identified by the specified variable node."

	presenter performMethodRefactoring: 
			[:method | 
			self developmentSystem 
				renameTemporary: aStVariableNode
				to: nil
				in: method methodClass
				selector: method selector]!

setPresenter: aPresenter 
	presenter := aPresenter! !

!Tools.RefactoringTool categoriesForMethods!
convertTempToInstVar:!public!refactoring! !
developmentSystem!constants!public! !
inlineParameter:!private!refactoring! !
onAboutToDisplayMenu:!event handling!public! !
parseTree!accessing!private! !
queryCommand:!commands-queries!public! !
queryContextCommand:as:!commands-mappings!commands-queries!private! !
queryRenameItCommand:!commands-queries!private! !
removeParameter:!operations!private!refactoring! !
removeParameter:from:!operations!private!refactoring! !
renameIt!commands-actions!public!refactoring! !
renameItCommand!private!refactoring! !
renameTemporary:!operations!private!refactoring! !
setPresenter:!initializing!private! !
!

Tools.RefactoringTool methodProtocol: #commandTarget attributes: #(#readOnly) selectors: #(#queryCommand:)!

!Tools.RefactoringTool class methodsFor!

commandAnnotations
	^CommandAnnotationsRegister.Current annotationsFor: self!

forPresenter: aPresenter 
	^(self new)
		setPresenter: aPresenter;
		yourself! !

!Tools.RefactoringTool class categoriesForMethods!
commandAnnotations!accessing!public! !
forPresenter:!instance creation!public! !
!

