"Filed out from Dolphin Smalltalk"!

AbstractDocumentShell subclass: #ScribbleDocument
	instanceVariableNames: 'scribblePresenter checkpoint'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ScribbleDocument guid: (GUID fromString: '{a1f145eb-f943-4ade-84a5-0274e1390a5b}')!

ScribbleDocument comment: '`ScribbleDocument` is a very simple example of a non-text DocumentShell.

Most of the code associated with storing, capturing and displaying scribbles is in the MVP triad of `ListModel`, `Scribble`, and `ScribbleView`. This document class just adds the ability to save and load scribbles to and from files using the STB binary filer to serialized the model.'!

!ScribbleDocument categoriesForClass!MVP-Presenters! !

!ScribbleDocument methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	scribblePresenter := self add: self class scribblePresenterClass new name: 'scribble'!

fileNew
	"The user has selected the standard File/New command."

	self promptToSaveChanges ifFalse: [^self].
	self filename: nil.
	self setDocumentData: ListModel new!

isModified
	"Answer whether the document in the receiver has been modified."

	"Scribble documents can only be added to, so if there are more points than when the model was set, it is dirty"

	^checkpoint ~= self model size!

isModified: aBoolean
	"Set/reset the receiver's dirty `flag`."

	checkpoint := self model size!

model: aValueModel
	"Set the model associated with the receiver."

	super model: aValueModel.
	scribblePresenter model: self model.
	self isModified: false
	!

streamIn: aStream
	"Private - Stream the receiver's model contents in from aStream"

	self setDocumentData: (Object binaryReadFrom: aStream)!

streamOut: aStream
	"Private - Stream the receiver's model out to aStream. Use the STB4 format for backwards compatibility."

	self getDocumentData binaryStoreUsing: (STBOutFiler4 on: aStream)! !

!ScribbleDocument categoriesForMethods!
createComponents!initializing!public! !
fileNew!commands!public! !
isModified!public!testing! !
isModified:!modes!not an aspect!public! !
model:!accessing!public! !
streamIn:!private!streaming! !
streamOut:!private!streaming! !
!

!ScribbleDocument class methodsFor!

defaultFileExtension
	^File splitExtensionFrom: self fileType last!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel new!

fileType
	"Answer a two element array describing the principal file type for this document."

	^#('Scribble Files (*.scribble)' '*.scribble')!

fileTypes
	"Answer an Array of file types that can be associated with this class of document."

	^{self fileType. FileDialog allFilesType}!

icon
	^self scribblePresenterClass icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Scribble) #resource_Default_view nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 738 1169 683 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 8 #() 738 193 193 nil 27 170 192 34 2 528 8 'scribble' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 1 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'DocumentShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1010 1 1042 #fileOpen 8 '&Open…' 9375 1 1090 nil true 1136 8 'OpenWorkspace.ico' 1184 nil nil 1010 1 1042 #fileSave 8 '&Save' 9383 1 1090 nil true 1136 8 'FileSave.ico' 1184 nil nil 1010 1 1042 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 13077 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 1090 nil true 1136 8 'Scribble.ico' 1184 nil nil nil 1 nil nil 626 138 144 34 2 690 #createAt:extent: 34 2 738 3839 21 738 1201 801 416 690 #updateMenuBar 832 416 786 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 1 528 848 nil 27 )!

scribblePresenterClass
	^Scribble!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !

!ScribbleDocument class categoriesForMethods!
defaultFileExtension!constants!public! !
defaultModel!models!public! !
fileType!constants!public! !
fileTypes!constants!public! !
icon!public! !
resource_Default_view!public!resources-views! !
scribblePresenterClass!constants!private! !
shutdownOnExit!public!testing! !
!

