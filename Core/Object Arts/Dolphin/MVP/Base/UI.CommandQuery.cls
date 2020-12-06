"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'UI.CommandQuery'
	instanceVariableNames: 'commandDescription receiver source text flags image'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'CheckedMask' -> 16r2.
		'DefaultMask' -> 16r4.
		'EnabledMask' -> 16r1
	}!
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

	self isChecked: true!

beDisabled
	"Set the receiver into the disabled state"

	self isEnabled: false!

beEnabled
	"Set the receiver into the enabled state"

	self isEnabled: true!

beUnchecked
	"Set the receiver into the not checked state"

	self isChecked: false!

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

image
	^image!

image: anObject
	image := anObject!

initialize
	"Private - Initialize the receiver. Command queries start off pessimistically in disabled
	unchecked state."

	super initialize.
	flags := 0
!

isChecked
	"Answer true if the receiver is in the checked state"

	^flags allMask: CheckedMask!

isChecked: aBoolean
	"Set the whether or not the command associated with the receiver is 'checked'
	(toggled on). This will cause associated menu items to be displayed with a 
	tick mark (or a blob if using radio button style)."

	flags := flags mask: CheckedMask set: aBoolean
!

isDefault
	"Answer whether the receiver is expecting to be the default item on its parent menu.
	Note: Obviously their can be only one default item per menu, so if more than one item
	claims default status only one will triumph. Under the current implementation this will
	be the last occurring default item, but this behaviour should not be relied upon."

	^flags anyMask: DefaultMask!

isDefault: aBoolean
	"Set whether the receiver is expected to be the default command for the host menu."

	flags := flags mask: DefaultMask set: aBoolean!

isEnabled
	"Answer true if the receiver is in the enabled state"

	^flags allMask: EnabledMask!

isEnabled: aBoolean
	"Set the enable state of the receiver to aBoolean"

	flags := flags mask: EnabledMask set: aBoolean!

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

	text := aString! !
!UI.CommandQuery categoriesFor: #applicationShell!accessing!public! !
!UI.CommandQuery categoriesFor: #beChecked!accessing!public! !
!UI.CommandQuery categoriesFor: #beDisabled!accessing!public! !
!UI.CommandQuery categoriesFor: #beEnabled!accessing!public! !
!UI.CommandQuery categoriesFor: #beUnchecked!accessing!public! !
!UI.CommandQuery categoriesFor: #canPerform!public!testing! !
!UI.CommandQuery categoriesFor: #canPerformAgainst:!accessing!public! !
!UI.CommandQuery categoriesFor: #command!accessing!public! !
!UI.CommandQuery categoriesFor: #commandDescription!accessing!public! !
!UI.CommandQuery categoriesFor: #commandDescription:source:!initializing!private! !
!UI.CommandQuery categoriesFor: #commandSymbol!accessing!public! !
!UI.CommandQuery categoriesFor: #description!accessing!public! !
!UI.CommandQuery categoriesFor: #image!accessing!public! !
!UI.CommandQuery categoriesFor: #image:!accessing!public! !
!UI.CommandQuery categoriesFor: #initialize!initializing!private! !
!UI.CommandQuery categoriesFor: #isChecked!public!testing! !
!UI.CommandQuery categoriesFor: #isChecked:!accessing!public! !
!UI.CommandQuery categoriesFor: #isDefault!accessing!public! !
!UI.CommandQuery categoriesFor: #isDefault:!accessing!public! !
!UI.CommandQuery categoriesFor: #isEnabled!public!testing! !
!UI.CommandQuery categoriesFor: #isEnabled:!accessing!public! !
!UI.CommandQuery categoriesFor: #perform!operations!public! !
!UI.CommandQuery categoriesFor: #printOn:!development!printing!public! !
!UI.CommandQuery categoriesFor: #receiver!accessing!public! !
!UI.CommandQuery categoriesFor: #receiver:!accessing!public! !
!UI.CommandQuery categoriesFor: #source!accessing!public! !
!UI.CommandQuery categoriesFor: #source:!accessing!private! !
!UI.CommandQuery categoriesFor: #text!accessing!public! !
!UI.CommandQuery categoriesFor: #text:!accessing!public! !

!UI.CommandQuery class methodsFor!

commandDescription: item source: aView
	"Answers an instance of the receiver for the <commandDescription>, command,
	generated by aView"

	^(super new initialize) 
		commandDescription: item source: aView!

new
	"Answers an instance of the receiver on a nil message"

	^self commandDescription: CommandDescription new source: nil! !
!UI.CommandQuery class categoriesFor: #commandDescription:source:!instance creation!public! !
!UI.CommandQuery class categoriesFor: #new!instance creation!public! !

