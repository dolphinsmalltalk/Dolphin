"Filed out from Dolphin Smalltalk"!

UI.ToolbarButton
	subclass: #'UI.ToolbarBitmapButton'
	instanceVariableNames: 'bitmap bitmapIndex'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ToolbarBitmapButton guid: (Core.GUID fromString: '{87b4c700-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.ToolbarBitmapButton comment: '`ToolbarBitmapButton` represents a user defined button for a `Toolbar` where the image for the button is sourced from a `Bitmap`, typically containing a strip of tool images. The image within the bitmap strip to be used for the button is identified by an index within the supplied `Bitmap`.

## Instance Variables:
  `bitmap`			`Bitmap` containing one or more button images.
  `bitmapIndex`		`<integer>` index of this button''s image within the bitmap.



'!

!UI.ToolbarBitmapButton categoriesForClass!MVP-Views-Support! !

!UI.ToolbarBitmapButton methodsFor!

bitmap
	"Answer the bitmap for the receiver."

	^bitmap!

bitmap: aBitmap
	"Set aBitmap (or a shared copy of it) as the bitmap for the receiver."

	bitmap := aBitmap asSharedCopy.
	self update!

bitmap: aBitmap index: anInteger commandDescription: aCommandDescription
	"Private - Initialize the instance variables of the receiver."

	self initialize.
	bitmap := aBitmap asSharedCopy.
	bitmapIndex := anInteger.
	commandDescription := aCommandDescription!

bitmapIndex
	"Answer the index of receiver's sub-bitmap within its bitmap."

	^bitmapIndex!

bitmapIndex: anInteger
	"Set the index of receiver's sub-bitmap within its bitmap to anInteger."

	bitmapIndex := anInteger.
	self update
!

imageIndexIn: aToolbar
	"Private - Add the bitmap for the receiver to aToolbar.
	Answer the index of the bitmap within aToolbar's registered bitmaps"

	^aToolbar addBitmap: self bitmap index: self bitmapIndex
! !

!UI.ToolbarBitmapButton categoriesForMethods!
bitmap!accessing!public! !
bitmap:!accessing!public! !
bitmap:index:commandDescription:!initializing!private! !
bitmapIndex!accessing!public! !
bitmapIndex:!accessing!public! !
imageIndexIn:!operations!private! !
!

UI.ToolbarBitmapButton methodProtocol: #commandSource attributes: #(#readOnly) selectors: #(#commandDescription)!

!UI.ToolbarBitmapButton class methodsFor!

bitmap: aBitmap index: bitmapIndex commandDescription: aCommandDescription
	"Answer a new instance of the receiver containing the bitmapIndex'd subimage of aBitmap."

	^self basicNew
		bitmap: aBitmap
		index: bitmapIndex
		commandDescription: aCommandDescription!

new
	"Answer a new default ToolbarButton"

	^self dolphinImage: 35 command: #noCommand description: 'No command'! !

!UI.ToolbarBitmapButton class categoriesForMethods!
bitmap:index:commandDescription:!instance creation!public! !
new!instance creation!public! !
!

