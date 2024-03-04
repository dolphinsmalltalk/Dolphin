"Filed out from Dolphin Smalltalk"!

UI.CheckButton
	subclass: #'UI.CheckBox'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.CheckBox guid: (Core.GUID fromString: '{87b4c734-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.CheckBox comment: 'CheckBox is a <valueView> implementing the Windows "BUTTON" class in either BS_AUTOCHECKBOX or BS_AUTO3STATE style. The <valueModel> associated with a CheckBox must always yield a <boolean> value once mapped through the installed type converter, although nil is also an acceptable value for a 3-state button where it indicates that the button is in an indeterminate state. A CheckBox will normally be used in conjunction with a <BooleanPresenter>.'!

!UI.CheckBox categoriesForClass!MVP-Views! !

!UI.CheckBox methodsFor!

basicWindowStyle
	"Private - Answer a basic default style to use when creating a checkbox."

	^BS_AUTOCHECKBOX!

is3State
	"Answer whether the receiver is a 3-state check box that can be 'dimmed' as well as checked
	and unchecked."

	^(self baseStyle bitAnd: BS_TYPEMASK) = BS_AUTO3STATE!

is3State: aBoolean 
	"Set whether the receiver is a 3-state check box that can be 'dimmed' as well as checked
	and unchecked."

	self baseStyle: (aBoolean ifTrue: [BS_AUTO3STATE] ifFalse: [self basicWindowStyle])
		maskedBy: BS_TYPEMASK!

paintTransparentBackgroundOn: aCanvas
	self isThemed ifFalse: [^self].
	UxTheme
		drawThemeParentBackground: handle
		hdc: aCanvas asParameter
		prc: nil! !

!UI.CheckBox categoriesForMethods!
basicWindowStyle!constants!private! !
is3State!accessing!public! !
is3State:!accessing!public! !
paintTransparentBackgroundOn:!private!updating! !
!

