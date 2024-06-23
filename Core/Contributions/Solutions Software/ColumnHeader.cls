"Filed out from Dolphin Smalltalk"!

Object subclass: #ColumnHeader
	instanceVariableNames: 'parent index dropDownMenu'
	classVariableNames: ''
	poolDictionaries: 'HeaderViewConstants'
	classInstanceVariableNames: ''!

ColumnHeader guid: (GUID fromString: '{9bd93348-662b-499a-84fe-75576dbd2f21}')!

ColumnHeader comment: ''!

!ColumnHeader categoriesForClass!Kernel-Objects! !

!ColumnHeader methodsFor!

alignment

	| style |

	style := self style bitAnd: HDF_JUSTIFYMASK.

	style = HDF_LEFT ifTrue: [^#left].
	style = HDF_RIGHT ifTrue: [^#right].
	style = HDF_CENTER ifTrue: [^#center].

	^self parent errorInCommonControlCall!

alignment: aSymbol

	| mask |

	mask := 
		##(Dictionary new 
			at: #left put: HDF_LEFT;
			at: #right put: HDF_RIGHT;
			at: #center put: HDF_CENTER;
			yourself) at: aSymbol.

	self style: ((self style maskClear: HDF_JUSTIFYMASK) maskSet: mask)!

dropDownMenu

	^dropDownMenu!

dropDownMenu: aMenu

	dropDownMenu := aMenu!

index

	"Private - The 1-based index of the receiver in the header"

	^index!

index: anObject
	index := anObject!

isChecked

	^self style allMask: HDF_CHECKED!

isChecked: aBoolean

	self style: (self style mask: HDF_CHECKED set: aBoolean)!

isCheckStyle

	^self style allMask: HDF_CHECKBOX!

isCheckStyle: aBoolean

	self style: (self style mask: HDF_CHECKBOX set: aBoolean)!

isDropDownStyle

	^self style allMask: HDF_SPLITBUTTON!

isDropDownStyle: aBoolean

	self style: (self style mask: HDF_SPLITBUTTON set: aBoolean)!

onDropDownButtonClicked

	self trigger: #dropDownButtonClicked.

	self dropDownMenu isNil ifTrue: [^nil].

	[self dropDownMenu 
		queryAllFromView: self parent;
		showIn: self parent position: self screenRectangle bottomRight rightAlign: true] postToInputQueue.

	"Suppress further processing"
	^0!

parent

	"Private - The HeaderView in which this column header resides"

	^parent!

parent: anObject
	parent := anObject!

rectangle

	^self parent rectangleForColumnIndex: self index!

screenRectangle
	"Answer the receiver's bounding Rectangle in the parent coordinate system"

	^self parent mapRectangle: self rectangle to: View desktop!

setIsChecked: aBoolean

	self isChecked: aBoolean.
	self trigger: #isChecked: with: aBoolean
!

sortIndicator

	| style |

	style := self style.
	(style allMask: HDF_SORTUP) ifTrue: [^#up].
	(style allMask: HDF_SORTDOWN) ifTrue: [^#down].

	^nil.!

sortIndicator: aSymbol

	| style |

	style := self style maskClear: ##(HDF_SORTUP | HDF_SORTDOWN).
	aSymbol = #up ifTrue: [style := style maskSet: HDF_SORTUP].
	aSymbol = #down ifTrue: [style := style maskSet: HDF_SORTDOWN].

	self style: style!

style

	| item |

	item := HDITEMW new.
	item mask: HDI_FORMAT.

	self parent hdmGetItem: item index: self index - 1.

	^item fmt!

style: anInteger

	| item |

	item := HDITEMW new.
	item 
		mask: HDI_FORMAT;
		fmt: anInteger.

	self parent hdmSetItem: item index: self index - 1! !

!ColumnHeader categoriesForMethods!
alignment!public!style! !
alignment:!public!style! !
dropDownMenu!accessing!public! !
dropDownMenu:!accessing!public! !
index!accessing!private! !
index:!accessing!private! !
isChecked!public!testing! !
isChecked:!public!state! !
isCheckStyle!public!style! !
isCheckStyle:!public!style! !
isDropDownStyle!public!style! !
isDropDownStyle:!public!style! !
onDropDownButtonClicked!event handling!public! !
parent!accessing!private! !
parent:!accessing!private! !
rectangle!geometry!public! !
screenRectangle!geometry!public! !
setIsChecked:!private!state! !
sortIndicator!public!style! !
sortIndicator:!public!style! !
style!accessing!private! !
style:!accessing!private! !
!

