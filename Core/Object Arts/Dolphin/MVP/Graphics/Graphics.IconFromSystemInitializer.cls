"Filed out from Dolphin Smalltalk"!

Graphics.ImageInitializer
	subclass: #'Graphics.IconFromSystemInitializer'
	instanceVariableNames: 'extent identifier'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.IconFromSystemInitializer guid: (Core.GUID fromString: '{b837eb81-e528-4a29-8c00-af531894b3ab}')!

Graphics.IconFromSystemInitializer comment: ''!

!Graphics.IconFromSystemInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent. Two Images loaded by identifier are equal if they are of the same species, and have the same id and are from the same resource modules."

	^self == anObject or: [self species == anObject species and: [identifier = anObject identifier]]!

createImage: anImage extent: aPoint
	"Private - Attempts to load the icon resource specified by the receiver. Answers the loaded handle or nil if the load failed. "

	^anImage loadFromSystem: identifier extent: aPoint!

extent
	^extent!

extent: aPoint
	extent := aPoint!

flags
	^##(LR_COLOR bitOr: LR_SHARED)!

hash
	"Answer the <integer> hash value for the receiver."

	^identifier hash!

identifier
	^identifier!

identifier: anInteger 
	identifier := anInteger!

isSelfEvaluatingImage: anImage
	"Private - Answer whether the `Image` argument is self-evaluating when initialized by the receiver."

	^true!

printImage: anIcon on: aWriteStream
	"Private - Print a representation of the <Image> initialized by the receiver onto the <puttableStream> argument in the form a developer might want to see."

	aWriteStream
		print: anIcon class;
		space.
	(anIcon class systemNames lookup: self identifier)
		ifNil: 
			[aWriteStream
				display: #fromSystemId:;
				space;
				print: identifier]
		ifNotNil: [:name | aWriteStream nextPutAll: name]! !

!Graphics.IconFromSystemInitializer categoriesForMethods!
=!comparing!public! !
createImage:extent:!private!realizing/unrealizing! !
extent!accessing!public! !
extent:!accessing!public! !
flags!accessing!private! !
hash!comparing!public! !
identifier!accessing!public! !
identifier:!initializing!private! !
isSelfEvaluatingImage:!enquiries!private! !
printImage:on:!printing!private! !
!

!Graphics.IconFromSystemInitializer class methodsFor!

extent: aPoint identifier: anInteger
	<primitive: 157>
	^self new
		extent: aPoint;
		identifier: anInteger;
		yourself!

identifier: anInteger
	^self new
		identifier: anInteger;
		yourself! !

!Graphics.IconFromSystemInitializer class categoriesForMethods!
extent:identifier:!instance creation!public! !
identifier:!instance creation!public! !
!

