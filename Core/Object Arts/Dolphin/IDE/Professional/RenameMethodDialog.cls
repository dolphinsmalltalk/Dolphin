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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 25690113 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 672 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 672 852230 ##(Smalltalk.FramingLayout)  234 240 98 8 410 8 ##(Smalltalk.StaticText)  98 16 0 672 98 2 8 1140850944 1 848 0 0 0 7 0 0 0 848 0 8 4294903625 852486 ##(Smalltalk.NullConverter)  0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 610 11 71 610 111 31 848 1042 8 #text: 98 1 8 'Scope:' 848 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 35 0 0 0 60 0 0 0 50 0 0 0] 98 0 610 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft 11 1314 8 #fixedViewLeft 111 1314 8 #fixedPreviousBottom 17 1314 8 #fixedViewTop 31 410 8 ##(Smalltalk.TextEdit)  98 16 0 672 98 2 8 1140916352 1025 1456 0 482 512 0 7 0 0 0 1456 0 8 4294903807 946 0 0 1 978 202 208 98 3 1042 1072 98 2 610 141 11 610 537 45 1456 1042 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1456 1042 8 #isTextModified: 98 1 32 1456 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 5 0 0 0 82 1 0 0 27 0 0 0] 98 0 1264 0 27 1282 1314 8 #fixedPreviousRight 21 1314 8 #fixedParentRight -7 1314 8 #fixedPreviousTop -9 1424 45 410 864 98 16 0 672 98 2 8 1140850944 1 1984 0 0 0 7 0 0 0 1984 0 8 4294903625 946 0 0 0 978 202 208 98 2 1042 1072 98 2 610 11 21 610 111 41 1984 1042 1152 98 1 8 '&Selector:' 1984 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 60 0 0 0 30 0 0 0] 98 0 1264 0 27 1282 1328 11 1360 111 1314 8 #fixedParentTop 21 1424 41 410 8 ##(Smalltalk.ComboBox)  98 17 0 672 98 2 8 1144063491 1025 2336 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 512 0 7 0 0 0 2336 0 8 4294903803 8 ##(Smalltalk.BasicListAbstract)  2464 401 978 202 208 98 1 1042 1072 98 2 610 141 65 610 301 43 2336 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 32 0 0 0 220 0 0 0 53 0 0 0] 98 0 1264 0 27 1282 1888 21 1360 301 1952 -5 1424 45 234 256 98 4 2336 8 'scope' 1456 8 'selector' 0 978 202 208 98 1 1042 1072 98 2 610 11 11 610 685 131 672 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 91 1 0 0 70 0 0 0] 98 4 1984 1456 848 2336 1264 0 27 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 2960 0 0 0 7 0 0 0 2960 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 978 202 208 98 1 1042 1072 98 2 610 11 417 610 685 61 2960 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 208 0 0 0 91 1 0 0 238 0 0 0] 2464 1264 0 27 0 0 410 688 98 15 0 416 98 2 8 1140850688 131073 3248 0 754 31 0 7 0 0 0 3248 642 1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 3248 98 2 8 1140853548 131137 3344 0 482 512 0 519 0 530 0 16 562 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 610 193 193 0 3344 482 512 8 4294903595 234 256 2464 234 256 98 8 21961 853766 ##(Smalltalk.ToolbarButton)  21961 0 3344 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #moveFirst 8 'Move First' 1 1 0 395334 3 ##(Smalltalk.Bitmap)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'ListBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 7 610 161 33 5 21963 3586 21963 0 3344 1 3618 8 #moveUp 8 'Move Up' 1 1 0 3696 1 21965 3586 21965 0 3344 1 3618 8 #moveDown 8 'Move Down' 1 1 0 3696 3 21967 3586 21967 0 3344 1 3618 8 #moveLast 8 'Move Last' 1 1 0 3696 7 98 5 3600 3824 3888 3952 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 3344 3 0 1 234 240 98 2 3696 1 0 1 0 610 33 33 610 45 45 0 0 978 202 208 98 2 1042 1072 98 2 610 7 1 610 673 51 3344 1042 8 #updateSize 2464 3344 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 0 0 0 0 0 83 1 0 0 25 0 0 0] 98 0 1264 0 27 0 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 3248 98 2 8 1140970061 1025 4320 2418 202 208 2464 0 2496 482 512 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem)  1 3618 3648 8 'Move to &First' 1 1 0 0 0 4498 1 3618 3856 8 'Move to &Previous' 1 1 0 0 0 4498 1 3618 3920 8 'Move to &Next' 1 1 0 0 0 4498 1 3618 3984 8 'Move to &Last' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 4320 0 8 4294903801 2544 0 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 '' 665 8 #left 2544 8 ##(Smalltalk.SortedCollection)  0 0 4320 0 3 0 0 8 #report 2464 0 133121 0 0 978 202 208 98 2 1042 1072 98 2 610 7 51 610 673 221 4320 1042 8 #contextMenu: 98 1 4464 4320 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 0 25 0 0 0 83 1 0 0 135 0 0 0] 98 0 1264 0 27 234 256 98 2 4320 8 'list' 590342 ##(Smalltalk.Rectangle)  610 7 1 610 7 7 978 202 208 98 1 1042 1072 98 2 610 11 141 610 685 277 3248 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 70 0 0 0 91 1 0 0 208 0 0 0] 98 2 3344 4320 1264 0 27 234 256 98 2 3248 8 'parameters' 5154 610 11 11 610 11 17 0 0 0 0 26699 0 0 0 610 481 411 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 978 202 208 98 3 1042 1072 98 2 610 2799 21 610 721 561 416 1042 1152 98 1 8 'Rename Method...' 416 1042 8 #updateMenuBar 2464 416 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 223 6 0 0 34 1 0 0] 98 3 672 3248 2960 1264 0 27 )! !
!RenameMethodDialog class categoriesFor: #defaultModel!models!public! !
!RenameMethodDialog class categoriesFor: #resource_Default_view!public!resources-views! !

