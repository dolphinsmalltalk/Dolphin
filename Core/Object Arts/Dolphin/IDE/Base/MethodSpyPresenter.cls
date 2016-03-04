"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #MethodSpyPresenter
	instanceVariableNames: 'spySourcePresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodSpyPresenter guid: (GUID fromString: '{7C99FB61-40B6-11D6-87E5-0010A70883E2}')!
MethodSpyPresenter comment: ''!
!MethodSpyPresenter categoriesForClass!Unclassified! !
!MethodSpyPresenter methodsFor!

accept

	| newSource oldSource |

	newSource := spySourcePresenter text.
	(newSource isNil or: [newSource isEmpty]) ifTrue: [newSource := '"<no spy source>"'].

	oldSource := self methodSpy spySource.
	self methodSpy spySource: newSource.

	(self spyManager compileSpy: self methodSpy) 
		ifTrue: [self refreshSpySource]
		ifFalse: [self methodSpy spySource: oldSource]!

createComponents

	super createComponents.

	spySourcePresenter := self add: SmalltalkWorkspace new name: 'spySource'!

method

	"Make the receiver polymorphic with a MethodBrowser
	 - in as much as a MethodSpy is polymorphic with a CompiledMethod"

	^self methodSpy!

methodSpy

	^self model value!

onViewOpened

	super onViewOpened.
	self refreshSpySource!

queryCommand: aCommandQuery

	| symbol |

	symbol := aCommandQuery commandSymbol.

	symbol == #accept ifTrue:
		[aCommandQuery isEnabled: (spySourcePresenter isModified or: [self methodSpy isExisting not]).
		^true].

	symbol == #toggleEnabled ifTrue:
		[aCommandQuery isChecked: self methodSpy isEnabled; isEnabled: true.
		^true].

	symbol == #removeSpy ifTrue:
		[aCommandQuery isEnabled: self methodSpy method isSpy.
		^true].

	^super queryCommand: aCommandQuery!

refreshSpySource

	spySourcePresenter text: self model value spySource!

removeSpy

	(MessageBox confirm: 'Remove this Method Spy?') ifFalse: [^self].

	self spyManager removeSpy: self methodSpy.
	self view topView close!

resetSpy

	self methodSpy reset!

spiedMethod

	^self methodSpy method!

spyManager
	^MethodSpyManager current!

toggleEnabled

	self methodSpy isLocallyEnabled: self methodSpy isLocallyEnabled not.

	self spiedMethod isSpy ifTrue: [self spyManager spyChangedIn: self spiedMethod]! !
!MethodSpyPresenter categoriesFor: #accept!accessing!commands!public! !
!MethodSpyPresenter categoriesFor: #createComponents!initializing!public! !
!MethodSpyPresenter categoriesFor: #method!accessing!public! !
!MethodSpyPresenter categoriesFor: #methodSpy!accessing!public! !
!MethodSpyPresenter categoriesFor: #onViewOpened!initializing!public! !
!MethodSpyPresenter categoriesFor: #queryCommand:!accessing!commands!public! !
!MethodSpyPresenter categoriesFor: #refreshSpySource!helpers!public! !
!MethodSpyPresenter categoriesFor: #removeSpy!accessing!commands!public! !
!MethodSpyPresenter categoriesFor: #resetSpy!accessing!commands!public! !
!MethodSpyPresenter categoriesFor: #spiedMethod!accessing!public! !
!MethodSpyPresenter categoriesFor: #spyManager!accessing!public! !
!MethodSpyPresenter categoriesFor: #toggleEnabled!accessing!commands!public! !

!MethodSpyPresenter class methodsFor!

icon
	^MethodSpy icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140853516 131137 576 0 498 528 0 517 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 135 4 60 213 87 1 0 0 204 53 87 1 3 0 20 59 0 0 0 0 15 1 5 86 135 1] 328198 ##(Smalltalk.Point)  193 193 0 576 498 528 8 4294903201 234 256 98 0 234 256 98 8 50077 853766 ##(Smalltalk.ToolbarButton)  50077 0 576 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #removeSpy 8 'Remove this Spy' 1 1 0 395334 3 ##(Smalltalk.Bitmap)  0 16 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.ImageRelativeFileLocator)  8 #current 8 'EditBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 7 754 193 33 11 49865 1115910 ##(Smalltalk.ToolbarIconButton)  49865 0 576 1 914 8 #accept 8 'Accept changes' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1024 8 'FileSave.ico' 1104 978 0 16 0 0 0 0 3 754 33 33 1 49211 1154 49211 0 576 1 914 8 #toggleEnabled 8 'Enable/Disable the Spy' 1 1 1234 0 16 1024 8 'CheckBox.ico' 1104 978 0 16 0 0 0 0 3 754 33 33 1 50091 1154 50091 0 576 1 914 8 #resetSpy 8 'Reset Spy' 1 1 1234 0 16 1024 8 'RadioButton.ico' 1104 978 0 16 0 0 0 0 3 754 33 33 1 98 6 1168 1312 1440 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 576 3 0 1 896 1586 0 0 576 3 0 1 234 240 98 8 1536 5 1280 1 1408 3 992 7 0 1 0 754 33 33 754 45 45 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 754 1 1 754 701 51 576 1762 8 #updateSize 832 576 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 25 0 0 0] 98 0 754 193 193 0 27 0 0 0 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 1968 0 0 0 5 0 0 0 1968 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.ValueWorkspace)  8 #resource_Default_view 0 1698 202 208 98 1 1762 1792 98 2 754 1 51 754 701 451 1968 1890 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 94 1 0 0 250 0 0 0] 832 1952 0 27 234 256 98 2 1968 8 'spySource' 0 1698 202 208 98 1 1762 1792 98 2 754 2047 21 754 701 501 416 1890 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 10 0 0 0 93 5 0 0 4 1 0 0] 98 2 576 1968 1952 0 27 )! !
!MethodSpyPresenter class categoriesFor: #icon!public! !
!MethodSpyPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

