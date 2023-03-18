"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Graphics.ImageInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.ImageInitializer guid: (Core.GUID fromString: '{37c30377-62f9-4396-a09b-b3c5a48ebfe3}')!
Graphics.ImageInitializer isNonInstantiable: true!
Graphics.ImageInitializer comment: ''!
!Graphics.ImageInitializer methodsFor!

createImage: anImage
	^self createImage: anImage extent: (self creationExtentFor: anImage)!

createImage: anImage extent: aPoint
	^self subclassResponsibility!

creationExtentFor: anImage
	^self extent ifNil: [anImage class defaultCreationExtent]!

extent
	"Answer the specified extent for images to be loaded/created by the receiver. If no extent is specified (e.g. in order to use some default), answer nil."

	^nil!

fileLocator
	^nil!

flag: anInteger set: aBoolean
	"Ignored"!

flags
	^LR_COLOR!

identifier
	^nil!

image: anImage valueWithHandle: aMonadicValuable extent: aPoint
	"Private - Evaluate the <monadicValuable>, operation, with a handle for the receiver's image at the best possible rendering for the requested extent, although the image passed to the block may not be of that extent."

	^(self createImage: anImage extent: aPoint)
		ifNil: [anImage class default valueWithHandle: aMonadicValuable extent: aPoint]
		ifNotNil: [:handle | [aMonadicValuable value: handle] ensure: [anImage class freeHandle: handle]]!

isLoadMap3dColors
	^self flags allMask: LR_LOADMAP3DCOLORS!

isLoadMap3dColors: aBoolean
	self flag: LR_LOADMAP3DCOLORS set: aBoolean!

isLoadShared
	"Answer true if the receiver requests that Windows load the image from its shared image cache."

	^self flags allMask: LR_SHARED!

isLoadShared: aBoolean
	"Set whether the receiver should request that Windows load the image from its shared image cache."

	self flag: LR_SHARED set: aBoolean!

isLoadTransparent
	^self flags allMask: LR_LOADTRANSPARENT!

isLoadTransparent: aBoolean
	self flag: LR_LOADTRANSPARENT set: aBoolean!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the <Image> it describes exactly as it was across Smalltalk image save/restore. This is generally true."

	^true!

isSelfEvaluatingImage: anImage
	"Private - Answer whether the `Image` argument is self-evaluating when initialized by the receiver."

	^anImage isPersistent!

printImage: anImage on: aWriteStream
	"Private - Print a representation of the <Image> initialized by the receiver onto the <puttableStream> argument in the form a developer might want to see."

	anImage basicPrintOn: aWriteStream! !
!Graphics.ImageInitializer categoriesForMethods!
createImage:!public!realizing/unrealizing! !
createImage:extent:!private!realizing/unrealizing! !
creationExtentFor:!private! !
extent!accessing!public! !
fileLocator!accessing!public! !
flag:set:!accessing!private! !
flags!accessing!private! !
identifier!accessing!public! !
image:valueWithHandle:extent:!private!realizing/unrealizing! !
isLoadMap3dColors!public!testing! !
isLoadMap3dColors:!accessing!public! !
isLoadShared!public!testing! !
isLoadShared:!accessing!public! !
isLoadTransparent!public!testing! !
isLoadTransparent:!accessing!public! !
isPersistent!public!testing! !
isSelfEvaluatingImage:!enquiries!private! !
printImage:on:!printing!private! !
!

!Graphics.ImageInitializer class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Image icon! !
!Graphics.ImageInitializer class categoriesForMethods!
icon!constants!public! !
!

