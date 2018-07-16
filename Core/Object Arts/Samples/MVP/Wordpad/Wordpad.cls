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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853516 131137 544 nil 466 496 nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 544 466 496 8 1909124416 170 192 8 #() 170 192 34 22 50749 1246790 1 ##(Smalltalk.ToolbarSystemButton) 544 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 'New' 1 1 nil 50749 1 13 50751 834 544 1 866 #fileOpen 8 'Open' 1 1 nil 50751 1 15 50753 834 544 1 866 #fileSave 8 'Save' 1 1 nil 50753 1 17 50755 834 544 1 866 #printDocument 8 'Print' 1 1 nil 50755 1 29 50757 834 544 1 866 #printPreview 8 'Print Preview' 1 1 nil 50757 1 19 50759 834 544 1 866 #find 8 'Find' 1 1 nil 50759 1 25 50761 834 544 1 866 #cutSelection 8 'Cut' 1 1 nil 50761 1 1 50763 834 544 1 866 #copySelection 8 'Copy' 1 1 nil 50763 1 3 50765 834 544 1 866 #pasteSelection 8 'Paste' 1 1 nil 50765 1 5 50767 834 544 1 866 #clearSelection 8 'Delete' 1 1 nil 50767 1 11 50769 834 544 1 866 #undo 8 'Undo' 1 1 nil 50769 1 7 34 14 848 912 960 1049158 1 ##(Smalltalk.ToolbarSeparator) 544 1 1008 1056 1410 544 11 1104 1410 544 1 1152 1200 1248 1296 1344 170 176 8 #(0 0) nil 1 nil 706 33 33 706 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 706 1 1 706 1249 51 544 1634 #updateSizePosted 784 544 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 25 0 0 0] 8 #() 706 193 193 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 1808 nil 466 496 nil 7 nil 626 nil true 658 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 706 193 193 nil 1808 nil 8 1908856784 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 1808 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 3 3 2000 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] #icon #imageIndex 2096 7 257 nil 1049926 1 ##(Smalltalk.IconImageManager) 8 'status' 34 1 2016 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1808 nil nil 1570 138 144 34 1 1634 #createAt:extent: 34 2 706 1 799 706 1249 45 1808 1730 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 1 0 0 112 2 0 0 165 1 0 0] 8 #() 1792 nil 27 nil nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 416 34 2 8 1143017796 262145 2416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) 524550 ##(Smalltalk.RichText) 8 '{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\lang1033\f0\fs16 
\par }
' 466 496 nil 23 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 866 #cutSelection 8 'Cu&t' 1 1 nil nil nil 2658 1 866 #copySelection 8 '&Copy' 1 1 nil nil nil 2658 1 866 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2658 1 866 #formatFont 8 '&Font...' 1 1 nil nil nil 2658 1 866 #toggleBulletStyle 8 '&Bullet Style' 1 1 nil nil nil 2658 1 866 #formatParagraph 8 'P&aragraph...' 1 1 nil nil nil 2818 4097 2658 1 866 #objectProperties 8 'Object P&roperties...' 1025 1 nil nil nil 2658 1 866 #editObject 8 '&Object' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 2416 nil 8 1878735728 852486 ##(Smalltalk.NullConverter) nil nil 25 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 16 0 235 3] 1570 138 144 34 5 1634 #createAt:extent: 34 2 706 1 51 706 1249 749 2416 1634 #contextMenu: 34 1 2624 2416 1634 #text: 34 1 2546 8 '{\urtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\lang1033\f0\fs16\par
}
' 2416 1634 #textLimit: 8 #(1073741823) 2416 1634 #resetCharFormat 784 2416 1730 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 112 2 0 0 143 1 0 0] 8 #() 1792 nil 27 170 192 34 6 544 8 'toolbar' 1808 8 'statusbar' 2416 8 'document' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 2610 nil true 34 11 2658 1 866 #fileNew 8 '&New' 9373 1 nil nil nil 2658 1 866 #fileOpen 8 '&Open...' 9375 1 nil nil nil 2658 1 866 #fileSave 8 '&Save' 8359 1 nil nil nil 2658 1 866 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 2818 4097 2658 1 866 #filePrint 8 '&Print...' 9377 1 nil nil nil 2658 1 866 #filePageSetup 8 'Page Set&up...' 1 1 nil nil nil 2818 4097 2658 1 866 #sendDocument 8 'Sen&d...' 1 1 nil nil nil 2818 4097 2658 1 866 #exit 8 'E&xit' 1025 1 nil nil nil 8 '&File' nil 1 nil nil 50685 nil nil 2610 nil true 34 16 2658 1 866 #undo 8 '&Undo' 9397 1 nil nil nil 2818 4097 2658 1 866 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 2658 1 866 #copySelection 8 '&Copy' 9351 1 nil nil nil 2658 1 866 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 2658 1 866 #pasteSpecial 8 'Paste &Special...' 1 1 nil nil nil 2658 1 866 #clearSelection 8 'Cle&ar' 1629 1 nil nil nil 2658 1 866 #selectAll 8 'Select All' 9347 1 nil nil nil 2818 4097 2658 1 866 #find 8 '&Find...' 9357 1 nil nil nil 2658 1 866 #findNext 8 'Find &Next' 1253 1 nil nil nil 2658 1 866 #findReplace 8 'R&eplace...' 9361 1 nil nil nil 2818 4097 2658 1 866 #links 8 'Lin&ks...' 1 1 nil nil nil 2658 1 866 #objectProperties 8 'Object P&roperties...' 1025 1 nil nil nil 2658 1 866 #editObject 8 '&Object' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil 50713 nil nil 2610 nil true 34 6 2658 1025 866 #viewToolbar 8 '&Toolbar' 1025 1 nil nil nil 2658 1025 866 #viewFormatBar 8 '&Format Bar' 1025 1 nil nil nil 2658 1025 866 #viewRuler 8 '&Ruler' 1025 1 nil nil nil 2658 1025 866 #viewStatusBar 8 '&Status Bar' 1025 1 nil nil nil 2818 4097 2658 1 866 #viewOptions 8 '&Options...' 1 1 nil nil nil 8 '&View' nil 1 nil nil 50725 nil nil 2610 nil true 34 2 2658 1 866 #insertDateAndTime 8 '&Date and Time...' 1 1 nil nil nil 2658 1 866 #insertObject 8 '&Object...' 1 1 nil nil nil 8 '&Insert' nil 1 nil nil 50731 nil nil 2610 nil true 34 4 2658 1 866 #formatFont 8 '&Font...' 1 1 nil nil nil 2658 1 866 #toggleBulletStyle 8 '&Bullet Style' 1 1 nil nil nil 2658 1 866 #formatParagraph 8 '&Paragraph...' 1 1 nil nil nil 2658 1 866 #formatTabs 8 '&Tabs...' 1 1 nil nil nil 8 'F&ormat' nil 1 nil nil 50741 nil nil 2610 nil true 34 3 2658 1 866 #help 8 '&Help Topics' 1025 1 nil nil nil 2818 4097 2658 1 866 #about 8 '&About Dolphin WordPad' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 50747 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1570 138 144 34 3 1634 #createAt:extent: 34 2 706 3839 21 706 1281 961 416 1634 #text: 34 1 8 'Dolphin WordPad' 416 1634 #updateMenuBar 784 416 1730 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 255 9 0 0 234 1 0 0] 34 3 544 2416 1808 1792 nil 27 )!

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

