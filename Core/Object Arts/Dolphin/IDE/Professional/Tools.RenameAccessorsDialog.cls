"Filed out from Dolphin Smalltalk 7"!

ValueDialog subclass: #RenameAccessorsDialog
	instanceVariableNames: 'selectorsPresenter scopePresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 165 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 31 283 578 739 71 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 141 0 0 0 128 1 0 0 176 0 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 7 nil nil nil 960 852230 ##(Smalltalk.FramingLayout) 170 176 34 10 410 ##(Smalltalk.CheckBox) 34 16 nil 960 34 2 8 1140927779 1 1088 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 7 nil nil nil 1088 nil 8 1903885040 852486 ##(Smalltalk.NullConverter) nil nil nil 738 138 144 34 3 802 #createAt:extent: 34 2 578 1 195 578 491 43 1088 802 #isEnabled: 8 #(false) 1088 802 #text: 34 1 8 'Show proposed changes?' 1088 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 97 0 0 0 245 0 0 0 118 0 0 0] 8 #() 944 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1538 #fixedViewLeft 491 1538 #fixedPreviousBottom 39 1538 #fixedViewTop 43 410 ##(Smalltalk.ListBox) 34 17 nil 960 34 2 8 1144062209 262145 1616 590662 2 ##(Smalltalk.ListModel) 138 144 928 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 1616 nil 8 1903732064 459270 ##(Smalltalk.Message) #displayString 8 #() 928 false 738 138 144 34 2 802 #createAt:extent: 34 2 578 471 1 578 271 81 1616 802 #horizontalExtent: 8 #(0) 1616 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 0 0 0 0 114 1 0 0 40 0 0 0] 8 #() 944 nil 27 1506 1538 #fixedPreviousRight 31 1538 #fixedParentRight 3 1538 #fixedPreviousTop -13 1600 81 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850944 1 2112 nil nil nil 7 nil nil nil 2112 nil 8 1903849936 1234 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 15 578 441 71 2112 802 #text: 34 1 8 'The following potential accessors for the variable were identified:

' 2112 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 7 0 0 0 220 0 0 0 42 0 0 0] 8 #() 944 nil 27 1506 1552 1 1568 441 1538 #fixedParentTop 15 1600 71 410 ##(Smalltalk.ComboBox) 34 17 nil 960 34 2 8 1144063491 1025 2448 1682 138 144 928 nil 1744 1776 nil 7 nil nil nil 2448 nil 8 1903738896 1810 #displayString 8 #() 928 301 738 138 144 34 1 802 #createAt:extent: 34 2 578 469 115 578 271 47 2448 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 234 0 0 0 57 0 0 0 113 1 0 0 80 0 0 0] 8 #() 944 nil 27 1506 2064 29 2080 1 2096 11 1600 43 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850944 1 2768 nil nil nil 7 nil nil nil 2768 nil 8 1903849936 1234 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 105 578 441 81 2768 802 #text: 34 1 8 'Please choose the scope (if any) in which these accessors should be renamed:' 2768 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 220 0 0 0 92 0 0 0] 8 #() 944 nil 27 1506 1552 1 1568 441 1584 25 1600 81 170 192 34 4 2448 8 'scope' 1616 8 'selectors' nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 31 31 578 739 253 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 15 0 0 0 128 1 0 0 141 0 0 0] 34 5 2112 1616 2768 2448 1088 944 nil 27 170 192 928 590342 ##(Smalltalk.Rectangle) 578 31 31 578 31 31 nil nil nil nil 12825 nil nil 578 2049 461 578 831 461 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 1998684880 738 138 144 34 3 802 #createAt:extent: 34 2 578 3839 21 578 831 461 416 802 #text: 34 1 8 'Rename instance variable ...' 416 802 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 30 9 0 0 240 0 0 0] 34 2 640 960 944 nil 27 )! !
!RenameAccessorsDialog class categoriesFor: #defaultModel!public! !
!RenameAccessorsDialog class categoriesFor: #resource_Default_view!public!resources-views! !

