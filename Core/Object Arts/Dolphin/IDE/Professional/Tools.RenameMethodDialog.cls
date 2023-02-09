"Filed out from Dolphin Smalltalk"!

Tools.MethodNameDialog subclass: #'Tools.RenameMethodDialog'
	instanceVariableNames: 'scopePresenter scopeDescriptionPresenter allowExistingSelector'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.RenameMethodDialog guid: (Core.GUID fromString: '{d123996c-3d35-47b6-a418-da4086501e0e}')!
Tools.RenameMethodDialog comment: '
Instance Variables:
	scopePresenter				<ChoicePresenter>
	scopeDescriptionPresenter	<TextPresenter>
	allowExistingSelector			<boolean>

'!
!Tools.RenameMethodDialog categoriesForClass!MVP-Presenters!MVP-Resources-Dialogs! !
!Tools.RenameMethodDialog methodsFor!

allowExistingSelector: aBoolean 
	allowExistingSelector := aBoolean!

conditionsFor: aRBMethodName
	| conditions |
	conditions := (super conditionsFor: aRBMethodName)
				& (RBCondition withBlock: [aRBMethodName hasNewSignature]
						errorString: 'Method signature <1?:un>changed').
	^(allowExistingSelector or: [aRBMethodName selector = aRBMethodName originalSelector])
		ifTrue: [conditions]
		ifFalse: 
			[conditions
				& (RBCondition definesSelector: aRBMethodName selectorSymbol in: aRBMethodName methodClass) not]!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	scopePresenter := self add: ChoicePresenter new name: 'scope'.
	scopeDescriptionPresenter := self add: TextPresenter new name: 'scopeDescription'!

initialize
	"Private - Initialize the receiver"

	super initialize.
	allowExistingSelector := false!

model: anObject
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: anObject.
	aspectBuffer := self model.
	scopePresenter choices: anObject scopeNames.
	scopePresenter model: (aspectBuffer aspectValue: #scopeName).
	scopeDescriptionPresenter
		model: (aspectBuffer aspectValue: #scope triggers: #scopeChanged) beReadOnly! !
!Tools.RenameMethodDialog categoriesForMethods!
allowExistingSelector:!accessing!public! !
conditionsFor:!accessing!private! !
createComponents!initializing!public! !
initialize!initializing!private! !
model:!accessing!public! !
!

!Tools.RenameMethodDialog class methodsFor!

defaultModel
	^ScopedMethodName new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(12845056 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1048838 #{UI.FramingLayout} 170 176 34 10 410 #{UI.ComboBox} 34 17 nil 640 34 2 8 1144063491 1025 768 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 7 nil nil nil 768 nil 8 1833584496 786950 #{Core.Message} #displayString 8 #() 8 #() 401 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 141 69 578 191 47 768 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 34 0 0 0 165 0 0 0 57 0 0 0] 8 #() 578 193 193 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedPreviousRight 21 1282 #fixedViewLeft 191 1282 #fixedPreviousTop -3 1282 #fixedViewTop 41 410 #{UI.Scintilla.ScintillaView} 34 52 nil 640 34 2 8 1174409476 65 1360 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil nil nil 7 nil nil nil 1360 nil 8 1548917200 1049094 #{UI.NullConverter} nil nil 11 nil 170 192 34 8 #normal 1444934 1 #{UI.Scintilla.TextStyle} 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 1641542 1 #{UI.Scintilla.CallTipStyle} 77 930 #tooltipText 930 #tooltip 1 nil nil nil nil #callTip nil nil nil #lineNumber 1570 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #indentGuide 1570 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil nil 1507654 1 #{UI.Scintilla.NullStyler} #normal 170 192 34 2 #default 1903686 2 #{UI.Scintilla.MarkerDefinition} nil nil nil nil 1360 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 880 8 'zyxwvutsrqponmlkjihgfedcba_ZYXWVUTSRQPONMLKJIHGFEDCBA9876543210#' 170 176 880 nil nil nil 170 176 34 6 1 930 #windowText 81 1872 3 930 #window nil nil 2162950 #{UI.Scintilla.NullScintillaLibrary} nil nil 8 '~}|{`^]\[@?>=<;:/.-,+*)(''&%$"!!' nil nil nil 1 170 192 880 nil nil nil nil 208 nil nil nil nil 170 192 34 6 #Error 1570 1027 930 #firebrick 930 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 1570 1031 nil 930 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 1570 1029 930 #darkGoldenrod 930 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 1042 34 6 1090 #createAt:extent: 34 2 578 341 73 578 359 95 1360 1090 #wordWrap: 8 #(true) 1360 1090 #margins: 34 1 34 5 1247302 3 #{UI.Scintilla.Margin} 1 1360 1 3 nil nil nil nil 2306 3 1360 33 nil nil 67108863 nil nil 2306 5 1360 1 nil nil nil nil nil 2306 7 1360 1 nil nil nil nil nil 2306 9 1360 1 nil nil nil nil nil 1360 1090 #canHScroll: 8 #(false) 1360 1090 #targetRange: 34 1 852742 #{Core.Interval} 3 1 3 1360 1090 #maxCompletionListHeight: 8 #(9) 1360 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 170 0 0 0 36 0 0 0 93 1 0 0 83 0 0 0] 8 #() 1232 nil 35 1250 1296 11 1282 #fixedParentRight -9 1328 5 1282 #fixedParentBottom -3 410 #{UI.TextEdit} 34 16 nil 640 34 2 8 1140916352 1025 2624 nil 944 nil 7 nil nil nil 2624 nil 8 1833967856 1506 nil nil 5 1042 34 2 1090 #createAt:extent: 34 2 578 141 13 578 567 45 2624 1090 #setMarginWidths: 34 1 8 #(3 3) 2624 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 8 #() 1232 nil 27 1250 1296 21 2592 -1 1328 -7 1344 45 410 #{UI.StaticText} 34 16 nil 640 34 2 8 1140850944 1 2928 nil nil nil 7 nil nil nil 2928 nil 8 1834179760 1506 nil nil nil 1042 34 2 1090 #createAt:extent: 34 2 578 11 21 578 111 41 2928 1090 #text: 34 1 8 '&Selector:' 2928 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 60 0 0 0 30 0 0 0] 8 #() 1232 nil 27 1250 1282 #fixedParentLeft 11 1312 111 1282 #fixedParentTop 21 1344 41 410 #{UI.StaticText} 34 16 nil 640 34 2 8 1140850944 1 3264 nil nil nil 7 nil nil nil 3264 nil 8 1834179760 1506 nil nil nil 1042 34 2 1090 #createAt:extent: 34 2 578 11 73 578 111 31 3264 1090 #text: 34 1 8 'Scope:' 3264 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 36 0 0 0 60 0 0 0 51 0 0 0] 8 #() 1232 nil 27 1250 3232 11 1312 111 1282 #fixedPreviousBottom 17 1344 31 170 192 34 6 2624 8 'selector' 768 8 'scope' 1360 8 'scopeDescription' nil 1042 34 1 1090 #createAt:extent: 34 2 578 21 17 578 709 171 640 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 108 1 0 0 93 0 0 0] 34 5 2928 2624 3264 768 1360 1232 nil 27 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 3808 nil nil nil 7 nil nil nil 3808 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_Refactoring_OK_Cancel_button_block nil 1042 34 1 1090 #createAt:extent: 34 2 578 21 463 578 709 65 3808 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 231 0 0 0 108 1 0 0 7 1 0 0] 880 1232 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 4032 nil nil nil 7 nil nil nil 4032 610 1 1 410 #{UI.Toolbar} 34 28 nil 4032 34 2 8 1140853612 131073 4112 nil nil nil 519 nil nil nil 4112 944 8 1834079296 170 192 880 nil nil nil 170 192 34 8 32713 1311814 1 #{UI.ToolbarIconButton} 4112 1 1377606 4 #{UI.CommandDescription} #moveLast 8 'Move Last' 1 1 1378630 2 #{Graphics.TextTileIcon} $\x23ED 8 'Georgia' nil 930 #menuHilight nil nil 3 nil nil 32713 32711 4242 4112 1 4274 #moveDown 8 'Move Down' 1 1 4322 $\x25BC nil nil 4368 nil nil 1 nil nil 32711 32709 4242 4112 1 4274 #moveUp 8 'Move Up' 1 1 4322 $\x25B2 8 'Segoe UI' nil 4368 nil nil 1 nil nil 32709 32707 4242 4112 1 4274 #moveFirst 8 'Move First' 1 1 4322 $\x23EE 8 'Georgia' nil 4368 nil nil 3 nil nil 32707 34 4 4528 4448 4384 4256 nil nil 1 nil 578 33 33 nil nil nil 1042 34 1 1090 #createAt:extent: 34 2 578 1 1 578 709 51 4112 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 8 #() 1232 nil 29 nil nil nil 410 #{UI.ListView} 34 45 nil 4032 34 2 8 1140970061 1025 4784 834 138 144 880 nil 912 944 nil 7 461638 4 #{UI.Menu} nil true 34 4 1180742 2 #{UI.CommandMenuItem} 1 4274 #moveFirst 8 'Move to &First' 1 1 nil nil nil 4930 1 4274 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 4930 1 4274 #moveDown 8 'Move to &Next' 1 1 nil nil nil 4930 1 4274 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 4784 nil 8 1834035472 992 nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 '' 701 #left 992 978 #<= 8 #() nil nil 4784 nil 3 nil nil #report 1024 nil 133121 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 1042 34 1 1090 #createAt:extent: 34 2 578 1 51 578 709 217 4784 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 98 1 0 0 133 0 0 0] 8 #() 1232 nil 35 170 192 34 2 4784 8 'list' 1180166 #{Graphics.Rectangle} 578 1 1 578 1 11 1042 34 1 1090 #createAt:extent: 34 2 578 21 187 578 709 277 4032 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 93 0 0 0 108 1 0 0 231 0 0 0] 34 2 4112 4784 1232 nil 27 170 192 34 2 4032 8 'parameters' 5506 578 21 17 578 21 17 nil nil nil nil 16611 nil nil nil 578 481 411 1 nil nil 918278 #{Core.Semaphore} nil nil 1 false 8 2012053952 1042 34 2 1090 #createAt:extent: 34 2 578 6143 21 578 781 621 416 1090 #text: 34 1 8 'Rename Method…' 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 133 13 0 0 64 1 0 0] 34 3 640 4032 3808 1232 nil 27)! !
!Tools.RenameMethodDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

