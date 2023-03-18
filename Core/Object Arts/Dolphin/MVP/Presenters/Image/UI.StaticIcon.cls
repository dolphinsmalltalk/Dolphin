"Filed out from Dolphin Smalltalk"!

UI.StaticImage
	subclass: #'UI.StaticIcon'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.StaticIcon guid: (Core.GUID fromString: '{87b4c742-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.StaticIcon comment: 'StaticIcon is a <valueView> class for a Window STATIC control using the SS_ICON style. The <valueModel> associated with a StaticIcon must always yield an <Icon> value when mapped through the installed type converter. A StaticIcon will normally be used in conjunction with a <ImagePresenter>.'!
!UI.StaticIcon categoriesForClass!MVP-Views! !
!UI.StaticIcon methodsFor!

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
!UI.StaticIcon categoriesForMethods!
defaultExtent!constants!private! !
defaultWindowStyle!constants!private! !
setImage:!accessing!private! !
!

