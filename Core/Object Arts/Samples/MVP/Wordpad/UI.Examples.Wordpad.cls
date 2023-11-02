"Filed out from Dolphin Smalltalk"!

UI.TextDocument
	subclass: #'UI.Examples.WordPad'
	instanceVariableNames: ''
	classVariableNames: 'ResourceLib'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.WordPad guid: (Core.GUID fromString: '{daf98e5f-3a01-477d-b822-6b0e9bc79d14}')!
UI.Examples.WordPad comment: 'Wordpad is a <topShell> sample application which implements a limited set of the functionality of the familiar Windows utility. Most of the implementation of the application is actually inherited from Dolphin''s TextDocument framework class or provided by RichTextPresenter and RichTextEdit.

Example:
	Wordpad show
'!
!UI.Examples.WordPad methodsFor!

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
	(WordpadParagraphDialog showModalOn: paraformat)
		ifNotNil: [documentPresenter view selectionParaFormat: paraformat]!

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
	^'Do you want to save changes to <1s>?' expandMacrosWith: docName!

setDocumentData: aString 
	"Private - Set the data for the receiver's document to be anObject.
	Can be overidden by subclasses"

	super setDocumentData: ((aString beginsWith: '{\rtf') 
				ifTrue: [RichText fromRtf: aString]
				ifFalse: [RichText fromString: aString])! !
!UI.Examples.WordPad categoriesForMethods!
about!commands!public! !
documentPresenterClass!constants!public! !
formatFont!commands!public! !
formatParagraph!commands!public! !
getDocumentData!private! !
insertDateAndTime!commands!public! !
isRichText!public!testing! !
saveChangesPrompt!private! !
setDocumentData:!accessing!private! !
!

!UI.Examples.WordPad class methodsFor!

about
	"Private - Pop up a little helpful info. about this sample program."

	MessageBox new
		caption: 'About Dolphin <1d>' << self;
		icon: self icon;
		headline: 'Simple Wordpad Sample';
		text: VM fullVersion;
		detailsText: 'This is a reduced functionality implementation of the standard system utility WORDPAD.EXE, intended to demonstrate the DocumentShell and Rich Text hierarchies of Dolphin''s application framework.

DISCLAIMER: This software is freely provided purely as an educational sample and as such it is provided "as is", WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.';
		open!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'WordPad'!

fileTypes
	"Answer an Array of file types that can be associated with this class of document."

	^{#('Rich Text Files (*.rtf)' '*.rtf'). #('Text Files (*.txt)' '*.txt'). FileDialog allFilesType}!

icon
	"Answers an Icon that can be used to represent this class."

	^##(Icon shellStock: SHSTOCKICONID.SIID_DOCASSOC)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853516 131137 160 nil 112 nil 517 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 160 112 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 14 1606 1 #{UI.ToolbarSystemButton} 160 1 1350 4 #{UI.CommandDescription} #fileNew 8 'New' 1 1 nil nil 1 13 402 160 1 434 #fileOpen 8 'Open' 1 1 nil nil 1 15 402 160 1 434 #fileSave 8 'Save' 1 1 nil nil 1 17 582 1 #{UI.ToolbarSeparator} 160 1 402 160 1 434 #printDocument 8 'Print' 1 1 nil nil 1 29 402 160 1 434 #printPreview 8 'Print Preview' 1 1 nil nil 1 19 578 160 11 402 160 1 434 #find 8 'Find' 1 1 nil nil 1 25 578 160 1 402 160 1 434 #cutSelection 8 'Cut' 1 1 nil nil 1 1 402 160 1 434 #copySelection 8 'Copy' 1 1 nil nil 1 3 402 160 1 434 #pasteSelection 8 'Paste' 1 1 nil nil 1 5 402 160 1 434 #clearSelection 8 'Delete' 1 1 nil nil 1 11 402 160 1 434 #undo 8 'Undo' 1 1 nil nil 1 7 nil nil 1 nil 306 33 33 306 45 45 nil 838 1 #{UI.FlowLayout} 1 1 1 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 306 1 1 306 1249 51 160 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 25 0 0 0] 8 #() 306 193 193 nil 29 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140850956 1 1296 nil 112 nil 5 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 306 193 193 nil 1296 nil nil 338 #{Core.IdentityDictionary} 50 2 1862 1 #{UI.StatusBarItem} 8193 -1 1296 nil 518 #{Core.Message} #displayString 8 #() 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledMethod} 3 3 1456 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] #icon #imageIndex 1552 7 257 nil nil 8 'status' nil nil nil 50 1 1472 1094 1 #{UI.StatusBarNullItem} 8705 1 1296 nil nil 1090 50 1 1138 #createAt:extent: 50 2 306 1 799 306 1249 45 1296 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 1 0 0 112 2 0 0 165 1 0 0] 8 #() 1280 nil 29 nil nil 18 #{UI.RichTextEdit} 50 22 nil 32 50 2 8 1143017796 262145 1824 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} 262 #{UI.RichText} 8 '{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\lang1033\f0\fs16 
\par }
' 112 nil 21 2886 4 #{UI.Menu} nil true 50 10 1094 2 #{UI.CommandMenuItem} 1 434 #cutSelection 8 'Cu&t' 1 1 nil nil nil 2050 1 434 #copySelection 8 '&Copy' 1 1 nil nil nil 2050 1 434 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 2050 1 434 #formatFont 8 '&Font…' 1 1 nil nil nil 2050 1 434 #toggleBulletStyle 8 '&Bullet Style' 1 1 nil nil nil 2050 1 434 #formatParagraph 8 'P&aragraph…' 1 1 nil nil nil 2210 4097 2050 1 434 #objectProperties 8 'Object P&roperties…' 1025 1 nil nil nil 2050 1 434 #editObject 8 '&Object' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 1824 nil nil 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil nil 262 #{OS.EDITSTREAM} 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 1090 50 4 1138 #createAt:extent: 50 2 306 1 51 306 1249 749 1824 1138 #text: 50 1 1954 8 '{\urtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\lang1033\f0\fs16\par
}
' 1824 1138 #textLimit: 8 #(1073741823) 1824 1138 #resetCharFormat 368 1824 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 112 2 0 0 143 1 0 0] 8 #() 1280 nil 45 338 #{Core.IdentityDictionary} 50 6 1824 8 'document' 1296 8 'statusbar' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 6 2002 nil true 50 11 2050 1 434 #fileNew 8 '&New' 9373 1 nil nil nil 2050 1 434 #fileOpen 8 '&Open…' 9375 1 nil nil nil 2050 1 434 #fileSave 8 '&Save' 8359 1 nil nil nil 2050 1 434 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 2210 4097 2050 1 434 #filePrint 8 '&Print…' 9377 1 nil nil nil 2050 1 434 #filePageSetup 8 'Page Set&up…' 1 1 nil nil nil 2210 4097 2050 1 434 #sendDocument 8 'Sen&d…' 1 1 nil nil nil 2210 4097 2050 1 434 #exit 8 'E&xit' 1025 1 nil nil nil 8 '&File' nil 1 nil nil nil nil nil 2002 nil true 50 16 2050 1 434 #undo 8 '&Undo' 9397 1 nil nil nil 2210 4097 2050 1 434 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 2050 1 434 #copySelection 8 '&Copy' 9351 1 nil nil nil 2050 1 434 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 2050 1 434 #pasteSpecial 8 'Paste &Special…' 1 1 nil nil nil 2050 1 434 #clearSelection 8 'Cle&ar' 1629 1 nil nil nil 2050 1 434 #selectAll 8 'Select All' 9347 1 nil nil nil 2210 4097 2050 1 434 #find 8 '&Find…' 9357 1 nil nil nil 2050 1 434 #findNext 8 'Find &Next' 1253 1 nil nil nil 2050 1 434 #findReplace 8 'R&eplace…' 9361 1 nil nil nil 2210 4097 2050 1 434 #links 8 'Lin&ks…' 1 1 nil nil nil 2050 1 434 #objectProperties 8 'Object P&roperties…' 1025 1 nil nil nil 2050 1 434 #editObject 8 '&Object' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil 2002 nil true 50 6 2050 1025 434 #toggleToolbar 8 '&Toolbar' 1025 1 nil nil nil 2050 1025 434 #viewFormatBar 8 '&Format Bar' 1025 1 nil nil nil 2050 1025 434 #viewRuler 8 '&Ruler' 1025 1 nil nil nil 2050 1025 434 #toggleStatusBar 8 '&Status Bar' 1025 1 nil nil nil 2210 4097 2050 1 434 #viewOptions 8 '&Options…' 1 1 nil nil nil 8 '&View' nil 1 nil nil nil nil nil 2002 nil true 50 2 2050 1 434 #insertDateAndTime 8 '&Date and Time…' 1 1 nil nil nil 2050 1 434 #insertObject 8 '&Object…' 1 1 nil nil nil 8 '&Insert' nil 1 nil nil nil nil nil 2002 nil true 50 4 2050 1 434 #formatFont 8 '&Font…' 1 1 nil nil nil 2050 1 434 #toggleBulletStyle 8 '&Bullet Style' 1 1 nil nil nil 2050 1 434 #formatParagraph 8 '&Paragraph…' 1 1 nil nil nil 2050 1 434 #formatTabs 8 '&Tabs…' 1 1 nil nil nil 8 'F&ormat' nil 1 nil nil nil nil nil 2002 nil true 50 3 2050 1 434 #help 8 '&Help Topics' 1025 1 nil nil nil 2210 4097 2050 1 434 #about 8 '&About Dolphin WordPad' 1 1 nil nil nil 8 '&Help' nil 1 nil nil nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1090 50 2 1138 #createAt:extent: 50 2 306 6143 21 306 1281 961 32 1138 #text: 50 1 8 'Dolphin WordPad' 32 1218 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 127 14 0 0 234 1 0 0] 50 3 160 1824 1296 1280 nil 27)! !
!UI.Examples.WordPad class categoriesForMethods!
about!enquiries!private! !
displayOn:!displaying!public! !
fileTypes!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

