"Filed out from Dolphin Smalltalk"!

Graphics.ColorRef
	subclass: #'Graphics.ColorDefault'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.ColorDefault guid: (Core.GUID fromString: '{dc49f7c0-bb6c-444b-9e28-9342285c1880}')!
Graphics.ColorDefault comment: '`ColorDefault` is the special `ColorRef` which represents the default colour for something, whatever that might be. Typically it is used with `ControlView`s to specify that the control should draw itself usings its default background or foreground colour.

`ColorDefault`s singleton instance is accessed using the expression `Color default`.

The superclass `code` instance variable has the value `Win32Constants.CLR_DEFAULT`.

'!
!Graphics.ColorDefault methodsFor!

= aColor
	"Answer whether the receiver and argument are equivalent (i.e. represent the same colour)."

	^aColor species == self species!

alpha
	"Answer the receiver's alpha component as an <integer> in the range [0,255], with 0 being completely transparent and 255 completely opaque."

	^self errorNotARealColor!

brush
	"Answer a Brush configured for solid painting of the receiver's color."

	^self errorNotARealColor!

hash
	"Use a fixed value as all instances are equivalent."

	^16r149BC447!

isDefault
	"Answer whether the receiver is the special <Color> representing the default colour. Which
	colour this represents in practice will depend on context."

	^true!

name
	"Answer the symbolic name of the colour, or nil if it does not have a name (or known name)."

	^#default!

normalizedAlpha
	"Answer the receiver's alpha component as a <Number> in the range [0,1], with 0 being completely transparent and 1 completely opaque."

	^self errorNotARealColor!

pen
	"Answer a <Pen> configured for painting solid 1-pixel wide lines of the receiver's color."

	^self errorNotARealColor!

rgbCode
	"Answer the receiver's color value in 24-bit RGB encoding with 8-bits per component in (blue, green, red) order."

	^self errorNotARealColor!

shallowCopy
	"The receiver has a singleton instance."

	^self!

species
	^##(self)! !
!Graphics.ColorDefault categoriesForMethods!
=!comparing!public! !
alpha!public! !
brush!converting!public! !
hash!comparing!public! !
isDefault!public!testing! !
name!accessing!public! !
normalizedAlpha!public! !
pen!converting!public! !
rgbCode!accessing!public! !
shallowCopy!copying!public! !
species!accessing!public! !
!

