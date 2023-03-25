"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Scintilla.KeyBinding'
	instanceVariableNames: 'acceleratorKey message'
	classVariableNames: 'Commands VirtualKeyMap'
	imports: #(#{OS.Win32Constants})
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
	"Private - Answer the Scintilla key code (SCK_xxx) that corresponds to the from the Windows Virtual Key code of the receiver."

	^(VirtualKeyMap at: (acceleratorKey bitAnd: 16rFF) + 1)
		+ ((acceleratorKey bitAnd: 16r3800) bitShift: 5)!

translateVirtualKey: vkInteger 
	"Private - Translate from a Windows Virtual Key code (VK_xxx) to the corresponding Scintilla
	key code (SCK_xxx)"

	^VirtualKeyMap at: (vkInteger bitAnd: 16rFF) + 1! !
!UI.Scintilla.KeyBinding categoriesForMethods!
=!comparing!public! !
acceleratorKey!accessing!public! !
acceleratorKey:!accessing!public! !
acceleratorKeyDisplayString!accessing!public! !
acceleratorKeyString!accessing!public! !
acceleratorKeyString:!accessing!public! !
commandSymbol!accessing!public! !
commandSymbol:!accessing!public! !
displayOn:!printing!public! !
hash!comparing!public! !
message!accessing!private! !
message:!accessing!private! !
printOn:!printing!public! !
scintillaKeyCode!accessing!private! !
translateVirtualKey:!helpers!private! !
!

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
	Commands := (IdentityDictionary withAll: {
						SCI_BACKTAB -> #unindent.
						SCI_CANCEL -> #cancelModes.
						SCI_CHARLEFT -> #moveLeft.
						SCI_CHARLEFTEXTEND -> #extendLeft.
						SCI_CHARLEFTRECTEXTEND -> #extendRectangleLeft.
						SCI_CHARRIGHT -> #moveRight.
						SCI_CHARRIGHTEXTEND -> #extendRight.
						SCI_CHARRIGHTRECTEXTEND -> #extendRectangleRight.
						SCI_CLEAR -> #basicClearSelection.
						SCI_CLEARALL -> #basicClearAll.
						SCI_COPY -> #copySelection.
						SCI_CUT -> #cutSelection.
						SCI_DELETEBACK -> #backspace.
						SCI_DELETEBACKNOTLINE -> #backspaceNoLine.
						SCI_DELLINELEFT -> #deleteToStartOfLine.
						SCI_DELLINERIGHT -> #deleteToEndOfLine.
						SCI_DELWORDLEFT -> #deleteToStartOfWord.
						SCI_DELWORDRIGHT -> #deleteToNextWord.
						SCI_DELWORDRIGHTEND -> #deleteToEndOfWord.
						SCI_DOCUMENTEND -> #moveToEndOfDocument.
						SCI_DOCUMENTENDEXTEND -> #extendToEndOfDocument.
						SCI_DOCUMENTSTART -> #moveToStartOfDocument.
						SCI_DOCUMENTSTARTEXTEND -> #extendToStartOfDocument.
						SCI_EDITTOGGLEOVERTYPE -> #toggleOvertype.
						SCI_FORMFEED -> #formFeed.
						SCI_HOME -> #moveToStartOfLine.
						SCI_HOMEDISPLAY -> #moveToStartOfDisplayLine.
						SCI_HOMEDISPLAYEXTEND -> #extendToStartOfDisplayLine.
						SCI_HOMEEXTEND -> #extendToStartOfLine.
						SCI_HOMERECTEXTEND -> #extendRectangleToStartOfLine.
						SCI_HOMEWRAP -> #moveToStartOfWrappedLine.
						SCI_HOMEWRAPEXTEND -> #extendToStartOfWrappedLine.
						SCI_LINECOPY -> #copyLine.
						SCI_LINECUT -> #cutLine.
						SCI_LINEDELETE -> #deleteLine.
						SCI_LINEDOWN -> #moveDown.
						SCI_LINEDOWNEXTEND -> #extendDown.
						SCI_LINEDOWNRECTEXTEND -> #extendRectangleDown.
						SCI_LINEDUPLICATE -> #duplicateLine.
						SCI_LINEEND -> #moveToEndOfLine.
						SCI_LINEENDDISPLAY -> #moveToEndOfDisplayLine.
						SCI_LINEENDDISPLAYEXTEND -> #extendToEndOfDisplayLine.
						SCI_LINEENDEXTEND -> #extendToEndOfLine.
						SCI_LINEENDRECTEXTEND -> #extendRectangleToEndOfLine.
						SCI_LINEENDWRAP -> #moveToEndOfWrappedLine.
						SCI_LINEENDWRAPEXTEND -> #extendToEndOfWrappedLine.
						SCI_LINEREVERSE -> #reverseSelectedLines.
						SCI_LINESCROLLDOWN -> #scrollDown.
						SCI_LINESCROLLUP -> #scrollUp.
						SCI_LINESJOIN -> #joinTarget.
						SCI_LINETRANSPOSE -> #twiddleLines.
						SCI_LINEUP -> #moveUp.
						SCI_LINEUPEXTEND -> #extendUp.
						SCI_LINEUPRECTEXTEND -> #extendRectangleUp.
						SCI_LOWERCASE -> #convertToLowercase.
						SCI_MOVECARETINSIDEVIEW -> #moveCaretInsideView.
						SCI_MOVESELECTEDLINESDOWN -> #moveSelectedLinesDown.
						SCI_MOVESELECTEDLINESUP -> #moveSelectedLinesUp.
						SCI_NEWLINE -> #newLine.
						SCI_PAGEDOWN -> #movePageDown.
						SCI_PAGEDOWNEXTEND -> #extendPageDown.
						SCI_PAGEDOWNRECTEXTEND -> #extendRectanglePageDown.
						SCI_PAGEUP -> #movePageUp.
						SCI_PAGEUPEXTEND -> #extendPageUp.
						SCI_PAGEUPRECTEXTEND -> #extendRectanglePageUp.
						SCI_PARADOWN -> #moveParaDown.
						SCI_PARADOWNEXTEND -> #extendParaDown.
						SCI_PARAUP -> #moveParaUp.
						SCI_PARAUPEXTEND -> #extendParaUp.
						SCI_PASTE -> #pasteClipboard.
						SCI_REDO -> #redo.
						SCI_SCROLLTOEND -> #scrollToEnd.
						SCI_SCROLLTOSTART -> #scrollToStart.
						SCI_SELECTALL -> #basicSelectAll.
						SCI_SELECTIONDUPLICATE -> #duplicateSelection.
						SCI_SETZOOM -> #resetZoom.
						SCI_STARTRECORD -> #startRecording.
						SCI_STOPRECORD -> #stopRecording.
						SCI_STUTTEREDPAGEDOWN -> #moveStutteredPageDown.
						SCI_STUTTEREDPAGEDOWNEXTEND -> #extendStutteredPageDown.
						SCI_STUTTEREDPAGEUP -> #moveStutteredPageUp.
						SCI_STUTTEREDPAGEUPEXTEND -> #extendStutteredPageUp.
						SCI_TAB -> #indent.
						SCI_TARGETFROMSELECTION -> #setTargetRangeFromSelection.
						SCI_UNDO -> #basicUndo.
						SCI_UPPERCASE -> #convertToUppercase.
						SCI_VCHOME -> #moveToVcHome.
						SCI_VCHOMEDISPLAY -> #moveToVcStartOfDisplayLine.
						SCI_VCHOMEDISPLAYEXTEND -> #extendToStartOfVcDisplayLine.
						SCI_VCHOMEEXTEND -> #extendToVcHome.
						SCI_VCHOMERECTEXTEND -> #extendRectangleToVcHome.
						SCI_VCHOMEWRAP -> #moveToWrappedVcHome.
						SCI_VCHOMEWRAPEXTEND -> #extendToWrappedVcHome.
						SCI_VERTICALCENTRECARET -> #centerCurrentLine.
						SCI_WORDLEFT -> #moveToStartOfWord.
						SCI_WORDLEFTEND -> #moveToEndOfPreviousWord.
						SCI_WORDLEFTENDEXTEND -> #extendToEndOfPreviousWord.
						SCI_WORDLEFTEXTEND -> #extendToStartOfWord.
						SCI_WORDPARTLEFT -> #moveToStartOfWordPart.
						SCI_WORDPARTLEFTEXTEND -> #extendToStartOfWordPart.
						SCI_WORDPARTRIGHT -> #moveToEndOfWordPart.
						SCI_WORDPARTRIGHTEXTEND -> #extendToEndOfWordPart.
						SCI_WORDRIGHT -> #moveToEndOfWord.
						SCI_WORDRIGHTEND -> #moveToEndOfNextWord.
						SCI_WORDRIGHTENDEXTEND -> #extendToEndOfNextWord.
						SCI_WORDRIGHTEXTEND -> #extendToEndOfWord.
						SCI_ZOOMIN -> #zoomIn.
						SCI_ZOOMOUT -> #zoomOut.
						SCI_NULL -> #yourself
					})
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
	<primitive: 157>
	^self basicNew
		acceleratorKey: keyInteger;
		message: sciInteger;
		yourself!

newChord: aString message: sciInteger
	^self newAcceleratorKey: (AcceleratorTable keyCodeFromInvariantString: aString) message: sciInteger! !
!UI.Scintilla.KeyBinding class categoriesForMethods!
icon!constants!development!public! !
initialize!development!initializing!private! !
initializeCommands!**auto generated**!development!private!scintilla interface! !
initializeVirtualKeyMap!development!initializing!private! !
new!instance creation!public! !
newAcceleratorKey:message:!instance creation!public! !
newChord:message:!instance creation!public! !
!

