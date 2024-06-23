"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.CommandQuery'
	instanceVariableNames: 'commandDescription receiver source text flags image validationResult'
	classVariableNames: ''
	imports: #(#{OS.MENUITEMINFOW private})
	classInstanceVariableNames: ''
	classConstants: {}!

UI.CommandQuery guid: (Core.GUID fromString: '{87b4c46b-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.CommandQuery comment: 'A CommandQuery is used to determine whether, and how, a particular command can be performed. A command is queried in two situations. The first is to determine whether a command source should be enabled and/or checked. When a menu is pulled down it needs to determine the enable, default, and check state of each of its items. Similarly, a PushButton or ToolbarButton will need to determine its state; usually at idle time during #validateUserInterface processing. The second situation arises when a command is to be dispatched and executed. Again a CommandQuery is used to determine the target object that will actually perform it (i.e. the eventual receiver).

To determine the default/enable/checked state of a command, a CommandQuery is created and routed (using the current CommandPolicy) through each of the #queryCommand: methods of the potential target objects. The #queryCommand: method is responsible for using the #isDefault, #enabled: and #checked: methods to set the state of the command at that target location. If, at any point in the routing, a target object sets the CommandQuery as being enabled then the framework will determine that the target should be the eventual receiver of the command. As of Dolphin 3.0 a #queryCommand: implementation can also explicitly set the receiver to override the frameworks default behaviour. A further enhancement for 3.0 is the ability to specify a default command with #isDefault:, with this becoming the default menu item.

Note that a target may also explicitly set the #text: of a CommandQuery as part of the #queryCommand: interrogation. If this is done then the original menu or button text will be dynamically replaced by the newly specified text. Complete dynamic menus must be constructed by overriding <presenter>.onAboutToDisplayMenu:

Instance Variables:
	commandDescription		<CommandDescription> specifying the command being queried.
	receiver			<Object> indicating the target that will accept the command.
	source			<view> where the command originated.
	flags			<integer> containing various flags indicating the status of the command. '!

!UI.CommandQuery categoriesForClass!MVP-Commands! !

!UI.CommandQuery methodsFor!

applicationShell
	"Answers the <topPresenter> that will be responsible for performing this command."

	^self source topShell!

beChecked
	"Set the receiver into the checked state"

	flags := flags bitOr: MFS_CHECKED!

beDisabled
	"Set the receiver into the disabled state"

	flags := flags bitOr: MFS_DISABLED!

beEnabled
	"Set the receiver into the enabled state"

	flags := flags bitAnd: ##(MFS_DISABLED bitInvert)!

beUnchecked
	"Set the receiver into the not checked state"

	flags := flags bitAnd: ##(MFS_CHECKED bitInvert)!

canPerform
	"Answers true if the command described by the receiver can be performed.
	This requires a command receiver and that the command is enabled"

	^self receiver notNil and: [self isEnabled]!

canPerformAgainst: destination
	"Answer whether the command being queried by the receiver can
	be performed against the hypothetical <commandTarget>, destination."

	^self commandDescription canPerformAgainst: destination
!

command
	"Answer the command selector being queried"

	^self commandDescription command!

commandDescription
	"Answer the <commandDescription> being queried"

	^commandDescription!

commandDescription: aCommandDescription
	commandDescription := aCommandDescription!

commandDescription: action source: aView
	"Private - Initialize the receiver's instance variables."

	commandDescription := action.
	source := aView.!

commandSymbol
	"Answer the command selector being queried"

	^self commandDescription commandSymbol!

description
	"Answer the current description of the receiver"

	^self commandDescription description
!

expandMenuTextWith: anObject
	"Set the dynamic menu text associated with this to the result of expanding the macros of the <commandDescription>s menu text with the argument."

	self text: (commandDescription expandedMenuText: { anObject })!

image
	^image!

image: anObject
	image := anObject!

initialize
	"Private - Initialize the receiver. Command queries start off pessimistically in disabled
	unchecked state."

	super initialize.
	flags := MFS_DISABLED 
!

isChecked
	"Answer true if the receiver is in the checked state"

	^flags allMask: MFS_CHECKED!

isChecked: aBoolean
	"Set the whether or not the command associated with the receiver is 'checked'
	(toggled on). This will cause associated menu items to be displayed with a 
	tick mark (or a blob if using radio button style)."

	flags := flags mask: MFS_CHECKED set: aBoolean
!

isDefault
	"Answer whether the receiver is expecting to be the default item on its parent menu.
	Note: Obviously their can be only one default item per menu, so if more than one item
	claims default status only one will triumph. Under the current implementation this will
	be the last occurring default item, but this behaviour should not be relied upon."

	^flags anyMask: MFS_DEFAULT!

isDefault: aBoolean
	"Set whether the receiver is expected to be the default command for the host menu."

	flags := flags mask: MFS_DEFAULT set: aBoolean!

isEnabled
	"Answer true if the receiver is in the enabled state"

	^(flags bitAnd: MFS_DISABLED) == 0!

isEnabled: aBoolean
	"Set the enable state of the receiver to aBoolean"

	flags := flags mask: MFS_DISABLED set: aBoolean not!

menuStateFlags
	^flags bitAnd: ##(MFS_DISABLED | MFS_CHECKED | MFS_DEFAULT)!

menuText
	"Answer the full menu text (including accelerator key string, if any) associated with the receiver's <CommandDescription>."

	^commandDescription menuText!

newMenuImage
	"Private - Answer the full menu text to be used for the command associated with this query ."

	^self image ifNil: [commandDescription image]!

newMenuText
	"Private - Answer the full menu text to be used for the command associated with this query ."

	^self text ifNil: [commandDescription defaultMenuText]!

perform
	"Perform the command on the receiver and answer the result."

	| command answer shell |
	command := Command receiver: self receiver commandDescription: self commandDescription.
	shell := self applicationShell.
	answer := shell performCommand: command.
	"The command might close the window, in which case should we bother?"
	shell addCommandHistory: command.
	^answer!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	self basicPrintOn: aStream.
	aStream 
		nextPut: $(;
		print: self command.
	self isEnabled ifTrue: [aStream nextPutAll: ' enabled'].
	self isChecked ifTrue: [aStream nextPutAll: ' checked'].
	aStream 
		nextPutAll: ' receiver: ';
		print: self receiver;
		nextPut: $)!

receiver
	"Answers the receiver of the command"

	^receiver!

receiver: anObject
	"Set the receiver of this command to anObject. Usually sent by queryCommand:
	during command routing"

	receiver := anObject!

source
	"Answers the source of the command"

	^source!

source: aView
	"Private - Set the message source the receiver to aView"

	source := aView.!

text
	"Answer the text state of the receiver"

	^text!

text: aString
	"Set the text state of the receiver to aString"

	text := aString!

validationResult
	"Answer the <ValidationResult> set by a command query, if any."

	^validationResult ifNil: [ValidationResult value: self isEnabled]!

validationResult: aValidationResult
	validationResult := aValidationResult.
	self isEnabled: validationResult value! !

!UI.CommandQuery categoriesForMethods!
applicationShell!accessing!public! !
beChecked!accessing!public! !
beDisabled!accessing!public! !
beEnabled!accessing!public! !
beUnchecked!accessing!public! !
canPerform!public!testing! !
canPerformAgainst:!accessing!public! !
command!accessing!public! !
commandDescription!accessing!public! !
commandDescription:!accessing!public! !
commandDescription:source:!initializing!private! !
commandSymbol!accessing!public! !
description!accessing!public! !
expandMenuTextWith:!accessing!public! !
image!accessing!public! !
image:!accessing!public! !
initialize!initializing!private! !
isChecked!public!testing! !
isChecked:!accessing!public! !
isDefault!public!testing! !
isDefault:!accessing!public! !
isEnabled!public!testing! !
isEnabled:!accessing!public! !
menuStateFlags!accessing!private! !
menuText!accessing!public! !
newMenuImage!accessing!private! !
newMenuText!accessing!private! !
perform!operations!public! !
printOn:!development!printing!public! !
receiver!accessing!public! !
receiver:!accessing!public! !
source!accessing!public! !
source:!accessing!private! !
text!accessing!public! !
text:!accessing!public! !
validationResult!accessing!public! !
validationResult:!accessing!public! !
!

!UI.CommandQuery class methodsFor!

commandDescription: item source: aView
	"Answers an instance of the receiver for the <commandDescription>, command,
	generated by aView"

	^(super new initialize) 
		commandDescription: item source: aView!

new
	"Answers an instance of the receiver on a nil message"

	^self commandDescription: CommandDescription new source: nil! !

!UI.CommandQuery class categoriesForMethods!
commandDescription:source:!instance creation!public! !
new!instance creation!public! !
!

