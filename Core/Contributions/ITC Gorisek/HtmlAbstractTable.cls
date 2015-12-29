"Filed out from Dolphin Smalltalk X6.1"!

HtmlContainer subclass: #HtmlAbstractTable
	instanceVariableNames: 'viewOnly disabled showSmall onSelect onSelectInNewWindow onRowClickJavascriptFunctionName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlAbstractTable guid: (GUID fromString: '{79073415-5940-4CA2-A14F-DDDC10E69296}')!
HtmlAbstractTable comment: ''!
!HtmlAbstractTable categoriesForClass!Unclassified! !
!HtmlAbstractTable methodsFor!

addData: anObject onSelectLinkFor: id 
	self addData: anObject linkTo: (self getOnSelectLinkFor: id)!

addDisketteLinkTo: url toolTip: toolTip 
	self
		addImage: 'images/diskette.gif'
			width: 14
			height: 14
			toolTip: toolTip
			linkTo: url;
		nextCell!

addDisketteLinkTo: url toolTip: toolTip target: target 
	self 
		addImage: 'images/diskette.gif'
		width: 14
		height: 14
		toolTip: toolTip
		target: target
		linkTo: url!

addDisketteLinkTo: url toolTip: toolTip target: target onClick: onClick 
	self 
		addImage: 'images/diskette.gif'
		width: 14
		height: 14
		toolTip: toolTip
		target: target
		onClick: onClick
		linkTo: url!

addField: aHtmlField linkTo: url 
	(viewOnly == true or: [url isNil]) ifTrue: [^self addField: aHtmlField].
	self
		add: '<a href="' , url , '">';
		add: aHtmlField;
		add: '</a>'.
	^aHtmlField!

addField: aHtmlField linkTo: url title: aString target: target 
	(viewOnly == true or: [url isNilOrEmpty]) ifTrue: [^self addField: aHtmlField].
	self
		add: '<a href="' , url , '" title="' , aString asWebString webHtmlEncodedForForm , '" target="' 
					, target , '">';
		addField: aHtmlField;
		add: '</a>'.
	^aHtmlField!

addField: anObject onSelectLinkFor: id 
	self addField: anObject linkTo: (self getOnSelectLinkFor: id)!

addHeader: anObject 
	self addHeader: anObject cellWidthPx: nil!

addHeader: anObject cellWidthPx: width 
	self 
		addHeader: anObject
		cellWidthPx: width
		sortSelector: nil!

addHeader: anObject sortSelector: aSymbol 
	self 
		addHeader: anObject
		cellWidthPx: nil
		sortSelector: aSymbol!

addImage: imgSrc width: w height: h toolTip: toolTip target: linkTarget linkTo: url 
	| str |
	str := toolTip webTranslate.
	self
		addField: '<a href="' , url webXhtmlUrlEncodeForForm , '" target="' , linkTarget , '"><img src="' 
					, imgSrc , '" width="' 
					, w printString , '" height="' 
					, h printString , '" alt="' 
					, str , '" title="' 
					, str , '" border="0"/></a>';
		nextCell!

addImage: imgSrc width: w height: h toolTip: toolTip target: linkTarget linkTo: url linkId: id 
	| str |
	str := toolTip webTranslate.
	self
		addField: '<a id="' , id , '" href="' , url webXhtmlUrlEncodeForForm , '" target="' , linkTarget 
					, '"><img src="' , imgSrc 
					, '" width="' , w printString 
					, '" height="' , h printString 
					, '" alt="' , str 
					, '" title="' , str 
					, '" border="0"/></a>';
		nextCell!

addLuckaToolTip: toolTip linkTo: url 
	"Doda ikonco - lucko s tooltip-om.
	Ni premika v novo celico."

	| str |
	str := toolTip webTranslate.
	self
		cellAlignmentLeft;
		addImage: 'images/luc.gif'
			width: 9
			height: 14
			toolTip: str
			linkTo: url!

addLuckaToolTip: toolTip onSelectLinkFor: id 
	self addLuckaToolTip: toolTip linkTo: (self getOnSelectLinkFor: id)!

addMoneyData: anObject 
	self addMoneyData: anObject precision: 2!

addMoneyDataNotNextCell: anObject 
	self addMoneyDataNotNextCell: anObject highlighted: nil!

addNoPaymentLinkTo: url 
	self addNoPaymentToolTip: 'Racun.toolTip.NiPlacano' linkTo: url!

addNoPaymentOnSelectLinkFor: id 
	self addNoPaymentLinkTo: (self getOnSelectLinkFor: id)!

addNoPaymentToolTip: toolTip linkTo: url 
	| str |
	str := toolTip webTranslate.
	self 
		addImage: 'images/no-payment.gif'
		width: 25
		height: 15
		toolTip: str
		linkTo: url!

addNoPaymentToolTip: toolTip onSelectLinkFor: id 
	self addNoPaymentToolTip: toolTip linkTo: (self getOnSelectLinkFor: id)!

addOpenLinkTo: url toolTip: aString 
	self
		addImage: 'images/open.gif'
			width: 15
			height: 13
			toolTip: aString
			linkTo: url;
		nextCell!

addPercentageData: anObject precision: precision 
	self
		cellAlignmentRight;
		addData: (anObject isNil 
					ifFalse: 
						[(anObject asWebStringWithPrecision: (precision isNil ifTrue: [6] ifFalse: [precision])) 
							webHtmlEncoded , '%'])!

addPrintInNewWindowLinkTo: url 
	self 
		addImage: 'images/print.gif'
		width: 16
		height: 14
		toolTip: 'asp.label.helpTip.Print'
		target: '_blank'
		linkTo: url!

addSeqNo: anInteger 
	self
		cellWidthPx: 37;
		cellAlignmentRight;
		addField: anInteger printString , '.';
		nextCell!

addSeqNo: anInteger linkTo: url 
	self
		cellWidthPx: 37;
		cellAlignmentRight;
		addField: anInteger printString , '.' linkTo: url;
		nextCell!

addShortData: anObject onSelectLinkFor: id 
	self addShortData: anObject linkTo: (self getOnSelectLinkFor: id)!

cellBackground: aColorString 
	aColorString isNilOrEmpty ifFalse: [self cellStyleAdd: 'background-color:' , aColorString]!

cellBackgroundGrey
	^self cellBackground: '#f0f0f0'!

cellBackgroundHighlighted
	self cellHighlighted: true!

cellBackgroundHighlightedOk
	self cellHighlighted: #green!

cellHighlighted: aBooleanOrSymbol 
	(aBooleanOrSymbol == true or: [aBooleanOrSymbol == #red]) 
		ifTrue: [self cellStyleAdd: 'background-color:#ff9999;']
		ifFalse: 
			[aBooleanOrSymbol == #green 
				ifTrue: [self cellStyleAdd: 'background-color:#ccffcc;']
				ifFalse: [aBooleanOrSymbol == #yellow ifTrue: [self cellStyleAdd: 'background-color:#ffff99;']]]!

cellWidthPx: anInteger 
	!

colorForEvenRow
	^'#e8e8e8'!

colorForHover
	^'#fff080'!

colorForOddRow
	^'#ffffff'!

currentRowId: anIntegerOrString 
	!

getOnSelectLinkFor: id 
	^(id isNilOrEmpty or: [onSelect isNilOrEmpty]) ifFalse: [onSelect , id asWebString]!

isPrintableReportExcelListTable
	^false!

isPrintableReportListTable
	^false!

isVirtualListTable
	^false!

isWideListTable
	"Vrne <true>, ce je tabela sposobna prikazati zelo veliko stevilo stolpcev."

	^self class isWideListTable!

onRowClickJavascriptFunctionName: aString 
	"Doloci ime javascript funkcije, ki naj se klice, ko uporabnik klikne na vrstico v tabeli.
	Npr. v Javascriptu naredis funkcijo:

			function myTableOnRowClick(rowIndex, [rowID] ) { ... }

	To nastavis v Smalltalk-u s:

			myTable onRowClickJavascriptFunctionName: 'myTableOnRowClick'

	Nato se ta funkcija po kliku klice s parametrom stevilka vrstice. Ce je podan rowID, potem je drugi parameter rowID, sicer pa null. Stevilke vrstice se zacnejo od 1 do n."

	onRowClickJavascriptFunctionName := aString!

onSelect: urlPrefixOrBlock 
	"For AJAX actions format like - urlPrefix , '?action=ajaxGetXXX&id=';"

	onSelect := urlPrefixOrBlock!

onSelectInNewWindow: aBoolean 
	onSelectInNewWindow := aBoolean!

rowHeightPtFixed: anInteger 
	"RTF/ODF compatibility method"

	!

useCellOddEvenShading: aBool 
	"RTF/ODF compatibility method"

	! !
!HtmlAbstractTable categoriesFor: #addData:onSelectLinkFor:!public! !
!HtmlAbstractTable categoriesFor: #addDisketteLinkTo:toolTip:!public! !
!HtmlAbstractTable categoriesFor: #addDisketteLinkTo:toolTip:target:!public! !
!HtmlAbstractTable categoriesFor: #addDisketteLinkTo:toolTip:target:onClick:!public! !
!HtmlAbstractTable categoriesFor: #addField:linkTo:!public! !
!HtmlAbstractTable categoriesFor: #addField:linkTo:title:target:!public! !
!HtmlAbstractTable categoriesFor: #addField:onSelectLinkFor:!public! !
!HtmlAbstractTable categoriesFor: #addHeader:!public! !
!HtmlAbstractTable categoriesFor: #addHeader:cellWidthPx:!public! !
!HtmlAbstractTable categoriesFor: #addHeader:sortSelector:!public! !
!HtmlAbstractTable categoriesFor: #addImage:width:height:toolTip:target:linkTo:!public! !
!HtmlAbstractTable categoriesFor: #addImage:width:height:toolTip:target:linkTo:linkId:!public! !
!HtmlAbstractTable categoriesFor: #addLuckaToolTip:linkTo:!public! !
!HtmlAbstractTable categoriesFor: #addLuckaToolTip:onSelectLinkFor:!public! !
!HtmlAbstractTable categoriesFor: #addMoneyData:!public! !
!HtmlAbstractTable categoriesFor: #addMoneyDataNotNextCell:!public! !
!HtmlAbstractTable categoriesFor: #addNoPaymentLinkTo:!public! !
!HtmlAbstractTable categoriesFor: #addNoPaymentOnSelectLinkFor:!public! !
!HtmlAbstractTable categoriesFor: #addNoPaymentToolTip:linkTo:!public! !
!HtmlAbstractTable categoriesFor: #addNoPaymentToolTip:onSelectLinkFor:!public! !
!HtmlAbstractTable categoriesFor: #addOpenLinkTo:toolTip:!public! !
!HtmlAbstractTable categoriesFor: #addPercentageData:precision:!public! !
!HtmlAbstractTable categoriesFor: #addPrintInNewWindowLinkTo:!public! !
!HtmlAbstractTable categoriesFor: #addSeqNo:!public! !
!HtmlAbstractTable categoriesFor: #addSeqNo:linkTo:!public! !
!HtmlAbstractTable categoriesFor: #addShortData:onSelectLinkFor:!public! !
!HtmlAbstractTable categoriesFor: #cellBackground:!public! !
!HtmlAbstractTable categoriesFor: #cellBackgroundGrey!public! !
!HtmlAbstractTable categoriesFor: #cellBackgroundHighlighted!public! !
!HtmlAbstractTable categoriesFor: #cellBackgroundHighlightedOk!public! !
!HtmlAbstractTable categoriesFor: #cellHighlighted:!public! !
!HtmlAbstractTable categoriesFor: #cellWidthPx:!public! !
!HtmlAbstractTable categoriesFor: #colorForEvenRow!generating HTML!public! !
!HtmlAbstractTable categoriesFor: #colorForHover!generating HTML!public! !
!HtmlAbstractTable categoriesFor: #colorForOddRow!generating HTML!public! !
!HtmlAbstractTable categoriesFor: #currentRowId:!public! !
!HtmlAbstractTable categoriesFor: #getOnSelectLinkFor:!private! !
!HtmlAbstractTable categoriesFor: #isPrintableReportExcelListTable!public! !
!HtmlAbstractTable categoriesFor: #isPrintableReportListTable!public! !
!HtmlAbstractTable categoriesFor: #isVirtualListTable!public! !
!HtmlAbstractTable categoriesFor: #isWideListTable!public! !
!HtmlAbstractTable categoriesFor: #onRowClickJavascriptFunctionName:!accessing!public! !
!HtmlAbstractTable categoriesFor: #onSelect:!accessing!public! !
!HtmlAbstractTable categoriesFor: #onSelectInNewWindow:!accessing!public! !
!HtmlAbstractTable categoriesFor: #rowHeightPtFixed:!public! !
!HtmlAbstractTable categoriesFor: #useCellOddEvenShading:!public! !

!HtmlAbstractTable class methodsFor!

isPrintableReportExcelListTable
	^false!

isPrintableReportListTable
	^false!

isWideListTable
	"Vrne <true>, ce je tabela sposobna prikazati zelo veliko stevilo stolpcev."

	^false! !
!HtmlAbstractTable class categoriesFor: #isPrintableReportExcelListTable!public! !
!HtmlAbstractTable class categoriesFor: #isPrintableReportListTable!public! !
!HtmlAbstractTable class categoriesFor: #isWideListTable!public! !

