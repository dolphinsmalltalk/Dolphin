"Filed out from Dolphin Smalltalk"!

ValuePresenter subclass: #ScintillaStylesCollectionPresenter
	instanceVariableNames: 'collectionPresenter detailPresenter settingSelection'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ScintillaStylesCollectionPresenter guid: (GUID fromString: '{dfa721d9-7de6-4fe7-9998-18dd7b52c0c4}')!

ScintillaStylesCollectionPresenter comment: 'ScintillaStylesCollectionPresenter provides a master-detail presentation of a collection of <ScintillaTextStyle>s (e.g  those configured for a particular ScintillaView). It is composed of a <CollectionPresenter>, to present the list of styles, and a <ScintillaTextStylePresenter>, to present the detail view. A ScintillaStylesCollectionPresenter can be used to add new styles, and remove and modify existing styles, and as such is used for the #textStyles aspect of a <ScintillaView> when inspected with the Published Aspect Inspector, and also within the <ScintillaTextStylesDialog>. The latter is intended to allow for configuration of text styles in an end-user application that employs Scintilla.

Instance Variables:
	collectionPresenter	<CollectionPresenter>
	detailPresenter		<ScintillaTextStylePresenter>

'!

!ScintillaStylesCollectionPresenter categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !

!ScintillaStylesCollectionPresenter methodsFor!

addItem
	^collectionPresenter addItem!

applyDefaultStyle
	| style list |
	(collectionPresenter notNil and: [collectionPresenter isOpen]) ifFalse: [^self].
	list := collectionPresenter listPresenter view.
	style := self defaultStyle.
	list font: style font.
	style forecolor ifNotNil: [:colour | list forecolor: colour].
	style backcolor ifNotNil: [:colour | list backcolor: colour]!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	collectionPresenter := self add: CollectionPresenter new name: 'styles'.
	collectionPresenter setAddItemBlock: [ScintillaTextStyle new].
	detailPresenter := self add: ScintillaTextStylePresenter new name: 'detail'!

createSchematicWiring
	"Create the trigger wiring for the receiver. At this stage the initialization
	is complete and the view is open"

	super createSchematicWiring.
	collectionPresenter 
		when: #selectionChanged
		send: #onSelectionChanged
		to: self.
	detailPresenter 
		when: #valueChanged
		send: #onStyleChanged
		to: self!

defaultStyle
	^detailPresenter defaultStyle!

defaultStyle: aScintillaTextStyle 
	"Set the default style to be used for style facets for which no setting is specified, i.e.
	this style specifies the style facets that will be inherited from the view settings
	Typically this will include the font and background color. These style facets are then
	overridden by first the #normal style, and then any specific style. "

	detailPresenter defaultStyle: aScintillaTextStyle.
	self applyDefaultStyle!

model: aValueModel
	"Set the model of the receiver to be aValueModel. We intercept a change
	notification so that the list selection can track this value."

	super model: aValueModel.
	self onValueChanged
!

normalStyle: aScintillaTextStyle 
	detailPresenter normalStyle: aScintillaTextStyle!

onSelectionChanged
	collectionPresenter selectionOrNil 
		ifNil: 
			[detailPresenter isEnabled: false.
			detailPresenter model value: detailPresenter normalStyle]
		ifNotNil: 
			[:selection | 
			detailPresenter model value: selection.
			detailPresenter isEnabled: true]!

onStyleChanged
	collectionPresenter selectionOrNil ifNotNil: [:sel | collectionPresenter listModel refresh: sel]!

onValueChanged
	"Private - The value has been changed in the receiver's model. Transfer the value to the
	listModel"

	collectionPresenter model: self model.
	collectionPresenter listModel searchPolicy: SearchPolicy equality.
	(self model value detect: [:each | each name == #normal] ifNone: []) 
		ifNotNil: [:normal | self normalStyle: normal]!

onViewOpened
	super onViewOpened.
	collectionPresenter selectionOrNil: (self model value lookup: 1)! !

!ScintillaStylesCollectionPresenter categoriesForMethods!
addItem!commands!public! !
applyDefaultStyle!private!updating! !
createComponents!initializing!private! !
createSchematicWiring!initializing!public! !
defaultStyle!accessing!public! !
defaultStyle:!accessing!public! !
model:!accessing!public! !
normalStyle:!accessing!public! !
onSelectionChanged!event handling!private! !
onStyleChanged!event handling!private! !
onValueChanged!event handling!private! !
onViewOpened!event handling!public! !
!

!ScintillaStylesCollectionPresenter class methodsFor!

customDraw: aNMLVCUSTOMDRAW 
	| style |
	style := aNMLVCUSTOMDRAW item.
	style fontName isNil 
		ifTrue: 
			[| font |
			font := aNMLVCUSTOMDRAW font.
			style restyleFont: font]
		ifFalse: [aNMLVCUSTOMDRAW font: style font].
	style forecolor ifNotNil: [:color | aNMLVCUSTOMDRAW forecolor: color].
	style backcolor ifNotNil: [:color | aNMLVCUSTOMDRAW backcolor: color]!

defaultModel
	^OrderedCollection with: ScintillaTextStyle normal!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 17 11 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 512 nil nil nil 5 nil nil nil 512 482 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 512 34 2 8 1140850944 1 592 nil nil nil 5 nil nil nil 592 nil 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 160 0 0 0 19 0 0 0] 193 624 nil 592 770 #text: 34 1 8 '&Style Name:' 592 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 512 34 2 8 1140936781 1025 992 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 992 nil 8 1759068368 459270 ##(Smalltalk.Message) #displayString 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 313 #left 1202 #displayString 1232 1202 #<= 8 #() nil nil 992 nil 3 nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | ScintillaStylesCollectionPresenter customDraw: each]' 8 #[31 105 45 17 177 106] 721414 ##(Smalltalk.Association) #ScintillaStylesCollectionPresenter ##(Smalltalk.ScintillaStylesCollectionPresenter) #customDraw: 1424 7 257 nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 19 0 0 0 160 0 0 0 105 1 0 0] 193 1024 8 '' 992 3 8 #() 962 193 193 nil 35 170 192 34 2 992 8 'list' nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 0 0 0 0 160 0 0 0 105 1 0 0] 193 544 8 '' 512 3 34 2 592 992 962 193 193 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1968 nil nil nil 5 nil nil nil 1968 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.ScintillaTextStylePresenter) #resource_Default_view nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[168 0 0 0 0 0 0 0 162 1 0 0 105 1 0 0] 193 2000 8 '' 1968 3 1104 962 193 193 nil 27 170 192 34 4 512 8 'styles' 1968 8 'detail' 590342 ##(Smalltalk.Rectangle) 962 1 1 962 1 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[191 13 0 0 10 0 0 0 97 15 0 0 115 1 0 0] 193 448 8 'Text Styles' 416 1 34 2 512 1968 962 193 193 nil 27 )!

resource_Developer_view
	"Answer the literal data from which the 'Developer view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Developer_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 17 11 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 512 nil nil nil 5 nil nil nil 512 482 1 1 410 ##(Smalltalk.ReferenceView) 34 14 nil 512 34 2 8 1140850688 131073 592 nil nil nil 5 nil nil nil 592 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_List_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 160 0 0 0 25 0 0 0] 193 624 8 'toolbar' 592 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 512 34 2 8 1140936781 1 944 590662 2 ##(Smalltalk.ListModel) 138 144 896 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #moveFirst 8 'Move to &First' 1 1 nil nil nil 1170 1 1202 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 1170 1 1202 #moveDown 8 'Move to &Next' 1 1 nil nil nil 1170 1 1202 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 944 nil 8 1759068368 459270 ##(Smalltalk.Message) #displayString 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 313 #left 1426 #displayString 1456 1426 #<= 8 #() nil nil 944 nil 3 nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | ScintillaStylesCollectionPresenter customDraw: each]' 8 #[31 105 45 17 177 106] 721414 ##(Smalltalk.Association) #ScintillaStylesCollectionPresenter ##(Smalltalk.ScintillaStylesCollectionPresenter) #customDraw: 1648 7 257 nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 690 138 144 34 2 754 #createWindow: 34 1 802 834 8 #[0 0 0 0 25 0 0 0 160 0 0 0 160 1 0 0] 193 976 8 '' 944 754 #contextMenu: 34 1 1136 944 3 8 #() 914 193 193 nil 35 170 192 34 2 944 8 'list' nil 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[0 0 0 0 0 0 0 0 160 0 0 0 160 1 0 0] 193 544 8 '' 512 3 34 2 592 944 914 193 193 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2224 nil nil nil 5 nil nil nil 2224 658 ##(Smalltalk.ScintillaTextStylePresenter) #resource_Developer_view nil 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[168 0 0 0 0 0 0 0 162 1 0 0 160 1 0 0] 193 2256 8 '' 2224 3 896 914 193 193 nil 27 170 192 34 4 512 8 'styles' 2224 8 'detail' 590342 ##(Smalltalk.Rectangle) 914 1 1 914 1 1 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[191 13 0 0 10 0 0 0 97 15 0 0 170 1 0 0] 193 448 8 'Text Styles' 416 1 34 2 512 2224 914 193 193 nil 27 )! !

!ScintillaStylesCollectionPresenter class categoriesForMethods!
customDraw:!helpers!public! !
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
resource_Developer_view!public!resources-views! !
!

