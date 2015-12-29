"Filed out from Dolphin Smalltalk X6.1"!

WikiDocEditPageTask subclass: #WikiDocCopyPageTask
	instanceVariableNames: 'pageToCopy'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocCopyPageTask guid: (GUID fromString: '{24181B07-F324-4BA8-A6CE-67F6011A4ADC}')!
WikiDocCopyPageTask comment: ''!
!WikiDocCopyPageTask categoriesForClass!Unclassified! !
!WikiDocCopyPageTask methodsFor!

getPageVersionBeingEdited
	| page pageVersion |
	page := application getOrCreatePage: pageId language: language.
	pageVersion := page getCurrentVersion.
	page
		pageName: pageVersion page pageName;
		pageTitle: pageVersion page pageTitle.
	pageVersion
		parentPage: pageToCopy parentPage;
		pageFormat: pageToCopy pageFormat;
		contents: pageToCopy contents;
		pageTitle: pageToCopy pageTitle;
		isLeafPage: pageToCopy isLeafPage;
		pagePosition: pageToCopy pagePosition;
		tocNodeIcon: pageToCopy tocNodeIcon;
		keywords: pageToCopy keywords.
	^pageVersion!

getTopNavigation
	^parentTopNavigation isNil 
		ifFalse: [parentTopNavigation , (Array with: 'WikiDoc.CopyPage' webTranslate -> self taskURLPrefix)]!

pageToCopy: aWikiDocPage 
	pageToCopy := aWikiDocPage! !
!WikiDocCopyPageTask categoriesFor: #getPageVersionBeingEdited!public! !
!WikiDocCopyPageTask categoriesFor: #getTopNavigation!public! !
!WikiDocCopyPageTask categoriesFor: #pageToCopy:!public! !

