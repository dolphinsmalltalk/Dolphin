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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 25690113 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 672 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 672 852230 ##(Smalltalk.FramingLayout)  234 240 98 4 410 8 ##(Smalltalk.TextEdit)  98 16 0 672 98 2 8 1140916352 1025 848 0 482 512 0 7 0 0 0 848 0 8 4294903807 852486 ##(Smalltalk.NullConverter)  0 0 1 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 610 141 13 610 523 41 848 1058 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 848 1058 8 #isTextModified: 98 1 32 848 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 75 1 0 0 26 0 0 0] 98 0 610 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedPreviousRight 21 1394 8 #fixedParentRight -1 1394 8 #fixedPreviousTop -5 1394 8 #fixedViewTop 41 410 8 ##(Smalltalk.StaticText)  98 16 0 672 98 2 8 1140850944 1 1536 0 0 0 7 0 0 0 1536 0 8 4294903625 962 0 0 0 994 202 208 98 2 1058 1088 98 2 610 11 19 610 111 41 1536 1058 8 #text: 98 1 8 '&Selector:' 1536 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 9 0 0 0 60 0 0 0 29 0 0 0] 98 0 1344 0 27 1362 1394 8 #fixedParentLeft 11 1394 8 #fixedViewLeft 111 1394 8 #fixedParentTop 19 1504 41 234 256 98 2 848 8 'selector' 0 994 202 208 98 1 1058 1088 98 2 610 21 17 610 665 81 672 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 86 1 0 0 48 0 0 0] 98 2 1536 848 1344 0 27 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 2192 0 0 0 7 0 0 0 2192 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 994 202 208 98 1 1058 1088 98 2 610 21 363 610 665 61 2192 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 181 0 0 0 86 1 0 0 211 0 0 0] 98 0 1344 0 27 0 0 410 688 98 15 0 416 98 2 8 1140850688 131073 2496 0 754 31 0 7 0 0 0 2496 642 1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 2496 98 2 8 1140853548 131137 2592 0 482 512 0 519 0 530 0 16 562 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 610 193 193 0 2592 482 512 8 4294903595 234 256 2480 234 256 98 8 21055 853766 ##(Smalltalk.ToolbarButton)  21055 0 2592 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #moveDown 8 'Move Down' 1 1 0 395334 3 ##(Smalltalk.Bitmap)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'ListBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 7 610 161 33 3 21057 2834 21057 0 2592 1 2866 8 #moveLast 8 'Move Last' 1 1 0 2944 7 21051 2834 21051 0 2592 1 2866 8 #moveFirst 8 'Move First' 1 1 0 2944 5 21053 2834 21053 0 2592 1 2866 8 #moveUp 8 'Move Up' 1 1 0 2944 1 98 5 3136 3200 2848 3072 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 2592 3 0 1 234 240 98 2 2944 1 0 1 0 610 33 33 610 45 45 0 0 994 202 208 98 2 1058 1088 98 2 610 1 1 610 665 51 2592 1058 8 #updateSize 2480 2592 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 76 1 0 0 25 0 0 0] 98 0 1344 0 27 0 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 2496 98 2 8 1140970061 1025 3568 590662 2 ##(Smalltalk.ListModel)  202 208 2480 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 512 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem)  1 2866 3168 8 'Move to &First' 1 1 0 0 0 3794 1 2866 3232 8 'Move to &Previous' 1 1 0 0 0 3794 1 2866 2896 8 'Move to &Next' 1 1 0 0 0 3794 1 2866 3104 8 'Move to &Last' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 3568 0 8 4294903801 8 ##(Smalltalk.BasicListAbstract)  0 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 '' 657 8 #left 4032 8 ##(Smalltalk.SortedCollection)  0 0 3568 0 3 0 0 8 #report 2480 0 133121 0 0 994 202 208 98 2 1058 1088 98 2 610 1 51 610 665 207 3568 1058 8 #contextMenu: 98 1 3760 3568 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 76 1 0 0 128 0 0 0] 98 0 1344 0 27 234 256 98 2 3568 8 'list' 590342 ##(Smalltalk.Rectangle)  610 1 1 610 1 11 994 202 208 98 1 1058 1088 98 2 610 21 97 610 665 267 2496 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 48 0 0 0 86 1 0 0 181 0 0 0] 98 2 2592 3568 1344 0 27 234 256 98 2 2496 8 'parameters' 4466 610 21 17 610 21 21 0 0 0 0 26415 0 0 0 610 541 391 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 994 202 208 98 3 1058 1088 98 2 610 2799 21 610 721 511 416 1058 1776 98 1 8 'New Method Name...' 416 1058 8 #updateMenuBar 2480 416 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 223 6 0 0 9 1 0 0] 98 3 672 2496 2192 1344 0 27 )! !
!MethodNameDialog class categoriesFor: #defaultModel!models!public! !
!MethodNameDialog class categoriesFor: #resource_Default_view!public!resources-views! !

