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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default 518 #{Graphics.Point} 1321 1321 519 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONT} 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 84 114 101 98 117 99 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 288 nil 98 #orchid nil 7 nil nil nil 288 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 2 18 #{Graphics.Gdiplus.ImageView} 50 28 nil 288 50 2 8 1140850944 1 432 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} 2374 2 #{Graphics.TextTileIcon} 8 $🎓 nil 352 98 #white nil nil 1 nil nil nil nil 7 nil nil nil 432 nil 8 4294902331 518 #{UI.NullConverter} nil nil nil 576 #scaleToFit 1 518 #{Graphics.Rectangle} 130 1 1 130 1 1 nil nil #none nil nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 130 1101 7 130 129 129 432 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 38 2 0 0 3 0 0 0 102 2 0 0 67 0 0 0] 8 #() 130 193 193 nil 29 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentRight -147 978 #fixedViewLeft 129 978 #fixedParentTop -37 978 #fixedViewTop 129 18 #{UI.StaticText} 50 16 nil 288 50 2 8 1140850944 1 1056 nil nil nil 7 nil 162 nil true 194 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 84 114 101 98 117 99 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 1056 608 8 1853387904 642 nil nil nil 738 50 2 786 #createAt:extent: 50 2 130 21 45 130 1061 97 1056 786 #text: 50 1 8 'Title' 1056 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 22 0 0 0 28 2 0 0 70 0 0 0] 8 #() 928 nil 27 946 978 #fixedParentLeft 1 992 -167 1024 1 1040 97 550 #{Core.IdentityDictionary} 2 432 8 'badge' 1056 8 'title' 674 130 21 45 130 1 1 738 50 1 786 #createAt:extent: 50 2 130 21 21 130 1249 141 288 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 122 2 0 0 80 0 0 0] 50 2 1056 432 928 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1696 nil 352 nil 7 nil 162 nil true 194 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 1696 370 402 6 18 #{UI.LinkButton} 50 15 nil 1696 50 2 8 1140850688 65 1856 nil nil nil 519 nil nil nil 1856 112 8 1853021440 1350 4 #{UI.CommandDescription} #inspectIt 8 'Inspect It' 1 1 nil 738 50 3 786 #createAt:extent: 50 2 130 421 23 130 201 33 1856 786 #isEnabled: 8 #(false) 1856 786 #text: 50 1 8 '<a>Inspect It</a>' 1856 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 11 0 0 0 54 1 0 0 27 0 0 0] 8 #() 928 nil 27 946 1424 401 1008 201 1024 1 1040 33 18 #{UI.LinkButton} 50 15 nil 1696 50 2 8 1140850688 65 2224 nil nil nil 519 nil nil nil 2224 112 8 1853021440 1938 #evaluateIt 8 'Evaluate It' 1 1 nil 738 50 3 786 #createAt:extent: 50 2 130 21 23 130 201 33 2224 786 #isEnabled: 8 #(false) 2224 786 #text: 50 1 8 '<a>Evaluate It</a>' 2224 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 11 0 0 0 110 0 0 0 27 0 0 0] 8 #() 928 nil 27 946 1424 1 1008 201 1024 1 1040 33 18 #{UI.LinkButton} 50 15 nil 1696 50 2 8 1140850688 65 2576 nil nil nil 519 nil nil nil 2576 112 8 1853021440 1938 #displayIt 8 'Display It' 1 1 nil 738 50 3 786 #createAt:extent: 50 2 130 221 23 130 201 33 2576 786 #isEnabled: 8 #(false) 2576 786 #text: 50 1 8 '<a>Display It</a>' 2576 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 11 0 0 0 210 0 0 0 27 0 0 0] 8 #() 928 nil 27 946 1424 201 1008 201 1024 1 1040 33 18 #{UI.LinkButton} 50 15 nil 1696 50 2 8 1140850688 65 2928 nil nil nil 519 nil nil nil 2928 112 8 1853021440 1938 #reload 8 'Reload' 1 1 nil 738 50 3 786 #createAt:extent: 50 2 130 1129 25 130 91 41 2928 786 #isEnabled: 8 #(false) 2928 786 #text: 50 1 8 '<a>Reload</a>' 2928 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 2 0 0 12 0 0 0 97 2 0 0 32 0 0 0] 8 #() 928 nil 27 946 992 -119 1008 91 1024 3 1040 41 18 #{UI.LinkButton} 50 15 nil 1696 50 2 8 1140850688 65 3280 nil nil nil 519 nil nil nil 3280 112 8 1853021440 1938 #previous 8 'Previous' 1 1 nil 738 50 3 786 #createAt:extent: 50 2 130 839 25 130 121 41 3280 786 #isEnabled: 8 #(false) 3280 786 #text: 50 1 8 '<a>Previous</a>' 3280 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 1 0 0 12 0 0 0 223 1 0 0 32 0 0 0] 8 #() 928 nil 27 946 992 -409 1008 121 1024 3 1040 41 18 #{UI.LinkButton} 50 15 nil 1696 50 2 8 1140850688 65 3632 nil nil nil 519 nil nil nil 3632 112 8 1853021440 1938 #next 8 'Next' 1 1 nil 738 50 3 786 #createAt:extent: 50 2 130 1009 25 130 121 41 3632 786 #isEnabled: 8 #(false) 3632 786 #text: 50 1 8 '<a>Next</a>' 3632 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 248 1 0 0 12 0 0 0 52 2 0 0 32 0 0 0] 8 #() 928 nil 27 946 992 -239 1008 121 1024 3 1040 41 1442 0 674 130 21 23 130 1 1 738 50 1 786 #createAt:extent: 50 2 130 21 1143 130 1249 81 1696 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 59 2 0 0 122 2 0 0 99 2 0 0] 50 6 2224 2576 1856 3280 3632 2928 928 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 4192 nil nil nil 7 nil nil nil 4192 258 1 1 nil nil nil nil 18 #{UI.Scintilla.ScintillaView} 50 56 nil 4192 50 2 8 1411387716 1 4272 498 nil false 544 nil 608 nil 7 2886 4 #{UI.Menu} nil true 50 12 1094 2 #{UI.CommandMenuItem} 1 1938 #cutSelection 8 'Cu&t' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'EditCut.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 4402 1 1938 #copySelection 8 '&Copy' 1 1 4466 nil true 4498 8 'EditCopy.ico' 4560 65541 nil nil nil 4402 1 1938 #pasteClipboard 8 '&Paste' 1 1 4466 nil true 4498 8 'EditPaste.ico' 4560 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 4402 1 1938 #browseIt 8 'Bro&wse It' 1 1 4466 nil true 4498 8 'ClassBrowserShell.ico' 4560 65541 nil nil nil 4402 1 1938 #displayIt 8 '&Display It' 1 1 4466 nil true 4498 8 'DisplayIt.ico' 4560 65541 nil nil nil 4402 1 1938 #printIt 8 'P&rint It' 1 1 4466 nil true 4498 8 'PrintIt.ico' 4560 65541 nil nil nil 4402 1 1938 #evaluateIt 8 'E&valuate It' 1 1 4466 nil true 4498 8 'EvaluateIt.ico' 4560 65541 nil nil nil 4402 1 1938 #inspectIt 8 '&Inspect It' 1 1 4466 nil true 4498 8 'InspectIt.ico' 4560 65541 nil nil nil 4402 1 1938 #debugIt 8 'Deb&ug It' 1 1 4466 nil true 4498 8 'Debugger.ico' 4560 65541 nil nil nil 4786 4097 4354 nil true 50 9 4402 1 1938 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4402 1 1938 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4402 1 1938 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 4402 1 1938 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4402 1 1938 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4402 1 1938 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4402 1 1938 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 4786 4097 4354 nil true 50 2 4402 1 1938 518 #{Core.Message} #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 4402 1 1938 5858 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 162 nil true 194 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 4272 nil 8 1367644576 642 nil nil 9 #focusLost nil nil nil nil 1442 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 98 #gray 608 1 nil nil nil nil #callTip nil nil nil #normal 6162 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 550 #{Core.OrderedCollection} 0 1442 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 4272 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 402 0 9215 nil nil 402 1 81 98 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 1442 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 1442 1 #container 6144 nil nil nil nil #{Core.Utf8String} nil 1442 3 #Error 3142 5 #{UI.Scintilla.IndicatorDefinition} 21 4272 98 #red 3 1 #Error nil nil nil nil nil nil #Notification 6546 17 4272 98 #commonGreen 11 1 #Notification nil nil nil nil nil nil #Warning 6546 19 4272 98 #blue 3 1 #Warning nil nil nil nil nil nil nil nil 1442 3 #Error 6162 1031 98 #firebrick 98 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 6162 1029 nil 98 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 6162 1027 98 #darkGoldenrod 98 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 738 50 6 786 #createAt:extent: 50 2 130 21 21 130 1209 943 4272 786 #sciSetMouseDwellTime: 8 #(500) 4272 786 #wordWrap: 8 #(true) 4272 786 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 4272 nil 3 nil nil 5 nil 7010 3 4272 nil nil nil 67108863 5 nil 7010 5 4272 nil nil nil nil 5 nil 4272 786 #tabWidth: 8 #(4) 4272 786 #maxCompletionListHeight: 8 #(9) 4272 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 102 2 0 0 225 1 0 0] 8 #() 928 nil 45 1442 1 4272 8 'workspace' 674 130 21 21 130 21 21 738 50 1 786 #createAt:extent: 50 2 130 21 161 130 1249 983 4192 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 80 0 0 0 122 2 0 0 59 2 0 0] 50 1 4272 928 nil 27 1442 3 4192 8 'content' 1696 8 'footer' 288 8 'header' 674 130 21 21 130 21 21 nil nil nil nil 1 nil nil nil 130 1071 711 1 nil nil 738 50 1 786 #createAt:extent: 50 2 130 6143 21 130 1321 1321 32 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 147 14 0 0 158 2 0 0] 50 3 288 4192 1696 928 nil 27)! !
!Tools.TutorialPlayer class categoriesForMethods!
defaultModel!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

