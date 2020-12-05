"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'UI.Scintilla.KeyBinding'
	instanceVariableNames: 'acceleratorKey message'
	classVariableNames: 'Commands VirtualKeyMap'
	imports: #(#{OS.Win32Constants} #{UI.Scintilla.ScintillaConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.KeyBinding guid: (Core.GUID fromString: '{bf35c065-fef0-4aa1-8dcd-e40e73c5447a}')!
UI.Scintilla.KeyBinding comment: 'ScintillaKeyBinding is a support class for the ScintillaView, used to represent the key bindings defined in a particular instance. The control itself defines a large set of default mappings, but these can be replaced and/or augmented.

Instance Variables:
	acceleratorKey		<integer>. Dolphin format accelerator key combination (combines a VK_xxx, and FALT/FSHIFT/FCONTROL flags)
	message			<iInteger> from the valid SCI_xxx messages that can be used as commands

Class Variables:
	VirtualKeyMap		<Array> of <integer>s used to map Windows VK_xxx codes to Scintilla SCK_xxx codes.
	Commands		<IdentityDictionary> mapping Dolphin accelerator key codes to command symbols.

'!
!UI.Scintilla.KeyBinding categoriesForClass!MVP-Views-Support! !
!UI.Scintilla.KeyBinding methodsFor!

= comparand 
	^self species == comparand species 
		and: [self acceleratorKey = comparand acceleratorKey and: [self message = comparand message]]!

acceleratorKey
	"Answers the <integer> accelerator key code for the receiver, or zero if there is none."

	^acceleratorKey!

acceleratorKey: code
	"Set the receiver's accelerator key code to the <integer> argument, code."

	acceleratorKey := code!

acceleratorKeyDisplayString
	"Answers the <readableString> accelerator key string for the receiver as named on the default Keyboard, or an empty <String> if there is none."

	^AcceleratorTable keyStringFromCode: self acceleratorKey!

acceleratorKeyString
	"Answers the <readableString> accelerator key string for the receiver as named on the default Keyboard, or an empty <String> if there is none."

	^AcceleratorTable keyStringFromCode: self acceleratorKey!

acceleratorKeyString: keys
	"Sets the accelerator key to the key code generated from parsing the <readableString>
	accelerator key description, keys. The string is assumed to be using UK English key names."

	self acceleratorKey: (AcceleratorTable keyCodeFromInvariantString: keys)!

commandSymbol
	"Answers the <Symbol>ic command forwarded to a command target when the receiver's
	accelerator key combination is pressed."

	^message ifNotNil: [Commands at: message]!

commandSymbol: aSymbol 
	"Set the <Symbol>ic command forwarded to a command target when the receiver's
	accelerator key combination is pressed."

	message := Commands keyAtValue: aSymbol!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	#todo.	"Take account of Locale in printing accelerator key - need to convert to some default keyboard layout for the Locale of the stream."
	aPuttableStream
		nextPutAll: self acceleratorKeyDisplayString;
		nextPutAll: ' -> ';
		print: self commandSymbol!

hash
	^acceleratorKey hash!

message
	^message!

message: anInteger 
	message := anInteger!

printOn: target 
	super printOn: target.
	target
		nextPut: $(;
		display: self;
		nextPut: $)!

scintillaKeyCode
	^(self translateVirtualKey: acceleratorKey) + ((acceleratorKey bitAnd: 16r3800) bitShift: 5)!

translateVirtualKey: vkInteger 
	"Private - Translate from a Windows Virtual Key code (VK_xxx) to the corresponding Scintilla
	key code (SCK_xxx)"

	^VirtualKeyMap at: (vkInteger bitAnd: 16rFF) + 1! !
!UI.Scintilla.KeyBinding categoriesFor: #=!comparing!public! !
!UI.Scintilla.KeyBinding categoriesFor: #acceleratorKey!accessing!public! !
!UI.Scintilla.KeyBinding categoriesFor: #acceleratorKey:!accessing!public! !
!UI.Scintilla.KeyBinding categoriesFor: #acceleratorKeyDisplayString!accessing!public! !
!UI.Scintilla.KeyBinding categoriesFor: #acceleratorKeyString!accessing!public! !
!UI.Scintilla.KeyBinding categoriesFor: #acceleratorKeyString:!accessing!public! !
!UI.Scintilla.KeyBinding categoriesFor: #commandSymbol!accessing!public! !
!UI.Scintilla.KeyBinding categoriesFor: #commandSymbol:!accessing!public! !
!UI.Scintilla.KeyBinding categoriesFor: #displayOn:!printing!public! !
!UI.Scintilla.KeyBinding categoriesFor: #hash!comparing!public! !
!UI.Scintilla.KeyBinding categoriesFor: #message!accessing!private! !
!UI.Scintilla.KeyBinding categoriesFor: #message:!accessing!private! !
!UI.Scintilla.KeyBinding categoriesFor: #printOn:!printing!public! !
!UI.Scintilla.KeyBinding categoriesFor: #scintillaKeyCode!accessing!private! !
!UI.Scintilla.KeyBinding categoriesFor: #translateVirtualKey:!helpers!private! !

!UI.Scintilla.KeyBinding class methodsFor!

icon
	^ScintillaView icon!

initialize
	"Private - Initialize the receiver's class variables, etc
		self initialize
	"

	self initializeVirtualKeyMap.
	self initializeCommands!

initializeCommands
	Commands := IdentityDictionary new
				at: SCI_BACKTAB put: #unindent;
				at: SCI_CANCEL put: #cancelModes;
				at: SCI_CHARLEFT put: #moveLeft;
				at: SCI_CHARLEFTEXTEND put: #extendLeft;
				at: SCI_CHARLEFTRECTEXTEND put: #extendRectangleLeft;
				at: SCI_CHARRIGHT put: #moveRight;
				at: SCI_CHARRIGHTEXTEND put: #extendRight;
				at: SCI_CHARRIGHTRECTEXTEND put: #extendRectangleRight;
				at: SCI_CLEAR put: #basicClearSelection;
				at: SCI_CLEARALL put: #basicClearAll;
				at: SCI_COPY put: #copySelection;
				at: SCI_CUT put: #cutSelection;
				at: SCI_DELETEBACK put: #backspace;
				at: SCI_DELETEBACKNOTLINE put: #backspaceNoLine;
				at: SCI_DELLINELEFT put: #deleteToStartOfLine;
				at: SCI_DELLINERIGHT put: #deleteToEndOfLine;
				at: SCI_DELWORDLEFT put: #deleteToStartOfWord;
				at: SCI_DELWORDRIGHT put: #deleteToNextWord;
				at: SCI_DELWORDRIGHTEND put: #deleteToEndOfWord;
				at: SCI_DOCUMENTEND put: #moveToEndOfDocument;
				at: SCI_DOCUMENTENDEXTEND put: #extendToEndOfDocument;
				at: SCI_DOCUMENTSTART put: #moveToStartOfDocument;
				at: SCI_DOCUMENTSTARTEXTEND put: #extendToStartOfDocument;
				at: SCI_EDITTOGGLEOVERTYPE put: #toggleOvertype;
				at: SCI_FORMFEED put: #formFeed;
				at: SCI_HOME put: #moveToStartOfLine;
				at: SCI_HOMEDISPLAY put: #moveToStartOfDisplayLine;
				at: SCI_HOMEDISPLAYEXTEND put: #extendToStartOfDisplayLine;
				at: SCI_HOMEEXTEND put: #extendToStartOfLine;
				at: SCI_HOMERECTEXTEND put: #extendRectangleToStartOfLine;
				at: SCI_HOMEWRAP put: #moveToStartOfWrappedLine;
				at: SCI_HOMEWRAPEXTEND put: #extendToStartOfWrappedLine;
				at: SCI_LINECOPY put: #copyLine;
				at: SCI_LINECUT put: #cutLine;
				at: SCI_LINEDELETE put: #deleteLine;
				at: SCI_LINEDOWN put: #moveDown;
				at: SCI_LINEDOWNEXTEND put: #extendDown;
				at: SCI_LINEDOWNRECTEXTEND put: #extendRectangleDown;
				at: SCI_LINEDUPLICATE put: #duplicateLine;
				at: SCI_LINEEND put: #moveToEndOfLine;
				at: SCI_LINEENDDISPLAY put: #moveToEndOfDisplayLine;
				at: SCI_LINEENDDISPLAYEXTEND put: #extendToEndOfDisplayLine;
				at: SCI_LINEENDEXTEND put: #extendToEndOfLine;
				at: SCI_LINEENDRECTEXTEND put: #extendRectangleToEndOfLine;
				at: SCI_LINEENDWRAP put: #moveToEndOfWrappedLine;
				at: SCI_LINEENDWRAPEXTEND put: #extendToEndOfWrappedLine;
				at: SCI_LINEREVERSE put: #reverseSelectedLines;
				at: SCI_LINESCROLLDOWN put: #scrollDown;
				at: SCI_LINESCROLLUP put: #scrollUp;
				at: SCI_LINESJOIN put: #joinTarget;
				at: SCI_LINETRANSPOSE put: #twiddleLines;
				at: SCI_LINEUP put: #moveUp;
				at: SCI_LINEUPEXTEND put: #extendUp;
				at: SCI_LINEUPRECTEXTEND put: #extendRectangleUp;
				at: SCI_LOWERCASE put: #convertToLowercase;
				at: SCI_MOVECARETINSIDEVIEW put: #moveCaretInsideView;
				at: SCI_MOVESELECTEDLINESDOWN put: #moveSelectedLinesDown;
				at: SCI_MOVESELECTEDLINESUP put: #moveSelectedLinesUp;
				at: SCI_NEWLINE put: #newLine;
				at: SCI_PAGEDOWN put: #movePageDown;
				at: SCI_PAGEDOWNEXTEND put: #extendPageDown;
				at: SCI_PAGEDOWNRECTEXTEND put: #extendRectanglePageDown;
				at: SCI_PAGEUP put: #movePageUp;
				at: SCI_PAGEUPEXTEND put: #extendPageUp;
				at: SCI_PAGEUPRECTEXTEND put: #extendRectanglePageUp;
				at: SCI_PARADOWN put: #moveParaDown;
				at: SCI_PARADOWNEXTEND put: #extendParaDown;
				at: SCI_PARAUP put: #moveParaUp;
				at: SCI_PARAUPEXTEND put: #extendParaUp;
				at: SCI_PASTE put: #pasteClipboard;
				at: SCI_REDO put: #redo;
				at: SCI_SCROLLTOEND put: #scrollToEnd;
				at: SCI_SCROLLTOSTART put: #scrollToStart;
				at: SCI_SELECTALL put: #basicSelectAll;
				at: SCI_SELECTIONDUPLICATE put: #duplicateSelection;
				at: SCI_SETZOOM put: #resetZoom;
				at: SCI_STARTRECORD put: #startRecording;
				at: SCI_STOPRECORD put: #stopRecording;
				at: SCI_STUTTEREDPAGEDOWN put: #moveStutteredPageDown;
				at: SCI_STUTTEREDPAGEDOWNEXTEND put: #extendStutteredPageDown;
				at: SCI_STUTTEREDPAGEUP put: #moveStutteredPageUp;
				at: SCI_STUTTEREDPAGEUPEXTEND put: #extendStutteredPageUp;
				at: SCI_TAB put: #indent;
				at: SCI_TARGETFROMSELECTION put: #setTargetRangeFromSelection;
				at: SCI_UNDO put: #basicUndo;
				at: SCI_UPPERCASE put: #convertToUppercase;
				at: SCI_VCHOME put: #moveToVcHome;
				at: SCI_VCHOMEDISPLAY put: #moveToVcStartOfDisplayLine;
				at: SCI_VCHOMEDISPLAYEXTEND put: #extendToStartOfVcDisplayLine;
				at: SCI_VCHOMEEXTEND put: #extendToVcHome;
				at: SCI_VCHOMERECTEXTEND put: #extendRectangleToVcHome;
				at: SCI_VCHOMEWRAP put: #moveToWrappedVcHome;
				at: SCI_VCHOMEWRAPEXTEND put: #extendToWrappedVcHome;
				at: SCI_VERTICALCENTRECARET put: #centerCurrentLine;
				at: SCI_WORDLEFT put: #moveToStartOfWord;
				at: SCI_WORDLEFTEND put: #moveToEndOfPreviousWord;
				at: SCI_WORDLEFTENDEXTEND put: #extendToEndOfPreviousWord;
				at: SCI_WORDLEFTEXTEND put: #extendToStartOfWord;
				at: SCI_WORDPARTLEFT put: #moveToStartOfWordPart;
				at: SCI_WORDPARTLEFTEXTEND put: #extendToStartOfWordPart;
				at: SCI_WORDPARTRIGHT put: #moveToEndOfWordPart;
				at: SCI_WORDPARTRIGHTEXTEND put: #extendToEndOfWordPart;
				at: SCI_WORDRIGHT put: #moveToEndOfWord;
				at: SCI_WORDRIGHTEND put: #moveToEndOfNextWord;
				at: SCI_WORDRIGHTENDEXTEND put: #extendToEndOfNextWord;
				at: SCI_WORDRIGHTEXTEND put: #extendToEndOfWord;
				at: SCI_ZOOMIN put: #zoomIn;
				at: SCI_ZOOMOUT put: #zoomOut;
				at: SCI_NULL put: #yourself;
				shrink;
				isImmutable: true;
				yourself!

initializeVirtualKeyMap
	VirtualKeyMap := (0 to: 255) collect: [:each | each].
	VirtualKeyMap
		at: VK_DOWN + 1 put: SCK_DOWN;
		at: VK_UP + 1 put: SCK_UP;
		at: VK_LEFT + 1 put: SCK_LEFT;
		at: VK_RIGHT + 1 put: SCK_RIGHT;
		at: VK_HOME + 1 put: SCK_HOME;
		at: VK_END + 1 put: SCK_END;
		at: VK_PRIOR + 1 put: SCK_PRIOR;
		at: VK_NEXT + 1 put: SCK_NEXT;
		at: VK_DELETE + 1 put: SCK_DELETE;
		at: VK_INSERT + 1 put: SCK_INSERT;
		at: VK_ESCAPE + 1 put: SCK_ESCAPE;
		at: VK_BACK + 1 put: SCK_BACK;
		at: VK_TAB + 1 put: SCK_TAB;
		at: VK_RETURN + 1 put: SCK_RETURN;
		at: VK_ADD + 1 put: SCK_ADD;
		at: VK_SUBTRACT + 1 put: SCK_SUBTRACT;
		at: VK_DIVIDE + 1 put: SCK_DIVIDE;
		at: VK_MENU + 1 put: SCK_MENU;
		at: VK_LWIN + 1 put: SCK_WIN;
		at: VK_RWIN + 1 put: SCK_RWIN;
		at: VK_OEM_2 + 1 put: $/ codePoint;
		at: VK_OEM_3 + 1 put: $` codePoint;
		at: VK_OEM_4 + 1 put: $[ codePoint;
		at: VK_OEM_5 + 1 put: $\ codePoint;
		at: VK_OEM_6 + 1 put: $] codePoint;
		isImmutable: true!

new
	^self newAcceleratorKey: 0 message: SCI_NULL!

newAcceleratorKey: keyInteger message: sciInteger
	^self basicNew
		acceleratorKey: keyInteger;
		message: sciInteger;
		yourself!

newChord: aString message: sciInteger
	^self newAcceleratorKey: (AcceleratorTable keyCodeFromInvariantString: aString) message: sciInteger! !
!UI.Scintilla.KeyBinding class categoriesFor: #icon!constants!development!public! !
!UI.Scintilla.KeyBinding class categoriesFor: #initialize!development!initializing!private! !
!UI.Scintilla.KeyBinding class categoriesFor: #initializeCommands!**auto generated**!development!private!scintilla interface! !
!UI.Scintilla.KeyBinding class categoriesFor: #initializeVirtualKeyMap!development!initializing!private! !
!UI.Scintilla.KeyBinding class categoriesFor: #new!instance creation!public! !
!UI.Scintilla.KeyBinding class categoriesFor: #newAcceleratorKey:message:!instance creation!public! !
!UI.Scintilla.KeyBinding class categoriesFor: #newChord:message:!instance creation!public! !

