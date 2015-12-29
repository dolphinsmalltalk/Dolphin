"Filed out from Dolphin Smalltalk X6.1"!

WikiDocPageParser subclass: #WikiDocIndexingPageParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocIndexingPageParser guid: (GUID fromString: '{E2A72489-A894-4981-9EC3-BD05C7932D85}')!
WikiDocIndexingPageParser comment: ''!
!WikiDocIndexingPageParser categoriesForClass!Unclassified! !
!WikiDocIndexingPageParser methodsFor!

writeExternalLinkFrom: rs 
	| content url linkTitle |
	rs next.
	content := rs upTo: $].
	(content indexOf: $ ) = 0 
		ifTrue: 
			[url := content.
			linkTitle := content]
		ifFalse: 
			[url := content copyFrom: 1 to: (content indexOf: $ ) - 1.
			linkTitle := content copyFrom: url size + 2 to: content size].
	writeStream
		nextPutAll: linkTitle webHtmlEncoded;
		nextPut: $ ;
		nextPutAll: url;
		nextPut: $ !

writeFigureFrom: rs 
	| content tokens imageFile image caption |
	rs next: 9.
	content := rs itcUpToAll: ']]'.
	tokens := content itcSubStrings: $|.
	imageFile := tokens at: 1.
	tokens size > 1 ifTrue: [caption := tokens at: 2].
	(self addFigure: imageFile caption: caption) ifFalse: [^self].
	writeStream 
		nextPutAll: '<table cellpadding="0" cellspacing="0" border="0"><tr><td>&nbsp;&nbsp;</td><td align="center"></td><td width="100%"><img width="1" height="1"/></td></tr>'.
	caption isNilOrEmpty 
		ifFalse: 
			[writeStream
				nextPutAll: '<tr><td>&nbsp;&nbsp;</td><td colspan="2"><table cellspacing="0" cellpadding="0" border="0"><tr><td><font class="caption">&nbsp;&nbsp;</font></td><td><font class="caption"><b>';
				nextPutAll: caption webHtmlEncoded;
				nextPutAll: '</b></font></td></tr></table></td></tr>'].
	writeStream nextPutAll: '</table>'!

writeFigureRightFrom: rs 
	| content tokens imageFile image caption |
	rs next: 15.
	content := rs itcUpToAll: ']]'.
	tokens := content itcSubStrings: $|.
	imageFile := tokens at: 1.
	tokens size > 1 ifTrue: [caption := tokens at: 2].
	(self addFigure: imageFile caption: caption) ifFalse: [^self].
	writeStream
		nextPutAll: '<table cellpadding="0" cellspacing="0" border="0" align="right"><tr><td>&nbsp;</td><td></td></tr><tr><td>&nbsp;</td><td><table cellspacing="0" cellpadding="0" border="0"><tr><td><font class="caption">&nbsp;&nbsp;</font></td><td><font class="caption"><b>';
		nextPutAll: caption asWebString webHtmlEncoded;
		nextPutAll: '</b></font></td></tr></table></td></tr></table>'! !
!WikiDocIndexingPageParser categoriesFor: #writeExternalLinkFrom:!private! !
!WikiDocIndexingPageParser categoriesFor: #writeFigureFrom:!private! !
!WikiDocIndexingPageParser categoriesFor: #writeFigureRightFrom:!private! !

