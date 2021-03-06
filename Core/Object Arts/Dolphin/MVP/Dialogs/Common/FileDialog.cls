﻿"Filed out from Dolphin Smalltalk 7"!

CommonDialog subclass: #FileDialog
	instanceVariableNames: 'style fileTypes validationBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileDialog guid: (GUID fromString: '{87b4c6b1-026e-11d3-9fd7-00a0cc3e4a32}')!
FileDialog isAbstract: true!
FileDialog comment: 'FileDialog is an abstract superclass for <valueDialogPresenter>s implementing the Windows common file dialogs. 

'!
!FileDialog categoriesForClass!MVP-Presenters! !
!FileDialog methodsFor!

allFilesType
	"Private - Answer a file spec. pair suitable for adding to the FileDialog
	with the fileTypes: message."

	^self class allFilesType!

averageFilenameLength
	^30!

basicShowModal
	"Private - Show a Open File dialog for the receiver."

	^self subclassResponsibility!

caption: aString 
	"Sets the caption for the receiver to aString"

	self winStruct title: aString!

cdnFileOk: anExternalAddress
	"Private - The user clicked the OK button; the dialog is about to close. Return 0 to accept the
	filename choice, or non-zero to reject it."

	| ofn file |
	ofn := OFNOTIFYW fromAddress: anExternalAddress.
	file := ofn lpOFN lpstrFile.
	^(validationBlock value: file)
		ifTrue: [0]
		ifFalse: 
			[view setWindowLong: DWL_MSGRESULT to: 1.
			1]!

cdnFolderChange: anExternalAddress 
	"Private - The user opened a new folder or directory."

	^0!

cdnHelp: anExternalAddress 
	"Private - The user clicked the Help button."

	^0!

cdnIncludeItem: anExternalAddress
	"Private - Determines whether an item should be displayed. When the user opens a new folder
	or directory, the dialog sends this notification for each item in the folder or directory,
	but only if the OFN_ENABLEINCLUDENOTIFY flag was set."

	| ofnex |
	ofnex := OFNOTIFYEXW fromAddress: anExternalAddress.
	ofnex.
	^1!

cdnInitDone: anExternalAddress
	"Private - Initialisation of the dialog box is complete."

	| ofn |
	ofn := OFNOTIFYW fromAddress: anExternalAddress.
	ofn.
	^0!

cdnSelChange: anExternalAddress 
	"Private - The user has changed the selection in the dialog box."

	^0!

cdnShareViolation: anExternalAddress 
	"Private - The user has chosen a file on which there is a sharing violation."

	"Return zero to have the dialog display the standard warning message."

	^0!

cdnTypeChange: anExternalAddress 
	"Private - The user has selected a new file type from the file types combo box."

	^0!

commonDialogSelector
	"Private - Answer the selector to use to get the result."

	^self subclassResponsibility!

defaultExtension
	"Answer the default file extension to be used if a filename is entered
	without one, or nil if there is no default."

	^self winStruct defaultExtension
!

defaultExtension: aString
	"Set the receiver's default extension to aString."

	self winStruct defaultExtension: aString.
!

defaultStyle
	"Answers the default style for the receiver."

	^##(OFN_HIDEREADONLY | OFN_EXPLORER | OFN_ENABLESIZING)!

extractPathNames: aString
	| multisz strings pathNames |
	multisz := aString readStream.
	strings := Array writeStream.
	"The dialog populates the buffer with potentially multiple null-terminated strings, with an extra null terminator delimiting the list.
	If there is only a single file selected, the full path of that file is the only entry. If more than one file is selected, then the first entry is the folder path, and subsequent entries the names of files in that folder."
	[multisz atEnd or: [multisz peekFor: $\0]] whileFalse: [strings nextPut: (multisz upTo: $\0)].
	strings := strings contents.
	^strings size == 1
		ifTrue: [strings]
		ifFalse: 
			[| folder count |
			folder := strings first.
			count := strings size.
			pathNames := Array writeStream: count - 1.
			strings
				from: 2
				to: count
				do: [:each | pathNames nextPut: (File composePath: folder subPath: each)].
			pathNames collection]!

extractResult: result
	"Private - Extract and apply the result from the parameter structure passed to the Win32 API associated with this common dialog, immediately 
	after the call to that API."

	| buffer |
	result ifFalse: [^self].
	buffer := self winStruct fileName.
	self
		value: (self maxFileCount > 1 ifTrue: [self extractPathNames: buffer] ifFalse: [buffer trimNulls]).
	self apply!

fileTypes
	"Answer the file types to be displayed in the drop-down on the dialog. 
	See #fileTypes: for a description of the format."

	^fileTypes!

fileTypes: stringPairs
	"Sets the file selection specification to the <sequencedReadableCollection>
	of pairs of <readableString>s, where the pairs which responds to the 
	messages #first and #last answering its first and second elements respectively
	(e.g. an <Array> of 2 element <Array>s of <String>s).
	The first string from each pair specifies the text that will be displayed
	to the user, and the second string contains a list of the file types to be displayed in the file
	open/save dialog box in conjunction with the display string. If the list of file types contains
	more than one entry, then the specs are separated by semi-colons.

	eg. #( ('Text Files (*.txt)' '*.txt') 
		('Program Files (*.dll,*.exe)' '*.dll;*.exe'
		('All Files' '*.*'))"

	fileTypes := stringPairs!

fileTypesStringFromSpecs: stringPairs
	"Private - Answers a String of file types based on the contents of the
	<sequencedReadableCollection> of file specs pairs, stringPairs. The
	individual pairs must answer their first and last elements to the #first
	and #last messages respectively. If fileSpecs is nil, then answer nil.

	The shape of stringPairs is (for example):
		#(('Text files' '*.txt;*.rtf') ('All Files' '*.*'))
	The format of the result <String> is:
		'Text Files@*.txt;*.rtf@All Files@*.*@@'
	where @ is a NULL terminator."

	| stream null |
	stringPairs isNil ifTrue: [^nil].
	stream := Utf16String writeStream: 40.
	null := Character null.
	stringPairs do: 
			[:x |
			stream
				nextPutAll: x first;
				nextPut: null;
				nextPutAll: x last;
				nextPut: null].
	^stream
		nextPut: null;
		contents!

filterIndex
	"Answer the one-based <integer> index of the filter selected by the user."

	^self winStruct nFilterIndex
	!

filterIndex: anInteger
	"Set the <integer> index of the filter to be displayed initially."

	self winStruct nFilterIndex: anInteger
	!

getFilePath
	"Retrieve the full path of the file as currently specified in the dialog. This can be called
	during notifications from the dialog such as CDN_SELCHANGE."

	| len buf dialog |
	dialog := view parentView.
	len := dialog
				sendMessage: CDM_GETFILEPATH
				wParam: 0
				lpParam: nil.
	buf := Utf16String newFixed: len - 1.
	dialog
		sendMessage: CDM_GETFILEPATH
		wParam: len
		lpParam: buf.
	^buf asUtf8String!

getFileSpec
	"Retrieve the file name (sans path) as currently specified in the dialog. This can be called
	during notifications from the dialog such as CDN_SELCHANGE."

	| len buf dialog |
	dialog := view parentView.
	len := dialog
				sendMessage: CDM_GETSPEC
				wParam: 0
				lpParam: nil.
	buf := Utf16String newFixed: len - 1.
	dialog
		sendMessage: CDM_GETSPEC
		wParam: len
		lpParam: buf.
	^buf asUtf8String!

initialDirectory: aString
	"Set the initial directory path name to be opened/saved."

	self winStruct initialDirectory: aString!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self fileTypes: (Array with: self allFilesType).
	style := self defaultStyle.
	validationBlock := [:path | true]!

maxFileCount
	"Answers the maximum number of selections that can be expected to fit into the buffer."

	^1!

prepareStruct
	"Private - Initialize the parameter structure to be passed to the Win32 API associated with this common dialog, immediately prior to the call to that API."

	| buf defext |
	buf := Utf16String newFixed: self maxFileCount * self averageFilenameLength + File maxPath.
	self value
		ifNotNil: 
			[:filename |
			| utf16 |
			utf16 := filename asUtf16String.
			buf
				replaceFrom: 1
				to: utf16 size
				with: utf16].
	(self filterIndex = 0 and: [(defext := self defaultExtension) notNil])
		ifTrue: [self filterIndex: (self fileTypes findFirst: [:pair | pair last contains: defext])].
	self winStruct
		fileTypes: (self fileTypesStringFromSpecs: self fileTypes);
		nMaxFile: buf size;
		fileName: buf;
		maskIn: self style!

style
	"Answers the style flags to be used when the receiver is opened."

	^style!

style: anInteger
	"Set the style flags to be used when the receiver is opened."

	style := anInteger!

validationBlock
	^validationBlock!

validationBlock: aMonadicValuable 
	"Set the <monadicValuable> used to validate the user's reply. The valuable is passed the a
	<String> which is the full path of the selected file as its argument, and is expected to
	answer whether it is valid. The dialog cannot be Ok'd until the validationBlock answers
	true."

	"N.B. If validation fails it is adisable to inform the user in some way as otherwise they
	won't understand why the Open/Save button is not working. One way to do this is to show a
	message box from the validation block."

	validationBlock := aMonadicValuable!

winStructClass
	"Private - Answer the class to use for the receiver's associated windows parameter structure."

	^OPENFILENAMEW!

wmInitDialog: message wParam: wParam lParam: lParam 
	"Private - A WM_INITDIALOG message was sent to the hook procedure. This is sent after the common
	dialog itself has handled the message."

	"Implementation Note: We don't need to set the caption here, since in this case the
	initialisation structure has a field for the dialog title."

	^0!

wmNotify: msgInteger wParam: wParamInteger lParam: lParamInteger
	| ptr |
	ptr := lParamInteger asExternalAddress.
	^(##((Array new: CDN_FIRST - CDN_INCLUDEITEM + 1 withAll: #nmDummy:)
		at: CDN_FIRST - CDN_INITDONE + 1 put: #cdnInitDone:;
		at: CDN_FIRST - CDN_SELCHANGE + 1 put: #cdnSelChange:;
		at: CDN_FIRST - CDN_FOLDERCHANGE + 1 put: #cdnFolderChange:;
		at: CDN_FIRST - CDN_SHAREVIOLATION + 1 put: #cdnShareViolation:;
		at: CDN_FIRST - CDN_HELP + 1 put: #cdnHelp:;
		at: CDN_FIRST - CDN_FILEOK + 1 put: #cdnFileOk:;
		at: CDN_FIRST - CDN_TYPECHANGE + 1 put: #cdnTypeChange:;
		at: CDN_FIRST - CDN_INCLUDEITEM + 1 put: #cdnIncludeItem:;
		yourself) lookup: ##(CDN_FIRST + 1) - (ptr sdwordAtOffset: 8))
		ifNil: [0]
		ifNotNil: [:action | self perform: action with: ptr]! !
!FileDialog categoriesFor: #allFilesType!constants!private! !
!FileDialog categoriesFor: #averageFilenameLength!constants!private! !
!FileDialog categoriesFor: #basicShowModal!private!realizing/unrealizing! !
!FileDialog categoriesFor: #caption:!accessing!public! !
!FileDialog categoriesFor: #cdnFileOk:!event handling-win32!private! !
!FileDialog categoriesFor: #cdnFolderChange:!event handling-win32!private! !
!FileDialog categoriesFor: #cdnHelp:!event handling-win32!private! !
!FileDialog categoriesFor: #cdnIncludeItem:!event handling-win32!private! !
!FileDialog categoriesFor: #cdnInitDone:!event handling-win32!private! !
!FileDialog categoriesFor: #cdnSelChange:!event handling-win32!private! !
!FileDialog categoriesFor: #cdnShareViolation:!event handling-win32!private! !
!FileDialog categoriesFor: #cdnTypeChange:!event handling-win32!private! !
!FileDialog categoriesFor: #commonDialogSelector!constants!private! !
!FileDialog categoriesFor: #defaultExtension!accessing!public! !
!FileDialog categoriesFor: #defaultExtension:!accessing!public! !
!FileDialog categoriesFor: #defaultStyle!constants!public! !
!FileDialog categoriesFor: #extractPathNames:!helpers!private! !
!FileDialog categoriesFor: #extractResult:!helpers!private! !
!FileDialog categoriesFor: #fileTypes!accessing!public! !
!FileDialog categoriesFor: #fileTypes:!accessing!public! !
!FileDialog categoriesFor: #fileTypesStringFromSpecs:!helpers!private! !
!FileDialog categoriesFor: #filterIndex!accessing!public! !
!FileDialog categoriesFor: #filterIndex:!accessing!public! !
!FileDialog categoriesFor: #getFilePath!operations!private! !
!FileDialog categoriesFor: #getFileSpec!operations!private! !
!FileDialog categoriesFor: #initialDirectory:!accessing!public! !
!FileDialog categoriesFor: #initialize!initializing!private! !
!FileDialog categoriesFor: #maxFileCount!accessing!public! !
!FileDialog categoriesFor: #prepareStruct!helpers!private! !
!FileDialog categoriesFor: #style!accessing!public! !
!FileDialog categoriesFor: #style:!accessing!public! !
!FileDialog categoriesFor: #validationBlock!accessing!public! !
!FileDialog categoriesFor: #validationBlock:!initializing!public! !
!FileDialog categoriesFor: #winStructClass!accessing!private! !
!FileDialog categoriesFor: #wmInitDialog:wParam:lParam:!event handling-win32!private! !
!FileDialog categoriesFor: #wmNotify:wParam:lParam:!private! !

!FileDialog class methodsFor!

allFilesType
	"Private - Answer a two element array suitable for adding to the FileDialog
	with the fileTypes: message."

	^#('All Files (*.*)' '*.*')!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^Utf16String empty
!

icon
	^##(self) defaultIcon!

initializeDefaultHooks
	super initializeDefaultHooks.
	hookHandlers at: WM_NOTIFY put: #wmNotify:wParam:lParam:!

textFilesType
	^#('Text Files (*.txt)' '*.txt')! !
!FileDialog class categoriesFor: #allFilesType!constants!private! !
!FileDialog class categoriesFor: #defaultModel!models!public! !
!FileDialog class categoriesFor: #icon!constants!public! !
!FileDialog class categoriesFor: #initializeDefaultHooks!initializing!must not strip!private! !
!FileDialog class categoriesFor: #textFilesType!public! !

