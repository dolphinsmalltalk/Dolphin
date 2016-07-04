"Filed out from Dolphin Smalltalk 7"!

AXValueConvertingControlSite subclass: #MonthView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MonthView guid: (GUID fromString: '{C253BF6B-D8EA-4A15-BABB-79FC15F4F800}')!
MonthView comment: 'MonthView is an Active-X control which displays dates in traditional month calendar form, and which can be used to choose new dates.

**N.B. This class depends on having the MS common controls installed, which they commonly are, especially if a Microsoft Visual Studio product (such as VB) is installed on the machine.

If this view class is used in an application then it is necessary to distribute MSCOMCT2.OCX. Note that this Active-X control may be licensed. A Microsoft Installer merge module for the control is available for download from Microsoft (mscomct2.msm).'!
!MonthView categoriesForClass!MVP-Views! !
!MonthView methodsFor!

backcolor
	"Answers the background colour of the receiver"

	| color |
	color := self controlDispatch backColor.
	^color = Color window asColorRef ifFalse: [color]!

backcolor: color 
	"Sets the background colour of the receiver to the <Color>, color.
	Implementation Note: The control ignores the ambient property."

	self controlDispatch backColor: color!

defaultProgId
	"Answer the 'prog id' of the MS Month View Active-X control to be hosted in the receiver by default"

	^'MSComCtl2.MonthView'!

forecolor
	"Answers the foreground colour of the receiver"

	^forecolor!

forecolor: aColor
	"Sets the foreground colour of the receiver to the <Color>, color.
	Implementation Note: The control ignores the ambient property."

	self controlDispatch foreColor: aColor
!

monthBackColor
	^self controlDispatch monthBackColor!

monthBackColor: aColor
	^self controlDispatch monthBackColor: aColor!

monthColumns
	^self controlDispatch monthColumns!

monthRows
	^self controlDispatch monthRows!

usesAmbientColors
	"Answer whether this control makes use of the ambient foreground and background color
	properties. If it doesn't then there is no point attempting to set them."

	^false! !
!MonthView categoriesFor: #backcolor!accessing!public! !
!MonthView categoriesFor: #backcolor:!accessing!public! !
!MonthView categoriesFor: #defaultProgId!constants!public! !
!MonthView categoriesFor: #forecolor!accessing!public! !
!MonthView categoriesFor: #forecolor:!accessing!public! !
!MonthView categoriesFor: #monthBackColor!accessing!public! !
!MonthView categoriesFor: #monthBackColor:!accessing!public! !
!MonthView categoriesFor: #monthColumns!accessing!public! !
!MonthView categoriesFor: #monthRows!accessing!public! !
!MonthView categoriesFor: #usesAmbientColors!public!testing! !

!MonthView class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^DATE now asValue!

icon
	^Icon fromId: 6 in: (ExternalResourceLibrary open: 'MSCOMCT2.OCX')!

publishedAspectsOfInstances
	"Answer a <LookupTable> of the <Aspect>s published by instances of the receiver."

	| aspects aspectClass |
	aspects := super publishedAspectsOfInstances.
	#(#firesControlEvents #isDesignMode #progId #isDefault #licenseKey #value) 
		do: [:a | aspects removeKey: a ifAbsent: []].
	aspectClass := Smalltalk at: #Aspect.
	^aspects
		add: (aspectClass color: #monthBackColor);
		add: (aspectClass integer: #monthColumns);
		add: (aspectClass integer: #monthRows);
		yourself! !
!MonthView class categoriesFor: #defaultModel!models!public! !
!MonthView class categoriesFor: #icon!constants!public! !
!MonthView class categoriesFor: #publishedAspectsOfInstances!constants!development!public! !

