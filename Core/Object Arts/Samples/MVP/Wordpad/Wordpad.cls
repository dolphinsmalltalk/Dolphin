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
	| paraformat |
	paraformat := documentPresenter view selectionParaFormat.
	(WordpadParagraphDialog showModalOn: paraformat) ifNotNil: [documentPresenter view selectionParaFormat: paraformat]!

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

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853516 131137 544 nil 480 nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 544 480 8 1915204752 170 192 8 #() 170 192 34 22 64329 1246790 1 ##(Smalltalk.ToolbarSystemButton) 544 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 'New' 1 1 nil 64329 1 13 64331 802 544 1 834 #fileOpen 8 'Open' 1 1 nil 64331 1 15 64333 802 544 1 834 #fileSave 8 'Save' 1 1 nil 64333 1 17 64335 802 544 1 834 #printDocument 8 'Print' 1 1 nil 64335 1 29 64337 802 544 1 834 #printPreview 8 'Print Preview' 1 1 nil 64337 1 19 64339 802 544 1 834 #find 8 'Find' 1 1 nil 64339 1 25 64341 802 544 1 834 #cutSelection 8 'Cut' 1 1 nil 64341 1 1 64343 802 544 1 834 #copySelection 8 'Copy' 1 1 nil 64343 1 3 64345 802 544 1 834 #pasteSelection 8 'Paste' 1 1 nil 64345 1 5 64347 802 544 1 834 #clearSelection 8 'Delete' 1 1 nil 64347 1 11 64349 802 544 1 834 #undo 8 'Undo' 1 1 nil 64349 1 7 34 14 816 880 928 1049158 1 ##(Smalltalk.ToolbarSeparator) 544 1 976 1024 1378 544 11 1072 1378 544 1 1120 1168 1216 1264 1312 nil nil 1 nil 690 33 33 690 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 690 1 1 690 1249 51 544 1570 #updateSizePosted 752 544 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 25 0 0 0] 8 #() 690 193 193 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 1744 nil 480 nil 7 nil 610 nil true 642 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 690 193 193 nil 1744 nil 8 1914952576 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 1744 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 3 3 1920 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] #icon #imageIndex 2016 7 257 nil nil 8 'status' 34 1 1936 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1744 nil nil 1506 138 144 34 1 1570 #createAt:extent: 34 2 690 1 799 690 1249 45 1744 1666 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 1 0 0 112 2 0 0 165 1 0 0] 8 #() 1728 nil 27 nil nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 416 34 2 8 1143017796 262145 2304 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) 524550 ##(Smalltalk.RichText) 8 '{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\lang1033\f0\fs16 
\par }
' 480 nil 23 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 834 #cutSelection 8 'Cu&t' 1 1 nil nil nil 2530 1 834 #copySelection 8 '&Copy' 1 1 nil nil nil 2530 1 834 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2530 1 834 #formatFont 8 '&Font...' 1 1 nil nil nil 2530 1 834 #toggleBulletStyle 8 '&Bullet Style' 1 1 nil nil nil 2530 1 834 #formatParagraph 8 'P&aragraph...' 1 1 nil nil nil 2690 4097 2530 1 834 #objectProperties 8 'Object P&roperties...' 1025 1 nil nil nil 2530 1 834 #editObject 8 '&Object' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 2304 nil 8 1919505872 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 16 0 17 4] 1506 138 144 34 5 1570 #createAt:extent: 34 2 690 1 51 690 1249 749 2304 1570 #contextMenu: 34 1 2496 2304 1570 #text: 34 1 2434 8 '{\urtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\lang1033\f0\fs16\par
}
' 2304 1570 #textLimit: 8 #(1073741823) 2304 1570 #resetCharFormat 752 2304 1666 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 112 2 0 0 143 1 0 0] 8 #() 1728 nil 27 170 192 34 6 544 8 'toolbar' 2304 8 'document' 1744 8 'statusbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 2482 nil true 34 11 2530 1 834 #fileNew 8 '&New' 9373 1 nil nil nil 2530 1 834 #fileOpen 8 '&Open...' 9375 1 nil nil nil 2530 1 834 #fileSave 8 '&Save' 8359 1 nil nil nil 2530 1 834 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 2690 4097 2530 1 834 #filePrint 8 '&Print...' 9377 1 nil nil nil 2530 1 834 #filePageSetup 8 'Page Set&up...' 1 1 nil nil nil 2690 4097 2530 1 834 #sendDocument 8 'Sen&d...' 1 1 nil nil nil 2690 4097 2530 1 834 #exit 8 'E&xit' 1025 1 nil nil nil 8 '&File' nil 1 nil nil 64265 nil nil 2482 nil true 34 16 2530 1 834 #undo 8 '&Undo' 9397 1 nil nil nil 2690 4097 2530 1 834 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 2530 1 834 #copySelection 8 '&Copy' 9351 1 nil nil nil 2530 1 834 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 2530 1 834 #pasteSpecial 8 'Paste &Special...' 1 1 nil nil nil 2530 1 834 #clearSelection 8 'Cle&ar' 1629 1 nil nil nil 2530 1 834 #selectAll 8 'Select All' 9347 1 nil nil nil 2690 4097 2530 1 834 #find 8 '&Find...' 9357 1 nil nil nil 2530 1 834 #findNext 8 'Find &Next' 1253 1 nil nil nil 2530 1 834 #findReplace 8 'R&eplace...' 9361 1 nil nil nil 2690 4097 2530 1 834 #links 8 'Lin&ks...' 1 1 nil nil nil 2530 1 834 #objectProperties 8 'Object P&roperties...' 1025 1 nil nil nil 2530 1 834 #editObject 8 '&Object' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil 64293 nil nil 2482 nil true 34 6 2530 1025 834 #viewToolbar 8 '&Toolbar' 1025 1 nil nil nil 2530 1025 834 #viewFormatBar 8 '&Format Bar' 1025 1 nil nil nil 2530 1025 834 #viewRuler 8 '&Ruler' 1025 1 nil nil nil 2530 1025 834 #viewStatusBar 8 '&Status Bar' 1025 1 nil nil nil 2690 4097 2530 1 834 #viewOptions 8 '&Options...' 1 1 nil nil nil 8 '&View' nil 1 nil nil 64305 nil nil 2482 nil true 34 2 2530 1 834 #insertDateAndTime 8 '&Date and Time...' 1 1 nil nil nil 2530 1 834 #insertObject 8 '&Object...' 1 1 nil nil nil 8 '&Insert' nil 1 nil nil 64311 nil nil 2482 nil true 34 4 2530 1 834 #formatFont 8 '&Font...' 1 1 nil nil nil 2530 1 834 #toggleBulletStyle 8 '&Bullet Style' 1 1 nil nil nil 2530 1 834 #formatParagraph 8 '&Paragraph...' 1 1 nil nil nil 2530 1 834 #formatTabs 8 '&Tabs...' 1 1 nil nil nil 8 'F&ormat' nil 1 nil nil 64321 nil nil 2482 nil true 34 3 2530 1 834 #help 8 '&Help Topics' 1025 1 nil nil nil 2690 4097 2530 1 834 #about 8 '&About Dolphin WordPad' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 64327 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1506 138 144 34 3 1570 #createAt:extent: 34 2 690 3839 21 690 1281 961 416 1570 #text: 34 1 8 'Dolphin WordPad' 416 1570 #updateMenuBar 752 416 1666 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 255 9 0 0 234 1 0 0] 34 3 544 2304 1744 1728 nil 27 )! !
!WordPad class categoriesFor: #about!enquiries!private! !
!WordPad class categoriesFor: #aboutTemplate!enquiries!private! !
!WordPad class categoriesFor: #defaultAdditionalAccelerators!private! !
!WordPad class categoriesFor: #fileTypes!public! !
!WordPad class categoriesFor: #icon!constants!public! !
!WordPad class categoriesFor: #resource_Default_view!public!resources-views! !

