"Filed out from Dolphin Smalltalk X6"!

StaticImage subclass: #StaticBitmap
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StaticBitmap guid: (GUID fromString: '{87B4C741-026E-11D3-9FD7-00A0CC3E4A32}')!
StaticBitmap comment: 'StaticBitmap is a <valueView> class for a Window STATIC control using the SS_BITMAP style. The <valueModel> associated with a StaticBitmap must always yield a <Bitmap> value when mapped through the installed type converter. A StaticBitmap will normally be used in conjunction with a <ImagePresenter>.'!
!StaticBitmap categoriesForClass!MVP-Views! !
!StaticBitmap methodsFor!

defaultWindowStyle
	"Private - Answer a default base style to use for the receiver"

	^super defaultWindowStyle bitOr: SS_BITMAP.!

setImage: aBitmapOrNil
	"Private - Sets aBitmapOrNil into the receiver. Make sure that it is not selected into a DC,
	because if it is the image will be blank."

	image := aBitmapOrNil notNil ifTrue: [aBitmapOrNil freeDC; yourself].
	self sendMessage: STM_SETIMAGE wParam: IMAGE_BITMAP lParam: image asParameter! !
!StaticBitmap categoriesFor: #defaultWindowStyle!constants!private! !
!StaticBitmap categoriesFor: #setImage:!accessing!private! !

