"Filed out from Dolphin Smalltalk 1.0 Beta 2"!

Shell subclass: #HexadecimalBrowser
	instanceVariableNames: 'textPresenter '
	classVariableNames: ''
	poolDictionaries: ''!

HexadecimalBrowser class instanceVariableNames: ''!

HexadecimalBrowser comment: ''!

!HexadecimalBrowser categoriesForClass!No category! !

!HexadecimalBrowser methodsFor!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	textPresenter := self add: TextPresenter new name: 'text'.
!

filename: aStringOrNil
	"Set the file being inspected by the receiver"

	self model: aStringOrNil!

fileOpen
	"Prompt the user for a file to display in hexadecimal."

	| filename stream data |
	filename := FileOpenDialog new
		fileTypes: #( ('All Files (*.*)' '*.*') );
		defaultExtension: '';
		showModal.
	filename isNil ifTrue: [^self]. "user cancelled"
	self filename: filename!

model: aStringOrNil
	"Private - Set the model for the receiver to be aStringOrNil"

	| text stream data |
	text := aStringOrNil isNil 
		ifTrue: [ '' ]
		ifFalse: [ stream := FileStream read: aStringOrNil.
			data := stream setToEnd; contents.
			stream close. 
			(HexadecimalConverter new text: data; convertedText) ].

	textPresenter value: text.
! !

!HexadecimalBrowser categoriesFor: #createComponents!initializing! !
!HexadecimalBrowser categoriesFor: #filename:!accessing! !
!HexadecimalBrowser categoriesFor: #fileOpen!accessing!commands! !
!HexadecimalBrowser categoriesFor: #model:!accessing! !

!HexadecimalBrowser class methodsFor!

defaultView
	"Answer the resource name of the default view for the receiver."

	^'DefaultView'!

example
	"Start up an instance of the HexadecimalBrowser and immediately prompt for a file"

	^self show fileOpen! !

!HexadecimalBrowser class categoriesFor: #defaultView!constants! !
!HexadecimalBrowser class categoriesFor: #example!examples! !

