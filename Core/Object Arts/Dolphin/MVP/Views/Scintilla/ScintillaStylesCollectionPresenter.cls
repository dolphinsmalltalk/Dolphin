"Filed out from Dolphin Smalltalk 7"!

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
	collectionPresenter selectionOrNil: (self model value at: 1 ifAbsent: [])! !
!ScintillaStylesCollectionPresenter categoriesFor: #addItem!commands!public! !
!ScintillaStylesCollectionPresenter categoriesFor: #applyDefaultStyle!private!updating! !
!ScintillaStylesCollectionPresenter categoriesFor: #createComponents!initializing!private! !
!ScintillaStylesCollectionPresenter categoriesFor: #createSchematicWiring!initializing!public! !
!ScintillaStylesCollectionPresenter categoriesFor: #defaultStyle!accessing!public! !
!ScintillaStylesCollectionPresenter categoriesFor: #defaultStyle:!accessing!public! !
!ScintillaStylesCollectionPresenter categoriesFor: #model:!accessing!public! !
!ScintillaStylesCollectionPresenter categoriesFor: #normalStyle:!accessing!public! !
!ScintillaStylesCollectionPresenter categoriesFor: #onSelectionChanged!event handling!private! !
!ScintillaStylesCollectionPresenter categoriesFor: #onStyleChanged!event handling!private! !
!ScintillaStylesCollectionPresenter categoriesFor: #onValueChanged!event handling!private! !
!ScintillaStylesCollectionPresenter categoriesFor: #onViewOpened!event handling!public! !

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 0 0 5 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  17 11 0 0 0 410 432 98 15 0 416 98 2 8 1140850688 131073 528 0 0 0 5 0 0 0 528 498 1 1 410 8 ##(Smalltalk.StaticText)  98 16 0 528 98 2 8 1140850944 1 608 0 0 0 5 0 0 0 608 0 8 4294903625 852486 ##(Smalltalk.NullConverter)  0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 866 321 39 608 802 8 #text: 98 1 8 '&Style Name:' 608 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 0 0 0 19 0 0 0] 98 0 866 193 193 0 27 0 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 528 98 2 8 1140936781 1025 1056 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 1056 0 8 4294903801 459270 ##(Smalltalk.Message)  8 #displayString 98 0 0 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 '' 313 8 #left 1298 1328 1344 8 ##(Smalltalk.SortedCollection)  0 0 1056 0 3 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  3 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:each | ScintillaStylesCollectionPresenter customDraw: each]' 8 #[31 105 45 17 177 106] 721414 ##(Smalltalk.Association)  8 #ScintillaStylesCollectionPresenter 8 ##(Smalltalk.ScintillaStylesCollectionPresenter)  8 #customDraw: 1536 7 257 0 8 #report 1184 0 133217 0 0 738 202 208 98 1 802 832 98 2 866 1 39 866 321 685 1056 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 160 0 0 0 105 1 0 0] 98 0 1040 0 27 234 256 98 2 1056 8 'list' 0 738 202 208 98 1 802 832 98 2 866 1 1 866 321 723 528 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 0 0 0 105 1 0 0] 98 2 608 1056 1040 0 27 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 2112 0 0 0 5 0 0 0 2112 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.ScintillaTextStylePresenter)  8 #resource_Default_view 0 738 202 208 98 1 802 832 98 2 866 337 1 866 501 723 2112 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 168 0 0 0 0 0 0 0 162 1 0 0 105 1 0 0] 1184 1040 0 27 234 256 98 4 2112 8 'detail' 528 8 'styles' 590342 ##(Smalltalk.Rectangle)  866 1 1 866 1 1 738 202 208 98 2 802 832 98 2 866 2799 21 866 837 723 416 802 928 98 1 8 'Text Styles' 416 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 25 7 0 0 115 1 0 0] 98 2 528 2112 1040 0 27 )!

resource_Developer_view
	"Answer the literal data from which the 'Developer view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Developer_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 0 0 5 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  17 11 0 0 0 410 432 98 15 0 416 98 2 8 1140850688 131073 528 0 0 0 5 0 0 0 528 498 1 1 410 8 ##(Smalltalk.ReferenceView)  98 14 0 528 98 2 8 1140850688 131073 608 0 0 0 5 0 0 0 608 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Toolbar)  8 #resource_List_tools 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 882 321 51 608 818 8 #text: 98 1 8 'toolbar' 608 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 0 0 0 25 0 0 0] 98 0 882 193 193 0 27 0 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 528 98 2 8 1140936781 1025 1072 590662 2 ##(Smalltalk.ListModel)  202 208 1040 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 265030 4 ##(Smalltalk.Menu)  0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #moveFirst 8 'Move to &First' 1 1 0 0 0 1330 1 1362 8 #moveUp 8 'Move to &Previous' 1 1 0 0 0 1330 1 1362 8 #moveDown 8 'Move to &Next' 1 1 0 0 0 1330 1 1362 8 #moveLast 8 'Move to &Last' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 1072 0 8 4294903801 459270 ##(Smalltalk.Message)  8 #displayString 98 0 0 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 '' 313 8 #left 1650 1680 1696 8 ##(Smalltalk.SortedCollection)  0 0 1072 0 3 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  3 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:each | ScintillaStylesCollectionPresenter customDraw: each]' 8 #[31 105 45 17 177 106] 721414 ##(Smalltalk.Association)  8 #ScintillaStylesCollectionPresenter 8 ##(Smalltalk.ScintillaStylesCollectionPresenter)  8 #customDraw: 1888 7 257 0 8 #report 1040 0 133217 0 0 754 202 208 98 2 818 848 98 2 882 1 51 882 321 783 1072 818 8 #contextMenu: 98 1 1296 1072 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 0 0 0 160 1 0 0] 98 0 1056 0 27 234 256 98 2 1072 8 'list' 0 754 202 208 98 1 818 848 98 2 882 1 1 882 321 833 528 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 0 0 0 160 1 0 0] 98 2 608 1072 1056 0 27 410 624 98 14 0 416 98 2 8 1140850688 131073 2512 0 0 0 5 0 0 0 2512 690 8 ##(Smalltalk.ScintillaTextStylePresenter)  8 #resource_Developer_view 0 754 202 208 98 1 818 848 98 2 882 337 1 882 501 833 2512 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 168 0 0 0 0 0 0 0 162 1 0 0 160 1 0 0] 1040 1056 0 27 234 256 98 4 528 8 'styles' 2512 8 'detail' 590342 ##(Smalltalk.Rectangle)  882 1 1 882 1 1 754 202 208 98 2 818 848 98 2 882 2799 21 882 837 833 416 818 944 98 1 8 'Text Styles' 416 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 25 7 0 0 170 1 0 0] 98 2 528 2512 1056 0 27 )! !
!ScintillaStylesCollectionPresenter class categoriesFor: #customDraw:!helpers!public! !
!ScintillaStylesCollectionPresenter class categoriesFor: #defaultModel!models!public! !
!ScintillaStylesCollectionPresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!ScintillaStylesCollectionPresenter class categoriesFor: #resource_Developer_view!public!resources-views! !

