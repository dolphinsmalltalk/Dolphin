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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 10 18 #{UI.TextEdit} 50 20 nil 240 50 2 8 1140916352 1025 384 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 384 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 193 416 nil 384 562 #setMarginWidths: 50 1 8 #(3 3) 384 3 8 #() 518 #{Graphics.Point} 193 193 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 21 818 #fixedParentRight -1 818 #fixedPreviousTop -7 818 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 240 50 2 8 1140850944 1 896 nil nil nil 5 nil nil nil 896 nil nil 482 nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[5 0 0 0 10 0 0 0 60 0 0 0 30 0 0 0] 193 928 nil 896 562 #text: 50 1 8 '&Selector:' 896 3 8 #() 754 193 193 nil 27 786 818 #fixedParentLeft 11 818 #fixedViewLeft 111 818 #fixedParentTop 21 880 41 18 #{UI.ComboBox} 50 17 nil 240 50 2 8 1144063491 1025 1232 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 464 nil 5 nil nil nil 1232 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 514 50 1 562 #createWindow: 50 1 610 642 8 #[70 0 0 0 34 0 0 0 165 0 0 0 1 1 0 0] 193 1264 8 '' 1232 3 8 #() 754 193 193 nil 27 786 832 21 1200 191 864 -3 880 41 18 #{UI.StaticText} 50 16 nil 240 50 2 8 1140850944 1 1632 nil nil nil 5 nil nil nil 1632 nil nil 482 nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[5 0 0 0 36 0 0 0 60 0 0 0 51 0 0 0] 193 1664 nil 1632 562 #text: 50 1 8 'Scope:' 1632 3 8 #() 754 193 193 nil 27 786 1184 11 1200 111 818 #fixedPreviousBottom 17 880 31 18 #{UI.Scintilla.ScintillaView} 50 56 nil 240 50 2 8 1174409476 65 1936 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 1936 nil nil 482 nil nil 11 #focusLost nil nil nil nil 550 #{Core.IdentityDictionary} 4 #callTip 3142 1 #{UI.Scintilla.CallTipStyle} 77 450 #tooltipText 450 #tooltip 1 nil nil nil nil #callTip nil nil nil #indentGuide 3142 1 #{UI.Scintilla.TextStyle} 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 2178 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 2178 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #normal 2082 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} nil nil nil nil 1936 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 nil nil nil 2354 3 1 450 #windowText 3 450 #window 81 2400 nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil nil nil nil nil nil 1 2082 0 nil nil nil nil #{Core.Utf8String} nil nil 262 #{UI.Scintilla.CharacterClassifications} 8 #[0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 2 3 3 3 3 3 3 3 3 3 3 3 3 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 2 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2] nil 2082 3 #Error 2178 1027 450 #firebrick 450 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 2178 1031 nil 450 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 2178 1029 450 #darkGoldenrod 450 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 514 50 6 562 #createWindow: 50 1 610 642 8 #[170 0 0 0 36 0 0 0 93 1 0 0 83 0 0 0] 193 1968 nil 1936 562 #wordWrap: 8 #(true) 1936 562 #margins: 50 1 50 5 2118 3 #{UI.Scintilla.Margin} 1 1936 nil 3 nil nil nil nil 2866 3 1936 33 nil nil 67108863 nil nil 2866 5 1936 nil nil nil nil nil nil 2866 7 1936 nil nil nil nil nil nil 2866 9 1936 nil nil nil nil nil nil 1936 562 #sciSetHScrollBar: 8 #(false) 1936 562 #targetRange: 50 1 774 #{Core.Interval} 3 1 3 1936 562 #maxCompletionListHeight: 8 #(9) 1936 3 8 #() 754 193 193 nil 45 786 832 11 848 -9 864 5 818 #fixedParentBottom -3 338 2080 50 6 1232 8 'scope' 1936 8 'scopeDescription' 384 8 'selector' nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[10 0 0 0 8 0 0 0 108 1 0 0 93 0 0 0] 193 272 8 '' 240 3 50 5 896 384 1632 1232 1936 754 193 193 nil 27 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 3392 nil nil nil 5 nil nil nil 3392 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_Refactoring_OK_Cancel_button_block nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[10 0 0 0 231 0 0 0 108 1 0 0 7 1 0 0] 193 3424 8 '' 3392 3 8 #() 754 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 3648 nil nil nil 5 nil nil nil 3648 210 1 1 18 #{UI.Toolbar} 50 28 nil 3648 50 2 8 1140853612 131073 3728 nil nil nil 517 nil nil nil 3728 464 nil 338 2080 3616 nil nil nil nil 50 4 1606 2 #{UI.ToolbarIconButton} 3728 1 1350 4 #{UI.CommandDescription} #moveFirst 8 'Move First' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $⏮ 8 'Georgia' nil 450 #menuHilight nil nil 3 nil nil nil nil nil 3826 3728 1 3858 #moveUp 8 'Move Up' 1 1 3906 8 $▲ 8 'Segoe UI' nil 3968 nil nil 1 nil nil nil nil nil 3826 3728 1 3858 #moveDown 8 'Move Down' 1 1 3906 8 $▼ nil nil 3968 nil nil 1 nil nil nil nil nil 3826 3728 1 3858 #moveLast 8 'Move Last' 1 1 3906 8 $⏭ 8 'Georgia' nil 3968 nil nil 3 nil nil nil nil nil nil nil 9 1 #smallIcons nil nil nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 193 3760 8 '' 3728 3 8 #() 754 193 193 nil 31 nil nil nil 18 #{UI.ListView} 50 45 nil 3648 50 2 8 1140970061 1025 4416 1298 1330 0 nil 1376 464 nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 3858 #moveFirst 8 'Move to &First' 1 1 nil nil nil 4562 1 3858 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 4562 1 3858 #moveDown 8 'Move to &Next' 1 1 nil nil nil 4562 1 3858 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 4416 nil nil 1408 nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 1330 1 3142 5 #{UI.ListViewColumn} 8 '' 701 #left 1408 1394 #<= 8 #() nil nil 4416 nil 3 nil nil #report 1440 nil 133121 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 4416 nil nil nil nil nil nil nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 25 0 0 0 98 1 0 0 133 0 0 0] 193 4448 8 '' 4416 562 #contextMenu: 50 1 4528 4416 3 8 #() 754 193 193 nil 35 338 2080 50 2 4416 8 'list' 518 #{Graphics.Rectangle} 754 1 1 754 1 11 514 50 1 562 #createWindow: 50 1 610 642 8 #[10 0 0 0 93 0 0 0 108 1 0 0 231 0 0 0] 193 3680 8 '' 3648 3 50 2 3728 4416 754 193 193 nil 27 338 2080 50 2 3648 8 'parameters' 5186 754 21 17 754 21 17 nil nil nil nil 1 nil nil nil 754 481 411 nil nil 193 774 #{Core.Semaphore} nil nil 1 false nil nil nil nil nil 514 50 2 562 #createWindow: 50 1 518 #{UI.CreateDialog} 5186 754 7679 21 754 8459 641 193 32 562 #setWindowText: 50 1 8 'Rename Method…' 32 1 50 3 240 3648 3392 754 193 193 nil 29)! !

!Tools.RenameMethodDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

