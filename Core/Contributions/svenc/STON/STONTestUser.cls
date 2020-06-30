"Filed out from Dolphin Smalltalk 7"!

Object subclass: #STONTestUser
	instanceVariableNames: 'username password enabled'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STONTestUser guid: (GUID fromString: '{dc73b82c-2449-48f5-82a0-c000b743f362}')!
STONTestUser comment: 'STONTestUser is used to support unit tests.

Instance Variables
	enabled:		<Boolean>
	password:	<String>
	username:	<String>
'!
!STONTestUser categoriesForClass!STON-Tests-Base! !
!STONTestUser methodsFor!

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
!STONTestUser categoriesFor: #=!comparing!public! !
!STONTestUser categoriesFor: #enabled!accessing!public! !
!STONTestUser categoriesFor: #enabled:!accessing!public! !
!STONTestUser categoriesFor: #hash!comparing!public! !
!STONTestUser categoriesFor: #initialize!initialize/release!public! !
!STONTestUser categoriesFor: #password!accessing!public! !
!STONTestUser categoriesFor: #password:!accessing!public! !
!STONTestUser categoriesFor: #username!accessing!public! !
!STONTestUser categoriesFor: #username:!accessing!public! !

!STONTestUser class methodsFor!

dummy
	"self dummy"
	
	| username password |
	username := String streamContents: [ :stream |
		stream << 'user'; print: 999 atRandom; << '@company'; print: 99 atRandom; << '.com' ].
	password := String streamContents: [ :stream |
		stream << 'secret'; print: 999 atRandom ].
	^ self new
		username: username;
		password: password;
		yourself!

new
	^super new initialize!

stonName
	^ #TestUser! !
!STONTestUser class categoriesFor: #dummy!instance creation!public! !
!STONTestUser class categoriesFor: #new!public! !
!STONTestUser class categoriesFor: #stonName!public!ston/core! !

