﻿"Filed out from Dolphin Smalltalk"!

UI.ToolbarButton
	subclass: #'UI.ToolbarTextButton'
	instanceVariableNames: 'buttonText'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ToolbarTextButton guid: (Core.GUID fromString: '{10fa4741-2df6-4618-98b7-ffbc091fdb09}')!

UI.ToolbarTextButton comment: '`ToolbarTextButton` represents a user defined text-only button for a `Toolbar`. These are primarily intended for use with icon fonts such as Segoe Fluent Icons, providing lightweight and scalable button images.'!

!UI.ToolbarTextButton categoriesForClass!MVP-Views-Support! !

!UI.ToolbarTextButton methodsFor!

buttonText
	^buttonText!

buttonText: aStringOrCharacter
	buttonText := aStringOrCharacter!

imageIndexIn: aToolbar
	"Private - The receiver does not have an image - it is text only."

	^CommCtrlConstants.I_IMAGENONE!

isTextOnly
	^true!

setCommandDescription: aCommandDescription buttonText: aString
	style := ##(BTNS_SHOWTEXT | BTNS_AUTOSIZE).
	commandDescription := aCommandDescription.
	buttonText := aString.
	^self!

textIndexIn: aToolbar
	"Private - Answer the text for the receiver to aToolbar and answer the index of this text"

	^aToolbar addString: self buttonText! !

!UI.ToolbarTextButton categoriesForMethods!
buttonText!accessing!public! !
buttonText:!accessing!public! !
imageIndexIn:!operations!private! !
isTextOnly!public! !
setCommandDescription:buttonText:!private! !
textIndexIn:!operations!private! !
!

!UI.ToolbarTextButton class methodsFor!

command: aCommand description: aStringDescription buttonText: aString
	"Answer a new instance of the receiver issuing aCommand with aStringDescription and anImage"

	| command |
	command := CommandDescription command: aCommand description: aStringDescription.
	^self commandDescription: command buttonText: aString!

commandDescription: aCommandDescription buttonText: aString
	"Answer a new instance of the receiver containing a bitmap for aCommandDescription"

	^(self basicNew)
		setCommandDescription: aCommandDescription buttonText: aString!

new
	"Answer a new default ToolbarButton"

	^self
		command: #noCommand
		description: 'No command'
		buttonText: $\x1F42C! !

!UI.ToolbarTextButton class categoriesForMethods!
command:description:buttonText:!instance creation!public! !
commandDescription:buttonText:!instance creation!public! !
new!instance creation!public! !
!
