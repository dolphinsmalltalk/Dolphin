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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(12845056 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 608 nil nil nil 7 nil nil nil 608 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.TextEdit) 34 16 nil 608 34 2 8 1140916352 1025 736 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 736 nil 8 1795700448 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[70 0 0 0 6 0 0 0 97 1 0 0 28 0 0 0] 193 768 nil 736 946 #setMarginWidths: 34 1 8 #(3 3) 736 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 21 1202 #fixedParentRight -1 1202 #fixedPreviousTop -5 1202 #fixedViewTop 45 410 ##(Smalltalk.StaticText) 34 16 nil 608 34 2 8 1140850944 1 1280 nil nil nil 7 nil nil nil 1280 nil 8 1795912768 850 nil nil nil 882 138 144 34 2 946 #createWindow: 34 1 994 1026 8 #[5 0 0 0 9 0 0 0 60 0 0 0 29 0 0 0] 193 1312 nil 1280 946 #text: 34 1 8 '&Selector:' 1280 3 8 #() 1138 193 193 nil 27 1170 1202 #fixedParentLeft 11 1202 #fixedViewLeft 111 1202 #fixedParentTop 19 1264 41 170 192 34 2 736 8 'selector' nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[10 0 0 0 8 0 0 0 108 1 0 0 48 0 0 0] 193 640 8 '' 608 3 34 2 1280 736 1138 193 193 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1872 nil nil nil 7 nil nil nil 1872 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[10 0 0 0 176 0 0 0 108 1 0 0 206 0 0 0] 193 1904 8 '' 1872 3 8 #() 1138 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2144 nil nil nil 7 nil nil nil 2144 578 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 2144 34 2 8 1140853612 131073 2224 nil nil nil 519 nil nil nil 2224 816 8 1795812352 170 192 2112 nil nil nil 170 192 34 8 9213 1115718 2 ##(Smalltalk.ToolbarIconButton) 2224 1 1180998 4 ##(Smalltalk.CommandDescription) #moveDown 8 'Move Down' 1 1 788806 2 ##(Smalltalk.TextTileIcon) $▼ nil nil 802 #menuHilight nil nil 1 nil nil 9213 nil nil 9211 2354 2224 1 2386 #moveUp 8 'Move Up' 1 1 2434 $▲ 8 'Segoe UI' nil 2464 nil nil 1 nil nil 9211 nil nil 9209 2354 2224 1 2386 #moveFirst 8 'Move First' 1 1 2434 $⏮ 8 'Georgia' nil 2464 nil nil 3 nil nil 9209 nil nil 9215 2354 2224 1 2386 #moveLast 8 'Move Last' 1 1 2434 $⏭ 8 'Georgia' nil 2464 nil nil 3 nil nil 9215 nil nil 34 4 2560 2480 2368 2640 nil nil 9 1 #smallIcons nil nil nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[0 0 0 0 0 0 0 0 98 1 0 0 25 0 0 0] 193 2256 8 '' 2224 3 8 #() 1138 193 193 nil 31 nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 2144 34 2 8 1140970061 1025 2912 590662 2 ##(Smalltalk.ListModel) 138 144 2112 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 816 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 2386 #moveFirst 8 'Move to &First' 1 1 nil nil nil 3106 1 2386 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 3106 1 2386 #moveDown 8 'Move to &Next' 1 1 nil nil nil 3106 1 2386 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2912 nil 8 1795768528 ##(Smalltalk.BasicListAbstract) nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 701 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() nil nil 2912 nil 3 nil nil #report 8 #() nil 133121 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 882 138 144 34 2 946 #createWindow: 34 1 994 1026 8 #[0 0 0 0 25 0 0 0 98 1 0 0 123 0 0 0] 193 2944 8 '' 2912 946 #contextMenu: 34 1 3072 2912 3 8 #() 1138 193 193 nil 35 170 192 34 2 2912 8 'list' 590342 ##(Smalltalk.Rectangle) 1138 1 1 1138 1 11 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[10 0 0 0 48 0 0 0 108 1 0 0 176 0 0 0] 193 2176 8 '' 2144 3 34 2 2224 2912 1138 193 193 nil 27 170 192 34 2 2144 8 'parameters' 3778 1138 21 17 1138 21 21 nil nil nil nil 8631 nil nil nil 1138 541 391 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2001703808 nil nil nil nil 882 138 144 34 2 946 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 3778 1138 6143 21 1138 6923 531 193 416 946 #setWindowText: 34 1 8 'New Method Name...' 416 1 34 3 608 2144 1872 1138 193 193 nil 29 )! !

!MethodNameDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

