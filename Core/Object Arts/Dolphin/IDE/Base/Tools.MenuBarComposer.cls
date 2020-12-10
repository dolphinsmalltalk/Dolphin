"Filed out from Dolphin Smalltalk 7"!

Tools.MenuComposer subclass: #'Tools.MenuBarComposer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.MenuBarComposer guid: (Core.GUID fromString: '{87b4c6b8-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.MenuBarComposer comment: 'MenuComposer is a <valueDialogPresenter> that can be used to edit a <MenuBar> held in its <valueModel>.'!
!Tools.MenuBarComposer categoriesForClass!MVP-Presenters! !
!Tools.MenuBarComposer class methodsFor!

menuClass
	"Private - Answer the base menu class that instances of the receiver will edit|"

	^MenuBar! !
!Tools.MenuBarComposer class categoriesFor: #menuClass!models!private! !

