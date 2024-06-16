"Filed out from Dolphin Smalltalk"!

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

!WordPad categoriesForMethods!
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

	^'Simple Wordpad Sample<n><1s><n>
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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1409289036 131073 528 nil 480 nil 517 nil nil nil 528 nil 8 1759112192 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 640 nil nil nil 5 nil nil nil 640 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Fluent_File_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[3 0 0 0 3 0 0 0 92 0 0 0 28 0 0 0] 193 672 8 '' 640 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'fileTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1008 nil nil nil 5 nil nil nil 1008 706 ##(Smalltalk.Toolbar) #resource_Fluent_Paragraph_Tools nil 738 138 144 34 1 802 #createWindow: 34 1 850 882 8 #[164 1 0 0 3 0 0 0 253 1 0 0 28 0 0 0] 193 1040 8 '' 1008 3 944 962 193 193 nil 27 8 'paragraphTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 5 nil nil nil 1264 706 ##(Smalltalk.Toolbar) #resource_Fluent_Edit_tools nil 738 138 144 34 1 802 #createWindow: 34 1 850 882 8 #[92 0 0 0 3 0 0 0 231 0 0 0 28 0 0 0] 193 1296 8 '' 1264 3 944 962 193 193 nil 27 8 'clipboardTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1520 nil nil nil 5 nil nil nil 1520 706 ##(Smalltalk.Toolbar) #resource_Fluent_Find_tools nil 738 138 144 34 1 802 #createWindow: 34 1 850 882 8 #[253 1 0 0 3 0 0 0 61 2 0 0 28 0 0 0] 193 1552 8 '' 1520 3 944 962 193 193 nil 27 8 'findTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1776 nil nil nil 5 nil nil nil 1776 706 ##(Smalltalk.Toolbar) #resource_Fluent_Font_Tools nil 738 138 144 34 1 802 #createWindow: 34 1 850 882 8 #[231 0 0 0 3 0 0 0 164 1 0 0 28 0 0 0] 193 1808 8 '' 1776 3 944 962 193 193 nil 27 8 'fontTools' nil nil nil 170 192 944 8 #() nil 590342 ##(Smalltalk.Rectangle) 962 7 7 962 1 1 9 1141 #smallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 738 138 144 34 1 802 #createWindow: 34 1 850 882 8 #[0 0 0 0 0 0 0 0 112 2 0 0 28 0 0 0] 193 560 8 '' 528 3 34 5 640 1264 1776 1008 1520 962 193 193 nil 31 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1140850956 1 2336 nil 480 nil 5 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2336 nil 8 1758805184 170 192 34 2 853830 1 ##(Smalltalk.StatusBarItem) 8193 -1 2336 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 3 3 2528 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] #icon #imageIndex 2624 7 257 nil nil 8 'status' nil nil nil 34 1 2544 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 2336 nil nil 738 138 144 34 1 802 #createWindow: 34 1 850 882 8 #[0 0 0 0 143 1 0 0 112 2 0 0 165 1 0 0] 193 2368 8 '' 2336 3 8 #() 962 193 193 nil 29 nil nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 416 34 2 8 1143017796 262145 2928 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) 524550 ##(Smalltalk.RichText) 8 '{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\lang1033\f0\fs16 
\par }
' 480 nil 21 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #cutSelection 8 'Cu&t' 1 1 nil nil nil 3154 1 3186 #copySelection 8 '&Copy' 1 1 nil nil nil 3154 1 3186 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3154 1 3186 #formatFont 8 '&Font...' 1 1 nil nil nil 3154 1 3186 #toggleBulletStyle 8 '&Bullet Style' 1 1 nil nil nil 3154 1 3186 #formatParagraph 8 'P&aragraph...' 1 1 nil nil nil 3330 4097 3154 1 3186 #objectProperties 8 'Object P&roperties...' 1025 1 nil nil nil 3154 1 3186 #editObject 8 '&Object' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 2928 nil 8 1682719600 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 0 0 154 4] 738 138 144 34 5 802 #createWindow: 34 1 850 882 8 #[0 0 0 0 28 0 0 0 112 2 0 0 143 1 0 0] 193 2960 nil 2928 802 #contextMenu: 34 1 3120 2928 802 #text: 34 1 3058 8 '{\urtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\lang1033\f0\fs16\par
}
' 2928 802 #textLimit: 8 #(1073741823) 2928 802 #resetCharFormat 944 2928 3 8 #() 962 193 193 nil 27 170 192 34 6 528 8 'toolbar' 2336 8 'statusbar' 2928 8 'document' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 3106 nil true 34 11 3154 1 3186 #fileNew 8 '&New' 9373 1 nil nil nil 3154 1 3186 #fileOpen 8 '&Open...' 9375 1 nil nil nil 3154 1 3186 #fileSave 8 '&Save' 8359 1 nil nil nil 3154 1 3186 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 3330 4097 3154 1 3186 #filePrint 8 '&Print...' 9377 1 nil nil nil 3154 1 3186 #filePageSetup 8 'Page Set&up...' 1 1 nil nil nil 3330 4097 3154 1 3186 #sendDocument 8 'Sen&d...' 1 1 nil nil nil 3330 4097 3154 1 3186 #exit 8 'E&xit' 1025 1 nil nil nil 8 '&File' nil 1 nil nil 16525 nil nil 3106 nil true 34 16 3154 1 3186 #undo 8 '&Undo' 9397 1 nil nil nil 3330 4097 3154 1 3186 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 3154 1 3186 #copySelection 8 '&Copy' 9351 1 nil nil nil 3154 1 3186 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 3154 1 3186 #pasteSpecial 8 'Paste &Special...' 1 1 nil nil nil 3154 1 3186 #clearSelection 8 'Cle&ar' 1629 1 nil nil nil 3154 1 3186 #selectAll 8 'Select All' 9347 1 nil nil nil 3330 4097 3154 1 3186 #find 8 '&Find...' 9357 1 nil nil nil 3154 1 3186 #findNext 8 'Find &Next' 1253 1 nil nil nil 3154 1 3186 #findReplace 8 'R&eplace...' 9361 1 nil nil nil 3330 4097 3154 1 3186 #links 8 'Lin&ks...' 1 1 nil nil nil 3154 1 3186 #objectProperties 8 'Object P&roperties...' 1025 1 nil nil nil 3154 1 3186 #editObject 8 '&Object' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil 16553 nil nil 3106 nil true 34 6 3154 1025 3186 #viewToolbar 8 '&Toolbar' 1025 1 nil nil nil 3154 1025 3186 #viewFormatBar 8 '&Format Bar' 1025 1 nil nil nil 3154 1025 3186 #viewRuler 8 '&Ruler' 1025 1 nil nil nil 3154 1025 3186 #viewStatusBar 8 '&Status Bar' 1025 1 nil nil nil 3330 4097 3154 1 3186 #viewOptions 8 '&Options...' 1 1 nil nil nil 8 '&View' nil 1 nil nil 16565 nil nil 3106 nil true 34 2 3154 1 3186 #insertDateAndTime 8 '&Date and Time...' 1 1 nil nil nil 3154 1 3186 #insertObject 8 '&Object...' 1 1 nil nil nil 8 '&Insert' nil 1 nil nil 16571 nil nil 3106 nil true 34 4 3154 1 3186 #formatFont 8 '&Font...' 1 1 nil nil nil 3154 1 3186 #toggleBulletStyle 8 '&Bullet Style' 1 1 nil nil nil 3154 1 3186 #formatParagraph 8 '&Paragraph...' 1 1 nil nil nil 3154 1 3186 #formatTabs 8 '&Tabs...' 1 1 nil nil nil 8 'F&ormat' nil 1 nil nil 16581 nil nil 3106 nil true 34 3 3154 1 3186 #help 8 '&Help Topics' 1025 1 nil nil nil 3330 4097 3154 1 3186 #about 8 '&About Dolphin WordPad' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 16587 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 738 138 144 34 1 802 #createWindow: 34 1 850 2066 962 1 1 962 1281 961 193 448 8 'Dolphin WordPad' 416 1 34 3 528 2928 2336 962 193 193 nil 27 )! !

!WordPad class categoriesForMethods!
about!enquiries!private! !
aboutTemplate!enquiries!private! !
defaultAdditionalAccelerators!private! !
fileTypes!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

