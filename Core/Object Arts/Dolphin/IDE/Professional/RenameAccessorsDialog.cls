"Filed out from Dolphin Smalltalk"!

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

!RenameAccessorsDialog categoriesForMethods!
createComponents!initializing!public! !
model:!accessing!public! !
scopeNames!constants!public! !
selectors:!public! !
!

!RenameAccessorsDialog class methodsFor!

defaultModel
	^#None!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[15 0 0 0 141 0 0 0 128 1 0 0 176 0 0 0] 193 640 8 '' 608 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 5 nil nil nil 960 852230 ##(Smalltalk.FramingLayout) 170 176 34 10 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850944 1 1088 nil nil nil 5 nil nil nil 1088 nil 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 7 0 0 0 220 0 0 0 42 0 0 0] 193 1120 nil 1088 770 #text: 34 1 8 'The following potential accessors for the variable were identified:

' 1088 3 8 #() 930 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1442 #fixedViewLeft 441 1442 #fixedParentTop 15 1442 #fixedViewTop 71 410 ##(Smalltalk.ListBox) 34 17 nil 960 34 2 8 1144062209 262145 1520 590662 2 ##(Smalltalk.ListModel) 138 144 912 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 1520 nil 8 1758868288 459270 ##(Smalltalk.Message) #displayString 8 #() 8 #() false 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[235 0 0 0 0 0 0 0 114 1 0 0 40 0 0 0] 193 1552 8 '' 1520 3 8 #() 930 193 193 nil 27 1410 1442 #fixedPreviousRight 31 1442 #fixedParentRight 3 1442 #fixedPreviousTop -13 1504 81 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850944 1 2016 nil nil nil 5 nil nil nil 2016 nil 8 1759212608 1170 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 52 0 0 0 220 0 0 0 92 0 0 0] 193 2048 nil 2016 770 #text: 34 1 8 'Please choose the scope (if any) in which these accessors should be renamed:' 2016 3 8 #() 930 193 193 nil 27 1410 1456 1 1472 441 1442 #fixedPreviousBottom 25 1504 81 410 ##(Smalltalk.ComboBox) 34 17 nil 960 34 2 8 1144063491 1025 2352 1586 138 144 912 nil 1648 1680 nil 5 nil nil nil 2352 nil 8 1758616864 1714 #displayString 8 #() 1760 301 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[234 0 0 0 57 0 0 0 113 1 0 0 230 0 0 0] 193 2384 8 '' 2352 3 8 #() 930 193 193 nil 27 1410 1968 29 1984 1 2000 11 1504 43 410 ##(Smalltalk.CheckBox) 34 16 nil 960 34 2 8 1140927779 1 2688 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 2688 nil 8 1759007584 1170 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 97 0 0 0 245 0 0 0 118 0 0 0] 193 2720 8 'Show proposed changes?' 2688 770 #isEnabled: 8 #(false) 2688 3 8 #() 930 193 193 nil 27 1410 1456 1 1472 491 2336 39 1504 43 170 192 34 4 2352 8 'scope' 1520 8 'selectors' nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[15 0 0 0 15 0 0 0 128 1 0 0 141 0 0 0] 193 992 8 '' 960 3 34 5 1088 1520 2016 2352 2688 930 193 193 nil 27 170 192 912 590342 ##(Smalltalk.Rectangle) 930 31 31 930 31 31 nil nil nil nil 12613 nil nil 930 2049 461 930 831 461 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 3330 930 1 1 930 831 461 193 416 770 #setWindowText: 34 1 8 'Rename instance variable ...' 416 1 34 2 608 960 930 193 193 nil 29 )! !

!RenameAccessorsDialog class categoriesForMethods!
defaultModel!public! !
resource_Default_view!public!resources-views! !
!

