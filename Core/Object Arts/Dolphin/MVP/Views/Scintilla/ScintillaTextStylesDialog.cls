"Filed out from Dolphin Smalltalk X6"!

ValueDialog subclass: #ScintillaTextStylesDialog
	instanceVariableNames: 'stylesPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaTextStylesDialog guid: (GUID fromString: '{E768B8D3-CA27-4C94-B60D-7FBF3DD4E34A}')!
ScintillaTextStylesDialog comment: 'ScintillaTextStylesDialog is a <valueDialogPresenter> that can be used to edit a collection of <ScintillaTextStyles> in order to configure the visual styles in a <ScintillaView>. It is intended for use in applications, and so does not allow the addition or removal of styles, nor the editing of style names. However this could be changed by defining a different view that used the ScintillaStylesCollectionPresenter ''Developer view'' instead of the ''Default view''.

For example usage see the XmlPad sample.

Instance Variables:
	stylesPresenter		<ScintillaStylesCollectionPresenter>
'!
!ScintillaTextStylesDialog categoriesForClass!MVP-Presenters! !
!ScintillaTextStylesDialog methodsFor!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	stylesPresenter := self add: ScintillaStylesCollectionPresenter new name: 'styles'!

defaultStyle
	^stylesPresenter defaultStyle!

defaultStyle: aScintillaTextStyle 
	"Set the default style to be used for style facets for which no setting is specified, i.e.
	this style specifies the style facets that will be inherited from the view settings
	Typically this will include the font and background color. These style facets are then
	overridden by first the #normal style, and then any specific style. "

	stylesPresenter defaultStyle: aScintillaTextStyle!

model: aSubjectModel 
	"Connect the receiver to aSubjectModel. The reply presenter shares this
	same model since it is responsible for editing it's value"

	| styles |
	super model: aSubjectModel.
	styles := ((self model value collect: [:each | each copy]) 
				asSortedCollection: [:a :b | a name <= b name]) asValue.
	#todo.	"Sort out CollectionPresenter so don't need to use NeverSearchPolicy - problem is that it won't trigger any changes
	without this when the list is edited, since it compares the current value against itself"
	styles comparisonPolicy: SearchPolicy never.
	stylesPresenter model: styles.
	styles 
		when: #valueChanged
		send: #onStylesChanged
		to: self!

onStylesChanged
	"The style collection (a copy) has been changed, so transfer this across to the receiver's value buffer."

	self value: stylesPresenter value! !
!ScintillaTextStylesDialog categoriesFor: #createComponents!initializing!private! !
!ScintillaTextStylesDialog categoriesFor: #defaultStyle!accessing!public! !
!ScintillaTextStylesDialog categoriesFor: #defaultStyle:!accessing!public! !
!ScintillaTextStylesDialog categoriesFor: #model:!accessing!public! !
!ScintillaTextStylesDialog categoriesFor: #onStylesChanged!event handling!private! !

!ScintillaTextStylesDialog class methodsFor!

defaultModel
	^OrderedCollection with: ScintillaTextStyle normal!

icon
	"Answers an Icon that can be used to represent this class."

	^ScintillaTextStyle icon
!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(DialogView)  98 30 0 0 98 2 26738689 131073 416 0 524550 ##(ColorRef)  8 4278190080 0 133 0 0 0 416 788230 ##(BorderLayout)  1 21 0 410 8 ##(ContainerView)  98 15 0 416 98 2 8 1140850688 131073 560 0 0 0 5 0 0 0 560 530 1 1 410 8 ##(StaticRectangle)  98 14 0 560 98 2 8 1140850960 1 656 0 0 0 5 0 0 0 656 0 8 4294906439 983302 ##(MessageSequence)  202 208 98 2 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  1 1 882 837 5 656 818 8 #isEnabled: 98 1 32 656 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 162 1 0 0 2 0 0 0] 98 0 882 193 193 0 27 0 0 0 410 8 ##(ReferenceView)  98 14 0 560 98 2 8 1140850688 131073 1056 0 0 0 5 0 0 0 1056 1180166 ##(ResourceIdentifier)  8 ##(Presenter)  8 #resource_OK_Cancel_button_block 0 754 202 208 98 1 818 848 98 2 882 1 5 882 837 77 1056 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 162 1 0 0 40 0 0 0] 98 0 1040 0 27 234 256 1344 0 754 202 208 98 1 818 848 98 2 882 21 761 882 837 81 560 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 124 1 0 0 172 1 0 0 164 1 0 0] 98 2 656 1056 1040 0 27 0 0 410 1072 98 14 0 416 98 2 8 1140850688 131073 1536 0 0 0 5 0 0 0 1536 1138 8 ##(ScintillaStylesCollectionPresenter)  8 #resource_Default_view 0 754 202 208 98 1 818 848 98 2 882 21 21 882 837 721 1536 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 172 1 0 0 114 1 0 0] 1344 1040 0 27 234 256 98 2 1536 8 'styles' 590342 ##(Rectangle)  882 21 21 882 21 21 0 0 0 0 14555 0 0 0 882 885 915 1 0 0 590598 ##(Semaphore)  0 0 1 0 8 2010572111 754 202 208 98 3 818 848 98 2 882 1155 743 882 893 915 416 818 8 #text: 98 1 8 'Text Styles' 416 818 8 #menuBar: 98 1 0 416 978 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 2 0 0 115 1 0 0 255 3 0 0 60 3 0 0] 98 2 1536 560 1040 0 27 )! !
!ScintillaTextStylesDialog class categoriesFor: #defaultModel!constants!public! !
!ScintillaTextStylesDialog class categoriesFor: #icon!accessing!constants!public! !
!ScintillaTextStylesDialog class categoriesFor: #resource_Default_view!public!resources-views! !

