"Filed out from Dolphin Smalltalk 7"!

IdbShell subclass: #SerialChat
	instanceVariableNames: 'serialIO process comPort entry display status'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SerialChat guid: (GUID fromString: '{aa8260ab-20c3-4640-bd1e-7a8453a6d5a2}')!
SerialChat comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!SerialChat categoriesForClass!IDB Goodies! !
!SerialChat methodsFor!

about
	"Display the about view"

	self 
		idbAbout: '
Serial Chat
for
Dolphin Smalltalk 6.x

Version 6a
© 2005 Ian Bartholomew
http://www.idb.me.uk'!

appendText: aString 
	display value: ((String writeStream)
				nextPutAll: display value;
				cr;
				nextPutAll: '--\/--';
				cr;
				nextPutAll: aString;
				cr;
				nextPutAll: '--/\--';
				cr;
				contents).
	entry value: String new.
	display view scrollToEnd.
	entry view setFocus!

comPorts
	^#('COM1' 'COM2' 'COM3' 'COM4')!

connect
	serialIO := SerialIO connectTo: comPort selection.
	status value: ((String writeStream)
				nextPutAll: '  Connected to ';
				nextPutAll: comPort selection;
				nextPutAll: ' at ';
				print: Time now;
				nextPutAll: '  (';
				nextPutAll: serialIO connectionParameters;
				nextPut: $);
				contents).
	process := 
			[
			[| text |
			Processor sleep: 250.
			(text := serialIO read: 50) notEmpty 
				ifTrue: 
					[display value: display value , text asString.
					display view scrollToEnd]] 
					repeat] 
					fork!

createComponents
	super createComponents.
	comPort := self add: ListPresenter new name: 'comPort'.
	entry := self add: TextPresenter new name: 'entry'.
	display := self add: TextPresenter new name: 'display'!

disconnect
	process notNil 
		ifTrue: 
			[process terminate.
			process := nil].
	serialIO notNil 
		ifTrue: 
			[serialIO disconnect.
			serialIO := nil].
	status value: '  Not connected'!

finalize
	self disconnect!

isConnected
	^serialIO notNil!

onViewClosed
	super onViewClosed.
	self disconnect!

onViewOpened
	super onViewOpened.
	self beFinalizable.
	(self view viewNamed: 'status') model: (status := '  Not connected' asValue).
	comPort
		list: self comPorts;
		selection: self comPorts first!

queryCommand: aCommandQuery 
	aCommandQuery command == #connect 
		ifTrue: 
			[aCommandQuery isEnabled: self isConnected not.
			^true].
	(#(#disconnect #send #sendWithCr) identityIncludes: aCommandQuery command) 
		ifTrue: 
			[aCommandQuery isEnabled: self isConnected.
			^true].
	^super queryCommand: aCommandQuery!

send
	serialIO write: entry value.
	self appendText: entry value!

sendWithCr
	serialIO write: entry value , String lineDelimiter.
	self appendText: entry value! !
!SerialChat categoriesFor: #about!commands!public! !
!SerialChat categoriesFor: #appendText:!helpers!operations!public! !
!SerialChat categoriesFor: #comPorts!constants!public! !
!SerialChat categoriesFor: #connect!commands!public! !
!SerialChat categoriesFor: #createComponents!initializing!public! !
!SerialChat categoriesFor: #disconnect!commands!public! !
!SerialChat categoriesFor: #finalize!finalizing!public! !
!SerialChat categoriesFor: #isConnected!public!testing! !
!SerialChat categoriesFor: #onViewClosed!event handling!public! !
!SerialChat categoriesFor: #onViewOpened!event handling!public! !
!SerialChat categoriesFor: #queryCommand:!commands!public! !
!SerialChat categoriesFor: #send!commands!public! !
!SerialChat categoriesFor: #sendWithCr!commands!public! !

!SerialChat class methodsFor!

icon
	^##(TextTileIcon text:  $\x1F38C fontName: 'Segoe UI Emoji' color: (ARGB named: #mediumBlue))!

initialize
	Smalltalk developmentSystem addSamplesFolderIconFor: self description: self sampleDescription!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 519 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.StatusBar)  98 18 0 416 98 2 8 1140853004 1 560 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point)  193 193 0 560 0 8 4294904209 234 256 98 2 853766 ##(Smalltalk.StatusBarItem)  1 -1 560 0 8 ##(Smalltalk.BasicListAbstract)  787814 3 ##(Smalltalk.BlockClosure)  0 459302 ##(Smalltalk.Context)  1 1 0 0 1180966 ##(Smalltalk.CompiledExpression)  0 9 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 98 2 8 '[:o | ]' 98 1 202 8 ##(Smalltalk.PoolDictionary)  98 0 8 #[252 1 0 1 1 5 0 17 230 32 60 106 100 105] 17 257 0 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.IconImageManager)  8 #current 8 'status' 98 1 848 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 560 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 754 1 921 754 1521 45 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 204 1 0 0 248 2 0 0 226 1 0 0] 98 0 754 193 193 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 1488 0 482 512 0 7 0 0 0 1488 852230 ##(Smalltalk.FramingLayout)  234 240 98 4 410 1504 98 15 0 1488 98 2 8 1149239296 131073 1648 0 196934 1 ##(Smalltalk.RGB)  25264513 0 7 0 0 0 1648 1586 234 240 98 12 410 8 ##(Smalltalk.PushButton)  98 17 0 1648 98 2 8 1140924416 1 1792 0 0 0 7 0 0 0 1792 0 8 4294904477 1180998 4 ##(Smalltalk.CommandDescription)  8 #send 8 'Send' 1 1 0 0 32 1250 202 208 98 3 1314 1344 98 2 754 1333 75 754 169 51 1792 1314 8 #isEnabled: 98 1 32 1792 1314 8 #text: 98 1 8 'Send' 1792 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 154 2 0 0 37 0 0 0 238 2 0 0 62 0 0 0] 98 0 1472 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1130 8 ##(Smalltalk.FramingCalculation)  8 #fixedPreviousRight 17 1130 2272 8 #fixedParentRight -15 1130 2272 8 #fixedPreviousTop 1 1130 2272 8 #fixedViewTop 51 410 1808 98 17 0 1648 98 2 8 1140924416 1 2400 0 0 0 7 0 0 0 2400 0 8 4294904477 1890 8 #disconnect 8 'Disconnect' 1 1 0 0 32 1250 202 208 98 3 1314 1344 98 2 754 409 17 754 141 51 2400 1314 2080 98 1 32 2400 1314 2128 98 1 8 'Disconnect' 2400 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 204 0 0 0 8 0 0 0 18 1 0 0 33 0 0 0] 98 0 1472 0 27 2226 2256 17 1130 2272 8 #fixedViewLeft 141 2336 1 1130 2272 8 #fixedPreviousBottom 1 410 1808 98 17 0 1648 98 2 8 1140924416 1 2848 0 0 0 7 0 0 0 2848 0 8 4294904477 1890 8 #sendWithCr 8 'Send with CR' 1 1 0 0 32 1250 202 208 98 3 1314 1344 98 2 754 1333 141 754 169 51 2848 1314 2080 98 1 32 2848 1314 2128 98 1 8 'Send with CR' 2848 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 154 2 0 0 70 0 0 0 238 2 0 0 95 0 0 0] 98 0 1472 0 27 2226 1130 2272 8 #fixedPreviousLeft 1 2256 1 2816 17 2368 51 410 8 ##(Smalltalk.MultilineTextEdit)  98 16 0 1648 98 2 8 1143017796 1025 3264 0 482 8 4278190080 0 7 0 0 0 3264 0 8 4294904485 852486 ##(Smalltalk.NullConverter)  0 0 9 1250 202 208 98 3 1314 1344 98 2 754 17 75 754 1301 147 3264 1314 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 3264 1314 8 #isTextModified: 98 1 32 3264 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 37 0 0 0 146 2 0 0 110 0 0 0] 98 0 1472 0 27 2226 1130 2272 8 #fixedParentLeft 17 2304 -199 2816 9 1130 2272 8 #fixedParentBottom -15 410 8 ##(Smalltalk.ComboBox)  98 17 0 1648 98 2 8 1144063491 1025 3792 590662 2 ##(Smalltalk.ListModel)  202 208 1088 0 1130 8 ##(Smalltalk.SearchPolicy)  8 #identity 482 512 0 7 0 0 0 3792 0 8 4294904451 864 1088 401 1250 202 208 98 1 1314 1344 98 2 754 21 17 754 201 43 3792 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 110 0 0 0 29 0 0 0] 98 0 1472 0 27 2226 3728 21 2784 201 1130 2272 8 #fixedParentTop 17 2368 17 410 1808 98 17 0 1648 98 2 8 1140924416 1 4208 0 0 0 7 0 0 0 4208 0 8 4294904477 1890 8 #connect 8 'Connect' 1 1 0 0 32 1250 202 208 98 3 1314 1344 98 2 754 253 17 754 141 51 4208 1314 2080 98 1 32 4208 1314 2128 98 1 8 'Connect' 4208 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 126 0 0 0 8 0 0 0 196 0 0 0 33 0 0 0] 98 0 1472 0 27 2226 2256 33 2784 141 2336 1 2368 51 234 256 98 4 3792 8 'comPort' 3264 8 'entry' 0 1250 202 208 98 1 1314 1344 98 2 754 1 1 754 1521 241 1648 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 248 2 0 0 120 0 0 0] 98 6 3792 4208 2400 3264 1792 2848 1472 0 27 2226 3728 1 2304 1 4176 1 2368 241 410 3280 98 16 0 1488 98 2 8 1143017796 1025 4832 0 1714 28049407 0 7 0 0 0 4832 0 8 4294904485 3394 0 0 11 1250 202 208 98 3 1314 1344 98 2 754 1 241 754 1521 681 4832 1314 3552 98 1 3586 3 1 3 4832 1314 3632 98 1 32 4832 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 248 2 0 0 204 1 0 0] 98 0 1472 0 27 2226 3728 1 2304 1 2816 1 3760 1 234 256 98 2 4832 8 'display' 0 1250 202 208 98 1 1314 1344 98 2 754 1 1 754 1521 921 1488 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 248 2 0 0 204 1 0 0] 98 2 1648 4832 1472 0 27 234 256 1088 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 3 265030 4 ##(Smalltalk.Menu)  0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem)  1 1890 4304 8 'Connect' 1 1 0 0 0 5522 1 1890 2496 8 'Disconnect' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 5522 1 1890 8 #exit 8 'Exit' 1 1 0 0 0 8 'File' 0 1 0 0 22407 0 0 5474 0 16 98 2 5522 1 1890 1920 8 'Send' 1 1 0 0 0 5522 1 1890 2944 8 'Send+ (with CR)' 1 1 0 0 0 8 'Send' 0 1 0 0 22413 0 0 5474 0 16 98 19 5522 1 1890 8 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon)  0 16 1130 8 ##(Smalltalk.ImageRelativeFileLocator)  1168 49 1130 8 ##(Smalltalk.ShellLibrary)  8 #default 0 0 5522 1 1890 8 #help 8 'On this &Tool' 1249 1 0 0 0 5522 1 1890 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 5634 4097 5522 1 1890 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 5634 4097 5522 1 1890 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 5522 1 1890 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 5522 1 1890 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 5474 0 16 98 4 5522 2097153 1890 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 5986 0 16 6016 8 'TipOfTheDay.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 5522 1 1890 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 5986 0 16 6016 8 'TipOfTheDay.ico' 6656 0 0 5634 4097 5522 1 1890 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 0 0 0 5634 4097 5522 1 1890 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 5522 1 1890 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 5522 1 1890 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 5522 1 1890 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 5634 4097 5522 1 1890 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 5986 0 16 6016 8 'LiveUpdate.ico' 6656 0 0 5634 4097 5522 1 1890 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5986 0 16 6016 8 '!!APPLICATION' 6656 0 0 8 '&Help' 0 134217729 0 0 0 0 0 8 '' 0 1 0 0 0 0 0 0 1049350 ##(Smalltalk.AcceleratorTable)  0 16 98 5 721414 ##(Smalltalk.Association)  1025 1890 5952 8 '&Contents' 1025 1 5986 0 16 6016 49 6048 7458 1249 1890 6128 8 'On this &Tool' 1249 1 0 7458 5345 1890 6192 8 'What''s This?' 5345 1 0 7458 9441 1890 6576 8 '&Next Tip of the Day' 9441 1 5986 0 16 6016 8 'TipOfTheDay.ico' 6656 7458 13537 1890 6720 8 '&Previous Tip of the Day' 13537 1 5986 0 16 6016 8 'TipOfTheDay.ico' 6656 0 1 0 0 0 0 1 0 0 1250 202 208 98 3 1314 1344 98 2 754 6399 21 754 1537 1073 416 1314 2128 98 1 8 'Serial Chat' 416 1314 8 #menuBar: 98 1 5440 416 1410 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 12 0 0 10 0 0 0 127 15 0 0 34 2 0 0] 98 2 1488 560 1472 0 27 )!

sampleDescription
	^'Serial Chat'!

uninitialize
	Smalltalk developmentSystem removeSystemFolderIconNamed: self sampleDescription! !
!SerialChat class categoriesFor: #icon!constants!public! !
!SerialChat class categoriesFor: #initialize!initializing!public! !
!SerialChat class categoriesFor: #resource_Default_view!public!resources-views! !
!SerialChat class categoriesFor: #sampleDescription!constants!development!public! !
!SerialChat class categoriesFor: #uninitialize!initializing!public! !

