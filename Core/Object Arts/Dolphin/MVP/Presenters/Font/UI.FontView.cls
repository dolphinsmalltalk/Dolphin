"Filed out from Dolphin Smalltalk"!

UI.StaticView
	subclass: #'UI.FontView'
	instanceVariableNames: 'previewText'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.FontView guid: (Core.GUID fromString: '{87b4c73d-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.FontView comment: 'FontView is a <valueView> for displaying static <Font>s. The <valueModel> associated with a FontView must always yield a <Font> value when mapped through the installed type converter. A FontView will normally be used in conjunction with a <FontPresenter>.'!
!UI.FontView categoriesForClass!MVP-Views! !
!UI.FontView methodsFor!

displayValue
	"Answer the displayable contents of the receiver"

	^self font!

displayValue: aFont 
	"Private - Set the displayable contents of the receiver, the color"

	self font: aFont.
	self 
		text: (previewText ifNil: [aFont isNil ifTrue: ['Default'] ifFalse: [aFont displayString]])!

previewText
	"Answer the preview text displayed in the receiver. If this is nil then the Font's display string is used,
	which details the font name and point size."

	^previewText!

previewText: aString 
	"Set the preview text displayed in the receiver. If this is nil then the Font's display string is used,
	which details the font name and point size."

	previewText := aString! !
!UI.FontView categoriesForMethods!
displayValue!private!updating! !
displayValue:!private!updating! !
previewText!accessing!public! !
previewText:!accessing!public! !
!

!UI.FontView class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !
!UI.FontView class categoriesForMethods!
icon!constants!public! !
!

