"Filed out from Dolphin Smalltalk"!

CommandDescription subclass: #ClosedCommandDescription
	instanceVariableNames: 'queryBlock receiver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ClosedCommandDescription guid: (GUID fromString: '{26e7b7a8-fc97-462c-8edf-c6e4467046ff}')!

ClosedCommandDescription comment: 'ClosedCommandDescription is the class of <CommandDescription>s that have a pluggable implementation of #queryCommand: such that they can be completely self contained, both describing the command to be performed, where to send it, and also managing enablement/disablement.

Instance Variables:
	queryBlock	<monadicValue> implementation of #queryCommand:. Can be nil.
	receiver		<Object> to which the command will be sent. Can be nil, in which case queryBlock determines receiver. 
	
'!

!ClosedCommandDescription categoriesForClass!MVP-Commands! !

!ClosedCommandDescription methodsFor!

queryBlock: aMonadicValuable
	queryBlock := aMonadicValuable!

queryCommand: aCommandQuery
	"Update the <CommandQuery> argument with status and target details about the 
	receiver's own command. Answer whether the command query has been handled."

	^queryBlock isNil 
		ifTrue: 
			[(self command class conformsToProtocol: #commandTarget) 
				ifTrue: [self command queryCommand: aCommandQuery]
				ifFalse: 
					["If no query block and dumb command, such as a Symbol, enable if
					the receiver was specified when this closed command was created."

					self receiver 
						ifNil: [false]
						ifNotNil: 
							[:target | 
							aCommandQuery
								isEnabled: true;
								receiver: target.
							true]]]
		ifFalse: 
			[queryBlock value: aCommandQuery.
			"If the queryBlock has not set the receiver, then default to the pre-set receiver."
			aCommandQuery receiver isNil ifTrue: [aCommandQuery receiver: self receiver].
			true]!

receiver
	^receiver!

receiver: anObject
	receiver := anObject! !

!ClosedCommandDescription categoriesForMethods!
queryBlock:!accessing!public! !
queryCommand:!commands!public! !
receiver!accessing!public! !
receiver:!accessing!public! !
!

!ClosedCommandDescription class methodsFor!

command: commandMessage description: aString queryBlock: aMonadicValuable
	"Answer a new instance of the receiver to send the specified <commandMessage>. The 
	<readableString> description, aString, is used for bubble help, etc. The <monadicValuable> 
	argument, aMonadicValuable, is evaluated with a <CommandQuery> argument to determine 
	the status of the command, and it should also set the desired receiver."

	^self command: commandMessage description: aString queryBlock: aMonadicValuable receiver: nil!

command: commandMessage description: aString queryBlock: aMonadicValuable receiver: anObject
	"Answer a new instance of the receiver pre-targeted to the receiver, anObject,
	to send the specified <commandMessage>. The <readableString> description,
	aString, is used for bubble help, etc. The <monadicValuable> argument, aMonadicValuable,
	is evaluated with a <CommandQuery> argument to determine the status of the command, and 
	can also override the pre-specified receiver if desired."

	^(super command: commandMessage description: aString)
		queryBlock: aMonadicValuable;
		receiver: anObject;
		yourself!

command: commandMessage description: aString receiver: anObject
	"Answer a new instance of the receiver pre-targeted to the receiver, anObject,
	to send the specified <commandMessage>. The <readableString> description,
	aString, is used for bubble help, etc. The resulting command description will
	always be enabled (unless the query block is subsequently modified), and will
	always be sent to anObject."

	^self command: commandMessage description: aString queryBlock: nil receiver: anObject! !

!ClosedCommandDescription class categoriesForMethods!
command:description:queryBlock:!instance creation!public! !
command:description:queryBlock:receiver:!instance creation!public! !
command:description:receiver:!instance creation!public! !
!

