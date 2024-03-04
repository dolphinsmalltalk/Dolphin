"Filed out from Dolphin Smalltalk"!

UI.CommonDialog
	subclass: #'UI.FileDialog'
	instanceVariableNames: 'style fileTypes validationBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.FileDialog guid: (Core.GUID fromString: '{87b4c6b1-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.FileDialog isNonInstantiable: true!

UI.FileDialog comment: 'FileDialog is an abstract superclass for <valueDialogPresenter>s implementing the Windows common file dialogs. 

'!

!UI.FileDialog categoriesForClass!MVP-Presenters! !

!UI.FileDialog methodsFor!

allFilesType
	"Private - Answer a file spec. pair suitable for adding to the FileDialog
	with the fileTypes: message."

	^self class allFilesType!

averageFilenameLength
	^30!

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
	"Private - Determines whether an item should be displayed. The argument is a pointer to an OFNOTIFYEX structure. When the user opens a new folder or directory, the dialog sends this notification for each item in the folder or directory, but only if the OFN_ENABLEINCLUDENOTIFY flag was set. "

	^1!

cdnInitDone: anExternalAddress
	"Private - Initialisation of the dialog box is complete."

	self setInitialPosition.
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

	^##(OFN_HIDEREADONLY | OFN_EXPLORER | OFN_ENABLESIZING | OFN_ENABLEHOOK)!

dialogView
	"Answer a <View> wrapping the actual dialog."

	"For a file dialog in OFN_EXPLORER mode, the receiver's view is actually a child. We need to answer the parent, which is the real top-level dialog."

	^self view parentView!

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

	| stream |
	stringPairs isNil ifTrue: [^nil].
	stream := Utf16String writeStream: 40.
	stringPairs do: 
			[:x |
			stream
				nextPutAll: x first;
				nextPut: $\0;
				nextPutAll: x last;
				nextPut: $\0].
	^stream
		nextPut: $\0;
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
	"It is generally better to use system placement for the file dialogs as they are large and difficult to place well."
	positioning := #system.
	self fileTypes: {self allFilesType}.
	style := self defaultStyle.
	validationBlock := [:path | true]!

maxFileCount
	"Answers the maximum number of selections that can be expected to fit into the buffer."

	^1!

prepareStruct
	"Private - Initialize the parameter structure to be passed to the Win32 API associated with this common dialog, immediately prior to the call to that API."

	| buf defext |
	buf := Utf16String newFixed: self maxFileCount * self averageFilenameLength + MAX_PATH.
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
	"Set the <monadicValuable> used to validate the user's reply. The valuable is passed the
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
		yourself) lookup: ##(CDN_FIRST + 1) - (ptr int32AtOffset: 8))
		ifNil: [0]
		ifNotNil: [:action | self perform: action with: ptr]! !

!UI.FileDialog categoriesForMethods!
allFilesType!constants!private! !
averageFilenameLength!constants!private! !
caption:!accessing!public! !
cdnFileOk:!event handling-win32!private! !
cdnFolderChange:!event handling-win32!private! !
cdnHelp:!event handling-win32!private! !
cdnIncludeItem:!event handling-win32!private! !
cdnInitDone:!event handling-win32!private! !
cdnSelChange:!event handling-win32!private! !
cdnShareViolation:!event handling-win32!private! !
cdnTypeChange:!event handling-win32!private! !
defaultExtension!accessing!public! !
defaultExtension:!accessing!public! !
defaultStyle!constants!public! !
dialogView!public! !
extractPathNames:!helpers!private! !
extractResult:!helpers!private! !
fileTypes!accessing!public! !
fileTypes:!accessing!public! !
fileTypesStringFromSpecs:!helpers!private! !
filterIndex!accessing!public! !
filterIndex:!accessing!public! !
getFilePath!operations!private! !
getFileSpec!operations!private! !
initialDirectory:!accessing!public! !
initialize!initializing!private! !
maxFileCount!accessing!public! !
prepareStruct!helpers!private! !
style!accessing!public! !
style:!accessing!public! !
validationBlock!accessing!public! !
validationBlock:!initializing!public! !
winStructClass!accessing!private! !
wmInitDialog:wParam:lParam:!event handling-win32!private! !
wmNotify:wParam:lParam:!private! !
!

!UI.FileDialog class methodsFor!

allFilesType
	"Private - Answer a two element array suitable for adding to the FileDialog
	with the fileTypes: message."

	^#('All Files (*.*)' '*.*')!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^Utf16String empty!

icon
	^##(self) defaultIcon!

initializeDefaultHooks
	super initializeDefaultHooks.
	hookHandlers at: WM_NOTIFY put: #wmNotify:wParam:lParam:!

textFilesType
	^#('Text Files (*.txt)' '*.txt')! !

!UI.FileDialog class categoriesForMethods!
allFilesType!constants!private! !
defaultModel!models!public! !
icon!constants!public! !
initializeDefaultHooks!initializing!must not strip!private! !
textFilesType!public! !
!

