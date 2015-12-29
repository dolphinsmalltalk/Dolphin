"Filed out from Dolphin Smalltalk X6.1"!

WikiDocFckEditorImageFileServlet subclass: #WikiDocFckEditorPopUpSelectorImageFileServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocFckEditorPopUpSelectorImageFileServlet guid: (GUID fromString: '{76B4F7B0-80F8-48CA-A948-80C808A1E49A}')!
WikiDocFckEditorPopUpSelectorImageFileServlet comment: ''!
!WikiDocFckEditorPopUpSelectorImageFileServlet categoriesForClass!Unclassified! !
!WikiDocFckEditorPopUpSelectorImageFileServlet methodsFor!

urlPrefix: aString 
	numberOfCharactersToCut := aString size + 2 
				+ '/fckeditor/editor/dialog/fck_image/wiki-images/' size.
	urlPrefix := aString! !
!WikiDocFckEditorPopUpSelectorImageFileServlet categoriesFor: #urlPrefix:!public! !

!WikiDocFckEditorPopUpSelectorImageFileServlet class methodsFor!

servletName
	^'fckeditor/editor/dialog/fck_image/wiki'! !
!WikiDocFckEditorPopUpSelectorImageFileServlet class categoriesFor: #servletName!public! !

