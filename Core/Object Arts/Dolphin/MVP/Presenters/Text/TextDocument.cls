"Filed out from Dolphin Smalltalk 7"!

DocumentShell subclass: #TextDocument
	instanceVariableNames: 'documentPresenter statusModel'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TextDocument guid: (GUID fromString: '{87b4c6bb-026e-11d3-9fd7-00a0cc3e4a32}')!
TextDocument comment: 'TextDocument is a <documentPresenter> capable of displaying and editing a <readableString> document.

Instance Variables:
	documentPresenter	<TextPresenter> holding the document text.

'!
!TextDocument categoriesForClass!MVP-Presenters! !
!TextDocument methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	documentPresenter := self add: self documentPresenterClass new name: 'document'.
	statusModel := ValueHolder new!

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
	(self view viewNamed: 'status' ifNone: []) 
		ifNotNil: 
			[:item | 
			"item 
				when: #doubleClicked:
				send: #onStatusDoubleClicked:
				to: self."
			item model: statusModel].
	self restoreUserSettings!

restoreUserSettings
	"Private - Hook for subclass to override to restore user options from the registry or isolated storage, etc"

	!

saveUserSettings
	"Private - Save the users configuration to the registry, isolated storage, etc."

	! !
!TextDocument categoriesFor: #createComponents!initializing!public! !
!TextDocument categoriesFor: #documentPresenterClass!constants!public! !
!TextDocument categoriesFor: #fileNew!commands!public! !
!TextDocument categoriesFor: #getDocumentData!accessing!private! !
!TextDocument categoriesFor: #isModified!public!testing! !
!TextDocument categoriesFor: #isModified:!modes!public! !
!TextDocument categoriesFor: #isText!public!testing! !
!TextDocument categoriesFor: #model:!accessing!public! !
!TextDocument categoriesFor: #onViewClosed!event handling!public! !
!TextDocument categoriesFor: #onViewOpened!event handling!public! !
!TextDocument categoriesFor: #restoreUserSettings!operations!options!private! !
!TextDocument categoriesFor: #saveUserSettings!helpers!private! !

!TextDocument class methodsFor!

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

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !
!TextDocument class categoriesFor: #defaultFileExtension!constants!public! !
!TextDocument class categoriesFor: #defaultModel!models!public! !
!TextDocument class categoriesFor: #fileTypes!constants!public! !
!TextDocument class categoriesFor: #shutdownOnExit!public!testing! !

