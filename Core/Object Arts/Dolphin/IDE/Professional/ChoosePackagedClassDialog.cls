"Filed out from Dolphin Smalltalk"!

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
!ChoosePackagedClassDialog categoriesForMethods!
classesPresenterClass!constants!private! !
onViewOpened!event handling!public! !
packages:!public!selection! !
!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 5 nil nil nil 640 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 21 633 578 809 71 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 1 0 0 158 1 0 0 95 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 960 nil nil nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 2097153 1180998 4 ##(Smalltalk.CommandDescription) #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1074 1 1106 #gotoDefinition 8 '&Goto Definition' 1 1 nil nil nil 1026 nil true 34 4 1074 1 1106 #browseClassPackage 8 'Package <1d>' 1 1 1154 nil true 1200 8 'Package.ico' 1248 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1074 1 1106 #browseClass 8 '&Class' 1 1 1154 nil true 1200 8 'ClassBrowserShell.ico' 1248 nil nil 1074 2097153 1106 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 960 706 ##(Smalltalk.PackagedClassSelector) #resource_Choice_view nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 21 21 578 809 613 960 802 #contextMenu: 34 1 1040 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 158 1 0 0 60 1 0 0] 928 944 nil 27 170 192 34 2 960 8 'classSelector' 590342 ##(Smalltalk.Rectangle) 578 21 21 578 21 21 nil nil nil nil 10147 nil nil nil 578 661 521 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2011052416 738 138 144 34 3 802 #createAt:extent: 34 2 578 1481 681 578 881 801 416 802 #text: 34 1 8 'Choose Packaged Class...' 416 802 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 228 2 0 0 84 1 0 0 156 4 0 0 228 2 0 0] 34 2 960 640 944 nil 27 )!

uninitialize
	Smalltalk developmentSystem classChooserClass == self 
		ifTrue: [Smalltalk developmentSystem classChooserClass: nil]! !
!ChoosePackagedClassDialog class categoriesForMethods!
on:!instance creation!public! !
resource_Default_view!public!resources-views! !
uninitialize!class hierarchy-removing!public! !
!

