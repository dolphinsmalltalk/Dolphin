"Filed out from Dolphin Smalltalk 7"!

StaticText subclass: #StaticPath
	instanceVariableNames: 'text'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StaticPath guid: (GUID fromString: '{c79f6206-3e83-4124-b572-d8d54cd25cb1}')!
StaticPath comment: 'StaticPath is a <valueView> class for a Window STATIC control specifically intended for displaying file paths, which are truncated to fit by replacing path components with ellipses as necessary. Note that the path is expected to be dsiplayed on a single line, and will not wrap to multiple lines unless the last remaining component would be truncated. See <StaticText> for further details.
'!
!StaticPath categoriesForClass!Unclassified! !
!StaticPath methodsFor!

isSingleLine
	^true!

layout: aLayoutContext 
	"Private - Recalculate the geometry of the receiver."

	"Implementation Note: As the receiver's size has changed, we may be able to display more or
	less of the path."

	super layout: aLayoutContext.
	self setWindowText: text
!

plainText
	"Answers the plain, unformatted, text from the receiver.
	Implementation Note: Since the text in the control itself may be truncated,
	we answer the full path string cached in an instance variable."

	^text!

plainText: pathString
	"Private - Set the text contents of the receiver to the plain text pathString,
	truncating it to fit by replacing path components with ellipses if necessary.
	The full text is cached since it won't be set into the control itself."

	text := pathString.
	super plainText: text.
!

setWindowText: pathString
	"Private - Sets the text of the receiver"

	ShlwapiLibrary default
		pathSetDlgItemPath: self parentView asParameter
		id: self id
		pszPath: pathString.
	^true! !
!StaticPath categoriesFor: #isSingleLine!private!testing! !
!StaticPath categoriesFor: #layout:!geometry!private! !
!StaticPath categoriesFor: #plainText!accessing!public! !
!StaticPath categoriesFor: #plainText:!private!updating! !
!StaticPath categoriesFor: #setWindowText:!accessing!private! !

!StaticPath class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !
!StaticPath class categoriesFor: #icon!constants!public! !

