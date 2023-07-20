"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.CommandDescription'
	instanceVariableNames: 'command description acceleratorKey flags image'
	classVariableNames: 'CommandDescriptionRegistry CurrentId'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'DefaultMask' -> 16r1. 'ModalMask' -> 16r2. 'NotAbortableMask' -> 16r4 }!
UI.CommandDescription guid: (Core.GUID fromString: '{87b4c469-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.CommandDescription comment: 'A CommandDescription acts as the fundamental source for all MVP user interface commands. An instance of this class holds the command itself, a textual description of the command''s function and, optionally, an accelerator key that may trigger the command action when used within a menu. The command can be a <Message>, <Symbol> or, indeed, any object that responds to the <commandMessage> protocol. For most commands, symbols are prevalent but messages can sometimes be more convenient, especially if the command is to carry parameters, such as in dynamically constructed menus (e.g. the browser history list).

The MVP command framework operates as follows. There exist a number of potential command sources which each carry a CommandDescription that dictates the command that they wish to transmit. Possible command sources are Menus (drop-down and context), PushButtons and ToolbarButtons. When each source is actioned, the framework determines an appropriate view that can be considered as the origin for the command. Usually this is the view with focus but, in the case of context menus, it is the view beneath the context mouse click. 

The next stage is for the framework to determine a suitable target that will perform the command. It does this by creating a CommandQuery object containing the CommandDescription and then routing this via a number of potential command targets to determine if any of these are willing to accept responsibility for executing it. The actual route of command targets is determined by the active CommandPolicy for the originating view. The default CommandPolicy routes the CommandQuery''s in the sequence (view-presenter-model) and so on up the originating view''s parent chain. Normally this default policy is sufficient for most needs, but if necessary the policy can be specialized for a particular View class, or one can interfere with the routing of individual commands by explicitly setting the receiver (eventual target). At each stage in the routing, a potential target object is sent a #queryCommand: message with the CommandQuery as a parameter. This method is responsible for deciding whether the command should be considered as enabled at this target. It does so by setting CommandQuery>>enabled: to true where applicable. When the framework sees that a CommandQuery has been enabled it halts the routing process and gets around to performing command on the last target visited (or on the explicitly set target).

In order to perform the command, a Command object is created from the original CommandDescription and the designated receiver (target) object. The Command object is a valuable which, when performed, executes the command''s message against the receiver. When the command is actually being performed by the appropriate target method, it is possible for this to install some actions that can indicate how the operation may be undone or re-done. If these actions are set (and the top level Shell presenter to which the target belongs has been enabled to retain command history) then the framework will add the Command to its history once it has being performed. This allows an undo/redo facility to be added in a straightforward fashion to almost any application.

Another important aspect of the command framework is the ability to determine whether a particular CommandDescription can be performed without having to actually go-ahead and execute it. This is necessary in order to appropriately enable and disable the various command sources in the user interface. For example, when a menu is pulled down it must correctly display those commands which are enabled and disabled according to the current state of the application. The framework does this by using the same routing scheme that it uses when a command is to be executed. As a menu is pulled down or popped up, all of the commands within it are routed to determine whether their corresponding menu items should be enabled or not. At the same time onecan also indicate whether a particular command should appear checked (#checked:) or not, and specify whether it is considered the default command for its enclosing menu (#isDefault:).

As you can see, it is fairly straightforward for the command framework to determine when to query the commands that originate in menu items since the menus appear at defined times as requested by the user. However, for the various button command sources, the situation is somewhat more complicated since these are continuously visible and a is no obvious moment to perform the query routing. It is therefore necessary for the framework to route a CommandQuery at idle time in order to enable/disable and check/uncheck such items. This process could easily consume far too many processor cycles if not managed carefully. Consequently, the routing operation is only carried out if the user interface has been previously marked as being invalid. This is done by an application sending #invalidateUserInterface to any view or presenter whenever it considers that it has done something to change the application''s state. It is also done automatically by the framework following each command execution, since commands are very often responsible for changing such state.

The end result of a user interface component being marked by #invalidateUserInterface is that it will eventually receive a #validateUserInterface message; usually when the system next enters idle. The various button command sources use this message as a prompt to route a CommandQuery as described above. However, it is acceptable, and may sometimes be useful, to override #validateUserInterface to perform your own explicit interface validation.

The overall aim of the MVP command framework is to provide a flexible routing system to direct commands from their various sources to appropriate target objects that can execute them. The framework effectively implements the Chain Of Responsibility pattern, with the chain being determined by the active CommandPolicy.

Instance Variables:
	command		<commandMessage> indicating the command to be performed, e.g. a <Symbol> or <Message>
	description		<readableString> that describes the command to the user.
	acceleratorKey	<integer> virtual key code for the accelerator key that will trigger this command.
	unused		Reserved for future use.
	
'!
!UI.CommandDescription categoriesForClass!MVP-Commands! !
!UI.CommandDescription methodsFor!

acceleratorKey
	"Answers the <integer> accelerator key code for the receiver, or zero if there is none."

	^acceleratorKey!

acceleratorKey: code
	"Set the receiver's accelerator key code to the <integer> argument, code."

	acceleratorKey := code!

acceleratorKeyDisplayString
	"Answers the <readableString> accelerator key string for the receiver in the language of the default Keyboard, or an empty <String> if there is none."

	^AcceleratorTable keyStringFromCode: self acceleratorKey!

acceleratorKeyString
	"Answers the <readableString> accelerator key string for the receiver in the language of the invariant Keyboard, or an empty <String> if there is none."

	^AcceleratorTable keyStringFromCode: self acceleratorKey keyboard: Keyboard invariant!

acceleratorKeyString: keys
	"Sets the accelerator key to the key code generated from parsing the <readableString> accelerator key description, keys. The string is assumed to be in English (actually the UK English form used for Dolphin's invariant keyboard)."

	self acceleratorKey: (AcceleratorTable keyCodeFromInvariantString: keys)!

canPerformAgainst: destination
	"Answer whether the command described by the receiver can be 
	executed against the hypothetical <commandTarget>, destination."

	| selector |
	^(selector := self commandSymbol) isNil or: [destination respondsTo: selector]
!

command
	"Answers the <commandMessage> forwarded to a command target when
	the receiver's command is performed."

	^command!

command: commandMessage
	"Sets the <commandMessage> held by the receiver to the argument.
	<Symbol>, <Message>, and <MessageSend> are examples of classes which implement 
	the <commandMessage> protocol."

	command := commandMessage!

commandString
	"Answer a String representation of the receiver's command."

	^self command printString!

commandSymbol
	"Answer a <Symbol> representing the receiver's command."

	^self command ifNotNil: [:cmd | cmd asSymbol]!

description
	"Answers a short <readableString> description of the receiver's command. Uses the string
	representation of the command itself if no explicit description has been provided."

	^description ifNil: [self commandSymbol ifNotNil: [:symbol | symbol asPhrase]]!

description: aString
	"Sets the long description of the receiver's command to the <readableString>
	argument."

	description := (aString isNil or: [aString isEmpty]) ifFalse: [aString]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self description displayOn: aPuttableStream!

hasAcceleratorKey
	"Answer whether the receiver defines an accelerator key."

	^acceleratorKey ~= 0!

id
	"Answer a unique <integer> id for the receiver's command obtained from the command registry."

	^self class idFor: self!

image
	"Answers the <Image> associated with the receiver or nil if there is none"

	^image value!

image: anImageOrNil
	"Sets  the icon associated with the receiver to anImageOrNil"

	image := anImageOrNil!

initialize
	"Private - Initialize the receiver."

	acceleratorKey := 0.
	flags := 0!

isAbortable
	"Answer whether the receiver describes a command that may safely throw OperationAborted to terminate its operation without side effects. Some command hosts may choose to use this information to catch and suppress OperationAborted exceptions when executing the command. If this message answers false, then the command host should treat OperationAborted like any other error. By default commands are abortable."

	^flags noMask: NotAbortableMask!

isAbortable: aBoolean
	flags := flags mask: NotAbortableMask set: aBoolean not!

isModalCommand
	"Answer whether the receiver describes a command that should be performed modally to 
	its initiating shell (i.e. the shell will be disabled for the duration of execution of the
	command)."

	^flags allMask: ModalMask!

isModalCommand: aBoolean
	"Set whether the command described by the receiver should be be performed modally to 
	its initiating shell (i.e. the shell will be disabled for the duration of execution of the
	command). This is particularly useful for commands that pop-dialogs to request 
	additional inputs that they subsequently use to complete the command."

	flags := flags mask: ModalMask set: aBoolean!

menuText
	"Private - Answer the menu text (i.e. the text that appears in a menu) for the receiver."

	| menuText |
	menuText := self description.
	self hasAcceleratorKey
		ifTrue: [menuText := menuText , String tab , self acceleratorKeyDisplayString].
	^menuText!

messages
	"Answer a <collection> of the messages sent by the receiver."

	^self commandSymbol ifNil: [#()] ifNotNil: [:cmd | {cmd}]!

performAgainst: anObject
	"Private - Perform the command described by the receiver against the argument
	by forwarding it the receiver's <commandMessage>."

	^self command forwardTo: anObject!

printOn: aStream
	"Append a representation of the receiver to the <puttableStream> target that an 
	developer would want to see."

	aStream
		basicPrint: self;
		nextPut: $(;
		display: self;
		nextPut: $)!

queryCommand: query
	"Private - Enters status and target details about the receiver's own command into the 
	<CommandQuery>, query.
	Implementation Note: If the receiver represents a fully closed command, then we can
	skip all further routing (the CommandDescription itself is queried first by default),
	but we leave this decision to the command object itself if it appears capable."

	(self command class conformsToProtocol: #commandTarget)
		ifTrue: [^self command queryCommand: query].
	^false!

registerAcceleratorKeyIn: accelerators 
	"Private - Register the receiver's accelerator key, if any, in the <AcceleratorTable>,
	accelerators."

	acceleratorKey == 0 ifFalse: [accelerators addCommand: self]!

toolTipText
	"Answer a <readableString> suitable for displaying in a Tool-tip control."

	^self description! !
!UI.CommandDescription categoriesForMethods!
acceleratorKey!accessing!public! !
acceleratorKey:!accessing!public! !
acceleratorKeyDisplayString!accessing!public! !
acceleratorKeyString!accessing!public! !
acceleratorKeyString:!accessing!public! !
canPerformAgainst:!commands!public!testing! !
command!accessing!public! !
command:!accessing!public! !
commandString!accessing!public! !
commandSymbol!accessing!public! !
description!accessing!public! !
description:!accessing!public! !
displayOn:!printing!public! !
hasAcceleratorKey!public!testing! !
id!accessing!public! !
image!accessing!public! !
image:!accessing!public! !
initialize!initializing!private! !
isAbortable!public!testing! !
isAbortable:!accessing!public! !
isModalCommand!public!testing! !
isModalCommand:!public!testing! !
menuText!accessing!private! !
messages!enquiries!public! !
performAgainst:!operations!private! !
printOn:!development!printing!public! !
queryCommand:!commands!private! !
registerAcceleratorKeyIn:!operations!private! !
toolTipText!accessing!public! !
!

UI.CommandDescription methodProtocol: #commandTarget attributes: #(#readOnly) selectors: #(#queryCommand:)!
UI.CommandDescription methodProtocol: #messageSender attributes: #(#readOnly) selectors: #(#messages)!

!UI.CommandDescription class methodsFor!

command: commandMessage
	"Answer a new instance of the receiver for the specified <commandMessage>.
	N.B. The command is an identity instance variable."
	
	^self basicNew
		initialize;
		command: commandMessage!

command: commandMessage description: aString
	"Answer a new instance of the receiver with the specified <commandMessage>
	(required) and long description."
	
	^(self command: commandMessage)
		description: aString!

command: commandMessage description: aString image: anImage
	"Answer a new instance of the receiver with the specified <commandMessage>
	(required) and long description and image"

	^(self command: commandMessage description: aString) image: anImage!

idFor: aCommandDescription
	"Private - Answer a unique id for aCommandDescription, registering the command in our
	CommandDescriptionRegistry if it has not been added before."

	^CommandDescriptionRegistry at: aCommandDescription ifAbsentPutClean: [CommandDescription nextId]!

initialize
	"Private - Initialize the receiver's class variables.
		CommandDescription initialize
	"

	CommandDescriptionRegistry isNil
		ifTrue: 
			[CommandDescriptionRegistry := WeakIdentityDictionary newWithWeakKeys: 150.
			CurrentId := self startingId]
		ifFalse: 
			[CommandDescriptionRegistry
				haveStrongValues;
				haveWeakKeys]!

maximumId
	"Private - Answer the maximum id that we have available."

	^32767!

new
	"Instances of the receiver must have a command selector specified."

	^self command: #noCommand!

nextId
	"Private - Answer the next <SmallInteger> id to use."

	| wrapped max |
	wrapped := false.
	max := self maximumId.
	[ 	(CurrentId := CurrentId + 1) > max ifTrue: [
			wrapped ifTrue: [^self error: 'There are no unused command ids available.'].
			wrapped := true.
			CurrentId := self startingId].
		CommandDescriptionRegistry identityIncludes: CurrentId] whileTrue.
	^CurrentId!

startingId
	"Private - Answer the first id which we can safely use."

	^4000!

stbConvertFrom: anSTBClassFormat
	"Convert from earlier CommandDescription versions."

	| ver |
	ver := anSTBClassFormat version.
	ver <= 1 ifTrue: [^[:data | (self stbConvertFromVersion1: data) becomeA: self]].
	ver <= 3 ifTrue: [^[:data | (self stbConvertFromVersion3: data) becomeA: self]].
	^super stbConvertFrom: anSTBClassFormat!

stbConvertFromVersion1: anArray
	"Convert from earlier CommandDescription versions. In version 2, the shortDescription became the only description. The formerly unused 'bitmap' instance variable went through an unversioned transition to become the flags."

	| accelKey |
	accelKey := anArray at: 4.
	^self stbConvertFromVersion3: {
				anArray at: 1.
				anArray at: 3.
				accelKey isString
					ifTrue: [AcceleratorTable keyCodeFromInvariantString: accelKey]
					ifFalse: [accelKey].
				nil
			}!

stbConvertFromVersion3: anArray
	"Convert from earlier CommandDescription versions. Version 4 added the image inst var. Here we also patch up the flags, as not really sure what happened in V3."

	| data flags |
	data := Array new: self instSize.	"Last in chain"
	data
		replaceFrom: 1
		to: 3
		with: anArray
		startingAt: 1.
	flags := anArray at: 4.
	data at: 4 put: (flags isInteger ifTrue: [flags] ifFalse: [0]).
	"image defaults to nil, so copy any remaining inst vars after that"
	data
		replaceFrom: 6
		to: data size
		with: anArray
		startingAt: 5.
	^data!

stbVersion
	"Answer the current STB filer version for instances of the receiver
		Version 0: command description shortDescription acceleratorKey (integer) bitmap (not used)
		Version 1: command description shortDescription acceleratorKey (string) bitmap (not used)
		Version 2 (D2): command description acceleratorKey bitmap (not used)
		Version 2 (D3) command description acceleratorKey unused
		Version 2 (D4): command description acceleratorKey flags
		Version 3 ?:
		Version 4 (D5): command description acceleratorKey flags image
	"

	^4!

withId: anInteger ifAbsent: absentBlock
	"Answer a CommandDescription associated with anInteger id or if it is not in use
	then the value of absentBlock."

	^CommandDescriptionRegistry keyAtValue: anInteger ifAbsent: absentBlock! !
!UI.CommandDescription class categoriesForMethods!
command:!instance creation!public! !
command:description:!instance creation!public! !
command:description:image:!instance creation!public! !
idFor:!command registry!private! !
initialize!development!initializing!private! !
maximumId!command registry!private! !
new!instance creation!public! !
nextId!command registry!private! !
startingId!command registry!private! !
stbConvertFrom:!binary filing!public! !
stbConvertFromVersion1:!binary filing!public! !
stbConvertFromVersion3:!binary filing!public! !
stbVersion!binary filing!public! !
withId:ifAbsent:!command registry!public! !
!

