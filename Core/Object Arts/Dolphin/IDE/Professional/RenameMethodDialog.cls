"Filed out from Dolphin Smalltalk 7"!

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
!RenameMethodDialog categoriesFor: #allowExistingSelector:!accessing!public! !
!RenameMethodDialog categoriesFor: #createComponents!initializing!public! !
!RenameMethodDialog categoriesFor: #createSchematicWiring!public! !
!RenameMethodDialog categoriesFor: #initialize!initializing!private! !
!RenameMethodDialog categoriesFor: #isValid!private!testing! !
!RenameMethodDialog categoriesFor: #model:!accessing!public! !
!RenameMethodDialog categoriesFor: #onScopeChange!public! !

!RenameMethodDialog class methodsFor!

defaultModel
	^RBScopedMethodName new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 165 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 8 410 ##(Smalltalk.ComboBox) 34 17 nil 640 34 2 8 1144063491 1025 768 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 768 nil 8 1903738896 ##(Smalltalk.BasicListAbstract) 880 401 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 141 71 578 301 47 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 35 0 0 0 220 0 0 0 58 0 0 0] 8 #() 578 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 21 1234 #fixedViewLeft 301 1234 #fixedPreviousTop -5 1234 #fixedViewTop 45 410 ##(Smalltalk.StaticText) 34 16 nil 640 34 2 8 1140850944 1 1312 nil nil nil 7 nil nil nil 1312 nil 8 1903849936 852486 ##(Smalltalk.NullConverter) nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 578 11 77 578 111 31 1312 1042 #text: 34 1 8 'Scope:' 1312 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 38 0 0 0 60 0 0 0 53 0 0 0] 8 #() 1184 nil 27 1202 1234 #fixedParentLeft 11 1264 111 1234 #fixedPreviousBottom 21 1296 31 410 ##(Smalltalk.TextEdit) 34 16 nil 640 34 2 8 1140916352 1025 1680 nil 944 nil 7 nil nil nil 1680 nil 8 1903872368 1394 nil nil 1 978 138 144 34 2 1042 #createAt:extent: 34 2 578 141 13 578 567 45 1680 1042 #setMarginWidths: 34 1 8 #(3 3) 1680 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 8 #() 1184 nil 27 1202 1248 21 1234 #fixedParentRight -1 1280 -7 1296 45 410 ##(Smalltalk.StaticText) 34 16 nil 640 34 2 8 1140850944 1 2016 nil nil nil 7 nil nil nil 2016 nil 8 1903849936 1394 nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 578 11 21 578 111 41 2016 1042 #text: 34 1 8 '&Selector:' 2016 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 60 0 0 0 30 0 0 0] 8 #() 1184 nil 27 1202 1648 11 1264 111 1234 #fixedParentTop 21 1296 41 170 192 34 4 768 8 'scope' 1680 8 'selector' nil 978 138 144 34 1 1042 #createAt:extent: 34 2 578 21 17 578 709 131 640 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 108 1 0 0 73 0 0 0] 34 4 2016 1680 1312 768 1184 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2576 nil nil nil 7 nil nil nil 2576 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 978 138 144 34 1 1042 #createAt:extent: 34 2 578 21 399 578 709 65 2576 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 199 0 0 0 108 1 0 0 231 0 0 0] 880 1184 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2816 nil nil nil 7 nil nil nil 2816 610 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 2816 34 2 8 1140853612 131073 2896 nil nil nil 519 nil nil nil 2896 944 8 1903898080 170 192 880 170 192 34 8 50161 1115206 1 ##(Smalltalk.ToolbarIconButton) 2896 1 1180998 4 ##(Smalltalk.CommandDescription) #moveLast 8 'Move Last' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $\x23ED 8 'Georgia' nil 930 #menuHilight nil nil 3 nil nil 50161 50159 3026 2896 1 3058 #moveDown 8 'Move Down' 1 1 3106 $\x25BC nil nil 3152 nil nil 1 nil nil 50159 50157 3026 2896 1 3058 #moveUp 8 'Move Up' 1 1 3106 $\x25B2 8 'Segoe UI' nil 3152 nil nil 1 nil nil 50157 50155 3026 2896 1 3058 #moveFirst 8 'Move First' 1 1 3106 $\x23EE 8 'Georgia' nil 3152 nil nil 3 nil nil 50155 34 4 3312 3232 3168 3040 nil nil 1 nil 578 33 33 nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 578 1 1 578 709 51 2896 1042 #updateSizePosted 880 2896 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 8 #() 1184 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 30 nil 2816 34 2 8 1140970061 1025 3600 834 138 144 880 nil 912 944 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 3058 #moveFirst 8 'Move to &First' 1 1 nil nil nil 3746 1 3058 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3746 1 3058 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3746 1 3058 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3600 nil 8 1903904528 ##(Smalltalk.BasicListAbstract) nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 701 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() nil nil 3600 nil 3 nil nil #report 880 nil 133121 nil 34 4 nil nil 578 1 1 nil 978 138 144 34 2 1042 #createAt:extent: 34 2 578 1 51 578 709 193 3600 1042 #contextMenu: 34 1 3712 3600 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 98 1 0 0 121 0 0 0] 8 #() 1184 nil 27 170 192 34 2 3600 8 'list' 590342 ##(Smalltalk.Rectangle) 578 1 1 578 1 11 978 138 144 34 1 1042 #createAt:extent: 34 2 578 21 147 578 709 253 2816 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 73 0 0 0 108 1 0 0 199 0 0 0] 34 2 2896 3600 1184 nil 27 170 192 34 2 2816 8 'parameters' 4418 578 21 17 578 21 21 nil nil nil nil 39737 nil nil nil 578 481 411 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 1998684880 978 138 144 34 3 1042 #createAt:extent: 34 2 578 3839 21 578 781 561 416 1042 #text: 34 1 8 'Rename Method...' 416 1042 #updateMenuBar 880 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 5 9 0 0 34 1 0 0] 34 3 640 2816 2576 1184 nil 27 )! !
!RenameMethodDialog class categoriesFor: #defaultModel!models!public! !
!RenameMethodDialog class categoriesFor: #resource_Default_view!public!resources-views! !

