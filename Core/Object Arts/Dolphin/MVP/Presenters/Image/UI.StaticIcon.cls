"Filed out from Dolphin Smalltalk 7"!

StaticImage subclass: #StaticIcon
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StaticIcon guid: (GUID fromString: '{87b4c742-026e-11d3-9fd7-00a0cc3e4a32}')!
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

