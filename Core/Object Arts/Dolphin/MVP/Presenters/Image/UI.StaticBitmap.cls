"Filed out from Dolphin Smalltalk 7"!

UI.StaticImage subclass: #'UI.StaticBitmap'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.StaticBitmap guid: (Core.GUID fromString: '{87b4c741-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.StaticBitmap comment: 'StaticBitmap is a <valueView> class for a Window STATIC control using the SS_BITMAP style. The <valueModel> associated with a StaticBitmap must always yield a <Bitmap> value when mapped through the installed type converter. A StaticBitmap will normally be used in conjunction with a <ImagePresenter>.'!
!UI.StaticBitmap categoriesForClass!MVP-Views! !
!UI.StaticBitmap methodsFor!

defaultWindowStyle
	"Private - Answer a default base style to use for the receiver"

	^super defaultWindowStyle bitOr: SS_BITMAP.!

setImage: aBitmapOrNil
	"Private - Sets aBitmapOrNil into the receiver. Make sure that it is not selected into a DC,
	because if it is the image will be blank."

	image := aBitmapOrNil notNil ifTrue: [aBitmapOrNil freeDC; yourself].
	self sendMessage: STM_SETIMAGE wParam: IMAGE_BITMAP lParam: image asParameter! !
!UI.StaticBitmap categoriesFor: #defaultWindowStyle!constants!private! !
!UI.StaticBitmap categoriesFor: #setImage:!accessing!private! !

