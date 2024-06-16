"Filed out from Dolphin Smalltalk"!

ValueDialog subclass: #ScintillaTextStylesDialog
	instanceVariableNames: 'stylesPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ScintillaTextStylesDialog guid: (GUID fromString: '{e768b8d3-ca27-4c94-b60d-7fbf3dd4e34a}')!

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

!ScintillaTextStylesDialog categoriesForMethods!
createComponents!initializing!private! !
defaultStyle!accessing!public! !
defaultStyle:!accessing!public! !
model:!accessing!public! !
onStylesChanged!event handling!private! !
!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 21 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 578 1 1 410 ##(Smalltalk.StaticRectangle) 34 14 nil 608 34 2 8 1140850960 1 688 nil nil nil 5 nil nil nil 688 nil 8 1759212608 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 152 1 0 0 2 0 0 0] 193 720 nil 688 834 #isEnabled: 8 #(false) 688 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 608 34 2 8 1140850688 131073 1040 nil nil nil 5 nil nil nil 1040 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 2 0 0 0 154 1 0 0 40 0 0 0] 193 1072 8 '' 1040 3 8 #() 1010 193 193 nil 27 170 192 1280 nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[10 0 0 0 112 1 0 0 164 1 0 0 152 1 0 0] 193 640 8 '' 608 3 34 2 688 1040 1010 193 193 nil 27 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1504 nil nil nil 5 nil nil nil 1504 1106 ##(Smalltalk.ScintillaStylesCollectionPresenter) #resource_Default_view nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[10 0 0 0 10 0 0 0 164 1 0 0 102 1 0 0] 193 1536 8 '' 1504 3 1280 1010 193 193 nil 27 170 192 34 2 1504 8 'styles' 590342 ##(Smalltalk.Rectangle) 1010 21 21 1010 21 21 nil nil nil nil 13179 nil nil nil 1010 885 915 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 770 138 144 34 2 834 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 1794 1010 1 1 1010 893 915 193 416 834 #setWindowText: 34 1 8 'Text Styles' 416 1 34 2 1504 608 1010 193 193 nil 29 )! !

!ScintillaTextStylesDialog class categoriesForMethods!
defaultModel!constants!public! !
icon!accessing!constants!public! !
resource_Default_view!public!resources-views! !
!

