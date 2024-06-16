"Filed out from Dolphin Smalltalk"!

ScribbleDocument subclass: #EtchASketchDocument
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EtchASketchDocument guid: (GUID fromString: '{2971e17d-6207-4ede-b010-6a4262f924e5}')!

EtchASketchDocument comment: ''!

!EtchASketchDocument categoriesForClass!MVP-Presenters! !

!EtchASketchDocument class methodsFor!

fileType
	^#('Etch-a-Sketch Files (*.sketch)' '*.sketch')!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 528 nil nil nil 5 nil nil nil 528 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.EtchASketch) #resource_Default_view nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 193 560 8 '' 528 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 170 192 34 2 528 8 'scribble' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 1 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'DocumentShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1026 1 1058 #fileOpen 8 '&Open...' 9375 1 1106 nil true 1152 8 'OpenWorkspace.ico' 1200 nil nil 1026 1 1058 #fileSave 8 '&Save' 9383 1 1106 nil true 1152 8 'FileSave.ico' 1200 nil nil 1026 1 1058 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 12739 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 626 138 144 34 1 690 #createWindow: 34 1 738 590342 ##(Smalltalk.Rectangle) 850 1 1 850 1201 801 193 448 8 '' 416 1 34 1 528 850 193 193 nil 27 )!

scribblePresenterClass
	^EtchASketch! !

!EtchASketchDocument class categoriesForMethods!
fileType!constants!public! !
resource_Default_view!public!resources-views! !
scribblePresenterClass!constants!private! !
!

