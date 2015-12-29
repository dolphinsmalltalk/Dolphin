"Filed out from Dolphin Smalltalk X6.1"!

HtmlListTable subclass: #HtmlOverviewListTable
	instanceVariableNames: 'rowIndexWhileGenerating'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlOverviewListTable guid: (GUID fromString: '{83610810-5D47-4458-8D51-014F87B6C344}')!
HtmlOverviewListTable comment: ''!
!HtmlOverviewListTable categoriesForClass!Unclassified! !
!HtmlOverviewListTable methodsFor!

generateOn: aStream 
	rowIndexWhileGenerating := 1.
	^super generateOn: aStream!

getRowBeginTagForFirstCell: aTableCell rowIndex: anObject 
	| str bgColor |
	aTableCell isNil ifTrue: [^'<tr>'].
	aTableCell cellType == #dataCellEven 
		ifTrue: [bgColor := self colorForEvenRow]
		ifFalse: 
			[aTableCell cellType == #dataCellOdd ifTrue: [bgColor := self colorForOddRow] ifFalse: [^'<tr>']].
	str := '<tr style="background-color:' , bgColor , '"'.
	onRowClickJavascriptFunctionName isNilOrEmpty 
		ifFalse: 
			[str := str , ' onclick="' , onRowClickJavascriptFunctionName , '(' 
						, rowIndexWhileGenerating printString , ')"'.
			rowIndexWhileGenerating := rowIndexWhileGenerating + 1].
	^str , ' onmouseover="this.style.backgroundColor=''' , self colorForHover 
		, ''';" onmouseout="this.style.backgroundColor=''' , bgColor 
		, ''';">'! !
!HtmlOverviewListTable categoriesFor: #generateOn:!generating HTML!public! !
!HtmlOverviewListTable categoriesFor: #getRowBeginTagForFirstCell:rowIndex:!generating HTML!private! !

