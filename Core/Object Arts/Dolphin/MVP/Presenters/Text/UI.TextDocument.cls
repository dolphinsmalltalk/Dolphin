"Filed out from Dolphin Smalltalk 7"!

UI.AbstractDocumentShell subclass: #'UI.TextDocument'
	instanceVariableNames: 'documentPresenter statusModel modifiedModel'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.TextDocument guid: (Core.GUID fromString: '{87b4c6bb-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.TextDocument comment: '`TextDocument` is a `<documentPresenter>` capable of displaying and editing a `<readableString>` document.

Instance Variables:
	documentPresenter	`TextPresenter` holding the document text.

'!
!UI.TextDocument categoriesForClass!MVP-Presenters! !
!UI.TextDocument methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	documentPresenter := self add: self documentPresenterClass new name: 'document'.
	statusModel := ValueHolder new.
	modifiedModel := false asValue!

documentPresenterClass
	^TextPresenter!

fileNew
	"The user has selected the standard File/New command."

	self promptToSaveChanges ifFalse: [^self].
	self filename: nil.
	self setDocumentData: String new!

getDocumentData
	"Private - Answer the data for the receiver's document."

	documentPresenter view notNil ifTrue: [documentPresenter view updateModel].
	^self model value!

isModified
	"Answer whether the document in the receiver has been modified."

	^documentPresenter isModified!

isModified: aBoolean
	"Set/reset the receiver's dirty flag."

	documentPresenter isModified: aBoolean!

isText
	"Answer true if the receiver is a text document"

	^true!

model: aStringValueModel
	"Set the model associated with the receiver."

	super model: aStringValueModel asValue.
	documentPresenter model: self model
	!

onViewClosed
	"Sent by the receiver's view when it has been closed"

	self saveUserSettings.
	super onViewClosed!

onViewOpened
	"Received when the receiver's view is been connected. "

	super onViewOpened.
	(self view viewNamed: 'status' ifNone: []) ifNotNil: [:item | item model: statusModel].
	modifiedModel
		when: #valueChanged
		send: #updateCaption
		to: self.
	self restoreUserSettings!

openFile: pathString
	"Open the file with the <readableString> path, pathString, prompting in the standard Notepad
	fashion if it doesn't exist."

	(File exists: pathString)
		ifTrue: 
			[self
				filename: pathString;
				fileLoad]
		ifFalse: 
			[| resp mb |
			mb := MessageBox new.
			mb buttonStyle: #yesNoCancel.
			resp := mb warning: ('Cannot find the <1p> file.<n><n>Do you want to create a new file?'
								expandMacrosWith: pathString).
			resp == #yes ifTrue: [self filename: pathString] ifFalse: [resp == #cancel ifTrue: [self exit]]]!

restoreUserSettings
	"Private - Hook for subclass to override to restore user options from the registry or isolated storage, etc"

	!

saveUserSettings
	"Private - Save the users configuration to the registry, isolated storage, etc."

	!

validateUserInterface
	modifiedModel value: self isModified.
	^super validateUserInterface! !
!UI.TextDocument categoriesFor: #createComponents!initializing!public! !
!UI.TextDocument categoriesFor: #documentPresenterClass!constants!public! !
!UI.TextDocument categoriesFor: #fileNew!commands!public! !
!UI.TextDocument categoriesFor: #getDocumentData!accessing!private! !
!UI.TextDocument categoriesFor: #isModified!public!testing! !
!UI.TextDocument categoriesFor: #isModified:!modes!public! !
!UI.TextDocument categoriesFor: #isText!public!testing! !
!UI.TextDocument categoriesFor: #model:!accessing!public! !
!UI.TextDocument categoriesFor: #onViewClosed!event handling!public! !
!UI.TextDocument categoriesFor: #onViewOpened!event handling!public! !
!UI.TextDocument categoriesFor: #openFile:!operations!public! !
!UI.TextDocument categoriesFor: #restoreUserSettings!operations!options!private! !
!UI.TextDocument categoriesFor: #saveUserSettings!helpers!private! !
!UI.TextDocument categoriesFor: #validateUserInterface!operations!public! !

!UI.TextDocument class methodsFor!

defaultFileExtension
	"Answer a default extension that will be used for files saved from
	the receiver"

	^'txt'!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^String new asValue!

fileTypes
	"Answer an Array of file types that can be associated with this
	class of document."

	^#(#('Text Files (*.txt)' '*.txt') #('All Files (*.*)' '*.*'))!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !
!UI.TextDocument class categoriesFor: #defaultFileExtension!constants!public! !
!UI.TextDocument class categoriesFor: #defaultModel!models!public! !
!UI.TextDocument class categoriesFor: #fileTypes!constants!public! !
!UI.TextDocument class categoriesFor: #icon!constants!public! !
!UI.TextDocument class categoriesFor: #shutdownOnExit!public!testing! !

