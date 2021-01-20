"Filed out from Dolphin Smalltalk 7"!

UI.TextDocument subclass: #Notepad
	instanceVariableNames: ''
	classVariableNames: 'ResourceLib'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Notepad guid: (Core.GUID fromString: '{64abbec0-8140-42d2-aecd-6d329b3b41e0}')!
Notepad comment: '`Notepad` is a `<topShell>` sample application which implements most of the functionality of the familiar Windows utility. The major areas of missing functionality are printing, zoom and the status bar. Most of the implementation of the application is actually inherited from Dolphin''s `TextDocument` framework class.

Note that some resources are extracted from the Windows executable, but none of the functionality of that executable is reused (or indeed could be, as Notepad.exe doesn''t export any functions).

Example:
	Notepad show

Class Variables:
	ResourceLib	`External.ResourceLibrary` for accessing resources within the standard NOTEPAD.EXE.





'!
!Notepad categoriesForClass!Samples! !
!Notepad methodsFor!

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
	(IntegerPrompter create
				caption: 'Go To Line';
				prompt: 'Line number:';
				interval: (1 to: documentPresenter view lineCount);
				showModal)
	ifNotNil: [ :lineNo |
		documentPresenter view gotoLine: lineNo]!

editTimeStamp
	| stream now locale |
	stream := String writeStream.
	now := DateAndTime now.
	locale := Locale default.
	now printOn: stream format: locale shortTimeFormat, ' ', locale shortDateFormat.
	documentPresenter replaceSelection: stream contents!

hasWordWrap
	^documentPresenter view wordWrap!

queryCommand: query
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>, query"

	| cmd |
	cmd := query commandSymbol.
	cmd == #editGoto
		ifTrue: 
			[query isEnabled: self hasWordWrap  not.
			^true].
	^super queryCommand: query!

saveChangesPrompt
	| docName |
	docName := self hasFilename ifTrue: [self filename] ifFalse: ['Untitled'].
	^'The text in the <1s> file has changed.<n><n>Do you want to save the changes?' 
		expandMacrosWith: docName! !
!Notepad categoriesFor: #aboutNotepad!commands!public! !
!Notepad categoriesFor: #chooseFont!commands!public! !
!Notepad categoriesFor: #editGoto!public! !
!Notepad categoriesFor: #editTimeStamp!commands!public! !
!Notepad categoriesFor: #hasWordWrap!public!testing! !
!Notepad categoriesFor: #queryCommand:!commands!private! !
!Notepad categoriesFor: #saveChangesPrompt!private! !

!Notepad class methodsFor!

about
	"Private - Pop up a little helpful info. about this sample program."

	(MessageBox new)
		caption: ('About Dolphin <1d>' expandMacrosWith: self);
		icon: self icon;
		text: (self aboutTemplate expandMacrosWith: VMLibrary default fullVersion);
		open!

aboutTemplate
	"Private - Answer the text to be used in the receiver's about box"

	^'Simple Notepad Sample<n><1s><n>
This is a slightly reduced functionality implementation of the standard system utility NOTEPAD.EXE,
intended to demonstrate the DocumentShell hierarchy of Dolphin''s application framework.<n>
DISCLAIMER: This software is freely provided purely as an educational sample and as such it
is provided "as is", WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 416 34 2 8 1143017796 1025 528 nil 480 nil 7 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 49 70 105 120 101 100 115 121 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 528 nil 8 1903872368 852486 ##(Smalltalk.NullConverter) nil nil 9 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 1 1 674 1249 843 528 818 #textLimit: 34 1 8 4294967295 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 165 1 0 0] 8 #() 674 193 193 nil 27 170 192 34 2 528 8 'document' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 9 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 '&New' 8349 1 nil nil nil 1170 1 1202 #fileOpen 8 '&Open' 8351 1 nil nil nil 1170 1 1202 #fileSave 8 '&Save' 8359 1 nil nil nil 1170 1 1202 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1170 1 1202 #filePageSetup 8 'Page Set&up...' 1 1 nil nil nil 1170 1 1202 #filePrint 8 '&Print' 8353 1 nil nil nil 1394 4097 1170 1 1202 #exit 8 'E&xit' 1 1 nil nil nil 8 '&File' nil 1 nil nil 13771 nil nil 1122 nil true 34 14 1170 1 1202 #undo 8 '&Undo' 9397 1 nil nil nil 1394 4097 1170 1 1202 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 1170 1 1202 #copySelection 8 '&Copy' 9351 1 nil nil nil 1170 1 1202 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 1170 1 1202 #clearSelection 8 'De&lete	Del' 1 1 nil nil nil 1394 4097 1170 1 1202 #find 8 '&Find...' 9357 1 nil nil nil 1170 1 1202 #findNext 8 'Find &Next' 1253 1 nil nil nil 1170 1 1202 #findReplace 8 '&Replace...' 9361 1 nil nil nil 1170 1 1202 #editGoto 8 '&Go to...' 8335 1 nil nil nil 1394 4097 1170 1 1202 #selectAll 8 'Select &All' 9347 1 nil nil nil 1170 1 1202 #editTimeStamp 8 'Time/&Date' 233 1 nil nil nil 8 '&Edit' nil 1 nil nil 13795 nil nil 1122 nil true 34 2 1170 1 1202 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 1170 1 1202 #chooseFont 8 '&Font...' 1 1 nil nil nil 8 'F&ormat' nil 1 nil nil 13801 nil nil 1122 nil true 34 3 1170 1 1202 #helpTopics 8 'View &Help' 1 1 nil nil nil 1394 4097 1170 1 1202 #aboutNotepad 8 '&About Dolphin Notepad' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 13807 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 754 138 144 34 3 818 #createAt:extent: 34 2 674 3839 21 674 1281 961 416 818 #text: 34 1 8 'Dolphin Notepad' 416 818 #updateMenuBar 8 #() 416 946 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 255 9 0 0 234 1 0 0] 34 1 528 1008 nil 27 )!

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
!Notepad class categoriesFor: #about!enquiries!private! !
!Notepad class categoriesFor: #aboutTemplate!enquiries!private! !
!Notepad class categoriesFor: #closeResourceLib!helpers!private! !
!Notepad class categoriesFor: #displayOn:!displaying!public! !
!Notepad class categoriesFor: #icon!constants!public! !
!Notepad class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Notepad class categoriesFor: #resource_Default_view!public!resources-views! !
!Notepad class categoriesFor: #resourceLib!constants!public! !
!Notepad class categoriesFor: #uninitialize!class hierarchy-removing!private! !

