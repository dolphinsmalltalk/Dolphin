"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Scintilla.KeyBinding'
	instanceVariableNames: 'acceleratorKey message'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {
			'Commands'
				-> (IdentityDictionary withAll: {
								16r7D4 -> #basicClearAll.
								16r7DB -> #redo.
								16r7DD -> #basicSelectAll.
								16r87C -> #yourself.
								16r880 -> #basicUndo.
								16r881 -> #cutSelection.
								16r882 -> #copySelection.
								16r883 -> #pasteClipboard.
								16r884 -> #basicClearSelection.
								16r8EF -> #setTargetRangeFromSelection.
								16r8F0 -> #joinTarget.
								16r8FC -> #moveDown.
								16r8FD -> #extendDown.
								16r8FE -> #moveUp.
								16r8FF -> #extendUp.
								16r900 -> #moveLeft.
								16r901 -> #extendLeft.
								16r902 -> #moveRight.
								16r903 -> #extendRight.
								16r904 -> #moveToStartOfWord.
								16r905 -> #extendToStartOfWord.
								16r906 -> #moveToEndOfWord.
								16r907 -> #extendToEndOfWord.
								16r908 -> #moveToStartOfLine.
								16r909 -> #extendToStartOfLine.
								16r90A -> #moveToEndOfLine.
								16r90B -> #extendToEndOfLine.
								16r90C -> #moveToStartOfDocument.
								16r90D -> #extendToStartOfDocument.
								16r90E -> #moveToEndOfDocument.
								16r90F -> #extendToEndOfDocument.
								16r910 -> #movePageUp.
								16r911 -> #extendPageUp.
								16r912 -> #movePageDown.
								16r913 -> #extendPageDown.
								16r914 -> #toggleOvertype.
								16r915 -> #cancelModes.
								16r916 -> #backspace.
								16r917 -> #indent.
								16r918 -> #unindent.
								16r919 -> #newLine.
								16r91A -> #formFeed.
								16r91B -> #moveToVcHome.
								16r91C -> #extendToVcHome.
								16r91D -> #zoomIn.
								16r91E -> #zoomOut.
								16r91F -> #deleteToStartOfWord.
								16r920 -> #deleteToNextWord.
								16r921 -> #cutLine.
								16r922 -> #deleteLine.
								16r923 -> #twiddleLines.
								16r924 -> #convertToLowercase.
								16r925 -> #convertToUppercase.
								16r926 -> #scrollDown.
								16r927 -> #scrollUp.
								16r928 -> #backspaceNoLine.
								16r929 -> #moveToStartOfDisplayLine.
								16r92A -> #extendToStartOfDisplayLine.
								16r92B -> #moveToEndOfDisplayLine.
								16r92C -> #extendToEndOfDisplayLine.
								16r92D -> #moveToStartOfWrappedLine.
								16r932 -> #reverseSelectedLines.
								16r945 -> #resetZoom.
								16r956 -> #moveToStartOfWordPart.
								16r957 -> #extendToStartOfWordPart.
								16r958 -> #moveToEndOfWordPart.
								16r959 -> #extendToEndOfWordPart.
								16r95B -> #deleteToStartOfLine.
								16r95C -> #deleteToEndOfLine.
								16r961 -> #moveCaretInsideView.
								16r964 -> #duplicateLine.
								16r96D -> #moveParaDown.
								16r96E -> #extendParaDown.
								16r96F -> #moveParaUp.
								16r970 -> #extendParaUp.
								16r97A -> #extendRectangleDown.
								16r97B -> #extendRectangleUp.
								16r97C -> #extendRectangleLeft.
								16r97D -> #extendRectangleRight.
								16r97E -> #extendRectangleToStartOfLine.
								16r97F -> #extendRectangleToVcHome.
								16r980 -> #extendRectangleToEndOfLine.
								16r981 -> #extendRectanglePageUp.
								16r982 -> #extendRectanglePageDown.
								16r983 -> #moveStutteredPageUp.
								16r984 -> #extendStutteredPageUp.
								16r985 -> #moveStutteredPageDown.
								16r986 -> #extendStutteredPageDown.
								16r987 -> #moveToEndOfPreviousWord.
								16r988 -> #extendToEndOfPreviousWord.
								16r989 -> #moveToEndOfNextWord.
								16r98A -> #extendToEndOfNextWord.
								16r992 -> #extendToStartOfWrappedLine.
								16r993 -> #moveToEndOfWrappedLine.
								16r994 -> #extendToEndOfWrappedLine.
								16r995 -> #moveToWrappedVcHome.
								16r996 -> #extendToWrappedVcHome.
								16r997 -> #copyLine.
								16r9A5 -> #duplicateSelection.
								16r9D6 -> #deleteToEndOfWord.
								16rA3B -> #centerCurrentLine.
								16rA3C -> #moveSelectedLinesUp.
								16rA3D -> #moveSelectedLinesDown.
								16rA44 -> #scrollToStart.
								16rA45 -> #scrollToEnd.
								16rA5C -> #moveToVcStartOfDisplayLine.
								16rA5D -> #extendToStartOfVcDisplayLine.
								16rBB9 -> #startRecording.
								16rBBA -> #stopRecording
							}).
			'VirtualKeyMap'
				-> #(16r0 16r1 16r2 16r3 16r4 16r5 16r6 16r7 16r8 16r9 16rA 16rB 16rC 16rD 16rE 16rF 16r10 16r11 16r13B 16r13 16r14 16r15 16r16 16r17 16r18 16r19 16r1A 16r7 16r1C 16r1D 16r1E 16r1F 16r20 16r132 16r133 16r131 16r130 16r12E 16r12D 16r12F 16r12C 16r29 16r2A 16r2B 16r2C 16r135 16r134 16r2F 16r30 16r31 16r32 16r33 16r34 16r35 16r36 16r37 16r38 16r39 16r3A 16r3B 16r3C 16r3D 16r3E 16r3F 16r40 16r41 16r42 16r43 16r44 16r45 16r46 16r47 16r48 16r49 16r4A 16r4B 16r4C 16r4D 16r4E 16r4F 16r50 16r51 16r52 16r53 16r54 16r55 16r56 16r57 16r58 16r59 16r5A 16r139 16r13A 16r5D 16r5E 16r5F 16r60 16r61 16r62 16r63 16r64 16r65 16r66 16r67 16r68 16r69 16r6A 16r136 16r6C 16r137 16r6E 16r138 16r70 16r71 16r72 16r73 16r74 16r75 16r76 16r77 16r78 16r79 16r7A 16r7B 16r7C 16r7D 16r7E 16r7F 16r80 16r81 16r82 16r83 16r84 16r85 16r86 16r87 16r88 16r89 16r8A 16r8B 16r8C 16r8D 16r8E 16r8F 16r90 16r91 16r92 16r93 16r94 16r95 16r96 16r97 16r98 16r99 16r9A 16r9B 16r9C 16r9D 16r9E 16r9F 16rA0 16rA1 16rA2 16rA3 16rA4 16rA5 16rA6 16rA7 16rA8 16rA9 16rAA 16rAB 16rAC 16rAD 16rAE 16rAF 16rB0 16rB1 16rB2 16rB3 16rB4 16rB5 16rB6 16rB7 16rB8 16rB9 16rBA 16rBB 16rBC 16rBD 16rBE 16r2F 16r60 16rC1 16rC2 16rC3 16rC4 16rC5 16rC6 16rC7 16rC8 16rC9 16rCA 16rCB 16rCC 16rCD 16rCE 16rCF 16rD0 16rD1 16rD2 16rD3 16rD4 16rD5 16rD6 16rD7 16rD8 16rD9 16rDA 16r5B 16r5C 16r5D 16rDE 16rDF 16rE0 16rE1 16rE2 16rE3 16rE4 16rE5 16rE6 16rE7 16rE8 16rE9 16rEA 16rEB 16rEC 16rED 16rEE 16rEF 16rF0 16rF1 16rF2 16rF3 16rF4 16rF5 16rF6 16rF7 16rF8 16rF9 16rFA 16rFB 16rFC 16rFD 16rFE 16rFF)
		}!
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
	self addClassConstant: 'Commands'
		value: (IdentityDictionary withAll: {
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
					})!

initializeVirtualKeyMap
	| virtualKeyMap |
	virtualKeyMap := (0 to: 255) collect: [:each | each].
	virtualKeyMap
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
		at: VK_OEM_6 + 1 put: $] codePoint.
	self addClassConstant: 'VirtualKeyMap' value: virtualKeyMap!

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

