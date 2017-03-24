"Filed out from Dolphin Smalltalk 7"!

ClassAspectPlugin subclass: #ClassInitializerPlugin
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassInitializerPlugin guid: (GUID fromString: '{B529A009-713D-4417-8098-A335A0055268}')!
ClassInitializerPlugin comment: ''!
!ClassInitializerPlugin categoriesForClass!MVP-Presenters! !
!ClassInitializerPlugin methodsFor!

aspect
	^#initializer!

caption
	^'Class initializer'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self model model 
		when: self systemUpdateEvent
		send: #onClassUpdated:
		to: self!

defaultHelpId
	^0!

hasEditableMethodSelected
	^true!

parseContext
	^self browser selectedClass class!

saveNewMethod: aString 
	self accept!

selectedMethod
	^nil!

textPresenterClass
	^ExpressionWorkspace! !
!ClassInitializerPlugin categoriesFor: #aspect!helpers!private! !
!ClassInitializerPlugin categoriesFor: #caption!displaying!public! !
!ClassInitializerPlugin categoriesFor: #createSchematicWiring!initializing!public! !
!ClassInitializerPlugin categoriesFor: #defaultHelpId!constants!public! !
!ClassInitializerPlugin categoriesFor: #hasEditableMethodSelected!public!testing! !
!ClassInitializerPlugin categoriesFor: #parseContext!accessing!public! !
!ClassInitializerPlugin categoriesFor: #saveNewMethod:!commands!public! !
!ClassInitializerPlugin categoriesFor: #selectedMethod!accessing!public! !
!ClassInitializerPlugin categoriesFor: #textPresenterClass!initializing!private! !

!ClassInitializerPlugin class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ContainerView) 98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 0 0 0 410 8 ##(Smalltalk.ReferenceView) 98 14 0 416 98 2 8 1140916224 131073 576 0 498 8 4278190080 0 5 265030 4 ##(Smalltalk.Menu) 0 16 98 15 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #accept 8 '&Accept' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 690 0 16 98 8 738 1 770 8 #undo 8 '&Undo' 1 1 0 0 0 834 4097 738 1 770 8 #cutSelection 8 'Cu&t' 1 1 0 0 0 738 1 770 8 #copySelection 8 '&Copy' 1 1 0 0 0 738 1 770 8 #pasteClipboard 8 '&Paste' 1 1 0 0 0 738 1 770 8 #clearSelection 8 'De&lete' 1 1 0 0 0 834 4097 738 1 770 8 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 1 0 0 0 0 0 738 1 770 8 #clear 8 'Clea&r' 1 1 0 0 0 834 4097 738 1 770 8 #browseIt 8 'Bro&wse It' 1 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 738 1 770 8 #displayIt 8 '&Display It' 1 1 0 0 0 738 1 770 8 #evaluateIt 8 'E&valuate It' 1 1 0 0 0 738 1 770 8 #inspectIt 8 '&Inspect It' 1 1 1474 0 16 1520 8 'BasicInspector.ico' 1568 0 0 738 1 770 8 #debugIt 8 'Deb&ug It' 1 1 1474 0 16 1520 8 'Debugger.ico' 1568 0 0 834 4097 738 1 770 8 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 738 1 770 8 #cloneNew 8 'Clo&ne' 1 1 0 0 0 834 4097 690 0 16 98 2 738 2097153 770 8 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 738 1 770 8 #browseReferences 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 1 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 576 1180166 ##(Smalltalk.ResourceIdentifier) 8 ##(Smalltalk.SmalltalkWorkspace) 8 #resource_Default_view 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 2 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 1 1 2466 701 501 576 2402 8 #contextMenu: 98 1 704 576 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 0 2466 193 193 0 27 234 256 98 2 576 8 'text' 0 2338 202 208 98 1 2402 2432 98 2 2466 3839 21 2466 701 501 416 2562 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 98 1 576 2624 0 27 )! !
!ClassInitializerPlugin class categoriesFor: #resource_Default_view!public!resources-views! !

