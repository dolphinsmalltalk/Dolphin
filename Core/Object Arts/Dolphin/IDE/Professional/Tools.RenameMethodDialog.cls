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

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	scopePresenter 
		when: #valueChanged
		send: #onScopeChange
		to: self!

initialize
	"Private - Initialize the receiver"

	super initialize.
	allowExistingSelector := false!

model: anObject
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: anObject.
	aspectBuffer := self model.
	scopePresenter viewModel searchPolicy: SearchPolicy identity.
	scopePresenter choices: anObject scopeNames.
	scopePresenter model: (aspectBuffer aspectValue: #scope)!

onScopeChange
	scopeDescriptionPresenter value: scopePresenter value defaultLabel! !
!Tools.RenameMethodDialog categoriesForMethods!
allowExistingSelector:!accessing!public! !
conditionsFor:!accessing!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
initialize!initializing!private! !
model:!accessing!public! !
onScopeChange!event handling!public! !
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(12845056 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1048838 #{UI.FramingLayout} 170 176 34 8 410 #{UI.StaticText} 34 16 nil 640 34 2 8 1140850944 1 768 nil nil nil 7 nil nil nil 768 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 11 77 578 111 31 768 930 #text: 34 1 8 'Scope:' 768 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 38 0 0 0 60 0 0 0 53 0 0 0] 8 #() 578 193 193 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 11 1170 #fixedViewLeft 111 1170 #fixedPreviousBottom 21 1170 #fixedViewTop 31 410 #{UI.StaticText} 34 16 nil 640 34 2 8 1140850944 1 1248 nil nil nil 7 nil nil nil 1248 nil 8 1815137184 850 nil nil nil 882 34 2 930 #createAt:extent: 34 2 578 11 21 578 111 41 1248 930 #text: 34 1 8 '&Selector:' 1248 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 60 0 0 0 30 0 0 0] 8 #() 1120 nil 27 1138 1184 11 1200 111 1170 #fixedParentTop 21 1232 41 410 #{UI.ComboBox} 34 17 nil 640 34 2 8 1144063491 1025 1568 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 7 nil nil nil 1568 nil 8 1814646992 786950 #{Core.Message} #displayString 1680 8 #() 401 882 34 1 930 #createAt:extent: 34 2 578 141 71 578 301 47 1568 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 35 0 0 0 220 0 0 0 58 0 0 0] 8 #() 1120 nil 27 1138 1170 #fixedPreviousRight 21 1200 301 1170 #fixedPreviousTop -5 1232 45 410 #{UI.TextEdit} 34 16 nil 640 34 2 8 1140916352 1025 2016 nil 1744 nil 7 nil nil nil 2016 nil 8 1815092992 850 nil nil 5 882 34 2 930 #createAt:extent: 34 2 578 141 13 578 567 45 2016 930 #setMarginWidths: 34 1 8 #(3 3) 2016 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 8 #() 1120 nil 27 1138 1984 21 1170 #fixedParentRight -1 2000 -7 1232 45 170 192 34 4 1568 8 'scope' 2016 8 'selector' nil 882 34 1 930 #createAt:extent: 34 2 578 21 17 578 709 131 640 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 108 1 0 0 73 0 0 0] 34 4 1248 2016 768 1568 1120 nil 27 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 2544 nil nil nil 7 nil nil nil 2544 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 882 34 1 930 #createAt:extent: 34 2 578 21 399 578 709 65 2544 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 199 0 0 0 108 1 0 0 231 0 0 0] 1680 1120 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 2768 nil nil nil 7 nil nil nil 2768 610 1 1 410 #{UI.Toolbar} 34 28 nil 2768 34 2 8 1140853612 131073 2848 nil nil nil 519 nil nil nil 2848 1744 8 1815075056 170 192 1680 nil nil nil 170 192 34 8 54837 1311814 1 #{UI.ToolbarIconButton} 2848 1 1377606 4 #{UI.CommandDescription} #moveLast 8 'Move Last' 1 1 1378630 2 #{Graphics.TextTileIcon} $\x23ED 8 'Georgia' nil 1730 #menuHilight nil nil 3 nil nil 54837 54835 2978 2848 1 3010 #moveDown 8 'Move Down' 1 1 3058 $\x25BC nil nil 3104 nil nil 1 nil nil 54835 54833 2978 2848 1 3010 #moveUp 8 'Move Up' 1 1 3058 $\x25B2 8 'Segoe UI' nil 3104 nil nil 1 nil nil 54833 54831 2978 2848 1 3010 #moveFirst 8 'Move First' 1 1 3058 $\x23EE 8 'Georgia' nil 3104 nil nil 3 nil nil 54831 34 4 3264 3184 3120 2992 nil nil 1 nil 578 33 33 nil nil nil 882 34 1 930 #createAt:extent: 34 2 578 1 1 578 709 51 2848 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 8 #() 1120 nil 29 nil nil nil 410 #{UI.ListView} 34 45 nil 2768 34 2 8 1140970061 1025 3520 1634 138 144 1680 nil 1712 1744 nil 7 461638 4 #{UI.Menu} nil true 34 4 1180742 2 #{UI.CommandMenuItem} 1 3010 #moveFirst 8 'Move to &First' 1 1 nil nil nil 3666 1 3010 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3666 1 3010 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3666 1 3010 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3520 nil 8 1815049392 1792 nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 '' 701 #left 1792 1778 #<= 8 #() nil nil 3520 nil 3 nil nil #report 1808 nil 133121 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 34 2 930 #createAt:extent: 34 2 578 1 51 578 709 193 3520 930 #contextMenu: 34 1 3632 3520 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 98 1 0 0 121 0 0 0] 8 #() 1120 nil 35 170 192 34 2 3520 8 'list' 1180166 #{Graphics.Rectangle} 578 1 1 578 1 11 882 34 1 930 #createAt:extent: 34 2 578 21 147 578 709 253 2768 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 73 0 0 0 108 1 0 0 199 0 0 0] 34 2 2848 3520 1120 nil 27 170 192 34 2 2768 8 'parameters' 4274 578 21 17 578 21 21 nil nil nil nil 36625 nil nil nil 578 481 411 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 882 34 2 930 #createAt:extent: 34 2 578 12287 21 578 781 561 416 930 #text: 34 1 8 'Rename Method…' 416 1058 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 133 25 0 0 34 1 0 0] 34 3 640 2768 2544 1120 nil 27)! !
!Tools.RenameMethodDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

