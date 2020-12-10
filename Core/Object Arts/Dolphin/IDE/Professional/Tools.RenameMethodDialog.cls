"Filed out from Dolphin Smalltalk 7"!

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

isValid
	^super isValid and: 
			[| renamed |
			renamed := self model value.
			renamed hasNewSignature and: 
					[renamed selector = renamed originalSelector 
						or: [allowExistingSelector or: [(renamed methodClass includesSelector: renamed selector) not]]]]!

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
!Tools.RenameMethodDialog categoriesFor: #allowExistingSelector:!accessing!public! !
!Tools.RenameMethodDialog categoriesFor: #createComponents!initializing!public! !
!Tools.RenameMethodDialog categoriesFor: #createSchematicWiring!public! !
!Tools.RenameMethodDialog categoriesFor: #initialize!initializing!private! !
!Tools.RenameMethodDialog categoriesFor: #isValid!private!testing! !
!Tools.RenameMethodDialog categoriesFor: #model:!accessing!public! !
!Tools.RenameMethodDialog categoriesFor: #onScopeChange!public! !

!Tools.RenameMethodDialog class methodsFor!

defaultModel
	^Refactory.Browser.RBScopedMethodName new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 133 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1048838 ##(UI.FramingLayout) 170 176 34 8 410 ##(UI.StaticText) 34 16 nil 640 34 2 8 1140850944 1 768 nil nil nil 7 nil nil nil 768 nil 8 1801195232 1049094 ##(UI.NullConverter) nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 11 21 578 111 41 768 946 #text: 34 1 8 '&Selector:' 768 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 60 0 0 0 30 0 0 0] 8 #() 578 193 193 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 11 1186 #fixedViewLeft 111 1186 #fixedParentTop 21 1186 #fixedViewTop 41 410 ##(UI.ComboBox) 34 17 nil 640 34 2 8 1144063491 1025 1264 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1264 nil 8 1801138208 ##(UI.BasicListAbstract) 8 #() 401 882 138 144 34 1 946 #createAt:extent: 34 2 578 141 71 578 301 47 1264 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 35 0 0 0 220 0 0 0 58 0 0 0] 8 #() 1136 nil 27 1154 1186 #fixedPreviousRight 21 1216 301 1186 #fixedPreviousTop -5 1248 45 410 ##(UI.TextEdit) 34 16 nil 640 34 2 8 1140916352 1025 1696 nil 1440 nil 7 nil nil nil 1696 nil 8 1801338832 850 nil nil 1 882 138 144 34 2 946 #createAt:extent: 34 2 578 141 13 578 567 45 1696 946 #setMarginWidths: 34 1 8 #(3 3) 1696 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 8 #() 1136 nil 27 1154 1664 21 1186 #fixedParentRight -1 1680 -7 1248 45 410 ##(UI.StaticText) 34 16 nil 640 34 2 8 1140850944 1 2032 nil nil nil 7 nil nil nil 2032 nil 8 1801195232 850 nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 578 11 77 578 111 31 2032 946 #text: 34 1 8 'Scope:' 2032 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 38 0 0 0 60 0 0 0 53 0 0 0] 8 #() 1136 nil 27 1154 1200 11 1216 111 1186 #fixedPreviousBottom 21 1248 31 170 192 34 4 1264 8 'scope' 1696 8 'selector' nil 882 138 144 34 1 946 #createAt:extent: 34 2 578 21 17 578 709 131 640 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 108 1 0 0 73 0 0 0] 34 4 768 1696 2032 1264 1136 nil 27 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2592 nil nil nil 7 nil nil nil 2592 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 882 138 144 34 1 946 #createAt:extent: 34 2 578 21 399 578 709 65 2592 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 199 0 0 0 108 1 0 0 231 0 0 0] 1376 1136 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2832 nil nil nil 7 nil nil nil 2832 610 1 1 410 ##(UI.Toolbar) 34 25 nil 2832 34 2 8 1140853612 131073 2912 nil nil nil 519 nil nil nil 2912 1440 8 1801306032 170 192 1376 170 192 34 8 51939 1311814 1 ##(UI.ToolbarIconButton) 2912 1 1377606 4 ##(UI.CommandDescription) #moveDown 8 'Move Down' 1 1 1378630 1 ##(Graphics.TextTileIcon) $\x25BC nil nil 1426 #menuHilight nil nil 1 nil nil 51939 51937 3042 2912 1 3074 #moveUp 8 'Move Up' 1 1 3122 $\x25B2 8 'Segoe UI' nil 3152 nil nil 1 nil nil 51937 51935 3042 2912 1 3074 #moveFirst 8 'Move First' 1 1 3122 $\x23EE 8 'Georgia' nil 3152 nil nil 3 nil nil 51935 51941 3042 2912 1 3074 #moveLast 8 'Move Last' 1 1 3122 $\x23ED 8 'Georgia' nil 3152 nil nil 3 nil nil 51941 34 4 3248 3168 3056 3328 nil nil 1 nil 578 33 33 nil nil nil 882 138 144 34 1 946 #createAt:extent: 34 2 578 1 1 578 709 51 2912 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 8 #() 1136 nil 27 nil nil nil 410 ##(UI.ListView) 34 45 nil 2832 34 2 8 1140970061 1025 3600 1330 138 144 1376 nil 1408 1440 nil 7 461638 4 ##(UI.Menu) nil true 34 4 1180742 2 ##(UI.CommandMenuItem) 1 3074 #moveFirst 8 'Move to &First' 1 1 nil nil nil 3746 1 3074 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3746 1 3074 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3746 1 3074 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3600 nil 8 1801282304 ##(UI.BasicListAbstract) nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 '' 701 #left ##(UI.BasicListAbstract) 786950 ##(Core.Message) #<= 8 #() nil nil 3600 nil 3 nil nil #report 1472 nil 133121 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 578 1 51 578 709 193 3600 946 #contextMenu: 34 1 3712 3600 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 98 1 0 0 121 0 0 0] 8 #() 1136 nil 35 170 192 34 2 3600 8 'list' 1180166 ##(Graphics.Rectangle) 578 1 1 578 1 11 882 138 144 34 1 946 #createAt:extent: 34 2 578 21 147 578 709 253 2832 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 73 0 0 0 108 1 0 0 199 0 0 0] 34 2 2912 3600 1136 nil 27 170 192 34 2 2832 8 'parameters' 4386 578 21 17 578 21 21 nil nil nil nil 29211 nil nil nil 578 481 411 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 1996777232 882 138 144 34 2 946 #createAt:extent: 34 2 578 6143 21 578 781 561 416 946 #text: 34 1 8 'Rename Method...' 416 1074 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 133 13 0 0 34 1 0 0] 34 3 640 2832 2592 1136 nil 27 )! !
!Tools.RenameMethodDialog class categoriesFor: #defaultModel!models!public! !
!Tools.RenameMethodDialog class categoriesFor: #resource_Default_view!public!resources-views! !

