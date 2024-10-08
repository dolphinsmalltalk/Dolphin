﻿"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'UI.AbstractDocumentShell'
	instanceVariableNames: 'filename'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.AbstractDocumentShell guid: (Core.GUID fromString: '{7f3ab0c3-d1ed-4fb5-b64e-bfba5d74d038}')!

UI.AbstractDocumentShell isNonInstantiable: true!

UI.AbstractDocumentShell comment: '`AbstractDocumentShell` is an abstract class of `<documentPresenter>`s, i.e. `Shell` presenters present a documented model which can be loaded from and saved to a file.

Instance Variables:
	filename		`<readableString>` or `nil`, describing the document filename (if it has been set).
'!

!UI.AbstractDocumentShell categoriesForClass!MVP-Presenters! !

!UI.AbstractDocumentShell methodsFor!

addToRecentList: aFilenameString
	"Adds aFilenameString to the <orderedCollection> of recently accessed files"

	| recentList |
	recentList := self getRecentList.
	recentList remove: aFilenameString ifAbsent: nil.
	recentList addFirst: aFilenameString.
	self setRecentList: recentList!

basicCaption
	"Private - Answer a basic caption that can be used to label the receiver's view.
	Normally this is augmented (in #updateCaption) by appending the document file
	name"

	^''!

buildRecentFilesMenu: aMenyu
	aMenyu clear.
	self getRecentList do: 
			[:each |
			| nameToDisplay |
			nameToDisplay := each.
			self hasFilename
				ifTrue: 
					[nameToDisplay := (FolderRelativeFileLocator basePath: (File splitPathFrom: self filename))
								relativePathTo: each].
			aMenyu addCommand: (Message selector: #openOn: argument: each) description: nameToDisplay].
	aMenyu
		addSeparator;
		addCommand: (Message selector: #fileClearRecentList) description: 'Clear Recent List'!

canSave
	"Answer whether the document is in a valid state and can be saved. Subclasses to override as
	appropriate."

	^self isModified!

canSaveAs
	"Answer whether the document is in a valid state and can be saved to a new file. Subclasses to override as appropriate."

	^true!

canSaveState
	"Private - Answer true if the receiver can successfully have its state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of an IdeaSpace save operation"

	^false!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.
	self when: #closeRequested: send: #onCloseRequested: to: self.!

fileClearRecentList
	self setRecentList: OrderedCollection new!

fileLoad
	"Loads the receiver from its associated file (if any)"

	| stream |
	self hasFilename ifFalse: [^self].
	stream := FileStream read: self filename text: self isText share: #readWrite.
	self streamIn: stream.
	stream close!

filename
	"Answers the name of the file associated with the receiver or nil
	if there is none"

	^filename!

filename: aStringOrNil
	"Sets the name of the file associated with the receiver"

	filename := nil.
	(aStringOrNil notNil and: [ aStringOrNil notEmpty ])
		ifTrue: [ filename := aStringOrNil ].
	self updateCaption!

fileOpen
	"Prompts for a file to open into the receiver"

	| openFilename |
	self promptToSaveChanges ifFalse: [^self].
	openFilename := self class getFilename.
	openFilename isNil ifTrue: [^nil].
	^self openOn: openFilename!

fileOpenRecentMenu
	<commandQuery: #hasRecentFiles>
	<menuPopulator: #buildRecentFilesMenu:>
	!

fileRevert
	"Revert the contents of the receiver's document to those in the
	associated file"

	<commandQuery: #hasFilename>
	self isModified
		ifTrue: 
			[(MessageBox new
				owner: self view;
				headline: 'Discard unsaved changes?';
				confirm: 'Are you sure you wish to revert to the previously saved copy?') ifTrue: [self fileLoad]]
		ifFalse: [self fileLoad	"Load without prompt it not modified"]!

fileSave
	"Saves the receiver to its associated file (if any).
	Prompts for a filename if none is yet specified."

	<commandQuery: #canSave>
	^self saveDocument!

fileSaveAs
	"Associated the receiver with a file and saves it. Answers whether the file was actually
	saved."

	<commandQuery: #canSaveAs>
	^self saveDocumentAs!

getDocumentData
	"Private - Answer the data for the receiver's document.
	Can be overidden by subclasses"

	^self model!

getRecentList
	"Private - Answers the current <orderedCollection> of recently opened files.This method should
	probably be overridden in subclasses to provide more persistent storage for the list other
	than the property mechanism. Typically the Windows registry would be used."

	^self class propertyAt: #documentRecentList ifAbsent: [OrderedCollection new]!

hasContents
	^self hasFilename !

hasFilename
	"Answers true if the receiver has an associated file"

	^filename notNil
!

hasRecentFiles
	^self getRecentList notEmpty!

isModified
	"Answer whether the document in the receiver has been modified."

	^false!

isModified: aBoolean
	"Set/reset the receiver's dirty flag.
	To be overridden by subclasses which support such a concept."
!

isText
	"Answer true if the receiver is a text document. Overriden by subclasses
	to determine how the document data should be written and read"

	^false!

onCloseRequested: boolValueHolder
	"Private - A request to close the view onto the receiver as occurred.
	Prompt to save any outstanding changed"

	self onPromptToSaveChanges: boolValueHolder!

onPromptToSaveChanges: aBooleanValue
	"Private - The receiver is about to lose its current contents (or is being closed) as the
	result of some user action. If the displayed document has been changed then prompt to see if
	those changes should be retained, giving the user the option of:
		(a) saving the changes now,
		(b) discarding the changes, or 
		(c) retaining the changes and aborting whatever operation brought us to this point.
	If the operation is to be aborted, then the boolean <ValueHolder> argument is set to false."

	self isModified
		ifTrue: 
			[MessageBox new
				owner: self view;
				headline: self saveChangesPrompt;
				customButtons: #(#(#yes '&Save') #(#no 'Do&n''t Save'));
				confirm: nil
					onYes: [aBooleanValue value: self fileSave]
					onNo: [self isModified: false]
					onCancel: [aBooleanValue value: false]].
	^aBooleanValue value!

openOn: openFilename 
	self
		filename: openFilename;
		fileLoad.
	self addToRecentList: openFilename!

promptToSaveChanges
	"Private - If the receiver's document has been modified, prompt to save changes.
	Answer false if the user cancelled the action or if an attempt to save the document 
	failed, else true."

	| continue |
	continue := true asValue.
	self onPromptToSaveChanges: continue.
	^continue value!

saveChangesPrompt
	| docName |
	docName := self hasFilename ifTrue: [self filename] ifFalse: ['(untitled)'].
	^'Do you want to save changes to <1s>?' expandMacrosWith: docName!

saveDocument
	| saved |
	saved := false.
	
	[self hasFilename
		ifTrue: 
			[| stream |
			stream := FileStream write: self filename text: self isText.
			[self streamOut: stream] ensure: [stream close].
			self isModified: false.
			self addToRecentList: self filename.
			saved := true]
		ifFalse: [saved := self saveDocumentAs]]
			on: FileException
			do: 
				[:e |
				MessageBox new
					headline: 'Unable to save file <1p>' << e file name;
					errorMsg: e messageText].
	^saved!

saveDocumentAs
	| proceed newFilename |
	newFilename := (FileSaveDialog on: self filename asValue)
				fileTypes: self class fileTypes;
				defaultExtension: self class defaultFileExtension;
				caption: 'Save Document As…';
				showModal.
	(proceed := newFilename notNil and: 
					[(File exists: newFilename) not or: 
							[MessageBox new
								headline: 'Overwrite <1s>?' << newFilename;
								iconStyle: #warning;
								confirm: 'This file already exists, are you sure you would like to overwrite it?']])
		ifTrue: 
			["Install the new filename"
			self
				filename: newFilename;
				saveDocument].
	^proceed!

setDocumentData: anObject
	"Private - Set the data for the receiver's document to be anObject.
	Can be overidden by subclasses"

	self model: anObject!

setRecentList: anOrderedCollectionOfFilenameStrings 
	"Private - Save anOrderedCollectionOfFilenameStrings as the list of recently opened files. This method
	should probably be overridden in subclasses to provide more persistent storage for the list
	other than the property mechanism. Typically the Windows registry would be used."

	self class propertyAt: #documentRecentList put: anOrderedCollectionOfFilenameStrings!

shortCaption
	^self hasFilename
		ifTrue: 
			[| stream |
			stream := String writeStream: 32.
			stream nextPutAll: (File splitFilenameFrom: self filename).
			self isModified ifTrue: [stream nextPut: $*].
			stream contents]
		ifFalse: [super shortCaption]!

streamIn: aStream
	"Private - Stream the receiver's model contents in from aStream"

	self setDocumentData: (aStream
				setToEnd;
				contents)!

streamOut: aStream
	"Private - Stream the receiver's model out to aStream"

	aStream nextPutAll: self getDocumentData!

updateCaption
	"Private - The receiver has changed in such a way that the caption may need to be refreshed.
	Do this here"

	| stream suffix |
	stream := String writeStream: 64.
	stream nextPutAll: (self hasFilename ifTrue: [self filename] ifFalse: ['Untitled']).
	suffix := self basicCaption.
	suffix notEmpty
		ifTrue: 
			[stream
				nextPutAll: ' - ';
				nextPutAll: suffix].
	self isModified ifTrue: [stream nextPut: $*].
	self caption: stream contents! !

!UI.AbstractDocumentShell categoriesForMethods!
addToRecentList:!public! !
basicCaption!accessing!private! !
buildRecentFilesMenu:!private! !
canSave!commands-queries!public! !
canSaveAs!commands-queries!public! !
canSaveState!private!saved state! !
createSchematicWiring!initializing!public! !
fileClearRecentList!commands-actions!public! !
fileLoad!operations!public! !
filename!accessing!public! !
filename:!accessing!public! !
fileOpen!commands-actions!public! !
fileOpenRecentMenu!commands-menus!private! !
fileRevert!commands-actions!public! !
fileSave!commands-actions!public! !
fileSaveAs!commands-actions!public! !
getDocumentData!accessing!private! !
getRecentList!private! !
hasContents!public! !
hasFilename!public!testing! !
hasRecentFiles!private!testing! !
isModified!public!testing! !
isModified:!modes!not an aspect!public! !
isText!public!testing! !
onCloseRequested:!event handling!private! !
onPromptToSaveChanges:!private!testing! !
openOn:!public! !
promptToSaveChanges!helpers!private! !
saveChangesPrompt!private! !
saveDocument!operations!private! !
saveDocumentAs!operations!private! !
setDocumentData:!accessing!private! !
setRecentList:!private! !
shortCaption!accessing!public! !
streamIn:!private!streaming! !
streamOut:!private!streaming! !
updateCaption!private!updating! !
!

UI.AbstractDocumentShell methodProtocol: #documentPresenter attributes: #(#readOnly) selectors: #(#ensureVisible #fileLoad #filename #filename: #fileOpen #fileRevert #fileSave #fileSaveAs #getDocumentData #hasFilename #isModified #isModified: #isText #onAboutToDisplayMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewClosed #onViewOpened #parentPresenter #performAction #setDocumentData: #setFocus #show #streamIn: #streamOut: #topShell #view)!

!UI.AbstractDocumentShell class methodsFor!

defaultFileExtension
	"Answer a default extension that will be used for files saved from
	the receiver"

	^self subclassResponsibility!

filename: aStringFilename 
	"Answers an instance of the receiver open on aStringFilename"

	^self openOn: aStringFilename!

fileTypes
	"Answer an Array of file types that can be associated with this
	class of document. Overidden by documents that have their own file
	types"

	^{FileDialog allFilesType}!

getFilename
	| openFilename |
	openFilename := FileOpenDialog new
				fileTypes: self fileTypes;
				defaultExtension: self defaultFileExtension;
				showModal.
	^openFilename!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon fromId: 'DocumentShell.ico'!

open
	"Answers an instance of the receiver open on a filename that has been
	prompted for. If 'Cancel' is pressed in the file open dialog then
	answer nil"

	| openFilename |
	openFilename := self getFilename.
	openFilename isNil ifTrue: [^nil].
	^self openOn: openFilename!

openOn: aStringFilename 
	"Answers an instance of the receiver open on aStringFilename"

	^(self show)
		openOn: aStringFilename;
		yourself! !

!UI.AbstractDocumentShell class categoriesForMethods!
defaultFileExtension!constants!public! !
filename:!instance creation!public! !
fileTypes!constants!public! !
getFilename!instance creation!private! !
icon!constants!public! !
open!instance creation!public! !
openOn:!instance creation!public! !
!

