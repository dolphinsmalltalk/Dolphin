"Filed out from Dolphin Smalltalk 7"!

ChooseClassDialog subclass: #ChoosePackagedClassDialog
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChoosePackagedClassDialog guid: (GUID fromString: '{66f6e532-7d50-44b1-877b-8e46061d0277}')!
ChoosePackagedClassDialog comment: 'ChoosePackagedClassDialog is a specialised <ChooseClassDialog> that allows for filtering of the class hierarchy by package selection.
'!
!ChoosePackagedClassDialog categoriesForClass!MVP-Presenters! !
!ChoosePackagedClassDialog methodsFor!

classesPresenterClass
	^PackagedClassSelector!

onViewOpened
	"Received when the receiver's view has been connected."

	super onViewOpened.
	"If there is no current package, then select the root of the package tree."
	classesPresenter selectionOrNil isNil ifTrue: [classesPresenter selectPackageRoot]!

packages: aCollection 
	"Set the packages selected in the receiver. Ignored at this level."

	classesPresenter packages: aCollection! !
!ChoosePackagedClassDialog categoriesFor: #classesPresenterClass!constants!private! !
!ChoosePackagedClassDialog categoriesFor: #onViewOpened!event handling!public! !
!ChoosePackagedClassDialog categoriesFor: #packages:!public!selection! !

!ChoosePackagedClassDialog class methodsFor!

on: aModel 
	"Answer an instance of the receiver not yet connected to any view
	but connected to aModel."

	"Implementation Note: Unpackaged classes do not appear in the packaged class dialog, so if
	the initial class is unpackaged we have to use the simpler dialog (#1329)."

	aModel value ifNotNil: [:class | class owningPackage isNil ifTrue: [^ChooseClassDialog on: aModel]].
	^super on: aModel!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 560 0 0 0 7 0 0 0 560 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  21 643 834 825 71 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 65 1 0 0 166 1 0 0 100 1 0 0] 98 0 834 193 193 0 27 0 0 410 576 98 14 0 416 98 2 8 1140850688 131073 960 0 0 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 3 984134 2 ##(Smalltalk.CommandMenuItem)  2097153 1180998 4 ##(Smalltalk.CommandDescription)  8 #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 1074 1 1106 8 #gotoDefinition 8 '&Goto Definition' 1 1 0 0 0 1026 0 16 98 4 1074 1 1106 8 #browseClassPackage 8 'Package <1d>' 1 1 1170 0 16 1216 8 'Package.ico' 1264 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 1074 1 1106 8 #browseClass 8 '&Class' 1 1 1170 0 16 1216 8 'ClassBrowserShell.ico' 1264 0 0 1074 2097153 1106 8 #browseClassReferences 8 'Class &References' 1 1 0 0 0 8 '&Browse' 8 #browse 134217729 0 0 0 0 0 8 '&Class' 0 134217729 0 0 0 0 0 0 0 960 642 8 ##(Smalltalk.PackagedClassSelector)  8 #resource_Choice_view 0 706 202 208 98 2 770 800 98 2 834 21 21 834 825 623 960 770 8 #contextMenu: 98 1 1040 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 166 1 0 0 65 1 0 0] 928 944 0 27 234 256 98 2 960 8 'classSelector' 590342 ##(Smalltalk.Rectangle)  834 21 21 834 21 21 0 0 0 0 23271 0 0 0 834 661 521 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 706 202 208 98 3 770 800 98 2 834 2799 21 834 881 801 416 770 8 #text: 98 1 8 'Choose Packaged Class...' 416 770 8 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 47 7 0 0 154 1 0 0] 98 2 960 560 944 0 27 )!

uninitialize
	Smalltalk developmentSystem classChooserClass == self 
		ifTrue: [Smalltalk developmentSystem classChooserClass: nil]! !
!ChoosePackagedClassDialog class categoriesFor: #on:!instance creation!public! !
!ChoosePackagedClassDialog class categoriesFor: #resource_Default_view!public!resources-views! !
!ChoosePackagedClassDialog class categoriesFor: #uninitialize!class hierarchy-removing!public! !

