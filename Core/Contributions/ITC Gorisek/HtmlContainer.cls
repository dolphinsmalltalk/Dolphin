"Filed out from Dolphin Smalltalk X6.1"!

HtmlElement subclass: #HtmlContainer
	instanceVariableNames: 'contents javascriptSink'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlContainer guid: (GUID fromString: '{01FCFB02-8FC1-4713-9BA6-BEB3C4AF9DA6}')!
HtmlContainer comment: ''!
!HtmlContainer categoriesForClass!Unclassified! !
!HtmlContainer methodsFor!

add: aHtmlElement 
	aHtmlElement isNil ifFalse: [self contents add: aHtmlElement]!

add: anObject linkTo: url 
	self
		add: '<a href="' , url , '">';
		add: anObject;
		add: '</a>'!

add: anObject linkTo: url cssClass: cssClassStringOrStyle 
	self
		add: '<a href="' , url , '" class="' , cssClassStringOrStyle , '">';
		add: anObject;
		add: '</a>'!

add: anObject linkTo: url openInNewWindow: aBoolean 
	self
		add: '<a';
		add: (aBoolean == true ifTrue: [' target="_blank"'] ifFalse: ['']);
		add: ' href="' , url , '">';
		add: anObject;
		add: '</a>'!

add: anObject linkTo: url style: styleString 
	self
		add: '<a href="' , url , '" style="' , styleString , '">';
		add: anObject;
		add: '</a>'!

addActionButton: buttonName label: aString 
	^self 
		addActionButton: buttonName
		label: aString
		id: nil!

addActionButton: buttonName label: aString accessKey: accessKey 
	| field |
	field := self 
				addActionButton: buttonName
				label: aString
				id: nil.
	field accessKey: accessKey.
	^field!

addActionButton: buttonName label: aString disabled: disabled 
	^self 
		addActionButton: buttonName
		label: aString
		id: nil
		disabled: disabled!

addActionButton: buttonName label: aString id: id 
	| field |
	field := self addField: (HtmlButton 
						label: aString
						action: buttonName
						id: id).
	self space.
	^field!

addActionButton: buttonName label: aString id: id disabled: disabled 
	| field |
	field := self addField: ((HtmlButton 
						label: aString
						action: buttonName
						id: id)
						readOnly: disabled;
						disabled: disabled;
						yourself).
	self space.
	^field!

addActionButton: buttonName label: aString showFlag: aBoolean 
	^aBoolean = true ifTrue: [self addActionButton: buttonName label: aString]!

addActionLink: linkText onClick: javascript 
	self 
		add: '<a href="javascript:void(0);" onclick="' , javascript , '" class="actionTip">' , '[+] ' 
				, linkText webTranslate webHtmlEncoded , '</a>'!

addActionLink: linkText url: url 
	self 
		add: '<a href="' , url webHtmlEncodedForForm , '" class="actionTip">' , '[+] ' 
				, linkText webTranslate webHtmlEncoded , '</a>'!

addActionLinkForCollapse: linkText onClick: javascript 
	self 
		add: '<a href="javascript:void(0);" onclick="' , javascript , '" class="actionTip">' , '[-] ' 
				, linkText webTranslate webHtmlEncoded , '</a>'!

addActionLinkForCollapse: linkText url: url 
	self 
		add: '<a href="' , url webHtmlEncodedForForm , '" class="actionTip">' , '[-] ' 
				, linkText webTranslate webHtmlEncoded , '</a>'!

addAjaxLoadingIndicatorImage
	self addField: self class ajaxLoadingIndicatorImageFragment!

addAutoDropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value 
	^self addField: ((HtmlDropDownList name: fieldName)
				items: items;
				automatic: true;
				displaySelector: displaySelector;
				valueSelector: valueSelector;
				value: value)!

addAutoDropDownList: fieldName itemsWithNil: items displaySelector: displaySelector valueSelector: valueSelector value: value 
	^self addField: ((HtmlDropDownList name: fieldName)
				automatic: true;
				itemsWithNil: items;
				displaySelector: displaySelector;
				valueSelector: valueSelector;
				value: value)!

addAutoDropDownListItemsWithNilFrom: aWebApplication class: classId property: fieldName valueFrom: anObject 
	^self 
		addAutoDropDownListItemsWithNilFrom: aWebApplication
		class: classId
		property: fieldName
		valueFrom: anObject
		fieldName: fieldName!

addAutoDropDownListItemsWithNilFrom: aWebApplication class: classId property: fieldName valueFrom: anObject fieldName: aString 
	self addField: ((HtmlDropDownList name: aString)
				itemsWithNil: (aWebApplication db model valuesFor: classId attribute: fieldName);
				automatic: true;
				displaySelector: #translatedValue;
				valueSelector: #key;
				value: (self getValueFrom: anObject fieldName: aString);
				yourself)!

addBigBoldText: aString

	aString isNilOrEmpty
		ifFalse: [self add: '<font size=3><b>'; add: aString; add: '</b></font>' ]!

addBlueLamp
	self 
		addImage: 'images/bluelamp.gif'
		width: 15
		height: 15!

addBlueLampTip: aString 
	self 
		addImage: 'images/bluelamp.gif'
		width: 15
		height: 15
		toolTip: aString!

addBold: anObject 
	self
		add: ' <b>';
		addField: anObject;
		add: '</b>'!

addBold: aString linkTo: url 
	self add: ' <a href="' , url , '"><b>' , aString , '</b></a>'!

addBold: aString withColor: aStringColor

	self add: ' <font color="',aStringColor,'"><b>', aString, '</b></font>' !

addBoldText: aString 
	"NOTE: text is HTML encoded, so $> will be converted to &gt; and line break will be converted to <br />."

	self addText: ' <b>' , aString webHtmlEncoded , '</b>'!

addBoldText: aString fontSize: fontSize 
	self
		add: '<span style="font-size: ' , fontSize printString , 'pt; font-weight: bold;">';
		addText: aString asWebString webHtmlEncoded;
		add: '</span>'!

addBooleanField: fieldName value: aBoolean 
	^self 
		addCheckBox: fieldName
		value: 'true'
		checked: aBoolean!

addBooleanField: fieldName value: aBoolean disabled: disabled 
	^self 
		addCheckBox: fieldName
		value: 'true'
		checked: aBoolean
		disabled: disabled!

addBooleanField: fieldName value: aBoolean onClick: onClick 
	^self 
		addCheckBox: fieldName
		value: 'true'
		checked: aBoolean
		onClick: onClick!

addBooleanField: fieldName valueFrom: anObject 
	^self 
		addCheckBox: fieldName
		value: 'true'
		checked: (self getValueFrom: anObject fieldName: fieldName)!

addButton: buttonName label: aString 
	self add: (HtmlButton name: buttonName label: aString webTranslate)!

addButton: buttonName label: aString onClick: aScript 
	| button |
	button := HtmlButton name: buttonName label: aString webTranslate.
	button onClick: aScript.
	self add: button!

addButton: buttonName label: aString onClick: aScript disabled: disabled 
	| button |
	button := HtmlButton name: buttonName label: aString webTranslate.
	button
		onClick: aScript;
		disabled: disabled;
		readOnly: disabled.
	self add: button!

addCaseFunctionFor: associations named: functionName 
	self addJavascript: 
			[self add: '
function ' , functionName , '(key) {
switch(key) {'.
			associations do: 
					[:each | 
					self 
						add: 'case "' , each key asWebString webHtmlEncodedForForm , '":return "' 
								, each value asWebString webHtmlEncodedForForm , '";
'].
			self add: 'default: break;
}}']!

addCenteredTitle: aString 
	self center: [self addTitle: aString webHtmlEncoded]!

addCenteredTitle: aString fontSize: fontSize 
	self addCenteredTitle: aString!

addCheckBox: name checked: aBoolean 
	^self addField: (HtmlCheckBox 
				name: name
				value: nil
				checked: aBoolean
				onClick: nil)!

addCheckBox: name checked: aBoolean onClick: onClick
	^self addField: (HtmlCheckBox 
				name: name
				value: nil
				checked: aBoolean
				onClick: onClick)!

addCheckBox: name value: value checked: aBoolean 
	^self addField: (HtmlCheckBox 
				name: name
				value: value
				checked: aBoolean
				onClick: nil)!

addCheckBox: name value: value checked: aBoolean disabled: disabled 
	^self addField: ((HtmlCheckBox 
				name: name
				value: value
				checked: aBoolean
				onClick: nil)
				disabled: disabled;
				yourself)!

addCheckBox: name value: value checked: aBoolean onClick: onClick 
	^self addField: (HtmlCheckBox 
				name: name
				value: value
				checked: aBoolean
				onClick: onClick)!

addCheckBox: name value: value checked: aBoolean onClickToggle: toggleFields 
	| checkBox toggleScript formName |
	formName := Processor activeProcess webCoderDefaultFormName.
	checkBox := HtmlCheckBox 
				name: name
				value: value
				checked: aBoolean.
	(toggleFields notNil and: [toggleFields notEmpty]) 
		ifTrue: 
			[toggleScript := WriteStream on: String new.
			toggleScript nextPutAll: 'self.toggleFieldsFor_'.
			toggleScript
				nextPutAll: name;
				nextPutAll: '=function() {
	var fieldDisabled = document.' , formName , '.';
				nextPutAll: name;
				nextPutAll: '.checked;
'.
			toggleFields do: 
					[:each | 
					toggleScript
						nextPutAll: '	document.' , formName , '.';
						nextPutAll: each;
						nextPutAll: '.disabled = fieldDisabled';
						nextPutAll: ';
'].
			toggleScript nextPutAll: '}'.
			self addJavascript: toggleScript contents.
			checkBox onClick: 'toggleFieldsFor_' , name , '()'].
	self addField: checkBox!

addConfirmDeleteLinkTo: url confirmationString: aString 
	^self 
		addConfirmDeleteLinkTo: url
		confirmationString: aString
		enabled: true!

addConfirmDeleteLinkTo: url confirmationString: aString enabled: aBoolean 
	aBoolean 
		ifTrue: 
			[self
				add: '<span style="cursor:pointer;cursor:hand;">';
				addImage: 'images/delete.gif'
					width: 14
					height: 13
					toolTip: 'asp.label.helpTip.Delete'
					onClick: 'if(confirm(''' 
							, aString webTranslate webRemoveHtmlFormatting webHtmlEncodedForForm webJavascriptStringEncoded 
								, ''')!!=''0'')' 
								, ((url beginsWith: 'javascript:ajaxGet') ifTrue: [''] ifFalse: ['document.location.href=''']) 
								, url webXhtmlUrlEncodeForForm 
								, ((url beginsWith: 'javascript:ajaxGet') ifTrue: [''] ifFalse: [''';']);
				add: '</span>']
		ifFalse: 
			[self 
				addImage: 'images/delete-dis.gif'
				width: 14
				height: 13].
	self nextCell!

addCopyLinkTo: url 
	self
		addImage: 'images/copy.gif'
			width: 15
			height: 13
			toolTip: 'asp.label.helpTip.Copy'
			linkTo: url;
		nextCell!

addDate: aDateOrStringOrNil 
	aDateOrStringOrNil isNil ifFalse: [self addText: aDateOrStringOrNil asWebString]!

addDateField: name value: value
	self 
		addDateField: name
		value: value
		mandatory: false
		baseDate: nil
		onChange: nil
		hideFields: nil
		errors: nil!

addDateField: name value: value baseDate: baseDate 
	self 
		addDateField: name
		value: value
		mandatory: false
		baseDate: baseDate
		onChange: nil
		hideFields: nil
		errors: nil!

addDateField: name value: value baseDate: baseDate hideFields: hideFields 
	self 
		addDateField: name
		value: value
		mandatory: false
		baseDate: baseDate
		onChange: nil
		hideFields: hideFields
		errors: nil!

addDateField: name value: value baseDate: baseDate hideFields: hideFields errors: errors 
	self 
		addDateField: name
		value: value
		mandatory: false
		baseDate: baseDate
		onChange: nil
		hideFields: hideFields
		errors: errors!

addDateField: name value: value baseDate: baseDate onChange: onChange 
	self 
		addDateField: name
		value: value
		mandatory: false
		baseDate: baseDate
		onChange: onChange
		errors: nil!

addDateField: name value: value errors: errors
	^self 
		addDateField: name
		value: value
		mandatory: false
		baseDate: nil
		onChange: nil
		hideFields: nil
		errors: errors!

addDateField: name value: value floatCalendar: floatCalendar 
	self 
		addDateField: name
		value: value
		tabIndex: nil
		mandatory: false
		baseDate: nil
		onChange: nil
		floatCalendar: floatCalendar
		errors: nil!

addDateField: name value: value hideFields: hideFields 
	self 
		addDateField: name
		value: value
		mandatory: false
		baseDate: nil
		onChange: nil
		hideFields: hideFields
		errors: nil!

addDateField: name value: value hideFields: hideFields errors: errors 
	self 
		addDateField: name
		value: value
		mandatory: false
		baseDate: nil
		onChange: nil
		hideFields: hideFields
		errors: errors!

addDateField: name value: value mandatory: mandatory baseDate: baseDate onChange: onChangeScript errors: errors 
	^self 
		addDateField: name
		value: value
		mandatory: mandatory
		baseDate: baseDate
		onChange: onChangeScript
		hideFields: nil
		errors: errors!

addDateField: name value: value mandatory: mandatory baseDate: baseDate onChange: onChangeScript hideFields: hideFields errors: errors 
	^self 
		addDateField: name
		value: value
		tabIndex: nil
		mandatory: mandatory
		baseDate: baseDate
		onChange: onChangeScript
		floatCalendar: false
		errors: errors!

addDateField: name value: value tabIndex: tabIndex mandatory: mandatory baseDate: baseDate onChange: onChangeScript errors: errors 
	^self 
		addDateField: name
		value: value
		tabIndex: tabIndex
		mandatory: mandatory
		baseDate: baseDate
		onChange: onChangeScript
		floatCalendar: false
		errors: errors!

addDateField: name value: value tabIndex: tabIndex mandatory: mandatory baseDate: baseDate onChange: onChangeScript floatCalendar: floatCalendar errors: errors 
	| pa field hiddenDivId calScript |
	pa := Processor activeProcess.
	(pa attributes)
		at: #javascriptCalendar put: true;
		at: #javascriptCommon put: true.
	hiddenDivId := 'cal_' , name , '_div' , ItcSystemManager generateShortRandomString.
	field := (HtmlDateField new)
				autocomplete: false;
				name: name;
				elementId: name;
				value: value.
	field
		onChange: onChangeScript;
		tabIndex: tabIndex.
	self addField: field.
	calScript := 'var el=new ITC.dom.Element(''' , name 
				, ''');var cal=ITC.widget.Calendar.GetGlobalVar();cal.setDate(ITC.util.StringToDate(el.dom.value));'.
	calScript := calScript , ((pa webProcessingAjaxRequest or: [floatCalendar == true]) 
						ifTrue: 
							['cal.show((el.getLeft() - el.getScrollLeft()), (el.getTop() - el.getScrollTop() + el.getHeight()), el.dom, null);']
						ifFalse: ['cal.show(0,0,el.dom,ITC.dom.GetElement(''' , hiddenDivId , '''));']).
	(self isKindOf: HtmlTable) ifTrue: [self cellNoWrap].
	self 
		addImage: 'images/koledar.gif'
		width: 16
		height: 16
		toolTip: 'asp.label.helpTip.Calender' webTranslate
		onClick: calScript.
	mandatory ifTrue: [self redStar].
	self class == HtmlContainer ifFalse: [self break].
	self
		add: '<span id="' , hiddenDivId , '" style="position:relative;"></span>';
		addFormFieldErrorTextFor: name
			from: errors
			break: false.
	^field!

addDateField: fieldName valueFrom: anObject 
	^self addDateField: fieldName value: (self getValueFrom: anObject fieldName: fieldName)!

addDateField: name valueFrom: value errors: errors 
	^self 
		addDateField: name
		value: (self getValueFrom: value fieldName: name)
		mandatory: false
		baseDate: nil
		onChange: nil
		hideFields: nil
		errors: errors!

addDateField: name valueFrom: value hideFields: hideFields errors: errors 
	^self 
		addDateField: name
		value: (self getValueFrom: value fieldName: name)
		mandatory: false
		baseDate: nil
		onChange: nil
		hideFields: hideFields
		errors: errors!

addDateOrDash: aDateOrStringOrNil 
	aDateOrStringOrNil isNil 
		ifTrue: [self addText: '-']
		ifFalse: [self addText: aDateOrStringOrNil asWebString]!

addDaysField: name value: daysValue fromDateField: fromName untilDateField: dateFieldName value: dateValue mandatory: mandatory baseDate: baseDate errors: errors 
	| formName |
	formName := Processor activeProcess webCoderDefaultFormName.
	self
		addTextField: name
			value: daysValue
			size: 2
			onBlur: 'calculateDate(document.' , formName , '.' , fromName , ', document.' , formName , '.' 
					, dateFieldName , ', document.' 
					, formName , '.' 
					, name , ')'
			errors: nil;
		space;
		add: '-';
		space;
		addDateField: dateFieldName
			value: dateValue
			mandatory: mandatory
			baseDate: baseDate
			onChange: nil
			errors: errors!

addDaysField: name value: daysValue fromDateField: fromName untilDateField: dateFieldName value: dateValue mandatory: mandatory baseDate: baseDate hideFields: hideFields errors: errors 
	| formName |
	formName := Processor activeProcess webCoderDefaultFormName.
	self
		addTextField: name
			value: daysValue
			size: 2
			onBlur: 'calculateDate(document.' , formName , '.' , fromName , ', document.' , formName , '.' 
					, dateFieldName , ', document.' 
					, formName , '.' 
					, name , ')'
			errors: nil;
		space;
		add: '-';
		space;
		addDateField: dateFieldName
			value: dateValue
			mandatory: mandatory
			baseDate: baseDate
			onChange: nil
			hideFields: hideFields
			errors: errors!

addDeleteAjaxLinkTo: url 
	^self addDeleteAjaxLinkTo: url enabled: true!

addDeleteAjaxLinkTo: url enabled: aBoolean 
	Processor activeProcess attributes at: #javascriptDialogBox put: true.
	aBoolean 
		ifTrue: 
			[self
				add: '<span style="cursor:pointer;cursor:hand;">';
				addImage: 'images/delete.gif'
					width: 14
					height: 13
					toolTip: 'asp.label.helpTip.Delete'
					onClick: ((url beginsWith: 'javascript:') 
							ifTrue: [url]
							ifFalse: ['ajaxGetRequest(' , url webXhtmlUrlEncodeForForm asJavascriptValue , ')']);
				add: '</span>']
		ifFalse: 
			[self 
				addImage: 'images/delete-dis.gif'
				width: 14
				height: 13].
	self nextCell!

addDeleteLinkTo: url 
	self
		addImage: 'images/delete.gif'
			width: 14
			height: 13
			toolTip: 'asp.label.helpTip.Delete'
			linkTo: url;
		nextCell!

addDisabledMoneyField: name value: value 
	self 
		addDisabledMoneyField: name
		value: value
		size: 12!

addDisabledMoneyField: name value: value size: size 
	self addField: ((HtmlTextField new)
				alignRight;
				name: name;
				value: value;
				autocomplete: false;
				disabled: true;
				size: size)!

addDisabledTextField: name value: value size: size
	self add: ((HtmlTextField new)
				name: name;
				value: value;
				size: size;
				disabled: true)!

addDisabledTextField: name value: value size: size errors: errorsDictionary
	self
		add: ((HtmlTextField new)
					name: name;
					value: value;
					size: size;
					disabled: true);
		addFormFieldErrorTextFor: name from: errorsDictionary!

addDiv: aHtmlElement id: layerId style: style 
	self
		add: '<div id="' , layerId , '" style="' , style , '">';
		add: aHtmlElement;
		add: '</div>'!

addDivBlock: aBlock cssClass: cssClassStringOrSymbol 
	self add: '<div class="' , cssClassStringOrSymbol asString , '">'.
	aBlock value.
	self add: '</div>'!

addDivBlock: aBlock id: layerId 
	self add: '<div id="' , layerId , '">'.
	aBlock value.
	self add: '</div>'!

addDivBlock: aBlock id: layerId cssClass: cssClassStringOrSymbol 
	self add: '<div id="' , layerId , '" class="' , cssClassStringOrSymbol asString , '">'.
	aBlock value.
	self add: '</div>'!

addDivBlock: aBlock id: layerId cssClass: cssClassStringOrSymbol style: style 
	self 
		add: '<div id="' , layerId , '" class="' , cssClassStringOrSymbol asString , '" style="' , style 
				, '">'.
	aBlock value.
	self add: '</div>'!

addDivBlock: aBlock id: layerId style: style 
	self add: '<div id="' , layerId , '" style="' , style , '">'.
	aBlock value.
	self add: '</div>'!

addDivBlock: aBlock style: style 
	self add: '<div style="' , style , '">'.
	aBlock isBlockClosure ifTrue: [aBlock value] ifFalse: [self add: aBlock].
	self add: '</div>'!

addDropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value 
	^self addField: ((HtmlDropDownList name: fieldName)
				items: items;
				displaySelector: displaySelector;
				valueSelector: valueSelector;
				value: value)!

addDropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value cssStyle: style onChange: onChange 
	self addField: ((HtmlDropDownList name: fieldName)
				items: items;
				displaySelector: displaySelector;
				valueSelector: valueSelector;
				value: value;
				cssStyle: style;
				onChange: onChange)!

addDropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value onChange: onChange 
	self 
		addDropDownList: fieldName
		items: items
		displaySelector: displaySelector
		valueSelector: valueSelector
		value: value
		cssStyle: nil
		onChange: onChange!

addDropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value width: width 
	^self addField: ((HtmlDropDownList name: fieldName)
				items: items;
				displaySelector: displaySelector;
				valueSelector: valueSelector;
				value: value;
				width: width;
				yourself)!

addDropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector value: value widthPt: widthPt 
	^self addField: ((HtmlDropDownList name: fieldName)
				items: items;
				displaySelector: displaySelector;
				valueSelector: valueSelector;
				value: value;
				cssStyle: (widthPt isNil ifFalse: ['width:' , widthPt asJavascriptValueWithDecimalsToFloats , 'pt;']);
				yourself)!

addDropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector valueFrom: value 
	^self addField: ((HtmlDropDownList name: fieldName)
				items: items;
				displaySelector: displaySelector;
				valueSelector: valueSelector;
				value: (self getValueFrom: value fieldName: fieldName))!

addDropDownList: fieldName items: items displaySelector: displaySelector valueSelector: valueSelector valueFrom: value tabIndex: tabIndex 
	^self addField: ((HtmlDropDownList name: fieldName)
				items: items;
				displaySelector: displaySelector;
				valueSelector: valueSelector;
				tabIndex: tabIndex;
				value: (self getValueFrom: value fieldName: fieldName))!

addDropDownList: fieldName items: items valueFrom: value 
	^self addField: ((HtmlDropDownList name: fieldName)
				items: items;
				displaySelector: #value;
				valueSelector: #key;
				value: (self getValueFrom: value fieldName: fieldName))!

addDropDownList: fieldName itemsWithNil: items displaySelector: displaySelector valueSelector: valueSelector value: value 
	^self addField: ((HtmlDropDownList name: fieldName)
				itemsWithNil: items;
				displaySelector: displaySelector;
				valueSelector: valueSelector;
				value: value)!

addDropDownList: fieldName itemsWithNil: items displaySelector: displaySelector valueSelector: valueSelector value: value disabled: disabled 
	^self addField: ((HtmlDropDownList name: fieldName)
				itemsWithNil: items;
				displaySelector: displaySelector;
				valueSelector: valueSelector;
				value: value;
				disabled: disabled)!

addDropDownList: fieldName itemsWithNil: items displaySelector: displaySelector valueSelector: valueSelector value: value onChange: onChange 
	self addField: ((HtmlDropDownList name: fieldName)
				itemsWithNil: items;
				displaySelector: displaySelector;
				valueSelector: valueSelector;
				value: value;
				onChange: onChange)!

addDropDownList: fieldName itemsWithNil: items displaySelector: displaySelector valueSelector: valueSelector value: value onChange: onChange disabled: disabled 
	self addField: ((HtmlDropDownList name: fieldName)
				itemsWithNil: items;
				displaySelector: displaySelector;
				valueSelector: valueSelector;
				value: value;
				onChange: onChange;
				disabled: disabled)!

addDropDownList: fieldName itemsWithNil: items displaySelector: displaySelector valueSelector: valueSelector value: value widthPt: widthPt 
	^self addField: ((HtmlDropDownList name: fieldName)
				itemsWithNil: items;
				displaySelector: displaySelector;
				valueSelector: valueSelector;
				value: value;
				cssStyle: (widthPt isNil ifFalse: ['width:' , widthPt asJavascriptValueWithDecimalsToFloats , 'pt;']);
				yourself)!

addDropDownList: fieldName itemsWithNil: items displaySelector: displaySelector valueSelector: valueSelector valueFrom: value 
	^self addField: ((HtmlDropDownList name: fieldName)
				itemsWithNil: items;
				displaySelector: displaySelector;
				valueSelector: valueSelector;
				value: (self getValueFrom: value fieldName: fieldName))!

addDropDownList: fieldName itemsWithNil: items valueFrom: value 
	^self addField: ((HtmlDropDownList name: fieldName)
				itemsWithNil: items;
				displaySelector: #value;
				valueSelector: #key;
				value: (self getValueFrom: value fieldName: fieldName))!

addDropDownListItemsFrom: aWebApplication class: classId property: fieldName value: anObject 
	^self 
		addDropDownListItemsFrom: aWebApplication
		class: classId
		property: fieldName
		value: anObject
		fieldName: fieldName!

addDropDownListItemsFrom: aWebApplication class: classId property: fieldName value: value fieldName: aString 
	self addField: ((HtmlDropDownList name: aString)
				items: (aWebApplication db model valuesFor: classId attribute: fieldName);
				displaySelector: #translatedValue;
				valueSelector: #key;
				value: value)!

addDropDownListItemsFrom: aWebApplication class: classId property: fieldName valueFrom: anObject 
	^self 
		addDropDownListItemsFrom: aWebApplication
		class: classId
		property: fieldName
		valueFrom: anObject
		fieldName: fieldName!

addDropDownListItemsFrom: aWebApplication class: classId property: fieldName valueFrom: anObject disabled: disabled 
	^self 
		addDropDownListItemsFrom: aWebApplication
		class: classId
		property: fieldName
		valueFrom: anObject
		fieldName: fieldName
		disabled: disabled!

addDropDownListItemsFrom: aWebApplication class: classId property: fieldName valueFrom: anObject fieldName: aString 
	^self 
		addDropDownListItemsFrom: aWebApplication
		class: classId
		property: fieldName
		value: (self getValueFrom: anObject fieldName: fieldName)
		fieldName: aString!

addDropDownListItemsFrom: aWebApplication class: classId property: fieldName valueFrom: anObject fieldName: aString disabled: disabled 
	self addField: ((HtmlDropDownList name: aString)
				items: (aWebApplication db model valuesFor: classId attribute: fieldName);
				displaySelector: #translatedValue;
				valueSelector: #key;
				disabled: disabled;
				value: (self getValueFrom: anObject fieldName: fieldName))!

addDropDownListItemsFrom: aWebApplication class: classId property: fieldName valueFrom: anObject fieldName: aString onChange: onChange 
	self addField: ((HtmlDropDownList name: aString)
				items: (aWebApplication db model valuesFor: classId attribute: fieldName);
				displaySelector: #translatedValue;
				valueSelector: #key;
				value: (self getValueFrom: anObject fieldName: fieldName);
				onChange: onChange)!

addDropDownListItemsFrom: aWebApplication class: classId property: fieldName valueFrom: anObject fieldName: aString widthPt: widthPt 
	self addField: ((HtmlDropDownList name: aString)
				items: (aWebApplication db model valuesFor: classId attribute: fieldName);
				displaySelector: #translatedValue;
				valueSelector: #key;
				cssStyle: (widthPt isNil ifFalse: ['width:' , widthPt asJavascriptValueWithDecimalsToFloats , 'pt;']);
				value: (self getValueFrom: anObject fieldName: fieldName))!

addDropDownListItemsFrom: aWebApplication class: classId property: fieldName valueFrom: anObject onChange: onChange 
	^self 
		addDropDownListItemsFrom: aWebApplication
		class: classId
		property: fieldName
		valueFrom: anObject
		fieldName: fieldName
		onChange: onChange!

addDropDownListItemsFrom: aWebApplication class: classId property: fieldName valueFrom: anObject widthPt: widthPt 
	^self 
		addDropDownListItemsFrom: aWebApplication
		class: classId
		property: fieldName
		valueFrom: anObject
		fieldName: fieldName
		widthPt: widthPt!

addDropDownListItemsWithNilFrom: aWebApplication class: classId property: fieldName value: value 
	^self 
		addDropDownListItemsWithNilFrom: aWebApplication
		class: classId
		property: fieldName
		value: value
		fieldName: fieldName!

addDropDownListItemsWithNilFrom: aWebApplication class: classId property: fieldName value: value fieldName: aString 
	^self addField: ((HtmlDropDownList name: aString)
				itemsWithNil: (aWebApplication db model valuesFor: classId attribute: fieldName);
				displaySelector: #translatedValue;
				valueSelector: #key;
				value: value;
				yourself)!

addDropDownListItemsWithNilFrom: aWebApplication class: classId property: fieldName valueFrom: anObject 
	^self 
		addDropDownListItemsWithNilFrom: aWebApplication
		class: classId
		property: fieldName
		valueFrom: anObject
		fieldName: fieldName
		onChange: nil!

addDropDownListItemsWithNilFrom: aWebApplication class: classId property: fieldName valueFrom: anObject fieldName: aString onChange: onChange 
	^self addField: ((HtmlDropDownList name: aString)
				itemsWithNil: (aWebApplication db model valuesFor: classId attribute: fieldName);
				displaySelector: #translatedValue;
				valueSelector: #key;
				value: (self getValueFrom: anObject fieldName: fieldName);
				onChange: onChange;
				yourself)!

addDropDownListItemsWithNilFrom: aWebApplication class: classId property: fieldName valueFrom: anObject onChange: onChange 
	^self 
		addDropDownListItemsWithNilFrom: aWebApplication
		class: classId
		property: fieldName
		valueFrom: anObject
		fieldName: fieldName
		onChange: onChange!

addEditLinkTo: url 
	self
		addImage: 'images/edit.gif'
			width: 15
			height: 13
			toolTip: 'asp.label.helpTip.Edit'
			linkTo: url;
		nextCell!

addEmailData: anEmail 
	(ItcSystemManager checkEmail: anEmail) 
		ifTrue: [self addData: anEmail linkTo: 'mailto:' , anEmail]
		ifFalse: [self addData: anEmail]!

addEmptyStringCaseFunctionFor: associations named: functionName 
	self addJavascript: 
			[self add: 'function ' , functionName , '(key) {
switch(key) {'.
			associations do: 
					[:each | 
					self 
						add: 'case "' , each key asWebString webHtmlEncodedForForm , '":return "' 
								, each value asWebString webHtmlEncodedForForm , '";
'].
			self add: 'default: return "";
}}']!

addErrorText: errorMessage 
	errorMessage isNilOrEmpty 
		ifFalse: [self addField: '<font class="error">' , errorMessage webTranslate , '</font>']!

addErrorTextInBrackets: errorMessage 
	errorMessage isNilOrEmpty 
		ifFalse: 
			[self addField: '<font class="error"><b>( ' , errorMessage webTranslate , ' )</b></font>']!

addField: aHtmlElement 
	self add: aHtmlElement.
	^aHtmlElement!

addFileField: name errors: errorsDictionary 
	self
		add: '<input type="file" name="' , name , '"/>';
		addFormFieldErrorTextFor: name from: errorsDictionary!

addFormFieldErrorTextFor: fieldName from: errorsDictionary 
	self 
		addFormFieldErrorTextFor: fieldName
		from: errorsDictionary
		break: true!

addFormFieldErrorTextFor: fieldName from: errorsDictionary break: break 
	| errorMessage |
	(errorsDictionary isNil or: 
			[(errorMessage := fieldName isSymbol 
						ifFalse: 
							[errorsDictionary at: fieldName
								ifAbsent: [errorsDictionary at: fieldName asSymbol ifAbsent: []]]
						ifTrue: 
							[errorsDictionary at: fieldName
								ifAbsent: [errorsDictionary at: fieldName asString ifAbsent: []]]) 
					isNil]) 
		ifFalse: 
			[break ifTrue: [self break].
			self add: '<font class="error">' , errorMessage webTranslate , '</font>']!

addFormFieldWarningTextFor: fieldName from: errorsDictionary 
	self 
		addFormFieldWarningTextFor: fieldName
		from: errorsDictionary
		break: true!

addFormFieldWarningTextFor: fieldName from: warningsDictionary break: break 
	| errorMessage |
	(warningsDictionary isNil or: 
			[(errorMessage := fieldName isSymbol 
						ifFalse: 
							[warningsDictionary at: fieldName
								ifAbsent: [warningsDictionary at: fieldName asSymbol ifAbsent: []]]
						ifTrue: 
							[warningsDictionary at: fieldName
								ifAbsent: [warningsDictionary at: fieldName asString ifAbsent: []]]) 
					isNil]) 
		ifFalse: 
			[break ifTrue: [self break].
			self add: '<font class="warning">' , errorMessage webTranslate , '</font>']!

addGreenLamp
	self 
		addImage: 'images/greenlamp.gif'
		width: 15
		height: 15!

addGreenLampTip: aString 
	self 
		addImage: 'images/greenlamp.gif'
		width: 15
		height: 15
		toolTip: aString!

addH1: anElement 
	self
		add: '<h1>';
		add: anElement;
		add: '</h1>'!

addHelp2ImageLinkInNewWindowTo: url 
	self 
		addImage: 'images/help2.gif'
		width: 20
		height: 20
		toolTip: 'asp.button.Help'
		linkTo: url
		target: '_blank'!

addHelp2ImageLinkTo: url 
	self
		addImage: 'images/help2.gif'
			width: 20
			height: 20
			toolTip: 'asp.button.Help'
			linkTo: url;
		nextCell!

addHiddenDefaultButton: action 
	self add: '<input type="image" border="0" name="BUTTON_' , action webAsActionString 
				, '" src="images/pixel.gif" width="1" height="1" alt=""/>'!

addHiddenField: name value: value 
	self add: (HtmlHiddenField name: name value: value)!

addHiddenField: name valueFrom: value 
	self add: (HtmlHiddenField name: name value: (self getValueFrom: value fieldName: name))!

addHintBoxWithText: aMessageId 
	self 
		add: '<div class="wizardExtra" style="width:400px;padding-bottom:12px;">' 
				, aMessageId webTranslate webHtmlEncoded , '</div>'!

addHtmlEditor: name value: value 
	^self 
		addHtmlEditor: name
		value: value
		columns: nil
		rows: nil!

addHtmlEditor: name value: value columns: columns rows: rows 
	| width height |
	columns isNil ifFalse: [width := (columns * 8.25s) rounded].
	rows isNil ifFalse: [height := rows * 25].
	^self 
		addHtmlEditor: name
		value: value
		width: width
		height: height!

addHtmlEditor: name value: value columns: columns rows: rows errors: errorsDictionary 
	self
		addHtmlEditor: name
			value: value
			columns: columns
			rows: rows;
		addFormFieldErrorTextFor: name from: errorsDictionary!

addHtmlEditor: name value: value width: width height: height 
	^self 
		addHtmlEditor: name
		value: value
		width: width
		height: height
		expandedToolbar: true!

addHtmlEditor: name value: value width: width height: height expandedToolbar: expandedToolbarBoolean 
	^self 
		addHtmlEditor: name
		value: value
		width: width
		height: height
		expandedToolbar: expandedToolbarBoolean
		editorAreaCSS: nil
		linkBrowserUrl: nil
		imageBrowserUrl: nil
		imageUploadUrl: nil!

addHtmlEditor: name value: value width: width height: height expandedToolbar: expandedToolbarBoolean editorAreaCSS: editorAreaCSSorNil linkBrowserUrl: linkBrowserUrlOrNil imageBrowserUrl: imagesBrowserUrlOrNil imageUploadUrl: imageUploadUrlOrNil 
	| editorName ws activeProcess language linkBrowserUrl imagesBrowserUrl editorAreaCSS session imageUploadUrl |
	(activeProcess := Processor activeProcess) attributes at: #javascriptHtmlEditor put: true.
	session := activeProcess webSession.
	linkBrowserUrl := linkBrowserUrlOrNil isNilOrEmpty 
				ifTrue: [session isNil ifFalse: [session sessionData at: #FCKEditorLinkBrowserUrl ifAbsent: []]]
				ifFalse: [linkBrowserUrlOrNil].
	(linkBrowserUrl isNilOrEmpty or: [linkBrowserUrl includes: $?]) 
		ifFalse: [linkBrowserUrl := linkBrowserUrl , '?lang=' , Processor activeProcess language].
	imagesBrowserUrl := imagesBrowserUrlOrNil isNilOrEmpty 
				ifTrue: [session isNil ifFalse: [session sessionData at: #FCKEditorImageBrowserUrl ifAbsent: []]]
				ifFalse: [imagesBrowserUrlOrNil].
	(imagesBrowserUrl isNilOrEmpty or: [imagesBrowserUrl includes: $?]) 
		ifFalse: [imagesBrowserUrl := imagesBrowserUrl , '?lang=' , Processor activeProcess language].
	imageUploadUrl := imageUploadUrlOrNil isNilOrEmpty 
				ifTrue: [session isNil ifFalse: [session sessionData at: #FCKEditorImageUploadUrl ifAbsent: []]]
				ifFalse: [imageUploadUrlOrNil].
	editorAreaCSS := editorAreaCSSorNil isNilOrEmpty 
				ifTrue: [session isNil ifFalse: [session sessionData at: #FCKEditorEditorAreaCSS ifAbsent: []]]
				ifFalse: [editorAreaCSSorNil].
	editorName := 'fck_' , name asWebString.
	ws := WriteStream on: String new.
	ws
		nextPutAll: editorName;
		nextPutAll: '=new FCKeditor("' , name , '");';
		nextPutAll: editorName;
		nextPutAll: '.ToolbarSet="Standard";';
		nextPutAll: editorName;
		nextPutAll: '.BasePath="/';
		nextPutAll: activeProcess webApplication urlPrefix;
		nextPutAll: '/fckeditor/";';
		nextPutAll: editorName;
		nextPutAll: '.Config["AutoDetectLanguage"]=false;';
		nextPutAll: editorName;
		nextPutAll: '.Config["IncludeLatinEntities"]=false;';
		nextPutAll: editorName;
		nextPutAll: '.Config["ProcessNumericEntities"]=false;';
		nextPutAll: editorName;
		nextPutAll: '.Config["ProcessHTMLEntities"]=false;'.
	expandedToolbarBoolean = false 
		ifTrue: 
			[ws
				nextPutAll: editorName;
				nextPutAll: '.Config["ToolbarStartExpanded"]=false;'].
	editorAreaCSS isNilOrEmpty 
		ifFalse: 
			[ws
				nextPutAll: editorName;
				nextPutAll: '.Config["EditorAreaCSS"]=';
				nextPutAll: editorAreaCSS asJavascriptValue;
				nextPut: $;].
	linkBrowserUrl isNilOrEmpty 
		ifFalse: 
			[ws
				nextPutAll: editorName;
				nextPutAll: '.Config["LinkBrowser"]=true;';
				nextPutAll: editorName;
				nextPutAll: '.Config["LinkBrowserURL"]=';
				nextPutAll: linkBrowserUrl asJavascriptValue;
				nextPut: $;].
	imagesBrowserUrl isNilOrEmpty 
		ifFalse: 
			[ws
				nextPutAll: editorName;
				nextPutAll: '.Config["ImageBrowser"]=true;';
				nextPutAll: editorName;
				nextPutAll: '.Config["ImageBrowserURL"]=';
				nextPutAll: imagesBrowserUrl asJavascriptValue;
				nextPut: $;].
	imageUploadUrl isNilOrEmpty 
		ifFalse: 
			[ws
				nextPutAll: editorName;
				nextPutAll: '.Config["ImageUpload"]=true;';
				nextPutAll: editorName;
				nextPutAll: '.Config["ImageUploadURL"]=';
				nextPutAll: imageUploadUrl asJavascriptValue;
				nextPut: $;].
	language := 
			[(LookupTable new)
				at: 'Slovene' put: 'sl';
				at: 'Croatian' put: 'hr';
				at: 'Serbian' put: 'sr-latn';
				at: 'German' put: 'de';
				at: 'Czech' put: 'cs';
				at: 'Russian' put: 'ru';
				yourself] 
					cachedValue at: activeProcess language ifAbsent: ['en'].
	ws
		nextPutAll: editorName;
		nextPutAll: '.Config["DefaultLanguage"]="' , language , '";';
		nextPutAll: editorName;
		nextPutAll: '.Value=';
		nextPutAll: value asWebString asJavascriptValue;
		nextPutAll: ';'.
	ws
		nextPutAll: editorName;
		nextPutAll: '.Create();'.
	width isNil 
		ifFalse: 
			[ws nextPutAll: 'commonGetElementById("' , name , '___Frame").style.width="' , width asWebString 
						, 'px";'].
	height isNil 
		ifFalse: 
			[ws nextPutAll: 'commonGetElementById("' , name , '___Frame").style.height="' , height asWebString 
						, 'px";'].
	self addJavascript: ws contents!

addHtmlEditor: name valueFrom: value errors: errors 
	self
		addHtmlEditor: name
			value: (self getValueFrom: value fieldName: name)
			width: nil
			height: nil;
		addFormFieldErrorTextFor: name from: errors!

addHtmlEditor: name valueFrom: value width: width height: height expandedToolbar: expandedToolbarBoolean errors: errors 
	self
		addHtmlEditor: name
			value: (self getValueFrom: value fieldName: name)
			width: width
			height: height
			expandedToolbar: expandedToolbarBoolean;
		addFormFieldErrorTextFor: name from: errors!

addImage: imgSrc 
	self addField: '<img src="' , imgSrc , '" alt=""/>'!

addImage: imgSrc width: w height: h 
	self addField: '<img src="' , imgSrc , '" width="' , w printString , '" height="' , h printString 
				, '" alt=""/>'!

addImage: imgSrc width: w height: h onClick: script 
	self 
		addField: '<img src="' , imgSrc , '" width=' , w printString , ' height=' , h printString 
				, ' onclick="javascript:' , script 
				, '"/>'!

addImage: imgSrc width: w height: h onClick: script cssStyle: aString 
	self 
		addField: '<img src="' , imgSrc , '" width=' , w printString , ' height=' , h printString 
				, ' onclick="javascript:' , script 
				, '" style="' , aString 
				, '"/>'!

addImage: imgSrc width: w height: h toolTip: toolTip 
	| translation |
	translation := toolTip webTranslate.
	self 
		addField: '<img src="' , imgSrc , '" width=' , w printString , ' height=' , h printString 
				, ' alt="' , translation 
				, '" title="' , translation 
				, '" border="0"/>'!

addImage: imgSrc width: w height: h toolTip: toolTip linkTo: url 
	| translation |
	translation := toolTip webTranslate.
	self 
		addField: '<a href="' , url webXhtmlUrlEncodeForForm , '"><img src="' , imgSrc , '" width="' 
				, w printString , '" height="' 
				, h printString , '" alt="' 
				, translation , '" title="' 
				, translation , '" border="0"/></a>'!

addImage: imgSrc width: w height: h toolTip: toolTip linkTo: url target: target 
	| str |
	str := toolTip webTranslate.
	self 
		addField: '<a href="' , url , '"  target="' , target , '"><img src="' , imgSrc 
				, '" width=' , w printString 
				, ' height=' , h printString 
				, ' alt="' , str 
				, '" title="' , str 
				, '" border="0"/></a>'!

addImage: imgSrc width: w height: h toolTip: toolTip onClick: script 
	| translation |
	translation := toolTip webTranslate.
	self 
		addField: '<img src="' , imgSrc , '" width="' , w printString , '" height="' , h printString 
				, '" alt="' , translation 
				, '" title="' , translation 
				, '" border="0"' , (script isNilOrEmpty 
							ifTrue: ['']
							ifFalse: [' style="cursor:pointer;cursor:hand" onclick="' , script , '"']) 
				, ' />'!

addImage: imgSrc width: w height: h toolTip: toolTip onClick: script style: styleString 
	| translation |
	translation := toolTip webTranslate.
	self 
		addField: '<img src="' , imgSrc , '" width=' , w printString , ' height=' , h printString 
				, ' alt="' , translation 
				, '" title="' , translation 
				, '" border="0" style="' , styleString 
				, '"' 
					, (script isNilOrEmpty ifTrue: [''] ifFalse: [' onclick="javascript:' , script , '"']) 
					, '/>'!

addImageButton: imgSrc width: w height: h toolTip: toolTip accessKey: accessKey action: action onClick: onClick 
	| str onClickString ws actionString |
	str := toolTip webTranslate.
	actionString := action webAsActionString.
	onClickString := onClick isNil ifTrue: [''] ifFalse: [onClick].
	action isAjaxAction 
		ifTrue: 
			[(action beginsWith: 'ajaxGet') 
				ifTrue: 
					[Processor activeProcess attributes at: #javascriptDialogBox put: true.
					onClickString := onClickString , 'ajaxGetRequest(' 
								, (Processor activeProcess webTask taskURLPrefix , '?action=' , actionString) asJavascriptValue 
									, ');return false;']
				ifFalse: 
					[(action beginsWith: 'ajaxPost') 
						ifTrue: 
							[onClickString := onClickString , 'ajaxPostRequestForAction(this,' , action asJavascriptValue 
										, ');return false;']]].
	ws := WriteStream on: (String new: 512).
	ws
		nextPutAll: '<input type="image" border="0" tabindex="998" name="BUTTON_';
		nextPutAll: actionString;
		nextPutAll: '" src="';
		nextPutAll: imgSrc;
		nextPutAll: '"  width="';
		nextPutAll: w printString;
		nextPutAll: '" height="';
		nextPutAll: h printString;
		nextPutAll: '" accesskey="';
		nextPutAll: accessKey;
		nextPutAll: '" alt="';
		nextPutAll: str;
		nextPutAll: '" title="';
		nextPutAll: str.
	onClickString isNilOrEmpty 
		ifFalse: 
			[ws
				nextPutAll: '" onclick="';
				nextPutAll: onClickString].
	ws nextPutAll: '"/>'.
	self addField: ws contents!

addImageButton: imgSrc width: w height: h toolTip: toolTip accessKey: accessKey onClick: onClick 
	| str |
	str := toolTip webTranslate.
	self 
		addField: '<input type="image" border="0" tabindex="998" onclick="' , onClick , '" src="' 
				, imgSrc , '"  width="' 
				, w printString , '" height="' 
				, h printString , '" accessKey="' 
				, accessKey , '" alt="' 
				, str , '" title="' 
				, str , '"/>'!

addImageButton: imgSrc width: w height: h toolTip: toolTip action: action 
	| str |
	str := toolTip webTranslate.
	self 
		addField: '<input type="image" border="0" tabindex="998" name="BUTTON_' , action 
				, '" src="' , imgSrc 
				, '"  width="' , w printString 
				, '" height="' , h printString 
				, '" alt="' , str 
				, '" title="' , str 
				, '"/>'!

addImageButtonFindForAction: action toolTip: toolTip accessKey: accessKey 
	^self 
		addImageButton: 'images/find.gif'
		width: 15
		height: 13
		toolTip: toolTip
		accessKey: accessKey
		action: action
		onClick: nil!

addImageButtonFindForAction: action toolTip: toolTip onClick: onClick 
	^self 
		addImageButton: 'images/find.gif'
		width: 15
		height: 13
		toolTip: toolTip
		accessKey: ''
		action: action
		onClick: onClick!

addImageButtonFindOnClick: onClick toolTip: toolTip accessKey: accessKey 
	^self 
		addImageButton: 'images/find.gif'
		width: 15
		height: 13
		toolTip: toolTip
		accessKey: accessKey
		onClick: onClick!

addImageHtml: imageTag 
	"Special method for adding raw <IMG> tag HTML or any other HTML that should not be exported into non-HTML tables (like CSV or Excel)."

	self addField: imageTag!

addInlineEditable: anObject for: task selector: selector 
	(task isInlineEditingEnabledFor: selector) 
		ifTrue: 
			[self
				add: '<span id="edDiv_' , selector asString 
							, '"><a class="inlineEdit" href="javascript:void(0);" onclick="' 
								, (task urlPrefixForAction: #ajaxGetInlineEditField id: selector) , '">';
				add: anObject;
				add: '</a></span>']
		ifFalse: [self add: anObject]!

addInlineEditableData: stringData for: task selector: selector 
	| str |
	str := stringData asWebString.
	str := str size < 2 
				ifTrue: [str webHtmlEncoded , '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;']
				ifFalse: [str webHtmlEncoded].
	^self 
		addInlineEditable: str
		for: task
		selector: selector!

addInlineEditableDivContentForLongText: anObject for: task selector: selector 
	self
		add: '<div class="inlineEdit" onclick="' 
					, (task urlPrefixForAction: #ajaxGetInlineEditField id: selector) , '" style="height:' 
					, (anObject isNilOrEmpty ifTrue: ['2'] ifFalse: ['5']) , '0px;overflow:auto;">';
		add: anObject asWebString webHtmlEncoded;
		add: '</div>'!

addInlineEditableForLongText: anObject for: task selector: selector 
	self add: '<div style="background:#f0f0f0;border:1px solid #808080;margin:2px;">'.
	(task isInlineEditingEnabledFor: selector) 
		ifTrue: 
			[self
				add: '<div id="edDiv_' , selector asString , '">';
				addInlineEditableDivContentForLongText: anObject
					for: task
					selector: selector;
				add: '</div>']
		ifFalse: [self add: anObject asWebString webHtmlEncoded].
	self add: '</div>'!

addJavascript: aStringOrBlock 
	aStringOrBlock isNilOrEmpty ifTrue: [^self].
	Processor activeProcess webProcessingAjaxRequest 
		ifTrue: 
			[Processor activeProcess webAjaxRequestJavascriptCollector 
				nextPutAll: (aStringOrBlock isBlockClosure ifTrue: [aStringOrBlock value] ifFalse: [aStringOrBlock])]
		ifFalse: 
			[javascriptSink isNil 
				ifFalse: [javascriptSink addJavascript: aStringOrBlock]
				ifTrue: 
					[self add: self class javascriptBeginString.
					aStringOrBlock isBlockClosure ifTrue: [aStringOrBlock value] ifFalse: [self add: aStringOrBlock].
					self add: self class javascriptEndString]]!

addLabel: aString 
	"Adds a label.
	It will use 'dgLb' class for font settings.
	It will translate aString before using it and add double colon : after the label."

	self add: '<font class="dgLb">' , aString webTranslate , ':</font> '!

addLabel: aString data: anObject 
	"Adds a label.
	It will use 'dgLb' class for font settings.
	It will translate aString before using it and add double colon : after the label."

	self
		add: '<font class="dgLb">' , aString webTranslate , ':</font> ';
		add: anObject asWebString webHtmlEncoded;
		break!

addLabel: aString data: anObject linkTo: url 
	self
		addLabel: aString;
		add: '<a href="' , url , '">';
		add: anObject asWebString webHtmlEncoded;
		add: '</a>';
		nextCell!

addLabelForOptionalZipAndCityField: labelString zipCode: zipCode city: city errors: errorsDictionary 
	^self 
		addLabelForZipAndCityField: labelString
		zipCode: zipCode
		city: city
		zipField: 'zipCode'
		cityField: 'city'
		mandatory: false
		errors: errorsDictionary!

addLabelForZipAndCityField: labelString zipCode: zipCode city: city errors: errorsDictionary 
	^self 
		addLabelForZipAndCityField: labelString
		zipCode: zipCode
		city: city
		zipField: 'zipCode'
		cityField: 'city'
		mandatory: true
		errors: errorsDictionary!

addLabelForZipAndCityField: labelString zipCode: zipCode city: city zipField: zipField cityField: cityField mandatory: mandatory disabled: disabledBool errors: errorsDictionary 
	^self 
		addLabelForZipAndCityField: labelString
		zipCode: zipCode
		city: city
		zipField: zipField
		cityField: cityField
		mandatory: mandatory
		disabled: disabledBool
		errors: errorsDictionary
		zipCodeFieldStyle: nil
		cityFieldStyle: nil!

addLabelForZipAndCityField: labelString zipCode: zipCode city: city zipField: zipField cityField: cityField mandatory: mandatory disabled: disabledBool errors: errorsDictionary zipCodeFieldStyle: zipCodeFieldStyle cityFieldStyle: cityFieldStyle 
	| formName zipCodesResult |
	formName := Processor activeProcess webCoderDefaultFormName.
	Processor activeProcess webProcessingAjaxRequest 
		ifFalse: [Processor activeProcess attributes at: #javascriptZipToCity put: true]
		ifTrue: 
			[zipCodesResult := WriteStream on: String new.
			zipCodesResult nextPutAll: 'self.cityFromZipCode = function (zipCode){switch(zipCode){
'.
			Processor activeProcess webApplication postneStevilke do: 
					[:eachAssociation | 
					zipCodesResult
						nextPutAll: 'case "';
						nextPutAll: eachAssociation key;
						nextPutAll: '":return "';
						nextPutAll: eachAssociation value;
						nextPutAll: '";
'].
			zipCodesResult nextPutAll: 'default: break;}};'.
			self addJavascript: zipCodesResult contents].
	labelString isNil 
		ifFalse: [self addLabel: labelString]
		ifTrue: 
			["enclose into no spacing table so that fields wont be split"
			self add: '<table cellspacing="0" cellpadding="0"><tr><td>'].
	self add: '<input type="text" name="' , zipField , '" size="5" maxlength="12'.
	disabledBool == true ifTrue: [self add: '" disabled="disabled'].
	zipCodeFieldStyle isNil ifFalse: [self add: '" style="' , zipCodeFieldStyle].
	zipCode isNil 
		ifFalse: 
			[self add: '" value="' 
						, (zipCode isString ifTrue: [zipCode webHtmlEncodedForForm] ifFalse: [zipCode asWebString])].
	self 
		add: '" onkeyup="var cityName=cityFromZipCode(document.' , formName , '.' , zipField 
				, '.value); if(cityName!!=null) document.' , formName 
				, '.' , cityField 
				, '.value=cityName;"/>'.
	labelString isNil ifTrue: [self add: '</td><td>'].
	mandatory = true 
		ifTrue: 
			[(self 
				addMandatoryTextField: cityField
				value: city
				size: 18
				errors: errorsDictionary)
				disabled: disabledBool;
				cssStyle: cityFieldStyle]
		ifFalse: 
			[(self 
				addTextField: cityField
				value: city
				size: 18
				errors: errorsDictionary)
				disabled: disabledBool;
				cssStyle: cityFieldStyle].
	labelString isNil ifTrue: [self add: '</td></tr></table>'] ifFalse: [self nextCell]!

addLabelForZipAndCityField: labelString zipCode: zipCode city: city zipField: zipField cityField: cityField mandatory: mandatory errors: errorsDictionary 
	^self 
		addLabelForZipAndCityField: labelString
		zipCode: zipCode
		city: city
		zipField: zipField
		cityField: cityField
		mandatory: mandatory
		disabled: false
		errors: errorsDictionary!

addLabelText: aString 
	"Adds a label.
	It will use 'dgLb' class for font settings.
	It will translate aString before using it and add double colon : after the label."

	self add: '<font class="dgLb">' , aString webTranslate , ':</font> '!

addMandatoryDateField: name value: value
	self
		add: (HtmlDateField name: name value: value);
		redStar!

addMandatoryDateField: name value: value baseDate: baseDate 
	self 
		addDateField: name
		value: value
		mandatory: true
		baseDate: baseDate
		onChange: nil
		errors: nil!

addMandatoryDateField: name value: value baseDate: baseDate errors: errors 
	self 
		addDateField: name
		value: value
		mandatory: true
		baseDate: baseDate
		onChange: nil
		errors: errors!

addMandatoryDateField: name value: value baseDate: baseDate hideFields: hideFields 
	self 
		addDateField: name
		value: value
		mandatory: true
		baseDate: baseDate
		onChange: nil
		hideFields: hideFields
		errors: nil!

addMandatoryDateField: name value: value baseDate: baseDate hideFields: hideFields errors: errors
	self 
		addDateField: name
		value: value
		mandatory: true
		baseDate: baseDate
		onChange: nil
		hideFields: hideFields
		errors: errors!

addMandatoryDateField: name value: value baseDate: baseDate onChange: onChange 
	self 
		addDateField: name
		value: value
		mandatory: true
		baseDate: baseDate
		onChange: onChange
		errors: nil!

addMandatoryDateField: name value: value errors: errors 
	^self 
		addDateField: name
		value: value
		mandatory: true
		baseDate: nil
		onChange: nil
		errors: errors!

addMandatoryDateField: name value: value errors: errors onChange: onChange 
	^self 
		addDateField: name
		value: value
		mandatory: true
		baseDate: nil
		onChange: onChange
		errors: errors!

addMandatoryDateField: name value: value hideFields: hideFields 
	self 
		addDateField: name
		value: value
		mandatory: true
		baseDate: nil
		onChange: nil
		hideFields: hideFields
		errors: nil!

addMandatoryDateField: name value: value hideFields: hideFields errors: errors 
	self 
		addDateField: name
		value: value
		mandatory: true
		baseDate: nil
		onChange: nil
		hideFields: hideFields
		errors: errors!

addMandatoryDateField: name valueFrom: value errors: errors 
	^self 
		addMandatoryDateField: name
		value: (self getValueFrom: value fieldName: name)
		errors: errors!

addMandatoryDateField: name valueFrom: value errors: errors onChange: onChange 
	^self 
		addMandatoryDateField: name
		value: (self getValueFrom: value fieldName: name)
		errors: errors
		onChange: onChange!

addMandatoryDateField: name valueFrom: value hideFields: hideFields errors: errors 
	^self 
		addMandatoryDateField: name
		value: (self getValueFrom: value fieldName: name)
		hideFields: hideFields
		errors: errors!

addMandatoryDisabledTextField: name value: value size: size errors: errorsDictionary
	self
		add: ((HtmlTextField new)
					name: name;
					value: value;
					size: size;
					disabled: true);
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMandatoryMoneyField: name value: value comboBoxValues: comboBoxValues errors: errors 
	^(self 
		addTextField: name
		value: value
		size: 12
		maxLength: 20
		tabIndex: nil
		mandatory: true
		comboBoxValues: comboBoxValues
		onChange: nil
		errors: errors)
		alignRight;
		yourself!

addMandatoryMoneyField: name value: value disabled: disabled errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					alignRight;
					name: name;
					value: value;
					disabled: disabled;
					autocomplete: false;
					size: 12);
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMandatoryMoneyField: name value: value errors: errorsDictionary 
	| f |
	f := (HtmlTextField new)
				alignRight;
				name: name;
				value: value;
				autocomplete: false;
				size: 12.
	self
		addField: f;
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary.
	^f!

addMandatoryMoneyField: name value: value precision: precision errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					alignRight;
					name: name;
					value: (value asWebStringWithPrecision: precision);
					autocomplete: false;
					size: 12);
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMandatoryMoneyField: name value: value tabIndex: tabIndex errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					alignRight;
					name: name;
					value: value;
					size: 12;
					autocomplete: false;
					tabIndex: tabIndex);
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMandatoryMoneyField: name valueFrom: value errors: errorsDictionary 
	^self 
		addMandatoryMoneyField: name
		value: (self getValueFrom: value fieldName: name)
		errors: errorsDictionary!

addMandatoryMoneyField: name valueFrom: value precision: precision errors: errorsDictionary 
	^self 
		addMandatoryMoneyField: name
		value: (self getValueFrom: value fieldName: name)
		precision: precision
		errors: errorsDictionary!

addMandatoryReadOnlyTextField: name value: value size: size errors: errorsDictionary
	self
		add: ((HtmlTextField new)
					name: name;
					value: value;
					size: size;
					readOnly: true);
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMandatoryTextArea: name value: aString columns: nCols rows: nRows errors: errorsDictionary 
	self
		addTextArea: name
			value: aString
			columns: nCols
			rows: nRows
			errors: nil;
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMandatoryTextArea: name valueFrom: value columns: nCols rows: nRows errors: errorsDictionary 
	^self 
		addMandatoryTextArea: name
		value: (self getValueFrom: value fieldName: name)
		columns: nCols
		rows: nRows
		errors: errorsDictionary!

addMandatoryTextField: name value: value errors: errorsDictionary 
	| f |
	f := (HtmlTextField new)
				name: name;
				value: value.
	self
		add: f;
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary.
	^f!

addMandatoryTextField: name value: value readOnly: readOnly errors: errorsDictionary 
	self
		add: ((HtmlTextField new)
					name: name;
					readOnly: readOnly;
					value: value);
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMandatoryTextField: name value: value size: size errors: errorsDictionary 
	| f |
	f := (HtmlTextField new)
				name: name;
				value: value;
				size: size.
	self
		add: f;
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary.
	^f!

addMandatoryTextField: name value: value size: size maxLength: maxLength errors: errorsDictionary
	self
		add: ((HtmlTextField new)
					name: name;
					value: value;
					size: size;
					maxLength: maxLength);
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMandatoryTextField: name value: value size: size maxLength: maxLength tabIndex: tabIndex errors: errorsDictionary 
	self
		add: ((HtmlTextField new)
					name: name;
					value: value;
					size: size;
					maxLength: maxLength;
					tabIndex: tabIndex);
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMandatoryTextField: name value: value size: size onBlur: onBlur errors: errorsDictionary 
	self
		add: ((HtmlTextField new)
					name: name;
					value: value;
					size: size;
					onBlur: onBlur);
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMandatoryTextField: name value: value size: size onChange: onChange errors: errorsDictionary 
	self
		add: ((HtmlTextField new)
					name: name;
					value: value;
					size: size;
					onChange: onChange);
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMandatoryTextField: name value: value size: size tabIndex: tabIndex errors: errorsDictionary
	self
		add: ((HtmlTextField new)
					name: name;
					value: value;
					size: size;
					tabIndex: tabIndex);
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMandatoryTextField: name valueFrom: value errors: errorsDictionary 
	^self 
		addMandatoryTextField: name
		value: (self getValueFrom: value fieldName: name)
		errors: errorsDictionary!

addMandatoryTextField: name valueFrom: aModel size: size errors: errorsDictionary 
	self
		add: ((HtmlTextField new)
					name: name;
					value: (self getValueFrom: aModel fieldName: name);
					size: size);
		redStar;
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMandatoryTimeComboField: name value: value errors: errorsDictionary 
	| coll t hour halfAnHour |
	coll := OrderedCollection new.
	t := Time fromSeconds: 60 * 60 * 4.
	hour := Time fromSeconds: 60 * 60.
	halfAnHour := Time fromSeconds: 30 * 60.
	3 timesRepeat: 
			[coll add: t asShortWebString.
			t := t addTime: hour].
	34 timesRepeat: 
			[coll add: t asShortWebString.
			t := t addTime: halfAnHour].
	self 
		addTextField: name
		value: value asWebString
		size: 7
		maxLength: 8
		mandatory: true
		comboBoxValues: coll
		onChange: nil
		errors: errorsDictionary!

addMandatoryTimeField: name value: value errors: errorsDictionary 
	self 
		addMandatoryTextField: name
		value: value asWebString
		size: 7
		maxLength: 8
		errors: errorsDictionary!

addMoneyField: name value: value 
	^self addField: ((HtmlTextField new)
				alignRight;
				name: name;
				value: value;
				autocomplete: false;
				size: 12)!

addMoneyField: name value: value comboBoxValues: comboBoxValues errors: errors 
	^(self 
		addTextField: name
		value: value
		size: 12
		maxLength: 20
		tabIndex: nil
		mandatory: false
		comboBoxValues: comboBoxValues
		onChange: nil
		errors: errors)
		alignRight;
		yourself!

addMoneyField: name value: value disabled: disabled errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					alignRight;
					name: name;
					value: value;
					disabled: disabled;
					autocomplete: false;
					size: 12);
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMoneyField: name value: value errors: errorsDictionary 
	| f |
	self
		addField: ((f := HtmlTextField new)
					alignRight;
					name: name;
					value: value;
					autocomplete: false;
					size: 12);
		addFormFieldErrorTextFor: name from: errorsDictionary.
	^f!

addMoneyField: name value: value onChange: onChange errors: errorsDictionary 
	| f |
	f := HtmlTextField new.
	f
		alignRight;
		name: name;
		value: value;
		onChange: onChange;
		autocomplete: false;
		size: 12.
	self
		addField: f;
		addFormFieldErrorTextFor: name from: errorsDictionary.
	^f!

addMoneyField: name value: value precision: precision errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					alignRight;
					name: name;
					autocomplete: false;
					value: (value asWebStringWithPrecision: precision);
					size: 12);
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMoneyField: name value: value readOnly: readOnly 
	self 
		addMoneyField: name
		value: value
		size: 12
		readOnly: readOnly!

addMoneyField: name value: value size: size 
	self addField: ((HtmlTextField new)
				alignRight;
				name: name;
				value: value;
				autocomplete: false;
				size: size)!

addMoneyField: name value: value size: size errors: errorsDictionary 
	| f |
	self
		addField: ((f := HtmlTextField new)
					alignRight;
					name: name;
					autocomplete: false;
					value: value asWebString;
					size: (size isNil ifTrue: [12] ifFalse: [size]));
		addFormFieldErrorTextFor: name from: errorsDictionary.
	^f!

addMoneyField: name value: value size: size precision: precision comboBoxValues: comboBoxValues errors: errorsDictionary 
	^(self 
		addTextField: name
		value: (value asWebStringWithPrecision: precision)
		size: (size isNil ifTrue: [12] ifFalse: [size])
		maxLength: nil
		mandatory: false
		comboBoxValues: comboBoxValues
		errors: errorsDictionary)
		alignRight;
		yourself!

addMoneyField: name value: value size: size precision: precision disabled: disabled errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					alignRight;
					name: name;
					autocomplete: false;
					value: (value asWebStringWithPrecision: precision);
					disabled: disabled;
					size: (size isNil ifTrue: [12] ifFalse: [size]));
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMoneyField: name value: value size: size precision: precision errors: errorsDictionary 
	| f |
	self
		addField: ((f := HtmlTextField new)
					alignRight;
					name: name;
					autocomplete: false;
					value: (value asWebStringWithPrecision: precision);
					size: (size isNil ifTrue: [12] ifFalse: [size]));
		addFormFieldErrorTextFor: name from: errorsDictionary.
	^f!

addMoneyField: name value: value size: size precision: precision onBlur: onBlurScript errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					alignRight;
					onBlur: onBlurScript;
					autocomplete: false;
					name: name;
					value: (value asWebStringWithPrecision: precision);
					size: (size isNil ifTrue: [12] ifFalse: [size]));
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMoneyField: name value: value size: size precision: precision onChange: onChange errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					alignRight;
					name: name;
					autocomplete: false;
					value: (value asWebStringWithPrecision: precision);
					onChange: onChange;
					size: (size isNil ifTrue: [12] ifFalse: [size]));
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMoneyField: name value: value size: size precision: precision onChange: onChange onFocus: onFocus errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					alignRight;
					name: name;
					autocomplete: false;
					value: (value asWebStringWithPrecision: precision);
					onChange: onChange;
					onFocus: onFocus;
					size: (size isNil ifTrue: [12] ifFalse: [size]));
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMoneyField: name value: value size: size readOnly: readOnly 
	self addField: ((HtmlTextField new)
				alignRight;
				name: name;
				value: value;
				readOnly: readOnly;
				autocomplete: false;
				size: size)!

addMoneyField: name value: value tabIndex: tabIndex errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					alignRight;
					name: name;
					value: value;
					size: 12;
					autocomplete: false;
					tabIndex: tabIndex);
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMoneyField: name valueFrom: anObject 
	^self addMoneyField: name value: (self getValueFrom: anObject fieldName: name)!

addMoneyField: name valueFrom: value disabled: disable  errors: errorsDictionary 
	^self 
		addMoneyField: name
		value: (self getValueFrom: value fieldName: name)
		disabled: disable
		errors: errorsDictionary!

addMoneyField: name valueFrom: value errors: errorsDictionary 
	^self 
		addMoneyField: name
		value: (self getValueFrom: value fieldName: name)
		errors: errorsDictionary!

addMoneyField: name valueFrom: value onChange: onChange errors: errorsDictionary 
	^self 
		addMoneyField: name
		value: (self getValueFrom: value fieldName: name)
		onChange: onChange
		errors: errorsDictionary!

addMoneyField: name valueFrom: value precision: precision errors: errorsDictionary 
	^self 
		addMoneyField: name
		value: (self getValueFrom: value fieldName: name)
		precision: precision
		errors: errorsDictionary!

addMoneyField: name valueFrom: value size: anInteger errors: errorsDictionary 
	^self 
		addMoneyField: name
		value: (self getValueFrom: value fieldName: name)
		size: anInteger
		errors: errorsDictionary!

addMoneyField: name valueFrom: value size: size precision: precision comboBoxValues: comboBoxValues errors: errorsDictionary 
	^self 
		addMoneyField: name
		value: (self getValueFrom: value fieldName: name)
		size: size
		precision: precision
		comboBoxValues: comboBoxValues
		errors: errorsDictionary!

addMoneyField: name valueFrom: value size: size precision: precision disabled: disabled errors: errorsDictionary 
	| field |
	self
		addField: ((field := HtmlTextField new)
					alignRight;
					name: name;
					autocomplete: false;
					value: ((self getValueFrom: value fieldName: name) asWebStringWithPrecision: precision);
					disabled: disabled;
					size: (size isNil ifTrue: [12] ifFalse: [size]));
		addFormFieldErrorTextFor: name from: errorsDictionary.
	^field!

addMoneyField: name valueFrom: value size: size precision: precision errors: errorsDictionary 
	^self 
		addMoneyField: name
		value: (self getValueFrom: value fieldName: name)
		size: size
		precision: precision
		errors: errorsDictionary!

addMoneyFieldWithStrictPrecision: name value: value 
	self addField: ((HtmlTextField new)
				alignRight;
				name: name;
				autocomplete: false;
				value: value asWebStringWith2OrMoreDecimals;
				size: 12)!

addMoneyFieldWithStrictPrecision: name value: value errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					alignRight;
					name: name;
					autocomplete: false;
					value: value asWebStringWith2OrMoreDecimals;
					size: 12);
		addFormFieldErrorTextFor: name from: errorsDictionary!

addMoveDownLinkTo: url 
	self
		basicAddMoveDownLinkTo: url;
		nextCell!

addMoveUpLinkTo: url 
	self
		basicAddMoveUpLinkTo: url;
		nextCell!

addNoScriptErrorText: errorMessage 
	errorMessage isNilOrEmpty 
		ifFalse: 
			[self addField: '<noscript><font class="error">' , errorMessage webTranslate , '</font></noscript>']!

addOnlyImage: imgSrc width: w height: h toolTip: toolTip linkTo: url 
	self 
		addField: '<a href="' , url , '"><img src="' , imgSrc , '" width=' , w printString 
				, ' height=' , h printString 
				, ' alt="' , toolTip webTranslate 
				, '" border=0></a>'!

addOnlyOpenLinkTo: url 
	self 
		addOnlyImage: 'images/open.gif'
		width: 15
		height: 13
		toolTip: 'asp.label.helpTip.Open'
		linkTo: url!

addOpenLinkTo: url toolTip: aString 
	self 
		addImage: 'images/open.gif'
		width: 15
		height: 13
		toolTip: aString
		linkTo: url!

addPageBreak
	self add: '<div style="PAGE-BREAK-BEFORE:always"></div>'!

addParagraph: aString 
	self
		add: '<p>';
		addText: aString;
		add: '</p>'!

addParagraph: aString fontSize: fontSize 
	self
		add: '<p><font class="fs' , fontSize printString , 'pt">';
		addText: aString asWebString webHtmlEncoded;
		add: '</font></p>'!

addParagraphWith: aBlock 
	self add: '<p>'.
	aBlock value.
	self add: '</p>'!

addPasswordField: name value: value 
	self add: (HtmlPasswordField name: name value: value)!

addPasswordField: name value: value autocomplete: aBool 
	self add: ((HtmlPasswordField name: name value: value)
				autocomplete: aBool;
				yourself)!

addPixel
	self add: '<img width="1" height="1" src="images/pixel.gif" alt="" />'!

addPixelHeight: pixelHeight 
	self 
		add: '<img width="1" height="' , pixelHeight asWebString , '" src="images/pixel.gif" alt="" />'!

addPixelWidth: pixelWidth 
	self add: '<img width="' , pixelWidth asWebString , '" height="1" src="images/pixel.gif" alt="" />'!

addPixelWidth: pixelWidth height: pixelHeight 
	pixelWidth = 1 ifTrue: [^self pixelHeight: pixelHeight].
	pixelHeight = 1 ifTrue: [^self pixelWidth: pixelWidth].
	self 
		add: '<img src="images/pixel.gif" width="' , pixelWidth asWebString , '" height="' 
				, pixelHeight asWebString , '" alt=""/>'!

addPixelWidth: pixelWidth height: pixelHeight title: aString 
	self 
		add: '<img src="images/pixel.gif" width="' , pixelWidth asWebString , '" height="' 
				, pixelHeight asWebString , '" alt="' 
				, aString asWebString webTranslate webHtmlEncodedForForm , '"/>'!

addPixelWidth: pixelWidth height: pixelHeight title: aString linkTo: url 
	self
		add: '<a href="' , url webHtmlEncodedForForm , '"><img src="images/pixel.gif" width="' 
					, pixelWidth asWebString , '" height="' 
					, pixelHeight asWebString , '" border="0" ';
		add: (Processor activeProcess webRequest isMozilla 
					ifTrue: ['title="' , aString asWebString webHtmlEncodedForForm , '" alt="']
					ifFalse: ['alt="' , aString asWebString webHtmlEncodedForForm]);
		add: '"/></a>'!

addRadioButton: name value: value checked: aBoolean 
	^self addField: (HtmlRadioButton 
				name: name
				value: value
				checked: aBoolean)!

addRadioButton: name value: value checked: aBoolean disabled: disabled 
	^self addField: ((HtmlRadioButton 
				name: name
				value: value
				checked: aBoolean)
				disabled: disabled;
				yourself)!

addRadioButton: name value: value checked: aBoolean onClick: onClickScript 
	| radio |
	radio := HtmlRadioButton 
				name: name
				value: value
				checked: aBoolean.
	onClickScript isNil ifFalse: [radio onClick: onClickScript].
	self addField: radio!

addReadOnlyCheckBox: name checked: aBoolean
	self addField: ((HtmlCheckBox 
				name: name
				value: nil
				checked: aBoolean)
				readOnly: true;
				disabled: true)!

addReadOnlyTextField: name value: value size: size
	self add: ((HtmlTextField new)
				name: name;
				value: value;
				size: size;
				readOnly: true)!

addReadOnlyTextField: name value: value size: size errors: errorsDictionary
	self
		add: ((HtmlTextField new)
					name: name;
					value: value;
					size: size;
					readOnly: true);
		addFormFieldErrorTextFor: name from: errorsDictionary!

addRedLamp
	self 
		addImage: 'images/redlamp.gif'
		width: 15
		height: 15!

addRedLampTip: aString 
	self 
		addImage: 'images/redlamp.gif'
		width: 15
		height: 15
		toolTip: aString!

addSeparator
	self add: '<hr/>'!

addSmall: anObject 
	self
		add: '<small>';
		add: anObject;
		add: '</small>'!

addSmallBoldText: aString 
	aString isNilOrEmpty 
		ifFalse: 
			[self
				add: '<small><b>';
				add: aString;
				add: '</b></small>']!

addSpanBlock: aBlock cssClass: cssClassStringOrSymbol 
	self add: '<span class="' , cssClassStringOrSymbol asString , '">'.
	aBlock value.
	self add: '</span>'!

addSubtitle: aString 
	self add: '<span class="subTitle">' , aString webTranslate , '</span><br/>'!

addSubtitleText: aString 
	self add: '<font class="subTitle">' , aString webTranslate , '</font>'!

addSuggestTextField: name value: textValue hiddenField: hiddenName value: value size: size maxLength: maxLength mandatory: mandatory comboBoxValues: comboBoxValues valueSelector: valueSelector displaySelector: displaySelector errors: errors 
	^self 
		addSuggestTextField: name
		value: textValue
		hiddenField: hiddenName
		value: value
		size: size
		maxLength: maxLength
		tabIndex: nil
		mandatory: mandatory
		comboBoxValues: comboBoxValues
		valueSelector: valueSelector
		displaySelector: displaySelector
		onChange: nil
		errors: errors!

addSuggestTextField: name value: textValue hiddenField: hiddenName value: value size: size maxLength: maxLength mandatory: mandatory comboBoxValues: comboBoxValues valueSelector: valueSelector displaySelector: displaySelector onChange: onChangeScript errors: errors 
	^self 
		addSuggestTextField: name
		value: textValue
		hiddenField: hiddenName
		value: value
		size: size
		maxLength: maxLength
		tabIndex: nil
		mandatory: mandatory
		comboBoxValues: comboBoxValues
		valueSelector: valueSelector
		displaySelector: displaySelector
		onChange: onChangeScript
		errors: errors!

addSuggestTextField: name value: textValue hiddenField: hiddenName value: value size: size maxLength: maxLength tabIndex: tabIndex mandatory: mandatory comboBoxValues: comboBoxValues valueSelector: valueSelector displaySelector: displaySelector onChange: onChangeScript errors: errors 
	^self 
		addSuggestTextField: name
		value: textValue
		hiddenField: hiddenName
		value: value
		size: size
		maxLength: maxLength
		tabIndex: tabIndex
		mandatory: mandatory
		comboBoxValues: comboBoxValues
		valueSelector: valueSelector
		displaySelector: displaySelector
		onChange: onChangeScript
		errors: errors
		alwaysShowAll: nil!

addSuggestTextField: name value: textValue hiddenField: hiddenName value: value size: size maxLength: maxLength tabIndex: tabIndex mandatory: mandatory comboBoxValues: comboBoxValues valueSelector: valueSelector displaySelector: displaySelector onChange: onChangeScript errors: errors alwaysShowAll: showAllBool 
	| field hiddenField isOpera |
	isOpera := self webRequest isOpera.
	field := (HtmlTextField new)
				name: name;
				value: textValue;
				autocomplete: false.
	size notNil ifTrue: [field size: size].
	maxLength notNil ifTrue: [field maxLength: maxLength].
	tabIndex notNil ifTrue: [field tabIndex: tabIndex].
	hiddenName isNilOrEmpty 
		ifFalse: 
			[hiddenField := (HtmlHiddenField new)
						name: hiddenName;
						value: value.
			self addField: hiddenField].
	field 
		onChange: (hiddenName isNil ifFalse: ['ITC.dom.GetElement(''' , hiddenName , ''').value='''';']) 
				asWebString , onChangeScript asWebString.
	self addField: field.
	comboBoxValues isNilOrEmpty 
		ifTrue: 
			[mandatory ifTrue: [self redStar].
			self 
				addFormFieldErrorTextFor: name
				from: errors
				break: true]
		ifFalse: 
			[| selectedFunctionName selectedValueFunctionName allValues firstTime showFunctionName listName createDropDownFunctName removeDropDownFunctName |
			selectedValueFunctionName := name , '_selectedValue'.
			selectedFunctionName := name , '_selected'.
			listName := name , '_list'.
			showFunctionName := listName , '_show'.
			createDropDownFunctName := listName , '_createDropDown'.
			removeDropDownFunctName := listName , '_removeDropDown'.
			isOpera 
				ifTrue: [field onKeyPress: name , 'OnKeyDown(event)']
				ifFalse: [field onKeyDown: name , 'OnKeyDown(event)'].
			field onBlur: name , 'OnBlur()'.
			self class == HtmlTable ifTrue: [self cellNoWrap].
			self 
				add: '<img src="images/drop_down_button.gif" alt="' 
						, 'asp.label.helpTip.ClickForOptions' webTranslate 
							, '" style="cursor:pointer;cursor:hand" onclick="' , showFunctionName 
						, '();"/>'.
			mandatory ifTrue: [self redStar].
			(self 
				addFormFieldErrorTextFor: name
				from: errors
				break: true) isNil 
				ifFalse: [self break].
			firstTime := true.
			allValues := '['.
			comboBoxValues do: 
					[:eachValue | 
					| optionValue optionDisplayString |
					(eachValue isOrPersistentObject or: [eachValue class == Association]) 
						ifTrue: 
							[optionValue := eachValue perform: (valueSelector isNil 
												ifTrue: [eachValue isOrPersistentObject ifTrue: [#id] ifFalse: [#key]]
												ifFalse: [valueSelector]).
							optionDisplayString := eachValue perform: (displaySelector isNil 
												ifTrue: [eachValue isOrPersistentObject ifTrue: [#displayString] ifFalse: [#value]]
												ifFalse: [displaySelector])]
						ifFalse: [optionValue := optionDisplayString := eachValue asWebString].
					firstTime == true ifTrue: [firstTime := false] ifFalse: [allValues := allValues , ', '].
					allValues := allValues , '[''' , optionValue asWebString trimBlanks webJavascriptStringEncoded 
								, ''', ''' , optionDisplayString trimBlanks webJavascriptStringEncoded 
								, ''']'].
			allValues := allValues , ']'.
			self 
				addJavascript: '
self.typingTimer_' , name , ' = null;

self.closing_' , name 
						, ' = false;

self.alwaysShowAll_' , name 
						, '=' , (showAllBool == true ifTrue: ['true'] ifFalse: ['false']) 
						, ';

self.previousValue_' , name 
						, ' = ''' , (textValue isNilOrEmpty ifTrue: [''] ifFalse: [textValue asWebString]) 
						, ''';

self.dropDownValues_' , name 
						, ' = ' , allValues 
						, ';
self.' , showFunctionName 
						, '=function()
{
	self.' , listName 
						, '_updateValues();


	var formValue=ITC.dom.GetElement(''' 
							, (hiddenName isNilOrEmpty ifTrue: [name] ifFalse: [hiddenName]) 
							, ''');
	if(!!formValue) return formValue;
	formValue=formValue.value;

	var listEl=ITC.dom.GetElement(''' 
							, listName 
							, ''');
	if(!!listEl) return listEl;

	listEl.focus();

	for(var i=0;i<listEl.options.length;i++)
	{
		if (listEl.options[i].value==formValue)
		{
			listEl.options[i].selected=true
		}
		else
		{
			listEl.options[i].selected=false
		}
	}
};
self.' 
							, listName 
							, '_updateValues=function() {
	var matchIndex = null;
	var exactMatch = false;
	var fieldElement = ITC.dom.GetElement(''' 
							, name , ''');

	if(!!fieldElement) return fieldElement;

	var dropDown = ITC.dom.GetElement(''' 
						, listName , ''');

	if(!!dropDown) dropDown=self.' 
						, createDropDownFunctName 
							, '();

	var regEx;

	try{regEx = new RegExp(ITC.util.EncodeForRegEx(fieldElement.value) + ''.*'', ''i'')}catch(e){};


	var values = dropDownValues_' 
							, name 
							, ';
	var match, i, options, newOption;

	options = new Array();
	if (regEx && fieldElement.value.length > 0)
	{
		for (i=0;i<values.length;i++)
		{
			match = regEx.exec(values[i][1]);
			if (self.alwaysShowAll_' 
							, name 
							, ' || ((match !!= null) && (match.index == 0)))
			{
				options[options.length] = values[i];
				matchIndex = i;
			}
		}
	}

	if (options.length == 0)
	{
		options = values;
	}
	else
	{
		if ((options.length == 1) && (options[0][1] == fieldElement.value))
		{
		exactMatch = true;
		options = values;
		}
	};

	dropDown.innerHTML = '''';
	for (i=0;i<options.length;i++)
	{
		newOption = document.createElement(''option'');
		newOption.value = options[i][0];
		newOption.text = options[i][1];
		if (exactMatch && (i == matchIndex)) newOption.selected = ''selected'';
		dropDown.options.add(newOption);
	}
};
self.' 
							, name , 'OnBlur=function()
{
	closing_' 
						, name , '=true;
	setTimeout(function() {if (closing_' 
						, name , ') self.' 
						, removeDropDownFunctName , '();}, 500);
};
self.' 
						, name 
							, 'OnKeyDown=function(pEvent)
{
	var code=ITC.event.GetCharCode(pEvent);

	switch (code)
	{	
		case 9:
		case 13:
		case 27:
				self.' 
							, removeDropDownFunctName , '();
		break;
		case 40:
				self.' 
						, showFunctionName , '();
		break;
		default:' 
						, (hiddenName isNilOrEmpty 
								ifTrue: ['']
								ifFalse: 
									['
				if (previousValue_' , name , ' !!= ITC.dom.GetElement(''' , name 
										, ''').value)
				ITC.dom.GetElement(''' , hiddenName 
										, ''').value = '''';']) 
							, '
				if (typingTimer_' , name 
						, ') clearTimeout(typingTimer_' , name 
						, ');
				typingTimer_' , name 
						, ' = setTimeout(function() {' , listName 
						, '_updateValues();}, 250);
				previousValue_' , name 
						, ' = ITC.dom.GetElement(''' , name 
						, ''').value;
		break;
	}
}
self.' , listName 
						, 'OnKeyDown=function(pEvent)
{
	var code=ITC.event.GetCharCode(pEvent);

	if (code==13 || code==9 || code==27)
	{
		self.' 
							, listName , 'OnClick();
		ITC.event.StopEvent(pEvent);
	};
};
self.' 
						, listName , 'OnBlur=function()
{
	
	if(' 
						, selectedValueFunctionName , '()!!='''')
	{
		' 
						, (hiddenName isNilOrEmpty 
								ifTrue: ['ITC.dom.GetElement(''' , name , ''').value=' , selectedFunctionName , '();']
								ifFalse: 
									['ITC.dom.GetElement(''' , name , ''').value=' , selectedValueFunctionName 
										, '();
		ITC.dom.GetElement(''' , hiddenName 
										, ''').value=' , selectedFunctionName 
										, '();']) 
							, '
	};
	self.' , removeDropDownFunctName 
						, '();
' , onChangeScript asWebString 
						, '
}; 
self.' , listName 
						, 'OnClick=function()
{
 ' , (hiddenName isNilOrEmpty 
									ifTrue: ['ITC.dom.GetElement(''' , name , ''').value=' , selectedFunctionName , '();']
									ifFalse: 
										['ITC.dom.GetElement(''' , name , ''').value=' , selectedValueFunctionName 
											, '();
	ITC.dom.GetElement(''' , hiddenName 
											, ''').value=' , selectedFunctionName 
											, '();
']) 
						, '	self.' , removeDropDownFunctName 
						, '();
	ITC.dom.GetElement(''' , name 
						, ''').focus();

	' , onChangeScript asWebString 
						, '
};
self.' , selectedFunctionName 
						, '=function()
{
	var listEl=ITC.dom.GetElement(''' , listName 
						, ''');
	for(var i=0;i<listEl.options.length;i++) if(listEl.options[i].selected) return listEl.options[i].value;
	return ''''
};
self.' 
							, selectedValueFunctionName , '=function()
{
	var listEl=ITC.dom.GetElement(''' 
						, listName 
							, ''');
	for(var i=0;i<listEl.options.length;i++) if(listEl.options[i].selected) return listEl.options[i].text;
	return ''''
};
self.' 
							, createDropDownFunctName 
							, ' = function()
{
	var rootEl, dropDownEl, tmpEl, leftPos, topPos;

	dropDownEl=ITC.dom.GetElement("' 
							, listName , '");
	if(dropDownEl) return dropDownEl;

	rootEl = ITC.dom.GetElement("' 
						, name 
							, '");

	if(!!rootEl) return rootEl;

	dropDownEl = document.createElement("select");

	dropDownEl.id="' 
							, listName , '";
	dropDownEl.name="' 
						, listName , '";
	dropDownEl.size=' 
						, ((comboBoxValues size min: 10) max: 2) printString 
							, ';

	leftPos = ITC.dom.GetElementPositionLeft(rootEl) - ITC.dom.GetElementScrollLeft(rootEl);
	topPos = ITC.dom.GetElementPositionTop(rootEl) - ITC.dom.GetElementScrollTop(rootEl) + rootEl.offsetHeight;

	document.body.appendChild(dropDownEl);

	if ((leftPos + dropDownEl.offsetWidth) > ITC.dom.GetDocumentWidth())
	{
		leftPos = ITC.dom.GetWindowWidth() - dropDownEl.offsetWidth;
		if (leftPos < 0) leftPos = 0;
	};

	if ((topPos + dropDownEl.offsetHeight) > ITC.dom.GetDocumentHeight())
	{
		topPos = ITC.dom.GetDocumentHeight() - dropDownEl.offsetHeight;
		if (topPos < 0) topPos = 0;
	};

	dropDownEl.style.left = leftPos + ''px'';
	dropDownEl.style.top =  topPos +  ''px'';
	dropDownEl.style.position="absolute";
	dropDownEl.style.zIndex="999";

	ITC.event.AddListener(''' 
							, (isOpera ifTrue: ['keypress'] ifFalse: ['keydown']) , ''', dropDownEl, function(pEvent) {self.' 
						, listName , 'OnKeyDown(pEvent)});
	ITC.event.AddListener(''blur'', dropDownEl, function() {self.' 
						, listName , 'OnBlur()});
	ITC.event.AddListener(''focus'', dropDownEl, function() {closing_' 
						, name , '=false});

	ITC.event.AddListener(''click'', dropDownEl, function() {self.' 
						, listName , 'OnClick()});
	
	return dropDownEl;
};
self.' 
						, removeDropDownFunctName 
							, ' = function()
{
	var dropDownEl;
	
	dropDownEl=ITC.dom.GetElement("' , listName 
						, '");

	if(dropDownEl) document.body.removeChild(dropDownEl);
}
'].
	^field!

addSuggestTextField: name value: textValue size: size maxLength: maxLength mandatory: mandatory comboBoxValues: comboBoxValues valueSelector: valueSelector displaySelector: displaySelector errors: errors 
	^self 
		addSuggestTextField: name
		value: textValue
		hiddenField: nil
		value: nil
		size: size
		maxLength: maxLength
		tabIndex: nil
		mandatory: mandatory
		comboBoxValues: comboBoxValues
		valueSelector: valueSelector
		displaySelector: displaySelector
		onChange: nil
		errors: errors!

addSuggestTextField: name value: textValue size: size maxLength: maxLength mandatory: mandatory comboBoxValues: comboBoxValues valueSelector: valueSelector displaySelector: displaySelector onChange: onChangeScript errors: errors 
	^self 
		addSuggestTextField: name
		value: textValue
		hiddenField: nil
		value: nil
		size: size
		maxLength: maxLength
		tabIndex: nil
		mandatory: mandatory
		comboBoxValues: comboBoxValues
		valueSelector: valueSelector
		displaySelector: displaySelector
		onChange: onChangeScript
		errors: errors!

addTableWith: text1 withBold: text2
	self add: ((HtmlTable columns: 2)
				cellPadding: 0;
				cellSpacing: 0;
				cellVerticalAlignment: 'top';
				add: text1 asHtmlString;
				space2;
				nextCell;
				cellVerticalAlignment: 'top';
				addBold: text2)!

addTableWith: text1 withBold: text2 with: text3 withBold: text4 
	self add: ((HtmlTable columns: 4)
				cellPadding: 0;
				cellSpacing: 0;
				cellVerticalAlignment: 'top';
				add: text1 asHtmlString;
				space2;
				nextCell;
				cellVerticalAlignment: 'top';
				addBold: text2 asHtmlString;
				nextCell;
				cellVerticalAlignment: 'top';
				space2;
				add: text3 asHtmlString;
				space2;
				nextCell;
				cellVerticalAlignment: 'top';
				addBold: text4 asHtmlString)!

addTableWith: text1 withBold: text2 with: text3 withBold: text4 with: text5
	self add: ((HtmlTable columns: 5)
				cellPadding: 0;
				cellSpacing: 0;
				cellVerticalAlignment: 'top';
				add: text1 asHtmlString;
				space2;
				nextCell;
				cellVerticalAlignment: 'top';
				addBold: text2 asHtmlString;
				nextCell;
				cellVerticalAlignment: 'top';
				space2;
				add: text3 asHtmlString;
				space2;
				nextCell;
				cellVerticalAlignment: 'top';
				addBold: text4 asHtmlString;
				nextCell;
				cellVerticalAlignment: 'top';
				space2;
				add: text5 asHtmlString)!

addText: aString 
	(aString isNil or: [aString = '']) ifFalse: [self add: aString]!

addText: aString fontSize: fontSize 
	self
		add: '<span style="font-size: ' , fontSize printString , 'pt;">';
		addText: aString asWebString webHtmlEncoded;
		add: '</span>'!

addText: aString withColor: colorString 
	"Adds text in color in any format (hex like #ffffff, or web based colors like 'red'...)."

	(aString isNil or: [aString = '']) 
		ifFalse: 
			[self
				add: '<font color="' , colorString , '">';
				add: aString;
				add: '</font>']!

addTextArea: fieldName maxLength: maxLength valueFrom: model width: width height: height 
	| css |
	width isNilOrEmpty ifFalse: [css := 'width:' , width asWebString , ';'].
	height isNilOrEmpty ifFalse: [css := 'height:' , height asWebString , ';'].
	^(self 
		addTextArea: fieldName
		value: (self getValueFrom: model fieldName: fieldName)
		columns: nil
		rows: nil
		maxLength: maxLength)
		cssStyle: css;
		yourself!

addTextArea: fieldName value: aString columns: nCols rows: nRows
	self add: ((HtmlTextArea new name: fieldName)
				columns: nCols rows: nRows;
				text: aString)!

addTextArea: fieldName value: aString columns: nCols rows: nRows errors: errorsDictionary 
	| field |
	self
		add: ((field := HtmlTextArea new name: fieldName)
					columns: nCols rows: nRows;
					text: aString);
		addFormFieldErrorTextFor: fieldName from: errorsDictionary.
	^field!

addTextArea: fieldName value: aString columns: nCols rows: nRows maxLength: maxLength 
	^self addField: ((HtmlTextArea new name: fieldName)
				columns: nCols rows: nRows;
				maxLength: maxLength;
				text: aString;
				yourself)!

addTextArea: fieldName valueFrom: model columns: nCols rows: nRows 
	^self 
		addTextArea: fieldName
		value: (self getValueFrom: model fieldName: fieldName)
		columns: nCols
		rows: nRows!

addTextArea: fieldName valueFrom: model columns: nCols rows: nRows errors: errorsDictionary 
	| field |
	self
		add: ((field := HtmlTextArea new name: fieldName)
					columns: nCols rows: nRows;
					text: (self getValueFrom: model fieldName: fieldName));
		addFormFieldErrorTextFor: fieldName from: errorsDictionary.
	^field!

addTextArea: fieldName valueFrom: model width: width height: height 
	^self 
		addTextArea: fieldName
		maxLength: nil
		valueFrom: model
		width: width
		height: height!

addTextField: name maxLength: maxLen valueFrom: aDictionary
	self add: ((HtmlTextField name: name valueFrom: aDictionary) maxLength: maxLen)!

addTextField: name value: value 
	^self addField: (HtmlTextField name: name value: value)!

addTextField: name value: value errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					name: name;
					value: value);
		addFormFieldErrorTextFor: name from: errorsDictionary!

addTextField: name value: textValue hiddenField: hiddenName value: value size: size maxLength: maxLength mandatory: mandatory comboBoxValues: comboBoxValues valueSelector: valueSelector displaySelector: displaySelector errors: errors 
	self class == HtmlTable ifTrue: [self cellNoWrap].
	^self 
		addTextField: name
		value: textValue
		hiddenField: hiddenName
		value: value
		size: size
		maxLength: maxLength
		tabIndex: nil
		mandatory: mandatory
		comboBoxValues: comboBoxValues
		valueSelector: valueSelector
		displaySelector: displaySelector
		onChange: nil
		errors: errors!

addTextField: name value: textValue hiddenField: hiddenName value: value size: size maxLength: maxLength mandatory: mandatory comboBoxValues: comboBoxValues valueSelector: valueSelector displaySelector: displaySelector onChange: onChangeScript errors: errors 
	^self 
		addTextField: name
		value: textValue
		hiddenField: hiddenName
		value: value
		size: size
		maxLength: maxLength
		tabIndex: nil
		mandatory: mandatory
		comboBoxValues: comboBoxValues
		valueSelector: valueSelector
		displaySelector: displaySelector
		onChange: onChangeScript
		errors: errors!

addTextField: name value: textValue hiddenField: hiddenName value: value size: size maxLength: maxLength tabIndex: tabIndex mandatory: mandatory comboBoxValues: comboBoxValues valueSelector: valueSelector displaySelector: displaySelector onChange: onChangeScript errors: errors 
	^self 
		addSuggestTextField: name
		value: textValue
		hiddenField: hiddenName
		value: value
		size: size
		maxLength: maxLength
		tabIndex: tabIndex
		mandatory: mandatory
		comboBoxValues: comboBoxValues
		valueSelector: valueSelector
		displaySelector: displaySelector
		onChange: onChangeScript
		errors: errors
		alwaysShowAll: nil!

addTextField: name value: value readOnly: readOnly
	self add: ((HtmlTextField name: name value: value) readOnly: readOnly)!

addTextField: name value: value readOnly: readOnly errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					name: name;
					readOnly: readOnly;
					value: value);
		addFormFieldErrorTextFor: name from: errorsDictionary!

addTextField: name value: value size: size 
	^self addField: ((HtmlTextField new)
				name: name;
				value: value;
				size: size)!

addTextField: name value: value size: size autocomplete: autocompleteBool 
	^self addField: ((HtmlTextField new)
				name: name;
				value: value;
				autocomplete: autocompleteBool;
				size: size)!

addTextField: name value: textValue size: size comboBoxValues: comboBoxValues errors: errors 
	self class == HtmlTable ifTrue: [self cellNoWrap].
	^self 
		addTextField: name
		value: textValue
		size: size
		maxLength: nil
		tabIndex: nil
		mandatory: false
		comboBoxValues: comboBoxValues
		onChange: nil
		errors: errors!

addTextField: name value: value size: size enabled: enabledBool 
	^self addField: ((HtmlTextField new)
				name: name;
				value: value;
				size: size;
				disabled: enabledBool not;
				yourself)!

addTextField: name value: value size: size errors: errorsDictionary 
	| f |
	self
		addField: (f := (HtmlTextField new)
							name: name;
							value: value;
							size: size);
		addFormFieldErrorTextFor: name from: errorsDictionary.
	^f!

addTextField: name value: value size: size mandatory: mandatoryBool enabled: enabledBool 
	self add: ((HtmlTextField new)
				name: name;
				value: value;
				size: size;
				disabled: enabledBool not).
	mandatoryBool = true ifTrue: [self redStar]!

addTextField: name value: value size: size mandatory: mandatoryBool enabled: enabledBool errors: errors 
	self add: ((HtmlTextField new)
				name: name;
				value: value;
				size: size;
				disabled: enabledBool not).
	mandatoryBool = true ifTrue: [self redStar].
	self addFormFieldErrorTextFor: name from: errors!

addTextField: name value: value size: size maxLength: maxLength 
	self addField: ((HtmlTextField new)
				name: name;
				value: value;
				size: size;
				maxLength: maxLength)!

addTextField: name value: value size: size maxLength: maxLength errors: errorsDictionary
	self
		addField: ((HtmlTextField new)
					name: name;
					value: value;
					size: size;
					maxLength: maxLength);
		addFormFieldErrorTextFor: name from: errorsDictionary!

addTextField: name value: value size: size maxLength: maxLength mandatory: mandatory comboBoxValues: comboBoxValues errors: errors 
	^self 
		addTextField: name
		value: value
		size: size
		maxLength: maxLength
		tabIndex: nil
		mandatory: mandatory
		comboBoxValues: comboBoxValues
		onChange: nil
		errors: errors!

addTextField: name value: value size: size maxLength: maxLength mandatory: mandatory comboBoxValues: comboBoxValues onChange: onChangeScript errors: errors 
	^self 
		addTextField: name
		value: value
		size: size
		maxLength: maxLength
		tabIndex: nil
		mandatory: mandatory
		comboBoxValues: comboBoxValues
		onChange: onChangeScript
		errors: errors!

addTextField: name value: value size: size maxLength: maxLength tabIndex: tabIndex errors: errorsDictionary
	self
		addField: ((HtmlTextField new)
					name: name;
					value: value;
					size: size;
					maxLength: maxLength;
					tabIndex: tabIndex);
		addFormFieldErrorTextFor: name from: errorsDictionary!

addTextField: name value: value size: size maxLength: maxLength tabIndex: tabIndex mandatory: mandatory comboBoxValues: comboBoxValues onChange: onChangeScript errors: errors 
	^self 
		addTextField: name
		value: value
		hiddenField: nil
		value: nil
		size: size
		maxLength: maxLength
		tabIndex: tabIndex
		mandatory: mandatory
		comboBoxValues: comboBoxValues
		valueSelector: nil
		displaySelector: nil
		onChange: onChangeScript
		errors: errors!

addTextField: name value: value size: size onBlur: onBlur errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					name: name;
					value: value;
					size: size;
					onBlur: onBlur);
		addFormFieldErrorTextFor: name from: errorsDictionary!

addTextField: name value: value size: size onChange: onChange errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					name: name;
					value: value;
					size: size;
					onChange: onChange);
		addFormFieldErrorTextFor: name from: errorsDictionary!

addTextField: name value: value size: size readOnly: readOnly 
	self add: ((HtmlTextField name: name value: value)
				size: size;
				readOnly: readOnly;
				yourself)!

addTextField: name value: value size: size tabIndex: tabIndex
	self add: ((HtmlTextField new)
				name: name;
				value: value;
				size: size;
				tabIndex: tabIndex)!

addTextField: name value: value size: size tabIndex: tabIndex errors: errorsDictionary
	self
		add: ((HtmlTextField new)
					name: name;
					value: value;
					size: size;
					tabIndex: tabIndex);
		addFormFieldErrorTextFor: name from: errorsDictionary!

addTextField: name value: value size: size withId: withId errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					name: name;
					value: value;
					elementId: (withId == true ifTrue: [name]);
					size: size);
		addFormFieldErrorTextFor: name from: errorsDictionary!

addTextField: name valueFrom: aDictionary 
	self addField: (HtmlTextField name: name valueFrom: aDictionary)!

addTextField: name valueFrom: value errors: errorsDictionary 
	^self 
		addTextField: name
		value: (self getValueFrom: value fieldName: name)
		errors: errorsDictionary!

addTextField: name valueFrom: aDictionary size: anInteger 
	| field |
	field := HtmlTextField name: name valueFrom: aDictionary.
	field size: anInteger.
	self addField: field!

addTextField: name valueFrom: value size: size enabled: enabledBool errors: errorsDictionary 
	| f |
	f := (HtmlTextField new)
				name: name;
				value: (self getValueFrom: value fieldName: name);
				disabled: enabledBool not;
				size: size.
	self
		addField: f;
		addFormFieldErrorTextFor: name from: errorsDictionary.
	^f!

addTextField: name valueFrom: value size: size errors: errorsDictionary 
	| f |
	f := (HtmlTextField new)
				name: name;
				value: (self getValueFrom: value fieldName: name);
				size: size.
	self
		addField: f;
		addFormFieldErrorTextFor: name from: errorsDictionary.
	^f!

addTextField: name valueFrom: aModel size: size maxLength: maxLength mandatory: mandatory comboBoxValues: comboBoxValues errors: errors 
	^self 
		addTextField: name
		value: (self getValueFrom: aModel fieldName: name)
		size: size
		maxLength: maxLength
		tabIndex: nil
		mandatory: mandatory
		comboBoxValues: comboBoxValues
		onChange: nil
		errors: errors!

addTextFieldWithId: name value: value size: size errors: errorsDictionary 
	self
		addField: ((HtmlTextField new)
					elementId: name;
					name: name;
					value: value;
					size: size);
		addFormFieldErrorTextFor: name from: errorsDictionary!

addTimeComboField: name value: value

	self addTimeComboField: name value: value errors: nil!

addTimeComboField: name value: value errors: errorsDictionary

	| coll t hour halfAnHour |
	coll := OrderedCollection new.
	t := Time fromSeconds: (60 * 60 * 4).
	hour := Time fromSeconds: 60 * 60.
	halfAnHour := Time fromSeconds: 30 * 60.
	3 timesRepeat: [coll add: t asShortWebString. t := t addTime: hour].
	34 timesRepeat: [coll add: t asShortWebString. t := t addTime: halfAnHour].
	self addTextField: name
		value: value asWebString
		size: 7
		maxLength: 8
		mandatory: false
		comboBoxValues: coll
		onChange: nil
		errors: errorsDictionary
!

addTimeComboField: name valueFrom: value errors: errorsDictionary 
	^self 
		addTimeComboField: name
		value: (self getValueFrom: value fieldName: name)
		errors: errorsDictionary!

addTimeField: name value: value errors: errorsDictionary

	self addTextField: name value: value asWebString size: 7 maxLength: 8 errors: errorsDictionary
!

addTimeField: name valueFrom: value errors: errorsDictionary 
	^self 
		addTimeField: name
		value: (self getValueFrom: value fieldName: name)
		errors: errorsDictionary!

addTitle: aString 
	self add: '<font class="title">' , aString webTranslate , '</font><br/>'!

addTitleText: aString 
	self add: '<font class="title">' , aString webTranslate , '</font>'!

addTranslateText: aString 
	aString isNil ifFalse: [self add: aString webTranslate]!

addWaitingActionButton: buttonName label: aString 
	| field |
	field := self 
				addField: ((HtmlButton name: 'BUTTON_' , buttonName webAsActionString label: aString webTranslate)
						pleaseWaitNotice: true;
						yourself).
	self space.
	^field!

addWarningText: errorMessage 
	errorMessage isNilOrEmpty 
		ifFalse: [self add: '<font class="warning">' , errorMessage webTranslate , '</font>']!

addYellowLamp
	self 
		addImage: 'images/yellowlamp.gif'
		width: 15
		height: 15!

addYellowLampTip: aString 
	self 
		addImage: 'images/yellowlamp.gif'
		width: 15
		height: 15
		toolTip: aString!

basicAddActionButton: buttonName label: aString 
	self add: (HtmlButton name: 'BUTTON_' , buttonName label: aString webTranslate)!

basicAddMoveDownLinkTo: url 
	self 
		addImage: 'images/downbr2.gif'
		width: 10
		height: 12
		toolTip: 'asp.label.helpTip.MoveDown'
		linkTo: url!

basicAddMoveUpLinkTo: url 
	self 
		addImage: 'images/upbr2.gif'
		width: 10
		height: 12
		toolTip: 'asp.label.helpTip.MoveUp'
		linkTo: url!

break
	self add: '<br />'!

center: aBlock 
	self add: '<center>'.
	aBlock value.
	self add: '</center>'!

contents
	contents isNil ifTrue: [contents := OrderedCollection new].
	^contents!

footer: f alignment: a showPageNumber: bool fontSize: fs 
	"Do nothing, for compatibility with RTF document."

	!

generateOn: aStream

	contents isNil
		ifFalse: [contents do: [:each | each generateOn: aStream]]!

getMaxStringSizeForObject: anObject property: aSymbol 
	"If the object in the form field is defined by the object model, then take its string size as max text field length."

	^(#OrPersistentObject itcAsClassOrNil notNil and: [anObject isOrPersistentObject]) 
		ifTrue: 
			[(anObject classDefinition getPropertyAt: aSymbol) 
				ifNotNil: [:property | (property type isKindOf: #OrTypeString itcAsClass) ifTrue: [property type maxLength]]]!

getValueFrom: aDictionaryOrObject fieldName: fieldName 
	^aDictionaryOrObject isNil 
		ifFalse: 
			[aDictionaryOrObject isDictionaryOrLookupTable 
				ifTrue: 
					[fieldName isSymbol 
						ifFalse: 
							[aDictionaryOrObject at: fieldName
								ifAbsent: [aDictionaryOrObject at: fieldName asSymbol ifAbsent: []]]
						ifTrue: 
							[aDictionaryOrObject at: fieldName
								ifAbsent: [aDictionaryOrObject at: fieldName asString ifAbsent: []]]]
				ifFalse: 
					[(aDictionaryOrObject respondsTo: fieldName asSymbol) 
						ifTrue: [aDictionaryOrObject perform: fieldName asSymbol]
						ifFalse: 
							[ItcSystemManager isRuntime 
								ifFalse: 
									[ItcSystemManager 
										logLine: aDictionaryOrObject class printString , ' missing selector ' , fieldName asString].
							(aDictionaryOrObject respondsTo: #get:) ifTrue: [aDictionaryOrObject get: fieldName asSymbol]]]]!

javascriptSink: anObject 
	javascriptSink := anObject!

labelText: aString 
	"Adds a label.
	It will use 'dgLb' class for font settings.
	It will translate aString before using it and add double colon : after the label."

	self add: '<font class="dgLb">' , aString webTranslate , '</font>'!

newDocumentSection
	"For compatibility with RTF documents"

	^self!

newLine
	self add: '<p>&nbsp;</p>'!

newTable: n 
	^(HtmlTable columns: n)
		width: '100%';
		yourself!

nextCell
	"do nothing"

	!

pageBreak
	"When generating printable HTML output, use this method for page break."

	self add: '<div style="page-break-after:always;"></div>'!

pageBreakPending
	!

redStar
	self addBold: ' <font class="note">*</font>'!

setLandscape
	"For compatibility with RTF documents"

	^self!

setPageSizeToA4
	"do nothing"

	!

setPageSizeToA4Wide
	"For compatibility with RTF documents"

	^self!

smallBreak
	self add: '<small> <br /></small>'!

smallSpace
	self add: '<small>&nbsp;</small>'!

space
	self add: '&nbsp;'!

space: numberOfSpaces 
	numberOfSpaces timesRepeat: [self add: '&nbsp;']!

space2

	self add: '&nbsp;&nbsp;'!

space3

	self add: '&nbsp;&nbsp;&nbsp;'!

space4

	self add: '&nbsp;&nbsp;&nbsp;&nbsp;'!

space5

	self add: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'!

whiteBorder: aBlock 
	self add: '<table border="0" cellpadding="5"><tr><td>'.
	aBlock value.
	self add: '</td></tr></table>'!

whiteBorderForm: action with: aBlock

	self add: '<table border="0" cellpadding="5"><tr><td><form action="', action, '" name="f" method=POST>'.
	aBlock value.
	self add: '</form></td></tr></table>'.! !
!HtmlContainer categoriesFor: #add:!public! !
!HtmlContainer categoriesFor: #add:linkTo:!public! !
!HtmlContainer categoriesFor: #add:linkTo:cssClass:!public! !
!HtmlContainer categoriesFor: #add:linkTo:openInNewWindow:!public! !
!HtmlContainer categoriesFor: #add:linkTo:style:!public! !
!HtmlContainer categoriesFor: #addActionButton:label:!public! !
!HtmlContainer categoriesFor: #addActionButton:label:accessKey:!public! !
!HtmlContainer categoriesFor: #addActionButton:label:disabled:!public! !
!HtmlContainer categoriesFor: #addActionButton:label:id:!public! !
!HtmlContainer categoriesFor: #addActionButton:label:id:disabled:!public! !
!HtmlContainer categoriesFor: #addActionButton:label:showFlag:!public! !
!HtmlContainer categoriesFor: #addActionLink:onClick:!public! !
!HtmlContainer categoriesFor: #addActionLink:url:!public! !
!HtmlContainer categoriesFor: #addActionLinkForCollapse:onClick:!public! !
!HtmlContainer categoriesFor: #addActionLinkForCollapse:url:!public! !
!HtmlContainer categoriesFor: #addAjaxLoadingIndicatorImage!public! !
!HtmlContainer categoriesFor: #addAutoDropDownList:items:displaySelector:valueSelector:value:!public! !
!HtmlContainer categoriesFor: #addAutoDropDownList:itemsWithNil:displaySelector:valueSelector:value:!public! !
!HtmlContainer categoriesFor: #addAutoDropDownListItemsWithNilFrom:class:property:valueFrom:!public! !
!HtmlContainer categoriesFor: #addAutoDropDownListItemsWithNilFrom:class:property:valueFrom:fieldName:!public! !
!HtmlContainer categoriesFor: #addBigBoldText:!public! !
!HtmlContainer categoriesFor: #addBlueLamp!public! !
!HtmlContainer categoriesFor: #addBlueLampTip:!public! !
!HtmlContainer categoriesFor: #addBold:!public! !
!HtmlContainer categoriesFor: #addBold:linkTo:!public! !
!HtmlContainer categoriesFor: #addBold:withColor:!public! !
!HtmlContainer categoriesFor: #addBoldText:!public! !
!HtmlContainer categoriesFor: #addBoldText:fontSize:!public! !
!HtmlContainer categoriesFor: #addBooleanField:value:!public! !
!HtmlContainer categoriesFor: #addBooleanField:value:disabled:!public! !
!HtmlContainer categoriesFor: #addBooleanField:value:onClick:!public! !
!HtmlContainer categoriesFor: #addBooleanField:valueFrom:!public! !
!HtmlContainer categoriesFor: #addButton:label:!public! !
!HtmlContainer categoriesFor: #addButton:label:onClick:!public! !
!HtmlContainer categoriesFor: #addButton:label:onClick:disabled:!public! !
!HtmlContainer categoriesFor: #addCaseFunctionFor:named:!public! !
!HtmlContainer categoriesFor: #addCenteredTitle:!public! !
!HtmlContainer categoriesFor: #addCenteredTitle:fontSize:!public! !
!HtmlContainer categoriesFor: #addCheckBox:checked:!public! !
!HtmlContainer categoriesFor: #addCheckBox:checked:onClick:!public! !
!HtmlContainer categoriesFor: #addCheckBox:value:checked:!public! !
!HtmlContainer categoriesFor: #addCheckBox:value:checked:disabled:!public! !
!HtmlContainer categoriesFor: #addCheckBox:value:checked:onClick:!public! !
!HtmlContainer categoriesFor: #addCheckBox:value:checked:onClickToggle:!public! !
!HtmlContainer categoriesFor: #addConfirmDeleteLinkTo:confirmationString:!public! !
!HtmlContainer categoriesFor: #addConfirmDeleteLinkTo:confirmationString:enabled:!public! !
!HtmlContainer categoriesFor: #addCopyLinkTo:!public! !
!HtmlContainer categoriesFor: #addDate:!public! !
!HtmlContainer categoriesFor: #addDateField:value:!date field!public! !
!HtmlContainer categoriesFor: #addDateField:value:baseDate:!date field!public! !
!HtmlContainer categoriesFor: #addDateField:value:baseDate:hideFields:!date field!public! !
!HtmlContainer categoriesFor: #addDateField:value:baseDate:hideFields:errors:!date field!public! !
!HtmlContainer categoriesFor: #addDateField:value:baseDate:onChange:!public! !
!HtmlContainer categoriesFor: #addDateField:value:errors:!date field!public! !
!HtmlContainer categoriesFor: #addDateField:value:floatCalendar:!date field!public! !
!HtmlContainer categoriesFor: #addDateField:value:hideFields:!date field!public! !
!HtmlContainer categoriesFor: #addDateField:value:hideFields:errors:!date field!public! !
!HtmlContainer categoriesFor: #addDateField:value:mandatory:baseDate:onChange:errors:!date field!public! !
!HtmlContainer categoriesFor: #addDateField:value:mandatory:baseDate:onChange:hideFields:errors:!date field!public! !
!HtmlContainer categoriesFor: #addDateField:value:tabIndex:mandatory:baseDate:onChange:errors:!date field!public! !
!HtmlContainer categoriesFor: #addDateField:value:tabIndex:mandatory:baseDate:onChange:floatCalendar:errors:!date field!public! !
!HtmlContainer categoriesFor: #addDateField:valueFrom:!date field!public! !
!HtmlContainer categoriesFor: #addDateField:valueFrom:errors:!date field!public! !
!HtmlContainer categoriesFor: #addDateField:valueFrom:hideFields:errors:!date field!public! !
!HtmlContainer categoriesFor: #addDateOrDash:!public! !
!HtmlContainer categoriesFor: #addDaysField:value:fromDateField:untilDateField:value:mandatory:baseDate:errors:!public! !
!HtmlContainer categoriesFor: #addDaysField:value:fromDateField:untilDateField:value:mandatory:baseDate:hideFields:errors:!public! !
!HtmlContainer categoriesFor: #addDeleteAjaxLinkTo:!public! !
!HtmlContainer categoriesFor: #addDeleteAjaxLinkTo:enabled:!public! !
!HtmlContainer categoriesFor: #addDeleteLinkTo:!public! !
!HtmlContainer categoriesFor: #addDisabledMoneyField:value:!public! !
!HtmlContainer categoriesFor: #addDisabledMoneyField:value:size:!public! !
!HtmlContainer categoriesFor: #addDisabledTextField:value:size:!public! !
!HtmlContainer categoriesFor: #addDisabledTextField:value:size:errors:!public! !
!HtmlContainer categoriesFor: #addDiv:id:style:!public! !
!HtmlContainer categoriesFor: #addDivBlock:cssClass:!public! !
!HtmlContainer categoriesFor: #addDivBlock:id:!public! !
!HtmlContainer categoriesFor: #addDivBlock:id:cssClass:!public! !
!HtmlContainer categoriesFor: #addDivBlock:id:cssClass:style:!public! !
!HtmlContainer categoriesFor: #addDivBlock:id:style:!public! !
!HtmlContainer categoriesFor: #addDivBlock:style:!public! !
!HtmlContainer categoriesFor: #addDropDownList:items:displaySelector:valueSelector:value:!public! !
!HtmlContainer categoriesFor: #addDropDownList:items:displaySelector:valueSelector:value:cssStyle:onChange:!public! !
!HtmlContainer categoriesFor: #addDropDownList:items:displaySelector:valueSelector:value:onChange:!public! !
!HtmlContainer categoriesFor: #addDropDownList:items:displaySelector:valueSelector:value:width:!public! !
!HtmlContainer categoriesFor: #addDropDownList:items:displaySelector:valueSelector:value:widthPt:!public! !
!HtmlContainer categoriesFor: #addDropDownList:items:displaySelector:valueSelector:valueFrom:!public! !
!HtmlContainer categoriesFor: #addDropDownList:items:displaySelector:valueSelector:valueFrom:tabIndex:!public! !
!HtmlContainer categoriesFor: #addDropDownList:items:valueFrom:!public! !
!HtmlContainer categoriesFor: #addDropDownList:itemsWithNil:displaySelector:valueSelector:value:!public! !
!HtmlContainer categoriesFor: #addDropDownList:itemsWithNil:displaySelector:valueSelector:value:disabled:!public! !
!HtmlContainer categoriesFor: #addDropDownList:itemsWithNil:displaySelector:valueSelector:value:onChange:!public! !
!HtmlContainer categoriesFor: #addDropDownList:itemsWithNil:displaySelector:valueSelector:value:onChange:disabled:!public! !
!HtmlContainer categoriesFor: #addDropDownList:itemsWithNil:displaySelector:valueSelector:value:widthPt:!public! !
!HtmlContainer categoriesFor: #addDropDownList:itemsWithNil:displaySelector:valueSelector:valueFrom:!public! !
!HtmlContainer categoriesFor: #addDropDownList:itemsWithNil:valueFrom:!public! !
!HtmlContainer categoriesFor: #addDropDownListItemsFrom:class:property:value:!public! !
!HtmlContainer categoriesFor: #addDropDownListItemsFrom:class:property:value:fieldName:!public! !
!HtmlContainer categoriesFor: #addDropDownListItemsFrom:class:property:valueFrom:!public! !
!HtmlContainer categoriesFor: #addDropDownListItemsFrom:class:property:valueFrom:disabled:!public! !
!HtmlContainer categoriesFor: #addDropDownListItemsFrom:class:property:valueFrom:fieldName:!public! !
!HtmlContainer categoriesFor: #addDropDownListItemsFrom:class:property:valueFrom:fieldName:disabled:!public! !
!HtmlContainer categoriesFor: #addDropDownListItemsFrom:class:property:valueFrom:fieldName:onChange:!public! !
!HtmlContainer categoriesFor: #addDropDownListItemsFrom:class:property:valueFrom:fieldName:widthPt:!public! !
!HtmlContainer categoriesFor: #addDropDownListItemsFrom:class:property:valueFrom:onChange:!public! !
!HtmlContainer categoriesFor: #addDropDownListItemsFrom:class:property:valueFrom:widthPt:!public! !
!HtmlContainer categoriesFor: #addDropDownListItemsWithNilFrom:class:property:value:!public! !
!HtmlContainer categoriesFor: #addDropDownListItemsWithNilFrom:class:property:value:fieldName:!public! !
!HtmlContainer categoriesFor: #addDropDownListItemsWithNilFrom:class:property:valueFrom:!public! !
!HtmlContainer categoriesFor: #addDropDownListItemsWithNilFrom:class:property:valueFrom:fieldName:onChange:!public! !
!HtmlContainer categoriesFor: #addDropDownListItemsWithNilFrom:class:property:valueFrom:onChange:!public! !
!HtmlContainer categoriesFor: #addEditLinkTo:!public! !
!HtmlContainer categoriesFor: #addEmailData:!public! !
!HtmlContainer categoriesFor: #addEmptyStringCaseFunctionFor:named:!public! !
!HtmlContainer categoriesFor: #addErrorText:!public! !
!HtmlContainer categoriesFor: #addErrorTextInBrackets:!public! !
!HtmlContainer categoriesFor: #addField:!public! !
!HtmlContainer categoriesFor: #addFileField:errors:!public! !
!HtmlContainer categoriesFor: #addFormFieldErrorTextFor:from:!public! !
!HtmlContainer categoriesFor: #addFormFieldErrorTextFor:from:break:!public! !
!HtmlContainer categoriesFor: #addFormFieldWarningTextFor:from:!public! !
!HtmlContainer categoriesFor: #addFormFieldWarningTextFor:from:break:!public! !
!HtmlContainer categoriesFor: #addGreenLamp!public! !
!HtmlContainer categoriesFor: #addGreenLampTip:!public! !
!HtmlContainer categoriesFor: #addH1:!public! !
!HtmlContainer categoriesFor: #addHelp2ImageLinkInNewWindowTo:!public! !
!HtmlContainer categoriesFor: #addHelp2ImageLinkTo:!public! !
!HtmlContainer categoriesFor: #addHiddenDefaultButton:!public! !
!HtmlContainer categoriesFor: #addHiddenField:value:!public! !
!HtmlContainer categoriesFor: #addHiddenField:valueFrom:!public! !
!HtmlContainer categoriesFor: #addHintBoxWithText:!public! !
!HtmlContainer categoriesFor: #addHtmlEditor:value:!date field!public! !
!HtmlContainer categoriesFor: #addHtmlEditor:value:columns:rows:!date field!public! !
!HtmlContainer categoriesFor: #addHtmlEditor:value:columns:rows:errors:!date field!public! !
!HtmlContainer categoriesFor: #addHtmlEditor:value:width:height:!date field!public! !
!HtmlContainer categoriesFor: #addHtmlEditor:value:width:height:expandedToolbar:!date field!public! !
!HtmlContainer categoriesFor: #addHtmlEditor:value:width:height:expandedToolbar:editorAreaCSS:linkBrowserUrl:imageBrowserUrl:imageUploadUrl:!date field!public! !
!HtmlContainer categoriesFor: #addHtmlEditor:valueFrom:errors:!date field!public! !
!HtmlContainer categoriesFor: #addHtmlEditor:valueFrom:width:height:expandedToolbar:errors:!date field!public! !
!HtmlContainer categoriesFor: #addImage:!public! !
!HtmlContainer categoriesFor: #addImage:width:height:!public! !
!HtmlContainer categoriesFor: #addImage:width:height:onClick:!public! !
!HtmlContainer categoriesFor: #addImage:width:height:onClick:cssStyle:!public! !
!HtmlContainer categoriesFor: #addImage:width:height:toolTip:!public! !
!HtmlContainer categoriesFor: #addImage:width:height:toolTip:linkTo:!public! !
!HtmlContainer categoriesFor: #addImage:width:height:toolTip:linkTo:target:!public! !
!HtmlContainer categoriesFor: #addImage:width:height:toolTip:onClick:!public! !
!HtmlContainer categoriesFor: #addImage:width:height:toolTip:onClick:style:!public! !
!HtmlContainer categoriesFor: #addImageButton:width:height:toolTip:accessKey:action:onClick:!public! !
!HtmlContainer categoriesFor: #addImageButton:width:height:toolTip:accessKey:onClick:!public! !
!HtmlContainer categoriesFor: #addImageButton:width:height:toolTip:action:!public! !
!HtmlContainer categoriesFor: #addImageButtonFindForAction:toolTip:accessKey:!public! !
!HtmlContainer categoriesFor: #addImageButtonFindForAction:toolTip:onClick:!public! !
!HtmlContainer categoriesFor: #addImageButtonFindOnClick:toolTip:accessKey:!public! !
!HtmlContainer categoriesFor: #addImageHtml:!public! !
!HtmlContainer categoriesFor: #addInlineEditable:for:selector:!public! !
!HtmlContainer categoriesFor: #addInlineEditableData:for:selector:!public! !
!HtmlContainer categoriesFor: #addInlineEditableDivContentForLongText:for:selector:!public! !
!HtmlContainer categoriesFor: #addInlineEditableForLongText:for:selector:!public! !
!HtmlContainer categoriesFor: #addJavascript:!public! !
!HtmlContainer categoriesFor: #addLabel:!public! !
!HtmlContainer categoriesFor: #addLabel:data:!public! !
!HtmlContainer categoriesFor: #addLabel:data:linkTo:!public! !
!HtmlContainer categoriesFor: #addLabelForOptionalZipAndCityField:zipCode:city:errors:!public! !
!HtmlContainer categoriesFor: #addLabelForZipAndCityField:zipCode:city:errors:!public! !
!HtmlContainer categoriesFor: #addLabelForZipAndCityField:zipCode:city:zipField:cityField:mandatory:disabled:errors:!public! !
!HtmlContainer categoriesFor: #addLabelForZipAndCityField:zipCode:city:zipField:cityField:mandatory:disabled:errors:zipCodeFieldStyle:cityFieldStyle:!public! !
!HtmlContainer categoriesFor: #addLabelForZipAndCityField:zipCode:city:zipField:cityField:mandatory:errors:!public! !
!HtmlContainer categoriesFor: #addLabelText:!public! !
!HtmlContainer categoriesFor: #addMandatoryDateField:value:!public! !
!HtmlContainer categoriesFor: #addMandatoryDateField:value:baseDate:!public! !
!HtmlContainer categoriesFor: #addMandatoryDateField:value:baseDate:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryDateField:value:baseDate:hideFields:!public! !
!HtmlContainer categoriesFor: #addMandatoryDateField:value:baseDate:hideFields:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryDateField:value:baseDate:onChange:!public! !
!HtmlContainer categoriesFor: #addMandatoryDateField:value:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryDateField:value:errors:onChange:!public! !
!HtmlContainer categoriesFor: #addMandatoryDateField:value:hideFields:!public! !
!HtmlContainer categoriesFor: #addMandatoryDateField:value:hideFields:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryDateField:valueFrom:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryDateField:valueFrom:errors:onChange:!public! !
!HtmlContainer categoriesFor: #addMandatoryDateField:valueFrom:hideFields:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryDisabledTextField:value:size:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryMoneyField:value:comboBoxValues:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryMoneyField:value:disabled:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryMoneyField:value:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryMoneyField:value:precision:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryMoneyField:value:tabIndex:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryMoneyField:valueFrom:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryMoneyField:valueFrom:precision:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryReadOnlyTextField:value:size:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryTextArea:value:columns:rows:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryTextArea:valueFrom:columns:rows:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryTextField:value:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryTextField:value:readOnly:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryTextField:value:size:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryTextField:value:size:maxLength:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryTextField:value:size:maxLength:tabIndex:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryTextField:value:size:onBlur:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryTextField:value:size:onChange:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryTextField:value:size:tabIndex:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryTextField:valueFrom:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryTextField:valueFrom:size:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryTimeComboField:value:errors:!public! !
!HtmlContainer categoriesFor: #addMandatoryTimeField:value:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:comboBoxValues:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:disabled:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:onChange:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:precision:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:readOnly:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:size:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:size:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:size:precision:comboBoxValues:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:size:precision:disabled:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:size:precision:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:size:precision:onBlur:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:size:precision:onChange:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:size:precision:onChange:onFocus:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:size:readOnly:!public! !
!HtmlContainer categoriesFor: #addMoneyField:value:tabIndex:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:valueFrom:!public! !
!HtmlContainer categoriesFor: #addMoneyField:valueFrom:disabled:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:valueFrom:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:valueFrom:onChange:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:valueFrom:precision:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:valueFrom:size:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:valueFrom:size:precision:comboBoxValues:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:valueFrom:size:precision:disabled:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyField:valueFrom:size:precision:errors:!public! !
!HtmlContainer categoriesFor: #addMoneyFieldWithStrictPrecision:value:!public! !
!HtmlContainer categoriesFor: #addMoneyFieldWithStrictPrecision:value:errors:!public! !
!HtmlContainer categoriesFor: #addMoveDownLinkTo:!public! !
!HtmlContainer categoriesFor: #addMoveUpLinkTo:!public! !
!HtmlContainer categoriesFor: #addNoScriptErrorText:!public! !
!HtmlContainer categoriesFor: #addOnlyImage:width:height:toolTip:linkTo:!public! !
!HtmlContainer categoriesFor: #addOnlyOpenLinkTo:!public! !
!HtmlContainer categoriesFor: #addOpenLinkTo:toolTip:!public! !
!HtmlContainer categoriesFor: #addPageBreak!public! !
!HtmlContainer categoriesFor: #addParagraph:!public! !
!HtmlContainer categoriesFor: #addParagraph:fontSize:!public! !
!HtmlContainer categoriesFor: #addParagraphWith:!public! !
!HtmlContainer categoriesFor: #addPasswordField:value:!public! !
!HtmlContainer categoriesFor: #addPasswordField:value:autocomplete:!public! !
!HtmlContainer categoriesFor: #addPixel!public! !
!HtmlContainer categoriesFor: #addPixelHeight:!public! !
!HtmlContainer categoriesFor: #addPixelWidth:!public! !
!HtmlContainer categoriesFor: #addPixelWidth:height:!public! !
!HtmlContainer categoriesFor: #addPixelWidth:height:title:!public! !
!HtmlContainer categoriesFor: #addPixelWidth:height:title:linkTo:!public! !
!HtmlContainer categoriesFor: #addRadioButton:value:checked:!public! !
!HtmlContainer categoriesFor: #addRadioButton:value:checked:disabled:!public! !
!HtmlContainer categoriesFor: #addRadioButton:value:checked:onClick:!public! !
!HtmlContainer categoriesFor: #addReadOnlyCheckBox:checked:!public! !
!HtmlContainer categoriesFor: #addReadOnlyTextField:value:size:!public! !
!HtmlContainer categoriesFor: #addReadOnlyTextField:value:size:errors:!public! !
!HtmlContainer categoriesFor: #addRedLamp!public! !
!HtmlContainer categoriesFor: #addRedLampTip:!public! !
!HtmlContainer categoriesFor: #addSeparator!public! !
!HtmlContainer categoriesFor: #addSmall:!public! !
!HtmlContainer categoriesFor: #addSmallBoldText:!public! !
!HtmlContainer categoriesFor: #addSpanBlock:cssClass:!public! !
!HtmlContainer categoriesFor: #addSubtitle:!public! !
!HtmlContainer categoriesFor: #addSubtitleText:!public! !
!HtmlContainer categoriesFor: #addSuggestTextField:value:hiddenField:value:size:maxLength:mandatory:comboBoxValues:valueSelector:displaySelector:errors:!public! !
!HtmlContainer categoriesFor: #addSuggestTextField:value:hiddenField:value:size:maxLength:mandatory:comboBoxValues:valueSelector:displaySelector:onChange:errors:!public! !
!HtmlContainer categoriesFor: #addSuggestTextField:value:hiddenField:value:size:maxLength:tabIndex:mandatory:comboBoxValues:valueSelector:displaySelector:onChange:errors:!public! !
!HtmlContainer categoriesFor: #addSuggestTextField:value:hiddenField:value:size:maxLength:tabIndex:mandatory:comboBoxValues:valueSelector:displaySelector:onChange:errors:alwaysShowAll:!public! !
!HtmlContainer categoriesFor: #addSuggestTextField:value:size:maxLength:mandatory:comboBoxValues:valueSelector:displaySelector:errors:!public! !
!HtmlContainer categoriesFor: #addSuggestTextField:value:size:maxLength:mandatory:comboBoxValues:valueSelector:displaySelector:onChange:errors:!public! !
!HtmlContainer categoriesFor: #addTableWith:withBold:!public! !
!HtmlContainer categoriesFor: #addTableWith:withBold:with:withBold:!public! !
!HtmlContainer categoriesFor: #addTableWith:withBold:with:withBold:with:!public! !
!HtmlContainer categoriesFor: #addText:!public! !
!HtmlContainer categoriesFor: #addText:fontSize:!public! !
!HtmlContainer categoriesFor: #addText:withColor:!public! !
!HtmlContainer categoriesFor: #addTextArea:maxLength:valueFrom:width:height:!public! !
!HtmlContainer categoriesFor: #addTextArea:value:columns:rows:!public! !
!HtmlContainer categoriesFor: #addTextArea:value:columns:rows:errors:!public! !
!HtmlContainer categoriesFor: #addTextArea:value:columns:rows:maxLength:!public! !
!HtmlContainer categoriesFor: #addTextArea:valueFrom:columns:rows:!public! !
!HtmlContainer categoriesFor: #addTextArea:valueFrom:columns:rows:errors:!public! !
!HtmlContainer categoriesFor: #addTextArea:valueFrom:width:height:!public! !
!HtmlContainer categoriesFor: #addTextField:maxLength:valueFrom:!public! !
!HtmlContainer categoriesFor: #addTextField:value:!public! !
!HtmlContainer categoriesFor: #addTextField:value:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:hiddenField:value:size:maxLength:mandatory:comboBoxValues:valueSelector:displaySelector:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:hiddenField:value:size:maxLength:mandatory:comboBoxValues:valueSelector:displaySelector:onChange:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:hiddenField:value:size:maxLength:tabIndex:mandatory:comboBoxValues:valueSelector:displaySelector:onChange:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:readOnly:!public! !
!HtmlContainer categoriesFor: #addTextField:value:readOnly:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:autocomplete:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:comboBoxValues:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:enabled:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:mandatory:enabled:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:mandatory:enabled:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:maxLength:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:maxLength:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:maxLength:mandatory:comboBoxValues:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:maxLength:mandatory:comboBoxValues:onChange:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:maxLength:tabIndex:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:maxLength:tabIndex:mandatory:comboBoxValues:onChange:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:onBlur:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:onChange:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:readOnly:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:tabIndex:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:tabIndex:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:value:size:withId:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:valueFrom:!public! !
!HtmlContainer categoriesFor: #addTextField:valueFrom:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:valueFrom:size:!public! !
!HtmlContainer categoriesFor: #addTextField:valueFrom:size:enabled:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:valueFrom:size:errors:!public! !
!HtmlContainer categoriesFor: #addTextField:valueFrom:size:maxLength:mandatory:comboBoxValues:errors:!public! !
!HtmlContainer categoriesFor: #addTextFieldWithId:value:size:errors:!public! !
!HtmlContainer categoriesFor: #addTimeComboField:value:!public! !
!HtmlContainer categoriesFor: #addTimeComboField:value:errors:!public! !
!HtmlContainer categoriesFor: #addTimeComboField:valueFrom:errors:!public! !
!HtmlContainer categoriesFor: #addTimeField:value:errors:!public! !
!HtmlContainer categoriesFor: #addTimeField:valueFrom:errors:!public! !
!HtmlContainer categoriesFor: #addTitle:!public! !
!HtmlContainer categoriesFor: #addTitleText:!public! !
!HtmlContainer categoriesFor: #addTranslateText:!public! !
!HtmlContainer categoriesFor: #addWaitingActionButton:label:!public! !
!HtmlContainer categoriesFor: #addWarningText:!public! !
!HtmlContainer categoriesFor: #addYellowLamp!public! !
!HtmlContainer categoriesFor: #addYellowLampTip:!public! !
!HtmlContainer categoriesFor: #basicAddActionButton:label:!public! !
!HtmlContainer categoriesFor: #basicAddMoveDownLinkTo:!public! !
!HtmlContainer categoriesFor: #basicAddMoveUpLinkTo:!public! !
!HtmlContainer categoriesFor: #break!public! !
!HtmlContainer categoriesFor: #center:!public! !
!HtmlContainer categoriesFor: #contents!public! !
!HtmlContainer categoriesFor: #footer:alignment:showPageNumber:fontSize:!document generation!public! !
!HtmlContainer categoriesFor: #generateOn:!public! !
!HtmlContainer categoriesFor: #getMaxStringSizeForObject:property:!private! !
!HtmlContainer categoriesFor: #getValueFrom:fieldName:!private! !
!HtmlContainer categoriesFor: #javascriptSink:!public! !
!HtmlContainer categoriesFor: #labelText:!public! !
!HtmlContainer categoriesFor: #newDocumentSection!document generation!public! !
!HtmlContainer categoriesFor: #newLine!public! !
!HtmlContainer categoriesFor: #newTable:!public! !
!HtmlContainer categoriesFor: #nextCell!public! !
!HtmlContainer categoriesFor: #pageBreak!public! !
!HtmlContainer categoriesFor: #pageBreakPending!public! !
!HtmlContainer categoriesFor: #redStar!public! !
!HtmlContainer categoriesFor: #setLandscape!document generation!public! !
!HtmlContainer categoriesFor: #setPageSizeToA4!accessing!document generation!public! !
!HtmlContainer categoriesFor: #setPageSizeToA4Wide!document generation!public! !
!HtmlContainer categoriesFor: #smallBreak!public! !
!HtmlContainer categoriesFor: #smallSpace!public! !
!HtmlContainer categoriesFor: #space!public! !
!HtmlContainer categoriesFor: #space:!public! !
!HtmlContainer categoriesFor: #space2!public! !
!HtmlContainer categoriesFor: #space3!public! !
!HtmlContainer categoriesFor: #space4!public! !
!HtmlContainer categoriesFor: #space5!public! !
!HtmlContainer categoriesFor: #whiteBorder:!public! !
!HtmlContainer categoriesFor: #whiteBorderForm:with:!public! !

