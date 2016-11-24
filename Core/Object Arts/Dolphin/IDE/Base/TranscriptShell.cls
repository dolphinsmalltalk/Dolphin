"Filed out from Dolphin Smalltalk 7"!

Shell subclass: #TranscriptShell
	instanceVariableNames: 'outputWindow buffer bufferProtect'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'DefaultExtent FlashOnOutput'!
TranscriptShell guid: (GUID fromString: '{87B4C6C5-026E-11D3-9FD7-00A0CC3E4A32}')!
TranscriptShell comment: 'TranscriptShell is a <SmalltalkToolShell> that implements the Transcript notification logging window.

Note that although TranscriptShell is a development tool, it is not dependent on the Development System package to operate. Among the Dolphin development tools it is unusual in that its model is not SmalltalkSystem, which means that it has to reproduce some of the functionality normally implemented there.

Instance Variables:
	workspacePresenter		<SmalltalkWorkspace> displaying the contents of the Transcript.
	buffer			<WriteStream> for accepting logging information.
	bufferProtect		<Mutex> protecting the buffer.

'!
!TranscriptShell categoriesForClass!Development!MVP-Presenters!MVP-Resources-IDE Tools! !
!TranscriptShell methodsFor!

addToCommandRoute: route
	"Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer self to have the command policy decide where
	to go next.
	Implementation Note: We want to include the development system if it is present."

	route 
		appendPresenter: self;
		appendTarget: Smalltalk developmentSystem!

alertUser
	"Private - Attempt to catch the users attention to inform them that output has been
	displayed in this window."

	| shell |
	shell := self view.
	shell isWindowVisible ifFalse: [shell showMinimizedNoActivate].
	shell flash: 3 flags: FLASHW_TRAY!

basicPrint: printee
	"Private - Ask the <Object>, printee, to append its basic textual description
	to the receiver."

	bufferProtect critical: [printee basicPrintOn: buffer]
!

clear
	"Remove all contents in the receiver's view"

	self clearAll!

clearAll
	"Remove all contents in the receiver's view"

	self flush.
	self hasOutputWindow ifTrue: [outputWindow clear]!

close
	"This is present to complete the implementation of the protocol <sequencedStream>."

	self flush!

contents
	"Answer all of the objects in the collection accessed by the receiver.
	Generally the collection will be the same class as the one accessed by the receiver."

	| text |
	text := self hasOutputWindow
		ifTrue: [outputWindow plainText]
		ifFalse: [''].
	bufferProtect critical: [text := text, buffer contents].
	^text!

cr
	"Append a line delimiter to the receiver (N.B. For Windows this is a CR-LF sequence)."

	self nextPutAll: String lineDelimiter; flush!

createComponents
	"Create the presenters contained by the receiver.
	There are none. We use access the output window view directly."

	super createComponents.

	outputWindow := DeafObject current!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.
	self when: #closeRequested: send: #onCloseRequested: to: self.!

crtab
	"Append a new line to the receiver followed by a tab"

	self crtab: 1!

crtab: count
	"Append a new line to the receiver followed by <integer>, count, tabs."

	self cr.
	count timesRepeat: [self tab]!

defaultHelpId
	^10891!

display: anObject
	"Ask anObject to append its end-user textual description to the receiver."

	bufferProtect critical: [anObject displayOn: buffer]!

fileFileIn
	"The user has selected the standard File/File In command. Prompt for a file
	(containing chunks) and file it in."

	| filename |
	filename := (FileOpenDialog new)
				caption: 'File in...';
				fileTypes: (Array with: self smalltalkFilesType with: FileDialog allFilesType);
				defaultExtension: '';
				showModal.
	filename notNil
		ifTrue: [Cursor wait showWhile: [self class sourceManager fileIn: filename normalizeLineEndings: true]]!

flush
	"Flush the buffered output to the display."

	buffer position == 0 ifTrue: [^self].
	bufferProtect critical: [self hasOutputWindow ifTrue: [self updateWindow]].
	(self class flashOnOutput and: [self view isActive not]) ifTrue: [self alertUser]!

forgetSize
	"Forget the default size for new instances of this tool."

	self class defaultExtent: nil!

hasOutputWindow
	"Private - Answer whether the receiver has an open output window available."

	^outputWindow isOpen == true!

initialize
	"Private - Initialize the receiver."

	super initialize.
	buffer := String writeStream.
	bufferProtect := Mutex new.!

isEmpty
	"Answer whether the Stream is accessing an empty collection"

	^self contents isEmpty!

next: anInteger put: anObject 
	"Store the argument, anObject, as the next anInteger number of elements accessible by the receiver. 
	Answer anObject."

	^bufferProtect critical: [buffer next: anInteger put: anObject]!

next: sizeInteger putAll: aSequenceableCollection startingAt: startInteger 
	"Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	^bufferProtect critical: 
			[buffer 
				next: sizeInteger
				putAll: aSequenceableCollection
				startingAt: startInteger]!

nextPut: aCharacter 
	"Append the <character> argument to the receiver."

	^bufferProtect critical: [buffer nextPut: aCharacter]!

nextPutAll: insertString 
	"Append the <readableString>, insertString, to the text of the receiver."

	^bufferProtect critical: [buffer nextPutAll: insertString]!

notEmpty
	"Answer whether the Stream is accessing an empty collection"

	^self isEmpty not!

onCloseRequested: aBooleanValue 
	"Handler for a close request event. The Transcript is never closed
	but is hidden instead"

	self == Transcript ifFalse: [^self].
	self hide.
	"If this Transcript was the only visible window, then perhaps exit?"
	SessionManager inputState hasVisibleWindows ifFalse: [SessionManager current exit].
	aBooleanValue value: false!

onViewOpened
	"Private - Received when the receiver's view is been connected. "

	super onViewOpened.

	outputWindow := self view viewNamed: 'workspace'
!

onViewRestored: aSizeEvent 
	"#149: In order to workaround the problem of a restored Transcript not displaying any output
	sent when it was closed, we have to perturb it a bit. This seems to be a bug in the RichEdit
	control , since this workaround is not necessary when using a multi-line text edit. Thanks
	to Mikael Svane for this fix."

	outputWindow
		scrollUp;
		scrollDown.
	^super onViewRestored: aSizeEvent!

position
	"Answer the receiver's current position reference for accessing the collection"

	self flush.
	^outputWindow caretPosition!

position: pos
	"Set the receiver's current position reference for accessing the collection
	to the the <Integer> argument, pos. If the argument is not within the bounds of
	the receiver's collection, report an error."

	self flush.
!

print: anObject
	"Prints anObject at the end of the receiver."

	bufferProtect critical: [anObject printOn: buffer]!

queryCommand: aCommandQuery
	"Private - Enter details about a potential command for the receiver into the 
	<CommandQuery>."

	| command |
	command := aCommandQuery commandSymbol.
	#forgetSize == command 
		ifTrue: 
			[aCommandQuery isEnabled: self class defaultExtent notNil.
			^true].
	^super queryCommand: aCommandQuery!

rememberThisSize
	"Record the size of the receiver as the default extent for its tool class."

	self class defaultExtent: self view extent!

reset
	"Set the receiver's position reference to the beginning of the collection"

	self position: 0
!

setToEnd
	"Set the receiver to the end of its sequence. This is part of the protocol <sequencedStream>."

	self flush.
	self hasOutputWindow ifTrue: [outputWindow caretPosition: 0]!

show
	"Shows the view of the receiver"

	self view zOrderTop.
	super show!

show: aString 
	"Append aString to the bottom of the receiver."

	"Although an original Smalltalk-80 selector, this is now considered obsolete.
	The standard stream protocols should be used when writing to the Transcript."

	self
		nextPutAll: aString;
		flush!

smalltalkFilesType
	"Private - Answer a two element array suitable for adding to the FileDialog
	with the fileTypes: message."

	^#('Smalltalk Files (*.st)' '*.st')!

space
	"Append a space to the receiver."

	self nextPutAll: ' '!

stbSaveOn: anSTBOutFiler
	"Output the singleton receiver to anSTBOutFiler."

	anSTBOutFiler saveObject: self as: (STBSingletonProxy forClass: self class)!

tab
	"Store a tab character as the next element of the receiver."

	self nextPutAll: String tab!

tab: tabCount
	"Append the specified number of tabs to the receiver."

	tabCount timesRepeat: [self tab]!

updateWindow
	| newText length |
	newText := buffer contents.
	length := outputWindow textLength.
	outputWindow
		caretPosition: length + 1;
		replaceSelection: newText.
	^buffer reset! !
!TranscriptShell categoriesFor: #addToCommandRoute:!commands!public! !
!TranscriptShell categoriesFor: #alertUser!operations!private! !
!TranscriptShell categoriesFor: #basicPrint:!printing!private! !
!TranscriptShell categoriesFor: #clear!initializing!public! !
!TranscriptShell categoriesFor: #clearAll!initializing!public! !
!TranscriptShell categoriesFor: #close!operations!public! !
!TranscriptShell categoriesFor: #contents!accessing!public! !
!TranscriptShell categoriesFor: #cr!adding!public! !
!TranscriptShell categoriesFor: #createComponents!initializing!public! !
!TranscriptShell categoriesFor: #createSchematicWiring!initializing!public! !
!TranscriptShell categoriesFor: #crtab!adding!public! !
!TranscriptShell categoriesFor: #crtab:!adding!public! !
!TranscriptShell categoriesFor: #defaultHelpId!public! !
!TranscriptShell categoriesFor: #display:!printing!public! !
!TranscriptShell categoriesFor: #fileFileIn!commands!public! !
!TranscriptShell categoriesFor: #flush!buffer!public! !
!TranscriptShell categoriesFor: #forgetSize!commands!public! !
!TranscriptShell categoriesFor: #hasOutputWindow!accessing!private! !
!TranscriptShell categoriesFor: #initialize!initializing!private! !
!TranscriptShell categoriesFor: #isEmpty!public!testing! !
!TranscriptShell categoriesFor: #next:put:!operations!public! !
!TranscriptShell categoriesFor: #next:putAll:startingAt:!accessing!public! !
!TranscriptShell categoriesFor: #nextPut:!adding!public! !
!TranscriptShell categoriesFor: #nextPutAll:!adding!public! !
!TranscriptShell categoriesFor: #notEmpty!public!testing! !
!TranscriptShell categoriesFor: #onCloseRequested:!event handling!public! !
!TranscriptShell categoriesFor: #onViewOpened!event handling!private! !
!TranscriptShell categoriesFor: #onViewRestored:!event handling!public! !
!TranscriptShell categoriesFor: #position!accessing!public! !
!TranscriptShell categoriesFor: #position:!accessing!public! !
!TranscriptShell categoriesFor: #print:!printing!public! !
!TranscriptShell categoriesFor: #queryCommand:!commands!private! !
!TranscriptShell categoriesFor: #rememberThisSize!commands!public! !
!TranscriptShell categoriesFor: #reset!positioning!public! !
!TranscriptShell categoriesFor: #setToEnd!operations!public! !
!TranscriptShell categoriesFor: #show!operations!public! !
!TranscriptShell categoriesFor: #show:!printing!public! !
!TranscriptShell categoriesFor: #smalltalkFilesType!constants!private! !
!TranscriptShell categoriesFor: #space!adding!public! !
!TranscriptShell categoriesFor: #stbSaveOn:!binary filing!public! !
!TranscriptShell categoriesFor: #tab!accessing!public! !
!TranscriptShell categoriesFor: #tab:!accessing!public! !
!TranscriptShell categoriesFor: #updateWindow!private!updating! !

TranscriptShell methodProtocol: #puttableStream attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!
TranscriptShell methodProtocol: #sequencedStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #isEmpty #position #position: #reset #setToEnd)!
TranscriptShell methodProtocol: #Transcript attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!

!TranscriptShell class methodsFor!

create
	"Answers an instance of the receiver with a default view.
	The receiver is a singleton whose single instance is referenced
	via a global variable (for historical and convenience reasons)
	and so we intervene to subdue calls for a new king."

	^self current
	!

current
	"Answer the singleton instance of the receiver"

	Transcript = DeafObject current 
		ifTrue: 
			[Transcript := super create.
			self defaultExtent ifNotNil: [:ext | Transcript view extent: ext]].
	^Transcript!

default
	"Answer the singleton instance of the receiver (implemented for polymorphism with 
	SmalltalkSystemShell)."

	^self current!

defaultExtent
	"Answer a <Point> which is the user's chosen default extent for new instances
	of the receiver, or nil if left up to Windows."

	^DefaultExtent!

defaultExtent: aPoint
	"Set the default extent to be used for instances of the receiver to the <Point> argument.
	If the argument is nil, then let Windows decide."

	DefaultExtent := aPoint!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'System Transcript'!

flashOnOutput
	"Answer whether the Transcript should alert the user to output when it might not
	be visible (by appearing in the tray, if not already there, and flashing a few times)."

	^FlashOnOutput!

flashOnOutput: aBoolean
	"Set whether the Transcript should alert the user to output when it might not
	be visible."

	FlashOnOutput := aBoolean!

free
	"Close and release the current transcript (e.g. to create a runtime image)."

	Transcript==DeafObject current ifFalse: [Transcript destroy].
	Transcript := DeafObject current!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	FlashOnOutput := false.		"By default, don't flash when output occurs to a Transcript which is not the active window"
	Transcript := DeafObject current!

onStartup
	"Private - The system is starting, perform initialization actions.
	Sent after windows are restored."

	self current updateCaption!

reset
	"Private - Reset the class. 
	Force the creation of an new singleton instance of the Transcript

	self reset
	"

	self free.
	^self current show!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 328198 ##(Smalltalk.Point) 1079 655 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 0 0 0 410 8 ##(Smalltalk.RichTextEdit) 98 18 0 416 98 2 8 1143013700 262145 592 0 721158 ##(Smalltalk.SystemColor) 31 0 23 265030 4 ##(Smalltalk.Menu) 0 16 98 8 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #copySelection 8 '&Copy' 9351 1 0 0 0 754 1 786 8 #selectAll 8 'Select &All' 8323 1 0 0 0 754 1 786 8 #clearAll 8 'Clea&r' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 754 1 786 8 #find 8 '&Find...' 9357 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 47 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'shell32.dll' 0 0 0 754 1 786 8 #findNext 8 'Find &Next' 1253 1 0 0 0 978 4097 754 1 786 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 0 0 592 0 8 1344963120 852486 ##(Smalltalk.NullConverter) 0 8 '' 19 0 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 32 0 230 3] 983302 ##(Smalltalk.MessageSequence) 202 208 98 6 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 530 1 1 530 1047 537 592 1522 8 #contextMenu: 98 1 720 592 1522 8 #text: 98 1 524550 ##(Smalltalk.RichText) 8 '{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\lang2057\f0\fs16 
\par }
' 592 1522 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval) 3 1 3 592 1522 8 #isTextModified: 98 1 32 592 1522 8 #resetCharFormat 98 0 592 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 11 2 0 0 12 1 0 0] 98 0 530 193 193 0 27 234 256 98 2 592 8 'workspace' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 5 706 0 16 98 9 754 1 786 8 #fileNew 8 '&New' 9373 1 1074 0 16 1120 8 'FileNew.ico' 1146 8 'dolphindr7.dll' 0 0 0 754 1 786 8 #fileOpen 8 '&Open...' 9375 1 1074 0 16 1120 8 'FileOpen.ico' 2240 0 0 754 1 786 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 978 4097 754 1 786 8 #saveImage 8 'Sa&ve Image' 1 1 1074 0 16 1120 8 'Snapshot.ico' 2240 0 0 754 1 786 8 #saveImageAs 8 'Save Image As...' 1 1 0 0 0 754 1 786 8 #compressChanges 8 '&Compress Changes' 1 1 0 0 0 978 4097 754 1 786 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 1074 0 16 1120 8 'PowerSwitch.ico' 2240 0 0 8 '&File' 0 134217729 0 0 50261 0 0 706 0 16 98 8 754 1 786 8 #cr 8 'New&line' 1 1 0 0 0 978 4097 754 1 786 816 8 '&Copy' 9351 1 1074 0 16 1120 8 'EditCopy.ico' 2240 0 0 754 1 786 880 8 'Select &All' 9347 1 0 0 0 754 1 786 944 8 'Clea&r' 9393 1 1074 0 16 1120 8 'ClearDocument.ico' 2240 0 0 978 4097 754 1 786 8 #editFind 8 '&Find...' 9357 1 1074 0 16 1120 47 1152 0 0 754 1 786 1216 8 'Find &Next' 1253 1 1074 0 16 1120 8 'FindNext.ico' 2240 0 0 8 '&Edit' 0 134217729 0 0 50275 0 0 706 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 50277 0 0 706 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 50279 0 0 706 0 16 98 6 754 1 786 8 #help 8 '&Help on this tool' 1249 1 1074 0 16 1120 49 1152 0 0 978 4097 754 1 786 8 #guidedTour 8 '&Guided tour' 1 1 0 0 0 754 1 786 8 #educationCenter 8 '&Education centre' 1 1 0 0 0 978 4097 754 1 786 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 1074 0 16 1120 8 '!!APPLICATION' 2240 0 0 8 '&Help' 0 134217729 0 0 50289 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1458 202 208 98 3 1522 1552 98 2 530 3839 21 530 1079 655 416 1522 1680 98 1 8 'System Transcript' 416 1522 8 #updateMenuBar 1920 416 1938 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 154 9 0 0 81 1 0 0] 98 1 592 2000 0 27 )!

uninitialize
	"Private - This is a singleton class so free the single instance to
	allow clean removal from the system."

	self free! !
!TranscriptShell class categoriesFor: #create!instance creation!public! !
!TranscriptShell class categoriesFor: #current!instance creation!public! !
!TranscriptShell class categoriesFor: #default!instance creation!public! !
!TranscriptShell class categoriesFor: #defaultExtent!options!public! !
!TranscriptShell class categoriesFor: #defaultExtent:!options!public! !
!TranscriptShell class categoriesFor: #displayOn:!displaying!public! !
!TranscriptShell class categoriesFor: #flashOnOutput!options!public! !
!TranscriptShell class categoriesFor: #flashOnOutput:!options!public! !
!TranscriptShell class categoriesFor: #free!public!realizing/unrealizing! !
!TranscriptShell class categoriesFor: #icon!constants!public! !
!TranscriptShell class categoriesFor: #initialize!development!initializing!private! !
!TranscriptShell class categoriesFor: #onStartup!events-session!private! !
!TranscriptShell class categoriesFor: #reset!operations!private! !
!TranscriptShell class categoriesFor: #resource_Default_view!public!resources-views! !
!TranscriptShell class categoriesFor: #uninitialize!class hierarchy-removing!private! !

