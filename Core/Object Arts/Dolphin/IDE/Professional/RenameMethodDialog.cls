"Filed out from Dolphin Smalltalk"!

MethodNameDialog subclass: #RenameMethodDialog
	instanceVariableNames: 'scopePresenter scopeDescriptionPresenter allowExistingSelector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RenameMethodDialog guid: (GUID fromString: '{d123996c-3d35-47b6-a418-da4086501e0e}')!

RenameMethodDialog comment: '
Instance Variables:
	scopePresenter				<ChoicePresenter>
	scopeDescriptionPresenter	<TextPresenter>
	allowExistingSelector			<boolean>

'!

!RenameMethodDialog categoriesForClass!MVP-Presenters!MVP-Resources-Dialogs! !

!RenameMethodDialog methodsFor!

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

!RenameMethodDialog categoriesForMethods!
allowExistingSelector:!accessing!public! !
createComponents!initializing!public! !
createSchematicWiring!public! !
initialize!initializing!private! !
isValid!private!testing! !
model:!accessing!public! !
onScopeChange!public! !
!

!RenameMethodDialog class methodsFor!

defaultModel
	^RBScopedMethodName new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(12845056 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 608 nil nil nil 7 nil nil nil 608 852230 ##(Smalltalk.FramingLayout) 170 176 34 8 410 ##(Smalltalk.ComboBox) 34 17 nil 608 34 2 8 1144063491 1025 736 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 736 nil 8 1795317024 ##(Smalltalk.BasicListAbstract) 8 #() 401 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[70 0 0 0 35 0 0 0 220 0 0 0 3 1 0 0] 193 768 8 '' 736 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 21 1250 #fixedViewLeft 301 1250 #fixedPreviousTop -5 1250 #fixedViewTop 45 410 ##(Smalltalk.TextEdit) 34 16 nil 608 34 2 8 1140916352 1025 1328 nil 912 nil 7 nil nil nil 1328 nil 8 1795700448 852486 ##(Smalltalk.NullConverter) nil nil 1 962 138 144 34 2 1026 #createWindow: 34 1 1074 1106 8 #[70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 193 1360 nil 1328 1026 #setMarginWidths: 34 1 8 #(3 3) 1328 3 8 #() 1186 193 193 nil 27 1218 1264 21 1250 #fixedParentRight -1 1296 -7 1312 45 410 ##(Smalltalk.StaticText) 34 16 nil 608 34 2 8 1140850944 1 1680 nil nil nil 7 nil nil nil 1680 nil 8 1795912768 1410 nil nil nil 962 138 144 34 2 1026 #createWindow: 34 1 1074 1106 8 #[5 0 0 0 38 0 0 0 60 0 0 0 53 0 0 0] 193 1712 nil 1680 1026 #text: 34 1 8 'Scope:' 1680 3 8 #() 1186 193 193 nil 27 1218 1250 #fixedParentLeft 11 1280 111 1250 #fixedPreviousBottom 21 1312 31 410 ##(Smalltalk.StaticText) 34 16 nil 608 34 2 8 1140850944 1 2032 nil nil nil 7 nil nil nil 2032 nil 8 1795912768 1410 nil nil nil 962 138 144 34 2 1026 #createWindow: 34 1 1074 1106 8 #[5 0 0 0 10 0 0 0 60 0 0 0 30 0 0 0] 193 2064 nil 2032 1026 #text: 34 1 8 '&Selector:' 2032 3 8 #() 1186 193 193 nil 27 1218 2000 11 1280 111 1250 #fixedParentTop 21 1312 41 170 192 34 4 736 8 'scope' 1328 8 'selector' nil 962 138 144 34 1 1026 #createWindow: 34 1 1074 1106 8 #[10 0 0 0 8 0 0 0 108 1 0 0 73 0 0 0] 193 640 8 '' 608 3 34 4 2032 1328 1680 736 1186 193 193 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2608 nil nil nil 7 nil nil nil 2608 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 962 138 144 34 1 1026 #createWindow: 34 1 1074 1106 8 #[10 0 0 0 199 0 0 0 108 1 0 0 231 0 0 0] 193 2640 8 '' 2608 3 848 1186 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2864 nil nil nil 7 nil nil nil 2864 578 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 2864 34 2 8 1140853612 131073 2944 nil nil nil 519 nil nil nil 2944 912 8 1795812352 170 192 848 nil nil nil 170 192 34 8 9223 1115718 2 ##(Smalltalk.ToolbarIconButton) 2944 1 1180998 4 ##(Smalltalk.CommandDescription) #moveLast 8 'Move Last' 1 1 788806 2 ##(Smalltalk.TextTileIcon) $⏭ 8 'Georgia' nil 898 #menuHilight nil nil 3 nil nil 9223 nil nil 9221 3074 2944 1 3106 #moveDown 8 'Move Down' 1 1 3154 $▼ nil nil 3200 nil nil 1 nil nil 9221 nil nil 9219 3074 2944 1 3106 #moveUp 8 'Move Up' 1 1 3154 $▲ 8 'Segoe UI' nil 3200 nil nil 1 nil nil 9219 nil nil 9217 3074 2944 1 3106 #moveFirst 8 'Move First' 1 1 3154 $⏮ 8 'Georgia' nil 3200 nil nil 3 nil nil 9217 nil nil 34 4 3360 3280 3216 3088 nil nil 9 1 #smallIcons nil nil nil 962 138 144 34 1 1026 #createWindow: 34 1 1074 1106 8 #[0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 193 2976 8 '' 2944 3 8 #() 1186 193 193 nil 31 nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 2864 34 2 8 1140970061 1025 3632 802 138 144 848 nil 880 912 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 3106 #moveFirst 8 'Move to &First' 1 1 nil nil nil 3778 1 3106 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3778 1 3106 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3778 1 3106 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3632 nil 8 1795768528 ##(Smalltalk.BasicListAbstract) nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 701 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() nil nil 3632 nil 3 nil nil #report 944 nil 133121 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 962 138 144 34 2 1026 #createWindow: 34 1 1074 1106 8 #[0 0 0 0 25 0 0 0 98 1 0 0 121 0 0 0] 193 3664 8 '' 3632 1026 #contextMenu: 34 1 3744 3632 3 8 #() 1186 193 193 nil 35 170 192 34 2 3632 8 'list' 590342 ##(Smalltalk.Rectangle) 1186 1 1 1186 1 11 962 138 144 34 1 1026 #createWindow: 34 1 1074 1106 8 #[10 0 0 0 73 0 0 0 108 1 0 0 199 0 0 0] 193 2896 8 '' 2864 3 34 2 2944 3632 1186 193 193 nil 27 170 192 34 2 2864 8 'parameters' 4434 1186 21 17 1186 21 21 nil nil nil nil 8653 nil nil nil 1186 481 411 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2001703808 nil nil nil nil 962 138 144 34 2 1026 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 4434 1186 6143 21 1186 6923 581 193 416 1026 #setWindowText: 34 1 8 'Rename Method...' 416 1 34 3 608 2864 2608 1186 193 193 nil 29 )! !

!RenameMethodDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

