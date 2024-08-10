"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.ToolbarTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.ToolbarTest guid: (Core.GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!

UI.Tests.ToolbarTest comment: ''!

!UI.Tests.ToolbarTest methodsFor!

classToTest
	^Toolbar!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view hasBitmapButtons |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assert: (view items allSatisfy: [:each | each isKindOf: ToolbarItem]).
	view items do: 
			[:each |
			each isDivider
				ifFalse: 
					[self assertIsNil: each textcolor.
					self assertIsNil: each font]].
	hasBitmapButtons := view items anySatisfy: [:each | each isKindOf: ToolbarBitmapButton].
	self assert: view interactor identicalTo: view.
	self assert: view actualImageSize equals: #smallIcons.
	self assert: view scaledBitmapSize
		equals: (hasBitmapButtons
				ifTrue: [SystemMetrics default smallIconExtent]
				ifFalse: [view metrics smallIconExtent]).
	self assert: view indent equals: 0.
	"12->13 conversion"
	self assert: (view backcolor == Color default or: [view backcolor isNil]).
	self assert: (view forecolor == Color default or: [view forecolor isNil]).
	self assert: view isTransparent.
	self deny: view hasLabels.
	self assert: (view baseStyleAllMask: OS.CommCtrlConstants.CCS_NOPARENTALIGN).
	self assertIsNil: view textcolor! !

!UI.Tests.ToolbarTest categoriesForMethods!
classToTest!helpers!private! !
verifyUpgradedView:identifier:!helpers!private! !
!

!UI.Tests.ToolbarTest class methodsFor!

resource_Fluent_Find_tools_D7
	"Toolbar with text buttons from D7.2 at stb version 1.

	THIS RESOURCE MUST REMAIN UNCHANGED FOR UPGRADE TESTING PURPOSES, but to view:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Fluent_Find_tools_D7)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.Toolbar) 34 28 nil nil 34 2 8 1409293132 131137 416 nil nil nil 519 nil nil nil 416 327686 ##(Smalltalk.Color) #default 8 1759112192 170 192 8 #() nil nil nil 170 192 34 4 15853 1115462 1 ##(Smalltalk.ToolbarTextButton) 416 161 1180998 4 ##(Smalltalk.CommandDescription) #findNext 8 'Find Next' 1 1 nil 15853 $\xE893 15851 594 416 161 626 #find 8 'Find' 1 1 nil 15851 $\xE721 34 3 672 608 1049158 1 ##(Smalltalk.ToolbarSeparator) 416 1 nil nil 13 1 nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[255 9 0 0 10 0 0 0 61 10 0 0 35 0 0 0] 193 34 2 8 1140857676 131137 8 '' 416 1 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 31 )!

resource_Fluent_Find_tools_D8_v1
	"Toolbar with text buttons from D8.1 at stb version 1.

	THIS RESOURCE MUST REMAIN UNCHANGED FOR UPGRADE TESTING PURPOSES, but to view:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Fluent_Find_tools_D8_v1)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Toolbar} 38 #{Core.Array} 28 nil nil 50 2 8 1409293132 131137 32 nil nil nil 517 nil nil nil 32 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 3 1350 1 #{UI.ToolbarTextButton} 32 161 1350 4 #{UI.CommandDescription} #find 8 'Find' 1 1 nil nil 8 $\xE721 210 32 161 242 #findNext 8 'Find Next' 1 1 nil nil 8 $\xE893 582 1 #{UI.ToolbarSeparator} 32 1 nil nil 13 1 nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 61 15 0 0 35 0 0 0] 193 50 2 8 1140857676 131137 8 '' 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 31)!

resource_SUnitBrowser_Resource_browser_toolbar_D7
	"A D7 resource containing ToolbarBitmapButtons and ToolbarSystemButtons.

	THIS RESOURCE MUST REMAIN UNCHANGED FOR UPGRADE TESTING PURPOSES, but to view:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_SUnitBrowser_Resource_browser_toolbar_D7)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.Toolbar) 34 25 nil nil 34 2 8 1140853580 131137 416 nil 327686 ##(Smalltalk.Color) #default nil 519 nil nil nil 416 496 8 1903898080 nil 170 192 34 12 56823 1246790 1 ##(Smalltalk.ToolbarSystemButton) 416 1 1180998 4 ##(Smalltalk.CommandDescription) #reset 8 'Reset' 1 1 nil 56823 1 9 56819 1246790 1 ##(Smalltalk.ToolbarBitmapButton) 416 1 594 #stopSelected 8 'Stop' 1 1 nil 56819 395334 3 ##(Smalltalk.Bitmap) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Tools.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil 71 328198 ##(Smalltalk.Point) 1857 33 65 56815 642 416 1 594 #startSelected 8 'Run Selected' 1 1 nil 56815 720 83 56821 562 416 1 594 #delete 8 'Delete' 1 1 nil 56821 1 11 56817 642 416 1 594 #stopAll 8 'Stop All' 1 1 nil 56817 720 53 56813 642 416 1 594 #startAll 8 'Run All' 1 1 nil 56813 720 51 34 9 1008 864 1049158 1 ##(Smalltalk.ToolbarSeparator) 416 1 960 656 1074 416 1 912 1074 416 1 576 nil nil 1 nil 834 33 33 834 45 45 nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 834 3839 21 834 701 51 416 1234 #updateSizePosted 8 #() 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 35 0 0 0] 8 #() 834 193 193 nil 27 )!

resource_Tool_bar_D6
	"Answer the literal data from which the 'Tool bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Tool_bar)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.Toolbar)  98 25 0 0 98 2 8 1409288972 131137 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 517 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 498 528 8 4294903295 234 256 98 0 234 256 704 202 208 704 234 240 704 0 1 0 626 33 33 626 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 626 2799 21 626 701 51 416 898 8 #updateSize 704 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 213 6 0 0 35 0 0 0] 98 0 626 193 193 0 27 )!

resource_Tool_bar_D7
	"Answer the literal data from which the 'Tool bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Tool_bar)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.Toolbar) 34 25 nil nil 34 2 8 1409288972 131137 416 nil 327686 ##(Smalltalk.Color) #default nil 517 nil nil nil 416 496 8 1867527152 170 192 8 #() 170 192 544 138 144 544 nil nil 1 nil nil nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 7039 21 738 701 51 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 29 15 0 0 35 0 0 0] 8 #() 738 193 193 nil 27 )!

resource_View_composer_alignment_tools_D8_v1
	"A D8 resource containing ToolbarBitmapButtons.

	THIS RESOURCE MUST REMAIN UNCHANGED FOR UPGRADE TESTING PURPOSES, but to view:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_View_composer_alignment_tools)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Toolbar} 38 #{Core.Array} 28 nil nil 50 2 8 1409289036 131137 32 nil nil nil 517 nil nil nil 32 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 8 1606 1 #{UI.ToolbarBitmapButton} 32 1 1350 4 #{UI.CommandDescription} #alignToGrid nil 1 1 nil nil 1606 4 #{Graphics.Bitmap} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'VCBar.BMP' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 73733 nil nil 5 518 #{Graphics.Point} 929 33 1 210 32 1 242 #alignLefts nil 1 1 nil nil 288 3 210 32 1 242 #alignCenters nil 1 1 nil nil 288 5 210 32 1 242 #alignRights nil 1 1 nil nil 288 7 210 32 1 242 #alignTops nil 1 1 nil nil 288 9 210 32 1 242 #alignMiddles nil 1 1 nil nil 288 11 210 32 1 242 #alignBottoms nil 1 1 nil nil 288 13 582 1 #{UI.ToolbarSeparator} 32 1 nil nil 17 nil #smallIcons 402 45 45 nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 168 15 0 0 35 0 0 0] 193 80 8 '' 32 1 8 #() 402 193 193 nil 31)! !

!UI.Tests.ToolbarTest class categoriesForMethods!
resource_Fluent_Find_tools_D7!public!resources-views! !
resource_Fluent_Find_tools_D8_v1!public!resources-views! !
resource_SUnitBrowser_Resource_browser_toolbar_D7!public!resources-views! !
resource_Tool_bar_D6!public!resources-views! !
resource_Tool_bar_D7!public!resources-views! !
resource_View_composer_alignment_tools_D8_v1!public!resources-views! !
!

