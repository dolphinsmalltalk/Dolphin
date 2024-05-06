"Filed out from Dolphin Smalltalk"!

StaticView subclass: #StaticImage
	instanceVariableNames: 'image'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StaticImage guid: (GUID fromString: '{87b4c73f-026e-11d3-9fd7-00a0cc3e4a32}')!

StaticImage isAbstract: true!

StaticImage comment: 'StaticImage is an abstract superclass for Windows STATIC controls that display <images>. The <valueModel> associated with a StaticImage must always yield an <image> value when mapped through the installed type converter. A StaticImage will normally be used in conjunction with a <ImagePresenter>.

Instance Variables:
	image		<image> which is a cache for the image being displayed.

'!

!StaticImage categoriesForClass!MVP-Views! !

!StaticImage methodsFor!

displayValue
	"Private - Answer the displayed contents, the current image,
	of the receiver"

	^image!

displayValue: anImage
	"Private - Sets the displayable contents, the image, of the receiver to anImage
	Since the Windows StaticImage control has a propensity to resize to the image 
	size, and this would often be considered unacceptable, we force ourselves 
	back to our original size"

	| extent |
	extent := self extent.
	self setImage: anImage.
	self extent: extent!

image
	"Private - Answers the image held by the receiver"

	^image!

image: anImage
	"Sets the image displayed by the receiver."

	self value: anImage!

setImage: anImage
	^self subclassResponsibility! !

!StaticImage categoriesForMethods!
displayValue!private!updating! !
displayValue:!private!updating! !
image!accessing!private! !
image:!accessing!public! !
setImage:!accessing!private! !
!

!StaticImage class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !

!StaticImage class categoriesForMethods!
icon!constants!public! !
!

