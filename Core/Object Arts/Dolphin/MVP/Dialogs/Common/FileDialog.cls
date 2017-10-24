"Filed out from Dolphin Smalltalk 7"!

CommonDialog subclass: #FileDialog
	instanceVariableNames: 'style fileTypes validationBlock'
	classVariableNames: 'CDNMap'
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

basicShowModal
	"Private - Show a Open File dialog for the receiver."

	^ComDlgLibrary default perform: self commonDialogSelector with: winStruct!

caption: aString 
	"Sets the caption for the receiver to aString"

	self winStruct title: aString!

cdnFileOk: anExternalAddress 
	"Private - The user clicked the OK button; the dialog is about to close. Return 0 to accept the
	filename choice, or non-zero to reject it."

	| ofn file |
	ofn := OFNOTIFY fromAddress: anExternalAddress.
	file := ofn lpOFN lpstrFile.
	^(validationBlock value: file) 
		ifTrue: [0]
		ifFalse: 
			[UserLibrary default 
				setWindowLong: view handle
				nIndex: DWL_MSGRESULT
				dwNewLong: 1.
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
	ofnex := OFNOTIFYEX fromAddress: anExternalAddress.
	ofnex.
	^1!

cdnInitDone: anExternalAddress 
	"Private - Initialisation of the dialog box is complete."

	| ofn |
	ofn := OFNOTIFY fromAddress: anExternalAddress.
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

extractResult: result 
	"Private - Extract and apply the result from the parameter structure 
	passed to the Win32 API associated with this common dialog, immediately 
	after the call to that API."

	result ifFalse: [^self].
	self value: self winStruct lpstrFile.
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

	stream := WriteStream on: (String new: 40).
	null := Character null.
	stringPairs do: [:x | 
		stream
			nextPutAll: x first;
			nextPut: null;
			nextPutAll: x last;
			nextPut: null ].
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

	| len buf |
	buf := File pathBuffer.
	len := view parentView 
				sendMessage: CDM_GETFILEPATH
				wParam: buf byteSize
				lpParam: buf.
	buf resize: len - 1.
	^buf!

getFileSpec
	"Retrieve the file name (sans path) as currently specified in the dialog. This can be called
	during notifications from the dialog such as CDN_SELCHANGE."

	| len buf |
	buf := File pathBuffer.
	len := view parentView 
				sendMessage: CDM_GETSPEC
				wParam: buf byteSize
				lpParam: buf.
	buf resize: len - 1.
	^buf!

initialDirectory: aString
	"Set the initial directory path name to be opened/saved."

	self winStruct initialDirectory: aString!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self fileTypes: (Array with: self allFilesType).
	style := self defaultStyle.
	validationBlock := [:path | true]!

prepareStruct
	"Private - Initialize the parameter structure to be passed to the Win32 API associated with
	this common dialog, immediately prior to the call to that API."

	| buf filename defext |
	buf := File pathBuffer.
	filename := self value.
	filename notNil 
		ifTrue: 
			[buf 
				replaceFrom: 1
				to: filename size
				with: filename].
	(self filterIndex = 0 and: [(defext := self defaultExtension) notNil]) 
		ifTrue: [self filterIndex: (self fileTypes findFirst: [:pair | (pair last findString: defext) ~~ 0])].
	(self winStruct)
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

	^OPENFILENAME!

wmInitDialog: message wParam: wParam lParam: lParam 
	"Private - A WM_INITDIALOG message was sent to the hook procedure. This is sent after the common
	dialog itself has handled the message."

	"Implementation Note: We don't need to set the caption here, since in this case the
	initialisation structure has a field for the dialog title."

	^0!

wmNotify: msgInteger wParam: wParamInteger lParam: lParamInteger
	| ptr |
	ptr := lParamInteger asExternalAddress.
	^(CDNMap lookup: CDN_FIRST - (ptr sdwordAtOffset: 8) + 1)
		ifNil: [0]
		ifNotNil: [:action | self perform: action with: ptr]! !
!FileDialog categoriesFor: #allFilesType!constants!private! !
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
!FileDialog categoriesFor: #prepareStruct!helpers!private! !
!FileDialog categoriesFor: #style!accessing!public! !
!FileDialog categoriesFor: #style:!accessing!public! !
!FileDialog categoriesFor: #validationBlock!accessing!public! !
!FileDialog categoriesFor: #validationBlock:!accessing!public! !
!FileDialog categoriesFor: #winStructClass!accessing!private! !
!FileDialog categoriesFor: #wmInitDialog:wParam:lParam:!event handling-win32!private! !
!FileDialog categoriesFor: #wmNotify:wParam:lParam:!private! !

!FileDialog class methodsFor!

allFilesType
	"Private - Answer a two element array suitable for adding to the FileDialog
	with the fileTypes: message."

	^#('All Files (*.*)' '*.*')!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^String new asValue
!

icon
	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	CDNMap := #(#cdnInitDone: #cdnSelChange: #cdnFolderChange: #cdnShareViolation: #cdnHelp: #cdnFileOk: #cdnTypeChange: #cdnIncludeItem:)!

initializeDefaultHooks
	super initializeDefaultHooks.
	hookHandlers at: WM_NOTIFY put: #wmNotify:wParam:lParam:!

textFilesType
	^#('Text Files (*.txt)' '*.txt')! !
!FileDialog class categoriesFor: #allFilesType!constants!private! !
!FileDialog class categoriesFor: #defaultModel!models!public! !
!FileDialog class categoriesFor: #icon!constants!public! !
!FileDialog class categoriesFor: #initialize!initializing!private! !
!FileDialog class categoriesFor: #initializeDefaultHooks!initializing!private! !
!FileDialog class categoriesFor: #textFilesType!public! !

