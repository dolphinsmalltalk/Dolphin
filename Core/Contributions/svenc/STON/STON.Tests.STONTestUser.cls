﻿"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'STON.Tests.STONTestUser'
	instanceVariableNames: 'username password enabled'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

STON.Tests.STONTestUser guid: (Core.GUID fromString: '{dc73b82c-2449-48f5-82a0-c000b743f362}')!

STON.Tests.STONTestUser comment: 'STONTestUser is used to support unit tests.

Instance Variables
	enabled:		<Boolean>
	password:	<String>
	username:	<String>
'!

!STON.Tests.STONTestUser categoriesForClass!STON-Tests-Base! !

!STON.Tests.STONTestUser methodsFor!

= anObject
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ username = anObject username and: [ password = anObject password and: [ enabled = anObject enabled ] ]!

enabled
	^ enabled!

enabled: anObject
	enabled := anObject!

hash
	"Answer an integer value that is related to the identity of the receiver."

	^ username hash bitXor: (password hash bitXor: enabled hash)!

initialize 
	super initialize.
	enabled := true!

password
	^ password!

password: anObject
	password := anObject!

username
	^ username!

username: anObject
	username := anObject! !

!STON.Tests.STONTestUser categoriesForMethods!
=!comparing!public! !
enabled!accessing!public! !
enabled:!accessing!public! !
hash!comparing!public! !
initialize!initialization!public! !
password!accessing!public! !
password:!accessing!public! !
username!accessing!public! !
username:!accessing!public! !
!

!STON.Tests.STONTestUser class methodsFor!

dummy
	"self dummy"

	| username password |
	username := String streamContents: 
					[:stream |
					stream
						<< 'user';
						print: 999 atRandom;
						<< '@company';
						print: 99 atRandom;
						<< '.com'].
	password := String streamContents: 
					[:stream |
					stream
						<< 'secret';
						print: 999 atRandom].
	^self new
		username: username;
		password: password;
		yourself!

new
	^super new initialize!

stonName
	^ #TestUser! !

!STON.Tests.STONTestUser class categoriesForMethods!
dummy!instance creation!public! !
new!public! !
stonName!public!ston/core! !
!

