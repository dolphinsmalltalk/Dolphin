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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 786950 ##(Smalltalk.DefaultColor) #dialog nil 167 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 8 410 ##(Smalltalk.StaticText) 34 16 nil 640 34 2 8 1140850944 1 768 nil nil nil 7 nil nil nil 768 nil 8 1912674480 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 11 71 578 111 31 768 946 #text: 34 1 8 'Scope:' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 35 0 0 0 60 0 0 0 50 0 0 0] 8 #() 578 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 11 1186 #fixedViewLeft 111 1186 #fixedPreviousBottom 17 1186 #fixedViewTop 31 410 ##(Smalltalk.TextEdit) 34 16 nil 640 34 2 8 1140916352 1025 1264 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 1264 nil 8 1912718128 850 nil nil 1 882 138 144 34 1 946 #createAt:extent: 34 2 578 141 11 578 521 45 1264 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 5 0 0 0 74 1 0 0 27 0 0 0] 8 #() 1136 nil 27 1154 1186 #fixedPreviousRight 21 1186 #fixedParentRight -7 1186 #fixedPreviousTop -9 1248 45 410 ##(Smalltalk.ComboBox) 34 17 nil 640 34 2 8 1144063491 1025 1632 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1330 1360 nil 7 nil nil nil 1632 nil 8 1912552560 ##(Smalltalk.BasicListAbstract) 1744 401 882 138 144 34 1 946 #createAt:extent: 34 2 578 141 65 578 301 43 1632 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 32 0 0 0 220 0 0 0 53 0 0 0] 8 #() 1136 nil 27 1154 1584 21 1216 301 1616 -5 1248 45 410 ##(Smalltalk.StaticText) 34 16 nil 640 34 2 8 1140850944 1 2000 nil nil nil 7 nil nil nil 2000 nil 8 1912674480 850 nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 578 11 21 578 111 41 2000 946 #text: 34 1 8 '&Selector:' 2000 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 60 0 0 0 30 0 0 0] 8 #() 1136 nil 27 1154 1200 11 1216 111 1186 #fixedParentTop 21 1248 41 170 192 34 4 1632 8 'scope' 1264 8 'selector' nil 882 138 144 34 1 946 #createAt:extent: 34 2 578 11 11 578 669 131 640 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 83 1 0 0 70 0 0 0] 34 4 2000 1264 768 1632 1136 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2560 nil nil nil 7 nil nil nil 2560 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 882 138 144 34 1 946 #createAt:extent: 34 2 578 11 403 578 669 65 2560 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 201 0 0 0 83 1 0 0 233 0 0 0] 1744 1136 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2800 nil nil nil 7 nil nil nil 2800 610 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 2800 34 2 8 1140853548 131137 2880 nil nil nil 519 nil 498 nil true 530 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 578 193 193 nil 2880 1330 1360 8 1912794480 170 192 1744 170 192 34 8 17835 1246790 1 ##(Smalltalk.ToolbarBitmapButton) 2880 1 1180998 4 ##(Smalltalk.CommandDescription) #moveFirst 8 'Move First' 1 1 nil 17835 395334 3 ##(Smalltalk.Bitmap) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ListBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil 7 578 161 33 5 17837 3090 2880 1 3122 #moveUp 8 'Move Up' 1 1 nil 17837 3184 1 17839 3090 2880 1 3122 #moveDown 8 'Move Down' 1 1 nil 17839 3184 3 17841 3090 2880 1 3122 #moveLast 8 'Move Last' 1 1 nil 17841 3184 7 34 5 3104 3312 3360 3408 1049158 1 ##(Smalltalk.ToolbarSeparator) 2880 1 170 176 34 2 3184 1 nil 1 nil 578 33 33 578 45 45 nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 578 7 1 578 657 51 2880 946 #updateSizePosted 1744 2880 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 0 0 0 0 0 75 1 0 0 25 0 0 0] 8 #() 1136 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 30 nil 2800 34 2 8 1140970061 1025 3744 1698 138 144 1744 nil 1776 1330 1360 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 3122 #moveFirst 8 'Move to &First' 1 1 nil nil nil 3906 1 3122 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3906 1 3122 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3906 1 3122 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3744 nil 8 1912800272 ##(Smalltalk.BasicListAbstract) nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 649 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 3744 nil 3 nil nil #report 1744 nil 133121 nil 8 #(nil) 882 138 144 34 2 946 #createAt:extent: 34 2 578 7 51 578 657 207 3744 946 #contextMenu: 34 1 3872 3744 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 0 25 0 0 0 75 1 0 0 128 0 0 0] 8 #() 1136 nil 27 170 192 34 2 3744 8 'list' 590342 ##(Smalltalk.Rectangle) 578 7 1 578 7 7 882 138 144 34 1 946 #createAt:extent: 34 2 578 11 141 578 669 263 2800 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 70 0 0 0 83 1 0 0 201 0 0 0] 34 2 2880 3744 1136 nil 27 170 192 34 2 2800 8 'parameters' 4514 578 11 11 578 11 17 nil nil nil nil 27927 nil nil nil 578 481 411 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2007257760 882 138 144 34 3 946 #createAt:extent: 34 2 578 3839 21 578 721 561 416 946 #text: 34 1 8 'Rename Method...' 416 946 #updateMenuBar 1744 416 1074 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 231 8 0 0 34 1 0 0] 34 3 640 2800 2560 1136 nil 27 )! !
!RenameMethodDialog class categoriesFor: #defaultModel!models!public! !
!RenameMethodDialog class categoriesFor: #resource_Default_view!public!resources-views! !

