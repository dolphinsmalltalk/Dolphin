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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #default nil 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1140853516 131137 528 nil 480 nil 519 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 528 480 8 1815075056 170 192 8 #() nil nil nil 170 192 34 22 46903 1443398 1 #{UI.ToolbarSystemButton} 528 1 1377606 4 #{UI.CommandDescription} #pasteSelection 8 'Paste' 1 1 nil 46903 1 5 46899 786 528 1 818 #cutSelection 8 'Cut' 1 1 nil 46899 1 1 46895 786 528 1 818 #printPreview 8 'Print Preview' 1 1 nil 46895 1 19 46891 786 528 1 818 #fileSave 8 'Save' 1 1 nil 46891 1 17 46887 786 528 1 818 #fileNew 8 'New' 1 1 nil 46887 1 13 46905 786 528 1 818 #clearSelection 8 'Delete' 1 1 nil 46905 1 11 46901 786 528 1 818 #copySelection 8 'Copy' 1 1 nil 46901 1 3 46897 786 528 1 818 #find 8 'Find' 1 1 nil 46897 1 25 46893 786 528 1 818 #printDocument 8 'Print' 1 1 nil 46893 1 29 46889 786 528 1 818 #fileOpen 8 'Open' 1 1 nil 46889 1 15 46907 786 528 1 818 #undo 8 'Undo' 1 1 nil 46907 1 7 34 14 1008 1248 960 1245766 1 #{UI.ToolbarSeparator} 528 1 1200 912 1362 528 11 1152 1362 528 1 864 1104 800 1056 1296 nil nil 1 nil 674 33 33 674 45 45 nil 852806 1 #{UI.FlowLayout} 1 1 1 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 674 1 1 674 1249 51 528 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 25 0 0 0] 8 #() 674 193 193 nil 29 410 #{UI.StatusBar} 34 21 nil 416 34 2 8 1140850956 1 1696 nil 480 nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 674 193 193 nil 1696 nil 8 1814628368 170 192 34 2 1050438 1 #{UI.StatusBarItem} 8193 -1 1696 nil 786950 #{Core.Message} #displayString 8 #() 1246566 3 #{Kernel.BlockClosure} 0 nil 1377574 #{Kernel.CompiledMethod} 3 3 1872 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] #icon #imageIndex 1968 7 257 nil nil 8 'status' nil nil nil 34 1 1888 1311814 1 #{UI.StatusBarNullItem} 8705 1 1696 nil nil 1490 34 1 1538 #createAt:extent: 34 2 674 1 799 674 1249 45 1696 1618 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 1 0 0 112 2 0 0 165 1 0 0] 8 #() 1680 nil 29 nil nil 410 #{UI.RichTextEdit} 34 18 nil 416 34 2 8 1143017796 262145 2240 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} 721158 #{UI.RichText} 8 '{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\lang1033\f0\fs16 
\par }
' 480 nil 23 461638 4 #{UI.Menu} nil true 34 10 1180742 2 #{UI.CommandMenuItem} 1 818 #cutSelection 8 'Cu&t' 1 1 nil nil nil 2466 1 818 #copySelection 8 '&Copy' 1 1 nil nil nil 2466 1 818 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 2466 1 818 #formatFont 8 '&Font…' 1 1 nil nil nil 2466 1 818 #toggleBulletStyle 8 '&Bullet Style' 1 1 nil nil nil 2466 1 818 #formatParagraph 8 'P&aragraph…' 1 1 nil nil nil 2626 4097 2466 1 818 #objectProperties 8 'Object P&roperties…' 1025 1 nil nil nil 2466 1 818 #editObject 8 '&Object' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 2240 nil 8 1348699616 1049094 #{UI.NullConverter} nil nil 9 nil 852230 #{OS.EDITSTREAM} 8 #[0 0 0 0 0 0 0 0 0 0 112 5] 1490 34 5 1538 #createAt:extent: 34 2 674 1 51 674 1249 749 2240 1538 #contextMenu: 34 1 2432 2240 1538 #text: 34 1 2370 8 '{\urtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\lang1033\f0\fs16\par
}
' 2240 1538 #textLimit: 8 #(1073741823) 2240 1538 #resetCharFormat 736 2240 1618 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 112 2 0 0 143 1 0 0] 8 #() 1680 nil 27 170 192 34 6 528 8 'toolbar' 1696 8 'statusbar' 2240 8 'document' nil 658246 4 #{UI.MenuBar} nil true 34 6 2418 nil true 34 11 2466 1 818 #fileNew 8 '&New' 9373 1 nil nil nil 2466 1 818 #fileOpen 8 '&Open…' 9375 1 nil nil nil 2466 1 818 #fileSave 8 '&Save' 8359 1 nil nil nil 2466 1 818 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 2626 4097 2466 1 818 #filePrint 8 '&Print…' 9377 1 nil nil nil 2466 1 818 #filePageSetup 8 'Page Set&up…' 1 1 nil nil nil 2626 4097 2466 1 818 #sendDocument 8 'Sen&d…' 1 1 nil nil nil 2626 4097 2466 1 818 #exit 8 'E&xit' 1025 1 nil nil nil 8 '&File' nil 1 nil nil 46925 nil nil 2418 nil true 34 16 2466 1 818 #undo 8 '&Undo' 9397 1 nil nil nil 2626 4097 2466 1 818 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 2466 1 818 #copySelection 8 '&Copy' 9351 1 nil nil nil 2466 1 818 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 2466 1 818 #pasteSpecial 8 'Paste &Special…' 1 1 nil nil nil 2466 1 818 #clearSelection 8 'Cle&ar' 1629 1 nil nil nil 2466 1 818 #selectAll 8 'Select All' 9347 1 nil nil nil 2626 4097 2466 1 818 #find 8 '&Find…' 9357 1 nil nil nil 2466 1 818 #findNext 8 'Find &Next' 1253 1 nil nil nil 2466 1 818 #findReplace 8 'R&eplace…' 9361 1 nil nil nil 2626 4097 2466 1 818 #links 8 'Lin&ks…' 1 1 nil nil nil 2466 1 818 #objectProperties 8 'Object P&roperties…' 1025 1 nil nil nil 2466 1 818 #editObject 8 '&Object' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil 46953 nil nil 2418 nil true 34 6 2466 1025 818 #viewToolbar 8 '&Toolbar' 1025 1 nil nil nil 2466 1025 818 #viewFormatBar 8 '&Format Bar' 1025 1 nil nil nil 2466 1025 818 #viewRuler 8 '&Ruler' 1025 1 nil nil nil 2466 1025 818 #viewStatusBar 8 '&Status Bar' 1025 1 nil nil nil 2626 4097 2466 1 818 #viewOptions 8 '&Options…' 1 1 nil nil nil 8 '&View' nil 1 nil nil 46965 nil nil 2418 nil true 34 2 2466 1 818 #insertDateAndTime 8 '&Date and Time…' 1 1 nil nil nil 2466 1 818 #insertObject 8 '&Object…' 1 1 nil nil nil 8 '&Insert' nil 1 nil nil 46971 nil nil 2418 nil true 34 4 2466 1 818 #formatFont 8 '&Font…' 1 1 nil nil nil 2466 1 818 #toggleBulletStyle 8 '&Bullet Style' 1 1 nil nil nil 2466 1 818 #formatParagraph 8 '&Paragraph…' 1 1 nil nil nil 2466 1 818 #formatTabs 8 '&Tabs…' 1 1 nil nil nil 8 'F&ormat' nil 1 nil nil 46981 nil nil 2418 nil true 34 3 2466 1 818 #help 8 '&Help Topics' 1025 1 nil nil nil 2626 4097 2466 1 818 #about 8 '&About Dolphin WordPad' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 46987 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1490 34 2 1538 #createAt:extent: 34 2 674 12287 21 674 1281 961 416 1538 #text: 34 1 8 'Dolphin WordPad' 416 1618 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 127 26 0 0 234 1 0 0] 34 3 528 2240 1696 1680 nil 27)! !
!UI.Examples.WordPad class categoriesForMethods!
about!enquiries!private! !
displayOn:!displaying!public! !
fileTypes!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

