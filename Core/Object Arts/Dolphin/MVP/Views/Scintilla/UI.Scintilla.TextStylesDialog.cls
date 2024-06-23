"Filed out from Dolphin Smalltalk"!

UI.ValueDialog
	subclass: #'UI.Scintilla.TextStylesDialog'
	instanceVariableNames: 'stylesPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Scintilla.TextStylesDialog guid: (Core.GUID fromString: '{e768b8d3-ca27-4c94-b60d-7fbf3dd4e34a}')!

UI.Scintilla.TextStylesDialog comment: 'ScintillaTextStylesDialog is a <valueDialogPresenter> that can be used to edit a collection of <ScintillaTextStyles> in order to configure the visual styles in a <ScintillaView>. It is intended for use in applications, and so does not allow the addition or removal of styles, nor the editing of style names. However this could be changed by defining a different view that used the ScintillaStylesCollectionPresenter ''Developer view'' instead of the ''Default view''.

For example usage see the XmlPad sample.

Instance Variables:
	stylesPresenter		<ScintillaStylesCollectionPresenter>
'!

!UI.Scintilla.TextStylesDialog categoriesForClass!MVP-Presenters! !

!UI.Scintilla.TextStylesDialog methodsFor!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	stylesPresenter := self add: StylesCollectionPresenter new name: 'styles'!

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
	same model since it is responsible for editing its value"

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

!UI.Scintilla.TextStylesDialog categoriesForMethods!
createComponents!initializing!private! !
defaultStyle!accessing!public! !
defaultStyle:!accessing!public! !
model:!accessing!public! !
onStylesChanged!event handling!private! !
!

!UI.Scintilla.TextStylesDialog class methodsFor!

defaultModel
	^OrderedCollection with: TextStyle normal!

icon
	"Answers an Icon that can be used to represent this class."

	^TextStyle icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 21 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 242 1 1 18 #{UI.StaticRectangle} 50 14 nil 272 50 2 8 1140850960 1 352 nil nil nil 5 nil nil nil 352 nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 1 1 210 821 5 352 466 #isEnabled: 8 #(false) 352 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 154 1 0 0 2 0 0 0] 8 #() 210 193 193 nil 27 nil nil nil 18 #{UI.ReferenceView} 50 14 nil 272 50 2 8 1140850688 131073 656 nil nil nil 5 nil nil nil 656 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 418 50 1 466 #createAt:extent: 50 2 210 1 5 210 821 77 656 578 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 154 1 0 0 40 0 0 0] 8 #() 640 nil 27 550 #{Core.IdentityDictionary} 0 nil 418 50 1 466 #createAt:extent: 50 2 210 21 737 210 821 81 272 578 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 112 1 0 0 164 1 0 0 152 1 0 0] 50 2 352 656 640 nil 27 nil nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 1072 nil nil nil 5 nil nil nil 1072 722 #{UI.Scintilla.StylesCollectionPresenter} #resource_Default_view nil 418 50 1 466 #createAt:extent: 50 2 210 21 21 210 821 697 1072 578 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 164 1 0 0 102 1 0 0] 880 640 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} 896 50 2 1072 8 'styles' 518 #{Graphics.Rectangle} 210 21 21 210 21 21 nil nil nil nil 1 nil nil nil 210 885 915 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 418 50 2 466 #createAt:extent: 50 2 210 6143 21 210 893 915 32 466 #text: 50 1 8 'Text Styles' 32 578 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 189 13 0 0 211 1 0 0] 50 2 1072 272 640 nil 27)! !

!UI.Scintilla.TextStylesDialog class categoriesForMethods!
defaultModel!constants!public! !
icon!accessing!constants!public! !
resource_Default_view!public!resources-views! !
!

