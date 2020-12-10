"Filed out from Dolphin Smalltalk 7"!

UI.Shell subclass: #'UI.TranscriptShell'
	instanceVariableNames: 'outputWindow buffer bufferProtect'
	classVariableNames: 'DefaultExtent FlashOnOutput'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.TranscriptShell guid: (Core.GUID fromString: '{87b4c6c5-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.TranscriptShell comment: 'TranscriptShell is a <SmalltalkToolShell> that implements the Transcript notification logging window.

Note that although TranscriptShell is a development tool, it is not dependent on the Development System package to operate. Among the Dolphin development tools it is unusual in that its model is not SmalltalkSystem, which means that it has to reproduce some of the functionality normally implemented there.

Instance Variables:
	workspacePresenter		<SmalltalkWorkspace> displaying the contents of the Transcript.
	buffer			<WriteStream> for accepting logging information.
	bufferProtect		<Mutex> protecting the buffer.

'!
!UI.TranscriptShell categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!UI.TranscriptShell methodsFor!

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
	filename := FileOpenDialog new
				caption: 'File in...';
				fileTypes: {self smalltalkFilesType. FileDialog allFilesType};
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
	buffer := String smalltalkWriteStream: 128.
	bufferProtect := Mutex new!

isEmpty
	"Answer whether the Stream is accessing an empty collection"

	^self contents isEmpty!

locale
	^Locale smalltalk!

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
	^buffer reset!

visit: anObject do: aNiladicValuable
	aNiladicValuable value! !
!UI.TranscriptShell categoriesFor: #<<!public! !
!UI.TranscriptShell categoriesFor: #addToCommandRoute:!commands!public! !
!UI.TranscriptShell categoriesFor: #alertUser!operations!private! !
!UI.TranscriptShell categoriesFor: #basicPrint:!printing!private! !
!UI.TranscriptShell categoriesFor: #clear!initializing!public! !
!UI.TranscriptShell categoriesFor: #clearAll!initializing!public! !
!UI.TranscriptShell categoriesFor: #close!operations!public! !
!UI.TranscriptShell categoriesFor: #contents!accessing!public! !
!UI.TranscriptShell categoriesFor: #cr!adding!public! !
!UI.TranscriptShell categoriesFor: #createComponents!initializing!public! !
!UI.TranscriptShell categoriesFor: #createSchematicWiring!initializing!public! !
!UI.TranscriptShell categoriesFor: #crtab!adding!public! !
!UI.TranscriptShell categoriesFor: #crtab:!adding!public! !
!UI.TranscriptShell categoriesFor: #defaultHelpId!public! !
!UI.TranscriptShell categoriesFor: #display:!printing!public! !
!UI.TranscriptShell categoriesFor: #fileFileIn!commands!public! !
!UI.TranscriptShell categoriesFor: #flush!buffer!public! !
!UI.TranscriptShell categoriesFor: #forgetSize!commands!public! !
!UI.TranscriptShell categoriesFor: #hasOutputWindow!accessing!private! !
!UI.TranscriptShell categoriesFor: #initialize!initializing!private! !
!UI.TranscriptShell categoriesFor: #isEmpty!public!testing! !
!UI.TranscriptShell categoriesFor: #locale!accessing!public! !
!UI.TranscriptShell categoriesFor: #next:put:!operations!public! !
!UI.TranscriptShell categoriesFor: #next:putAll:startingAt:!accessing!public! !
!UI.TranscriptShell categoriesFor: #nextPut:!adding!public! !
!UI.TranscriptShell categoriesFor: #nextPutAll:!adding!public! !
!UI.TranscriptShell categoriesFor: #notEmpty!public!testing! !
!UI.TranscriptShell categoriesFor: #onCloseRequested:!event handling!public! !
!UI.TranscriptShell categoriesFor: #onViewOpened!event handling!private! !
!UI.TranscriptShell categoriesFor: #onViewRestored:!event handling!public! !
!UI.TranscriptShell categoriesFor: #position!accessing!public! !
!UI.TranscriptShell categoriesFor: #position:!accessing!public! !
!UI.TranscriptShell categoriesFor: #print:!printing!public! !
!UI.TranscriptShell categoriesFor: #queryCommand:!commands!private! !
!UI.TranscriptShell categoriesFor: #rememberThisSize!commands!public! !
!UI.TranscriptShell categoriesFor: #reset!positioning!public! !
!UI.TranscriptShell categoriesFor: #setToEnd!operations!public! !
!UI.TranscriptShell categoriesFor: #show!operations!public! !
!UI.TranscriptShell categoriesFor: #show:!printing!public! !
!UI.TranscriptShell categoriesFor: #smalltalkFilesType!constants!private! !
!UI.TranscriptShell categoriesFor: #space!adding!public! !
!UI.TranscriptShell categoriesFor: #stbSaveOn:!binary filing!public! !
!UI.TranscriptShell categoriesFor: #tab!accessing!public! !
!UI.TranscriptShell categoriesFor: #tab:!accessing!public! !
!UI.TranscriptShell categoriesFor: #updateWindow!private!updating! !
!UI.TranscriptShell categoriesFor: #visit:do:!public! !

UI.TranscriptShell methodProtocol: #puttableStream attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!
UI.TranscriptShell methodProtocol: #sequencedStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #isEmpty #position #position: #reset #setToEnd)!
UI.TranscriptShell methodProtocol: #Transcript attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!

!UI.TranscriptShell class methodsFor!

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

defaultView
	"Answer the resource name of the default view for the receiver.
	Scintilla is preferred when available, not least because it is much more performant as a scrolling output window than the simple Multiline Edit control."

	^'Scintilla view'!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'System Transcript'!

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

	^#(#'!!STL' 4 788558 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Graphics.Color) #default 328198 ##(Graphics.Point) 1079 655 549 265030 4 ##(UI.Menu) nil true 34 8 984134 2 ##(UI.CommandMenuItem) 1 1180998 4 ##(UI.CommandDescription) #copySelection 8 '&Copy' 9351 1 263494 3 ##(Graphics.Icon) nil true 1572870 ##(Kernel.ImageRelativeFileLocator) 8 'EditCopy.ico' 2032142 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 578 1 610 #selectAll 8 'Select &All' 8323 1 nil nil nil 578 1 610 #clearAll 8 'Clea&r' 1 1 658 nil true 704 8 'ClearDocument.ico' 752 nil nil 983366 1 ##(UI.DividerMenuItem) 4097 578 1 610 #find 8 '&Find...' 9357 1 658 nil true 704 47 746 8 'shell32.dll' nil nil nil 578 1 610 #findNext 8 'Find &Next' 1253 1 658 nil true 704 8 'FindNext.ico' 752 nil nil 914 4097 578 1 610 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil nil nil 416 788230 ##(UI.BorderLayout) 1 1 nil nil nil nil 410 ##(UI.MultilineTextEdit) 34 16 nil 416 34 2 8 1143013700 262145 1232 nil 466 #window nil 23 nil nil nil 1232 nil 8 1892929408 852486 ##(UI.NullConverter) nil 8 '' 3 983302 ##(Core.MessageSequence) 138 144 34 3 721670 ##(Core.MessageSend) #createAt:extent: 34 2 498 1 1 498 1047 537 1232 1442 #setMarginWidths: 34 1 8 #(3 3) 1232 1442 #textLimit: 34 1 8 4294967295 1232 983302 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 11 2 0 0 12 1 0 0] 8 #() 498 193 193 nil 27 170 192 34 2 1232 8 'workspace' nil 461638 4 ##(UI.MenuBar) nil true 34 5 530 nil true 34 9 578 1 610 #fileNew 8 '&New Workspace' 9373 1 658 nil true 704 8 'NewWorkspace.ico' 752 nil nil 578 1 610 #fileOpen 8 '&Open Workspace...' 9375 1 658 nil true 704 8 'OpenWorkspace.ico' 752 nil nil 578 1 610 #fileFileIn 8 '&File In...' 1 1 nil nil nil 914 4097 578 1 610 #saveImage 8 'Sa&ve Image' 1 1 658 nil true 704 8 'Snapshot.ico' 752 nil nil 578 1 610 #saveImageAs 8 'Save Image As...' 1 1 nil nil nil 578 1 610 #compressChanges 8 '&Compress Changes' 1 1 nil nil nil 914 4097 578 1 610 #smalltalkExit 8 'E&xit Dolphin' 1 1 658 nil true 704 8 'PowerSwitch.ico' 752 nil nil 8 '&File' nil 134217729 nil nil 36919 nil nil 530 nil true 34 8 578 1 610 #cr 8 'New&line' 1 1 nil nil nil 914 4097 578 1 610 #copySelection 8 '&Copy' 9351 1 658 nil true 704 8 'EditCopy.ico' 752 nil nil 578 1 610 #selectAll 8 'Select &All' 9347 1 nil nil nil 578 1 610 #clearAll 8 'Clea&r' 9393 1 658 nil true 704 8 'ClearDocument.ico' 752 nil nil 914 4097 578 1 610 #editFind 8 '&Find...' 9357 1 658 nil true 704 47 1008 nil nil 578 1 610 #findNext 8 'Find &Next' 1253 1 658 nil true 704 8 'FindNext.ico' 752 nil nil 8 '&Edit' nil 134217729 nil nil 36933 nil nil 530 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 36935 nil nil 530 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 36937 nil nil 530 nil true 34 6 578 1 610 #help 8 '&Help on this tool' 1249 1 658 nil true 704 8 'Help.ico' 752 nil nil 914 4097 578 1 610 #guidedTour 8 '&Guided tour' 1 1 nil nil nil 578 1 610 #educationCenter 8 '&Education centre' 1 1 nil nil nil 914 4097 578 1 610 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 36947 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1378 138 144 34 3 1442 #createAt:extent: 34 2 498 6143 21 498 1079 655 416 1442 #contextMenu: 34 1 544 416 1442 #text: 34 1 8 'System Transcript' 416 1618 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 26 14 0 0 81 1 0 0] 34 1 1232 1680 nil 27 )!

uninitialize
	"Private - This is a singleton class so free the single instance to
	allow clean removal from the system."

	self free! !
!UI.TranscriptShell class categoriesFor: #create!instance creation!public! !
!UI.TranscriptShell class categoriesFor: #current!instance creation!public! !
!UI.TranscriptShell class categoriesFor: #default!instance creation!public! !
!UI.TranscriptShell class categoriesFor: #defaultExtent!options!public! !
!UI.TranscriptShell class categoriesFor: #defaultExtent:!options!public! !
!UI.TranscriptShell class categoriesFor: #defaultView!constants!public! !
!UI.TranscriptShell class categoriesFor: #displayOn:!displaying!public! !
!UI.TranscriptShell class categoriesFor: #flashOnOutput!options!public! !
!UI.TranscriptShell class categoriesFor: #flashOnOutput:!options!public! !
!UI.TranscriptShell class categoriesFor: #free!public!realizing/unrealizing! !
!UI.TranscriptShell class categoriesFor: #icon!constants!public! !
!UI.TranscriptShell class categoriesFor: #initialize!development!initializing!private! !
!UI.TranscriptShell class categoriesFor: #onStartup!events-session!private! !
!UI.TranscriptShell class categoriesFor: #reset!operations!private! !
!UI.TranscriptShell class categoriesFor: #resource_Default_view!public!resources-views! !
!UI.TranscriptShell class categoriesFor: #uninitialize!class hierarchy-removing!private! !

