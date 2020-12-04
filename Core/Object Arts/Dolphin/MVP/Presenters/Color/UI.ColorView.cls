"Filed out from Dolphin Smalltalk 7"!

UI.StaticView subclass: #'UI.ColorView'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ColorView guid: (Core.GUID fromString: '{87b4c73c-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ColorView comment: 'ColorView is a <valueView> for displaying static <color>s. The <valueModel> associated with a ColorView must always yield a <color> value when mapped through the installed type converter. A ColorView will normally be used in conjunction with a <ColorPresenter>.'!
!UI.ColorView categoriesForClass!MVP-Views! !
!UI.ColorView methodsFor!

basicActualBackcolor
	| color |
	color := super basicActualBackcolor.
	^color isDefault ifTrue: [ColorRef defaultColorRepresentation] ifFalse: [color]!

displayValue
	"Answer the displayable contents of the receiver"

	^self backcolor!

displayValue: aColor
	"Private - Set the displayable contents of the receiver, the color"

	self backcolor: aColor
!

paintTransparentBackgroundOn: aCanvas
	"The purpose of a ColorView is to present a visual representation of a Color, so we need to choose a suitable way to show the completely transparent Color none. Although strictly it will be 'invisible', leaving the client area unpainted so that the previously painted content (whatever that is) shows through, would not be helpful."

	aCanvas
		brush: (HatchBrush diamond: Color whiteSmoke);
		fillRectangle: self clientRectangle! !
!UI.ColorView categoriesFor: #basicActualBackcolor!accessing!private! !
!UI.ColorView categoriesFor: #displayValue!private!updating! !
!UI.ColorView categoriesFor: #displayValue:!private!updating! !
!UI.ColorView categoriesFor: #paintTransparentBackgroundOn:!private!updating! !

!UI.ColorView class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^Color black asValue!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !
!UI.ColorView class categoriesFor: #defaultModel!models!public! !
!UI.ColorView class categoriesFor: #icon!constants!public! !

