"Filed out from Dolphin Smalltalk 7"!

Shell subclass: #TranscriptShell
	instanceVariableNames: 'outputWindow buffer bufferProtect'
	classVariableNames: 'DefaultExtent FlashOnOutput'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
TranscriptShell guid: (GUID fromString: '{87b4c6c5-026e-11d3-9fd7-00a0cc3e4a32}')!
TranscriptShell comment: 'TranscriptShell is a <SmalltalkToolShell> that implements the Transcript notification logging window.

Note that although TranscriptShell is a development tool, it is not dependent on the Development System package to operate. Among the Dolphin development tools it is unusual in that its model is not SmalltalkSystem, which means that it has to reproduce some of the functionality normally implemented there.

Instance Variables:
	workspacePresenter		<SmalltalkWorkspace> displaying the contents of the Transcript.
	buffer			<WriteStream> for accepting logging information.
	bufferProtect		<Mutex> protecting the buffer.

'!
!TranscriptShell categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!TranscriptShell methodsFor!

<< anObject
	"Store the argument, or the elements of the argument if it is a <collection>, as the next element or elements of the receiver."

	anObject appendToStream: self.
	^self!

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

	| newBuffer |
	self flush.
	self hasOutputWindow ifTrue: [outputWindow clear].
	newBuffer := String writeStream.
	bufferProtect critical: [buffer := newBuffer]!

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
	buffer := String writeStream: 128.
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
!TranscriptShell categoriesFor: #<<!public! !
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 1079 655 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 416 34 2 8 1143013700 262145 560 nil 466 #window nil 23 265030 4 ##(Smalltalk.Menu) nil true 34 8 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #copySelection 8 '&Copy' 9351 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditCopy.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 690 1 722 #selectAll 8 'Select &All' 8323 1 nil nil nil 690 1 722 #clearAll 8 'Clea&r' 1 1 770 nil true 816 8 'ClearDocument.ico' 864 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 690 1 722 #find 8 '&Find...' 9357 1 770 nil true 816 47 858 8 'shell32.dll' nil nil nil 690 1 722 #findNext 8 'Find &Next' 1253 1 770 nil true 816 8 'FindNext.ico' 864 nil nil 1026 4097 690 1 722 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil nil nil 560 nil 8 1903872368 852486 ##(Smalltalk.NullConverter) nil 8 '' 3 983302 ##(Smalltalk.MessageSequence) 138 144 34 4 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 1 1 498 1047 537 560 1442 #contextMenu: 34 1 656 560 1442 #setMarginWidths: 34 1 8 #(3 3) 560 1442 #textLimit: 34 1 8 4294967295 560 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 11 2 0 0 12 1 0 0] 8 #() 498 193 193 nil 27 170 192 34 2 560 8 'workspace' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 5 642 nil true 34 9 690 1 722 #fileNew 8 '&New Workspace' 9373 1 770 nil true 816 8 'NewWorkspace.ico' 864 nil nil 690 1 722 #fileOpen 8 '&Open Workspace...' 9375 1 770 nil true 816 8 'OpenWorkspace.ico' 864 nil nil 690 1 722 #fileFileIn 8 '&File In...' 1 1 nil nil nil 1026 4097 690 1 722 #saveImage 8 'Sa&ve Image' 1 1 770 nil true 816 8 'Snapshot.ico' 864 nil nil 690 1 722 #saveImageAs 8 'Save Image As...' 1 1 nil nil nil 690 1 722 #compressChanges 8 '&Compress Changes' 1 1 nil nil nil 1026 4097 690 1 722 #smalltalkExit 8 'E&xit Dolphin' 1 1 770 nil true 816 8 'PowerSwitch.ico' 864 nil nil 8 '&File' nil 134217729 nil nil 11677 nil nil 642 nil true 34 8 690 1 722 #cr 8 'New&line' 1 1 nil nil nil 1026 4097 690 1 722 #copySelection 8 '&Copy' 9351 1 770 nil true 816 8 'EditCopy.ico' 864 nil nil 690 1 722 #selectAll 8 'Select &All' 9347 1 nil nil nil 690 1 722 #clearAll 8 'Clea&r' 9393 1 770 nil true 816 8 'ClearDocument.ico' 864 nil nil 1026 4097 690 1 722 #editFind 8 '&Find...' 9357 1 770 nil true 816 47 1120 nil nil 690 1 722 #findNext 8 'Find &Next' 1253 1 770 nil true 816 8 'FindNext.ico' 864 nil nil 8 '&Edit' nil 134217729 nil nil 11691 nil nil 642 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 11693 nil nil 642 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 11695 nil nil 642 nil true 34 6 690 1 722 #help 8 '&Help on this tool' 1249 1 770 nil true 816 8 'Help.ico' 864 nil nil 1026 4097 690 1 722 #guidedTour 8 '&Guided tour' 1 1 nil nil nil 690 1 722 #educationCenter 8 '&Education centre' 1 1 nil nil nil 1026 4097 690 1 722 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 11705 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1378 138 144 34 3 1442 #createAt:extent: 34 2 498 3839 21 498 1079 655 416 1442 #text: 34 1 8 'System Transcript' 416 1442 #updateMenuBar 8 #() 416 1650 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 154 9 0 0 81 1 0 0] 34 1 560 1712 nil 27 )!

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

