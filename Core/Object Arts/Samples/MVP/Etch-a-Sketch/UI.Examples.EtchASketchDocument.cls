"Filed out from Dolphin Smalltalk"!

ScribbleDocument
	subclass: #'UI.Examples.EtchASketchDocument'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.EtchASketchDocument guid: (Core.GUID fromString: '{2971e17d-6207-4ede-b010-6a4262f924e5}')!

UI.Examples.EtchASketchDocument comment: ''!

!UI.Examples.EtchASketchDocument categoriesForClass!MVP-Presenters! !

!UI.Examples.EtchASketchDocument class methodsFor!

fileType
	^#('Etch-a-Sketch Files (*.sketch)' '*.sketch')!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 160 nil nil nil 5 nil nil nil 160 582 1 #{UI.ResourceIdentifier} #{UI.Examples.EtchASketch} #resource_Default_view nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 193 192 8 '' 160 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 160 8 'scribble' nil 2886 4 #{UI.MenuBar} nil true 50 1 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #fileNew 8 '&New' 9373 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'DocumentShell.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 658 1 690 #fileOpen 8 '&Open…' 9375 1 738 nil true 770 8 'OpenWorkspace.ico' 832 65541 nil nil nil 658 1 690 #fileSave 8 '&Save' 9383 1 738 nil true 770 8 'FileSave.ico' 832 65541 nil nil nil 658 1 690 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 258 50 1 306 #createWindow: 50 1 354 518 #{Graphics.Rectangle} 466 7679 21 466 8879 821 193 80 8 '' 32 1 50 1 160 466 193 193 nil 27)!

scribblePresenterClass
	^EtchASketch! !

!UI.Examples.EtchASketchDocument class categoriesForMethods!
fileType!constants!public! !
resource_Default_view!public!resources-views! !
scribblePresenterClass!constants!private! !
!

