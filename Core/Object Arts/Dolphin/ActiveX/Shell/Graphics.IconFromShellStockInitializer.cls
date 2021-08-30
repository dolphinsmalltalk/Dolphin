"Filed out from Dolphin Smalltalk"!

Graphics.ImageInitializer subclass: #'Graphics.IconFromShellStockInitializer'
	instanceVariableNames: 'identifier extent'
	classVariableNames: ''
	imports: #(#{OS.ShellConstants private} #{OS.SHSTOCKICONINFO private})
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.IconFromShellStockInitializer guid: (Core.GUID fromString: '{3ef7de96-b077-44ab-b925-2b403b972b56}')!
Graphics.IconFromShellStockInitializer comment: ''!
!Graphics.IconFromShellStockInitializer categoriesForClass!Unclassified! !
!Graphics.IconFromShellStockInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent. The extent is ignored from the point of view of comparison the initializer is capable of creating an icon at any desired extent."

	^self == anObject or: [self species == anObject species and: [identifier = anObject identifier]]!

createImage: anImage extent: aPoint
	^(aPoint isZero or: [aPoint = Icon.LargeExtent])
		ifTrue: [(self getStockIconInfo: ##(SHGSI_ICON | SHGSI_LARGEICON)) hIcon]
		ifFalse: 
			[aPoint = Icon.SmallExtent
				ifTrue: [(self getStockIconInfo: ##(SHGSI_ICON | SHGSI_SMALLICON)) hIcon]
				ifFalse: 
					[| info |
					info := self getStockIconInfo: SHGSI_ICONLOCATION.
					anImage
						loadResource: info iIcon abs
						fromModule: (ResourceLibrary open: info szPath)
						extent: aPoint
						flags: ##(LR_COLOR | LR_SHARED)]]!

extent
	^extent!

extent: aPoint
	extent := aPoint!

flags
	^##(LR_COLOR | LR_SHARED)!

getStockIconInfo: anInteger
	| info |
	info := SHSTOCKICONINFO newBuffer.
	Shell32
		shGetStockIconInfo: identifier
		uFlags: anInteger
		psii: info.
	^info!

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
		nextPutAll: ' shellStock: ';
		display: ((SHSTOCKICONID keyAtValue: identifier ifAbsent: [])
					ifNil: [identifier]
					ifNotNil: [:siid | BindingReference path: {#OS. #SHSTOCKICONID. siid}]).
	extent
		ifNotNil: 
			[aWriteStream
				nextPutAll: ' extent: ';
				print: extent]! !
!Graphics.IconFromShellStockInitializer categoriesForMethods!
=!comparing!public! !
createImage:extent:!private!realizing/unrealizing! !
extent!accessing!public! !
extent:!accessing!public! !
flags!accessing!private! !
getStockIconInfo:!helpers!private! !
hash!comparing!public! !
identifier!accessing!public! !
identifier:!initializing!private! !
isSelfEvaluatingImage:!enquiries!private! !
printImage:on:!printing!private! !
!

!Graphics.IconFromShellStockInitializer class methodsFor!

identifier: anInteger extent: aPoint
	<primitive: 157>
	^self new
		identifier: anInteger;
		extent: aPoint;
		yourself! !
!Graphics.IconFromShellStockInitializer class categoriesForMethods!
identifier:extent:!instance creation!public! !
!

