"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #MethodNameDialog
	instanceVariableNames: 'selectorPresenter parametersPresenter parameterNamesPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodNameDialog guid: (GUID fromString: '{560f006d-fa1b-4603-810c-3b7b21486bd3}')!
MethodNameDialog comment: 'MethodNameDialog is a <dialogPresenter> used to edit a method selector and argument list. It is part of the native Dolphin Refactoring Browser implementation, and is used for refactorings such as ''Rename Method''.

Instance Variables:
	selectorPresenter		<TextPresenter>. The method selector.
	parametersPresenter		<ListValuePresenter>. List of argument names.

'!
!MethodNameDialog categoriesForClass!Development!MVP-Presenters! !
!MethodNameDialog methodsFor!

allowParameterRename: aBoolean
	parameterNamesPresenter view canEditLabels: aBoolean!

allowParameterReordering: aBoolean
	parameterNamesPresenter view isEnabled: aBoolean!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	selectorPresenter := self add: TextPresenter new name: 'selector'.
	parametersPresenter := self add: SequenceableCollectionPresenter new
				name: 'parameters'.
	parameterNamesPresenter := parametersPresenter presenterNamed: 'list'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	parameterNamesPresenter 
		when: #labelOf:editedTo:accept:
		send: #onParameter:renamedTo:accept:
		to: self!

isValid
	^self model isValid!

model: anObject
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: anObject.

	aspectBuffer := self model.
	selectorPresenter model: (aspectBuffer aspectValue: #selector).
	parametersPresenter model: (aspectBuffer aspectValue: #arguments).!

onParameter: aString renamedTo: aString2 accept: aValueHolder
	| args |
	args := self model arguments.
	(args includes: aString2) 
		ifTrue: [aValueHolder value: false]
		ifFalse: 
			[args := args copy at: (args indexOf: aString) put: aString2; yourself.
			(self model aspectValue: #arguments) value: args.
			aValueHolder value: true]!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>."

	aCommandQuery commandSymbol == #ok 
		ifTrue: 
			[selectorPresenter value.
			aCommandQuery isEnabled: self isValid.
			^true].
	^super queryCommand: aCommandQuery! !
!MethodNameDialog categoriesFor: #allowParameterRename:!accessing!public! !
!MethodNameDialog categoriesFor: #allowParameterReordering:!accessing!public! !
!MethodNameDialog categoriesFor: #createComponents!initializing!public! !
!MethodNameDialog categoriesFor: #createSchematicWiring!initializing!public! !
!MethodNameDialog categoriesFor: #isValid!private!testing! !
!MethodNameDialog categoriesFor: #model:!accessing!public! !
!MethodNameDialog categoriesFor: #onParameter:renamedTo:accept:!event handling!public! !
!MethodNameDialog categoriesFor: #queryCommand:!commands!private! !

!MethodNameDialog class methodsFor!

defaultModel
	^RBMethodName new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 656 nil 721158 ##(Smalltalk.SystemColor) 31 nil 7 nil nil nil 656 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.StaticText) 34 16 nil 656 34 2 8 1140850944 1 816 nil nil nil 7 nil nil nil 816 nil 8 1906774720 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 11 19 594 111 41 816 994 #text: 34 1 8 '&Selector:' 816 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 9 0 0 0 60 0 0 0 29 0 0 0] 8 #() 594 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 11 1234 #fixedViewLeft 111 1234 #fixedParentTop 19 1234 #fixedViewTop 41 410 ##(Smalltalk.TextEdit) 34 16 nil 656 34 2 8 1140916352 1025 1312 nil 466 496 nil 7 nil nil nil 1312 nil 8 1906818384 898 nil nil 1 930 138 144 34 2 994 #createAt:extent: 34 2 594 141 13 594 507 45 1312 994 #setMarginWidths: 34 1 8 #(3 3) 1312 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 67 1 0 0 28 0 0 0] 8 #() 1184 nil 27 1202 1234 #fixedPreviousRight 21 1234 #fixedParentRight -1 1234 #fixedPreviousTop -5 1296 45 170 192 34 2 1312 8 'selector' nil 930 138 144 34 1 994 #createAt:extent: 34 2 594 21 17 594 649 81 656 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 78 1 0 0 48 0 0 0] 34 2 816 1312 1184 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1904 nil nil nil 7 nil nil nil 1904 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 930 138 144 34 1 994 #createAt:extent: 34 2 594 21 353 594 649 61 1904 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 176 0 0 0 78 1 0 0 206 0 0 0] 8 #() 1184 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2160 nil 722 31 nil 7 nil nil nil 2160 626 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 2160 34 2 8 1140853548 131137 2256 nil 466 496 nil 519 nil nil nil 2256 466 496 8 1906893552 170 192 2144 170 192 34 8 21741 853766 ##(Smalltalk.ToolbarButton) 21741 nil 2256 1 1180998 4 ##(Smalltalk.CommandDescription) #moveFirst 8 'Move First' 1 1 nil 395334 3 ##(Smalltalk.Bitmap) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ListBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil 7 594 161 33 5 21743 2418 21743 nil 2256 1 2450 #moveUp 8 'Move Up' 1 1 nil 2512 1 21745 2418 21745 nil 2256 1 2450 #moveDown 8 'Move Down' 1 1 nil 2512 3 21747 2418 21747 nil 2256 1 2450 #moveLast 8 'Move Last' 1 1 nil 2512 7 34 5 2432 2640 2688 2736 1050118 ##(Smalltalk.ToolbarSeparator) nil nil 2256 3 nil 1 170 176 34 2 2512 1 nil 1 nil 594 33 33 594 45 45 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 594 1 1 594 649 51 2256 994 #updateSizePosted 2144 2256 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 68 1 0 0 25 0 0 0] 8 #() 1184 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 30 nil 2160 34 2 8 1140970061 1025 3072 590662 2 ##(Smalltalk.ListModel) 138 144 2144 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 496 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 2450 #moveFirst 8 'Move to &First' 1 1 nil nil nil 3282 1 2450 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3282 1 2450 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3282 1 2450 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3072 nil 8 1906899344 ##(Smalltalk.BasicListAbstract) nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 641 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 3072 nil 3 nil nil #report 2144 nil 133121 nil 34 4 nil nil 594 1 1 nil 930 138 144 34 2 994 #createAt:extent: 34 2 594 1 51 594 649 197 3072 994 #contextMenu: 34 1 3248 3072 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 68 1 0 0 123 0 0 0] 8 #() 1184 nil 27 170 192 34 2 3072 8 'list' 590342 ##(Smalltalk.Rectangle) 594 1 1 594 1 11 930 138 144 34 1 994 #createAt:extent: 34 2 594 21 97 594 649 257 2160 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 48 0 0 0 78 1 0 0 176 0 0 0] 34 2 2256 3072 1184 nil 27 170 192 34 2 2160 8 'parameters' 3906 594 21 17 594 21 21 nil nil nil nil 18375 nil nil nil 594 541 391 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010075552 930 138 144 34 3 994 #createAt:extent: 34 2 594 3839 21 594 721 511 416 994 #text: 34 1 8 'New Method Name...' 416 994 #updateMenuBar 2144 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 231 8 0 0 9 1 0 0] 34 3 656 2160 1904 1184 nil 27 )! !
!MethodNameDialog class categoriesFor: #defaultModel!models!public! !
!MethodNameDialog class categoriesFor: #resource_Default_view!public!resources-views! !

