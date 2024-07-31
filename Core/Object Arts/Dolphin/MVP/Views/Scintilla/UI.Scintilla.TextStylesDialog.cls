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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 21 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 210 1 1 18 #{UI.StaticRectangle} 50 14 nil 240 50 2 8 1140850960 1 320 nil nil nil 5 nil nil nil 320 nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 154 1 0 0 2 0 0 0] 193 352 8 '' 320 434 #isEnabled: 8 #(false) 320 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 nil nil nil 18 #{UI.ReferenceView} 50 14 nil 240 50 2 8 1140850688 131073 656 nil nil nil 5 nil nil nil 656 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 386 50 1 434 #createWindow: 50 1 482 514 8 #[0 0 0 0 2 0 0 0 154 1 0 0 40 0 0 0] 193 688 8 '' 656 3 8 #() 626 193 193 nil 27 550 #{Core.IdentityDictionary} 0 nil 386 50 1 434 #createWindow: 50 1 482 514 8 #[10 0 0 0 112 1 0 0 164 1 0 0 152 1 0 0] 193 272 8 '' 240 3 50 2 320 656 626 193 193 nil 27 nil nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 1104 nil nil nil 5 nil nil nil 1104 722 #{UI.Scintilla.StylesCollectionPresenter} #resource_Default_view nil 386 50 1 434 #createWindow: 50 1 482 514 8 #[10 0 0 0 10 0 0 0 164 1 0 0 102 1 0 0] 193 1136 8 '' 1104 3 880 626 193 193 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} 912 50 2 1104 8 'styles' 518 #{Graphics.Rectangle} 626 21 21 626 21 21 nil nil nil nil 1 nil nil nil 626 885 915 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 386 50 2 434 #createWindow: 50 1 518 #{UI.CreateDialog} 1394 626 7679 21 626 8571 935 193 32 434 #setWindowText: 50 1 8 'Text Styles' 32 1 50 2 1104 240 626 193 193 nil 29)! !

!UI.Scintilla.TextStylesDialog class categoriesForMethods!
defaultModel!constants!public! !
icon!accessing!constants!public! !
resource_Default_view!public!resources-views! !
!

