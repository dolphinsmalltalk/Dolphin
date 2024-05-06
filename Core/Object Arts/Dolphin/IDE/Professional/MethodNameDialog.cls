"Filed out from Dolphin Smalltalk"!

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

!MethodNameDialog categoriesForClass!MVP-Presenters! !

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

!MethodNameDialog categoriesForMethods!
allowParameterRename:!accessing!public! !
allowParameterReordering:!accessing!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
isValid!private!testing! !
model:!accessing!public! !
onParameter:renamedTo:accept:!event handling!public! !
queryCommand:!commands!private! !
!

!MethodNameDialog class methodsFor!

defaultModel
	^RBMethodName new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.StaticText) 34 16 nil 640 34 2 8 1140850944 1 768 nil nil nil 7 nil nil nil 768 nil 8 1883797456 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 11 19 578 111 41 768 946 #text: 34 1 8 '&Selector:' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 9 0 0 0 60 0 0 0 29 0 0 0] 8 #() 578 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 11 1186 #fixedViewLeft 111 1186 #fixedParentTop 19 1186 #fixedViewTop 41 410 ##(Smalltalk.TextEdit) 34 16 nil 640 34 2 8 1140916352 1025 1264 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 1264 nil 8 1883819888 850 nil nil 1 882 138 144 34 2 946 #createAt:extent: 34 2 578 141 13 578 567 45 1264 946 #setMarginWidths: 34 1 8 #(3 3) 1264 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 8 #() 1136 nil 27 1154 1186 #fixedPreviousRight 21 1186 #fixedParentRight -1 1186 #fixedPreviousTop -5 1248 45 170 192 34 2 1264 8 'selector' nil 882 138 144 34 1 946 #createAt:extent: 34 2 578 21 17 578 709 81 640 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 108 1 0 0 48 0 0 0] 34 2 768 1264 1136 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1872 nil nil nil 7 nil nil nil 1872 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 882 138 144 34 1 946 #createAt:extent: 34 2 578 21 353 578 709 61 1872 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 176 0 0 0 108 1 0 0 206 0 0 0] 8 #() 1136 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2128 nil nil nil 7 nil nil nil 2128 610 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 2128 34 2 8 1140853612 131073 2208 nil nil nil 519 nil nil nil 2208 1344 8 1883845616 170 192 2112 170 192 34 8 26209 1115206 1 ##(Smalltalk.ToolbarIconButton) 2208 1 1180998 4 ##(Smalltalk.CommandDescription) #moveLast 8 'Move Last' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $\x23ED 8 'Georgia' nil 1330 #menuHilight nil nil 3 nil nil 26209 26207 2338 2208 1 2370 #moveDown 8 'Move Down' 1 1 2418 $\x25BC nil nil 2464 nil nil 1 nil nil 26207 26205 2338 2208 1 2370 #moveUp 8 'Move Up' 1 1 2418 $\x25B2 8 'Segoe UI' nil 2464 nil nil 1 nil nil 26205 26203 2338 2208 1 2370 #moveFirst 8 'Move First' 1 1 2418 $\x23EE 8 'Georgia' nil 2464 nil nil 3 nil nil 26203 34 4 2624 2544 2480 2352 nil nil 1 nil 578 33 33 nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 578 1 1 578 709 51 2208 946 #updateSizePosted 2112 2208 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 8 #() 1136 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 2128 34 2 8 1140970061 1025 2912 590662 2 ##(Smalltalk.ListModel) 138 144 2112 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1344 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 2370 #moveFirst 8 'Move to &First' 1 1 nil nil nil 3106 1 2370 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3106 1 2370 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3106 1 2370 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2912 nil 8 1883852064 ##(Smalltalk.BasicListAbstract) nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 701 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() nil nil 2912 nil 3 nil nil #report 2112 nil 133121 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 138 144 34 2 946 #createAt:extent: 34 2 578 1 51 578 709 197 2912 946 #contextMenu: 34 1 3072 2912 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 98 1 0 0 123 0 0 0] 8 #() 1136 nil 35 170 192 34 2 2912 8 'list' 590342 ##(Smalltalk.Rectangle) 578 1 1 578 1 11 882 138 144 34 1 946 #createAt:extent: 34 2 578 21 97 578 709 257 2128 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 48 0 0 0 108 1 0 0 176 0 0 0] 34 2 2208 2912 1136 nil 27 170 192 34 2 2128 8 'parameters' 3746 578 21 17 578 21 21 nil nil nil nil 34845 nil nil nil 578 541 391 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010284960 882 138 144 34 3 946 #createAt:extent: 34 2 578 7039 21 578 781 511 416 946 #text: 34 1 8 'New Method Name...' 416 946 #updateMenuBar 2112 416 1074 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 69 15 0 0 9 1 0 0] 34 3 640 2128 1872 1136 nil 27 )! !

!MethodNameDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

