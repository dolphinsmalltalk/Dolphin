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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 7 nil nil nil 272 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 5 18 #{UI.ComboBox} 50 17 nil 272 50 2 8 1144063491 1025 400 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 7 nil nil nil 400 nil 8 1852792128 518 #{Core.Message} #displayString 8 #() 8 #() 401 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 141 69 210 191 47 400 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 34 0 0 0 165 0 0 0 57 0 0 0] 8 #() 210 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 21 914 #fixedViewLeft 191 914 #fixedPreviousTop -3 914 #fixedViewTop 41 18 #{UI.Scintilla.ScintillaView} 50 56 nil 272 50 2 8 1174409476 65 992 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 7 nil nil nil 992 nil 8 1367644576 518 #{UI.NullConverter} nil nil 11 #focusLost nil nil nil nil 550 #{Core.IdentityDictionary} 4 #callTip 3142 1 #{UI.Scintilla.CallTipStyle} 77 562 #tooltipText 562 #tooltip 1 nil nil nil nil #callTip nil nil nil #indentGuide 3142 1 #{UI.Scintilla.TextStyle} 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 1266 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 1266 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #normal 1170 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} nil nil nil nil 992 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 370 0 nil nil nil 370 3 1 562 #windowText 3 562 #window 81 1472 nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil nil nil nil nil nil 1 1170 0 nil nil nil nil #{Core.Utf8String} nil nil 262 #{UI.Scintilla.CharacterClassifications} 8 #[0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 2 3 3 3 3 3 3 3 3 3 3 3 3 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 2 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2] nil 1170 3 #Error 1266 1027 562 #firebrick 562 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 1266 1031 nil 562 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 1266 1029 562 #darkGoldenrod 562 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 674 50 6 722 #createAt:extent: 50 2 210 341 73 210 359 95 992 722 #wordWrap: 8 #(true) 992 722 #margins: 50 1 50 5 2118 3 #{UI.Scintilla.Margin} 1 992 nil 3 nil nil nil nil 1922 3 992 33 nil nil 67108863 nil nil 1922 5 992 nil nil nil nil nil nil 1922 7 992 nil nil nil nil nil nil 1922 9 992 nil nil nil nil nil nil 992 722 #sciSetHScrollBar: 8 #(false) 992 722 #targetRange: 50 1 774 #{Core.Interval} 3 1 3 992 722 #maxCompletionListHeight: 8 #(9) 992 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 170 0 0 0 36 0 0 0 93 1 0 0 83 0 0 0] 8 #() 864 nil 45 882 928 11 914 #fixedParentRight -9 960 5 914 #fixedParentBottom -3 18 #{UI.StaticText} 50 16 nil 272 50 2 8 1140850944 1 2240 nil nil nil 7 nil nil nil 2240 nil 8 1853387904 1138 nil nil nil 674 50 2 722 #createAt:extent: 50 2 210 11 73 210 111 31 2240 722 #text: 50 1 8 'Scope:' 2240 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 36 0 0 0 60 0 0 0 51 0 0 0] 8 #() 864 nil 27 882 914 #fixedParentLeft 11 944 111 914 #fixedPreviousBottom 17 976 31 18 #{UI.StaticText} 50 16 nil 272 50 2 8 1140850944 1 2576 nil nil nil 7 nil nil nil 2576 nil 8 1853387904 1138 nil nil nil 674 50 2 722 #createAt:extent: 50 2 210 11 21 210 111 41 2576 722 #text: 50 1 8 '&Selector:' 2576 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 60 0 0 0 30 0 0 0] 8 #() 864 nil 27 882 2544 11 944 111 914 #fixedParentTop 21 976 41 18 #{UI.TextEdit} 50 20 nil 272 50 2 8 1140916352 1025 2896 nil 576 nil 7 nil nil nil 2896 nil 8 1853175488 1138 nil nil 1 #perChar nil nil nil 674 50 2 722 #createAt:extent: 50 2 210 141 13 210 567 45 2896 722 #setMarginWidths: 50 1 8 #(3 3) 2896 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 8 #() 864 nil 45 882 928 21 2208 -1 960 -7 976 45 1170 3 400 8 'scope' 992 8 'scopeDescription' 2896 8 'selector' nil 674 50 1 722 #createAt:extent: 50 2 210 21 17 210 709 171 272 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 108 1 0 0 93 0 0 0] 50 5 2576 2896 2240 400 992 864 nil 27 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 3408 nil nil nil 7 nil nil nil 3408 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_Refactoring_OK_Cancel_button_block nil 674 50 1 722 #createAt:extent: 50 2 210 21 463 210 709 65 3408 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 231 0 0 0 108 1 0 0 7 1 0 0] 8 #() 864 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 3648 nil nil nil 7 nil nil nil 3648 242 1 1 18 #{UI.Toolbar} 50 28 nil 3648 50 2 8 1140853612 131073 3728 nil nil nil 519 nil nil nil 3728 576 8 1853287488 1170 0 nil nil nil 1170 4 47843 1094 1 #{UI.ToolbarIconButton} 3728 1 1350 4 #{UI.CommandDescription} #moveFirst 8 'Move First' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $⏮ 8 'Georgia' nil 562 #menuHilight nil nil 3 nil nil 47843 47845 3842 3728 1 3874 #moveUp 8 'Move Up' 1 1 3922 8 $▲ 8 'Segoe UI' nil 3984 nil nil 1 nil nil 47845 47847 3842 3728 1 3874 #moveDown 8 'Move Down' 1 1 3922 8 $▼ nil nil 3984 nil nil 1 nil nil 47847 47849 3842 3728 1 3874 #moveLast 8 'Move Last' 1 1 3922 8 $⏭ 8 'Georgia' nil 3984 nil nil 3 nil nil 47849 50 4 3856 4000 4096 4176 nil nil 1 nil 210 33 33 nil nil nil 674 50 1 722 #createAt:extent: 50 2 210 1 1 210 709 51 3728 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 8 #() 864 nil 29 nil nil nil 18 #{UI.ListView} 50 45 nil 3648 50 2 8 1140970061 1025 4448 466 498 0 nil 544 576 nil 7 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 3874 #moveFirst 8 'Move to &First' 1 1 nil nil nil 4594 1 3874 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 4594 1 3874 #moveDown 8 'Move to &Next' 1 1 nil nil nil 4594 1 3874 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 4448 nil 8 1853243664 624 nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 498 1 3142 5 #{UI.ListViewColumn} 8 '' 701 #left 624 610 #<= 8 #() nil nil 4448 nil 3 nil nil #report 656 nil 133121 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 674 50 1 722 #createAt:extent: 50 2 210 1 51 210 709 217 4448 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 98 1 0 0 133 0 0 0] 8 #() 864 nil 35 1170 1 4448 8 'list' 518 #{Graphics.Rectangle} 210 1 1 210 1 11 674 50 1 722 #createAt:extent: 50 2 210 21 187 210 709 277 3648 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 93 0 0 0 108 1 0 0 231 0 0 0] 50 2 3728 4448 864 nil 27 1170 1 3648 8 'parameters' 5138 210 21 17 210 21 17 nil nil nil nil 13629 nil nil nil 210 481 411 1 nil nil 774 #{Core.Semaphore} nil nil 1 false 8 2011790800 674 50 2 722 #createAt:extent: 50 2 210 6143 21 210 781 621 32 722 #text: 50 1 8 'Rename Method…' 32 802 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 133 13 0 0 64 1 0 0] 50 3 272 3648 3408 864 nil 27)! !
!Tools.RenameMethodDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

