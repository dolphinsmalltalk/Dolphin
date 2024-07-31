"Filed out from Dolphin Smalltalk"!

Tools.ChooseClassDialog
	subclass: #'Tools.ChoosePackagedClassDialog'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.ChoosePackagedClassDialog guid: (Core.GUID fromString: '{66f6e532-7d50-44b1-877b-8e46061d0277}')!

Tools.ChoosePackagedClassDialog comment: 'ChoosePackagedClassDialog is a specialised <ChooseClassDialog> that allows for filtering of the class hierarchy by package selection.
'!

!Tools.ChoosePackagedClassDialog categoriesForClass!MVP-Presenters! !

!Tools.ChoosePackagedClassDialog methodsFor!

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

!Tools.ChoosePackagedClassDialog categoriesForMethods!
classesPresenterClass!constants!private! !
onViewOpened!event handling!public! !
packages:!public!selection! !
!

!Tools.ChoosePackagedClassDialog class methodsFor!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 210 1 1 nil nil 18 #{UI.ReferenceView} 50 14 nil 240 50 2 8 1140850688 131073 320 nil nil nil 5 nil nil nil 320 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[176 1 0 0 5 0 0 0 90 2 0 0 35 0 0 0] 193 352 8 '' 320 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 240 50 2 8 1409286144 131073 656 nil nil nil 5 nil nil nil 656 838 1 #{UI.FlowLayout} 17 17 17 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 18 #{UI.PushButton} 50 20 nil 656 50 2 8 1141055488 1 800 nil nil nil 5 nil nil nil 800 nil nil 1350 4 #{UI.CommandDescription} #none 8 'None' 1 1 nil nil false nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[2 0 0 0 8 0 0 0 77 0 0 0 31 0 0 0] 193 832 8 'None' 800 466 #isEnabled: 8 #(false) 800 3 8 #() 626 193 193 nil 29 8 'none' 518 #{Graphics.Rectangle} 626 5 17 626 1 1 418 50 1 466 #createWindow: 50 1 514 546 8 #[0 0 0 0 5 0 0 0 85 0 0 0 35 0 0 0] 193 688 8 '' 656 3 50 1 800 626 193 193 nil 27 nil 550 #{Core.IdentityDictionary} 0 1122 626 1 11 626 5 1 418 50 1 466 #createWindow: 50 1 514 546 8 #[10 0 0 0 60 1 0 0 102 2 0 0 95 1 0 0] 193 272 8 '' 240 3 50 2 656 320 626 193 193 nil 27 nil nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 1584 nil nil nil 5 2886 4 #{UI.Menu} nil true 50 3 1094 2 #{UI.CommandMenuItem} 2097153 866 #findClass 8 'Find…' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'FindClass.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 1698 1 866 #gotoDefinition 8 '&Goto Definition' 1 1 nil nil nil 1650 nil true 50 4 1698 1 866 #browseClassPackage 8 'Package <d>' 1 1 1762 nil true 1794 8 'Package.ico' 1856 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1698 1 866 #browseClass 8 '&Class' 1 1 1762 nil true 1794 8 'ClassBrowserShell.ico' 1856 65541 nil nil nil 1698 2097153 866 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 1584 386 #{Tools.PackagedClassSelector} #resource_Choice_view nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[10 0 0 0 10 0 0 0 102 2 0 0 60 1 0 0] 193 1616 8 '' 1584 466 #contextMenu: 50 1 1664 1584 3 608 626 193 193 nil 27 754 1344 50 2 1584 8 'classSelector' 1122 626 21 21 626 21 21 nil nil nil nil 1 nil nil nil 626 661 521 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 418 50 2 466 #createWindow: 50 1 518 #{UI.CreateDialog} 1122 626 7679 21 626 8959 821 193 32 466 #setWindowText: 50 1 8 'Choose Packaged Class…' 32 1 50 2 1584 240 626 193 193 nil 29)!

uninitialize
	SmalltalkSystem.Current
		ifNotNil: [:devsys | devsys classChooserClass == self ifTrue: [devsys classChooserClass: nil]]! !

!Tools.ChoosePackagedClassDialog class categoriesForMethods!
on:!instance creation!public! !
resource_Default_view!public!resources-views! !
uninitialize!class hierarchy-removing!public! !
!

