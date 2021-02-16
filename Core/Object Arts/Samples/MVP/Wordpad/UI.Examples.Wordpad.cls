"Filed out from Dolphin Smalltalk 7"!

UI.TextDocument subclass: #WordPad
	instanceVariableNames: ''
	classVariableNames: 'ResourceLib'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WordPad guid: (Core.GUID fromString: '{daf98e5f-3a01-477d-b822-6b0e9bc79d14}')!
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
	| stream now locale |
	stream := String writeStream.
	now := DateAndTime now.
	locale := Locale default.
	now printOn: stream format: locale shortTimeFormat, ' ', locale shortDateFormat.
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

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'WordPad'!

fileTypes
	"Answer an Array of file types that can be associated with this class of document."

	^{#('Rich Text Files (*.rtf)' '*.rtf'). #('Text Files (*.txt)' '*.txt'). FileDialog allFilesType}!

icon
	"Answers an Icon that can be used to represent this class."

	^Icon fromId: 2 in: (ExternalResourceLibrary open: 'Shell32')!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853516 131137 528 nil 480 nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 528 480 8 1903898080 170 192 8 #() 170 192 34 22 14243 1246790 1 ##(Smalltalk.ToolbarSystemButton) 528 1 1180998 4 ##(Smalltalk.CommandDescription) #undo 8 'Undo' 1 1 nil 14243 1 7 14239 786 528 1 818 #pasteSelection 8 'Paste' 1 1 nil 14239 1 5 14235 786 528 1 818 #cutSelection 8 'Cut' 1 1 nil 14235 1 1 14231 786 528 1 818 #printPreview 8 'Print Preview' 1 1 nil 14231 1 19 14227 786 528 1 818 #fileSave 8 'Save' 1 1 nil 14227 1 17 14223 786 528 1 818 #fileNew 8 'New' 1 1 nil 14223 1 13 14241 786 528 1 818 #clearSelection 8 'Delete' 1 1 nil 14241 1 11 14237 786 528 1 818 #copySelection 8 'Copy' 1 1 nil 14237 1 3 14233 786 528 1 818 #find 8 'Find' 1 1 nil 14233 1 25 14229 786 528 1 818 #printDocument 8 'Print' 1 1 nil 14229 1 29 14225 786 528 1 818 #fileOpen 8 'Open' 1 1 nil 14225 1 15 34 14 1056 1296 1008 1049158 1 ##(Smalltalk.ToolbarSeparator) 528 1 1248 960 1362 528 11 1200 1362 528 1 912 1152 864 1104 800 nil nil 1 nil 674 33 33 674 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 1 1 674 1249 51 528 1554 #updateSizePosted 736 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 1728 nil 480 nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 674 193 193 nil 1728 nil 8 1903688272 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 1728 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 3 3 1904 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] #icon #imageIndex 2000 7 257 nil nil 8 'status' 34 1 1920 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1728 nil nil 1490 138 144 34 1 1554 #createAt:extent: 34 2 674 1 799 674 1249 45 1728 1650 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 1 0 0 112 2 0 0 165 1 0 0] 8 #() 1712 nil 27 nil nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 416 34 2 8 1143017796 262145 2288 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) 524550 ##(Smalltalk.RichText) 8 '{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\lang1033\f0\fs16 
\par }
' 480 nil 23 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 818 #cutSelection 8 'Cu&t' 1 1 nil nil nil 2514 1 818 #copySelection 8 '&Copy' 1 1 nil nil nil 2514 1 818 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2514 1 818 #formatFont 8 '&Font...' 1 1 nil nil nil 2514 1 818 #toggleBulletStyle 8 '&Bullet Style' 1 1 nil nil nil 2514 1 818 #formatParagraph 8 'P&aragraph...' 1 1 nil nil nil 2674 4097 2514 1 818 #objectProperties 8 'Object P&roperties...' 1025 1 nil nil nil 2514 1 818 #editObject 8 '&Object' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 2288 nil 8 1348221456 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 0 0 250 3] 1490 138 144 34 5 1554 #createAt:extent: 34 2 674 1 51 674 1249 749 2288 1554 #contextMenu: 34 1 2480 2288 1554 #text: 34 1 2418 8 '{\urtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\lang1033\f0\fs16\par
}
' 2288 1554 #textLimit: 8 #(1073741823) 2288 1554 #resetCharFormat 736 2288 1650 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 112 2 0 0 143 1 0 0] 8 #() 1712 nil 27 170 192 34 6 1728 8 'statusbar' 528 8 'toolbar' 2288 8 'document' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 2466 nil true 34 11 2514 1 818 #fileNew 8 '&New' 9373 1 nil nil nil 2514 1 818 #fileOpen 8 '&Open...' 9375 1 nil nil nil 2514 1 818 #fileSave 8 '&Save' 8359 1 nil nil nil 2514 1 818 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 2674 4097 2514 1 818 #filePrint 8 '&Print...' 9377 1 nil nil nil 2514 1 818 #filePageSetup 8 'Page Set&up...' 1 1 nil nil nil 2674 4097 2514 1 818 #sendDocument 8 'Sen&d...' 1 1 nil nil nil 2674 4097 2514 1 818 #exit 8 'E&xit' 1025 1 nil nil nil 8 '&File' nil 1 nil nil 14159 nil nil 2466 nil true 34 16 2514 1 818 #undo 8 '&Undo' 9397 1 nil nil nil 2674 4097 2514 1 818 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 2514 1 818 #copySelection 8 '&Copy' 9351 1 nil nil nil 2514 1 818 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 2514 1 818 #pasteSpecial 8 'Paste &Special...' 1 1 nil nil nil 2514 1 818 #clearSelection 8 'Cle&ar' 1629 1 nil nil nil 2514 1 818 #selectAll 8 'Select All' 9347 1 nil nil nil 2674 4097 2514 1 818 #find 8 '&Find...' 9357 1 nil nil nil 2514 1 818 #findNext 8 'Find &Next' 1253 1 nil nil nil 2514 1 818 #findReplace 8 'R&eplace...' 9361 1 nil nil nil 2674 4097 2514 1 818 #links 8 'Lin&ks...' 1 1 nil nil nil 2514 1 818 #objectProperties 8 'Object P&roperties...' 1025 1 nil nil nil 2514 1 818 #editObject 8 '&Object' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil 14187 nil nil 2466 nil true 34 6 2514 1025 818 #viewToolbar 8 '&Toolbar' 1025 1 nil nil nil 2514 1025 818 #viewFormatBar 8 '&Format Bar' 1025 1 nil nil nil 2514 1025 818 #viewRuler 8 '&Ruler' 1025 1 nil nil nil 2514 1025 818 #viewStatusBar 8 '&Status Bar' 1025 1 nil nil nil 2674 4097 2514 1 818 #viewOptions 8 '&Options...' 1 1 nil nil nil 8 '&View' nil 1 nil nil 14199 nil nil 2466 nil true 34 2 2514 1 818 #insertDateAndTime 8 '&Date and Time...' 1 1 nil nil nil 2514 1 818 #insertObject 8 '&Object...' 1 1 nil nil nil 8 '&Insert' nil 1 nil nil 14205 nil nil 2466 nil true 34 4 2514 1 818 #formatFont 8 '&Font...' 1 1 nil nil nil 2514 1 818 #toggleBulletStyle 8 '&Bullet Style' 1 1 nil nil nil 2514 1 818 #formatParagraph 8 '&Paragraph...' 1 1 nil nil nil 2514 1 818 #formatTabs 8 '&Tabs...' 1 1 nil nil nil 8 'F&ormat' nil 1 nil nil 14215 nil nil 2466 nil true 34 3 2514 1 818 #help 8 '&Help Topics' 1025 1 nil nil nil 2674 4097 2514 1 818 #about 8 '&About Dolphin WordPad' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 14221 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1490 138 144 34 3 1554 #createAt:extent: 34 2 674 3839 21 674 1281 961 416 1554 #text: 34 1 8 'Dolphin WordPad' 416 1554 #updateMenuBar 736 416 1650 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 255 9 0 0 234 1 0 0] 34 3 528 2288 1728 1712 nil 27 )! !
!WordPad class categoriesFor: #about!enquiries!private! !
!WordPad class categoriesFor: #aboutTemplate!enquiries!private! !
!WordPad class categoriesFor: #defaultAdditionalAccelerators!private! !
!WordPad class categoriesFor: #displayOn:!displaying!public! !
!WordPad class categoriesFor: #fileTypes!public! !
!WordPad class categoriesFor: #icon!constants!public! !
!WordPad class categoriesFor: #resource_Default_view!public!resources-views! !

