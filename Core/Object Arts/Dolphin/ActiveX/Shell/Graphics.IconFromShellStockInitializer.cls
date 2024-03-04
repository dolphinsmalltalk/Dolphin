"Filed out from Dolphin Smalltalk"!

Graphics.IconFromSystemInitializer
	subclass: #'Graphics.IconFromShellStockInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ShellConstants private} #{OS.SHSTOCKICONINFO private})
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.IconFromShellStockInitializer guid: (Core.GUID fromString: '{3ef7de96-b077-44ab-b925-2b403b972b56}')!

Graphics.IconFromShellStockInitializer comment: ''!

!Graphics.IconFromShellStockInitializer methodsFor!

createImage: anImage extent: aPoint
	^(aPoint isZero or: [aPoint = SystemMetrics default largeIconExtent])
		ifTrue: [(self getStockIconInfo: ##(SHGSI_ICON | SHGSI_LARGEICON)) hIcon]
		ifFalse: 
			[aPoint = SystemMetrics default smallIconExtent
				ifTrue: [(self getStockIconInfo: ##(SHGSI_ICON | SHGSI_SMALLICON)) hIcon]
				ifFalse: 
					[| info |
					info := self getStockIconInfo: SHGSI_ICONLOCATION.
					anImage
						loadResource: info iIcon abs
						fromModule: (ResourceLibrary open: info szPath)
						extent: aPoint
						flags: ##(LR_COLOR | LR_SHARED)]]!

getStockIconInfo: anInteger
	| info |
	info := SHSTOCKICONINFO newBuffer.
	Shell32
		shGetStockIconInfo: identifier
		uFlags: anInteger
		psii: info.
	^info!

printImage: anIcon on: aWriteStream
	"Private - Print a representation of the <Image> initialized by the receiver onto the <puttableStream> argument in the form a developer might want to see."

	aWriteStream
		print: anIcon class;
		nextPutAll: ' shellStock: ';
		display: ((SHSTOCKICONID keyAtValue: identifier ifAbsent: nil)
					ifNil: [identifier]
					ifNotNil: [:siid | BindingReference path: {#OS. #SHSTOCKICONID. siid}]).
	extent
		ifNotNil: 
			[aWriteStream
				nextPutAll: ' extent: ';
				print: extent]! !

!Graphics.IconFromShellStockInitializer categoriesForMethods!
createImage:extent:!private!realizing/unrealizing! !
getStockIconInfo:!helpers!private! !
printImage:on:!printing!private! !
!

!Graphics.IconFromShellStockInitializer class methodsFor!

extent: anInteger identifier: aPoint
	<primitive: 157>
	^self new
		identifier: anInteger;
		extent: aPoint;
		yourself! !

!Graphics.IconFromShellStockInitializer class categoriesForMethods!
extent:identifier:!instance creation!public! !
!

