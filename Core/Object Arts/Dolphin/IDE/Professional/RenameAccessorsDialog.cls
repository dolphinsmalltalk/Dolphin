"Filed out from Dolphin Smalltalk 7"!

ValueDialog subclass: #RenameAccessorsDialog
	instanceVariableNames: 'selectorsPresenter scopePresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RenameAccessorsDialog guid: (GUID fromString: '{0131b7a6-c39c-4be0-b124-1004a06770da}')!
RenameAccessorsDialog comment: ''!
!RenameAccessorsDialog categoriesForClass!MVP-Presenters! !
!RenameAccessorsDialog methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	selectorsPresenter := self add: ListPresenter new name: 'selectors'.
	scopePresenter := self add: ChoicePresenter new name: 'scope'.

!

model: anObject 
	"Set the model associated with the receiver."

	super model: anObject.
	scopePresenter choices: self scopeNames.
	scopePresenter model: self model!

scopeNames
	^#(#None #Global #Hierarchy #'Package(s)' #Class #'Method(s)')!

selectors: aCollection
	selectorsPresenter model: aCollection! !
!RenameAccessorsDialog categoriesFor: #createComponents!initializing!public! !
!RenameAccessorsDialog categoriesFor: #model:!accessing!public! !
!RenameAccessorsDialog categoriesFor: #scopeNames!constants!public! !
!RenameAccessorsDialog categoriesFor: #selectors:!public! !

!RenameAccessorsDialog class methodsFor!

defaultModel
	^#None!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 31 283 594 739 71 656 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 141 0 0 0 128 1 0 0 176 0 0 0] 8 #() 594 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 976 nil 721158 ##(Smalltalk.SystemColor) 31 nil 7 nil nil nil 976 852230 ##(Smalltalk.FramingLayout) 170 176 34 10 410 ##(Smalltalk.ComboBox) 34 17 nil 976 34 2 8 1144063491 1025 1136 590662 2 ##(Smalltalk.ListModel) 138 144 944 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 496 nil 7 nil nil nil 1136 nil 8 1906654144 459270 ##(Smalltalk.Message) #displayString 8 #() 944 301 754 138 144 34 1 818 #createAt:extent: 34 2 594 469 115 594 271 47 1136 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 234 0 0 0 57 0 0 0 113 1 0 0 80 0 0 0] 8 #() 960 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 29 1554 #fixedParentRight 1 1554 #fixedPreviousTop 11 1554 #fixedViewTop 43 410 ##(Smalltalk.StaticText) 34 16 nil 976 34 2 8 1140850944 1 1632 nil nil nil 7 nil nil nil 1632 nil 8 1906774720 852486 ##(Smalltalk.NullConverter) nil nil nil 754 138 144 34 2 818 #createAt:extent: 34 2 594 1 105 594 441 81 1632 818 #text: 34 1 8 'Please choose the scope (if any) in which these accessors should be renamed:' 1632 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 220 0 0 0 92 0 0 0] 8 #() 960 nil 27 1522 1554 #fixedParentLeft 1 1554 #fixedViewLeft 441 1554 #fixedPreviousBottom 25 1616 81 410 ##(Smalltalk.ListBox) 34 17 nil 976 34 2 8 1144062209 262145 2016 1202 138 144 944 nil 1264 466 496 nil 7 nil nil nil 2016 nil 8 1906660928 1314 #displayString 8 #() 944 false 754 138 144 34 2 818 #createAt:extent: 34 2 594 471 1 594 271 81 2016 818 #horizontalExtent: 8 #(0) 2016 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 0 0 0 0 114 1 0 0 40 0 0 0] 8 #() 960 nil 27 1522 1568 31 1584 3 1600 -13 1616 81 410 ##(Smalltalk.CheckBox) 34 16 nil 976 34 2 8 1140927779 1 2384 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false 466 496 nil 7 nil nil nil 2384 nil 8 1906824432 1714 nil nil nil 754 138 144 34 3 818 #createAt:extent: 34 2 594 1 195 594 491 43 2384 818 #isEnabled: 8 #(false) 2384 818 #text: 34 1 8 'Show proposed changes?' 2384 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 97 0 0 0 245 0 0 0 118 0 0 0] 8 #() 960 nil 27 1522 1968 1 1984 491 2000 39 1616 43 410 ##(Smalltalk.StaticText) 34 16 nil 976 34 2 8 1140850944 1 2816 nil nil nil 7 nil nil nil 2816 nil 8 1906774720 1714 nil nil nil 754 138 144 34 2 818 #createAt:extent: 34 2 594 1 15 594 441 71 2816 818 #text: 34 1 8 'The following potential accessors for the variable were identified:

' 2816 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 7 0 0 0 220 0 0 0 42 0 0 0] 8 #() 960 nil 27 1522 1968 1 1984 441 1554 #fixedParentTop 15 1616 71 170 192 34 4 2016 8 'selectors' 1136 8 'scope' nil 754 138 144 34 1 818 #createAt:extent: 34 2 594 31 31 594 739 253 976 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 15 0 0 0 128 1 0 0 141 0 0 0] 34 5 2816 2016 1632 1136 2384 960 nil 27 170 192 944 590342 ##(Smalltalk.Rectangle) 594 31 31 594 31 31 nil nil nil nil 24367 nil nil 594 2049 461 594 831 461 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010075552 754 138 144 34 3 818 #createAt:extent: 34 2 594 3839 21 594 831 461 416 818 #text: 34 1 8 'Rename instance variable ...' 416 818 #updateMenuBar 944 416 898 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 30 9 0 0 240 0 0 0] 34 2 656 976 960 nil 27 )! !
!RenameAccessorsDialog class categoriesFor: #defaultModel!public! !
!RenameAccessorsDialog class categoriesFor: #resource_Default_view!public!resources-views! !

