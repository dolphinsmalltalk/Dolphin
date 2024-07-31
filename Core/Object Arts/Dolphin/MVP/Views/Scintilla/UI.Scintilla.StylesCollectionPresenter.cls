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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 17 11 nil nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 144 nil nil nil 5 nil nil nil 144 114 1 1 18 #{UI.StaticText} 50 16 nil 144 50 2 8 1140850944 1 224 nil nil nil 5 nil nil nil 224 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 160 0 0 0 19 0 0 0] 193 256 nil 224 370 #text: 50 1 8 '&Style Name:' 224 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 nil nil nil 18 #{UI.ListView} 50 45 nil 144 50 2 8 1140936781 1025 592 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 592 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 690 1 3142 5 #{UI.ListViewColumn} 8 '' 313 #left 786 #displayString 816 786 #<= 8 #() nil nil 592 nil 3 nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 976 8 'doIt' 8 '[:each | UI.Scintilla.StylesCollectionPresenter customDraw: each]' 8 #[31 105 45 17 177 106] 1094 2 #{Kernel.VariableBinding} #StylesCollectionPresenter #{UI.Scintilla.StylesCollectionPresenter} #{UI.Scintilla} 1 #customDraw: 992 7 257 nil #report 8 #() nil 133217 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 592 nil nil nil nil nil nil nil nil nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 19 0 0 0 160 0 0 0 105 1 0 0] 193 624 8 '' 592 3 8 #() 562 193 193 nil 35 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 592 8 'list' nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 0 0 0 0 160 0 0 0 105 1 0 0] 193 176 8 '' 144 3 50 2 224 592 562 193 193 nil 27 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 1552 nil nil nil 5 nil nil nil 1552 582 1 #{UI.ResourceIdentifier} #{UI.Scintilla.TextStylePresenter} #resource_Default_view nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[168 0 0 0 0 0 0 0 162 1 0 0 105 1 0 0] 193 1584 8 '' 1552 3 8 #() 562 193 193 nil 27 1330 #{Core.IdentityDictionary} 50 4 1552 8 'detail' 144 8 'styles' 518 #{Graphics.Rectangle} 562 1 1 562 1 1 322 50 1 370 #createWindow: 50 1 418 450 8 #[255 14 0 0 10 0 0 0 161 16 0 0 115 1 0 0] 193 80 8 'Text Styles' 32 1 50 2 144 1552 562 193 193 nil 27)! !

!UI.Scintilla.StylesCollectionPresenter class categoriesForMethods!
customDraw:!helpers!public! !
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

