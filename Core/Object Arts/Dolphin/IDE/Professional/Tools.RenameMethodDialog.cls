"Filed out from Dolphin Smalltalk"!

Tools.MethodNameDialog
	subclass: #'Tools.RenameMethodDialog'
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 10 18 #{UI.TextEdit} 50 20 nil 272 50 2 8 1140916352 1025 416 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 416 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 141 13 210 567 45 416 594 #setMarginWidths: 50 1 8 #(3 3) 416 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 8 #() 210 193 193 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 21 834 #fixedParentRight -1 834 #fixedPreviousTop -7 834 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 272 50 2 8 1140850944 1 912 nil nil nil 5 nil nil nil 912 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 210 11 21 210 111 41 912 594 #text: 50 1 8 '&Selector:' 912 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 60 0 0 0 30 0 0 0] 8 #() 784 nil 27 802 834 #fixedParentLeft 11 834 #fixedViewLeft 111 834 #fixedParentTop 21 896 41 18 #{UI.ComboBox} 50 17 nil 272 50 2 8 1144063491 1025 1248 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 496 nil 5 nil nil nil 1248 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 546 50 1 594 #createAt:extent: 50 2 210 141 69 210 191 47 1248 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 34 0 0 0 165 0 0 0 57 0 0 0] 8 #() 784 nil 27 802 848 21 1216 191 880 -3 896 41 18 #{UI.StaticText} 50 16 nil 272 50 2 8 1140850944 1 1632 nil nil nil 5 nil nil nil 1632 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 210 11 73 210 111 31 1632 594 #text: 50 1 8 'Scope:' 1632 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 36 0 0 0 60 0 0 0 51 0 0 0] 8 #() 784 nil 27 802 1200 11 1216 111 834 #fixedPreviousBottom 17 896 31 18 #{UI.Scintilla.ScintillaView} 50 56 nil 272 50 2 8 1174409476 65 1936 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 1936 nil nil 514 nil nil 11 #focusLost nil nil nil nil 550 #{Core.IdentityDictionary} 4 #callTip 3142 1 #{UI.Scintilla.CallTipStyle} 77 482 #tooltipText 482 #tooltip 1 nil nil nil nil #callTip nil nil nil #indentGuide 3142 1 #{UI.Scintilla.TextStyle} 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 2178 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 2178 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #normal 2082 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} nil nil nil nil 1936 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 nil nil nil 2354 3 1 482 #windowText 3 482 #window 81 2400 nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil nil nil nil nil nil 1 2082 0 nil nil nil nil #{Core.Utf8String} nil nil 262 #{UI.Scintilla.CharacterClassifications} 8 #[0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 2 3 3 3 3 3 3 3 3 3 3 3 3 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 2 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2] nil 2082 3 #Error 2178 1027 482 #firebrick 482 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 2178 1031 nil 482 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 2178 1029 482 #darkGoldenrod 482 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 546 50 6 594 #createAt:extent: 50 2 210 341 73 210 359 95 1936 594 #wordWrap: 8 #(true) 1936 594 #margins: 50 1 50 5 2118 3 #{UI.Scintilla.Margin} 1 1936 nil 3 nil nil nil nil 2850 3 1936 33 nil nil 67108863 nil nil 2850 5 1936 nil nil nil nil nil nil 2850 7 1936 nil nil nil nil nil nil 2850 9 1936 nil nil nil nil nil nil 1936 594 #sciSetHScrollBar: 8 #(false) 1936 594 #targetRange: 50 1 774 #{Core.Interval} 3 1 3 1936 594 #maxCompletionListHeight: 8 #(9) 1936 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 170 0 0 0 36 0 0 0 93 1 0 0 83 0 0 0] 8 #() 784 nil 45 802 848 11 864 -9 880 5 834 #fixedParentBottom -3 370 2080 50 6 1248 8 'scope' 1936 8 'scopeDescription' 416 8 'selector' nil 546 50 1 594 #createAt:extent: 50 2 210 21 17 210 709 171 272 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 108 1 0 0 93 0 0 0] 50 5 912 416 1632 1248 1936 784 nil 27 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 3376 nil nil nil 5 nil nil nil 3376 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_Refactoring_OK_Cancel_button_block nil 546 50 1 594 #createAt:extent: 50 2 210 21 463 210 709 65 3376 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 231 0 0 0 108 1 0 0 7 1 0 0] 8 #() 784 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 3616 nil nil nil 5 nil nil nil 3616 242 1 1 18 #{UI.Toolbar} 50 28 nil 3616 50 2 8 1140853612 131073 3696 nil nil nil 517 nil nil nil 3696 496 nil 370 2080 3600 nil nil nil nil 50 4 1094 1 #{UI.ToolbarIconButton} 3696 1 1350 4 #{UI.CommandDescription} #moveFirst 8 'Move First' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $⏮ 8 'Georgia' nil 482 #menuHilight nil nil 3 nil nil nil 3794 3696 1 3826 #moveUp 8 'Move Up' 1 1 3874 8 $▲ 8 'Segoe UI' nil 3936 nil nil 1 nil nil nil 3794 3696 1 3826 #moveDown 8 'Move Down' 1 1 3874 8 $▼ nil nil 3936 nil nil 1 nil nil nil 3794 3696 1 3826 #moveLast 8 'Move Last' 1 1 3874 8 $⏭ 8 'Georgia' nil 3936 nil nil 3 nil nil nil nil nil 1 nil 210 33 33 nil nil nil 546 50 1 594 #createAt:extent: 50 2 210 1 1 210 709 51 3696 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 8 #() 784 nil 29 nil nil nil 18 #{UI.ListView} 50 45 nil 3616 50 2 8 1140970061 1025 4384 1314 1346 0 nil 1392 496 nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 3826 #moveFirst 8 'Move to &First' 1 1 nil nil nil 4530 1 3826 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 4530 1 3826 #moveDown 8 'Move to &Next' 1 1 nil nil nil 4530 1 3826 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 4384 nil nil 1424 nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 1346 1 3142 5 #{UI.ListViewColumn} 8 '' 701 #left 1424 1410 #<= 8 #() nil nil 4384 nil 3 nil nil #report 1456 nil 133121 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 546 50 1 594 #createAt:extent: 50 2 210 1 51 210 709 217 4384 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 98 1 0 0 133 0 0 0] 8 #() 784 nil 35 370 2080 50 2 4384 8 'list' 518 #{Graphics.Rectangle} 210 1 1 210 1 11 546 50 1 594 #createAt:extent: 50 2 210 21 187 210 709 277 3616 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 93 0 0 0 108 1 0 0 231 0 0 0] 50 2 3696 4384 784 nil 27 370 2080 50 2 3616 8 'parameters' 5074 210 21 17 210 21 17 nil nil nil nil 1 nil nil nil 210 481 411 1 nil nil 774 #{Core.Semaphore} nil nil 1 false nil 546 50 2 594 #createAt:extent: 50 2 210 6143 21 210 781 621 32 594 #text: 50 1 8 'Rename Method…' 32 722 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 133 13 0 0 64 1 0 0] 50 3 272 3616 3376 784 nil 27)! !
!Tools.RenameMethodDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

