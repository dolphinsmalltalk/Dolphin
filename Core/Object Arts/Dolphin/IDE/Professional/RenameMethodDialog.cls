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
!RenameMethodDialog categoriesForClass!Development! !
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 656 nil 721158 ##(Smalltalk.SystemColor) 31 nil 7 nil nil nil 656 852230 ##(Smalltalk.FramingLayout) 170 176 34 8 410 ##(Smalltalk.ComboBox) 34 17 nil 656 34 2 8 1144063491 1025 816 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 496 nil 7 nil nil nil 816 nil 8 1906654144 ##(Smalltalk.BasicListAbstract) 928 401 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 141 65 594 301 47 816 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 32 0 0 0 220 0 0 0 55 0 0 0] 8 #() 594 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 21 1266 #fixedViewLeft 301 1266 #fixedPreviousTop -5 1266 #fixedViewTop 45 410 ##(Smalltalk.StaticText) 34 16 nil 656 34 2 8 1140850944 1 1344 nil nil nil 7 nil nil nil 1344 nil 8 1906774720 852486 ##(Smalltalk.NullConverter) nil nil nil 1010 138 144 34 2 1074 #createAt:extent: 34 2 594 11 71 594 111 31 1344 1074 #text: 34 1 8 'Scope:' 1344 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 35 0 0 0 60 0 0 0 50 0 0 0] 8 #() 1216 nil 27 1234 1266 #fixedParentLeft 11 1296 111 1266 #fixedPreviousBottom 17 1328 31 410 ##(Smalltalk.StaticText) 34 16 nil 656 34 2 8 1140850944 1 1712 nil nil nil 7 nil nil nil 1712 nil 8 1906774720 1426 nil nil nil 1010 138 144 34 2 1074 #createAt:extent: 34 2 594 11 21 594 111 41 1712 1074 #text: 34 1 8 '&Selector:' 1712 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 60 0 0 0 30 0 0 0] 8 #() 1216 nil 27 1234 1680 11 1296 111 1266 #fixedParentTop 21 1328 41 410 ##(Smalltalk.TextEdit) 34 16 nil 656 34 2 8 1140916352 1025 2048 nil 466 496 nil 7 nil nil nil 2048 nil 8 1906818384 1426 nil nil 1 1010 138 144 34 2 1074 #createAt:extent: 34 2 594 141 11 594 521 45 2048 1074 #setMarginWidths: 34 1 8 #(3 3) 2048 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 5 0 0 0 74 1 0 0 27 0 0 0] 8 #() 1216 nil 27 1234 1280 21 1266 #fixedParentRight -7 1312 -9 1328 45 170 192 34 4 2048 8 'selector' 816 8 'scope' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 594 11 11 594 669 131 656 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 83 1 0 0 70 0 0 0] 34 4 1712 2048 1344 816 1216 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2624 nil nil nil 7 nil nil nil 2624 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 594 11 407 594 669 61 2624 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 203 0 0 0 83 1 0 0 233 0 0 0] 928 1216 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2864 nil 722 31 nil 7 nil nil nil 2864 626 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 2864 34 2 8 1140853548 131137 2960 nil 466 496 nil 519 nil nil nil 2960 466 496 8 1906893552 170 192 928 170 192 34 8 22221 853766 ##(Smalltalk.ToolbarButton) 22221 nil 2960 1 1180998 4 ##(Smalltalk.CommandDescription) #moveFirst 8 'Move First' 1 1 nil 395334 3 ##(Smalltalk.Bitmap) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ListBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil 7 594 161 33 5 22223 3122 22223 nil 2960 1 3154 #moveUp 8 'Move Up' 1 1 nil 3216 1 22225 3122 22225 nil 2960 1 3154 #moveDown 8 'Move Down' 1 1 nil 3216 3 22227 3122 22227 nil 2960 1 3154 #moveLast 8 'Move Last' 1 1 nil 3216 7 34 5 3136 3344 3392 3440 1050118 ##(Smalltalk.ToolbarSeparator) nil nil 2960 3 nil 1 170 176 34 2 3216 1 nil 1 nil 594 33 33 594 45 45 nil nil 1010 138 144 34 2 1074 #createAt:extent: 34 2 594 7 1 594 657 51 2960 1074 #updateSizePosted 928 2960 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 0 0 0 0 0 75 1 0 0 25 0 0 0] 8 #() 1216 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 30 nil 2864 34 2 8 1140970061 1025 3776 882 138 144 928 nil 960 466 496 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 3154 #moveFirst 8 'Move to &First' 1 1 nil nil nil 3938 1 3154 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3938 1 3154 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3938 1 3154 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3776 nil 8 1906899344 ##(Smalltalk.BasicListAbstract) nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 649 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 3776 nil 3 nil nil #report 928 nil 133121 nil 8 #(nil) 1010 138 144 34 2 1074 #createAt:extent: 34 2 594 7 51 594 657 211 3776 1074 #contextMenu: 34 1 3904 3776 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 0 25 0 0 0 75 1 0 0 130 0 0 0] 8 #() 1216 nil 27 170 192 34 2 3776 8 'list' 590342 ##(Smalltalk.Rectangle) 594 7 1 594 7 7 1010 138 144 34 1 1074 #createAt:extent: 34 2 594 11 141 594 669 267 2864 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 70 0 0 0 83 1 0 0 203 0 0 0] 34 2 2960 3776 1216 nil 27 170 192 34 2 2864 8 'parameters' 4546 594 11 11 594 11 17 nil nil nil nil 18615 nil nil nil 594 481 411 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010075552 1010 138 144 34 3 1074 #createAt:extent: 34 2 594 3839 21 594 721 561 416 1074 #text: 34 1 8 'Rename Method...' 416 1074 #updateMenuBar 928 416 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 231 8 0 0 34 1 0 0] 34 3 656 2864 2624 1216 nil 27 )! !
!RenameMethodDialog class categoriesFor: #defaultModel!models!public! !
!RenameMethodDialog class categoriesFor: #resource_Default_view!public!resources-views! !

