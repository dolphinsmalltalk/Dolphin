"Filed out from Dolphin Smalltalk X6"!

StaticImage subclass: #StaticIcon
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StaticIcon guid: (GUID fromString: '{87B4C742-026E-11D3-9FD7-00A0CC3E4A32}')!
StaticIcon comment: 'StaticIcon is a <valueView> class for a Window STATIC control using the SS_ICON style. The <valueModel> associated with a StaticIcon must always yield an <Icon> value when mapped through the installed type converter. A StaticIcon will normally be used in conjunction with a <ImagePresenter>.'!
!StaticIcon categoriesForClass!MVP-Views! !
!StaticIcon methodsFor!

defaultExtent
	"Private - Answer the default size of the receiver
	to be used when it is created."

	^##(32 @ 32)!

defaultWindowStyle
	"Private - Answer a default base style to use for the receiver"

	^super defaultWindowStyle bitOr: SS_ICON.!

setImage: anIconOrNil
	"Private - Sets anIconOrNil into the receiver."

	image := anIconOrNil.
	self sendMessage: STM_SETIMAGE wParam: IMAGE_ICON lParam: anIconOrNil asParameter! !
!StaticIcon categoriesFor: #defaultExtent!constants!private! !
!StaticIcon categoriesFor: #defaultWindowStyle!constants!private! !
!StaticIcon categoriesFor: #setImage:!accessing!private! !

