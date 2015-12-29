"Filed out from Dolphin Smalltalk X6"!

StaticView subclass: #FontView
	instanceVariableNames: 'previewText'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FontView guid: (GUID fromString: '{87B4C73D-026E-11D3-9FD7-00A0CC3E4A32}')!
FontView comment: 'FontView is a <valueView> for displaying static <Font>s. The <valueModel> associated with a FontView must always yield a <Font> value when mapped through the installed type converter. A FontView will normally be used in conjunction with a <FontPresenter>.'!
!FontView categoriesForClass!MVP-Views! !
!FontView methodsFor!

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
!FontView categoriesFor: #displayValue!private!updating! !
!FontView categoriesFor: #displayValue:!private!updating! !
!FontView categoriesFor: #previewText!accessing!public! !
!FontView categoriesFor: #previewText:!accessing!public! !

!FontView class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !
!FontView class categoriesFor: #icon!constants!public! !

