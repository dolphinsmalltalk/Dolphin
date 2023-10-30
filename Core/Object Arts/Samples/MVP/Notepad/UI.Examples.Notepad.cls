"Filed out from Dolphin Smalltalk"!

UI.TextDocument
	subclass: #'UI.Examples.Notepad'
	instanceVariableNames: ''
	classVariableNames: 'ResourceLib'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.Notepad guid: (Core.GUID fromString: '{64abbec0-8140-42d2-aecd-6d329b3b41e0}')!
UI.Examples.Notepad comment: '`Notepad` is a `<topShell>` sample application which implements most of the functionality of the familiar Windows utility. The major areas of missing functionality are printing, zoom and the status bar. Most of the implementation of the application is actually inherited from Dolphin''s `TextDocument` framework class.

Note that some resources are extracted from the Windows executable, but none of the functionality of that executable is reused (or indeed could be, as Notepad.exe doesn''t export any functions).

Example:
	Notepad show

Class Variables:
	ResourceLib	`External.ResourceLibrary` for accessing resources within the standard NOTEPAD.EXE.





'!
!UI.Examples.Notepad categoriesForClass!Samples! !
!UI.Examples.Notepad methodsFor!

aboutNotepad
	"Pop up a little helpful info. about this sample program."

	self class about!

chooseFont
	"Pop the font dialog to allow selection of font for the text in the receiver.
	Note how we easily we can modify the font simply by opening FontDialog on the
	font aspect of the view."

	FontDialog showModalOn: (documentPresenter view aspectValue: #font)
!

editGoto
	<commandQuery: #queryEditGoto:>
	(IntegerPrompter create
		caption: 'Go To Line';
		prompt: 'Line number:';
		interval: (1 to: documentPresenter view lineCount);
		showModal) ifNotNil: [:lineNo | documentPresenter view gotoLine: lineNo]!

editTimeStamp
	| stream now locale |
	stream := String writeStream.
	now := DateAndTime now.
	locale := Locale default.
	now printOn: stream format: locale shortTimeFormat, ' ', locale shortDateFormat.
	documentPresenter replaceSelection: stream contents!

hasWordWrap
	^documentPresenter view wordWrap!

queryEditGoto: query
	query isEnabled: self hasWordWrap not!

saveChangesPrompt
	| docName |
	docName := self hasFilename ifTrue: [self filename] ifFalse: ['Untitled'].
	^'Do you want to save changes to <1s>?' expandMacrosWith: docName! !
!UI.Examples.Notepad categoriesForMethods!
aboutNotepad!commands-actions!public! !
chooseFont!commands-actions!public! !
editGoto!public! !
editTimeStamp!commands-actions!public! !
hasWordWrap!public!testing! !
queryEditGoto:!commands-queries!private! !
saveChangesPrompt!private! !
!

!UI.Examples.Notepad class methodsFor!

about
	"Private - Pop up a little helpful info. about this sample program."

	MessageBox new
		caption: 'About Dolphin <1d>' << self;
		icon: self icon;
		headline: 'Simple Notepad Sample';
		text: VM fullVersion;
		detailsText: 'This is a reduced functionality implementation of the standard system utility NOTEPAD.EXE, intended to demonstrate the DocumentShell hierarchy of Dolphin''s application framework.

DISCLAIMER: This software is freely provided purely as an educational sample and as such it is provided "as is", WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.';
		open!

closeResourceLib
	ResourceLib isNil ifFalse: [ResourceLib close. ResourceLib := nil].
!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Notepad'!

icon
	"Answers an Icon that can be used to represent this class.
	Use the one from the real Windows Notepad for fun."

	^Icon fromId: 2 in: self resourceLib!

onPreStripImage
	"Private - The image is about to be stripped. Nil any lazily initialized class variables."

	self uninitialize!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.MultilineTextEdit} 50 20 nil 32 50 2 8 1143017796 1025 160 nil 112 nil 5 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 0 70 0 105 0 120 0 101 0 100 0 115 0 121 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 160 nil nil 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 306 1 1 306 1249 843 160 418 #textLimit: 50 1 8 4294967295 160 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 165 1 0 0] 8 #() 306 193 193 nil 45 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 160 8 'document' nil 2886 4 #{UI.MenuBar} nil true 50 4 2886 4 #{UI.Menu} nil true 50 9 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #fileNew 8 '&New' 8349 1 nil nil nil 786 1 818 #fileOpen 8 '&Open' 8351 1 nil nil nil 786 1 818 #fileSave 8 '&Save' 8359 1 nil nil nil 786 1 818 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 786 1 818 #filePageSetup 8 'Page Set&up…' 1 1 nil nil nil 786 1 818 #filePrint 8 '&Print' 8353 1 nil nil nil 1010 4097 786 1 818 #exit 8 'E&xit' 1 1 nil nil nil 8 '&File' nil 1 nil nil nil nil nil 738 nil true 50 14 786 1 818 #undo 8 '&Undo' 9397 1 nil nil nil 1010 4097 786 1 818 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 786 1 818 #copySelection 8 '&Copy' 9351 1 nil nil nil 786 1 818 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 786 1 818 #clearSelection 8 'De&lete	Del' 1 1 nil nil nil 1010 4097 786 1 818 #find 8 '&Find…' 9357 1 nil nil nil 786 1 818 #findNext 8 'Find &Next' 1253 1 nil nil nil 786 1 818 #findReplace 8 '&Replace…' 9361 1 nil nil nil 786 1 818 #editGoto 8 '&Go to…' 8335 1 nil nil nil 1010 4097 786 1 818 #selectAll 8 'Select &All' 9347 1 nil nil nil 786 1 818 #editTimeStamp 8 'Time/&Date' 233 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil 738 nil true 50 2 786 1 818 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 786 1 818 #chooseFont 8 '&Font…' 1 1 nil nil nil 8 'F&ormat' nil 1 nil nil nil nil nil 738 nil true 50 3 786 1 818 #helpTopics 8 'View &Help' 1 1 nil nil nil 1010 4097 786 1 818 #aboutNotepad 8 '&About Dolphin Notepad' 1 1 nil nil nil 8 '&Help' nil 1 nil nil nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 370 50 2 418 #createAt:extent: 50 2 306 6143 21 306 1281 961 32 418 #text: 50 1 8 'Dolphin Notepad' 32 546 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 127 14 0 0 234 1 0 0] 50 1 160 608 nil 27)!

resourceLib
	"Answer the notepad resource library (notepad.exe)"

	^ResourceLib
		ifNil: 
			[ResourceLib := External.ResourceLibrary open: SessionManager current systemDirectory , '\notepad.exe']!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system.
		self uninitialize
	"

	self closeResourceLib! !
!UI.Examples.Notepad class categoriesForMethods!
about!enquiries!private! !
closeResourceLib!helpers!private! !
displayOn:!displaying!public! !
icon!constants!public! !
onPreStripImage!class hierarchy-removing!private! !
resource_Default_view!public!resources-views! !
resourceLib!constants!public! !
uninitialize!class hierarchy-removing!private! !
!

