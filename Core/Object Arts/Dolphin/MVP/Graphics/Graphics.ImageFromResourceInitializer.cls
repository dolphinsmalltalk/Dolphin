"Filed out from Dolphin Smalltalk"!

Graphics.ImageInitializer
	subclass: #'Graphics.ImageFromResourceInitializer'
	instanceVariableNames: 'identifier module flags extent'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.ImageFromResourceInitializer guid: (Core.GUID fromString: '{b0d7fbd0-9ebb-4121-b7d6-bec55f0f6525}')!
Graphics.ImageFromResourceInitializer comment: ''!
!Graphics.ImageFromResourceInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: 
			[self species == anObject species
				and: [identifier = anObject identifier and: [module = anObject module]]]!

createImage: anImage extent: aPoint
	^(anImage
		loadResource: identifier
		fromModule: module
		extent: aPoint
		flags: flags)
			ifNil: 
				[(self tryLoadFromFile: anImage extent: aPoint)
					ifNil: 
						[anImage
							loadResource: identifier
							fromModule: SessionManager.Current defaultResourceLibrary
							extent: aPoint
							flags: flags]]!

extent
	^extent!

extent: aPoint
	extent := aPoint!

flag: anInteger set: aBoolean
	flags := flags mask: anInteger set: aBoolean!

flags
	^flags!

flags: anInteger
	flags := anInteger!

hash
	"Answer the <integer> hash value for the receiver."

	^(identifier hash + module hash) hashMultiply!

identifier
	^identifier!

identifier: anIntegerOrString
	identifier := anIntegerOrString!

module
	^module!

module: anObject
	module := anObject!

printImage: anImage on: aWriteStream
	"Private - Print a representation of the <Image> initialized by the receiver onto the <puttableStream> argument in the form a developer might want to see."

	aWriteStream
		print: anImage class;
		nextPutAll: ' fromId: ';
		print: identifier.
	module = SessionManager.Current defaultResourceLibrary
		ifFalse: 
			[aWriteStream
				nextPutAll: ' in: ';
				print: module]!

tryLoadFromFile: anImage extent: aPoint
	^nil! !
!Graphics.ImageFromResourceInitializer categoriesForMethods!
=!comparing!public! !
createImage:extent:!private!realizing/unrealizing! !
extent!accessing!public! !
extent:!accessing!public! !
flag:set:!constants!private! !
flags!accessing!private! !
flags:!initializing!private! !
hash!comparing!public! !
identifier!accessing!public! !
identifier:!initializing!private! !
module!accessing!public! !
module:!initializing!private! !
printImage:on:!printing!private! !
tryLoadFromFile:extent:!private!realizing/unrealizing! !
!

!Graphics.ImageFromResourceInitializer class methodsFor!

identifier: identifierObject module: moduleObject flags: anInteger
	<primitive: 157>
	^self new
		identifier: identifierObject;
		module: moduleObject;
		flags: anInteger;
		yourself!

identifier: identifierObject module: moduleObject flags: anInteger extent: aPoint
	<primitive: 157>
	^self new
		identifier: identifierObject;
		module: moduleObject;
		flags: anInteger;
		extent: aPoint;
		yourself! !
!Graphics.ImageFromResourceInitializer class categoriesForMethods!
identifier:module:flags:!public! !
identifier:module:flags:extent:!instance creation!public! !
!

