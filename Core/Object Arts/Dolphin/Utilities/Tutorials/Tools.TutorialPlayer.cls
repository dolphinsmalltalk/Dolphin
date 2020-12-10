"Filed out from Dolphin Smalltalk 7"!

UI.Shell subclass: #'Tools.TutorialPlayer'
	instanceVariableNames: 'tutorialPosition tutorial title workspace'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.TutorialPlayer guid: (Core.GUID fromString: '{0ba31b85-7347-43e6-87d6-5f582babde3d}')!
Tools.TutorialPlayer comment: 'I can navigate through an AbstractTutorial subclass. With #next and #previous you can go forward and backward through the tutorial.'!
!Tools.TutorialPlayer categoriesForClass!Unclassified! !
!Tools.TutorialPlayer methodsFor!

createComponents
	super createComponents.
	title := self add: TextPresenter new name: 'title'.
	workspace := self add: Tools.SmalltalkWorkspace new name: 'workspace'!

currentLesson
	^ self tutorial lessonAt: self tutorialPosition.
!

displayIt
	workspace
		setFocus;
		displayIt!

evaluateIt
	workspace
		setFocus;
		evaluateIt!

first
	self rewind.
	^self updateLesson
!

inspectIt
	workspace
		setFocus;
		inspectIt!

last
	tutorialPosition := self size.
	^ self updateLesson
!

model: aTutorial
	super model: aTutorial.
	self updateLesson
!

next
	self tutorialPosition < self size
		ifTrue: [tutorialPosition := tutorialPosition + 1].
	
	^ self updateLesson
!

onViewOpened
	super onViewOpened.

	"Workspaces font is set by system options, Override this here."
	workspace view font: self view font.

	self updateLesson
!

previous
	tutorialPosition >  1 ifTrue: [tutorialPosition := tutorialPosition  - 1].
	^ self updateLesson
!

printIt
	workspace
		setFocus;
		printIt!

reload
	^self updateLesson!

rewind
	tutorialPosition := 1.
	^self updateLesson
!

size
	^ self tutorial size
!

tutorial
	^self model
!

tutorial: aTutorial
	self model: aTutorial.
	self updateLesson
!

tutorialPosition 
	^ tutorialPosition  ifNil: [
		self rewind.
		tutorialPosition.
	].
!

tutorialPosition: aTutorialPosition 
	tutorialPosition := aTutorialPosition
!

updateLesson
	| lesson |
	lesson := self currentLesson.
	title value: lesson title.
	workspace text: lesson contents.
	self caption: ('<1d> - Lesson <2d>/<3d>' 
				expandMacrosWith: self tutorial name
				with: self tutorialPosition
				with: self tutorial tableOfContents size).
	^lesson! !
!Tools.TutorialPlayer categoriesFor: #createComponents!accessing!private! !
!Tools.TutorialPlayer categoriesFor: #currentLesson!accessing!public! !
!Tools.TutorialPlayer categoriesFor: #displayIt!commands!public! !
!Tools.TutorialPlayer categoriesFor: #evaluateIt!commands!public! !
!Tools.TutorialPlayer categoriesFor: #first!navigation!public! !
!Tools.TutorialPlayer categoriesFor: #inspectIt!commands!public! !
!Tools.TutorialPlayer categoriesFor: #last!navigation!public! !
!Tools.TutorialPlayer categoriesFor: #model:!accessing!private! !
!Tools.TutorialPlayer categoriesFor: #next!navigation!public! !
!Tools.TutorialPlayer categoriesFor: #onViewOpened!accessing!private! !
!Tools.TutorialPlayer categoriesFor: #previous!navigation!public! !
!Tools.TutorialPlayer categoriesFor: #printIt!commands!public! !
!Tools.TutorialPlayer categoriesFor: #reload!navigation!public! !
!Tools.TutorialPlayer categoriesFor: #rewind!navigation!public! !
!Tools.TutorialPlayer categoriesFor: #size!accessing!public! !
!Tools.TutorialPlayer categoriesFor: #tutorial!accessing!public! !
!Tools.TutorialPlayer categoriesFor: #tutorial:!accessing!public! !
!Tools.TutorialPlayer categoriesFor: #tutorialPosition!accessing!public! !
!Tools.TutorialPlayer categoriesFor: #tutorialPosition:!accessing!public! !
!Tools.TutorialPlayer categoriesFor: #updateLesson!accessing!private! !

!Tools.TutorialPlayer class methodsFor!

defaultModel
	^Tools.AbstractTutorial new!

icon
	^Tools.AbstractTutorial icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 ##(Graphics.Color) #default 918022 ##(Graphics.Point) 1321 1321 549 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 84 114 101 98 117 99 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 656 nil 466 #orchid nil 7 nil nil nil 656 1048838 ##(UI.FramingLayout) 170 176 34 4 410 ##(Graphics.Gdiplus.ImageView) 34 28 nil 656 34 2 8 1140850944 1 800 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) 1378630 1 ##(Graphics.TextTileIcon) $\x1F393 nil 720 466 #white nil nil 1 nil nil nil nil 7 nil nil nil 800 nil 8 4294902331 1049094 ##(UI.NullConverter) nil nil nil 944 #scaleToFit 1 1180166 ##(Graphics.Rectangle) 498 1 1 498 1 1 nil nil #none nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 498 1101 7 498 129 129 800 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 38 2 0 0 3 0 0 0 102 2 0 0 67 0 0 0] 8 #() 498 193 193 nil 29 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentRight -147 1346 #fixedViewLeft 129 1346 #fixedParentTop -37 1346 #fixedViewTop 129 410 ##(UI.StaticText) 34 16 nil 656 34 2 8 1140850944 1 1424 nil nil nil 7 nil 530 nil true 562 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 84 114 101 98 117 99 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 1424 960 8 1801195232 994 nil nil nil 1090 138 144 34 2 1154 #createAt:extent: 34 2 498 21 45 498 1061 97 1424 1154 #text: 34 1 8 'Title' 1424 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 22 0 0 0 28 2 0 0 70 0 0 0] 8 #() 1296 nil 27 1314 1346 #fixedParentLeft 1 1360 -167 1392 1 1408 97 170 192 34 4 800 8 'badge' 1424 8 'title' 1026 498 21 45 498 1 1 1090 138 144 34 1 1154 #createAt:extent: 34 2 498 21 21 498 1249 141 656 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 122 2 0 0 80 0 0 0] 34 2 1424 800 1296 nil 27 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2096 nil 720 nil 7 nil 530 nil true 562 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 2096 738 170 176 34 12 410 ##(UI.LinkButton) 34 15 nil 2096 34 2 8 1140850688 65 2272 nil nil nil 519 nil nil nil 2272 480 8 1801822672 1377606 4 ##(UI.CommandDescription) #previous 8 'Previous' 1 1 nil 1090 138 144 34 3 1154 #createAt:extent: 34 2 498 839 25 498 121 41 2272 1154 #isEnabled: 8 #(false) 2272 1154 #text: 34 1 8 '<a>Previous</a>' 2272 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 1 0 0 12 0 0 0 223 1 0 0 32 0 0 0] 8 #() 1296 nil 27 1314 1360 -409 1376 121 1392 3 1408 41 410 ##(UI.LinkButton) 34 15 nil 2096 34 2 8 1140850688 65 2656 nil nil nil 519 nil nil nil 2656 480 8 1801822672 2354 #next 8 'Next' 1 1 nil 1090 138 144 34 3 1154 #createAt:extent: 34 2 498 1009 25 498 121 41 2656 1154 #isEnabled: 8 #(false) 2656 1154 #text: 34 1 8 '<a>Next</a>' 2656 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 248 1 0 0 12 0 0 0 52 2 0 0 32 0 0 0] 8 #() 1296 nil 27 1314 1360 -239 1376 121 1392 3 1408 41 410 ##(UI.LinkButton) 34 15 nil 2096 34 2 8 1140850688 65 3024 nil nil nil 519 nil nil nil 3024 480 8 1801822672 2354 #reload 8 'Reload' 1 1 nil 1090 138 144 34 3 1154 #createAt:extent: 34 2 498 1129 25 498 91 41 3024 1154 #isEnabled: 8 #(false) 3024 1154 #text: 34 1 8 '<a>Reload</a>' 3024 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 2 0 0 12 0 0 0 97 2 0 0 32 0 0 0] 8 #() 1296 nil 27 1314 1360 -119 1376 91 1392 3 1408 41 410 ##(UI.LinkButton) 34 15 nil 2096 34 2 8 1140850688 65 3392 nil nil nil 519 nil nil nil 3392 480 8 1801822672 2354 #displayIt 8 'Display It' 1 1 nil 1090 138 144 34 3 1154 #createAt:extent: 34 2 498 221 23 498 201 33 3392 1154 #isEnabled: 8 #(false) 3392 1154 #text: 34 1 8 '<a>Display It</a>' 3392 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 11 0 0 0 210 0 0 0 27 0 0 0] 8 #() 1296 nil 27 1314 1808 201 1376 201 1392 1 1408 33 410 ##(UI.LinkButton) 34 15 nil 2096 34 2 8 1140850688 65 3760 nil nil nil 519 nil nil nil 3760 480 8 1801822672 2354 #evaluateIt 8 'Evaluate It' 1 1 nil 1090 138 144 34 3 1154 #createAt:extent: 34 2 498 21 23 498 201 33 3760 1154 #isEnabled: 8 #(false) 3760 1154 #text: 34 1 8 '<a>Evaluate It</a>' 3760 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 11 0 0 0 110 0 0 0 27 0 0 0] 8 #() 1296 nil 27 1314 1808 1 1376 201 1392 1 1408 33 410 ##(UI.LinkButton) 34 15 nil 2096 34 2 8 1140850688 65 4128 nil nil nil 519 nil nil nil 4128 480 8 1801822672 2354 #inspectIt 8 'Inspect It' 1 1 nil 1090 138 144 34 3 1154 #createAt:extent: 34 2 498 421 23 498 201 33 4128 1154 #isEnabled: 8 #(false) 4128 1154 #text: 34 1 8 '<a>Inspect It</a>' 4128 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 11 0 0 0 54 1 0 0 27 0 0 0] 8 #() 1296 nil 27 1314 1808 401 1376 201 1392 1 1408 33 170 192 8 #() 1026 498 21 23 498 1 1 1090 138 144 34 1 1154 #createAt:extent: 34 2 498 21 1143 498 1249 81 2096 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 59 2 0 0 122 2 0 0 99 2 0 0] 34 6 3760 3392 4128 2272 2656 3024 1296 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 4736 nil nil nil 7 nil nil nil 4736 626 1 1 nil nil nil nil 410 ##(UI.Scintilla.ScintillaView) 34 50 nil 4736 34 2 8 1411387716 1 4816 866 nil false 912 nil 960 nil 7 461638 4 ##(UI.Menu) nil true 34 12 1180742 2 ##(UI.CommandMenuItem) 1 2354 #cutSelection 8 'Cu&t' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'EditCut.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 4946 1 2354 #copySelection 8 '&Copy' 1 1 5010 nil true 5056 8 'EditCopy.ico' 5104 nil nil 4946 1 2354 #pasteClipboard 8 '&Paste' 1 1 5010 nil true 5056 8 'EditPaste.ico' 5104 nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 4946 1 2354 #browseIt 8 'Bro&wse It' 1 1 5010 nil true 5056 8 'ClassBrowserShell.ico' 5104 nil nil 4946 1 2354 #displayIt 8 '&Display It' 1 1 5010 nil true 5056 8 'DisplayIt.ico' 5104 nil nil 4946 1 2354 #printIt 8 'P&rint It' 1 1 5010 nil true 5056 8 'PrintIt.ico' 5104 nil nil 4946 1 2354 #evaluateIt 8 'E&valuate It' 1 1 5010 nil true 5056 8 'EvaluateIt.ico' 5104 nil nil 4946 1 2354 #inspectIt 8 '&Inspect It' 1 1 5010 nil true 5056 8 'InspectIt.ico' 5104 nil nil 4946 1 2354 #debugIt 8 'Deb&ug It' 1 1 5010 nil true 5056 8 'Debugger.ico' 5104 nil nil 5298 4097 4898 nil true 34 9 4946 1 2354 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4946 1 2354 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4946 1 2354 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 4946 1 2354 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4946 1 2354 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4946 1 2354 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4946 1 2354 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 5298 4097 4898 nil true 34 2 4946 1 2354 786950 ##(Core.Message) #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 4946 1 2354 6274 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 530 nil true 562 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 4816 nil 8 1434664858 994 nil nil 9 1777665137 170 192 34 4 #normal 1444934 1 ##(UI.Scintilla.TextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 6594 77 466 #gray 960 1 nil nil nil nil #callTip nil nil nil nil 2032902 ##(Tools.SmalltalkExpressionStyler) 1 nil nil false 138 144 4512 170 192 34 2 #default 1903686 2 ##(UI.Scintilla.MarkerDefinition) 1 nil nil nil 4816 #circle nil nil nil nil nil nil 138 ##(Core.IdentitySet) 4512 nil 170 176 4512 9215 nil nil nil nil 466 #silver nil nil 65 nil nil 170 192 34 6 #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 6560 nil nil nil nil 208 nil 170 192 34 6 #Notification 1772614 3 ##(UI.Scintilla.IndicatorStyle) 17 4816 466 #commonGreen 11 false #Notification nil nil nil nil nil nil #Warning 6978 19 4816 466 #blue 3 false #Warning nil nil nil nil nil nil #Error 6978 21 4816 466 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 6594 1029 nil 466 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 6594 1027 466 #darkGoldenrod 466 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 6594 1031 466 #firebrick 466 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 1090 138 144 34 10 1154 #createAt:extent: 34 2 498 21 21 498 1209 943 4816 1154 #contextMenu: 34 1 4912 4816 1154 #hoverTime: 8 #(500) 4816 1154 #caretPeriod: 8 #(530) 4816 1154 #wordWrap: 8 #(true) 4816 1154 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 4816 1 3 nil nil 5 nil 7538 3 4816 1 nil nil 67108863 5 nil 7538 5 4816 1 nil nil nil 5 nil 4816 1154 #tabWidth: 8 #(4) 4816 1154 #targetRange: 34 1 852742 ##(Core.Interval) 1 -1 3 4816 1154 #maxCompletionListHeight: 8 #(9) 4816 1154 #edgeColumn: 8 #(1) 4816 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 102 2 0 0 225 1 0 0] 8 #() 1296 nil 31 170 192 34 2 4816 8 'workspace' 1026 498 21 21 498 21 21 1090 138 144 34 1 1154 #createAt:extent: 34 2 498 21 161 498 1249 983 4736 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 80 0 0 0 122 2 0 0 59 2 0 0] 34 1 4816 1296 nil 27 170 192 34 6 656 8 'header' 2096 8 'footer' 4736 8 'content' 1026 498 21 21 498 21 21 nil nil nil nil 1 nil nil nil 498 1071 711 1 nil nil 1090 138 144 34 1 1154 #createAt:extent: 34 2 498 6143 21 498 1321 1321 416 1234 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 147 14 0 0 158 2 0 0] 34 3 656 4736 2096 1296 nil 27 )! !
!Tools.TutorialPlayer class categoriesFor: #defaultModel!public! !
!Tools.TutorialPlayer class categoriesFor: #icon!constants!public! !
!Tools.TutorialPlayer class categoriesFor: #resource_Default_view!public!resources-views! !

