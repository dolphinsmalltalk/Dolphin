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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 167 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1048838 ##(UI.FramingLayout) 170 176 34 8 410 ##(UI.StaticText) 34 16 nil 640 34 2 8 1140850944 1 768 nil nil nil 7 nil nil nil 768 nil 8 1812122528 1049094 ##(UI.NullConverter) nil nil nil 1310982 ##(Core.MessageSequence) 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 11 77 578 111 31 768 930 #text: 34 1 8 'Scope:' 768 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 38 0 0 0 60 0 0 0 53 0 0 0] 8 #() 578 193 193 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 11 1170 #fixedViewLeft 111 1170 #fixedPreviousBottom 21 1170 #fixedViewTop 31 410 ##(UI.TextEdit) 34 16 nil 640 34 2 8 1140916352 1025 1248 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1248 nil 8 1812078336 850 nil nil 5 882 34 2 930 #createAt:extent: 34 2 578 141 13 578 567 45 1248 930 #setMarginWidths: 34 1 8 #(3 3) 1248 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 8 #() 1120 nil 27 1138 1170 #fixedPreviousRight 21 1170 #fixedParentRight -1 1170 #fixedPreviousTop -7 1232 45 410 ##(UI.StaticText) 34 16 nil 640 34 2 8 1140850944 1 1632 nil nil nil 7 nil nil nil 1632 nil 8 1812122528 850 nil nil nil 882 34 2 930 #createAt:extent: 34 2 578 11 21 578 111 41 1632 930 #text: 34 1 8 '&Selector:' 1632 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 60 0 0 0 30 0 0 0] 8 #() 1120 nil 27 1138 1184 11 1200 111 1170 #fixedParentTop 21 1232 41 410 ##(UI.ComboBox) 34 17 nil 640 34 2 8 1144063491 1025 1952 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) 1328 nil 7 nil nil nil 1952 nil 8 1811632336 ##(UI.BasicListAbstract) 8 #() 401 882 34 1 930 #createAt:extent: 34 2 578 141 71 578 301 47 1952 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 35 0 0 0 220 0 0 0 58 0 0 0] 8 #() 1120 nil 27 1138 1584 21 1200 301 1616 -5 1232 45 170 192 34 4 1952 8 'scope' 1248 8 'selector' nil 882 34 1 930 #createAt:extent: 34 2 578 21 17 578 709 131 640 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 108 1 0 0 73 0 0 0] 34 4 1632 1248 768 1952 1120 nil 27 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2512 nil nil nil 7 nil nil nil 2512 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 882 34 1 930 #createAt:extent: 34 2 578 21 399 578 709 65 2512 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 199 0 0 0 108 1 0 0 231 0 0 0] 2064 1120 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2736 nil nil nil 7 nil nil nil 2736 610 1 1 410 ##(UI.Toolbar) 34 28 nil 2736 34 2 8 1140853612 131073 2816 nil nil nil 519 nil nil nil 2816 1328 8 1812060400 170 192 2064 nil nil nil 170 192 34 8 36457 1311814 1 ##(UI.ToolbarIconButton) 2816 1 1377606 4 ##(UI.CommandDescription) #moveUp 8 'Move Up' 1 1 1378630 2 ##(Graphics.TextTileIcon) $\x25B2 8 'Segoe UI' nil 1314 #menuHilight nil nil 1 nil nil 36457 36455 2946 2816 1 2978 #moveFirst 8 'Move First' 1 1 3026 $\x23EE 8 'Georgia' nil 3072 nil nil 3 nil nil 36455 36461 2946 2816 1 2978 #moveLast 8 'Move Last' 1 1 3026 $\x23ED 8 'Georgia' nil 3072 nil nil 3 nil nil 36461 36459 2946 2816 1 2978 #moveDown 8 'Move Down' 1 1 3026 $\x25BC nil nil 3072 nil nil 1 nil nil 36459 34 4 3088 2960 3248 3168 nil nil 1 nil 578 33 33 nil nil nil 882 34 1 930 #createAt:extent: 34 2 578 1 1 578 709 51 2816 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 8 #() 1120 nil 29 nil nil nil 410 ##(UI.ListView) 34 45 nil 2736 34 2 8 1140970061 1025 3488 2018 138 144 2064 nil 2096 1328 nil 7 461638 4 ##(UI.Menu) nil true 34 4 1180742 2 ##(UI.CommandMenuItem) 1 2978 #moveFirst 8 'Move to &First' 1 1 nil nil nil 3634 1 2978 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3634 1 2978 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3634 1 2978 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3488 nil 8 1812034736 ##(UI.BasicListAbstract) nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 '' 701 #left ##(UI.BasicListAbstract) 786950 ##(Core.Message) #<= 8 #() nil nil 3488 nil 3 nil nil #report 2128 nil 133121 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 34 2 930 #createAt:extent: 34 2 578 1 51 578 709 193 3488 930 #contextMenu: 34 1 3600 3488 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 98 1 0 0 121 0 0 0] 8 #() 1120 nil 35 170 192 34 2 3488 8 'list' 1180166 ##(Graphics.Rectangle) 578 1 1 578 1 11 882 34 1 930 #createAt:extent: 34 2 578 21 147 578 709 253 2736 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 73 0 0 0 108 1 0 0 199 0 0 0] 34 2 2816 3488 1120 nil 27 170 192 34 2 2736 8 'parameters' 4258 578 21 17 578 21 21 nil nil nil nil 16747 nil nil nil 578 481 411 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 1999993616 882 34 2 930 #createAt:extent: 34 2 578 12287 21 578 781 561 416 930 #text: 34 1 8 'Rename Method…' 416 1058 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 133 25 0 0 34 1 0 0] 34 3 640 2736 2512 1120 nil 27 )! !
!Tools.RenameMethodDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

