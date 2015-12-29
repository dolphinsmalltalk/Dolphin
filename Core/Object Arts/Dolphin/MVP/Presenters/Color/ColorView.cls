"Filed out from Dolphin Smalltalk X6"!

StaticView subclass: #ColorView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ColorView guid: (GUID fromString: '{87B4C73C-026E-11D3-9FD7-00A0CC3E4A32}')!
ColorView comment: 'ColorView is a <valueView> for displaying static <color>s. The <valueModel> associated with a ColorView must always yield a <color> value when mapped through the installed type converter. A ColorView will normally be used in conjunction with a <ColorPresenter>.'!
!ColorView categoriesForClass!MVP-Views! !
!ColorView methodsFor!

basicActualBackcolor
	| color |
	color := super basicActualBackcolor.
	"Since the purpose of this view is to display a colour, transparency doesn't make sense, so paint it white instead"
	^color isNone ifTrue: [Color window] ifFalse: [color]!

displayValue
	"Answer the displayable contents of the receiver"

	^self backcolor!

displayValue: aColor
	"Private - Set the displayable contents of the receiver, the color"

	self backcolor: aColor
! !
!ColorView categoriesFor: #basicActualBackcolor!accessing!private! !
!ColorView categoriesFor: #displayValue!private!updating! !
!ColorView categoriesFor: #displayValue:!private!updating! !

!ColorView class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^Color black asValue!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !
!ColorView class categoriesFor: #defaultModel!models!public! !
!ColorView class categoriesFor: #icon!constants!public! !

