"Filed out from Dolphin Smalltalk X6.1"!

HtmlTable subclass: #HtmlListTable
	instanceVariableNames: 'application evenClass oddClass headerClass prestop headerAlignment overviewTaskSortString overviewTaskUrlPrefix dataCellEvenClass dataCellOddClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlListTable guid: (GUID fromString: '{D2409D27-49B5-4A30-855E-A34A5446D7FC}')!
HtmlListTable comment: ''!
!HtmlListTable categoriesForClass!Unclassified! !
!HtmlListTable methodsFor!

addBoldData: anObject 
	self
		setCellTypeAndGetClass;
		add: '<b>&nbsp;' , anObject asWebString webHtmlEncoded , '&nbsp;</b>';
		nextCell!

addBoldData: anObject linkTo: url 
	| class str |
	viewOnly == true ifTrue: [^self addBoldData: anObject].
	class := self setCellTypeAndGetClass.
	(str := anObject asWebString webHtmlEncoded) isEmpty ifTrue: [str := '&nbsp;'].
	disabled 
		ifTrue: 
			[self 
				add: '&nbsp;<a href="' , url , '"><font class="' , class , '"><b>' , str , '</b></font></a>&nbsp;']
		ifFalse: [self add: '&nbsp;<a href="' , url , '"><b>' , str , '</b></a>&nbsp;'].
	self nextCell!

addBoldDataLabel: anObject 
	self
		setCellTypeAndGetClass;
		add: '<b>&nbsp;' , anObject webTranslate webHtmlEncoded , ':&nbsp;</b>';
		nextCell!

addBoldHeader: aString 
	(self cell)
		cssClass: headerClass;
		noWrap.
	self
		add: '&nbsp;<b>' , aString webTranslate , '</b>&nbsp;';
		nextCell!

addBoldMoneyDataWith2OrMoreDecimals: anObject 
	| str value |
	str := (anObject class == Array or: [anObject isMoney]) 
				ifTrue: 
					[anObject first isString 
						ifTrue: 
							[anObject first webHtmlEncoded add: anObject last asWebString webHtmlEncoded withDelimiter: '&nbsp;']
						ifFalse: 
							[value := anObject isMoney 
										ifTrue: [anObject]
										ifFalse: [Money amount: anObject first currency: anObject last].
							value asWebStringForHtmlWith2OrMoreDecimals]]
				ifFalse: 
					[value := anObject.
					value isInteger ifTrue: [value := value asDecimalOrFloat].
					value asWebStringWith2OrMoreDecimals webHtmlEncoded].
	self
		setCellTypeAndGetClass;
		cellAlignmentRight;
		space.
	((value isNumber and: [value < 0]) or: [value isNil and: [str notEmpty and: [str first == $-]]]) 
		ifTrue: 
			[self
				cellNoWrap;
				addBold: str withColor: 'red']
		ifFalse: [self addBold: str].
	self
		space;
		nextCell!

addBoldMoneyDataWithMinimumDecimals: anObject 
	| str value |
	str := (anObject class == Array or: [anObject isMoney]) 
				ifTrue: 
					[anObject first isString 
						ifTrue: 
							[anObject first webHtmlEncoded add: anObject last asWebString webHtmlEncoded withDelimiter: '&nbsp;']
						ifFalse: 
							[value := anObject isMoney 
										ifTrue: [anObject]
										ifFalse: [Money amount: anObject first currency: anObject last].
							value asWebStringForHtmlWithMinimumDecimals]]
				ifFalse: 
					[value := anObject.
					value isInteger ifTrue: [value := value asDecimalOrFloat].
					value asWebStringWithMinimumDecimals webHtmlEncoded].
	self
		setCellTypeAndGetClass;
		cellAlignmentRight;
		space.
	((value isNumber and: [value < 0]) or: [value isNil and: [str notEmpty and: [str first == $-]]]) 
		ifTrue: 
			[self
				cellNoWrap;
				addBold: str withColor: 'red']
		ifFalse: [self addBold: str].
	self
		space;
		nextCell!

addBoldRawHeader: aString 
	(self cell)
		cssClass: 'ltbHd';
		noWrap.
	self
		add: '<b>&nbsp;' , aString , '&nbsp;</b>';
		nextCell!

addBookLinkTo: url toolTip: toolTip 
	self
		addImage: 'images/book.gif'
			width: 15
			height: 12
			toolTip: toolTip
			linkTo: url;
		nextCell!

addData: anObject 
	self
		addField: (anObject isNilOrEmpty 
					ifTrue: ['&nbsp;']
					ifFalse: ['&nbsp;' , anObject asWebString webHtmlEncoded , '&nbsp;']);
		nextCell!

addData: anObject cssClass: cssClassName 
	"This method is obsolete. Should be replaced with CSS class name independent method."

	self addField: '&nbsp;' , anObject asWebString webHtmlEncoded , '&nbsp;'.
	self cell cssClass: cssClassName.
	self nextCell!

addData: anObject fieldName: fieldName errors: errors 
	self
		setCellTypeAndGetClass;
		add: (anObject isNilOrEmpty 
					ifTrue: ['&nbsp;']
					ifFalse: ['&nbsp;' , anObject asWebString webHtmlEncoded , '&nbsp;']);
		addFormFieldErrorTextFor: fieldName
			from: errors
			break: anObject asWebString isNilOrEmpty not;
		nextCell!

addData: anObject fontSize: fs 
	^self addData: anObject!

addData: anObject highlighted: aBooleanOrSymbol 
	self
		cellHighlighted: aBooleanOrSymbol;
		add: '&nbsp;' , anObject asWebString webHtmlEncoded , '&nbsp;';
		nextCell!

addData: anObject linkInNewWindowTo: url 
	| class |
	viewOnly == true ifTrue: [^self addData: anObject].
	class := self setCellTypeAndGetClass.
	disabled 
		ifTrue: 
			[self 
				add: '&nbsp;<a href="' , url , '" target="_blank"><font class="' , class , '">' 
						, anObject asWebString webHtmlEncoded , '</font></a>&nbsp;']
		ifFalse: 
			[self add: '&nbsp;<a href="' , url , '" target="_blank">' , anObject asWebString webHtmlEncoded 
						, '</a>&nbsp;'].
	self nextCell!

addData: anObject linkTo: url 
	| class |
	(viewOnly == true or: [url isNilOrEmpty]) ifTrue: [^self addData: anObject].
	class := self setCellTypeAndGetClass.
	disabled 
		ifTrue: 
			[self 
				add: '&nbsp;<a href="' , url , '"><font class="' , class , '">' 
						, anObject asWebString webHtmlEncoded , '</font></a>&nbsp;']
		ifFalse: 
			[self add: '&nbsp;<a href="' , url , '">' , anObject asWebString webHtmlEncoded , '</a>&nbsp;'].
	self nextCell!

addData: anObject linkTo: url linkTitle: linkTitle 
	| class |
	viewOnly == true ifTrue: [^self addData: anObject].
	class := self setCellTypeAndGetClass.
	disabled 
		ifTrue: 
			[self 
				add: '&nbsp;<a href="' , url , '" title="' , linkTitle asWebString webHtmlEncodedForForm 
						, '"><font class="' , class 
						, '">' , anObject asWebString webHtmlEncoded 
						, '</font></a>&nbsp;']
		ifFalse: 
			[self 
				add: '&nbsp;<a href="' , url , '" title="' , linkTitle asWebString webHtmlEncodedForForm , '">' 
						, anObject asWebString webHtmlEncoded , '</a>&nbsp;'].
	self nextCell!

addData: anObject onClick: script 
	| class |
	viewOnly == true ifTrue: [^self addData: anObject].
	class := self setCellTypeAndGetClass.
	disabled 
		ifTrue: 
			[self 
				add: '&nbsp;<a href="javascript:void(0);" onclick="' , script , '"><font class="' , class , '">' 
						, anObject asWebString webHtmlEncoded , '</font></a>&nbsp;']
		ifFalse: 
			[self 
				add: '&nbsp;<a href="javascript:void(0);" onclick="' , script , '">' 
						, anObject asWebString webHtmlEncoded , '</a>&nbsp;'].
	self nextCell!

addDataNoSpace: anObject 
	self
		add: anObject asWebString webHtmlEncoded;
		nextCell!

addDataNoSpace: anObject cssClass: cssClassName 
	"This method is obsolete. Should be replaced with CSS class name independent method."

	self cell cssClass: cssClassName.
	self
		add: anObject asWebString webHtmlEncoded;
		nextCell!

addField: aHtmlField 
	self setCellTypeAndGetClass.
	^super addField: aHtmlField!

addField: aHtmlField linkInNewWindowTo: url 
	viewOnly == true ifTrue: [^self addField: aHtmlField].
	self
		setCellTypeAndGetClass;
		add: '<a href="' , url , '" target="_blank">';
		add: aHtmlField;
		add: '</a>'!

addField: aHtmlField linkTo: url 
	(viewOnly == true or: [url isNil]) ifTrue: [^self addField: aHtmlField].
	self
		setCellTypeAndGetClass;
		add: '<a href="' , url , '">';
		add: aHtmlField;
		add: '</a>'.
	^aHtmlField!

addField: aHtmlField linkTo: url linkTitle: linkTitle 
	viewOnly == true ifTrue: [^self addField: aHtmlField].
	self
		setCellTypeAndGetClass;
		add: '<a href="' , url , '" title="' , linkTitle asWebString webHtmlEncoded , '">';
		add: aHtmlField;
		add: '</a>'!

addHeader: aString bgColor: bgColor 
	(self cell)
		cssClass: headerClass;
		noWrap.
	self
		add: '&nbsp;' , aString webTranslate , '&nbsp;';
		nextCell!

addHeader: aString cellWidthPx: pxWidth sortSelector: aSymbol 
	| sortSelector |
	sortSelector := overviewTaskUrlPrefix isNil ifFalse: [aSymbol].
	(self cell)
		cssClass: headerClass;
		noWrap.
	headerAlignment isNil ifFalse: [self cellAlignment: headerAlignment].
	self add: '&nbsp;'.
	sortSelector isNil 
		ifFalse: 
			[self 
				add: '<a href="' , overviewTaskUrlPrefix , '?_sortBy=' , sortSelector 
						, ((overviewTaskSortString asWebString endsWith: sortSelector , '.asc') 
								ifTrue: ['.desc']
								ifFalse: ['.asc']) 
							, '">'].
	self add: aString webTranslate.
	sortSelector isNil 
		ifFalse: 
			[self add: '</a>'.
			(overviewTaskSortString asWebString endsWith: sortSelector , '.asc') 
				ifTrue: [self add: '<img src="images/sort-asc.gif" width="11" height="10" alt="" />'].
			(overviewTaskSortString asWebString endsWith: sortSelector , '.desc') 
				ifTrue: [self add: '<img src="images/sort-desc.gif" width="11" height="10" alt="" />']].
	self
		add: '&nbsp;';
		nextCell!

addHeader: aString linkTo: url 
	(self cell)
		cssClass: headerClass;
		noWrap.
	self
		add: '&nbsp;<a href="' , url , '">' , aString webTranslate , '</a>&nbsp;';
		nextCell!

addHeader: aString linkTo: url deleteLinkTo: deleteUrl 
	(self cell)
		cssClass: headerClass;
		noWrap.
	self add: '&nbsp;<a href="' , url , '">' , aString webTranslate , '</a>&nbsp;&nbsp'.
	super
		addImage: 'images/delete.gif'
			width: 14
			height: 13
			toolTip: 'asp.label.helpTip.Delete'
			linkTo: deleteUrl;
		nextCell!

addHeader: aString sortSelector: aSymbol 
	^self 
		addHeader: aString
		cellWidthPx: nil
		sortSelector: aSymbol!

addHeader3: anArray 
	self addHeader3: anArray withIds: nil!

addHeader3: anArray withIds: idArrayOrNil 
	self cell cssClass: headerClass.
	self
		cellId: (idArrayOrNil isNil ifFalse: [idArrayOrNil at: 1]);
		colSpan: 2;
		add: ((HtmlTable noSpacing: 2)
					width: '100%';
					colSpan: 2;
					cellNoWrap;
					cellAlignmentCenter;
					add: '&nbsp;' , (anArray at: 1) webTranslate , '&nbsp;';
					nextCell;
					cellAlignmentCenter;
					cellId: (idArrayOrNil isNil ifFalse: [idArrayOrNil at: 2]);
					add: '&nbsp;' , (anArray at: 2) webTranslate , '&nbsp;';
					nextCell;
					cellAlignmentCenter;
					cellId: (idArrayOrNil isNil ifFalse: [idArrayOrNil at: 3]);
					add: '&nbsp;' , (anArray at: 3) webTranslate , '&nbsp;';
					yourself);
		nextCell!

addHeaderField: aHtmlElement 
	(self cell)
		cssClass: headerClass;
		noWrap.
	self
		add: aHtmlElement;
		nextCell!

addHeaderLeft: aString 
	(self cell)
		cssClass: headerClass;
		noWrap.
	self
		add: '&nbsp;' , aString webTranslate , '&nbsp;';
		nextCell!

addHighlitedData: anObject 
	self
		cellHighlighted: true;
		add: '&nbsp;' , anObject asWebString webHtmlEncoded , '&nbsp;';
		nextCell!

addHighlitedData: anObject onClick: script 
	viewOnly == true ifTrue: [^self addHighlitedData: anObject].
	self
		cellHighlighted: true;
		add: '&nbsp;<a href="javascript:void(0);" onclick="' , script , '">' 
					, anObject asWebString webHtmlEncoded , '</a>&nbsp;';
		nextCell!

addHighlitedShortData: anObject 
	self
		cellHighlighted: true;
		add: '&nbsp;' , anObject asShortWebString webHtmlEncoded , '&nbsp;';
		nextCell!

addImage: imgSrc toolTip: toolTip linkTo: url 
	self
		setCellTypeAndGetClass;
		add: '<a href="' , url , '"><img src="' , imgSrc , '" alt="' , toolTip webTranslate 
					, '" border="0"/></a>';
		nextCell!

addImage: imgSrc width: w height: h toolTip: toolTip target: linkTarget onClick: onClick linkTo: url 
	| str |
	str := toolTip webTranslate.
	self
		setCellTypeAndGetClass;
		add: '<a href="' , url , '" target="' , linkTarget , '"><img src="' , imgSrc , '" width=' 
					, w printString , ' height=' 
					, h printString , ' alt="' 
					, str , '" title="' 
					, str , '" onclick="' 
					, onClick , '" border="0"/></a>';
		nextCell!

addItalicData: anObject 
	self
		setCellTypeAndGetClass;
		add: '&nbsp;<i>' , anObject asWebString webHtmlEncoded , '</i>&nbsp;';
		nextCell!

addLabel: aString 
	self
		addField: aString webTranslate;
		nextCell!

addMoneyData: anObject highlighted: aBooleanOrSymbol 
	| str value |
	str := (anObject class == Array or: [anObject isMoney]) 
				ifTrue: 
					[anObject first isString 
						ifTrue: 
							[anObject first webHtmlEncoded add: anObject last asWebString webHtmlEncoded withDelimiter: '&nbsp;']
						ifFalse: 
							[value := anObject isMoney 
										ifTrue: [anObject]
										ifFalse: [Money amount: anObject first currency: anObject last].
							value asWebStringForHtml]]
				ifFalse: 
					[value := anObject.
					value isInteger ifTrue: [value := value asDecimalOrFloat].
					value asWebString webHtmlEncoded].
	self
		setCellTypeAndGetClass;
		cellHighlighted: aBooleanOrSymbol;
		cellAlignmentRight;
		cellNoWrap;
		space.
	((value isNumber and: [value < 0]) or: [value isNil and: [str notEmpty and: [str first == $-]]]) 
		ifTrue: [self addText: str withColor: 'red']
		ifFalse: [self add: str].
	self
		space;
		nextCell!

addMoneyData: anObject linkTo: url 
	^self 
		addMoneyData: anObject
		precision: 2
		linkTo: url!

addMoneyData: anObject precision: precision 
	^self 
		addMoneyData: anObject
		precision: precision
		linkTo: nil!

addMoneyData: anObject precision: precision linkTo: url 
	| str value |
	str := (anObject class == Array or: [anObject isMoney]) 
				ifTrue: 
					[anObject first isString 
						ifTrue: 
							[anObject first webHtmlEncoded add: anObject last asWebString webHtmlEncoded withDelimiter: '&nbsp;']
						ifFalse: 
							[value := anObject isMoney 
										ifTrue: [anObject]
										ifFalse: [Money amount: anObject first currency: anObject last].
							value asWebStringForHtmlWithPrecision: precision]]
				ifFalse: 
					[value := anObject.
					value isInteger ifTrue: [value := value asDecimalOrFloat].
					(value asWebStringWithPrecision: precision) webHtmlEncoded].
	self
		setCellTypeAndGetClass;
		cellAlignmentRight;
		cellNoWrap;
		space.
	url isNil 
		ifTrue: 
			[((value isNumber and: [value < 0]) or: [value isNil and: [str notEmpty and: [str first == $-]]]) 
				ifTrue: [self addText: str withColor: 'red']
				ifFalse: [self add: str]]
		ifFalse: [self add: str linkTo: url].
	self
		space;
		nextCell!

addMoneyDataNotNextCell: anObject highlighted: aBooleanOrSymbol 
	| str value |
	str := (anObject class == Array or: [anObject isMoney]) 
				ifTrue: 
					[anObject first isString 
						ifTrue: 
							[anObject first webHtmlEncoded add: anObject last asWebString webHtmlEncoded withDelimiter: '&nbsp;']
						ifFalse: 
							[value := anObject isMoney 
										ifTrue: [anObject]
										ifFalse: [Money amount: anObject first currency: anObject last].
							value asWebStringForHtml]]
				ifFalse: 
					[value := anObject.
					value isInteger ifTrue: [value := value asDecimalOrFloat].
					value asWebString webHtmlEncoded].
	self
		setCellTypeAndGetClass;
		cellHighlighted: aBooleanOrSymbol;
		cellAlignmentRight;
		space.
	((value isNumber and: [value < 0]) or: [value isNil and: [str notEmpty and: [str first == $-]]]) 
		ifTrue: 
			[self
				cellNoWrap;
				addText: str withColor: 'red']
		ifFalse: [self add: str].
	self space!

addMoneyDataWith2OrMoreDecimals: anObject 
	| str value |
	str := (anObject class == Array or: [anObject isMoney]) 
				ifTrue: 
					[anObject first isString 
						ifTrue: 
							[anObject first webHtmlEncoded add: anObject last asWebString webHtmlEncoded withDelimiter: '&nbsp;']
						ifFalse: 
							[value := anObject isMoney 
										ifTrue: [anObject]
										ifFalse: [Money amount: anObject first currency: anObject last].
							value asWebStringForHtmlWith2OrMoreDecimals]]
				ifFalse: 
					[value := anObject.
					value isInteger ifTrue: [value := value asDecimalOrFloat].
					value asWebStringWith2OrMoreDecimals webHtmlEncoded].
	self
		setCellTypeAndGetClass;
		cellAlignmentRight;
		space.
	((value isNumber and: [value < 0]) or: [value isNil and: [str notEmpty and: [str first == $-]]]) 
		ifTrue: 
			[self
				cellNoWrap;
				addText: str withColor: 'red']
		ifFalse: [self add: str].
	self
		space;
		nextCell!

addMoneyDataWithMinimumDecimals: anObject 
	| str value |
	str := (anObject class == Array or: [anObject isMoney]) 
				ifTrue: 
					[anObject first isString 
						ifTrue: 
							[anObject first webHtmlEncoded add: anObject last asWebString webHtmlEncoded withDelimiter: '&nbsp;']
						ifFalse: 
							[value := anObject isMoney 
										ifTrue: [anObject]
										ifFalse: [Money amount: anObject first currency: anObject last].
							value asWebStringForHtmlWithMinimumDecimals]]
				ifFalse: 
					[value := anObject.
					value isInteger ifTrue: [value := value asDecimalOrFloat].
					value asWebStringWithMinimumDecimals webHtmlEncoded].
	self
		setCellTypeAndGetClass;
		cellAlignmentRight;
		space.
	((value isNumber and: [value < 0]) or: [value isNil and: [str notEmpty and: [str first == $-]]]) 
		ifTrue: 
			[self
				cellNoWrap;
				addText: str withColor: 'red']
		ifFalse: [self add: str].
	self
		space;
		nextCell!

addPrintLinkTo: url 
	self
		addImage: 'images/print.gif'
			width: 16
			height: 14
			toolTip: 'asp.label.helpTip.Print'
			linkTo: url;
		nextCell!

addRawData: anObject 
	self
		setCellTypeAndGetClass;
		cellVerticalAlignment: 'top';
		add: anObject;
		nextCell!

addRawHeader: aString 
	(self cell)
		cssClass: 'ltbHd';
		noWrap.
	self
		add: aString;
		nextCell!

addSelectRowField: checkFieldPrefix id: itemId 
	self 
		addSelectRowField: checkFieldPrefix
		id: itemId
		selected: false!

addSelectRowField: checkFieldPrefix id: itemId selected: selectBool 
	self
		cellAlignmentCenter;
		addCheckBox: checkFieldPrefix , '_' , itemId asWebString
			checked: selectBool == true
			onClick: checkFieldPrefix , '_checkSelection()';
		nextCell!

addSelectRowsHeader: checkFieldPrefix 
	(self cell)
		cssClass: headerClass;
		alignment: 'center'.
	self
		addJavascript: 'var menuListenerAdded=false, imgCbChecked="images/cb-checked.gif", imgCbCheckedStr="cb-checked.gif", imgCbUnchecked="images/cb.gif", imgCbDisabled="images/cb-checked-disabled.gif"; function ' 
					, checkFieldPrefix 
						, '_getActionUrlWithSelection(action){
var selectionString="";
for(i=0;i<document.form.elements.length;i++){
if(document.form.elements[i].type=="checkbox" && document.form.elements[i].name.substr(0,' 
						, (checkFieldPrefix size + 1) printString , ')=="' 
					, checkFieldPrefix 
						, '_"){
if(document.form.elements[i].checked)selectionString+=document.form.elements[i].name.replace("' 
						, checkFieldPrefix 
						, '_",",");
}};
if(selectionString.length>0 && selectionString.substr(0,1) == ",") selectionString = selectionString.substr(1,selectionString.length);
return "' 
						, Processor activeProcess webTask taskURLPrefix , '?action="+action+"&table=' 
					, checkFieldPrefix , '&sel="+selectionString;
};
function ' 
					, checkFieldPrefix , '_sendRequest(action){
ajaxGetRequest(' 
					, checkFieldPrefix , '_getActionUrlWithSelection(action));
};
function ' 
					, checkFieldPrefix 
						, '_checkSelection(){
var allOff,allOn,selectionCount,count,firstIndex,lastIndex,el;
allOff=true;allOn=true;
selectionCount=count=0;
for(i=0;i<document.form.elements.length;i++){
if(document.form.elements[i].type=="checkbox" && document.form.elements[i].name.substr(0,' 
						, (checkFieldPrefix size + 1) printString , ')=="' 
					, checkFieldPrefix 
						, '_"){
count++;
if(document.form.elements[i].checked)
{allOff=false;
if(firstIndex==null)firstIndex=count;
lastIndex=count;
selectionCount++;
}
else allOn=false;
}}
if(!!allOff&&!!allOn){document.form.checkAll_' 
						, checkFieldPrefix , '.src=imgCbDisabled}
else{
document.form.checkAll_' 
					, checkFieldPrefix , '.src=imgCbUnchecked;
if(allOff&&allOn) document.form.checkAll_' 
					, checkFieldPrefix , '.src=imgCbUnchecked;
if(allOff&&!!allOn) document.form.checkAll_' 
					, checkFieldPrefix , '.src=imgCbUnchecked;
if(!!allOff&&allOn) document.form.checkAll_' 
					, checkFieldPrefix , '.src=imgCbChecked;
}
if(el=commonGetElementById("' 
					, checkFieldPrefix 
						, '_btnCopy")){
if(selectionCount==1){el.className="toolBarIcon itcBgIconCopy";el.href="javascript:' 
						, checkFieldPrefix , '_sendRequest(\"' 
					, #ajaxGetTableBarRowCopy 
						, '\");void(0);";}
else{el.className="toolBarIcon itcBgIconCopy disabled";el.href="javascript:void(0);";}
}
if(el=commonGetElementById("' 
						, checkFieldPrefix 
						, '_btnRemove")){
if(selectionCount>0){el.className="toolBarIcon itcBgIconDelete";el.href="javascript:' 
						, checkFieldPrefix , '_sendRequest(\"' 
					, #ajaxGetTableBarRowsRemove 
						, '\");void(0);";}
else{el.className="toolBarIcon itcBgIconDelete disabled";el.href="javascript:void(0);";}
}
if(el=commonGetElementById("' 
						, checkFieldPrefix 
						, '_btnAdditionalOptionsMenuButton")){
if(selectionCount>0){el.className="toolBarPopUp";if(!!menuListenerAdded){ITC.event.AddListener("mousedown", el, show_' 
						, checkFieldPrefix 
						, '_btnAdditionalOptionsMenu);menuListenerAdded=true}}
else{el.className="toolBarPopUp disabled";el.onmousedown="";ITC.event.RemoveListener("mousedown", el, show_' 
						, checkFieldPrefix 
						, '_btnAdditionalOptionsMenu);menuListenerAdded=false}
}
if(el=commonGetElementById("' 
						, checkFieldPrefix 
						, '_btnMoveTop")){
if((selectionCount==1 && firstIndex>1)||selectionCount>1){el.className="toolBarIcon itcBgIconMoveTop";el.href="javascript:' 
						, checkFieldPrefix , '_sendRequest(\"' 
					, #ajaxGetTableBarRowsTop 
						, '\");void(0);";}
else{el.className="toolBarIcon itcBgIconMoveTop disabled";el.href="javascript:void(0);";}
}

if(el=commonGetElementById("' 
						, checkFieldPrefix 
						, '_btnMoveUp")){
if((selectionCount==1 && firstIndex>1)||selectionCount>1){el.className="toolBarIcon itcBgIconMoveUp";el.href="javascript:' 
						, checkFieldPrefix , '_sendRequest(\"' 
					, #ajaxGetTableBarRowsUp 
						, '\");void(0);";}
else{el.className="toolBarIcon itcBgIconMoveUp disabled";el.href="javascript:void(0);";}
}

if(el=commonGetElementById("' 
						, checkFieldPrefix 
						, '_btnMoveDown")){
if((selectionCount==1 && lastIndex<count)||selectionCount>1){el.className="toolBarIcon itcBgIconMoveDown";el.href="javascript:' 
						, checkFieldPrefix , '_sendRequest(\"' 
					, #ajaxGetTableBarRowsDown 
						, '\");void(0);";}
else{el.className="toolBarIcon itcBgIconMoveDown disabled";el.href="javascript:void(0);";}
}

if(el=commonGetElementById("' 
						, checkFieldPrefix 
						, '_btnMoveBottom")){
if((selectionCount==1 && lastIndex<count)||selectionCount>1){el.className="toolBarIcon itcBgIconMoveBottom";el.href="javascript:' 
						, checkFieldPrefix , '_sendRequest(\"' 
					, #ajaxGetTableBarRowsBottom 
						, '\");void(0);";}
else{el.className="toolBarIcon itcBgIconMoveBottom disabled";el.href="javascript:void(0);";}
}

};
function ' 
						, checkFieldPrefix , '_toggleSelection(){
var checkAllArr=document.form.checkAll_' 
					, checkFieldPrefix 
						, '.src.split("/"), newState;
newState=checkAllArr[checkAllArr.length-1]!!=imgCbCheckedStr;

if(newState)
{document.form.checkAll_' 
						, checkFieldPrefix , '.src=imgCbUnchecked}
else
{document.form.checkAll_' 
					, checkFieldPrefix 
						, '.src=imgCbChecked};
for(i=0;i<document.form.elements.length;i++){
if(document.form.elements[i].type=="checkbox" && document.form.elements[i].name.substr(0,' 
						, (checkFieldPrefix size + 1) printString , ')=="' 
					, checkFieldPrefix , '_")document.form.elements[i].checked=newState;}
' 
					, checkFieldPrefix , '_checkSelection();}';
		cellOnClick: checkFieldPrefix , '_toggleSelection();';
		cellStyle: 'cursor:pointer;cursor:hand;padding:2px';
		add: '<img id="checkAll_' , checkFieldPrefix , '" src="images/cb.gif" width="14" height="14" />';
		nextCell!

addShortData: anObject 
	self
		setCellTypeAndGetClass;
		add: '&nbsp;' , anObject asShortWebString webHtmlEncoded , '&nbsp;';
		nextCell!

addShortData: anObject highlighted: aBooleanOrSymbol 
	self
		addField: '&nbsp;' , anObject asShortWebString webHtmlEncoded , '&nbsp;';
		cellHighlighted: aBooleanOrSymbol;
		nextCell!

addShortData: anObject linkTo: url 
	(viewOnly == true or: [url isNilOrEmpty]) ifTrue: [^self addShortData: anObject].
	self
		setCellTypeAndGetClass;
		add: '&nbsp;<a href="' , url webXhtmlUrlEncodeForForm , '">' 
					, anObject asShortWebString webHtmlEncoded , '</a>&nbsp;';
		nextCell!

addSmallData: anObject 
	self
		setCellTypeAndGetClass;
		cellVerticalAlignment: 'middle';
		add: (anObject = ' ' 
					ifTrue: ['&nbsp;']
					ifFalse: ['<small>' , anObject asWebString webHtmlEncoded , '</small>']);
		nextCell!

getRowBeginTagForFirstCell: aTableCell rowIndex: rowIndex 
	| str |
	aTableCell isNil 
		ifTrue: 
			[^(rowIdentifiers isNil or: [(rowIdentifiers at: rowIndex ifAbsent: []) isNilOrEmpty]) 
				ifTrue: ['<tr>']
				ifFalse: ['<tr id="' , (rowIdentifiers at: rowIndex) , '">']].
	str := '<tr'.
	rowIdentifiers isNil ifFalse: [str := str , ' id="' , rowIdentifiers , '"'].
	aTableCell cellType == #dataCellEven 
		ifTrue: [str := str , ' style="background-color:' , self colorForEvenRow , '"'].
	aTableCell cellType == #dataCellOdd 
		ifTrue: [str := str , ' style="background-color:' , self colorForOddRow , '"'].
	^str , '>'!

headerClass
	^headerClass!

leftStickyColumns
	" zaradi kompatibilnosti s SortedListTable "

	^nil!

leftStickyColumns: anInteger 
	" zaradi kompatibilnosti s SortedListTable "

	^nil!

overviewTaskSortString: aString 
	overviewTaskSortString := aString!

overviewTaskUrlPrefix: aWebTask 
	overviewTaskUrlPrefix := aWebTask!

rightStickyColumns
	" zaradi kompatibilnosti s SortedListTable "

	^nil!

rightStickyColumns: anInteger 
	" zaradi kompatibilnosti s SortedListTable "

	^nil!

setCellTypeAndGetClass
	| cell class |
	cell := self cell.
	cell cellType: (self getRowIndex even = prestop 
				ifTrue: 
					[class := evenClass.
					#dataCellEven]
				ifFalse: 
					[class := oddClass.
					#dataCellOdd]).
	cell cssClass: class.
	^class!

setColumns: nrColumns

	cssClass := 'listTable'.
	prestop := true.
	self showEnabled.
	super setColumns: nrColumns.!

setEditMode

	viewOnly := false!

setViewOnly

	viewOnly := true!

showCenteredHeaders
	headerAlignment := 'center'!

showDisabled
	disabled := true.
	headerClass := 'ltbHd'.
	evenClass := 'ltbEvGrey'.
	oddClass := 'ltbOdGrey'!

showEnabled
	disabled := false.
	headerClass := 'ltbHd'.
	evenClass := 'ltbEv'.
	oddClass := 'ltbOd'!

showNormal
	showSmall := false.
	headerClass := 'ltbHd'.
	evenClass := 'ltbEv'.
	oddClass := 'ltbOd'!

showSmall
	showSmall := true.
	headerClass := 'ltbHdSml'.
	evenClass := 'ltbEvSml'.
	oddClass := 'ltbOdSml'!

showSmallVerticalHeaderText
	showSmall := true.
	headerClass := 'ltbHdSmlVertical'.
	evenClass := 'ltbEvSml'.
	oddClass := 'ltbOdSml'!

showSumRow

	evenClass := 'sumEv'.
	oddClass := 'sumOd'.!

skipRowSwitch

	prestop := prestop not! !
!HtmlListTable categoriesFor: #addBoldData:!public! !
!HtmlListTable categoriesFor: #addBoldData:linkTo:!public! !
!HtmlListTable categoriesFor: #addBoldDataLabel:!public! !
!HtmlListTable categoriesFor: #addBoldHeader:!public! !
!HtmlListTable categoriesFor: #addBoldMoneyDataWith2OrMoreDecimals:!public! !
!HtmlListTable categoriesFor: #addBoldMoneyDataWithMinimumDecimals:!public! !
!HtmlListTable categoriesFor: #addBoldRawHeader:!public! !
!HtmlListTable categoriesFor: #addBookLinkTo:toolTip:!public! !
!HtmlListTable categoriesFor: #addData:!public! !
!HtmlListTable categoriesFor: #addData:cssClass:!public! !
!HtmlListTable categoriesFor: #addData:fieldName:errors:!public! !
!HtmlListTable categoriesFor: #addData:fontSize:!public! !
!HtmlListTable categoriesFor: #addData:highlighted:!public! !
!HtmlListTable categoriesFor: #addData:linkInNewWindowTo:!public! !
!HtmlListTable categoriesFor: #addData:linkTo:!public! !
!HtmlListTable categoriesFor: #addData:linkTo:linkTitle:!public! !
!HtmlListTable categoriesFor: #addData:onClick:!public! !
!HtmlListTable categoriesFor: #addDataNoSpace:!public! !
!HtmlListTable categoriesFor: #addDataNoSpace:cssClass:!public! !
!HtmlListTable categoriesFor: #addField:!public! !
!HtmlListTable categoriesFor: #addField:linkInNewWindowTo:!public! !
!HtmlListTable categoriesFor: #addField:linkTo:!public! !
!HtmlListTable categoriesFor: #addField:linkTo:linkTitle:!public! !
!HtmlListTable categoriesFor: #addHeader:bgColor:!public! !
!HtmlListTable categoriesFor: #addHeader:cellWidthPx:sortSelector:!public! !
!HtmlListTable categoriesFor: #addHeader:linkTo:!public! !
!HtmlListTable categoriesFor: #addHeader:linkTo:deleteLinkTo:!public! !
!HtmlListTable categoriesFor: #addHeader:sortSelector:!public! !
!HtmlListTable categoriesFor: #addHeader3:!public! !
!HtmlListTable categoriesFor: #addHeader3:withIds:!public! !
!HtmlListTable categoriesFor: #addHeaderField:!public! !
!HtmlListTable categoriesFor: #addHeaderLeft:!public! !
!HtmlListTable categoriesFor: #addHighlitedData:!public! !
!HtmlListTable categoriesFor: #addHighlitedData:onClick:!public! !
!HtmlListTable categoriesFor: #addHighlitedShortData:!public! !
!HtmlListTable categoriesFor: #addImage:toolTip:linkTo:!public! !
!HtmlListTable categoriesFor: #addImage:width:height:toolTip:target:onClick:linkTo:!public! !
!HtmlListTable categoriesFor: #addItalicData:!public! !
!HtmlListTable categoriesFor: #addLabel:!public! !
!HtmlListTable categoriesFor: #addMoneyData:highlighted:!public! !
!HtmlListTable categoriesFor: #addMoneyData:linkTo:!public! !
!HtmlListTable categoriesFor: #addMoneyData:precision:!public! !
!HtmlListTable categoriesFor: #addMoneyData:precision:linkTo:!public! !
!HtmlListTable categoriesFor: #addMoneyDataNotNextCell:highlighted:!public! !
!HtmlListTable categoriesFor: #addMoneyDataWith2OrMoreDecimals:!public! !
!HtmlListTable categoriesFor: #addMoneyDataWithMinimumDecimals:!public! !
!HtmlListTable categoriesFor: #addPrintLinkTo:!public! !
!HtmlListTable categoriesFor: #addRawData:!public! !
!HtmlListTable categoriesFor: #addRawHeader:!public! !
!HtmlListTable categoriesFor: #addSelectRowField:id:!public! !
!HtmlListTable categoriesFor: #addSelectRowField:id:selected:!public! !
!HtmlListTable categoriesFor: #addSelectRowsHeader:!public! !
!HtmlListTable categoriesFor: #addShortData:!public! !
!HtmlListTable categoriesFor: #addShortData:highlighted:!public! !
!HtmlListTable categoriesFor: #addShortData:linkTo:!public! !
!HtmlListTable categoriesFor: #addSmallData:!public! !
!HtmlListTable categoriesFor: #getRowBeginTagForFirstCell:rowIndex:!generating HTML!private! !
!HtmlListTable categoriesFor: #headerClass!public! !
!HtmlListTable categoriesFor: #leftStickyColumns!public! !
!HtmlListTable categoriesFor: #leftStickyColumns:!public! !
!HtmlListTable categoriesFor: #overviewTaskSortString:!public! !
!HtmlListTable categoriesFor: #overviewTaskUrlPrefix:!public! !
!HtmlListTable categoriesFor: #rightStickyColumns!public! !
!HtmlListTable categoriesFor: #rightStickyColumns:!public! !
!HtmlListTable categoriesFor: #setCellTypeAndGetClass!private! !
!HtmlListTable categoriesFor: #setColumns:!public! !
!HtmlListTable categoriesFor: #setEditMode!public! !
!HtmlListTable categoriesFor: #setViewOnly!public! !
!HtmlListTable categoriesFor: #showCenteredHeaders!public! !
!HtmlListTable categoriesFor: #showDisabled!public! !
!HtmlListTable categoriesFor: #showEnabled!public! !
!HtmlListTable categoriesFor: #showNormal!public! !
!HtmlListTable categoriesFor: #showSmall!public! !
!HtmlListTable categoriesFor: #showSmallVerticalHeaderText!public! !
!HtmlListTable categoriesFor: #showSumRow!public! !
!HtmlListTable categoriesFor: #skipRowSwitch!public! !

!HtmlListTable class methodsFor!

columnTypeDate
	^2!

columnTypeNumber
	^1!

columnTypeString
	^0! !
!HtmlListTable class categoriesFor: #columnTypeDate!public! !
!HtmlListTable class categoriesFor: #columnTypeNumber!public! !
!HtmlListTable class categoriesFor: #columnTypeString!public! !

