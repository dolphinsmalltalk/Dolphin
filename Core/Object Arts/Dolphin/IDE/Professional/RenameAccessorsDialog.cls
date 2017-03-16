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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 84 97 104 111 109 97 0 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 672 0 0 0 7 0 0 0 672 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 610 31 299 610 679 71 672 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 149 0 0 0 98 1 0 0 184 0 0 0] 98 0 610 193 193 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 1056 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 1056 852230 ##(Smalltalk.FramingLayout)  234 240 98 10 410 8 ##(Smalltalk.CheckBox)  98 16 0 1056 98 2 8 1140927779 1 1232 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  32 482 512 0 7 0 0 0 1232 0 8 4294903631 852486 ##(Smalltalk.NullConverter)  0 0 0 818 202 208 98 3 882 912 98 2 610 1 195 610 435 43 1232 882 8 #isEnabled: 98 1 32 1232 882 8 #text: 98 1 8 'Show proposed changes?' 1232 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 97 0 0 0 217 0 0 0 118 0 0 0] 98 0 1040 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft 1 1746 8 #fixedViewLeft 435 1746 8 #fixedPreviousBottom 39 1746 8 #fixedViewTop 43 410 8 ##(Smalltalk.ComboBox)  98 17 0 1056 98 2 8 1144063491 1025 1888 590662 2 ##(Smalltalk.ListModel)  202 208 1024 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 512 0 7 0 0 0 1888 0 8 4294903803 459270 ##(Smalltalk.Message)  8 #displayString 98 0 1024 301 818 202 208 98 1 882 912 98 2 610 409 115 610 271 43 1888 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 204 0 0 0 57 0 0 0 83 1 0 0 78 0 0 0] 98 0 1040 0 27 1714 1746 8 #fixedPreviousRight 29 1746 8 #fixedParentRight 1 1746 8 #fixedPreviousTop 11 1856 43 410 8 ##(Smalltalk.StaticText)  98 16 0 1056 98 2 8 1140850944 1 2416 0 0 0 7 0 0 0 2416 0 8 4294903625 1410 0 0 0 818 202 208 98 2 882 912 98 2 610 1 105 610 381 81 2416 882 1616 98 1 8 'Please choose the scope (if any) in which you would like these accessors renamed:' 2416 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 190 0 0 0 92 0 0 0] 98 0 1040 0 27 1714 1760 1 1792 381 1824 25 1856 81 410 2432 98 16 0 1056 98 2 8 1140850944 1 2752 0 0 0 7 0 0 0 2752 0 8 4294903625 1410 0 0 0 818 202 208 98 2 882 912 98 2 610 1 15 610 381 71 2752 882 1616 98 1 8 'The following potential accessors for the variable were identified:

' 2752 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 7 0 0 0 190 0 0 0 42 0 0 0] 98 0 1040 0 27 1714 1760 1 1792 381 1746 8 #fixedParentTop 15 1856 71 410 8 ##(Smalltalk.ListBox)  98 17 0 1056 98 2 8 1144062209 262145 3104 1970 202 208 1024 0 2032 482 512 0 7 0 0 0 3104 0 8 4294903955 2082 2112 98 0 1024 32 818 202 208 98 2 882 912 98 2 610 411 1 610 271 81 3104 882 8 #horizontalExtent: 98 1 1 3104 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 205 0 0 0 0 0 0 0 84 1 0 0 40 0 0 0] 98 0 1040 0 27 1714 2320 31 2352 3 2384 -13 1856 81 234 256 98 4 1888 8 'scope' 3104 8 'selectors' 0 818 202 208 98 1 882 912 98 2 610 31 31 610 679 269 1056 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 15 0 0 0 98 1 0 0 149 0 0 0] 98 5 2752 3104 2416 1888 1232 1040 0 27 234 256 1024 590342 ##(Smalltalk.Rectangle)  610 31 31 610 31 31 0 0 0 0 26543 0 0 0 0 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 818 202 208 98 3 882 912 98 2 610 2799 21 610 751 463 416 882 1616 98 1 8 'Rename instance variable ...' 416 882 8 #updateMenuBar 1024 416 978 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 238 6 0 0 241 0 0 0] 98 2 672 1056 1040 0 27 )! !
!RenameAccessorsDialog class categoriesFor: #defaultModel!public! !
!RenameAccessorsDialog class categoriesFor: #resource_Default_view!public!resources-views! !

