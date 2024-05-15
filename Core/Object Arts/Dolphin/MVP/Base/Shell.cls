"Filed out from Dolphin Smalltalk"!

Presenter subclass: #Shell
	instanceVariableNames: 'caption commandHistory'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Shell guid: (GUID fromString: '{87b4c68f-026e-11d3-9fd7-00a0cc3e4a32}')!

Shell comment: 'Shell implements the <topPresenter> protocol for presenters that are to appear in <topView>s; i.e. in top-level windows on the desktop.A Shell provides methods for supplying a caption for the associated <topView> and for maintaining a <HistoryList> of commands that have recently been performed within it. By default, a Shell will not maintain a command history unless it is explicitly told to do so using its #hasCommandHistory aspect. The purpose of maintaining a command history is to support the potential for #undo and #redo operations. For these to work successfully, each <Command> must be provided with an appropriate undo action after it has been performed. For more details see the comment for Command.

Instance Variables:
	caption		<readableString> or nil, holding and explicit caption for the associated <topView>.
	commandHistory	<HistoryList> or nil, holding a history of <Command>s that the presenter has recently performed.

'!

!Shell categoriesForClass!MVP-Presenters!MVP-Resources-Shells! !

!Shell methodsFor!

addCommandHistory: aCommand 
	"Private - Adds aCommand to the receiver's command history list.
	Only do this if the command is undoable. If not then clear the list unless
	the command has been marked as being benign."

	self hasCommandHistory ifFalse: [^self].
	aCommand isBenign ifTrue: [^self].
	aCommand canUndo 
		ifTrue: [commandHistory addLast: aCommand]
		ifFalse: [self clearCommandHistory]!

allAdditionalKeyBindings
	"Private - Answer a collection of additional accelerator definitions for commands not on the menu bar of the receiver's view(s),
	but which either the receiver of one of its sub-presenters wants to define.
	Each element of the collection should be a two element <Array>, the first element of which is the command symbol
	and the second the accelerator key string."

	| answer |
	answer := OrderedCollection withAll: self additionalKeyBindings.
	self allSubPresentersDo: [:each | answer addAll: each additionalKeyBindings].
	^answer!

caption
	"Answer the caption of the receiver"

	^caption!

caption: aString
	"Set the caption of the receiver to aString"

	aString = caption ifTrue: [^self].
	caption := aString.
	self view notNil ifTrue: [self view caption: aString].
	self trigger: #captionChanged!

clearCommandHistory
	"Clear the receiver's command history list if one is available"

	commandHistory notNil ifTrue: [
		commandHistory := HistoryList new ]!

close
	"Attempt to close the receiver's view."

	^self view close!

commandHistory
	"Private - Answer the history list of recent commands for the receiver"

	^commandHistory!

commandPolicyClass
	"Answers the class of <commandPolicy> to use for routing commands originating
	in the receiver or one of its sub-presenters."

	^CommandPolicy defaultClass!

commandPolicyWithSource: sourceView
	"Answers a <CommandPolicy> object for routing commands originating
	from the <View>, source. 
	This can be overridden by subclasses which wish to use a different routing policy, 
	although to substitute a specialized <commandPolicy> one should override 
	#commandPolicyClass."

	^self commandPolicyClass
		commandSource: sourceView!

createView: aResourceNameString 
	"Private - Creates and connects a view for the receiver from the resource identified
	by aResourceNameString. Answers the new view created"

	| contextView |
	contextView := parentPresenter isNil ifTrue: [View desktop] ifFalse: [parentPresenter view].
	self view: (self class loadViewResource: aResourceNameString inContext: contextView).
	^self view!

exit
	"Attempt to close the receiver's view."

	^self view close!

hasCommandHistory
	"Answer true if the receiver can undo/redo commands"

	^commandHistory notNil!

hasCommandHistory: aBoolean
	"Set the receiver to allow it to keep a command history list
	to allow commands to be undone"

	commandHistory := aBoolean ifTrue: [ HistoryList new ].!

onAboutToDisplaySystemMenu: hMenu
	"The system menu with <integer> handle, hMenu, is about to be displayed.
	This is our opportunity to update it, e.g. to add our own items."

	^self view onAboutToDisplaySystemMenu: hMenu!

onIdleEntered
	"There are no messages in the input queue and the input state is
	about to go idle. Reflect back to the view so that it can update
	any visible UI elements such as toolbar buttons."

	^self view onIdleEntered!

onSettingChanged: aWindowEvent 
	^self view onSettingChanged: aWindowEvent!

onTimeChanged: aWindowEvent 
	^self view onTimeChanged: aWindowEvent!

onViewActivated: anEvent
	"Default handler for activation. Pass on the the view"

	^self view onViewActivated: anEvent!

onViewDeactivated: anEvent
	"Default handler for de-activation. Pass on to view"

	^self view onViewDeactivated: anEvent!

onViewDestroyed
	"The <ShellView> associated with the receiver has been destroyed. Cleanup, and shutdown a
	runtime session if this is the main shell of an application."

	super onViewDestroyed.
	(self class shutdownOnExit and: [SessionManager current isRuntime]) 
		ifTrue: [SessionManager current exit]!

onViewMinimized: aSizeEvent
	"Default handler for window minimized. Pass on to the view"

	^self view onViewMinimized: aSizeEvent!

onViewNcActivated: anEvent 
	"Default handler for window frame activation. Pass on to view.
	BE CAREFUL overriding this method. See comment in ShellView>>wmNcActivate:wparam:lParam:
	"

	^self view onViewNcActivated: anEvent!

onViewNcDeactivated: anEvent 
	"Default handler for window frame deactivation. Pass on to view.

	BE CAREFUL overriding this method. See comment in ShellView>>wmNcActivate:wparam:lParam:
	"

	^self view onViewNcDeactivated: anEvent!

onViewOpened
	"Received when the receiver's view has been connected."

	super onViewOpened.
	caption := self view caption.
	self
		updateIcon;
		invalidateUserInterface;
		updateCaption.
	self class trigger: #viewOpened: with: self!

onViewRestored: aSizeEvent
	"Default handler for window restored. Pass on to the view"

	^self view onViewRestored: aSizeEvent!

performCommand: aCommand
	"Performs aCommand on the receiver and answer the result.
	Can be overridden by subclasses that wish, perhaps, to add some
	generic undo/redo ability for all commands."

	^self view performCommand: aCommand!

queryCommand: aCommandQuery 
	"Enters details about a potential command for the receiver into the <CommandQuery>
	arugment."

	| cmd |
	cmd := aCommandQuery commandSymbol.

	"Handle Undo/Redo commands"
	cmd == #undo 
		ifTrue: 
			[| description |
			description := ''.
			aCommandQuery beDisabled.
			self hasCommandHistory 
				ifTrue: 
					[commandHistory pastSize >= 0 
						ifTrue: 
							[| command |
							command := self commandHistory current.
							description := command description.
							aCommandQuery beEnabled].
					aCommandQuery text: (aCommandQuery commandDescription menuText expandMacrosWith: description)].
			^true].
	cmd == #redo 
		ifTrue: 
			[| description |
			description := ''.
			aCommandQuery beDisabled.
			self hasCommandHistory 
				ifTrue: 
					[commandHistory hasFuture 
						ifTrue: 
							[| command |
							command := self commandHistory next.
							command canRedo 
								ifTrue: 
									[description := self commandHistory next description.
									aCommandQuery beEnabled]].
					aCommandQuery text: (aCommandQuery commandDescription menuText expandMacrosWith: description)].
			^true].
	^super queryCommand: aCommandQuery!

redo
	"Redo the last command that is forward in the command history list. During the redo operation
	we place the receiver in a state where it will not accept any further command histories."

	"Save the original history list"
	| history |
	self hasCommandHistory ifFalse: [^self].
	history := commandHistory.
	commandHistory := nil.
	[(history goForward: 1) redo] ensure: 
			["Restore the original history list"
			commandHistory := history].

	"Mark the current command (#redo) as benign so that it will
		not require the command history to be cleared even though it has no
		explicit undo action"
	Command current beBenign!

setInitialFocus
	"Received when the receiver's view is first opened.
	Set the initial keyboard focus to the first view in the tab sequence.
	Can be overidden by subclasses that find this behaviour 
	unacceptable"

	self view setInitialFocus!

shortCaption
	^self caption!

undo
	"Undo the current command in the command history list. During the undo operation
	we place the receiver in a state where it will not accept any further command histories."

	| history command |
	self hasCommandHistory ifFalse: [^self].
	"Save the original history list"
	history := commandHistory.
	commandHistory := nil.

	"Perform the undo"
	
	[command := history current.
	command undo] ensure: 
				["Restore the original history list. If the command executed can be redone
			then backup by one command. Otherwise we clear the redo portion of the list."

				commandHistory := history].
	commandHistory goBack: 1.
	command canRedo ifFalse: [commandHistory clearFuture].

	"Mark the current command (#undo) as benign so that it will
		not require the command history to be cleared even though it has no
		explicit undo action"
	Command current beBenign!

updateCaption
	"The receiver has changed in such a way that the caption may need to be refreshed.
	Overidden in subclasses that need to provide a dynamic caption that changes
	according to the state of the receiver"

	!

updateIcon
	"Private - Transfer any icon across to the view"

	self view largeIcon isNil ifTrue: [
		"Update the view's icon if not explicitly specified"
		self view largeIcon: self icon ].
!

view: aShellView
	"Set the view for the receiver to aShellView. 
	After this is complete we inform all our sub presenters that
	everything is open and ready to go."

	super view: aShellView.
	self onViewOpened; setInitialFocus
! !

!Shell categoriesForMethods!
addCommandHistory:!accessing!private! !
allAdditionalKeyBindings!constants!private! !
caption!accessing!public! !
caption:!accessing!public! !
clearCommandHistory!accessing!public! !
close!commands!public! !
commandHistory!accessing!private! !
commandPolicyClass!commands!constants!public! !
commandPolicyWithSource:!commands!public! !
createView:!operations!private! !
exit!commands!public! !
hasCommandHistory!accessing!public! !
hasCommandHistory:!accessing!public! !
onAboutToDisplaySystemMenu:!event handling!public! !
onIdleEntered!event handling!public! !
onSettingChanged:!event handling-win32!public! !
onTimeChanged:!event handling-win32!public! !
onViewActivated:!event handling!public! !
onViewDeactivated:!event handling!public! !
onViewDestroyed!event handling!public! !
onViewMinimized:!event handling!public! !
onViewNcActivated:!event handling!public! !
onViewNcDeactivated:!event handling!public! !
onViewOpened!event handling!public! !
onViewRestored:!event handling!public! !
performCommand:!commands!public! !
queryCommand:!commands!private! !
redo!commands!public! !
setInitialFocus!operations!public! !
shortCaption!accessing!public! !
undo!commands!public! !
updateCaption!public!updating! !
updateIcon!private!updating! !
view:!accessing!public! !
!

Shell methodProtocol: #topPresenter attributes: #(#readOnly) selectors: #(#caption #caption: #commandPolicyWithSource: #ensureVisible #invalidateUserInterface #onAboutToDisplayMenu: #onAboutToDisplaySystemMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewActivated: #onViewClosed #onViewDeactivated: #onViewMinimized: #onViewOpened #onViewRestored: #parentPresenter #performAction #performCommand: #setFocus #show #topShell #updateCaption #view)!

!Shell class methodsFor!

asSessionManagerClass
	^DefaultShellSessionManager!

create: aResourceNameString
	"Answers an instance of the receiver created with no parent presenter
	and wired up to a view identified by the resource name aResourceNameString. 
	The view must be a Shell and will be a child of the desktop"

	| newOne |
	newOne := self new.
	newOne createView: aResourceNameString.
	^newOne!

create: aResourceNameString in: aCompositePresenter on: aModel 
	"Answers an instance of the receiver created as a sub-presenter of aCompositePresenter
	and wired up to a view identified by the resource name aResourceNameString. The new
	presenter is to be connected to aModel. It is assumed that, at this stage, aCompositePresenter
	is already opened in a view. For this reason we must force an #onViewOpened message to
	the newly created presenter"

	| newOne |
	newOne := aCompositePresenter add: (self on: aModel).
	newOne createView: aResourceNameString.
	^newOne!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

installNew
	^(self asSessionManagerClass basicNew mainShellClass: self) install!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 549 nil nil nil 416 nil 170 192 8 #() nil nil nil nil nil 1 nil nil nil nil 1 nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 7039 21 642 1201 801 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 23 16 0 0 154 1 0 0] 8 #() 642 193 193 nil 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	"Implementation Note: For backwards compatibility, this is currently false, although this
	does mean most applications will need to override for their main shell window."

	^false! !

!Shell class categoriesForMethods!
asSessionManagerClass!converting!public!VM and session managerment! !
create:!instance creation!public! !
create:in:on:!instance creation!public! !
icon!constants!public! !
installNew!converting!public!VM and session managerment! !
resource_Default_view!public!resources-views! !
shutdownOnExit!public!testing! !
!

