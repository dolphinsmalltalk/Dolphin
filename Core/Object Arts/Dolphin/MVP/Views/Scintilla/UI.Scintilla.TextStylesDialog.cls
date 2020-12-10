"Filed out from Dolphin Smalltalk 7"!

UI.ValueDialog subclass: #'UI.Scintilla.TextStylesDialog'
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
!UI.Scintilla.TextStylesDialog categoriesFor: #createComponents!initializing!private! !
!UI.Scintilla.TextStylesDialog categoriesFor: #defaultStyle!accessing!public! !
!UI.Scintilla.TextStylesDialog categoriesFor: #defaultStyle:!accessing!public! !
!UI.Scintilla.TextStylesDialog categoriesFor: #model:!accessing!public! !
!UI.Scintilla.TextStylesDialog categoriesFor: #onStylesChanged!event handling!private! !

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Graphics.ThemeColor) #dialog nil 165 nil 263174 ##(Graphics.Font) nil true 524550 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Graphics.Point) 193 193 nil 416 788230 ##(UI.BorderLayout) 1 21 nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 610 1 1 410 ##(UI.StaticRectangle) 34 14 nil 640 34 2 8 1140850960 1 720 nil nil nil 7 nil nil nil 720 nil 8 1867478992 983302 ##(Core.MessageSequence) 138 144 34 2 721670 ##(Core.MessageSend) #createAt:extent: 34 2 578 1 1 578 821 5 720 866 #isEnabled: 8 #(false) 720 983302 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 154 1 0 0 2 0 0 0] 8 #() 578 193 193 nil 27 nil nil nil 410 ##(UI.ReferenceView) 34 14 nil 640 34 2 8 1140850688 131073 1056 nil nil nil 7 nil nil nil 1056 1180230 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 802 138 144 34 1 866 #createAt:extent: 34 2 578 1 5 578 821 77 1056 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 154 1 0 0 40 0 0 0] 8 #() 1040 nil 27 170 192 1296 nil 802 138 144 34 1 866 #createAt:extent: 34 2 578 21 737 578 821 81 640 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 112 1 0 0 164 1 0 0 152 1 0 0] 34 2 720 1056 1040 nil 27 nil nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1488 nil nil nil 7 nil nil nil 1488 1122 ##(UI.Scintilla.StylesCollectionPresenter) #resource_Default_view nil 802 138 144 34 1 866 #createAt:extent: 34 2 578 21 21 578 821 697 1488 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 164 1 0 0 102 1 0 0] 1296 1040 nil 27 170 192 34 2 1488 8 'styles' 590342 ##(Graphics.Rectangle) 578 21 21 578 21 21 nil nil nil nil 10207 nil nil nil 578 885 915 1 nil nil 590598 ##(Core.Semaphore) nil nil 1 nil 8 2007860128 802 138 144 34 2 866 #createAt:extent: 34 2 578 7039 21 578 893 915 416 866 #text: 34 1 8 'Text Styles' 416 978 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 125 15 0 0 211 1 0 0] 34 2 1488 640 1040 nil 27)! !
!UI.Scintilla.TextStylesDialog class categoriesFor: #defaultModel!constants!public! !
!UI.Scintilla.TextStylesDialog class categoriesFor: #icon!accessing!constants!public! !
!UI.Scintilla.TextStylesDialog class categoriesFor: #resource_Default_view!public!resources-views! !

