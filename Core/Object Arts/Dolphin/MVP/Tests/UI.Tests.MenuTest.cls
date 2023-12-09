"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.MenuTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.MenuTest guid: (Core.GUID fromString: '{7e39f8d9-1ee0-471d-8e3f-76c307707b10}')!
UI.Tests.MenuTest comment: ''!
!UI.Tests.MenuTest methodsFor!

assertEqualToExampleMenu: menu
	self assert: menu toStrings printString caseFolded
		equals: self exampleStrings printString caseFolded!

exampleMenu
	^MenuBar fromStrings: self exampleStrings!

exampleStrings
	^#(#('&File' '&New/CTRL+N/fileNew' '|' '&Open.../CTRL+O/fileOpen' '-' 'E&xit//fileExit') '||' 'F&ire!!//fire' '|' #('&Tools' '&Workspace.../CTRL+N/fileNew' '-' #('&Options' 'Default Font...//chooseDefaultFont' #('&Theme' '&Dark//darkTheme' '&Light//lightTheme'))))!

testAllItems
	self assert: (self exampleMenu allItems collect: [:each | each printString])
		equals: #('a MenuBar' 'a Menu(&File)' 'a CommandMenuItem(&New)' 'DividerMenuItem break' 'a CommandMenuItem(&Open...)' 'DividerMenuItem separator' 'a CommandMenuItem(E&xit)' 'DividerMenuItem barBreak' 'a CommandMenuItem(F&ire!!)' 'DividerMenuItem break' 'a Menu(&Tools)' 'a CommandMenuItem(&Workspace...)' 'DividerMenuItem separator' 'a Menu(&Options)' 'a CommandMenuItem(Default Font...)' 'a Menu(&Theme)' 'a CommandMenuItem(&Dark)' 'a CommandMenuItem(&Light)')!

testAllMenus
	self assert: (self exampleMenu allMenus collect: [:each | each text])
		equals: #('' '&File' '&Tools' '&Options' '&Theme')!

testFindCommand
	| subject item |
	subject := Menu fromStrings: #('&File' 'Open//fileOpen' '-' '&Save/Ctrl+S/fileSave').
	item := subject findCommand: #fileOpen.
	self assertNotNil: item.
	self assert: item command identicalTo: #fileOpen.
	item := subject findCommand: #fileExit.
	self assertIsNil: item.
	subject addCommand: (Message selector: #quit argument: SessionManager current) description: '&Exit'.
	item := subject findCommand: (Message selector: #quit argument: SessionManager current).
	self assertNotNil: item.
	self assert: item command isKindOf: Message.
	self assert: item command selector equals: #quit!

testFromStrings
	self assertEqualToExampleMenu: self exampleMenu!

testStbConvertFromVersion0
	| bytes menu |
	bytes := #[33 83 84 66 32 48 32 6 4 7 0 77 101 110 117 66 97 114 0 0 0 0 0 0 0 0 16 0 0 0 14 2 18 0 83 84 66 67 111 108 108 101 99 116 105 111 110 80 114 111 120 121 0 0 0 0 14 1 13 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 17 0 0 0 79 114 100 101 114 101 100 67 111 108 108 101 99 116 105 111 110 38 0 5 0 65 114 114 97 121 5 0 0 0 6 4 4 0 77 101 110 117 0 0 0 0 0 0 0 0 16 0 0 0 122 0 0 0 0 0 0 0 160 0 0 0 210 0 0 0 5 0 0 0 6 1 15 0 67 111 109 109 97 110 100 77 101 110 117 73 116 101 109 0 0 0 0 70 4 18 0 2 0 0 0 67 111 109 109 97 110 100 68 101 115 99 114 105 112 116 105 111 110 0 0 0 0 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 178 0 0 0 7 0 0 0 102 105 108 101 78 101 119 178 0 0 0 4 0 0 0 38 78 101 119 157 36 0 0 0 0 0 0 6 1 15 0 68 105 118 105 100 101 114 77 101 110 117 73 116 101 109 0 0 0 0 129 0 0 0 50 1 0 0 0 0 0 0 82 1 0 0 0 0 0 0 122 1 0 0 0 0 0 0 178 0 0 0 8 0 0 0 102 105 108 101 79 112 101 110 178 0 0 0 8 0 0 0 38 79 112 101 110 46 46 46 159 36 0 0 0 0 0 0 178 1 0 0 0 0 0 0 1 16 0 0 50 1 0 0 0 0 0 0 82 1 0 0 0 0 0 0 122 1 0 0 0 0 0 0 178 0 0 0 8 0 0 0 102 105 108 101 69 120 105 116 178 0 0 0 5 0 0 0 69 38 120 105 116 1 0 0 0 0 0 0 0 178 0 0 0 5 0 0 0 38 70 105 108 101 178 1 0 0 0 0 0 0 65 0 0 0 50 1 0 0 0 0 0 0 82 1 0 0 0 0 0 0 122 1 0 0 0 0 0 0 178 0 0 0 4 0 0 0 102 105 114 101 178 0 0 0 6 0 0 0 70 38 105 114 101 33 1 0 0 0 0 0 0 0 192 1 0 0 242 0 0 0 0 0 0 0 0 0 0 0 16 0 0 0 122 0 0 0 0 0 0 0 160 0 0 0 210 0 0 0 3 0 0 0 50 1 0 0 0 0 0 0 82 1 0 0 0 0 0 0 128 1 0 0 178 0 0 0 13 0 0 0 38 87 111 114 107 115 112 97 99 101 46 46 46 157 36 0 0 0 0 0 0 32 2 0 0 242 0 0 0 0 0 0 0 0 0 0 0 16 0 0 0 122 0 0 0 0 0 0 0 160 0 0 0 210 0 0 0 1 0 0 0 50 1 0 0 0 0 0 0 82 1 0 0 0 0 0 0 122 1 0 0 0 0 0 0 178 0 0 0 17 0 0 0 99 104 111 111 115 101 68 101 102 97 117 108 116 70 111 110 116 178 0 0 0 15 0 0 0 68 101 102 97 117 108 116 32 70 111 110 116 46 46 46 1 0 0 0 0 0 0 0 178 0 0 0 8 0 0 0 38 79 112 116 105 111 110 115 178 0 0 0 6 0 0 0 38 84 111 111 108 115 178 0 0 0 0 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	menu := Object fromBinaryStoreBytes: bytes.
	self assert: menu isKindOf: MenuBar.
	self assert: menu toStrings printString caseFolded
		equals: '#(#(''&file'' ''&new/ctrl+n/filenew'' ''|'' ''&open.../ctrl+o/fileopen'' ''-'' ''e&xit//fileexit'') ''||'' ''f&ire!!//fire'' ''|'' #(''&tools'' ''&workspace.../ctrl+n/filenew'' ''-'' #(''&options'' ''default font...//choosedefaultfont'')))'! !
!UI.Tests.MenuTest categoriesForMethods!
assertEqualToExampleMenu:!helpers!private! !
exampleMenu!helpers!private! !
exampleStrings!constants!private! !
testAllItems!constants!private! !
testAllMenus!constants!private! !
testFindCommand!public!unit tests! !
testFromStrings!public!unit tests! !
testStbConvertFromVersion0!public!unit tests! !
!

