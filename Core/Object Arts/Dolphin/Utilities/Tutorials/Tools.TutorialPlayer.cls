"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'Tools.TutorialPlayer'
	instanceVariableNames: 'tutorialPosition tutorial title workspace'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.TutorialPlayer guid: (Core.GUID fromString: '{0ba31b85-7347-43e6-87d6-5f582babde3d}')!

Tools.TutorialPlayer comment: 'I can navigate through an AbstractTutorial subclass. With #next and #previous you can go forward and backward through the tutorial.'!

!Tools.TutorialPlayer methodsFor!

createComponents
	super createComponents.
	title := self add: TextPresenter new name: 'title'.
	workspace := self add: SmalltalkWorkspace new name: 'workspace'!

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

	"Workspaces font is set by system options. Override this here."
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

!Tools.TutorialPlayer categoriesForMethods!
createComponents!accessing!private! !
currentLesson!accessing!public! !
displayIt!commands!public! !
evaluateIt!commands!public! !
first!navigation!public! !
inspectIt!commands!public! !
last!navigation!public! !
model:!accessing!private! !
next!navigation!public! !
onViewOpened!accessing!private! !
previous!navigation!public! !
printIt!commands!public! !
reload!navigation!public! !
rewind!navigation!public! !
size!accessing!public! !
tutorial!accessing!public! !
tutorial:!accessing!public! !
tutorialPosition!accessing!public! !
tutorialPosition:!accessing!public! !
updateLesson!accessing!private! !
!

!Tools.TutorialPlayer class methodsFor!

defaultModel
	^AbstractTutorial new!

icon
	^AbstractTutorial icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default 518 #{Graphics.Point} 1321 1321 517 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 84 0 114 0 101 0 98 0 117 0 99 0 104 0 101 0 116 0 32 0 77 0 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil 98 #orchid nil 5 nil nil nil 272 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 4 18 #{Graphics.Gdiplus.ImageView} 50 28 nil 272 50 2 8 1140850944 1 432 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} 2374 2 #{Graphics.TextTileIcon} 8 $🎓 nil 336 98 #white nil nil 1 nil nil nil nil 5 nil nil nil 432 nil nil 518 #{UI.NullConverter} nil nil nil 576 #scaleToFit 1 518 #{Graphics.Rectangle} 130 1 1 130 1 1 nil nil #none nil nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[38 2 0 0 3 0 0 0 102 2 0 0 67 0 0 0] 193 464 nil 432 3 8 #() 130 193 193 nil 29 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentRight -147 962 #fixedViewLeft 129 962 #fixedParentTop -37 962 #fixedViewTop 129 18 #{UI.StaticText} 50 16 nil 272 50 2 8 1140850944 1 1040 nil nil nil 5 nil 162 nil true 194 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 84 0 114 0 101 0 98 0 117 0 99 0 104 0 101 0 116 0 32 0 77 0 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1040 608 nil 626 nil nil nil 722 50 2 770 #createWindow: 50 1 818 850 8 #[10 0 0 0 22 0 0 0 28 2 0 0 70 0 0 0] 193 1072 nil 1040 770 #text: 50 1 8 'Title' 1040 3 8 #() 130 193 193 nil 27 930 962 #fixedParentLeft 1 976 -167 1008 1 1024 97 386 #{Core.IdentityDictionary} 50 4 432 8 'badge' 1040 8 'title' 658 130 21 45 130 1 1 722 50 1 770 #createWindow: 50 1 818 850 8 #[10 0 0 0 10 0 0 0 122 2 0 0 80 0 0 0] 193 304 8 '' 272 3 50 2 1040 432 130 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1664 nil 336 nil 5 nil 162 nil true 194 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1664 354 386 #{Core.LookupTable} 50 12 18 #{UI.LinkButton} 50 15 nil 1664 50 2 8 1140850688 65 1824 nil nil nil 517 nil nil nil 1824 112 nil 1350 4 #{UI.CommandDescription} #evaluateIt 8 'Evaluate It' 1 1 nil 722 50 2 770 #createWindow: 50 1 818 850 8 #[10 0 0 0 11 0 0 0 110 0 0 0 27 0 0 0] 193 1856 8 '<a>Evaluate It</a>' 1824 770 #isEnabled: 8 #(false) 1824 3 8 #() 130 193 193 nil 27 930 1376 1 992 201 1008 1 1024 33 18 #{UI.LinkButton} 50 15 nil 1664 50 2 8 1140850688 65 2144 nil nil nil 517 nil nil nil 2144 112 nil 1890 #displayIt 8 'Display It' 1 1 nil 722 50 2 770 #createWindow: 50 1 818 850 8 #[110 0 0 0 11 0 0 0 210 0 0 0 27 0 0 0] 193 2176 8 '<a>Display It</a>' 2144 770 #isEnabled: 8 #(false) 2144 3 8 #() 130 193 193 nil 27 930 1376 201 992 201 1008 1 1024 33 18 #{UI.LinkButton} 50 15 nil 1664 50 2 8 1140850688 65 2448 nil nil nil 517 nil nil nil 2448 112 nil 1890 #inspectIt 8 'Inspect It' 1 1 nil 722 50 2 770 #createWindow: 50 1 818 850 8 #[210 0 0 0 11 0 0 0 54 1 0 0 27 0 0 0] 193 2480 8 '<a>Inspect It</a>' 2448 770 #isEnabled: 8 #(false) 2448 3 8 #() 130 193 193 nil 27 930 1376 401 992 201 1008 1 1024 33 18 #{UI.LinkButton} 50 15 nil 1664 50 2 8 1140850688 65 2752 nil nil nil 517 nil nil nil 2752 112 nil 1890 #previous 8 'Previous' 1 1 nil 722 50 2 770 #createWindow: 50 1 818 850 8 #[163 1 0 0 12 0 0 0 223 1 0 0 32 0 0 0] 193 2784 8 '<a>Previous</a>' 2752 770 #isEnabled: 8 #(false) 2752 3 8 #() 130 193 193 nil 27 930 976 -409 992 121 1008 3 1024 41 18 #{UI.LinkButton} 50 15 nil 1664 50 2 8 1140850688 65 3056 nil nil nil 517 nil nil nil 3056 112 nil 1890 #next 8 'Next' 1 1 nil 722 50 2 770 #createWindow: 50 1 818 850 8 #[248 1 0 0 12 0 0 0 52 2 0 0 32 0 0 0] 193 3088 8 '<a>Next</a>' 3056 770 #isEnabled: 8 #(false) 3056 3 8 #() 130 193 193 nil 27 930 976 -239 992 121 1008 3 1024 41 18 #{UI.LinkButton} 50 15 nil 1664 50 2 8 1140850688 65 3360 nil nil nil 517 nil nil nil 3360 112 nil 1890 #reload 8 'Reload' 1 1 nil 722 50 2 770 #createWindow: 50 1 818 850 8 #[52 2 0 0 12 0 0 0 97 2 0 0 32 0 0 0] 193 3392 8 '<a>Reload</a>' 3360 770 #isEnabled: 8 #(false) 3360 3 8 #() 130 193 193 nil 27 930 976 -119 992 91 1008 3 1024 41 550 #{Core.IdentityDictionary} 0 658 130 21 23 130 1 1 722 50 1 770 #createWindow: 50 1 818 850 8 #[10 0 0 0 59 2 0 0 122 2 0 0 99 2 0 0] 193 1696 8 '' 1664 3 50 6 1824 2144 2448 2752 3056 3360 130 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 3904 nil nil nil 5 nil nil nil 3904 242 1 1 nil nil nil nil 18 #{UI.Scintilla.ScintillaView} 50 56 nil 3904 50 2 8 1411387716 1 3984 498 nil false 544 nil 608 nil 5 2886 4 #{UI.Menu} nil true 50 12 1094 2 #{UI.CommandMenuItem} 1 1890 #cutSelection 8 'Cu&t' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'EditCut.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 4114 1 1890 #copySelection 8 '&Copy' 1 1 4178 nil true 4210 8 'EditCopy.ico' 4272 65541 nil nil nil 4114 1 1890 #pasteClipboard 8 '&Paste' 1 1 4178 nil true 4210 8 'EditPaste.ico' 4272 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 4114 1 1890 #browseIt 8 'Bro&wse It' 1 1 4178 nil true 4210 8 'ClassBrowserShell.ico' 4272 65541 nil nil nil 4114 1 1890 #displayIt 8 '&Display It' 1 1 4178 nil true 4210 8 'DisplayIt.ico' 4272 65541 nil nil nil 4114 1 1890 #printIt 8 'P&rint It' 1 1 4178 nil true 4210 8 'PrintIt.ico' 4272 65541 nil nil nil 4114 1 1890 #evaluateIt 8 'E&valuate It' 1 1 4178 nil true 4210 8 'EvaluateIt.ico' 4272 65541 nil nil nil 4114 1 1890 #inspectIt 8 '&Inspect It' 1 1 4178 nil true 4210 8 'InspectIt.ico' 4272 65541 nil nil nil 4114 1 1890 #debugIt 8 'Deb&ug It' 1 1 4178 nil true 4210 8 'Debugger.ico' 4272 65541 nil nil nil 4498 4097 4066 nil true 50 9 4114 1 1890 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4114 1 1890 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4114 1 1890 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 4114 1 1890 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4114 1 1890 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4114 1 1890 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4114 1 1890 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 4498 4097 4066 nil true 50 2 4114 1 1890 518 #{Core.Message} #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 4114 1 1890 5570 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 162 nil true 194 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 3984 nil nil 626 nil nil 9 #focusLost nil nil nil nil 3666 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 98 #gray 608 1 nil nil nil nil #callTip nil nil nil #normal 5842 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 550 #{Core.OrderedCollection} 0 3666 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 3984 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 9215 nil nil 6050 1 81 98 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 3666 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 3666 1 #container 5824 nil nil nil nil #{Core.Utf8String} nil 3666 3 #Error 3142 5 #{UI.Scintilla.IndicatorDefinition} 21 3984 98 #red 3 1 #Error nil nil nil nil nil nil #Notification 6242 17 3984 98 #commonGreen 11 1 #Notification nil nil nil nil nil nil #Warning 6242 19 3984 98 #blue 3 1 #Warning nil nil nil nil nil nil nil nil 3666 3 #Error 5842 1031 98 #firebrick 98 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 5842 1029 nil 98 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 5842 1027 98 #darkGoldenrod 98 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 722 50 7 770 #createWindow: 50 1 818 850 8 #[10 0 0 0 10 0 0 0 102 2 0 0 225 1 0 0] 193 4016 nil 3984 770 #contextMenu: 50 1 4080 3984 770 #sciSetMouseDwellTime: 8 #(500) 3984 770 #wordWrap: 8 #(true) 3984 770 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 3984 nil 3 nil nil 5 nil 6754 3 3984 nil nil nil 67108863 5 nil 6754 5 3984 nil nil nil nil 5 nil 3984 770 #tabWidth: 8 #(4) 3984 770 #maxCompletionListHeight: 8 #(9) 3984 3 8 #() 130 193 193 nil 45 386 3664 50 2 3984 8 'workspace' 658 130 21 21 130 21 21 722 50 1 770 #createWindow: 50 1 818 850 8 #[10 0 0 0 80 0 0 0 122 2 0 0 59 2 0 0] 193 3936 8 '' 3904 3 50 1 3984 130 193 193 nil 27 386 3664 50 6 3904 8 'content' 1664 8 'footer' 272 8 'header' 658 130 21 21 130 21 21 nil nil nil nil 1 nil nil nil 130 1071 711 1 nil 193 722 50 1 770 #createWindow: 50 1 818 658 130 7679 21 130 8999 1341 193 80 8 '' 32 1 50 3 272 3904 1664 130 193 193 nil 27)! !

!Tools.TutorialPlayer class categoriesForMethods!
defaultModel!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

