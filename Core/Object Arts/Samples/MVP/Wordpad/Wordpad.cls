"Filed out from Dolphin Smalltalk 7"!

TextDocument subclass: #WordPad
	instanceVariableNames: ''
	classVariableNames: 'ResourceLib'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WordPad guid: (GUID fromString: '{daf98e5f-3a01-477d-b822-6b0e9bc79d14}')!
WordPad comment: 'Wordpad is a <topShell> sample application which implements a limited set of the functionality of the familiar Windows utility. Most of the implementation of the application is actually inherited from Dolphin''s TextDocument framework class or provided by RichTextPresenter and RichTextEdit.

Example:
	Wordpad show
'!
!WordPad categoriesForClass!Unclassified! !
!WordPad methodsFor!

about
	"Pop up a little helpful info. about this sample program."

	self class about!

documentPresenterClass
	^RichTextPresenter!

formatFont
	documentPresenter chooseSelectionFont!

formatParagraph
	WordpadParagraphDialog show!

getDocumentData
	"Private - Answer the data for the receiver's document"

	^self isRichText ifTrue: [self model value rtf] ifFalse: [self model value asString]!

insertDateAndTime
	| stream |
	stream := String writeStream.
	Time now printOn: stream format: 'HH:mm'.
	stream space.
	Date today printOn: stream longPicture: false.
	documentPresenter replaceSelection: stream contents!

isRichText
	"Answer true if the receiver is a text document. Overriden by subclasses
	to determine how the document data should be written and read"

	| fn |
	fn := self filename.
	^fn isNil or: [(File splitExtensionFrom: fn) = 'rtf']!

saveChangesPrompt
	| docName |
	docName := self hasFilename ifTrue: [File splitFilenameFrom: self filename] ifFalse: ['Document'].
	^'Save changes to <1s>?' expandMacrosWith: docName!

setDocumentData: aString 
	"Private - Set the data for the receiver's document to be anObject.
	Can be overidden by subclasses"

	super setDocumentData: ((aString beginsWith: '{\rtf') 
				ifTrue: [RichText fromRtf: aString]
				ifFalse: [RichText fromString: aString])! !
!WordPad categoriesFor: #about!commands!public! !
!WordPad categoriesFor: #documentPresenterClass!constants!public! !
!WordPad categoriesFor: #formatFont!commands!public! !
!WordPad categoriesFor: #formatParagraph!commands!public! !
!WordPad categoriesFor: #getDocumentData!private! !
!WordPad categoriesFor: #insertDateAndTime!commands!public! !
!WordPad categoriesFor: #isRichText!public!testing! !
!WordPad categoriesFor: #saveChangesPrompt!private! !
!WordPad categoriesFor: #setDocumentData:!accessing!private! !

!WordPad class methodsFor!

about
	"Private - Pop up a little helpful info. about this sample program."

	(MessageBox new)
		caption: ('About Dolphin <1d>' expandMacrosWith: self);
		icon: self icon;
		text: (self aboutTemplate expandMacrosWith: VMLibrary default fullVersion);
		open!

aboutTemplate
	"Private - Answer the text to be used in the receiver's about box"

	^'Simple Wordpad  Sample<n><1s><n>
This is a reduced functionality implementation of the standard system utility WORDPAD.EXE,
intended to demonstrate the DocumentShell and Rich Text hierarchies of Dolphin''s application framework.<n>
DISCLAIMER: This software is freely provided purely as an educational sample and as such it
is provided "as is", WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'!

addSamplesFolderIcon
	Smalltalk developmentSystem 
		addSamplesFolderIconFor: self
		description: self displayString
		helpId: 10624!

defaultAdditionalAccelerators
	"Answer a collection of additional accelerator definitions for commands not on the menu bar of the receiver's view(s).
	Each element of the collection should be a two element <Array>, the first element of which is the command symbol
	and the second the accelerator key string."

	^#(#(#toggleBold 'Ctrl+B') #(#toggleItalic 'Ctrl+I') #(#toggleUnderlined 'Ctrl+U'))
!

fileTypes
	"Answer an Array of file types that can be associated with this class of document."

	^Array 
		with: #('Rich Text Files (*.rtf)' '*.rtf')
		with: #('Text Files (*.txt)' '*.txt')
		with: FileDialog allFilesType!

icon
	"Answers an Icon that can be used to represent this class."

	^Icon fromId: 2 in: (ExternalResourceLibrary open: 'Shell32')!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	self addSamplesFolderIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(ColorRef)  8 4278190080 0 551 0 0 0 416 788230 ##(BorderLayout)  1 1 410 8 ##(Toolbar)  98 25 0 416 98 2 8 1140851468 131137 560 0 482 512 0 519 0 263174 ##(Font)  0 16 459014 ##(LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Point)  193 193 0 560 482 512 8 4294907173 234 256 98 0 234 256 98 22 13055 1246982 ##(ToolbarSystemButton)  13055 0 560 1 1180998 4 ##(CommandDescription)  8 #fileNew 8 'New' 1 1 0 1 13 13057 866 13057 0 560 1 898 8 #fileOpen 8 'Open' 1 1 0 1 15 13059 866 13059 0 560 1 898 8 #fileSave 8 'Save' 1 1 0 1 17 13061 866 13061 0 560 1 898 8 #printDocument 8 'Print' 1 1 0 1 29 13063 866 13063 0 560 1 898 8 #printPreview 8 'Print Preview' 1 1 0 1 19 13065 866 13065 0 560 1 898 8 #find 8 'Find' 1 1 0 1 25 13067 866 13067 0 560 1 898 8 #cutSelection 8 'Cut' 1 1 0 1 1 13069 866 13069 0 560 1 898 8 #copySelection 8 'Copy' 1 1 0 1 3 13071 866 13071 0 560 1 898 8 #pasteSelection 8 'Paste' 1 1 0 1 5 13073 866 13073 0 560 1 898 8 #clearSelection 8 'Delete' 1 1 0 1 11 13075 866 13075 0 560 1 898 8 #undo 8 'Undo' 1 1 0 1 7 98 14 880 960 1024 1050118 ##(ToolbarSeparator)  0 0 560 3 0 1 1088 1152 1618 0 0 560 3 0 11 1216 1618 0 0 560 3 0 1 1280 1344 1408 1472 1536 234 240 98 2 1 1 0 1 0 738 33 33 738 45 45 0 656198 1 ##(FlowLayout)  1 1 1 983302 ##(MessageSequence)  202 208 98 2 721670 ##(MessageSend)  8 #createAt:extent: 98 2 738 1 1 738 1265 51 560 1842 8 #updateSize 816 560 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 120 2 0 0 25 0 0 0] 98 0 738 193 193 0 27 410 8 ##(StatusBar)  98 18 0 416 98 2 8 1140850956 1 2048 0 482 512 0 7 0 658 0 16 690 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 738 193 193 0 2048 0 8 4294906895 234 256 98 2 853766 ##(StatusBarItem)  1 -1 2048 0 459270 ##(Message)  8 #displayString 98 0 787814 3 ##(BlockClosure)  0 0 918822 ##(CompiledMethod)  3 3 2256 8 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] 8 #icon 8 #imageIndex 2368 7 257 0 1114638 ##(STBSingletonProxy)  8 ##(IconImageManager)  8 #current 8 'status' 98 1 2272 1115142 ##(StatusBarNullItem)  513 1 2048 0 0 1778 202 208 98 1 1842 1872 98 2 738 1 809 738 1265 45 2048 1970 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 1 0 0 120 2 0 0 170 1 0 0] 98 0 2032 0 27 0 0 410 8 ##(RichTextEdit)  98 18 0 416 98 2 8 1143017796 262145 2768 721990 2 ##(ValueHolder)  0 32 2490 8 ##(SearchPolicy)  8 #equality 524550 ##(RichText)  8 '{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\lang1033\f0\fs16 
\par }
' 482 512 0 23 265030 4 ##(Menu)  0 16 98 10 984134 2 ##(CommandMenuItem)  1 898 1312 8 'Cu&t' 1 1 0 0 0 3042 1 898 1376 8 '&Copy' 1 1 0 0 0 3042 1 898 8 #pasteClipboard 8 '&Paste' 1 1 0 0 0 983366 1 ##(DividerMenuItem)  4097 3042 1 898 8 #formatFont 8 '&Font...' 1 1 0 0 0 3042 1 898 8 #toggleBulletStyle 8 '&Bullet Style' 1 1 0 0 0 3042 1 898 8 #formatParagraph 8 'P&aragraph...' 1 1 0 0 0 3218 4097 3042 1 898 8 #objectProperties 8 'Object P&roperties...' 1025 1 0 0 0 3042 1 898 8 #editObject 8 '&Object' 1 1 0 0 0 8 '&Workspace' 0 1 0 0 0 0 0 0 0 2768 0 8 1961167625 852486 ##(NullConverter)  0 0 25 0 655622 ##(EDITSTREAM)  8 #[0 0 0 0 0 0 0 0 160 162 191 2] 1778 202 208 98 6 1842 1872 98 2 738 1 51 738 1265 759 2768 1842 8 #contextMenu: 98 1 3008 2768 1842 8 #text: 98 1 2930 8 '{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\lang1033\f0\fs16 
\par }
' 2768 1842 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 2768 1842 8 #isTextModified: 98 1 32 2768 1842 8 #resetCharFormat 816 2768 1970 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 120 2 0 0 148 1 0 0] 98 0 2032 0 27 234 256 98 6 2768 8 'document' 560 8 'toolbar' 2048 8 'statusbar' 0 461638 4 ##(MenuBar)  0 16 98 6 2994 0 16 98 11 3042 1 898 928 8 '&New' 9373 1 0 0 0 3042 1 898 992 8 '&Open...' 9375 1 0 0 0 3042 1 898 1056 8 '&Save' 8359 1 0 0 0 3042 1 898 8 #fileSaveAs 8 'Save &As...' 1 1 0 0 0 3218 4097 3042 1 898 8 #filePrint 8 '&Print...' 9377 1 0 0 0 3042 1 898 8 #filePageSetup 8 'Page Set&up...' 1 1 0 0 0 3218 4097 3042 1 898 8 #sendDocument 8 'Sen&d...' 1 1 0 0 0 3218 4097 3042 1 898 8 #exit 8 'E&xit' 1025 1 0 0 0 8 '&File' 0 1 0 0 13139 0 0 2994 0 16 98 16 3042 1 898 1568 8 '&Undo' 9397 1 0 0 0 3218 4097 3042 1 898 1312 8 'Cu&t' 9393 1 0 0 0 3042 1 898 1376 8 '&Copy' 9351 1 0 0 0 3042 1 898 3184 8 '&Paste' 9389 1 0 0 0 3042 1 898 8 #pasteSpecial 8 'Paste &Special...' 1 1 0 0 0 3042 1 898 1504 8 'Cle&ar' 1629 1 0 0 0 3042 1 898 8 #selectAll 8 'Select All' 9347 1 0 0 0 3218 4097 3042 1 898 1248 8 '&Find...' 9357 1 0 0 0 3042 1 898 8 #findNext 8 'Find &Next' 1253 1 0 0 0 3042 1 898 8 #findReplace 8 'R&eplace...' 9361 1 0 0 0 3218 4097 3042 1 898 8 #links 8 'Lin&ks...' 1 1 0 0 0 3042 1 898 3488 8 'Object P&roperties...' 1025 1 0 0 0 3042 1 898 3552 8 '&Object' 1 1 0 0 0 8 '&Edit' 0 1 0 0 13167 0 0 2994 0 16 98 6 3042 1025 898 8 #viewToolbar 8 '&Toolbar' 1025 1 0 0 0 3042 1025 898 8 #viewFormatBar 8 '&Format Bar' 1025 1 0 0 0 3042 1025 898 8 #viewRuler 8 '&Ruler' 1025 1 0 0 0 3042 1025 898 8 #viewStatusBar 8 '&Status Bar' 1025 1 0 0 0 3218 4097 3042 1 898 8 #viewOptions 8 '&Options...' 1 1 0 0 0 8 '&View' 0 1 0 0 13179 0 0 2994 0 16 98 2 3042 1 898 8 #insertDateAndTime 8 '&Date and Time...' 1 1 0 0 0 3042 1 898 8 #insertObject 8 '&Object...' 1 1 0 0 0 8 '&Insert' 0 1 0 0 13185 0 0 2994 0 16 98 4 3042 1 898 3280 8 '&Font...' 1 1 0 0 0 3042 1 898 3344 8 '&Bullet Style' 1 1 0 0 0 3042 1 898 3408 8 '&Paragraph...' 1 1 0 0 0 3042 1 898 8 #formatTabs 8 '&Tabs...' 1 1 0 0 0 8 'F&ormat' 0 1 0 0 13195 0 0 2994 0 16 98 3 3042 1 898 8 #help 8 '&Help Topics' 1025 1 0 0 0 3218 4097 3042 1 898 8 #about 8 '&About Dolphin WordPad' 1 1 0 0 0 8 '&Help' 0 1 0 0 13201 0 0 8 '' 0 1 0 0 0 0 0 0 1049350 ##(AcceleratorTable)  0 16 98 20 721414 ##(Association)  9373 4320 6706 9375 4368 6706 8359 4416 6706 9377 4544 6706 1025 4768 6706 9397 4880 6706 9393 4944 6706 9351 4992 6706 9389 5040 6706 1629 5152 6706 9347 5200 6706 9357 5280 6706 1253 5328 6706 9361 5392 6706 1025 5536 6706 1025 5680 6706 1025 5744 6706 1025 5808 6706 1025 5872 6706 1025 6496 2768 1 0 0 0 0 1 0 0 1778 202 208 98 3 1842 1872 98 2 738 20001 20001 738 1281 961 416 1842 3872 98 1 8 'Dolphin WordPad' 416 1842 8 #menuBar: 98 1 4240 416 1970 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 39 0 0 16 39 0 0 144 41 0 0 240 40 0 0] 98 3 560 2768 2048 2032 0 27 )!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system.
		self uninitialize
	"

	Smalltalk developmentSystem removeSystemFolderIconNamed: self displayString! !
!WordPad class categoriesFor: #about!enquiries!private! !
!WordPad class categoriesFor: #aboutTemplate!enquiries!private! !
!WordPad class categoriesFor: #addSamplesFolderIcon!development!initializing!private! !
!WordPad class categoriesFor: #defaultAdditionalAccelerators!private! !
!WordPad class categoriesFor: #fileTypes!public! !
!WordPad class categoriesFor: #icon!constants!public! !
!WordPad class categoriesFor: #initialize!development!initializing!private! !
!WordPad class categoriesFor: #resource_Default_view!public!resources-views! !
!WordPad class categoriesFor: #uninitialize!development!initializing!private! !

