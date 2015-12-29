"Filed out from Dolphin Smalltalk X6.1"!

HtmlAbstractTable subclass: #HtmlTable
	instanceVariableNames: 'columns position border width height cellSpacing cellPadding alignment verticalAlignment fieldRowSpan cellWidths defaultFontSize rowBorderTop rowBorderBottom onDoubleClick onMouseOver onMouseOut borderColor onMouseClick rowIdentifiers rowDisplay'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlTable guid: (GUID fromString: '{8C5B4965-B565-44AC-944B-652A474098AC}')!
HtmlTable comment: ''!
!HtmlTable categoriesForClass!Unclassified! !
!HtmlTable methodsFor!

add: anObject 
	anObject isNil ifTrue: [self cell add: '&nbsp;'] ifFalse: [self cell add: anObject]!

addActionButtons: anArray 
	| buttonsTable stream action button label waitNotice |
	anArray isNilOrEmpty ifTrue: [^self].
	buttonsTable := HtmlTable columns: anArray size // 2.
	buttonsTable
		cellPadding: 0;
		cellSpacing: 1.
	self
		spanRow;
		add: buttonsTable.
	stream := ReadStream on: anArray.
	[stream atEnd] whileFalse: 
			[((action := stream next) isNil or: [action = 1]) 
				ifTrue: [buttonsTable space]
				ifFalse: 
					[waitNotice := false.
					action := action webAsActionString.
					label := stream next.
					action first = $# 
						ifTrue: 
							[action := action copyFrom: 2.
							waitNotice := true]
						ifFalse: 
							[label first = $# 
								ifTrue: 
									[label := label copyFrom: 2.
									waitNotice := true]].
					button := HtmlButton name: 'BUTTON_' , action label: label webTranslate.
					waitNotice = true ifTrue: [button pleaseWaitNotice: true].
					buttonsTable
						add: button;
						nextCell]]!

addAutoDropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value width: fieldWidth 
	self
		addField: (((HtmlDropDownList name: fieldName)
					items: items;
					automatic: true;
					displaySelector: displaySelector;
					valueSelector: valueSelector;
					value: value) cssStyle: 'width:' 
								, (fieldWidth isString ifTrue: [fieldWidth] ifFalse: [fieldWidth printString , 'px']));
		nextCell!

addBoldData: anObject 
	self
		cellVerticalAlignment: 'top';
		add: '<b>' , anObject asWebString webHtmlEncoded , '</b>';
		nextCell!

addBoldData: anObject fontSize: fontSize 
	self
		add: '<span style="font-size: ' , fontSize printString , 'pt;"><b>';
		add: (anObject = ' ' ifTrue: ['&nbsp;'] ifFalse: [anObject asWebString webHtmlEncoded]);
		add: '</b></span>';
		nextCell!

addBoldData: anObject linkTo: url 
	self
		cellVerticalAlignment: 'top';
		add: '<a href="' , url , '"><b>';
		add: anObject asWebString webHtmlEncoded;
		add: '</b></a>';
		nextCell!

addBoldDataLabel: anObject 
	self
		cellVerticalAlignmentTop;
		add: '<b>' , anObject webTranslate webHtmlEncoded , ':</b>';
		nextCell!

addBoldLabel: aString 
	self addLabel: '<b>' , aString webTranslate , '</b>'!

addBoldMoneyData: anObject 
	self addBoldMoneyData: anObject precision: 2!

addBoldMoneyData: anObject precision: precision 
	| str value |
	str := (anObject class == Array or: [anObject isMoney]) 
				ifTrue: 
					[value := anObject isMoney 
								ifTrue: [anObject]
								ifFalse: [Money amount: anObject first currency: anObject last].
					value asWebStringForHtmlWithPrecision: precision]
				ifFalse: 
					[value := anObject.
					value isInteger ifTrue: [value := value asDecimalOrFloat].
					(value asWebStringWithPrecision: precision) webHtmlEncoded].
	self
		cellAlignmentRight;
		cellNoWrap;
		space.
	(value isNumber and: [value < 0]) 
		ifTrue: [self addBold: str withColor: 'red']
		ifFalse: [self addBold: str].
	self
		space;
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

addBoldText: anObject 
	"NOTE: text is HTML encoded, so $> will be converted to &gt; and line break will be converted to <br />."

	anObject isNilOrEmpty 
		ifTrue: [self space]
		ifFalse: 
			[anObject isString 
				ifTrue: [self addText: '<b>' , anObject webHtmlEncoded , '</b>']
				ifFalse: 
					[(self cell)
						add: '<b>';
						add: anObject;
						add: '</b>']]!

addBooleanField: fieldName valueFrom: anObject label: aString 
	self
		addBooleanField: fieldName valueFrom: anObject;
		nextCell;
		add: aString webTranslate;
		nextCell!

addCenter: anObject

	self cellAlignment: 'center'; add: anObject!

addData: anObject 
	self
		cellVerticalAlignmentTop;
		add: (anObject = ' ' ifTrue: ['&nbsp;'] ifFalse: [anObject asWebString webHtmlEncoded]);
		nextCell!

addData: anObject alwaysLinkTo: url 
	^self addData: (anObject isNilOrEmpty ifTrue: ['   '] ifFalse: [anObject]) linkTo: url!

addData: anObject fieldName: fieldName errors: errors 
	self
		cellVerticalAlignment: 'top';
		add: (anObject = ' ' ifTrue: ['&nbsp;'] ifFalse: [anObject asWebString webHtmlEncoded]);
		addFormFieldErrorTextFor: fieldName
			from: errors
			break: anObject asWebString isNilOrEmpty not;
		nextCell!

addData: anObject fontSize: fontSize 
	self
		add: '<span style="font-size: ' , fontSize printString , 'pt;">';
		add: (anObject = ' ' ifTrue: ['&nbsp;'] ifFalse: [anObject asWebString webHtmlEncoded]);
		add: '</span>';
		nextCell!

addData: anObject linkInNewWindowTo: url width: winWidth height: winHeight 
	| winStats |
	winStats := 'scrollbars=yes,resizable=1'.
	winWidth notNil ifTrue: [winStats := winStats , ',width=' , winWidth printString].
	winHeight notNil ifTrue: [winStats := winStats , ',height=' , winHeight printString].
	self
		cellVerticalAlignment: 'top';
		add: '<a href="javascript:void(0)" onclick="window.open(''' , url , ''', '''', ''' 
					, winStats , ''')">';
		add: anObject asWebString webHtmlEncoded;
		add: '</a>';
		nextCell!

addData: anObject linkTo: url 
	self
		cellVerticalAlignmentTop;
		add: '<a href="' , url , '">';
		add: anObject asWebString webHtmlEncoded;
		add: '</a>';
		nextCell!

addData: anObject linkTo: url target: target 
	self
		cellVerticalAlignment: 'top';
		add: '<a href="' , url , '" target="' , target , '">';
		add: anObject asWebString webHtmlEncoded;
		add: '</a>';
		nextCell!

addData: anObject linkTo: url title: aString 
	self
		cellVerticalAlignment: 'top';
		add: '<a href="' , url , '" title="' , aString asWebString webHtmlEncodedForForm , '">';
		add: anObject asWebString webHtmlEncoded;
		add: '</a>';
		nextCell!

addData: anObject linkTo: url title: aString target: target 
	self
		cellVerticalAlignment: 'top';
		add: '<a href="' , url , '" title="' , aString asWebString webHtmlEncodedForForm 
					, '" target="' , target 
					, '">';
		add: anObject asWebString webHtmlEncoded;
		add: '</a>';
		nextCell!

addDataOrSpace: anObject 
	anObject isNilOrEmpty ifTrue: [self addData: ' '] ifFalse: [self addData: anObject]!

addDataRight: anObject 
	self
		cellAlignmentRight;
		addData: anObject!

addHeader: anObject cellWidthPx: w sortSelector: sortSelector 
	^self addData: (anObject isString ifTrue: [anObject webTranslate] ifFalse: [anObject])!

addIntegerData: n 
	^self
		cellAlignment: 'right';
		addData: n!

addLabel: aString 
	"Adds a label into table. If this is not the first column it will insert a space before label.
	It will use dgLC - dialog label cell - class for the tabel cell with the label.
	It will translate aString before using it and add double colon : after the label."

	| str |
	str := aString webTranslate.
	self getColumnIndex = 1 ifFalse: [str := '&nbsp;&nbsp;' , str].
	self
		cellAlignmentRight;
		cellVerticalAlignmentTop;
		add: '<font class="dgLb">' , str , ':</font>';
		nextCell.
	fieldRowSpan == true ifTrue: [self spanRow]!

addLabel: labelString autoDropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value 
	self
		addLabel: labelString;
		addAutoDropDownList: fieldName
			items: items
			displaySelector: displaySelector
			valueSelector: valueSelector
			value: value;
		nextCell!

addLabel: labelString autoDropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value width: fieldWidth 
	self
		addLabel: labelString;
		addField: (((HtmlDropDownList name: fieldName)
					items: items;
					automatic: true;
					displaySelector: displaySelector;
					valueSelector: valueSelector;
					value: value) cssStyle: 'width:' 
								, (fieldWidth isString ifTrue: [fieldWidth] ifFalse: [fieldWidth printString , 'px']));
		nextCell!

addLabel: labelString autoDropDownList: fieldName itemsWithNil: items displaySelector: displaySelector valueSelector: valueSelector value: value 
	self
		addLabel: labelString;
		addField: ((HtmlDropDownList name: fieldName)
					automatic: true;
					itemsWithNil: items;
					displaySelector: displaySelector;
					valueSelector: valueSelector;
					value: value);
		nextCell!

addLabel: aString boldData: anObject 
	self
		addLabel: aString;
		cellVerticalAlignment: 'top';
		add: '<b>' , anObject asWebString webHtmlEncoded , '</b>';
		nextCell!

addLabel: labelString booleanField: fieldName value: aBoolean 
	| boolValue |
	boolValue := aBoolean.
	boolValue = 1 ifTrue: [boolValue := true].
	(boolValue = 0 or: [boolValue isNil]) ifTrue: [boolValue := false].
	self
		addLabel: labelString;
		addCheckBox: fieldName
			value: 'true'
			checked: aBoolean;
		nextCell!

addLabel: labelString booleanField: fieldName valueFrom: model 
	^self 
		addLabel: labelString
		booleanField: fieldName
		value: (self getValueFrom: model fieldName: fieldName)!

addLabel: aString data: anObject 
	self
		addLabel: aString;
		cellVerticalAlignment: 'top';
		add: anObject asWebString webHtmlEncoded;
		nextCell!

addLabel: aString data: anObject dataCellBackground: aColor 
	self
		addLabel: aString;
		cellVerticalAlignment: 'top';
		cellBackground: aColor;
		add: anObject asWebString webHtmlEncoded;
		nextCell!

addLabel: aString data: anObject fieldName: fieldName errors: errors 
	self
		addLabel: aString;
		cellVerticalAlignment: 'top';
		add: anObject asWebString webHtmlEncoded;
		addFormFieldErrorTextFor: fieldName
			from: errors
			break: anObject asWebString isNilOrEmpty not;
		nextCell!

addLabel: aString data: anObject fieldName: fieldName warnings: warnings 
	self
		addLabel: aString;
		cellVerticalAlignment: 'top';
		add: anObject asWebString webHtmlEncoded;
		addFormFieldWarningTextFor: fieldName
			from: warnings
			break: anObject asWebString isNilOrEmpty not;
		nextCell!

addLabel: aString data: anObject linkTo: url 
	self
		addLabel: aString;
		cellVerticalAlignment: 'top'.
	url isNil ifFalse: [self add: '<a href="' , url , '">'].
	self add: anObject asWebString webHtmlEncoded.
	url isNil ifFalse: [self add: '</a>'].
	self nextCell!

addLabel: aString dataOnlyIfNotNil: anObject 
	"Adds label and data only if not nil"

	anObject isNil 
		ifFalse: 
			[self
				addLabel: aString;
				cellVerticalAlignmentTop;
				add: anObject asWebString webHtmlEncoded;
				nextCell]!

addLabel: labelString dateField: textFieldName value: aDate 

	self addLabel: labelString dateField: textFieldName value: aDate baseDate: nil!

addLabel: labelString dateField: textFieldName value: aDate baseDate: baseDate 
	self
		addLabel: labelString;
		cellNoWrap;
		addDateField: textFieldName
			value: aDate
			mandatory: false
			baseDate: baseDate
			onChange: nil
			errors: nil;
		nextCell!

addLabel: labelString dateField: textFieldName value: aDate baseDate: baseDate errors: errorsDictionary

	self
		addLabel: labelString;
		addDateField: textFieldName value: aDate mandatory: false baseDate: baseDate onChange: nil errors: errorsDictionary;
		nextCell!

addLabel: labelString dateField: textFieldName value: aDate baseDate: baseDate hideFields: hideFields

	self
		addLabel: labelString;
		addDateField: textFieldName value: aDate mandatory: false baseDate: baseDate onChange: nil hideFields: hideFields errors: nil;
		nextCell!

addLabel: labelString dateField: textFieldName value: aDate baseDate: baseDate hideFields: hideFields errors: errors

	self
		addLabel: labelString;
		addDateField: textFieldName value: aDate mandatory: false baseDate: baseDate onChange: nil hideFields: hideFields errors: errors;
		nextCell!

addLabel: labelString dateField: textFieldName value: aDate errors: errorsDictionary
	^self 
		addLabel: labelString
		dateField: textFieldName
		value: aDate 
		baseDate: aDate
		errors: errorsDictionary!

addLabel: labelString dateField: textFieldName value: aDate floatCalendar: floatCalendar 
	self
		addLabel: labelString;
		cellNoWrap;
		addDateField: textFieldName
			value: aDate
			floatCalendar: floatCalendar;
		nextCell!

addLabel: labelString dateField: textFieldName value: aDate hideFields: hideFields errors: errors 
	self
		addLabel: labelString;
		addDateField: textFieldName
			value: aDate
			mandatory: false
			baseDate: nil
			onChange: nil
			hideFields: hideFields
			errors: errors;
		nextCell!

addLabel: labelString dateField: textFieldName valueFrom: aDate 
	^self 
		addLabel: labelString
		dateField: textFieldName
		value: (self getValueFrom: aDate fieldName: textFieldName)
		errors: nil!

addLabel: labelString dateField: textFieldName valueFrom: aDate baseDate: baseDate errors: errorsDictionary 
	^self 
		addLabel: labelString
		dateField: textFieldName
		value: (self getValueFrom: aDate fieldName: textFieldName)
		baseDate: baseDate
		errors: errorsDictionary!

addLabel: labelString dateField: textFieldName valueFrom: aDate errors: errorsDictionary 
	^self 
		addLabel: labelString
		dateField: textFieldName
		value: (self getValueFrom: aDate fieldName: textFieldName)
		errors: errorsDictionary!

addLabel: labelString dropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value 
	| field |
	self
		addLabel: labelString;
		addField: ((field := HtmlDropDownList name: fieldName)
					items: items;
					displaySelector: displaySelector;
					valueSelector: valueSelector;
					value: value);
		nextCell.
	^field!

addLabel: labelString dropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value onChange: onChange
	self
		addLabel: labelString;
		addField: ((HtmlDropDownList name: fieldName)
					items: items;
					displaySelector: displaySelector;
					valueSelector: valueSelector;
					value: value;
					onChange: onChange);
		nextCell!

addLabel: labelString dropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value width: fieldWidth 
	self
		addLabel: labelString;
		addField: ((HtmlDropDownList name: fieldName)
					items: items;
					displaySelector: displaySelector;
					valueSelector: valueSelector;
					value: value;
					width: fieldWidth);
		nextCell!

addLabel: labelString dropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value widthPt: widthPt 
	self
		addLabel: labelString;
		addField: ((HtmlDropDownList name: fieldName)
					items: items;
					displaySelector: displaySelector;
					valueSelector: valueSelector;
					value: value;
					cssStyle: (widthPt isNil ifFalse: ['width:' , widthPt asJavascriptValueWithDecimalsToFloats , 'pt;']);
					yourself);
		nextCell!

addLabel: labelString dropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector valueFrom: value 
	^self 
		addLabel: labelString
		dropDownList: fieldName
		items: items
		displaySelector: displaySelector
		valueSelector: valueSelector
		value: (self getValueFrom: value fieldName: fieldName)!

addLabel: labelString dropDownList: fieldName itemsWithNil: items displaySelector: displaySelector valueSelector: valueSelector value: value
	self
		addLabel: labelString;
		addField: ((HtmlDropDownList name: fieldName)
					itemsWithNil: items;
					displaySelector: displaySelector;
					valueSelector: valueSelector;
					value: value);
		nextCell!

addLabel: labelString dropDownList: fieldName itemsWithNil: items displaySelector: displaySelector valueSelector: valueSelector value: value onChange: onChange
	self
		addLabel: labelString;
		addField: ((HtmlDropDownList name: fieldName)
					itemsWithNil: items;
					displaySelector: displaySelector;
					valueSelector: valueSelector;
					value: value;
					onChange: onChange);
		nextCell!

addLabel: labelString dropDownList: fieldName itemsWithNil: items displaySelector: displaySelector valueSelector: valueSelector value: value width: fieldWidth 
	self
		addLabel: labelString;
		addField: (((HtmlDropDownList name: fieldName)
					itemsWithNil: items;
					displaySelector: displaySelector;
					valueSelector: valueSelector;
					value: value) cssStyle: 'width:' , fieldWidth printString , 'px');
		nextCell!

addLabel: labelString dropDownList: fieldName itemsWithNil: items displaySelector: displaySelector valueSelector: valueSelector value: value widthPt: widthPt 
	self
		addLabel: labelString;
		addField: ((HtmlDropDownList name: fieldName)
					itemsWithNil: items;
					displaySelector: displaySelector;
					valueSelector: valueSelector;
					value: value;
					cssStyle: (widthPt isNil ifFalse: ['width:' , widthPt asJavascriptValueWithDecimalsToFloats , 'pt;']);
					yourself);
		nextCell!

addLabel: labelString dropDownList: fieldName itemsWithNil: items displaySelector: displaySelector valueSelector: valueSelector valueFrom: value 
	self
		addLabel: labelString;
		addField: ((HtmlDropDownList name: fieldName)
					itemsWithNil: items;
					displaySelector: displaySelector;
					valueSelector: valueSelector;
					value: (self getValueFrom: value fieldName: fieldName));
		nextCell!

addLabel: labelString dropDownListItemsFrom: aWebApplication class: classId property: fieldName valueFrom: anObject 
	self
		addLabel: labelString;
		addDropDownListItemsFrom: aWebApplication
			class: classId
			property: fieldName
			valueFrom: anObject;
		nextCell!

addLabel: labelString dropDownListItemsFrom: aWebApplication class: classId property: fieldName valueFrom: anObject disabled: disabledBool 
	self
		addLabel: labelString;
		addDropDownListItemsFrom: aWebApplication
			class: classId
			property: fieldName
			valueFrom: anObject
			disabled: disabledBool;
		nextCell!

addLabel: labelString dropDownListItemsFrom: aWebApplication class: classId property: fieldName valueFrom: anObject onChange: onChange 
	self
		addLabel: labelString;
		addDropDownListItemsFrom: aWebApplication
			class: classId
			property: fieldName
			valueFrom: anObject
			onChange: onChange;
		nextCell!

addLabel: labelString dropDownListItemsWithNilFrom: aWebApplication class: classId property: fieldName value: value 
	| f |
	f := self
				addLabel: labelString;
				addDropDownListItemsWithNilFrom: aWebApplication
					class: classId
					property: fieldName
					value: value.
	self nextCell.
	^f!

addLabel: labelString dropDownListItemsWithNilFrom: aWebApplication class: classId property: fieldName valueFrom: anObject 
	| f |
	f := self
				addLabel: labelString;
				addDropDownListItemsWithNilFrom: aWebApplication
					class: classId
					property: fieldName
					valueFrom: anObject.
	self nextCell.
	^f!

addLabel: labelString dropDownListOrTextFor: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value 
	self addLabel: labelString.
	items size = 1 
		ifTrue: 
			[self
				addHiddenField: fieldName
					value: (HtmlDropDownList getOptionValueFor: items first valueSelector: valueSelector);
				addBold: (HtmlDropDownList getOptionDisplayStringFor: items first displaySelector: displaySelector)]
		ifFalse: 
			[self
				addField: ((HtmlDropDownList name: fieldName)
							items: items;
							displaySelector: displaySelector;
							valueSelector: valueSelector;
							value: value);
				nextCell]!

addLabel: labelString mandatoryDateField: textFieldName value: aDate baseDate: baseDate

	self
		addLabel: labelString;
		addDateField: textFieldName value: aDate mandatory: true baseDate: baseDate onChange: nil errors: nil;
		nextCell!

addLabel: labelString mandatoryDateField: textFieldName value: aDate baseDate: baseDate errors: errorsDictionary

	self
		addLabel: labelString;
		addDateField: textFieldName value: aDate mandatory: true baseDate: baseDate onChange: nil errors: errorsDictionary;
		nextCell!

addLabel: labelString mandatoryDateField: textFieldName value: aDate baseDate: baseDate hideFields: hideFields errors: errorsDictionary

	self
		addLabel: labelString;
		addDateField: textFieldName value: aDate mandatory: true baseDate: baseDate onChange: nil hideFields: hideFields errors: errorsDictionary;
		nextCell!

addLabel: labelString mandatoryDateField: textFieldName value: aDate errors: errorsDictionary

	self addLabel: labelString mandatoryDateField: textFieldName value: aDate baseDate: nil hideFields: nil errors: errorsDictionary!

addLabel: labelString mandatoryDateField: fieldName value: aDate hideFields: hideFields errors: errors

	self addLabel: labelString mandatoryDateField: fieldName value: aDate baseDate: nil hideFields: hideFields errors: errors!

addLabel: labelString mandatoryDateField: textFieldName valueFrom: aModel baseDate: baseDate errors: errorsDictionary 
	^self 
		addLabel: labelString
		mandatoryDateField: textFieldName
		value: (self getValueFrom: aModel fieldName: textFieldName)
		baseDate: baseDate
		errors: errorsDictionary!

addLabel: labelString mandatoryDateField: textFieldName valueFrom: aDate errors: errorsDictionary 
	^self 
		addLabel: labelString
		mandatoryDateField: textFieldName
		value: (self getValueFrom: aDate fieldName: textFieldName)
		errors: errorsDictionary!

addLabel: labelString mandatoryMoneyField: fieldName value: aNumber errors: errorsDictionary 
	self
		addLabel: labelString;
		addMandatoryMoneyField: fieldName
			value: aNumber
			errors: errorsDictionary;
		nextCell!

addLabel: labelString mandatoryMoneyField: fieldName value: aNumber precision: precision errors: errorsDictionary 
	self
		addLabel: labelString;
		addMandatoryMoneyField: fieldName
			value: aNumber
			precision: precision
			errors: errorsDictionary;
		nextCell!

addLabel: labelString mandatoryMoneyField: fieldName value: aNumber size: size errors: errorsDictionary 
	self
		addLabel: labelString;
		addField: ((HtmlTextField new)
					alignRight;
					name: fieldName;
					value: aNumber;
					size: size);
		redStar;
		addFormFieldErrorTextFor: fieldName from: errorsDictionary;
		nextCell!

addLabel: labelString mandatoryMoneyField: fieldName valueFrom: aNumber errors: errorsDictionary 
	^self 
		addLabel: labelString
		mandatoryMoneyField: fieldName
		value: (self getValueFrom: aNumber fieldName: fieldName)
		errors: errorsDictionary!

addLabel: labelString mandatoryMoneyField: fieldName valueFrom: anObject precision: precision errors: errorsDictionary 
	self
		addLabel: labelString;
		addTextField: fieldName
			value: ((self getValueFrom: anObject fieldName: fieldName) 
					asWebStringWithPrecision: precision)
			size: 12;
		redStar;
		addFormFieldErrorTextFor: fieldName from: errorsDictionary;
		nextCell!

addLabel: labelString mandatoryMoneyFieldWithStrictPrecision: fieldName value: aNumber size: size errors: errorsDictionary 
	self
		addLabel: labelString;
		cellNoWrap;
		addField: ((HtmlTextField new)
					alignRight;
					name: fieldName;
					autocomplete: false;
					value: aNumber asWebStringWith2OrMoreDecimals;
					size: size);
		redStar;
		addFormFieldErrorTextFor: fieldName from: errorsDictionary;
		nextCell!

addLabel: labelString mandatoryPasswordField: fieldName value: aString autocomplete: aBool errors: errorsDictionary 
	self
		addLabel: labelString;
		addPasswordField: fieldName
			value: aString
			autocomplete: aBool;
		redStar;
		addFormFieldErrorTextFor: fieldName from: errorsDictionary;
		nextCell!

addLabel: labelString mandatoryPasswordField: fieldName value: aString errors: errorsDictionary

	self
		addLabel: labelString;
		addPasswordField: fieldName value: aString;
		redStar;
		addFormFieldErrorTextFor: fieldName from: errorsDictionary;
		nextCell!

addLabel: labelString mandatoryPasswordField: textFieldName valueFrom: aString errors: errorsDictionary 
	^self 
		addLabel: labelString
		mandatoryPasswordField: textFieldName
		value: (self getValueFrom: aString fieldName: textFieldName)
		errors: errorsDictionary!

addLabel: labelString mandatoryTextArea: fieldName value: aString columns: nCols rows: nRows errors: errorsDictionary

	self
		addLabel: labelString;
		addTextArea: fieldName value: aString columns: nCols rows: nRows;
		redStar;
		addFormFieldErrorTextFor: fieldName from: errorsDictionary;
		nextCell!

addLabel: labelString mandatoryTextField: textFieldName value: aString 
	self
		addLabel: labelString;
		addTextField: textFieldName value: aString;
		redStar;
		nextCell!

addLabel: labelString mandatoryTextField: textFieldName value: aString errors: errorsDictionary 
	self
		addLabel: labelString;
		cellNoWrap;
		addTextField: textFieldName value: aString;
		redStar;
		addFormFieldErrorTextFor: textFieldName from: errorsDictionary;
		nextCell!

addLabel: labelString mandatoryTextField: textFieldName value: aString size: size comboBoxValues: comboBoxValues errors: errorsDictionary 
	self
		addLabel: labelString;
		addTextField: textFieldName
			value: aString
			size: size
			maxLength: nil
			mandatory: true
			comboBoxValues: comboBoxValues
			onChange: nil
			errors: errorsDictionary;
		nextCell!

addLabel: labelString mandatoryTextField: textFieldName value: aString size: size comboBoxValues: comboBoxValues onChange: script errors: errorsDictionary 
	self
		addLabel: labelString;
		addTextField: textFieldName
			value: aString
			size: size
			maxLength: nil
			mandatory: true
			comboBoxValues: comboBoxValues
			onChange: script
			errors: errorsDictionary;
		nextCell!

addLabel: labelString mandatoryTextField: textFieldName value: aString size: size errors: errorsDictionary 
	self
		addLabel: labelString;
		addTextField: textFieldName
			value: aString
			size: size;
		redStar;
		addFormFieldErrorTextFor: textFieldName from: errorsDictionary;
		nextCell!

addLabel: labelString mandatoryTextField: textFieldName value: aString size: size maxLength: maxLength errors: errorsDictionary 
	self
		addLabel: labelString;
		addTextField: textFieldName
			value: aString
			size: size
			maxLength: maxLength
			errors: nil;
		redStar;
		addFormFieldErrorTextFor: textFieldName from: errorsDictionary;
		nextCell!

addLabel: labelString mandatoryTextField: textFieldName valueFrom: aModel errors: errorsDictionary 
	^self 
		addLabel: labelString
		mandatoryTextField: textFieldName
		value: (self getValueFrom: aModel fieldName: textFieldName)
		errors: errorsDictionary!

addLabel: labelString mandatoryTextField: textFieldName valueFrom: aString size: size errors: errorsDictionary 
	^self 
		addLabel: labelString
		mandatoryTextField: textFieldName
		value: (self getValueFrom: aString fieldName: textFieldName)
		size: size
		errors: errorsDictionary!

addLabel: labelString mandatoryTimeComboField: fieldName value: value errors: errors 
	self
		addLabel: labelString;
		addMandatoryTimeComboField: fieldName
			value: value
			errors: errors;
		nextCell!

addLabel: aString moneyData: anObject
	self
		addLabel: aString;
		addMoneyData: anObject!

addLabel: aString moneyData: anObject currency: currencyCode 
	self
		addLabel: aString;
		cellVerticalAlignment: 'top';
		cellAlignment: 'right';
		add: (anObject isNil 
					ifTrue: ['']
					ifFalse: [anObject asWebString webHtmlEncoded , ' ' , currencyCode]);
		nextCell!

addLabel: labelString moneyField: fieldName value: aNumber errors: errorsDictionary 
	| f |
	f := self
				addLabel: labelString;
				addMoneyField: fieldName
					value: aNumber
					errors: errorsDictionary.
	self nextCell.
	^f!

addLabel: labelString moneyField: fieldName value: aNumber precision: precision errors: errorsDictionary 
	self
		addLabel: labelString;
		addMoneyField: fieldName
			value: aNumber
			size: nil
			precision: precision
			errors: errorsDictionary;
		nextCell!

addLabel: labelString moneyField: fieldName value: aNumber size: size errors: errorsDictionary 
	self
		addLabel: labelString;
		addMoneyField: fieldName
			value: aNumber
			size: size
			precision: nil
			errors: errorsDictionary;
		nextCell!

addLabel: labelString moneyField: fieldName value: aNumber size: size precision: precision errors: errorsDictionary 
	self
		addLabel: labelString;
		addMoneyField: fieldName
			value: aNumber
			size: size
			precision: precision
			errors: errorsDictionary;
		nextCell!

addLabel: labelString moneyField: fieldName valueFrom: aNumber errors: errorsDictionary 
	^self 
		addLabel: labelString
		moneyField: fieldName
		value: (self getValueFrom: aNumber fieldName: fieldName)
		errors: errorsDictionary!

addLabel: labelString moneyField: fieldName valueFrom: aNumber precision: precision errors: errorsDictionary 
	^self 
		addLabel: labelString
		moneyField: fieldName
		value: (self getValueFrom: aNumber fieldName: fieldName)
		precision: precision
		errors: errorsDictionary!

addLabel: labelString moneyField: fieldName valueFrom: aNumber size: anInteger errors: errorsDictionary 
	^self 
		addLabel: labelString
		moneyField: fieldName
		value: (self getValueFrom: aNumber fieldName: fieldName)
		size: anInteger
		errors: errorsDictionary!

addLabel: labelString moneyFieldWithStrictPrecision: fieldName value: aNumber size: size errors: errorsDictionary 
	self
		addLabel: labelString;
		addField: ((HtmlTextField new)
					alignRight;
					name: fieldName;
					autocomplete: false;
					value: aNumber asWebStringWith2OrMoreDecimals;
					size: size);
		addFormFieldErrorTextFor: fieldName from: errorsDictionary;
		nextCell!

addLabel: labelString passwordField: fieldName value: aString errors: errorsDictionary 
	self
		addLabel: labelString;
		addPasswordField: fieldName value: aString;
		addFormFieldErrorTextFor: fieldName from: errorsDictionary;
		nextCell!

addLabel: aString rawData: anObject 
	self
		addLabel: aString;
		cellVerticalAlignment: 'top';
		add: anObject;
		nextCell!

addLabel: aString rowData: anObject 
	self
		addLabel: aString;
		spanRow;
		cellVerticalAlignment: 'top';
		add: anObject asWebString webHtmlEncoded;
		nextCell!

addLabel: aString rowData: anObject linkTo: url 
	self
		addLabel: aString;
		spanRow;
		cellVerticalAlignment: 'top';
		add: '<a href="' , url , '">';
		add: anObject asWebString webHtmlEncoded;
		add: '</a>';
		nextCell!

addLabel: aString rowRawData: anObject 
	self
		addLabel: aString;
		spanRow;
		cellVerticalAlignment: 'top';
		add: anObject;
		nextCell!

addLabel: labelString spanDropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value
	self
		addLabel: labelString;
		spanRow;
		addField: ((HtmlDropDownList name: fieldName)
					items: items;
					displaySelector: displaySelector;
					valueSelector: valueSelector;
					value: value);
		nextCell!

addLabel: labelString spanDropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value onChange: onChangeScript 
	self
		addLabel: labelString;
		spanRow;
		addField: ((HtmlDropDownList name: fieldName)
					items: items;
					displaySelector: displaySelector;
					valueSelector: valueSelector;
					value: value;
					onChange: onChangeScript);
		nextCell!

addLabel: labelString spanDropDownList: fieldName itemsWithNil: items displaySelector: displaySelector valueSelector: valueSelector value: value
	self
		addLabel: labelString;
		spanRow;
		addField: ((HtmlDropDownList name: fieldName)
					itemsWithNil: items;
					displaySelector: displaySelector;
					valueSelector: valueSelector;
					value: value);
		nextCell!

addLabel: labelString spanTextArea: fieldName value: aString columns: nCols rows: nRows errors: errorsDictionary
	self
		addLabel: labelString;
		spanRow;
		addTextArea: fieldName
			value: aString
			columns: nCols
			rows: nRows;
		addFormFieldErrorTextFor: fieldName from: errorsDictionary;
		nextCell!

addLabel: labelString spanTextField: textFieldName value: aString size: size errors: errorsDictionary
	self
		addLabel: labelString;
		spanRow;
		addTextField: textFieldName
			value: aString
			size: size;
		addFormFieldErrorTextFor: textFieldName from: errorsDictionary;
		nextCell!

addLabel: labelString textArea: fieldName value: aString columns: nCols rows: nRows errors: errorsDictionary 
	^self 
		addLabel: labelString
		textArea: fieldName
		value: aString
		columns: nCols
		rows: nRows
		maxLength: nil
		errors: errorsDictionary!

addLabel: labelString textArea: fieldName value: aString columns: nCols rows: nRows maxLength: maxLength errors: errorsDictionary 
	self
		addLabel: labelString;
		addTextArea: fieldName
			value: aString
			columns: nCols
			rows: nRows
			maxLength: maxLength;
		addFormFieldErrorTextFor: fieldName from: errorsDictionary;
		nextCell!

addLabel: labelString textArea: fieldName valueFrom: aString columns: nCols rows: nRows errors: errorsDictionary 
	^self 
		addLabel: labelString
		textArea: fieldName
		value: (self getValueFrom: aString fieldName: fieldName)
		columns: nCols
		rows: nRows
		maxLength: (self getMaxStringSizeForObject: aString property: fieldName)
		errors: errorsDictionary!

addLabel: labelString textField: textFieldName value: aString

	self
		addLabel: labelString;
		addTextField: textFieldName value: aString;
		nextCell!

addLabel: labelString textField: textFieldName value: aString errors: errorsDictionary

	self
		addLabel: labelString;
		addTextField: textFieldName value: aString;
		addFormFieldErrorTextFor: textFieldName from: errorsDictionary;
		nextCell
!

addLabel: labelString textField: textFieldName value: textValue hiddenField: hiddenName value: aString size: size comboBoxValues: comboBoxValues valueSelector: valueSelector displaySelector: displaySelector errors: errorsDictionary 
	self
		addLabel: labelString;
		addTextField: textFieldName
			value: textValue
			hiddenField: hiddenName
			value: aString
			size: size
			maxLength: nil
			mandatory: false
			comboBoxValues: comboBoxValues
			valueSelector: valueSelector
			displaySelector: displaySelector
			onChange: nil
			errors: errorsDictionary;
		nextCell!

addLabel: labelString textField: textFieldName value: textValue hiddenField: hiddenName value: aString size: size comboBoxValues: comboBoxValues valueSelector: valueSelector displaySelector: displaySelector onChange: script errors: errorsDictionary 
	self
		addLabel: labelString;
		addTextField: textFieldName
			value: textValue
			hiddenField: hiddenName
			value: aString
			size: size
			maxLength: nil
			mandatory: false
			comboBoxValues: comboBoxValues
			valueSelector: valueSelector
			displaySelector: displaySelector
			onChange: script
			errors: errorsDictionary;
		nextCell!

addLabel: labelString textField: textFieldName value: aString size: size
	self
		addLabel: labelString;
		addTextField: textFieldName
			value: aString
			size: size;
		nextCell!

addLabel: labelString textField: textFieldName value: aString size: size comboBoxValues: comboBoxValues errors: errorsDictionary 
	| f |
	self addLabel: labelString.
	f := self 
				addTextField: textFieldName
				value: aString
				size: size
				maxLength: nil
				mandatory: false
				comboBoxValues: comboBoxValues
				onChange: nil
				errors: errorsDictionary.
	self nextCell.
	^f!

addLabel: labelString textField: textFieldName value: aString size: size comboBoxValues: comboBoxValues onChange: script errors: errorsDictionary

	self
		addLabel: labelString;
		addTextField: textFieldName value: aString size: size maxLength: nil mandatory: false comboBoxValues: comboBoxValues onChange: script errors: errorsDictionary;
		nextCell!

addLabel: labelString textField: textFieldName value: aString size: size errors: errorsDictionary 
	| f |
	f := self
				addLabel: labelString;
				addTextField: textFieldName
					value: aString
					size: size.
	self
		addFormFieldErrorTextFor: textFieldName from: errorsDictionary;
		nextCell.
	^f!

addLabel: labelString textField: textFieldName valueFrom: aString 
	^self 
		addLabel: labelString
		textField: textFieldName
		value: (self getValueFrom: aString fieldName: textFieldName)
		errors: nil!

addLabel: labelString textField: textFieldName valueFrom: aString errors: errorsDictionary 
	^self 
		addLabel: labelString
		textField: textFieldName
		value: (self getValueFrom: aString fieldName: textFieldName)
		errors: errorsDictionary!

addLabel: labelString textField: textFieldName valueFrom: aString size: size 
	^self 
		addLabel: labelString
		textField: textFieldName
		value: (self getValueFrom: aString fieldName: textFieldName)
		size: size
		errors: nil!

addLabel: labelString textField: textFieldName valueFrom: aString size: size comboBoxValues: comboBoxValues errors: errorsDictionary 
	^self 
		addLabel: labelString
		textField: textFieldName
		value: (self getValueFrom: aString fieldName: textFieldName)
		size: size
		comboBoxValues: comboBoxValues
		errors: errorsDictionary!

addLabel: labelString textField: textFieldName valueFrom: aString size: size errors: errorsDictionary 
	^self 
		addLabel: labelString
		textField: textFieldName
		value: (self getValueFrom: aString fieldName: textFieldName)
		size: size
		errors: errorsDictionary!

addLabel: label yesNoField: fieldName value: value
	^self
		addLabel: label;
		cellVerticalAlignment: 'top';
		add: ((HtmlDropDownList name: fieldName)
					items: (Array with: (Association key: 1 value: 'asp.label.Yes')
								with: (Association key: 0 value: 'asp.label.No'));
					displaySelector: #translatedValue;
					valueSelector: #key;
					value: value);
		nextCell!

addLabelText: aString 
	"Adds a label without going to the next cell. It will add space before and after the label.
	It will use 'dgLb' class for font settings.
	It will translate aString before using it and add double colon : after the label."

	| str |
	str := aString webTranslate.
	self getColumnIndex > 1 ifTrue: [self space].
	self add: '<font class="dgLb">' , str , ':</font>&nbsp;'!

addMoneyData: anObject highlighted: aBooleanOrSymbol 
	self addMoneyData: anObject precision: 2!

addMoneyData: anObject precision: precision 
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
		cellAlignmentRight;
		cellNoWrap;
		space.
	((value isNumber and: [value < 0]) or: [value isNil and: [str notEmpty and: [str first == $-]]]) 
		ifTrue: [self addText: str withColor: 'red']
		ifFalse: [self add: str].
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

addOpenLinkTo: url 
	self
		addImage: 'images/open.gif'
			width: 15
			height: 13
			toolTip: 'asp.label.helpTip.Open'
			linkTo: url;
		nextCell!

addPaymentLinkTo: url 
	self addPaymentToolTip: 'Racun.toolTip.Placano' linkTo: url!

addPaymentToolTip: toolTip linkTo: url 
	| str |
	str := toolTip webTranslate.
	self 
		addField: '<a href="' , url 
				, '"><img src="images/payment.gif" width=26 height=15 border=0 alt="' , str 
				, '" title="' , str 
				, '"/></a>'!

addRawData: anObject
	self
		cellVerticalAlignment: 'top';
		add: anObject;
		nextCell!

addRight: anObject 
	self
		cellAlignment: 'right';
		add: anObject!

addRLabel: aString 
	| str |
	str := aString webTranslate.
	self getColumnIndex = 1 ifFalse: [str := '&nbsp;&nbsp;' , str].
	self
		cellAlignment: 'right';
		cellVerticalAlignment: 'top';
		add: '<b>' , str , ':</b>';
		nextCell.
	fieldRowSpan == true ifTrue: [self spanRow]!

addRLabel: aString data: anObject 
	self
		addRLabel: aString;
		addData: anObject!

addSeparator
	self
		colSpan: columns;
		cellHeight: 0;
		add: '<hr size="1" />';
		nextCell!

addSeparatorBackground: picturePath 
	self
		cellHeight: 1;
		cellBackground: 'black';
		addPixel!

addSeparatorWidth: separatorWidth 
	self
		colSpan: columns;
		cellHeight: 0;
		cellWidth: separatorWidth;
		add: '<hr size="1"/>';
		nextCell!

addShortData: anObject 
	self
		cellVerticalAlignment: 'top';
		add: anObject asShortWebString webHtmlEncoded;
		nextCell!

addSmallBoldData: anObject 
	self
		cellVerticalAlignment: 'middle';
		add: (anObject = ' ' 
					ifTrue: ['&nbsp;']
					ifFalse: ['<small><b>' , anObject asWebString webHtmlEncoded , '</b></small>']);
		nextCell!

addSmallData: anObject 
	self
		cellVerticalAlignment: 'middle';
		add: (anObject = ' ' 
					ifTrue: ['&nbsp;']
					ifFalse: ['<small>' , anObject asWebString webHtmlEncoded , '</small>']);
		nextCell!

addSubtitleRow: aString 
	self
		spanRow;
		cellNoWrap;
		cellBackground: '#f0f0f0';
		add: ((HtmlTable columns: 1)
					cellPadding: 6;
					cellSpacing: 0;
					addBold: aString webTranslate);
		nextCell!

addText: aString

	aString isNilOrEmpty ifFalse: [self cell add: aString]!

addText: aString color: aStringColor 
	"Adds text with color in hex definition."
	| textColor |
	textColor := aStringColor first = $# ifTrue: [aStringColor] ifFalse: ['#' , aStringColor].
	aString isNil 
		ifTrue: [self cell space]
		ifFalse: 
			[(self cell)
				add: '<font color="' , textColor , '">';
				add: aString;
				add: '</font>']!

addText: aString fontSize: fontSize italic: italicBool 
	self add: '<font class="fs' , fontSize printString , 'pt">'.
	italicBool = true ifTrue: [self add: '<i>'].
	self addText: aString asWebString webHtmlEncoded.
	italicBool ifTrue: [self add: '</i>'].
	self add: '</font>'!

addText: aString linkTo: urlString 
	self
		add: '<a href="' , urlString , '">';
		addText: aString;
		add: '</a>'!

addText: aString linkTo: urlString target: target 
	self
		add: '<a href="' , urlString , '" target="' , target , '">';
		addText: aString;
		add: '</a>'!

addText: aString size: textSize 
	aString isNilOrEmpty 
		ifFalse: 
			[(self cell)
				add: '<font size=' , textSize printString , '>';
				add: aString;
				add: '</font>']!

addTitleBar: aString 
	self
		cellClass: 'bar';
		spanRow;
		cellNoWrap;
		cellVerticalAlignmentMiddle;
		add: '<span class="dgTitle">';
		addText: aString webTranslate asWebString webHtmlEncoded;
		add: '</span>';
		nextCell!

addTitleBar: aString links: anArray 
	| titleTable stream action |
	titleTable := HtmlTable columns: 2.
	titleTable
		width: '100%';
		cellPadding: 0;
		cellSpacing: 0;
		border: 0;
		cellWidthPc: 100;
		cellClass: 'dgTitle';
		addText: aString webTranslate asWebString webHtmlEncoded;
		nextCell.
	stream := ReadStream on: anArray.
	[stream atEnd] whileFalse: 
			[(action := stream next) isNil 
				ifFalse: 
					[titleTable
						add: '<a href="' , action , '" class="titleLink">' , stream next webTranslate , '</a>';
						space]].
	self
		cellClass: 'bar';
		spanRow;
		cellNoWrap;
		add: titleTable;
		nextCell!

addTotalsOrNil
	^self addData: nil!

addTranslateText: aString 
	aString isNilOrEmpty 
		ifTrue: [self cell add: '&nbsp;']
		ifFalse: [self cell add: aString webTranslate]!

addTranslateText: aString color: aStringColor 
	aString isNilOrEmpty 
		ifTrue: [self cell add: '&nbsp;']
		ifFalse: 
			[self cell add: '<font color="' , aStringColor , '">' , aString webTranslate , '</font>']!

alignment: aStringOrSymbol 
	alignment := aStringOrSymbol asString!

background: colorString 
	background := colorString!

basicAddActionButtons: anArray 
	| buttonsTable stream |
	buttonsTable := HtmlTable columns: anArray size // 2.
	self
		spanRow;
		add: buttonsTable.
	stream := ReadStream on: anArray.
	[stream atEnd] whileFalse: 
			[buttonsTable
				basicAddActionButton: stream next label: stream next;
				nextCell]!

border: aStringOrNumber 
	aStringOrNumber isString 
		ifFalse: [border := aStringOrNumber printString]
		ifTrue: [border := aStringOrNumber]!

borderColor: aString 
	borderColor := aString!

cell
	| cell |
	cell := position > contents size ifFalse: [contents at: position].
	cell isNil 
		ifTrue: 
			[[position > contents size] whileTrue: [contents add: nil].
			cell := contents at: position put: HtmlTableCell new.
			rowBorderTop isNil ifFalse: [cell borderTop: rowBorderTop].
			rowBorderBottom isNil ifFalse: [cell borderBottom: rowBorderBottom].
			cell borderColor: borderColor].
	^cell!

cellAlignment: aString 
	self cell alignment: aString!

cellAlignmentCenter
	self cell alignment: 'center'!

cellAlignmentLeft
	self cellAlignment: 'left'!

cellAlignmentRight
	self cellAlignment: 'right'!

cellBgPicture: aPictureFileName 
	self cell bgPicture: aPictureFileName!

cellBorderBottom
	(self cell)
		borderBottom: 1;
		borderColor: borderColor!

cellBorderLeft
	self cell borderLeft: 1!

cellBorderRight
	self cell borderRight: 1!

cellBorderTop
	self cell borderTop: 1!

cellClass: css 
	self cell cssClass: css!

cellHeight: aStringOrNumber 
	self cell height: aStringOrNumber!

cellId: aString 
	self cell id: aString!

cellNoWrap
	self cell noWrap!

cellOnClick: aString 
	self cell onClick: aString!

cellPadding: aStringOrNumber 
	aStringOrNumber isString 
		ifFalse: [cellPadding := aStringOrNumber printString]
		ifTrue: [cellPadding := aStringOrNumber]!

cellSpacing: aStringOrNumber 
	aStringOrNumber isString 
		ifFalse: [cellSpacing := aStringOrNumber printString]
		ifTrue: [cellSpacing := aStringOrNumber]!

cellStyle: aString 
	self cell style: aString!

cellStyleAdd: aString 
	aString isNilOrEmpty 
		ifFalse: 
			[self cell 
				style: (aString add: self cell style withDelimiter: (aString last = $; ifTrue: [''] ifFalse: [';']))]!

cellVerticalAlignment: aString 
	self cell verticalAlignment: aString!

cellVerticalAlignmentBottom
	self cell verticalAlignment: 'bottom'!

cellVerticalAlignmentMiddle
	self cell verticalAlignment: 'middle'!

cellVerticalAlignmentTop
	self cell verticalAlignment: 'top'!

cellWidth: aStringOrNumber 
	self cell width: aStringOrNumber!

cellWidthMm: aStringOrNumber 
	ItcSystemManager isRuntime 
		ifFalse: [self error: 'HTML tables does not implement mesures in millimeters.']!

cellWidthPc: n 
	self cellWidth: n printString , '%'!

cellWidthPt: aStringOrNumber 
	ItcSystemManager isRuntime ifFalse: [self error: 'HTML table does not implement width in points.']!

cellWidthTwips: aStringOrNumber 
	ItcSystemManager isRuntime ifFalse: [self error: 'HTML table does not implement width in twips.']!

clearFieldRowSpan
	fieldRowSpan := nil!

colSpan: anInteger 
	"Condition means that position is at last column, not first, so no span is posible, and can't span for less than 2 cells."

	| maxSpan |
	(anInteger < 2 or: [(maxSpan := position \\ columns) == 0]) 
		ifFalse: 
			[maxSpan := columns + 1 - maxSpan.
			"Reusing maxSpan variable."
			maxSpan := anInteger > maxSpan 
						ifTrue: 
							[ItcSystemManager logDevTimeError: 'Invalid span parameter'.
							maxSpan]
						ifFalse: [anInteger].
			maxSpan > 1 ifTrue: [self cell colSpan: maxSpan]]!

columns
	^columns!

currentRowDisplay: aBoolean 
	rowDisplay isNil ifTrue: [rowDisplay := ItcLookupTable new].
	rowDisplay at: self getRowIndex + 1 put: aBoolean!

currentRowElementId: aString 
	"It is used when we want to set id on row ( <td>)."

	rowIdentifiers isNil ifTrue: [rowIdentifiers := ItcLookupTable new].
	rowIdentifiers at: self getRowIndex + 1 put: aString!

generateOn: aStream 
	| i cell rows contentsSize skipCr beginRow |
	skipCr := ItcSystemManager isRuntime.
	aStream nextPutAll: '<table'.
	cssClass isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' class="';
				nextPutAll: cssClass;
				nextPut: $"].
	cssStyle isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' style="';
				nextPutAll: cssStyle;
				nextPut: $"].
	elementId isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' id="';
				nextPutAll: elementId;
				nextPut: $"].
	border isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' border="';
				nextPutAll: border;
				nextPut: $"].
	width isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' width="';
				nextPutAll: width;
				nextPut: $"].
	height isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' height="';
				nextPutAll: height;
				nextPut: $"].
	cellPadding isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' cellpadding="';
				nextPutAll: cellPadding;
				nextPut: $"].
	cellSpacing isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' cellspacing="';
				nextPutAll: cellSpacing;
				nextPut: $"].
	alignment isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' align="';
				nextPutAll: alignment;
				nextPut: $"].
	verticalAlignment isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' valign="';
				nextPutAll: verticalAlignment;
				nextPut: $"].
	background isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' bgcolor="';
				nextPutAll: background;
				nextPut: $"].
	onDoubleClick isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' ondblclick="';
				nextPutAll: onDoubleClick;
				nextPut: $"].
	onMouseOver isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onmouseover="';
				nextPutAll: onMouseOver;
				nextPut: $"].
	onMouseOut isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onmouseout="';
				nextPutAll: onMouseOut;
				nextPut: $"].
	onMouseClick isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onclick="';
				nextPutAll: onMouseClick;
				nextPut: $"].
	aStream nextPut: $>.
	i := 1.
	rows := (contents size - 1) // columns + 1.
	contentsSize := contents size.
	1 to: rows
		do: 
			[:row | 
			| col |
			skipCr ifFalse: [aStream cr].
			beginRow := true.
			col := 0.
			
			[col := col + 1.
			col <= columns and: [i <= contentsSize]] whileTrue: 
						["Read implementation note for #whileTrue:"
						| widthStr |
						widthStr := nil.
						cell := contents at: i.
						(row == 1 and: [cellWidths notNil]) 
							ifTrue: 
								[widthStr := (cellWidths at: col) printString , '%'.
								(cell isNil or: [cell colSpan isNil not]) ifFalse: [cell width: widthStr]].
						beginRow 
							ifTrue: 
								[aStream nextPutAll: (self getRowBeginTagForFirstCell: cell rowIndex: row).
								beginRow := false].
						cell isNil 
							ifTrue: 
								["From HtmlTableCell generateOn: method"
								aStream nextPutAll: '<td'.
								widthStr isNil 
									ifFalse: 
										[aStream
											nextPutAll: ' width="';
											nextPutAll: widthStr;
											nextPut: $"].
								aStream nextPutAll: '></td>']
							ifFalse: 
								[cell generateOn: aStream.
								cell colSpan notNil 
									ifTrue: 
										[i := i + cell colSpan - 1.
										col := col + cell colSpan - 1]].
						skipCr ifFalse: [aStream cr].
						i := i + 1].
			beginRow ifTrue: ['<tr>'].
			aStream nextPutAll: '</tr>'].
	aStream nextPutAll: '</table>'!

getColumnIndex
	^position \\ columns!

getRowBeginTagForFirstCell: anObject rowIndex: rowIndex 
	| str |
	str := '<tr'.
	(rowIdentifiers isNil not and: [(rowIdentifiers at: rowIndex ifAbsent: []) isNilOrEmpty not]) 
		ifTrue: [str := str , ' id="' , (rowIdentifiers at: rowIndex) , '"'].
	(rowDisplay isNil not and: [(rowDisplay at: rowIndex ifAbsent: []) = false]) 
		ifTrue: [str := str , ' style="display: none"'].
	^str , '>'!

getRowIndex
	^(position - 1) // columns!

height: aStringOrNumber 
	aStringOrNumber isString 
		ifFalse: [height := aStringOrNumber printString]
		ifTrue: [height := aStringOrNumber]!

nextCell
	| cell |
	((cell := position > contents size ifFalse: [contents at: position]) notNil 
		and: [cell colSpan notNil]) 
			ifTrue: [position := position + cell colSpan]
			ifFalse: [position := position + 1].
	self getColumnIndex = 1 
		ifTrue: 
			[rowBorderTop := nil.
			rowBorderBottom := nil]!

nextCell: count 
	count timesRepeat: [self nextCell]!

nextRow
	self skipRow!

onDoubleClick: aString 
	onDoubleClick := aString!

onMouseClick: aString 
	onMouseClick := aString!

onMouseOut: aString 
	onMouseOut := aString!

onMouseOver: aString 
	onMouseOver := aString!

rowBorderBottom
	rowBorderBottom := 1.
	(self cell)
		borderBottom: rowBorderBottom;
		borderColor: borderColor!

rowBorderTop
	rowBorderTop := 1.
	self cell borderTop: rowBorderTop!

rowBreak
	^self
		spanRow;
		break;
		nextCell!

rowHeight: anInteger 
	self cellHeight: anInteger!

rowHeightPt: anInteger 
	self cellHeight: anInteger!

rowHeightTwips: anInteger 
	self cellHeight: anInteger!

separatorCell
	self
		cellHeight: 1;
		add: '<hr size="1"/>';
		nextCell!

setCellWidths: anArray 
	self width: '100%'.
	cellWidths := ((anArray class == Array or: [anArray class == OrderedCollection]) 
				and: [anArray size == columns]) 
					ifTrue: [anArray]
					ifFalse: 
						[ItcSystemManager logDevTimeError: 'Ilegal use of #setCellWidths: method.'.
						nil]!

setCellWidthsMm: anArray 
	"Compatibility with Rtf document, for Html set proportional values."

	self setCellWidthsTwips: anArray!

setCellWidthsPc: anArray 
	self setCellWidths: anArray!

setCellWidthsPt: anArray 
	"Compatibility with Rtf document, for Html set proportional values."

	| sum arr |
	sum := anArray inject: 0.0s into: [:s :each | s + each].
	"reuse sum variable."
	sum := 100.0s / sum.
	arr := anArray collect: [:each | sum * each].
	self setCellWidths: arr!

setCellWidthsTwips: anArray 
	"Compatibility with Rtf/Odf document, for Html set proportional values."

	| sum arr |
	sum := anArray inject: 0.0s into: [:s :each | s + each].
	"reuse sum variable."
	sum := 100.0s / sum.
	arr := anArray collect: [:each | sum * each].
	self setCellWidths: arr!

setColumns: n2 
	columns := n2.
	position := 1.
	contents := OrderedCollection new: 128!

setDefaultFontSize: fontSize 
	defaultFontSize := fontSize.
	cssClass := 'tbl' , defaultFontSize printString , 'pt'.
	self
		cellSpacing: 0;
		cellPadding: 0!

setFieldRowSpan
	fieldRowSpan := true!

skipRow
	self
		spanRow;
		space;
		break;
		nextCell!

spanRow
	position \\ columns = 0 ifFalse: [self colSpan: columns + 1 - (position \\ columns)]!

verticalAlignment: aStringOrSymbol 
	verticalAlignment := aStringOrSymbol asString!

width
	^width!

width: aStringOrNumber 
	aStringOrNumber isString 
		ifFalse: [width := aStringOrNumber printString]
		ifTrue: [width := aStringOrNumber]!

widthPc: aStringOrNumber 
	width := (aStringOrNumber isString ifFalse: [aStringOrNumber printString] ifTrue: [aStringOrNumber]) 
				, '%'! !
!HtmlTable categoriesFor: #add:!public! !
!HtmlTable categoriesFor: #addActionButtons:!public! !
!HtmlTable categoriesFor: #addAutoDropDownList:items:displaySelector:valueSelector:value:width:!public! !
!HtmlTable categoriesFor: #addBoldData:!public! !
!HtmlTable categoriesFor: #addBoldData:fontSize:!public! !
!HtmlTable categoriesFor: #addBoldData:linkTo:!public! !
!HtmlTable categoriesFor: #addBoldDataLabel:!public! !
!HtmlTable categoriesFor: #addBoldLabel:!public! !
!HtmlTable categoriesFor: #addBoldMoneyData:!public! !
!HtmlTable categoriesFor: #addBoldMoneyData:precision:!public! !
!HtmlTable categoriesFor: #addBoldMoneyDataWith2OrMoreDecimals:!public! !
!HtmlTable categoriesFor: #addBoldMoneyDataWithMinimumDecimals:!public! !
!HtmlTable categoriesFor: #addBoldText:!public! !
!HtmlTable categoriesFor: #addBooleanField:valueFrom:label:!public! !
!HtmlTable categoriesFor: #addCenter:!public! !
!HtmlTable categoriesFor: #addData:!public! !
!HtmlTable categoriesFor: #addData:alwaysLinkTo:!public! !
!HtmlTable categoriesFor: #addData:fieldName:errors:!public! !
!HtmlTable categoriesFor: #addData:fontSize:!public! !
!HtmlTable categoriesFor: #addData:linkInNewWindowTo:width:height:!public! !
!HtmlTable categoriesFor: #addData:linkTo:!public! !
!HtmlTable categoriesFor: #addData:linkTo:target:!public! !
!HtmlTable categoriesFor: #addData:linkTo:title:!public! !
!HtmlTable categoriesFor: #addData:linkTo:title:target:!public! !
!HtmlTable categoriesFor: #addDataOrSpace:!public! !
!HtmlTable categoriesFor: #addDataRight:!public! !
!HtmlTable categoriesFor: #addHeader:cellWidthPx:sortSelector:!public! !
!HtmlTable categoriesFor: #addIntegerData:!public! !
!HtmlTable categoriesFor: #addLabel:!public! !
!HtmlTable categoriesFor: #addLabel:autoDropDownList:items:displaySelector:valueSelector:value:!public! !
!HtmlTable categoriesFor: #addLabel:autoDropDownList:items:displaySelector:valueSelector:value:width:!public! !
!HtmlTable categoriesFor: #addLabel:autoDropDownList:itemsWithNil:displaySelector:valueSelector:value:!public! !
!HtmlTable categoriesFor: #addLabel:boldData:!public! !
!HtmlTable categoriesFor: #addLabel:booleanField:value:!public! !
!HtmlTable categoriesFor: #addLabel:booleanField:valueFrom:!public! !
!HtmlTable categoriesFor: #addLabel:data:!public! !
!HtmlTable categoriesFor: #addLabel:data:dataCellBackground:!public! !
!HtmlTable categoriesFor: #addLabel:data:fieldName:errors:!public! !
!HtmlTable categoriesFor: #addLabel:data:fieldName:warnings:!public! !
!HtmlTable categoriesFor: #addLabel:data:linkTo:!public! !
!HtmlTable categoriesFor: #addLabel:dataOnlyIfNotNil:!public! !
!HtmlTable categoriesFor: #addLabel:dateField:value:!public! !
!HtmlTable categoriesFor: #addLabel:dateField:value:baseDate:!public! !
!HtmlTable categoriesFor: #addLabel:dateField:value:baseDate:errors:!public! !
!HtmlTable categoriesFor: #addLabel:dateField:value:baseDate:hideFields:!public! !
!HtmlTable categoriesFor: #addLabel:dateField:value:baseDate:hideFields:errors:!public! !
!HtmlTable categoriesFor: #addLabel:dateField:value:errors:!public! !
!HtmlTable categoriesFor: #addLabel:dateField:value:floatCalendar:!public! !
!HtmlTable categoriesFor: #addLabel:dateField:value:hideFields:errors:!public! !
!HtmlTable categoriesFor: #addLabel:dateField:valueFrom:!public! !
!HtmlTable categoriesFor: #addLabel:dateField:valueFrom:baseDate:errors:!public! !
!HtmlTable categoriesFor: #addLabel:dateField:valueFrom:errors:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownList:items:displaySelector:valueSelector:value:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownList:items:displaySelector:valueSelector:value:onChange:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownList:items:displaySelector:valueSelector:value:width:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownList:items:displaySelector:valueSelector:value:widthPt:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownList:items:displaySelector:valueSelector:valueFrom:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownList:itemsWithNil:displaySelector:valueSelector:value:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownList:itemsWithNil:displaySelector:valueSelector:value:onChange:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownList:itemsWithNil:displaySelector:valueSelector:value:width:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownList:itemsWithNil:displaySelector:valueSelector:value:widthPt:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownList:itemsWithNil:displaySelector:valueSelector:valueFrom:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownListItemsFrom:class:property:valueFrom:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownListItemsFrom:class:property:valueFrom:disabled:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownListItemsFrom:class:property:valueFrom:onChange:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownListItemsWithNilFrom:class:property:value:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownListItemsWithNilFrom:class:property:valueFrom:!public! !
!HtmlTable categoriesFor: #addLabel:dropDownListOrTextFor:items:displaySelector:valueSelector:value:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryDateField:value:baseDate:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryDateField:value:baseDate:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryDateField:value:baseDate:hideFields:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryDateField:value:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryDateField:value:hideFields:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryDateField:valueFrom:baseDate:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryDateField:valueFrom:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryMoneyField:value:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryMoneyField:value:precision:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryMoneyField:value:size:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryMoneyField:valueFrom:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryMoneyField:valueFrom:precision:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryMoneyFieldWithStrictPrecision:value:size:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryPasswordField:value:autocomplete:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryPasswordField:value:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryPasswordField:valueFrom:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryTextArea:value:columns:rows:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryTextField:value:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryTextField:value:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryTextField:value:size:comboBoxValues:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryTextField:value:size:comboBoxValues:onChange:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryTextField:value:size:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryTextField:value:size:maxLength:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryTextField:valueFrom:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryTextField:valueFrom:size:errors:!public! !
!HtmlTable categoriesFor: #addLabel:mandatoryTimeComboField:value:errors:!public! !
!HtmlTable categoriesFor: #addLabel:moneyData:!public! !
!HtmlTable categoriesFor: #addLabel:moneyData:currency:!public! !
!HtmlTable categoriesFor: #addLabel:moneyField:value:errors:!public! !
!HtmlTable categoriesFor: #addLabel:moneyField:value:precision:errors:!public! !
!HtmlTable categoriesFor: #addLabel:moneyField:value:size:errors:!public! !
!HtmlTable categoriesFor: #addLabel:moneyField:value:size:precision:errors:!public! !
!HtmlTable categoriesFor: #addLabel:moneyField:valueFrom:errors:!public! !
!HtmlTable categoriesFor: #addLabel:moneyField:valueFrom:precision:errors:!public! !
!HtmlTable categoriesFor: #addLabel:moneyField:valueFrom:size:errors:!public! !
!HtmlTable categoriesFor: #addLabel:moneyFieldWithStrictPrecision:value:size:errors:!public! !
!HtmlTable categoriesFor: #addLabel:passwordField:value:errors:!public! !
!HtmlTable categoriesFor: #addLabel:rawData:!public! !
!HtmlTable categoriesFor: #addLabel:rowData:!public! !
!HtmlTable categoriesFor: #addLabel:rowData:linkTo:!public! !
!HtmlTable categoriesFor: #addLabel:rowRawData:!public! !
!HtmlTable categoriesFor: #addLabel:spanDropDownList:items:displaySelector:valueSelector:value:!public! !
!HtmlTable categoriesFor: #addLabel:spanDropDownList:items:displaySelector:valueSelector:value:onChange:!public! !
!HtmlTable categoriesFor: #addLabel:spanDropDownList:itemsWithNil:displaySelector:valueSelector:value:!public! !
!HtmlTable categoriesFor: #addLabel:spanTextArea:value:columns:rows:errors:!public! !
!HtmlTable categoriesFor: #addLabel:spanTextField:value:size:errors:!public! !
!HtmlTable categoriesFor: #addLabel:textArea:value:columns:rows:errors:!public! !
!HtmlTable categoriesFor: #addLabel:textArea:value:columns:rows:maxLength:errors:!public! !
!HtmlTable categoriesFor: #addLabel:textArea:valueFrom:columns:rows:errors:!public! !
!HtmlTable categoriesFor: #addLabel:textField:value:!public! !
!HtmlTable categoriesFor: #addLabel:textField:value:errors:!public! !
!HtmlTable categoriesFor: #addLabel:textField:value:hiddenField:value:size:comboBoxValues:valueSelector:displaySelector:errors:!public! !
!HtmlTable categoriesFor: #addLabel:textField:value:hiddenField:value:size:comboBoxValues:valueSelector:displaySelector:onChange:errors:!public! !
!HtmlTable categoriesFor: #addLabel:textField:value:size:!public! !
!HtmlTable categoriesFor: #addLabel:textField:value:size:comboBoxValues:errors:!public! !
!HtmlTable categoriesFor: #addLabel:textField:value:size:comboBoxValues:onChange:errors:!public! !
!HtmlTable categoriesFor: #addLabel:textField:value:size:errors:!public! !
!HtmlTable categoriesFor: #addLabel:textField:valueFrom:!public! !
!HtmlTable categoriesFor: #addLabel:textField:valueFrom:errors:!public! !
!HtmlTable categoriesFor: #addLabel:textField:valueFrom:size:!public! !
!HtmlTable categoriesFor: #addLabel:textField:valueFrom:size:comboBoxValues:errors:!public! !
!HtmlTable categoriesFor: #addLabel:textField:valueFrom:size:errors:!public! !
!HtmlTable categoriesFor: #addLabel:yesNoField:value:!public! !
!HtmlTable categoriesFor: #addLabelText:!public! !
!HtmlTable categoriesFor: #addMoneyData:highlighted:!public! !
!HtmlTable categoriesFor: #addMoneyData:precision:!public! !
!HtmlTable categoriesFor: #addMoneyDataNotNextCell:highlighted:!public! !
!HtmlTable categoriesFor: #addMoneyDataWith2OrMoreDecimals:!public! !
!HtmlTable categoriesFor: #addMoneyDataWithMinimumDecimals:!public! !
!HtmlTable categoriesFor: #addOpenLinkTo:!public! !
!HtmlTable categoriesFor: #addPaymentLinkTo:!public! !
!HtmlTable categoriesFor: #addPaymentToolTip:linkTo:!public! !
!HtmlTable categoriesFor: #addRawData:!public! !
!HtmlTable categoriesFor: #addRight:!public! !
!HtmlTable categoriesFor: #addRLabel:!public! !
!HtmlTable categoriesFor: #addRLabel:data:!public! !
!HtmlTable categoriesFor: #addSeparator!public! !
!HtmlTable categoriesFor: #addSeparatorBackground:!public! !
!HtmlTable categoriesFor: #addSeparatorWidth:!public! !
!HtmlTable categoriesFor: #addShortData:!public! !
!HtmlTable categoriesFor: #addSmallBoldData:!public! !
!HtmlTable categoriesFor: #addSmallData:!public! !
!HtmlTable categoriesFor: #addSubtitleRow:!public! !
!HtmlTable categoriesFor: #addText:!public! !
!HtmlTable categoriesFor: #addText:color:!public! !
!HtmlTable categoriesFor: #addText:fontSize:italic:!public! !
!HtmlTable categoriesFor: #addText:linkTo:!public! !
!HtmlTable categoriesFor: #addText:linkTo:target:!public! !
!HtmlTable categoriesFor: #addText:size:!public! !
!HtmlTable categoriesFor: #addTitleBar:!public! !
!HtmlTable categoriesFor: #addTitleBar:links:!public! !
!HtmlTable categoriesFor: #addTotalsOrNil!public! !
!HtmlTable categoriesFor: #addTranslateText:!public! !
!HtmlTable categoriesFor: #addTranslateText:color:!public! !
!HtmlTable categoriesFor: #alignment:!public! !
!HtmlTable categoriesFor: #background:!accessing!public! !
!HtmlTable categoriesFor: #basicAddActionButtons:!public! !
!HtmlTable categoriesFor: #border:!public! !
!HtmlTable categoriesFor: #borderColor:!public! !
!HtmlTable categoriesFor: #cell!public! !
!HtmlTable categoriesFor: #cellAlignment:!public! !
!HtmlTable categoriesFor: #cellAlignmentCenter!public! !
!HtmlTable categoriesFor: #cellAlignmentLeft!public! !
!HtmlTable categoriesFor: #cellAlignmentRight!public! !
!HtmlTable categoriesFor: #cellBgPicture:!public! !
!HtmlTable categoriesFor: #cellBorderBottom!public! !
!HtmlTable categoriesFor: #cellBorderLeft!public! !
!HtmlTable categoriesFor: #cellBorderRight!public! !
!HtmlTable categoriesFor: #cellBorderTop!public! !
!HtmlTable categoriesFor: #cellClass:!public! !
!HtmlTable categoriesFor: #cellHeight:!public! !
!HtmlTable categoriesFor: #cellId:!public! !
!HtmlTable categoriesFor: #cellNoWrap!public! !
!HtmlTable categoriesFor: #cellOnClick:!public! !
!HtmlTable categoriesFor: #cellPadding:!public! !
!HtmlTable categoriesFor: #cellSpacing:!public! !
!HtmlTable categoriesFor: #cellStyle:!public! !
!HtmlTable categoriesFor: #cellStyleAdd:!public! !
!HtmlTable categoriesFor: #cellVerticalAlignment:!public! !
!HtmlTable categoriesFor: #cellVerticalAlignmentBottom!public! !
!HtmlTable categoriesFor: #cellVerticalAlignmentMiddle!public! !
!HtmlTable categoriesFor: #cellVerticalAlignmentTop!public! !
!HtmlTable categoriesFor: #cellWidth:!public! !
!HtmlTable categoriesFor: #cellWidthMm:!public! !
!HtmlTable categoriesFor: #cellWidthPc:!public! !
!HtmlTable categoriesFor: #cellWidthPt:!public! !
!HtmlTable categoriesFor: #cellWidthTwips:!public! !
!HtmlTable categoriesFor: #clearFieldRowSpan!public! !
!HtmlTable categoriesFor: #colSpan:!public! !
!HtmlTable categoriesFor: #columns!public! !
!HtmlTable categoriesFor: #currentRowDisplay:!accessing!public! !
!HtmlTable categoriesFor: #currentRowElementId:!accessing!public! !
!HtmlTable categoriesFor: #generateOn:!generating HTML!public! !
!HtmlTable categoriesFor: #getColumnIndex!private! !
!HtmlTable categoriesFor: #getRowBeginTagForFirstCell:rowIndex:!generating HTML!private! !
!HtmlTable categoriesFor: #getRowIndex!private! !
!HtmlTable categoriesFor: #height:!public! !
!HtmlTable categoriesFor: #nextCell!public! !
!HtmlTable categoriesFor: #nextCell:!public! !
!HtmlTable categoriesFor: #nextRow!public! !
!HtmlTable categoriesFor: #onDoubleClick:!Javascript event handlers!public! !
!HtmlTable categoriesFor: #onMouseClick:!Javascript event handlers!public! !
!HtmlTable categoriesFor: #onMouseOut:!Javascript event handlers!public! !
!HtmlTable categoriesFor: #onMouseOver:!Javascript event handlers!public! !
!HtmlTable categoriesFor: #rowBorderBottom!public! !
!HtmlTable categoriesFor: #rowBorderTop!public! !
!HtmlTable categoriesFor: #rowBreak!public! !
!HtmlTable categoriesFor: #rowHeight:!public! !
!HtmlTable categoriesFor: #rowHeightPt:!public! !
!HtmlTable categoriesFor: #rowHeightTwips:!public! !
!HtmlTable categoriesFor: #separatorCell!public! !
!HtmlTable categoriesFor: #setCellWidths:!public! !
!HtmlTable categoriesFor: #setCellWidthsMm:!public! !
!HtmlTable categoriesFor: #setCellWidthsPc:!public! !
!HtmlTable categoriesFor: #setCellWidthsPt:!public! !
!HtmlTable categoriesFor: #setCellWidthsTwips:!public! !
!HtmlTable categoriesFor: #setColumns:!public! !
!HtmlTable categoriesFor: #setDefaultFontSize:!public! !
!HtmlTable categoriesFor: #setFieldRowSpan!public! !
!HtmlTable categoriesFor: #skipRow!public! !
!HtmlTable categoriesFor: #spanRow!public! !
!HtmlTable categoriesFor: #verticalAlignment:!public! !
!HtmlTable categoriesFor: #width!public! !
!HtmlTable categoriesFor: #width:!public! !
!HtmlTable categoriesFor: #widthPc:!public! !

!HtmlTable class methodsFor!

columns: columns 
	^super new setColumns: columns!

new
	^super new setColumns: 1!

noSpacing: columns 
	^(super new)
		setColumns: columns;
		cellPadding: 0;
		cellSpacing: 0! !
!HtmlTable class categoriesFor: #columns:!public! !
!HtmlTable class categoriesFor: #new!public! !
!HtmlTable class categoriesFor: #noSpacing:!public! !

