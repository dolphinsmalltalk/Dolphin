"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'UI.Scintilla.StylesCollectionPresenter'
	instanceVariableNames: 'collectionPresenter detailPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.StylesCollectionPresenter guid: (Core.GUID fromString: '{dfa721d9-7de6-4fe7-9998-18dd7b52c0c4}')!
UI.Scintilla.StylesCollectionPresenter comment: 'ScintillaStylesCollectionPresenter provides a master-detail presentation of a collection of <ScintillaTextStyle>s (e.g  those configured for a particular ScintillaView). It is composed of a <CollectionPresenter>, to present the list of styles, and a <ScintillaTextStylePresenter>, to present the detail view. A ScintillaStylesCollectionPresenter can be used to add new styles, and remove and modify existing styles, and as such is used for the #textStyles aspect of a <ScintillaView> when inspected with the Published Aspect Inspector, and also within the <ScintillaTextStylesDialog>. The latter is intended to allow for configuration of text styles in an end-user application that employs Scintilla.

Instance Variables:
	collectionPresenter	<CollectionPresenter>
	detailPresenter		<ScintillaTextStylePresenter>

'!
!UI.Scintilla.StylesCollectionPresenter categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!UI.Scintilla.StylesCollectionPresenter methodsFor!

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
	collectionPresenter setAddItemBlock: [TextStyle new].
	detailPresenter := self add: TextStylePresenter new name: 'detail'!

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
	(self model value detect: [:each | each name == #normal] ifNone: nil)
		ifNotNil: [:normal | self normalStyle: normal]!

onViewOpened
	super onViewOpened.
	collectionPresenter selectionOrNil: (self model value lookup: 1)! !
!UI.Scintilla.StylesCollectionPresenter categoriesForMethods!
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

!UI.Scintilla.StylesCollectionPresenter class methodsFor!

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
	^OrderedCollection with: TextStyle normal!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 984838 #{UI.BorderLayout} 17 11 nil nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 512 nil nil nil 5 nil nil nil 512 482 1 1 410 #{UI.StaticText} 34 16 nil 512 34 2 8 1140850944 1 592 nil nil nil 5 nil nil nil 592 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 802 321 39 592 754 #text: 34 1 8 '&Style Name:' 592 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 0 0 0 19 0 0 0] 8 #() 802 193 193 nil 27 nil nil nil 410 #{UI.ListView} 34 45 nil 512 34 2 8 1140936781 1025 976 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 5 nil nil nil 976 nil 8 1815049392 786950 #{Core.Message} #displayString 8 #() nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 '' 313 #left 1186 #displayString 1216 1186 #<= 8 #() nil nil 976 nil 3 nil 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 3 1 1392 8 'doIt' 8 '[:each | UI.Scintilla.StylesCollectionPresenter customDraw: each]' 8 #[31 105 45 17 177 106] 1442886 2 #{Kernel.VariableBinding} #StylesCollectionPresenter #{UI.Scintilla.StylesCollectionPresenter} #{UI.Scintilla} 1 #customDraw: 1408 7 257 nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 706 34 1 754 #createAt:extent: 34 2 802 1 39 802 321 685 976 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 160 0 0 0 105 1 0 0] 8 #() 960 nil 35 170 192 34 2 976 8 'list' nil 706 34 1 754 #createAt:extent: 34 2 802 1 1 802 321 723 512 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 0 0 0 105 1 0 0] 34 2 592 976 960 nil 27 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 1888 nil nil nil 5 nil nil nil 1888 1376838 1 #{UI.ResourceIdentifier} #{UI.Scintilla.TextStylePresenter} #resource_Default_view nil 706 34 1 754 #createAt:extent: 34 2 802 337 1 802 501 723 1888 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 168 0 0 0 0 0 0 0 162 1 0 0 105 1 0 0] 1088 960 nil 27 170 192 34 4 1888 8 'detail' 512 8 'styles' 1180166 #{Graphics.Rectangle} 802 1 1 802 1 1 706 34 2 754 #createAt:extent: 34 2 802 12287 21 802 837 723 416 754 #text: 34 1 8 'Text Styles' 416 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 161 25 0 0 115 1 0 0] 34 2 512 1888 960 nil 27)!

resource_Developer_view
	"Answer the literal data from which the 'Developer view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Developer_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 984838 #{UI.BorderLayout} 17 11 nil nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 512 nil nil nil 5 nil nil nil 512 482 1 1 410 #{UI.ReferenceView} 34 14 nil 512 34 2 8 1140850688 131073 592 nil nil nil 5 nil nil nil 592 1376838 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_List_tools nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 786 321 51 592 738 #text: 34 1 8 'toolbar' 592 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 0 0 0 25 0 0 0] 8 #() 786 193 193 nil 27 nil nil nil 410 #{UI.ListView} 34 45 nil 512 34 2 8 1140936781 1 960 787270 2 #{UI.ListModel} 138 144 928 nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 5 461638 4 #{UI.Menu} nil true 34 4 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #moveFirst 8 'Move to &First' 1 1 nil nil nil 1186 1 1218 #moveUp 8 'Move to &Previous' 1 1 nil nil nil 1186 1 1218 #moveDown 8 'Move to &Next' 1 1 nil nil nil 1186 1 1218 #moveLast 8 'Move to &Last' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 960 nil 8 1815049392 786950 #{Core.Message} #displayString 8 #() nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 '' 313 #left 1442 #displayString 1472 1442 #<= 8 #() nil nil 960 nil 3 nil 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 3 1 1648 8 'doIt' 8 '[:each | UI.Scintilla.StylesCollectionPresenter customDraw: each] ' 8 #[31 105 45 17 177 106] 1442886 2 #{Kernel.VariableBinding} #StylesCollectionPresenter #{UI.Scintilla.StylesCollectionPresenter} #{UI.Scintilla} 1 #customDraw: 1664 7 257 nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 690 34 2 738 #createAt:extent: 34 2 786 1 51 786 321 783 960 738 #contextMenu: 34 1 1152 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 0 0 0 160 1 0 0] 8 #() 944 nil 35 170 192 34 2 960 8 'list' nil 690 34 1 738 #createAt:extent: 34 2 786 1 1 786 321 833 512 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 0 0 0 160 1 0 0] 34 2 592 960 944 nil 27 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 2176 nil nil nil 5 nil nil nil 2176 658 #{UI.Scintilla.TextStylePresenter} #resource_Developer_view nil 690 34 1 738 #createAt:extent: 34 2 786 337 1 786 501 833 2176 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 168 0 0 0 0 0 0 0 162 1 0 0 160 1 0 0] 928 944 nil 27 170 192 34 4 2176 8 'detail' 512 8 'styles' 1180166 #{Graphics.Rectangle} 786 1 1 786 1 1 690 34 2 738 #createAt:extent: 34 2 786 12287 21 786 837 833 416 738 #text: 34 1 8 'Text Styles' 416 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 161 25 0 0 170 1 0 0] 34 2 512 2176 944 nil 27)! !
!UI.Scintilla.StylesCollectionPresenter class categoriesForMethods!
customDraw:!helpers!public! !
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
resource_Developer_view!public!resources-views! !
!

