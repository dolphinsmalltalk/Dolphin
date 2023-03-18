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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #default 918022 #{Graphics.Point} 1321 1321 551 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 84 114 101 98 117 99 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 656 nil 466 #orchid nil 7 nil nil nil 656 1048838 #{UI.FramingLayout} 170 176 34 4 410 #{UI.StaticText} 34 16 nil 656 34 2 8 1140850944 1 800 nil nil nil 7 nil 530 nil true 562 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 84 114 101 98 117 99 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 800 466 #white 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 21 45 498 1061 97 800 1042 #text: 34 1 8 'Title' 800 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 22 0 0 0 28 2 0 0 70 0 0 0] 8 #() 498 193 193 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 1 1282 #fixedParentRight -167 1282 #fixedParentTop 1 1282 #fixedViewTop 97 410 #{Graphics.Gdiplus.ImageView} 34 28 nil 656 34 2 8 1140850944 1 1360 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} 1378630 2 #{Graphics.TextTileIcon} $\x1F393 nil 720 928 nil nil 1 nil nil nil nil 7 nil nil nil 1360 nil 8 4294902331 962 nil nil nil 1504 #scaleToFit 1 1180166 #{Graphics.Rectangle} 498 1 1 498 1 1 nil nil #none nil nil nil nil nil 994 34 1 1042 #createAt:extent: 34 2 498 1101 7 498 129 129 1360 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 38 2 0 0 3 0 0 0 102 2 0 0 67 0 0 0] 8 #() 1232 nil 29 1250 1312 -147 1282 #fixedViewLeft 129 1328 -37 1344 129 170 192 34 4 800 8 'title' 1360 8 'badge' 1554 498 21 45 498 1 1 994 34 1 1042 #createAt:extent: 34 2 498 21 21 498 1249 141 656 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 122 2 0 0 80 0 0 0] 34 2 800 1360 1232 nil 27 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 2048 nil 720 nil 7 nil 530 nil true 562 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 2048 738 170 176 34 12 410 #{UI.LinkButton} 34 15 nil 2048 34 2 8 1140850688 65 2224 nil nil nil 519 nil nil nil 2224 480 8 1814724400 1377606 4 #{UI.CommandDescription} #evaluateIt 8 'Evaluate It' 1 1 nil 994 34 3 1042 #createAt:extent: 34 2 498 21 23 498 201 33 2224 1042 #isEnabled: 8 #(false) 2224 1042 #text: 34 1 8 '<a>Evaluate It</a>' 2224 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 11 0 0 0 110 0 0 0 27 0 0 0] 8 #() 1232 nil 27 1250 1296 1 1776 201 1328 1 1344 33 410 #{UI.LinkButton} 34 15 nil 2048 34 2 8 1140850688 65 2592 nil nil nil 519 nil nil nil 2592 480 8 1814724400 2306 #next 8 'Next' 1 1 nil 994 34 3 1042 #createAt:extent: 34 2 498 1009 25 498 121 41 2592 1042 #isEnabled: 8 #(false) 2592 1042 #text: 34 1 8 '<a>Next</a>' 2592 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 248 1 0 0 12 0 0 0 52 2 0 0 32 0 0 0] 8 #() 1232 nil 27 1250 1312 -239 1776 121 1328 3 1344 41 410 #{UI.LinkButton} 34 15 nil 2048 34 2 8 1140850688 65 2944 nil nil nil 519 nil nil nil 2944 480 8 1814724400 2306 #displayIt 8 'Display It' 1 1 nil 994 34 3 1042 #createAt:extent: 34 2 498 221 23 498 201 33 2944 1042 #isEnabled: 8 #(false) 2944 1042 #text: 34 1 8 '<a>Display It</a>' 2944 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 11 0 0 0 210 0 0 0 27 0 0 0] 8 #() 1232 nil 27 1250 1296 201 1776 201 1328 1 1344 33 410 #{UI.LinkButton} 34 15 nil 2048 34 2 8 1140850688 65 3296 nil nil nil 519 nil nil nil 3296 480 8 1814724400 2306 #previous 8 'Previous' 1 1 nil 994 34 3 1042 #createAt:extent: 34 2 498 839 25 498 121 41 3296 1042 #isEnabled: 8 #(false) 3296 1042 #text: 34 1 8 '<a>Previous</a>' 3296 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 1 0 0 12 0 0 0 223 1 0 0 32 0 0 0] 8 #() 1232 nil 27 1250 1312 -409 1776 121 1328 3 1344 41 410 #{UI.LinkButton} 34 15 nil 2048 34 2 8 1140850688 65 3648 nil nil nil 519 nil nil nil 3648 480 8 1814724400 2306 #reload 8 'Reload' 1 1 nil 994 34 3 1042 #createAt:extent: 34 2 498 1129 25 498 91 41 3648 1042 #isEnabled: 8 #(false) 3648 1042 #text: 34 1 8 '<a>Reload</a>' 3648 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 2 0 0 12 0 0 0 97 2 0 0 32 0 0 0] 8 #() 1232 nil 27 1250 1312 -119 1776 91 1328 3 1344 41 410 #{UI.LinkButton} 34 15 nil 2048 34 2 8 1140850688 65 4000 nil nil nil 519 nil nil nil 4000 480 8 1814724400 2306 #inspectIt 8 'Inspect It' 1 1 nil 994 34 3 1042 #createAt:extent: 34 2 498 421 23 498 201 33 4000 1042 #isEnabled: 8 #(false) 4000 1042 #text: 34 1 8 '<a>Inspect It</a>' 4000 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 11 0 0 0 54 1 0 0 27 0 0 0] 8 #() 1232 nil 27 1250 1296 401 1776 201 1328 1 1344 33 170 192 8 #() 1554 498 21 23 498 1 1 994 34 1 1042 #createAt:extent: 34 2 498 21 1143 498 1249 81 2048 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 59 2 0 0 122 2 0 0 99 2 0 0] 34 6 2224 2944 4000 3296 2592 3648 1232 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 4576 nil nil nil 7 nil nil nil 4576 626 1 1 nil nil nil nil 410 #{UI.Scintilla.ScintillaView} 34 52 nil 4576 34 2 8 1411387716 1 4656 1426 nil false 1472 nil 928 nil 7 461638 4 #{UI.Menu} nil true 34 12 1180742 2 #{UI.CommandMenuItem} 1 2306 #cutSelection 8 'Cu&t' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'EditCut.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 4786 1 2306 #copySelection 8 '&Copy' 1 1 4850 nil true 4882 8 'EditCopy.ico' 4944 65541 nil nil nil 4786 1 2306 #pasteClipboard 8 '&Paste' 1 1 4850 nil true 4882 8 'EditPaste.ico' 4944 65541 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 4786 1 2306 #browseIt 8 'Bro&wse It' 1 1 4850 nil true 4882 8 'ClassBrowserShell.ico' 4944 65541 nil nil nil 4786 1 2306 #displayIt 8 '&Display It' 1 1 4850 nil true 4882 8 'DisplayIt.ico' 4944 65541 nil nil nil 4786 1 2306 #printIt 8 'P&rint It' 1 1 4850 nil true 4882 8 'PrintIt.ico' 4944 65541 nil nil nil 4786 1 2306 #evaluateIt 8 'E&valuate It' 1 1 4850 nil true 4882 8 'EvaluateIt.ico' 4944 65541 nil nil nil 4786 1 2306 #inspectIt 8 '&Inspect It' 1 1 4850 nil true 4882 8 'InspectIt.ico' 4944 65541 nil nil nil 4786 1 2306 #debugIt 8 'Deb&ug It' 1 1 4850 nil true 4882 8 'Debugger.ico' 4944 65541 nil nil nil 5170 4097 4738 nil true 34 9 4786 1 2306 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4786 1 2306 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4786 1 2306 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 4786 1 2306 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4786 1 2306 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4786 1 2306 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4786 1 2306 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 5170 4097 4738 nil true 34 2 4786 1 2306 786950 #{Core.Message} #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 4786 1 2306 6242 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 530 nil true 562 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 4656 nil 8 1395533126 962 nil nil 9 nil 170 192 34 4 #normal 1444934 1 #{UI.Scintilla.TextStyle} 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 6562 77 466 #gray 928 1 nil nil nil nil #callTip nil nil nil nil 2032902 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 138 144 4368 170 192 34 2 #default 1903686 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 4656 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 4368 nil 170 176 4368 9215 nil nil 170 176 34 2 81 466 #windowText nil nil 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 6528 nil nil nil nil 208 nil 170 192 34 6 #Notification 1772614 4 #{UI.Scintilla.IndicatorStyle} 17 4656 466 #commonGreen 11 1 #Notification nil nil nil nil nil nil #Error 7010 21 4656 466 #red 3 1 #Error nil nil nil nil nil nil #Warning 7010 19 4656 466 #blue 3 1 #Warning nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 6562 1029 nil 466 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Error 6562 1031 466 #firebrick 466 #floralWhite 1 nil nil nil nil #Error nil nil nil #Warning 6562 1027 466 #darkGoldenrod 466 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 994 34 7 1042 #createAt:extent: 34 2 498 21 21 498 1209 943 4656 1042 #contextMenu: 34 1 4752 4656 1042 #sciSetMouseDwellTime: 8 #(500) 4656 1042 #wordWrap: 8 #(true) 4656 1042 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 4656 1 3 nil nil 5 nil 7522 3 4656 1 nil nil 67108863 5 nil 7522 5 4656 1 nil nil nil 5 nil 4656 1042 #tabWidth: 8 #(4) 4656 1042 #maxCompletionListHeight: 8 #(9) 4656 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 102 2 0 0 225 1 0 0] 8 #() 1232 nil 35 170 192 34 2 4656 8 'workspace' 1554 498 21 21 498 21 21 994 34 1 1042 #createAt:extent: 34 2 498 21 161 498 1249 983 4576 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 80 0 0 0 122 2 0 0 59 2 0 0] 34 1 4656 1232 nil 27 170 192 34 6 656 8 'header' 4576 8 'content' 2048 8 'footer' 1554 498 21 21 498 21 21 nil nil nil nil 1 nil nil nil 498 1071 711 1 nil nil 994 34 1 1042 #createAt:extent: 34 2 498 12287 21 498 1321 1321 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 147 26 0 0 158 2 0 0] 34 3 656 4576 2048 1232 nil 27)! !
!Tools.TutorialPlayer class categoriesForMethods!
defaultModel!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

