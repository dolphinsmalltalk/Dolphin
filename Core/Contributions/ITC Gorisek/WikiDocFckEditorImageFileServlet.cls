"Filed out from Dolphin Smalltalk X6.1"!

WikiDocImageFileServlet subclass: #WikiDocFckEditorImageFileServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocFckEditorImageFileServlet guid: (GUID fromString: '{90B892B0-34B7-4C1A-AF47-7DF5A416F85F}')!
WikiDocFckEditorImageFileServlet comment: ''!
!WikiDocFckEditorImageFileServlet categoriesForClass!Unclassified! !
!WikiDocFckEditorImageFileServlet methodsFor!

urlPrefix: aString 
	numberOfCharactersToCut := aString size + 2 + '/fckeditor/editor/wiki-images/' size.
	urlPrefix := aString! !
!WikiDocFckEditorImageFileServlet categoriesFor: #urlPrefix:!public! !

!WikiDocFckEditorImageFileServlet class methodsFor!

servletName
	^'fckeditor/editor/wiki'! !
!WikiDocFckEditorImageFileServlet class categoriesFor: #servletName!public! !

