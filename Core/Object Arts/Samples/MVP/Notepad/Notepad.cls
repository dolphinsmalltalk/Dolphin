"Filed out from Dolphin Smalltalk X6.2"!

TextDocument subclass: #Notepad
	instanceVariableNames: ''
	classVariableNames: 'ResourceLib'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Notepad guid: (GUID fromString: '{64ABBEC0-8140-42D2-AECD-6D329B3B41E0}')!
Notepad comment: 'Notepad is a <topShell> sample application which implements most of the functionality of the familiar Windows utility. The major area of missing functionality is printing. Most of the implementation of the application is actually inherited from Dolphin''s TextDocument framework class.

Note that some resources are extracted from the Windows executable, but none of the functionality of that executable is reused (or indeed could be, as Notepad.exe doesn''t export any functions).

Example:
	Notepad show

Class Variables:
	ResourceLib	<ExternalResourceLibrary> for accessing resources within the standard NOTEPAD.EXE.





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

editTimeStamp
	| stream |
	stream := String writeStream.
	Time now printOn: stream format: 'HH:mm'.
	stream space.
	Date today printOn: stream longPicture: false.
	documentPresenter replaceSelection: stream contents!

openFile: pathString 
	"Open the file with the <readableString> path, pathString, prompting in the standard Notepad
	fashion if it doesn't exist."

	(File exists: pathString) 
		ifTrue: 
			[self
				filename: pathString;
				fileLoad]
		ifFalse: 
			[| resp mb |
			mb := MessageBox new.
			mb
				buttonStyle: #yesNoCancel;
				caption: 'Dolphin Notepad'.
			resp := mb warning: ('Cannot find the <1p> file.<n><n>Do you want to create a new file?' 
								expandMacrosWith: pathString).
			resp == #yes ifTrue: [self filename: pathString] ifFalse: [resp == #cancel ifTrue: [self exit]]]!

saveChangesPrompt
	| docName |
	docName := self hasFilename ifTrue: [self filename] ifFalse: ['Untitled'].
	^'The text in the <1s> file has changed.<n><n>Do you want to save the changes?' 
		expandMacrosWith: docName!

streamIn: aStream
	"Private - Stream the receiver's model contents in from aStream.
	Implementation Note: Override this purely to exclude RichText and ancillaries from
	the deployed image. In this case the base class probably attempts to do too much."

	self setDocumentData: (aStream setToEnd; contents).! !
!Notepad categoriesFor: #aboutNotepad!commands!public! !
!Notepad categoriesFor: #chooseFont!commands!public! !
!Notepad categoriesFor: #editTimeStamp!commands!public! !
!Notepad categoriesFor: #openFile:!operations!public! !
!Notepad categoriesFor: #saveChangesPrompt!private! !
!Notepad categoriesFor: #streamIn:!private!streaming! !

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

addSamplesFolderIcon
	Smalltalk developmentSystem 
		addSamplesFolderIconFor: self
		description: self displayString
		helpId: 10623!

closeResourceLib
	ResourceLib isNil ifFalse: [ResourceLib close. ResourceLib := nil].
!

icon
	"Answers an Icon that can be used to represent this class.
	Use the one from the real Windows Notepad for fun."

	^Icon fromId: (OSVERSIONINFO current isWinXPOrLater ifTrue: [2] ifFalse: [1])
		in: self resourceLib!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	self addSamplesFolderIcon.
	SessionManager current 
		when: #sessionStarted
		send: #onStartup
		to: self!

onPreStripImage
	"Private - The image is about to be stripped. Nil any lazily initialized class variables."

	self closeResourceLib.
	SessionManager current removeEventsTriggeredFor: self!

onStartup
	"Private - The system is starting, perform initialization actions.
	Implementation Note: We use the icon from the actual system Notepad tool, which is
	different on Windows XP than other versions of Windows, so we must refresh on 
	every startup."

	self addSamplesFolderIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(ColorRef)  8 4278190080 0 551 0 0 0 416 788230 ##(BorderLayout)  1 1 0 0 0 0 410 8 ##(MultilineTextEdit)  98 16 0 416 98 2 8 1143017796 1025 560 0 482 512 0 7 0 263174 ##(Font)  0 16 459014 ##(LOGFONT)  8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 49 70 105 120 101 100 115 121 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Point)  193 193 0 560 0 8 4294907497 852486 ##(NullConverter)  0 0 9 983302 ##(MessageSequence)  202 208 98 3 721670 ##(MessageSend)  8 #createAt:extent: 98 2 738 1 1 738 1265 853 560 882 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 560 882 8 #isTextModified: 98 1 32 560 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 120 2 0 0 170 1 0 0] 98 0 738 193 193 0 27 234 256 98 2 560 8 'document' 0 461638 4 ##(MenuBar)  0 16 98 4 265030 4 ##(Menu)  0 16 98 9 984134 2 ##(CommandMenuItem)  1 1180998 4 ##(CommandDescription)  8 #fileNew 8 '&New' 8349 1 0 0 0 1330 1 1362 8 #fileOpen 8 '&Open' 8351 1 0 0 0 1330 1 1362 8 #fileSave 8 '&Save' 8359 1 0 0 0 1330 1 1362 8 #fileSaveAs 8 'Save &As...' 1 1 0 0 0 983366 1 ##(DividerMenuItem)  4097 1330 1 1362 8 #filePageSetup 8 'Page Set&up...' 1 1 0 0 0 1330 1 1362 8 #filePrint 8 '&Print' 8353 1 0 0 0 1618 4097 1330 1 1362 8 #exit 8 'E&xit' 1 1 0 0 0 8 '&File' 0 1 0 0 12665 0 0 1282 0 16 98 14 1330 1 1362 8 #undo 8 '&Undo' 9397 1 0 0 0 1618 4097 1330 1 1362 8 #cutSelection 8 'Cu&t' 9393 1 0 0 0 1330 1 1362 8 #copySelection 8 '&Copy' 9351 1 0 0 0 1330 1 1362 8 #pasteClipboard 8 '&Paste' 9389 1 0 0 0 1330 1 1362 8 #clearSelection 8 'De&lete	Del' 1 1 0 0 0 1618 4097 1330 1 1362 8 #find 8 '&Find...' 9357 1 0 0 0 1330 1 1362 8 #findNext 8 'Find &Next' 1253 1 0 0 0 1330 1 1362 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 1330 1 1362 8 #editGoto 8 '&Go to...' 8335 1 0 0 0 1618 4097 1330 1 1362 8 #selectAll 8 'Select &All' 9347 1 0 0 0 1330 1 1362 8 #editTimeStamp 8 'Time/&Date' 233 1 0 0 0 8 '&Edit' 0 1 0 0 12689 0 0 1282 0 16 98 2 1330 1 1362 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 1330 1 1362 8 #chooseFont 8 '&Font...' 1 1 0 0 0 8 'F&ormat' 0 1 0 0 12695 0 0 1282 0 16 98 3 1330 1 1362 8 #helpTopics 8 'Help Topics' 1 1 0 0 0 1618 4097 1330 1 1362 8 #aboutNotepad 8 '&About Dolphin Notepad' 1 1 0 0 0 8 '&Help' 0 1 0 0 12701 0 0 8 '' 0 1 0 0 0 0 0 0 1049350 ##(AcceleratorTable)  0 16 98 14 721414 ##(Association)  8349 1376 3106 8351 1440 3106 8359 1504 3106 8353 1728 3106 9397 1920 3106 9393 2000 3106 9351 2064 3106 9389 2128 3106 9357 2272 3106 1253 2336 3106 9361 2400 3106 8335 2464 3106 9347 2544 3106 233 2608 560 1 0 0 0 0 1 0 0 818 202 208 98 3 882 912 98 2 738 20001 20001 738 1281 961 416 882 8 #text: 98 1 8 'Dolphin Notepad' 416 882 8 #menuBar: 98 1 1248 416 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 39 0 0 16 39 0 0 144 41 0 0 240 40 0 0] 98 1 560 1168 0 27 )!

resourceLib
	"Answer the notepad resource library (notepad.exe)"

	ResourceLib isNil ifTrue: [ResourceLib := ExternalResourceLibrary open: 'notepad.exe'].
	^ResourceLib!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system.
		self uninitialize
	"

	self closeResourceLib.
	Smalltalk developmentSystem removeSystemFolderIconNamed: self displayString.
	SessionManager current removeEventsTriggeredFor: self! !
!Notepad class categoriesFor: #about!enquiries!private! !
!Notepad class categoriesFor: #aboutTemplate!enquiries!private! !
!Notepad class categoriesFor: #addSamplesFolderIcon!development!initializing!private! !
!Notepad class categoriesFor: #closeResourceLib!helpers!private! !
!Notepad class categoriesFor: #icon!constants!public! !
!Notepad class categoriesFor: #initialize!development!initializing!private! !
!Notepad class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Notepad class categoriesFor: #onStartup!development!events-session!private! !
!Notepad class categoriesFor: #resource_Default_view!public!resources-views! !
!Notepad class categoriesFor: #resourceLib!constants!public! !
!Notepad class categoriesFor: #uninitialize!development!initializing!private! !

