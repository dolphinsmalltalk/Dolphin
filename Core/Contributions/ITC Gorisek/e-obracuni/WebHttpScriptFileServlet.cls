"Filed out from Dolphin Smalltalk X6.1"!

WebHttpFileServlet subclass: #WebHttpScriptFileServlet
	instanceVariableNames: 'cache cacheMutex servletName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpScriptFileServlet guid: (GUID fromString: '{AC1BA8FA-CC12-403A-A1A0-AFB64699594E}')!
WebHttpScriptFileServlet comment: ''!
!WebHttpScriptFileServlet categoriesForClass!Unclassified! !
!WebHttpScriptFileServlet methodsFor!

cache
	^cache!

cacheAt: aKey 
	| result |
	cacheMutex critical: [result := cache at: aKey ifAbsent: []].
	^result!

cacheAt: aKey put: anObject 
	cacheMutex critical: [cache at: aKey put: anObject]!

clearCache
	cacheMutex critical: [cache := IdentityDictionary new]!

createTimestampWithContents: aString 
	^Array with: Timestamp now
		with: (self doMinify ifTrue: [JavaScriptMinifier minify: aString] ifFalse: [aString])!

doMinify
	^ItcSystemManager isRuntime!

extractFilenameFrom: request 
	| path end prefix |
	prefix := '/' , self urlPrefix , '/'.
	(path := request header url) isNil ifTrue: [^nil].
	(end := path indexOf: $?) = 0 ifFalse: [path := path copyFrom: 1 to: end - 1].
	path := path webHttpUrlDecodePathComponent.
	path size <= prefix size ifTrue: [^nil].
	path := path copyFrom: prefix size + 1.
	(end := path lastIndexOf: $.) = 0 ifFalse: [path := path copyFrom: 1 to: end - 1].
	^path asSymbol!

initialize
	super initialize.
	servletName := self servletNamePrefix , '_' 
				, (application currentReleaseId copy replaceAll: $. with: $_).
	cacheMutex := Semaphore forMutualExclusion.
	cache := IdentityDictionary new!

itcExtScripts
	^#('Namespace' 'FormStore' 'GridView' 'RowSelectionModel' 'ComboBox' 'DateField' 'SuggestField' 'NumberField')!

itcScripts
	^#('ItcNamespace' 'ItcUtil' 'ItcEvent' 'ItcDom' 'ItcCss' 'ItcAjax' 'ItcLegacy')!

itcWidgetScripts
	^#('Calendar' 'TypingSuggest' 'EditableDropDown' 'WebConsole' 'WaitClock' 'MainMenu' 'MainMenuBar' 'HideableContainer' 'DropDownSuggest' 'CheckBoxTree' 'DialogBox' 'SessionRefresher')!

javascriptItc
	| array ws selector |
	(array := self cacheAt: #itc) isNil 
		ifTrue: 
			[ws := WriteStream on: String new.
			self itcScripts do: 
					[:each | 
					selector := ('javascriptPrivate' , each) asSymbol.
					(self class respondsTo: selector) ifTrue: [ws nextPutAll: (self class perform: selector)]].
			array := self createTimestampWithContents: ws contents.
			self cacheAt: #itc put: array].
	^array!

javascriptItcExt
	| array ws selector |
	(array := self cacheAt: #itcExt) isNil 
		ifTrue: 
			[ws := WriteStream on: String new.
			self itcExtScripts do: 
					[:each | 
					selector := ('javascriptPrivateItcExt' , each) asSymbol.
					(self class respondsTo: selector) ifTrue: [ws nextPutAll: (self class perform: selector)]].
			array := self createTimestampWithContents: ws contents.
			self cacheAt: #itcExt put: array].
	^array!

javascriptItcExtLocalizationBosnian
	^self javascriptItcExtLocalizationFor: 'Bosnian'!

javascriptItcExtLocalizationCroatian
	^self javascriptItcExtLocalizationFor: 'Croatian'!

javascriptItcExtLocalizationCzech
	^self javascriptItcExtLocalizationFor: 'Czech'!

javascriptItcExtLocalizationEnglish
	^self javascriptItcExtLocalizationFor: 'English'!

javascriptItcExtLocalizationFor: aString 
	| result key |
	key := ('javascriptItcExtLocalization' , aString) asSymbol.
	(result := self cacheAt: key) isNil 
		ifTrue: 
			[| selector |
			selector := ('javascriptPrivateItcExtLocalization' , aString) asSymbol.
			(self class respondsTo: selector) 
				ifTrue: 
					[result := self createTimestampWithContents: (self class perform: selector).
					self cacheAt: key put: result]
				ifFalse: 
					[ItcSystemManager 
						logLineWithTsAndSession: 'Ext localization for ' , selector printString , ' is not defined']].
	^result!

javascriptItcExtLocalizationGerman
	^self javascriptItcExtLocalizationFor: 'German'!

javascriptItcExtLocalizationRussian
	^self javascriptItcExtLocalizationFor: 'Russian'!

javascriptItcExtLocalizationSerbian
	^self javascriptItcExtLocalizationFor: 'Serbian'!

javascriptItcExtLocalizationSlovene
	^self javascriptItcExtLocalizationFor: 'Slovene'!

javascriptItcExtTranslationBosnian
	^self javascriptItcExtTranslationFor: 'Bosnian'!

javascriptItcExtTranslationCroatian
	^self javascriptItcExtTranslationFor: 'Croatian'!

javascriptItcExtTranslationCzech
	^self javascriptItcExtTranslationFor: 'Czech'!

javascriptItcExtTranslationEnglish
	^self javascriptItcExtTranslationFor: 'English'!

javascriptItcExtTranslationFor: aString 
	| result key |
	key := ('javascriptItcExtTranslation' , aString) asSymbol.
	(result := self cacheAt: key) isNil 
		ifTrue: 
			[Processor activeProcess language: aString.
			result := self createTimestampWithContents: self class javascriptPrivateItcExtTranslation.
			self cacheAt: key put: result].
	^result!

javascriptItcExtTranslationGerman
	^self javascriptItcExtTranslationFor: 'German'!

javascriptItcExtTranslationRussian
	^self javascriptItcExtTranslationFor: 'Russian'!

javascriptItcExtTranslationSerbian
	^self javascriptItcExtTranslationFor: 'Serbian'!

javascriptItcExtTranslationSlovene
	^self javascriptItcExtTranslationFor: 'Slovene'!

javascriptItcLocalizationBosnian
	^self javascriptItcLocalizationFor: 'Bosnian'!

javascriptItcLocalizationCroatian
	^self javascriptItcLocalizationFor: 'Croatian'!

javascriptItcLocalizationCzech
	^self javascriptItcLocalizationFor: 'Czech'!

javascriptItcLocalizationEnglish
	^self javascriptItcLocalizationFor: 'English'!

javascriptItcLocalizationFor: aString 
	| result key |
	key := ('javascriptItcLocalization' , aString) asSymbol.
	(result := self cacheAt: key) isNil 
		ifTrue: 
			[| selector |
			selector := ('javascriptPrivateItcLocalization' , aString) asSymbol.
			(self class respondsTo: selector) 
				ifTrue: 
					[result := self createTimestampWithContents: (self class perform: selector).
					self cacheAt: key put: result]
				ifFalse: 
					[ItcSystemManager 
						logLineWithTsAndSession: 'Itc localization for ' , selector printString , ' is not defined']].
	^result!

javascriptItcLocalizationGerman
	^self javascriptItcLocalizationFor: 'German'!

javascriptItcLocalizationRussian
	^self javascriptItcLocalizationFor: 'Russian'!

javascriptItcLocalizationSerbian
	^self javascriptItcLocalizationFor: 'Serbian'!

javascriptItcLocalizationSlovene
	^self javascriptItcLocalizationFor: 'Slovene'!

javascriptItcTranslationBosnian
	^self javascriptItcTranslationFor: 'Bosnian'!

javascriptItcTranslationCroatian
	^self javascriptItcTranslationFor: 'Croatian'!

javascriptItcTranslationCzech
	^self javascriptItcTranslationFor: 'Czech'!

javascriptItcTranslationEnglish
	^self javascriptItcTranslationFor: 'English'!

javascriptItcTranslationFor: aString 
	| result key |
	key := ('javascriptItcTranslation' , aString) asSymbol.
	(result := self cacheAt: key) isNil 
		ifTrue: 
			[Processor activeProcess language: aString.
			result := self createTimestampWithContents: self class javascriptPrivateItcTranslation.
			self cacheAt: key put: result].
	^result!

javascriptItcTranslationGerman
	^self javascriptItcTranslationFor: 'German'!

javascriptItcTranslationRussian
	^self javascriptItcTranslationFor: 'Russian'!

javascriptItcTranslationSerbian
	^self javascriptItcTranslationFor: 'Serbian'!

javascriptItcTranslationSlovene
	^self javascriptItcTranslationFor: 'Slovene'!

javascriptItcWidget
	| array ws selector |
	(array := self cacheAt: #itcWidget) isNil 
		ifTrue: 
			[ws := WriteStream on: String new.
			self itcWidgetScripts do: 
					[:each | 
					selector := ('javascriptPrivate' , each) asSymbol.
					(self class respondsTo: selector) ifTrue: [ws nextPutAll: (self class perform: selector)]].
			array := self createTimestampWithContents: ws contents.
			self cacheAt: #itcWidget put: array].
	^array!

javascriptOldGrid
	| result |
	(result := self cacheAt: #javascriptOldGrid) isNil 
		ifTrue: 
			[result := self createTimestampWithContents: self class javascriptPrivateOldGrid.
			self cacheAt: #javascriptOldGrid put: result].
	^result!

processGet: request on: stream 
	| selector array script modification fileSize ifModifiedSince |
	((selector := self extractFilenameFrom: request) notNil 
		and: [(self supportedScripts includes: selector) and: [self respondsTo: selector]]) 
			ifFalse: [^stream fileNotFoundResponse].
	array := self perform: selector.
	script := array at: 2.
	fileSize := script size.
	modification := array at: 1.
	((ifModifiedSince := request header ifModifiedSince) notNil and: 
			[(ifModifiedSince last isNil or: [ifModifiedSince last = fileSize]) and: 
					[ifModifiedSince first date = modification date and: 
							[ifModifiedSince first time minutes = modification time minutes 
								and: [ifModifiedSince first time seconds = modification time seconds]]]]) 
		ifTrue: [^stream notModifiedResponse].
	ItcSystemManager logDevTimeError: 'Script download: ' , selector.
	stream nextPutAll: script.
	stream
		expires: (Timestamp date: (Date today addDays: 10) time: Time now);
		cacheControl: 'max-age=864000, public';
		date: modification;
		lastModified: modification;
		contentType: 'application/x-javascript'!

servletName
	^servletName!

servletNamePrefix
	^'scripts'!

supportedScripts
	^
	[| supportedLangs supportedScripts |
	supportedLangs := #('Bosnian' 'Croatian' 'Czech' 'English' 'German' 'Russian' 'Serbian' 'Slovene').
	supportedScripts := OrderedCollection new.
	supportedScripts
		add: #javascriptItc;
		add: #javascriptItcWidget;
		add: #javascriptItcExt;
		add: #javascriptOldGrid.
	#('javascriptItcLocalization' 'javascriptItcTranslation' 'javascriptItcExtLocalization' 'javascriptItcExtTranslation') 
		do: [:eachScriptByLangs | supportedLangs do: [:eachLang | supportedScripts add: (eachScriptByLangs , eachLang) asSymbol]].
	supportedScripts asArray] 
			cachedValue!

urlPrefix: aString 
	| newPrefix |
	newPrefix := aString , '/' , self servletName.
	numberOfCharactersToCut := aString size + 2.
	urlPrefix := newPrefix! !
!WebHttpScriptFileServlet categoriesFor: #cache!private! !
!WebHttpScriptFileServlet categoriesFor: #cacheAt:!private! !
!WebHttpScriptFileServlet categoriesFor: #cacheAt:put:!private! !
!WebHttpScriptFileServlet categoriesFor: #clearCache!private! !
!WebHttpScriptFileServlet categoriesFor: #createTimestampWithContents:!private! !
!WebHttpScriptFileServlet categoriesFor: #doMinify!private! !
!WebHttpScriptFileServlet categoriesFor: #extractFilenameFrom:!private! !
!WebHttpScriptFileServlet categoriesFor: #initialize!public! !
!WebHttpScriptFileServlet categoriesFor: #itcExtScripts!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #itcScripts!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #itcWidgetScripts!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItc!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExt!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtLocalizationBosnian!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtLocalizationCroatian!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtLocalizationCzech!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtLocalizationEnglish!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtLocalizationFor:!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtLocalizationGerman!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtLocalizationRussian!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtLocalizationSerbian!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtLocalizationSlovene!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtTranslationBosnian!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtTranslationCroatian!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtTranslationCzech!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtTranslationEnglish!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtTranslationFor:!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtTranslationGerman!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtTranslationRussian!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtTranslationSerbian!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcExtTranslationSlovene!private!script generator-ext! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcLocalizationBosnian!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcLocalizationCroatian!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcLocalizationCzech!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcLocalizationEnglish!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcLocalizationFor:!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcLocalizationGerman!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcLocalizationRussian!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcLocalizationSerbian!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcLocalizationSlovene!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcTranslationBosnian!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcTranslationCroatian!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcTranslationCzech!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcTranslationEnglish!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcTranslationFor:!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcTranslationGerman!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcTranslationRussian!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcTranslationSerbian!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcTranslationSlovene!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptItcWidget!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #javascriptOldGrid!private!script generator-itc! !
!WebHttpScriptFileServlet categoriesFor: #processGet:on:!public! !
!WebHttpScriptFileServlet categoriesFor: #servletName!public! !
!WebHttpScriptFileServlet categoriesFor: #servletNamePrefix!private! !
!WebHttpScriptFileServlet categoriesFor: #supportedScripts!private! !
!WebHttpScriptFileServlet categoriesFor: #urlPrefix:!public! !

!WebHttpScriptFileServlet class methodsFor!

javascriptMenuBar
	| ws |
	ws := WriteStream on: String new.
	ws
		nextPutAll: self javascriptPrivateItcLegacy;
		nextPutAll: self javascriptPrivateMainMenu;
		nextPutAll: self javascriptPrivateMainMenuBar.
	^JavaScriptMinifier minify: ws contents!

javascriptNavigation
	| ws |
	#itcTodo.
	"Method is probably obsolete and should be deleted. It uses namespace script, that has predefined localization setup that should not be used."
	ws := WriteStream on: String new.
	ws
		nextPutAll: self javascriptPrivateItcNamespace;
		nextPutAll: self javascriptPrivateItcUtil;
		nextPutAll: self javascriptPrivateItcDom;
		nextPutAll: self javascriptPrivateItcEvent.
	^JavaScriptMinifier minify: ws contents!

javascriptPrivateCalendar
	^'ITC.widget.Calendar = function(pActivatorId, pValueElementId, pSelectedDate, pDayNames, pMonthNames) {
	this.m_Activator = pActivatorId?ITC.dom.GetElement(pActivatorId):null;
	this.m_ValueContainer = pValueElementId?ITC.dom.GetElement(pValueElementId):null;
	this.m_SelectedDate = pSelectedDate?pSelectedDate:new Date();
	this.m_DayNames = pDayNames?pDayNames:ITC.translation.DayNames;
	this.m_MonthNames = pMonthNames?pMonthNames:ITC.translation.MonthNames;
	this.m_TemporaryValueContainer = null;
	this.m_ParentContainer = document.body;
	this.m_Container = null;
	this.m_CoveringIframe = null;
	this.m_HideAllDropDowns = false;
	this.m_HeaderElement = null;
	this.m_MonthSelector = null;
	this.m_YearSelector = null;
	this.m_SelectedIndex = null;
	this.m_SelectedClassName = null;
	this.m_Holidays = null;
	this.m_DayElements = new Array();
	this.m_Dates = new Array();
	this._initialize();
};

ITC.widget.Calendar.__GlobalVar__ = null;
ITC.widget.Calendar.GetGlobalVar = function() {
	if (!!ITC.widget.Calendar.__GlobalVar__)
		ITC.widget.Calendar.__GlobalVar__ = new ITC.widget.Calendar(null, null, null, null, null);
	return ITC.widget.Calendar.__GlobalVar__;
}

ITC.widget.Calendar.prototype = {
	' 
		, self javascriptPrivateCalendarIsHoliday 
			, '
	setDate: function(pDate) {
		this.m_SelectedDate = pDate?pDate:new Date();
		this.m_MonthSelector.selectedIndex = this.m_SelectedDate.getMonth();
		this.m_YearSelector.value = this.m_SelectedDate.getFullYear();
		this._refresh();
	},
	show: function(pX, pY, pValueContainer, pParentContainer) {
		this.m_TemporaryValueContainer = pValueContainer?pValueContainer:null;
		if (pParentContainer || (this.m_ParentContainer !!= document.body)) {
			this.m_ParentContainer = pParentContainer?pParentContainer:document.body;
			this.m_ParentContainer.appendChild(this.m_Container);
			if (this.m_CoveringIframe)
				this.m_ParentContainer.appendChild(this.m_CoveringIframe);
		}
		this.m_Container.style.display = ''block'';
		this.m_Container.style.left = pX + ''px'';
		this.m_Container.style.top = pY + ''px'';
		if (this.m_CoveringIframe) {
			this.m_CoveringIframe.style.left = pX + ''px'';
			this.m_CoveringIframe.style.top = pY + ''px'';
			this.m_CoveringIframe.style.width = this.m_Container.offsetWidth + ''px'';
			this.m_CoveringIframe.style.height = this.m_Container.offsetHeight + ''px'';
			this.m_CoveringIframe.style.display = ''block'';
		} else if (this.m_HideAllDropDowns == true) {
			ITC.dom.ToggleDropDowns(false);
		}
	},
	hide: function(pX, pY) {
		this.m_Container.style.display = ''none'';
		if (this.m_CoveringIframe)
			this.m_CoveringIframe.style.display = ''none'';
		else if (this.m_HideAllDropDowns == true)
			ITC.dom.ToggleDropDowns(true);
		this.m_TemporaryValueContainer = null;
	},
	_addDateSelectEventTo: function(pElement, pIndex) {
		var ca = this;
	
		ITC.event.AddListener(''mousedown'', pElement, function(pEvent) {
			ca._selectDate(pIndex);
			ca._setFocus();
			ca.hide();
			ITC.event.StopEvent(ITC.event.GetEvent(pEvent));
		});
	},
	_initialize: function() {
		var ca = this;
		var i, j, el, tbody, row, cell, upDownEl;
		
		el = document.createElement(''table'');
		el.className = ''Calendar'';
		el.border = 0;
		el.cellSpacing = 1;
		el.cellPadding = 1;
		el.style.position = ''absolute'';
		el.style.display = ''none'';
		el.style.zIndex = 998;
		document.body.appendChild(el);
		this.m_Container = el;
		tbody = document.createElement(''tbody'');
		this.m_Container.appendChild(tbody);
		row = document.createElement(''tr'');
		row.className = ''CalendarHeader'';
		tbody.appendChild(row);
		ITC.dom.IEDisableSelectFor(row);
		cell = document.createElement(''td'');
		cell.colSpan = 7;
		cell.align = ''center'';
		cell.className = ''CalendarHeader'';
		cell.style.verticalAlign = ''middle'';
		cell.style.whiteSpace = ''nowrap'';
		row.appendChild(cell);
		el = document.createElement(''span'');
		el.className = ''CalendarSpan'';
		ITC.dom.SetPointerCursorFor(el);
		el.innerHTML = ''&nbsp;&lt;'';
		ITC.event.AddListener(''mousedown'', el, function(pEvent) {
			ca._gotoPreviousMonth();
			ITC.event.StopEvent(ITC.event.GetEvent(pEvent));
		});
		cell.appendChild(el);
		el = document.createElement(''span'');
		el.innerHTML = ''&nbsp;'';
		cell.appendChild(el);
		this.m_MonthSelector = document.createElement(''select'');
		for (i=0;i<12;i++) {
			el = document.createElement(''option'');
			if (this.m_SelectedDate.getMonth() == i)
				el.selected = true;
			el.value = i;
			el.innerHTML = this.m_MonthNames[i];
			this.m_MonthSelector.appendChild(el);
		}
		ITC.event.AddListener(''change'', this.m_MonthSelector, function(pEvent) {
			ca._refresh();
		});
		cell.appendChild(this.m_MonthSelector);
		el = document.createElement(''span'');
		el.innerHTML = ''&nbsp;'';
		cell.appendChild(el);
		el = document.createElement(''input'');
		el.style.border = ''1px solid black'';
		el.type = ''text'';
		el.maxLength = 4;
		el.size = 2;
		el.value = this.m_SelectedDate.getFullYear();
		cell.appendChild(el);
		ITC.event.AddListener(''keypress'', el, function(pEvent) {
			var e = ITC.event.GetEvent(pEvent);
			
			if (e.GetCharCode(e) == 13) {
				ca._refresh();
				ITC.event.StopEvent(e);
			}
		});
		ITC.event.AddListener(''blur'', el, function(pEvent) {
			ca._refresh();
		});
		this.m_YearSelector = el;
		el = document.createElement(''span'');
		el.innerHTML = ''&nbsp;'';
		cell.appendChild(el);
		el = document.createElement(''span'');
		el.className = ''CalendarSpan'';
		ITC.dom.SetPointerCursorFor(el);
		el.innerHTML = ''&gt;&nbsp;'';
		ITC.event.AddListener(''mousedown'', el, function(pEvent) {
			ca._gotoNextMonth();
			ITC.event.StopEvent(ITC.event.GetEvent(pEvent));
		});
		cell.appendChild(el);
		el = document.createElement(''span'');
		el.innerHTML = ''&nbsp;&nbsp;&nbsp;'';
		cell.appendChild(el);
		el = document.createElement(''span'');
		el.className = ''CalendarSpan'';
		ITC.dom.SetPointerCursorFor(el);
		el.innerHTML = ''&#215;'';
		ITC.event.AddListener(''mousedown'', el, function(pEvent) {
			ca._setFocus();
			ca.hide();
			ITC.event.StopEvent(ITC.event.GetEvent(pEvent));
		});
		cell.appendChild(el);
		row = document.createElement(''tr'');
		tbody.appendChild(row);
		for (i=0;i<7;i++) {
			cell = document.createElement(''td'');
			cell.className = ''CalendarDaysRow'';
			cell.innerHTML = this.m_DayNames[i];
			row.appendChild(cell);
		}
		for (i=0;i<6;i++) {
			row = document.createElement(''tr'');
			tbody.appendChild(row);
			for (j=0;j<7;j++) {
				cell = document.createElement(''td'');
				cell.align = ''center'';
				row.appendChild(cell);
				this._addDateSelectEventTo(cell, this.m_DayElements.length);
				this.m_DayElements[this.m_DayElements.length] = cell;
			}
		}
		if (document.all) {
			if (ITC.util.IsBrowserInternetExplorer55Up()) {
				el = document.createElement(''iframe'');
				el.src = ''javascript:false'';
				el.scrolling = ''no'';
				el.frameborder = ''0'';
				el.style.position = ''absolute'';
				el.style.filter = ''Alpha(style=0,opacity=0)'';
				el.style.display = ''none'';
				el.style.zIndex = 997;
				document.body.appendChild(el);
				this.m_CoveringIframe = el;
			} else {
				this.m_HideAllDropDowns = true;
			}
		}
		if (this.m_Activator) {
			ITC.event.AddListener(''mousedown'', this.m_Activator, function(pEvent) {
				var e = ITC.event.GetEvent(pEvent);
				
				ca.show(e.pageX?e.pageX:e.x, e.pageY?e.pageY:e.y, null);
				ITC.event.StopEvent(e);
			});
		}
		this._refresh();
	},
	_setFocus: function() {
		var tmpId;
		if (this.m_ValueContainer && this.m_ValueContainer.id) tmpId=this.m_ValueContainer.id;
		if (this.m_TemporaryValueContainer && this.m_TemporaryValueContainer.id) tmpId=this.m_TemporaryValueContainer.id;
		if (tmpId) setTimeout(function(){var tmpEl=ITC.dom.GetElement(tmpId); if(tmpEl && tmpEl.focus) tmpEl.focus()},0);
	},
	_selectDate: function(pIndex) {
		var date = this.m_Dates[pIndex];
		
		if (!!date)
			return;
		if (date.getMonth() !!= this.m_MonthSelector.selectedIndex) {
			this.setDate(date);
		} else {
			if (this.m_SelectedIndex && this.m_SelectedClassName)
				this.m_DayElements[this.m_SelectedIndex].className = this.m_SelectedClassName;
			this.m_SelectedIndex = pIndex;
			this.m_SelectedClassName = this.m_DayElements[pIndex].className;
			this.m_DayElements[pIndex].className = ''CalendarSelectedDay'';
		}
		if (this.m_ValueContainer)
			{this.m_ValueContainer.value=ITC.util.DateToString(date);if(this.m_ValueContainer.onchange)this.m_ValueContainer.onchange();}
		if (this.m_TemporaryValueContainer)
			{this.m_TemporaryValueContainer.value=ITC.util.DateToString(date);if(this.m_TemporaryValueContainer.onchange)this.m_TemporaryValueContainer.onchange();}
	},
	_gotoPreviousMonth: function() {
		var month, year = parseInt(this.m_YearSelector.value, 10);
		
		if (!!year || (year < 0))
			year = (new Date()).getFullYear();
		month = this.m_MonthSelector[this.m_MonthSelector.selectedIndex].value;
		if (month == 0) {
			month = 11;
			year--;
			this.m_YearSelector.value = year;
		} else {
			month--;
		}
		this.m_MonthSelector.selectedIndex = month;
		this._refresh();
	},
	_gotoNextMonth: function() {
		var month, year = parseInt(this.m_YearSelector.value, 10);
		
		if (!!year || (year < 0))
			year = (new Date()).getFullYear();
		month = this.m_MonthSelector[this.m_MonthSelector.selectedIndex].value;
		if (month == 11) {
			month = 0;
			year++;
			this.m_YearSelector.value = year;
		} else {
			month++;
		}
		this.m_MonthSelector.selectedIndex = month;
		this._refresh();
	},
	_daysInMonth: function(pMonthIndex, pYear) {
		if ((pMonthIndex == 3) || (pMonthIndex == 5) || (pMonthIndex == 8) || (pMonthIndex == 10))
			return 30;
		if (pMonthIndex !!= 1)
			return 31;
		if (((pYear % 4) == 0) && (((pYear % 100) !!= 0) || ((pYear % 400) == 0)))
			return 29;
		return 28;
	},
	_refresh: function() {
		var i, index, el, date, currentYear, currentMonth, tempDay, tempMonth, tempYear;
		
		currentYear = parseInt(this.m_YearSelector.value, 10);
		if (!!currentYear || (currentYear < 0))
			currentYear = (new Date()).getFullYear();
		currentMonth = parseInt(this.m_MonthSelector[this.m_MonthSelector.selectedIndex].value, 10);
		if (!!currentMonth)
			currentMonth = 0;
		if ((currentMonth < 0) || (currentMonth > 11))
			currentMonth = (new Date()).getMonth();
		index = (new Date(currentYear, currentMonth, 1)).getDay();
		if (index == 0)
			index = 7;
		index--;
		if (currentMonth == 0) {
			tempMonth = 11;
			tempYear = currentYear - 1;
		} else {
			tempMonth = currentMonth - 1;
			tempYear = currentYear;
		}
		tempDay = (this._daysInMonth(tempMonth, tempYear)) - index + 1;
		for (i=0;i<index;i++) {
			date = new Date(tempYear, tempMonth, tempDay);
			this.m_DayElements[i].className = ''CalendarNoDay'' + ((((i+1)%7)==0)||(((i+2)%7)==0)?''Weekend'':'''');
			this.m_DayElements[i].innerHTML = tempDay++;
			this.m_Dates[i] = date;
		}
		for (i=1;i<=this._daysInMonth(currentMonth, currentYear);i++) {
			date = new Date(currentYear, currentMonth, i);
			this.m_DayElements[index].className = ''Calendar'' + ((((index+1)%7)==0)||(((index+2)%7)==0)?''Weekend'':(this.IsHoliday(date)?''DayHoliday'':''Day''));
			this.m_DayElements[index].innerHTML = i;
			this.m_Dates[index] = date;
			if ((currentYear == this.m_SelectedDate.getFullYear()) && (currentMonth == this.m_SelectedDate.getMonth()) && (i == this.m_SelectedDate.getDate())) {
				this.m_SelectedIndex = index;
				this.m_SelectedClassName = this.m_DayElements[index].className;
				this.m_DayElements[index].className = ''CalendarSelectedDay'';
			}
			index++;
		}
		tempDay = 1;
		if (currentMonth == 11) {
			tempMonth = 0;
			tempYear = currentYear + 1;
		} else {
			tempMonth = currentMonth + 1;
			tempYear = currentYear;
		}
		for (i=index;i<42;i++) {
			date = new Date(tempYear, tempMonth, tempDay);
			this.m_DayElements[i].className = ''CalendarNoDay'' + ((((i+1)%7)==0)||(((i+2)%7)==0)?''Weekend'':'''');
			this.m_DayElements[i].innerHTML = tempDay++;
			this.m_Dates[i] = date;
		}
	}
};'!

javascriptPrivateCalendarIsHoliday
	| localization selector |
	localization := (localization := Processor activeProcess webApplication) isNil 
				ifTrue: ['EN']
				ifFalse: [localization defaultLocalization].
	selector := ('javascriptPrivateCalendarIsHoliday' , localization) asSymbol.
	^(self respondsTo: selector) 
		ifTrue: [self perform: selector]
		ifFalse: 
			[ItcSystemManager 
				logLineWithTsAndSession: 'Holiday localization for ' , selector printString , ' is not defined'.
			'IsHoliday: function(pDate) {return false},']!

javascriptPrivateCalendarIsHolidayBA
	^'IsHoliday: function(pDate) {
		var year, month, day, newYear;
		
		year = pDate.getFullYear();
		month = pDate.getMonth() + 1;
		day = pDate.getDate();
		newYear=new Date;
		newYear.setYear(year);
		newYear.setMonth(0);
		newYear.setDate(1);
		
		if ((month == 1) && ((day == 1) || ((day == 2) ||(day == 7))))
			return true;
		if ((month == 1) && ((newYear.getDay() == 0) || (newYear.getDay() == 6)) && (day == 3))
			return true;
		if ((month == 3) && (day == 28))
			return true;
		if ((month == 5) && ((day == 1) || ((day == 2) || (day == 9))))
			return true;
		if ((month == 7) && (day == 7))
			return true;
		
		switch (year){
			case 2000:
				if (((month == 5) && (day == 1)) || ((month == 4) && (day == 28))) return true;
			break;
			case 2001:
				if (((month == 4) && (day == 16)) || ((month == 4) && (day == 13))) return true;
			break;
			case 2002:
				if (((month == 5) && (day == 6)) || ((month == 5) && (day == 3))) return true;
			break;
			case 2003:
				if (((month == 4) && (day == 28)) || ((month == 4) && (day == 25))) return true;
			break;
			case 2004:
				if (((month == 4) && (day == 12)) || ((month == 4) && (day == 9))) return true;
			break;
			case 2005:
				if (((month == 5) && (day == 2)) || ((month == 4) && (day == 29))) return true;
			break;	
			case 2006:
				if (((month == 4) && (day == 24)) || ((month == 4) && (day == 21))) return true;
			break;
			case 2007:
				if (((month == 4) && (day == 9)) || ((month == 4) && (day == 6))) return true;
			break;
			case 2008:
				if (((month == 4) && (day == 28)) || ((month == 4) && (day == 25))) return true;
			break;
			case 2009:
				if (((month == 4) && (day == 20)) || ((month == 4) && (day == 17))) return true;
			break;
			case 2010:
				if (((month == 4) && (day == 5)) || ((month == 4) && (day == 2))) return true;
			break;
			case 2011:
				if (((month == 4) && (day == 25)) || ((month == 4) && (day == 22))) return true;
			break;
			case 2012:
				if (((month == 4) && (day == 16)) || ((month == 4) && (day == 13))) return true;
			break;
			case 2013:
				if (((month == 4) && (day == 8)) || ((month == 4) && (day == 5))) return true;
			break;
			case 2014:
				if (((month == 4) && (day == 21)) || ((month == 4) && (day == 18))) return true;
			break;
			case 2015:
				if (((month == 4) && (day == 13)) || ((month == 4) && (day == 10))) return true;
			break;
			case 2016:
				if (((month == 5) && (day == 2)) || ((month == 4) && (day == 29))) return true;
			break;
			case 2017:
				if (((month == 4) && (day == 17)) || ((month == 4) && (day == 14))) return true;
			break;
			case 2018:
				if (((month == 4) && (day == 9)) || ((month == 4) && (day == 6))) return true;
			default:
				return false;
		}
	},'!

javascriptPrivateCalendarIsHolidayCZ
	^'IsHoliday: function(pDate) {
		var i, z, s, e, p, d, vn, vnd, vnm, year, month, day, coll;
		
		month = pDate.getMonth() + 1;
		day = pDate.getDate();
		if ((month == 1) && (day == 1))
			return true;
		if ((month == 12) && (day == 25))
			return true;
		year = pDate.getFullYear();
		if ((this.m_Holidays == null) || (this.m_Holidays[0] !!= year)) {
			if (year > 1582) {
				z = year % 19;
				s = Math.floor(year / 100);
				e = (s - Math.floor(s / 4) - Math.floor((8 * s + 13) / 25)+ 19 * z + 15) % 30;
				p = e - Math.floor(e / 28) * (1 - Math.floor(e / 28) * Math.floor(29 / (e + 1)) * Math.floor((21 - z) / 11));
				d = (year + Math.floor(year / 4) + p + 2 - s + Math.floor(s / 4)) % 7;
			} else {
				z = year % 19;
				p = (19 * z + 15) % 30; 
				d = (year + Math.floor(year / 4) + p) % 7;
			}
			vnm = 3 + Math.floor((p - d + 40) / 44);
			vnd = (p - d) + 28 - 31 * Math.floor(vnm / 4);
			vn = new Date(year, vnm - 1, vnd);
			coll = [new Date(vn.getTime() + 86400000), new Date(vn.getTime() + 49*86400000)];
			this.m_Holidays = [year, coll];
		} else {
			coll = this.m_Holidays[1];
		}
		for (i=0;i<coll.length;i++) {
			if ((coll[i].getMonth() == (month-1)) && (coll[i].getDate() == day))
				return true;
		}
		return false;
	},'!

javascriptPrivateCalendarIsHolidayDE
	^'IsHoliday: function(pDate) {
		var i, z, s, e, p, d, vn, vnd, vnm, year, month, day, coll;
		
		month = pDate.getMonth() + 1;
		day = pDate.getDate();
		if ((month == 1) && (day == 1))
			return true;
		if ((month == 12) && (day == 25))
			return true;
		year = pDate.getFullYear();
		if ((this.m_Holidays == null) || (this.m_Holidays[0] !!= year)) {
			if (year > 1582) {
				z = year % 19;
				s = Math.floor(year / 100);
				e = (s - Math.floor(s / 4) - Math.floor((8 * s + 13) / 25)+ 19 * z + 15) % 30;
				p = e - Math.floor(e / 28) * (1 - Math.floor(e / 28) * Math.floor(29 / (e + 1)) * Math.floor((21 - z) / 11));
				d = (year + Math.floor(year / 4) + p + 2 - s + Math.floor(s / 4)) % 7;
			} else {
				z = year % 19;
				p = (19 * z + 15) % 30; 
				d = (year + Math.floor(year / 4) + p) % 7;
			}
			vnm = 3 + Math.floor((p - d + 40) / 44);
			vnd = (p - d) + 28 - 31 * Math.floor(vnm / 4);
			vn = new Date(year, vnm - 1, vnd);
			coll = [new Date(vn.getTime() + 86400000), new Date(vn.getTime() + 49*86400000)];
			this.m_Holidays = [year, coll];
		} else {
			coll = this.m_Holidays[1];
		}
		for (i=0;i<coll.length;i++) {
			if ((coll[i].getMonth() == (month-1)) && (coll[i].getDate() == day))
				return true;
		}
		return false;
	},'!

javascriptPrivateCalendarIsHolidayEN
	^'IsHoliday: function(pDate) {
		var i, z, s, e, p, d, vn, vnd, vnm, year, month, day, coll;
		
		month = pDate.getMonth() + 1;
		day = pDate.getDate();
		if ((month == 1) && (day == 1))
			return true;
		if ((month == 12) && (day == 25))
			return true;
		year = pDate.getFullYear();
		if ((this.m_Holidays == null) || (this.m_Holidays[0] !!= year)) {
			if (year > 1582) {
				z = year % 19;
				s = Math.floor(year / 100);
				e = (s - Math.floor(s / 4) - Math.floor((8 * s + 13) / 25)+ 19 * z + 15) % 30;
				p = e - Math.floor(e / 28) * (1 - Math.floor(e / 28) * Math.floor(29 / (e + 1)) * Math.floor((21 - z) / 11));
				d = (year + Math.floor(year / 4) + p + 2 - s + Math.floor(s / 4)) % 7;
			} else {
				z = year % 19;
				p = (19 * z + 15) % 30; 
				d = (year + Math.floor(year / 4) + p) % 7;
			}
			vnm = 3 + Math.floor((p - d + 40) / 44);
			vnd = (p - d) + 28 - 31 * Math.floor(vnm / 4);
			vn = new Date(year, vnm - 1, vnd);
			coll = [new Date(vn.getTime() + 86400000), new Date(vn.getTime() + 49*86400000)];
			this.m_Holidays = [year, coll];
		} else {
			coll = this.m_Holidays[1];
		}
		for (i=0;i<coll.length;i++) {
			if ((coll[i].getMonth() == (month-1)) && (coll[i].getDate() == day))
				return true;
		}
		return false;
	},'!

javascriptPrivateCalendarIsHolidayHR
	"v kolekciji coll je datum za veliko noc, ter datum za corpus christi, ki je 60 dni po veliki noci"

	^'IsHoliday: function(pDate) {
		var i, z, s, e, p, d, vn, vnd, vnm, year, month, day, coll;
		
		month = pDate.getMonth() + 1;
		day = pDate.getDate();
		if ((month == 1) && ((day == 1) || (day == 6)))
			return true;
		if (month == 2) return false;
		if ((month == 5) && (day == 1))
			return true;
		if ((month == 6) && ((day == 25) || (day == 22)))
			return true;
		if ((month == 8) && ((day == 5) || (day == 15)))
			return true;
		if ((month == 10) && (day == 8))
			return true;
		if ((month == 11) && (day == 1))
			return true;
		if ((month == 12) && ((day == 25) || (day == 26)))
			return true;
		year = pDate.getFullYear();
		if ((this.m_Holidays == null) || (this.m_Holidays[0] !!= year)) {
			if (year > 1582) {
				z = year % 19;
				s = Math.floor(year / 100);
				e = (s - Math.floor(s / 4) - Math.floor((8 * s + 13) / 25)+ 19 * z + 15) % 30;
				p = e - Math.floor(e / 28) * (1 - Math.floor(e / 28) * Math.floor(29 / (e + 1)) * Math.floor((21 - z) / 11));
				d = (year + Math.floor(year / 4) + p + 2 - s + Math.floor(s / 4)) % 7;
			} else {
				z = year % 19;
				p = (19 * z + 15) % 30; 
				d = (year + Math.floor(year / 4) + p) % 7;
			}
			vnm = 3 + Math.floor((p - d + 40) / 44);
			vnd = (p - d) + 28 - 31 * Math.floor(vnm / 4);
			vn = new Date(year, vnm - 1, vnd);
			coll = [new Date(vn.getTime() + 86400000), new Date(vn.getTime() + 60*86400000)];
			this.m_Holidays = [year, coll];
		} else {
			coll = this.m_Holidays[1];
		}
		for (i=0;i<coll.length;i++) {
			if ((coll[i].getMonth() == (month-1)) && (coll[i].getDate() == day))
				return true;
		}
		return false;
	},'!

javascriptPrivateCalendarIsHolidayRS
	^'IsHoliday: function(pDate) {
		var year, month, day, newYear;
		
		year = pDate.getFullYear();
		month = pDate.getMonth() + 1;
		day = pDate.getDate();
		newYear=new Date;
		newYear.setYear(year);
		newYear.setMonth(0);
		newYear.setDate(1);
		
		if ((month == 1) && ((day == 1) || ((day == 2) ||(day == 7))))
			return true;
		if ((month == 1) && ((newYear.getDay() == 0) || (newYear.getDay() == 6)) && (day == 3))
			return true;

		if ((month == 2) && (day == 15))
			return true;

		if ((month == 5) && ((day == 1) || (day == 2)))
			return true;
	
		switch (year){
			case 2000:
				if (((month == 5) && (day == 1)) || ((month == 4) && (day == 28))) return true;
			break;
			case 2001:
				if (((month == 4) && (day == 16)) || ((month == 4) && (day == 13))) return true;
			break;
			case 2002:
				if (((month == 5) && (day == 6)) || ((month == 5) && (day == 3))) return true;
			break;
			case 2003:
				if (((month == 4) && (day == 28)) || ((month == 4) && (day == 25))) return true;
			break;
			case 2004:
				if (((month == 4) && (day == 12)) || ((month == 4) && (day == 9))) return true;
			break;
			case 2005:
				if (((month == 5) && (day == 2)) || ((month == 4) && (day == 29))) return true;
			break;	
			case 2006:
				if (((month == 4) && (day == 24)) || ((month == 4) && (day == 21))) return true;
			break;
			case 2007:
				if (((month == 4) && (day == 9)) || ((month == 4) && (day == 6))) return true;
			break;
			case 2008:
				if (((month == 4) && (day == 28)) || ((month == 4) && (day == 25))) return true;
			break;
			case 2009:
				if (((month == 4) && (day == 20)) || ((month == 4) && (day == 17))) return true;
			break;
			case 2010:
				if (((month == 4) && (day == 5)) || ((month == 4) && (day == 2))) return true;
			break;
			case 2011:
				if (((month == 4) && (day == 25)) || ((month == 4) && (day == 22))) return true;
			break;
			case 2012:
				if (((month == 4) && (day == 16)) || ((month == 4) && (day == 13))) return true;
			break;
			case 2013:
				if (((month == 4) && (day == 8)) || ((month == 4) && (day == 5))) return true;
			break;
			case 2014:
				if (((month == 4) && (day == 21)) || ((month == 4) && (day == 18))) return true;
			break;
			case 2015:
				if (((month == 4) && (day == 13)) || ((month == 4) && (day == 10))) return true;
			break;
			case 2016:
				if (((month == 5) && (day == 2)) || ((month == 4) && (day == 29))) return true;
			break;
			case 2017:
				if (((month == 4) && (day == 17)) || ((month == 4) && (day == 14))) return true;
			break;
			case 2018:
				if (((month == 4) && (day == 9)) || ((month == 4) && (day == 6))) return true;
			default:
				return false;
		}
	},'!

javascriptPrivateCalendarIsHolidayRU
	^'IsHoliday: function(pDate) {
		var i, z, s, e, p, d, vn, vnd, vnm, year, month, day, coll;
		
		month = pDate.getMonth() + 1;
		day = pDate.getDate();
		if ((month == 1) && (day == 1))
			return true;
		if ((month == 12) && (day == 25))
			return true;
		year = pDate.getFullYear();
		if ((this.m_Holidays == null) || (this.m_Holidays[0] !!= year)) {
			if (year > 1582) {
				z = year % 19;
				s = Math.floor(year / 100);
				e = (s - Math.floor(s / 4) - Math.floor((8 * s + 13) / 25)+ 19 * z + 15) % 30;
				p = e - Math.floor(e / 28) * (1 - Math.floor(e / 28) * Math.floor(29 / (e + 1)) * Math.floor((21 - z) / 11));
				d = (year + Math.floor(year / 4) + p + 2 - s + Math.floor(s / 4)) % 7;
			} else {
				z = year % 19;
				p = (19 * z + 15) % 30; 
				d = (year + Math.floor(year / 4) + p) % 7;
			}
			vnm = 3 + Math.floor((p - d + 40) / 44);
			vnd = (p - d) + 28 - 31 * Math.floor(vnm / 4);
			vn = new Date(year, vnm - 1, vnd);
			coll = [new Date(vn.getTime() + 86400000), new Date(vn.getTime() + 49*86400000)];
			this.m_Holidays = [year, coll];
		} else {
			coll = this.m_Holidays[1];
		}
		for (i=0;i<coll.length;i++) {
			if ((coll[i].getMonth() == (month-1)) && (coll[i].getDate() == day))
				return true;
		}
		return false;
	},'!

javascriptPrivateCalendarIsHolidaySI
	"V kolekciji coll je samo datum za veliko noc"

	^'IsHoliday: function(pDate) {
		var i, z, s, e, p, d, vn, vnd, vnm, year, month, day, coll;
		
		month = pDate.getMonth() + 1;
		day = pDate.getDate();
		if ((month == 1) && ((day == 1) || (day == 2)))
			return true;
		if ((month == 2) && (day == 8))
			return true;
		if ((month == 4) && (day == 27))
			return true;
		if ((month == 5) && ((day == 1) || (day == 2)))
			return true;
		if ((month == 6) && (day == 25))
			return true;
		if ((month == 8) && (day == 15))
			return true;
		if ((month == 10) && (day == 31))
			return true;
		if ((month == 11) && (day == 1))
			return true;
		if ((month == 12) && ((day == 25) || (day == 26)))
			return true;
		year = pDate.getFullYear();
		if ((this.m_Holidays == null) || (this.m_Holidays[0] !!= year)) {
			if (year > 1582) {
				z = year % 19;
				s = Math.floor(year / 100);
				e = (s - Math.floor(s / 4) - Math.floor((8 * s + 13) / 25)+ 19 * z + 15) % 30;
				p = e - Math.floor(e / 28) * (1 - Math.floor(e / 28) * Math.floor(29 / (e + 1)) * Math.floor((21 - z) / 11));
				d = (year + Math.floor(year / 4) + p + 2 - s + Math.floor(s / 4)) % 7;
			} else {
				z = year % 19;
				p = (19 * z + 15) % 30; 
				d = (year + Math.floor(year / 4) + p) % 7;
			}
			vnm = 3 + Math.floor((p - d + 40) / 44);
			vnd = (p - d) + 28 - 31 * Math.floor(vnm / 4);
			vn = new Date(year, vnm - 1, vnd);
			coll = [new Date(vn.getTime() + 86400000)];
			this.m_Holidays = [year, coll];
		} else {
			coll = this.m_Holidays[1];
		}
		for (i=0;i<coll.length;i++) {
			if ((coll[i].getMonth() == (month-1)) && (coll[i].getDate() == day))
				return true;
		}
		return false;
	},'!

javascriptPrivateCheckBoxTree
	^'ITC.widget.CheckBoxTree = function(pContainerId, pImagePath) {
	this.m_Container = ITC.dom.GetElement(pContainerId);
	this.m_ImagePath = pImagePath;
	this.m_RootNodes = new Array();
};

ITC.widget.CheckBoxTree.prototype = {
	addChildNode: function(pLabel, pName, pValue, pChecked) {
		return this.m_RootNodes[this.m_RootNodes.length] = new ITC.widget.CheckBoxTreeNode(pLabel, pName, pValue, pChecked, null, this, (this.m_Depth + 1));
	},
	
	getImagePath: function() {
		if (!!this.m_ImagePath)
			this.m_ImagePath = '''';
		return this.m_ImagePath;
	},
	
	build: function() {
		var i;
		
		for (i=0;i<this.m_RootNodes.length;i++) {
			this.m_RootNodes[i]._build(this.m_Container, i, this.m_RootNodes.length);
			this.m_RootNodes[i]._testAllChildren();
		}
	}
};

ITC.widget.CheckBoxTreeNode = function(pLabel, pName, pValue, pChecked, pParentNode, pTree, pDepth) {
	this.m_Label = pLabel;
	this.m_Name = pName;
	this.m_Value = pValue;
	this.m_Checked = pChecked;
	this.m_ParentNode = pParentNode;
	this.m_Tree = pTree;
	this.m_Depth = pDepth?pDepth:0;
	this.m_ChildNodes = new Array();
	this.m_Container = null;
	this.m_Open = false;
	this.m_PlusMinusImage = null;
	this.m_CheckBoxImg = null;
	this.m_CheckBox = null;
};

ITC.widget.CheckBoxTreeNode.prototype = {
	_build: function(pParentContainer, pPosition, pSize) {
		var tn = this;
		var i, el, pos;
		
		if (pPosition == 0)
			this.m_Position = 0;
		else if (pPosition == (pSize - 1))
			this.m_Position = 2;
		else
			this.m_Position = 1;
		this.m_Container = document.createElement(''div'');
		if (this.m_Depth > 0)
			this.m_Container.style.display = ''none'';
		else
			this.m_Container.style.display = ''block'';
		pParentContainer.appendChild(this.m_Container);
		for (i=0;i<this.m_Depth;i++) {
			el = document.createElement(''img'');
			el.src = this.m_Tree.getImagePath() + ''line-vertical.gif'';
			el.style.verticalAlign = ''middle'';
			this.m_Container.appendChild(el);
		}
		if (this.m_ChildNodes.length > 0) {
			this.m_PlusMinusImage = document.createElement(''img'');
			if (this.m_Position == 0)
				this.m_PlusMinusImage.src = this.m_Tree.getImagePath() + ''plus-begin.gif'';
			else if (this.m_Position == 1)
				this.m_PlusMinusImage.src = this.m_Tree.getImagePath() + ''plus-middle.gif'';
			else
				this.m_PlusMinusImage.src = this.m_Tree.getImagePath() + ''plus-end.gif'';
			this.m_PlusMinusImage.style.verticalAlign = ''middle'';
			this.m_Container.appendChild(this.m_PlusMinusImage);
			ITC.event.AddListener(''click'', this.m_PlusMinusImage, function(pEvent) {
				tn._toggleChildren(pEvent);
			});
			el = document.createElement(''img'');
			el.src = this.m_Tree.getImagePath() + ''folder-closed.gif'';
			el.style.verticalAlign = ''middle'';
			this.m_Container.appendChild(el);
		} else {
			el = document.createElement(''img'');
			if (this.m_Position == 2)
				el.src = this.m_Tree.getImagePath() + ''line-end.gif'';
			else
				el.src = this.m_Tree.getImagePath() + ''line-middle.gif'';
			el.style.verticalAlign = ''middle'';
			this.m_Container.appendChild(el);
			el = document.createElement(''img'');
			el.src = this.m_Tree.getImagePath() + ''leaf.gif'';
			el.style.verticalAlign = ''middle'';
			this.m_Container.appendChild(el);
		}
		this.m_CheckBoxImg = document.createElement(''img'');
		if (this.m_Checked)
			this.m_CheckBoxImg.src = this.m_Tree.getImagePath() + ''cb-checked.gif'';
		else
			this.m_CheckBoxImg.src = this.m_Tree.getImagePath() + ''cb.gif'';
		this.m_CheckBoxImg.align = ''middle'';
		this.m_Container.appendChild(this.m_CheckBoxImg);
		ITC.event.AddListener(''click'', this.m_CheckBoxImg, function(pEvent) {
			tn._toggleChecked(pEvent);
		});
		this.m_CheckBox = document.createElement(''input'');
		this.m_CheckBox.type = ''checkbox'';
		this.m_CheckBox.name = this.m_Name;
		this.m_CheckBox.id = this.m_Name;
		this.m_CheckBox.value = this.m_Value;
		this.m_CheckBox.style.display = ''none'';
		this.m_Container.appendChild(this.m_CheckBox);
		if (this.m_Checked)
			this.m_CheckBox.checked = true;
		el = document.createElement(''span'');
		el.className = ''nodeLabel'';
		el.style.verticalAlign = ''middle'';
		el.appendChild(document.createTextNode(this.m_Label));
		this.m_Container.appendChild(el);
		for (i=0;i<this.m_ChildNodes.length;i++)
			this.m_ChildNodes[i]._build(this.m_Container, i, this.m_ChildNodes.length);
	},
	
	_toggleChildren: function(pEvent) {
		if (this.m_Open)
			this.hide();
		else
			this.show();
	},
	
	_toggleChecked: function(pEvent) {
		if (this.m_CheckBox.disabled == true) {
			this.m_CheckBoxImg.src = this.m_Tree.getImagePath() + ''cb-checked.gif'';
			this.m_CheckBox.disabled = false;
			this._checkAll();
		} else if (this.m_CheckBox.checked == true) {
			this.m_CheckBoxImg.src = this.m_Tree.getImagePath() + ''cb.gif'';
			this._uncheckAll();
		} else {
			this.m_CheckBoxImg.src = this.m_Tree.getImagePath() + ''cb-checked.gif'';
			this._checkAll();
		}
		if (this.m_ParentNode)
			this.m_ParentNode._testChildren();
	},
	
	_checkAll: function() {
		var i;
		
		this.m_CheckBoxImg.src = this.m_Tree.getImagePath() + ''cb-checked.gif'';
		this.m_CheckBox.checked = true;
		for (i=0;i<this.m_ChildNodes.length;i++)
			this.m_ChildNodes[i]._checkAll();
	},
	
	_uncheckAll: function() {
		var i;
		
		this.m_CheckBoxImg.src = this.m_Tree.getImagePath() + ''cb.gif'';
		this.m_CheckBox.checked = false;
		for (i=0;i<this.m_ChildNodes.length;i++)
			this.m_ChildNodes[i]._uncheckAll();
	},
	
	_testChildren: function() {
		var i;
		var allChecked = true, allUnchecked = true;
		
		for (i=0;i<this.m_ChildNodes.length;i++) {
			if (this.m_ChildNodes[i].m_CheckBox.checked == true) {
				allUnchecked = false;
				if (this.m_ChildNodes[i].m_CheckBox.disabled == true)
					allChecked = false;
			} else {
				allChecked = false;
			}
		}
		this._setChecked(allChecked, allUnchecked);
		if (this.m_ParentNode)
			this.m_ParentNode._testChildren();
	},
	
	_testAllChildren: function() {
		var i;
		var allChecked = true, allUnchecked = true;
		
		if (this.m_ChildNodes.length == 0)
			return (this.m_CheckBox.checked == true);
		for (i=0;i<this.m_ChildNodes.length;i++) {
			if (this.m_ChildNodes[i]._testAllChildren())
				allUnchecked = false;
			else
				allChecked = false;
		}
		this._setChecked(allChecked, allUnchecked);
		return allChecked;
	},
	
	_setChecked: function(pAllChecked, pAllUnchecked) {
		if (pAllChecked) {
			this.m_CheckBoxImg.src = this.m_Tree.getImagePath() + ''cb-checked.gif'';
			this.m_CheckBox.disabled = false;
			this.m_CheckBox.checked = true;
		} else if (pAllUnchecked) {
			this.m_CheckBoxImg.src = this.m_Tree.getImagePath() + ''cb.gif'';
			this.m_CheckBox.disabled = false;
			this.m_CheckBox.checked = false;
		} else {
			this.m_CheckBoxImg.src = this.m_Tree.getImagePath() + ''cb-checked-disabled.gif'';
			this.m_CheckBox.checked = true;
			this.m_CheckBox.disabled = true;
		}
	},
	
	hide: function() {
		var i;
		
		for (i=0;i<this.m_ChildNodes.length;i++)
			this.m_ChildNodes[i].m_Container.style.display = ''none'';
		if (this.m_Position == 0)
			this.m_PlusMinusImage.src = this.m_Tree.getImagePath() + ''plus-begin.gif'';
		else if (this.m_Position == 1)
			this.m_PlusMinusImage.src = this.m_Tree.getImagePath() + ''plus-middle.gif'';
		else
			this.m_PlusMinusImage.src = this.m_Tree.getImagePath() + ''plus-end.gif'';
		this.m_Open = false;
	},
	
	show: function() {
		for (i=0;i<this.m_ChildNodes.length;i++)
			this.m_ChildNodes[i].m_Container.style.display = ''block'';
		if (this.m_Position == 0)
			this.m_PlusMinusImage.src = this.m_Tree.getImagePath() + ''minus-begin.gif'';
		else if (this.m_Position == 1)
			this.m_PlusMinusImage.src = this.m_Tree.getImagePath() + ''minus-middle.gif'';
		else
			this.m_PlusMinusImage.src = this.m_Tree.getImagePath() + ''minus-end.gif'';
		this.m_Open = true;
	},
	
	addChildNode: function(pLabel, pName, pValue, pChecked) {
		return this.m_ChildNodes[this.m_ChildNodes.length] = new ITC.widget.CheckBoxTreeNode(pLabel, pName, pValue, pChecked, this, this.m_Tree, (this.m_Depth + 1));
	}
};'!

javascriptPrivateDialogBox
	^'ITC.widget.DialogBox = function(pTitle,pHelpPageUrl,pWidth,pHeight,pFormName,pFormAction,pFormTarget,pWebAction) {
	this.m_Title = '''';
	this.m_HelpPageUrl=pHelpPageUrl;
	this.setDialogBoxTitle(pTitle);
	this.m_Width = pWidth?pWidth:0;
	this.m_Height = pHeight?pHeight:0;
	if (this.m_Width<100)
		this.m_Width = 200;
	if (this.m_Height<70)
		this.m_Height = 70;
	this.m_OverlayContainer = null;
	this.m_OverlayFrame = null;
	this.m_HideAllDropDowns = false;
	this.m_DialogContainer = null;
	this.m_FormName = pFormName;
	this.m_FormAction = pFormAction;
	this.m_FormTarget = pFormTarget;
	this.m_FormContainer = null;
	this.m_FormWebAction = pWebAction;
	this.m_ContentContainer = null;
	this.m_TitleBarContainer = null;
	this.m_OutlineContainer = new Array(4);
	this.m_ControlContainer = null;
	this.m_RepaintNeeded = true;
	this.m_Open = false;
	this.m_DataRetriever = null;
	this.m_CallbackFunction = null;
	this.m_Dragging = false;
	this.m_XOffset = 0;
	this.m_YOffset = 0;
	this.m_onClosedAjaxGetUrl;
	this.m_onClosedGoToUrl;
	this.m_ThisDialogBoxIndex = ITC.widget.DialogBox.LastDialogBoxIndex++;
	ITC.widget.DialogBox.AllDialogBoxes[this.m_ThisDialogBoxIndex] = this;
	ITC.widget.DialogBox.PreviousKeyboardHandler[this.m_ThisDialogBoxIndex]=self.itc_gkHandler;
	this._initialize();
};

ITC.widget.DialogBox.prototype = {
	isOpen: function() {
		return this.m_Open==true;
	},
	
	loadUrl: function(pUrl) {
		if (!!this.isOpen())
			return;
		this.m_DataRetriever.sendRequest(pUrl);
	},
	
	basicClose: function() {
		var i;
		
		if(ITC.widget.DialogBox.AllDialogBoxes[this.m_ThisDialogBoxIndex]) {
			ITC.widget.DialogBox.AllDialogBoxes[this.m_ThisDialogBoxIndex]=null;
			self.itc_gkHandler=ITC.widget.DialogBox.PreviousKeyboardHandler[this.m_ThisDialogBoxIndex];
			ITC.widget.DialogBox.PreviousKeyboardHandler[this.m_ThisDialogBoxIndex]=null;
		}
		ITC.event.RemoveAllListenersForClient(this);
		if (this.isOpen()) {
			if (this.m_HideAllDropDowns == true)
				ITC.dom.ToggleDropDowns(true);
		}
		ITC.dom.DisposeElement(this.m_DialogContainer);
		this.m_DialogContainer = null;
		ITC.dom.DisposeElement(this.m_OverlayContainer);
		this.m_OverlayContainer = null;
		for(i=0;i<4;i++) {
			ITC.dom.DisposeElement(this.m_OutlineContainer[i]);
			this.m_OutlineContainer[i] = null;
		}
		this.m_OutlineContainer = null;
	},
	
	close: function() {
		if (this.m_onClosedAjaxGetUrl)
			ITC.widget.DialogBox.AjaxGetRequest(this.m_onClosedAjaxGetUrl, this);
		else if(this.m_onClosedGoToUrl)
			window.location=this.m_onClosedGoToUrl;
		else
			this.basicClose();
	},
	
	hide: function() {
		if (!!this.isOpen())
			return;
		this.m_DialogContainer.style.display = ''none'';
		this.m_OverlayContainer.style.display = ''none'';
		if (this.m_HideAllDropDowns == true)
			ITC.dom.ToggleDropDowns(true);
		this.m_Open = false;
	},
	
	show: function() {
		if (!!this.isOpen()) {
			this._onResize();
			this.m_OverlayContainer.style.display = ''block'';
			if (this.m_HideAllDropDowns == true)
				ITC.dom.ToggleDropDowns(false);
			this.m_DialogContainer.style.display = ''block'';
			this.m_Open = true;
		}
		if (this.m_RepaintNeeded == true)
			this._repaint();
	},
	
	setContent: function(htmlString) {
		this.m_ContentContainer.innerHTML = ''<div style="padding:5px;">'' + htmlString + ''</div>'';
		if(this.isOpen())
			this._repaint();
	},
	
	setBottomContent: function(htmlString) {
		this.m_ControlContainer.innerHTML = ''<div>'' + htmlString + ''</div>'';
		if (this.isOpen())
			this._repaint();
	},
	
	resizeToContent: function(){
		var w, w1, w2, h, h1, h2, maxH, maxW, posX, posY, left, top;
		
		maxH = ITC.dom.GetDocumentHeight();
		maxW = ITC.dom.GetDocumentWidth();
		w = w1 = this.m_ContentContainer.scrollWidth;
		if (this.m_ControlContainer.childNodes.length>0) {
			w2 = this.m_ControlContainer.childNodes[0].offsetWidth+15;
			if (w2>w)
				w = w2;
		}
		if (maxW && w>maxW)
			w = maxW-20;
		h1 = this.m_ContentContainer.childNodes[0].offsetHeight+20;
		h2 = 0;
		if (this.m_ControlContainer.childNodes.length>0) 
			h2 = this.m_ControlContainer.childNodes[0].scrollHeight + (ITC.util.IsBrowserInternetExplorer()?12:7);
		if (maxH && h1+h2+this.m_TitleBarContainer.offsetHeight>maxH-50)
			h1 = maxH - h2 - this.m_TitleBarContainer.offsetHeight;
		h = h1 + h2 + this.m_TitleBarContainer.offsetHeight+(ITC.util.IsBrowserInternetExplorer()?9:6);
		this.m_Width = w + 20;
		this.m_Height = h;
		this.m_DialogContainer.style.width = this.m_Width + ''px'';
		this.m_DialogContainer.style.height = this.m_Height + ''px'';
		this.m_ContentContainer.style.height = h1 + ''px'';
		this.m_ControlContainer.style.height = h2 + ''px'';
		left = ITC.dom.GetElementPositionLeft(this.m_DialogContainer);
		top = ITC.dom.GetElementPositionTop(this.m_DialogContainer);
		if (left+this.m_Width > maxW) {
			posX = (maxW - this.m_Width) / 2;
			if (posX<0)
				posX = -2;
			this.m_DialogContainer.style.left = posX + ''px'';
		}
		if (top + this.m_Height > maxH) {
			posY = (maxH - this.m_Height) / 2;
			if (posY<0)
				posY = -2;
			this.m_DialogContainer.style.top = posY + ''px'';
		}
	},
	
	setDialogBoxTitle: function(pTitle) {
		var str;
		try {this.m_Title = pTitle.htmlEncode();}
			catch(e) {}
		if (this.m_TitleBarContainer)
		{
			str=''<a href="#" class="close" onclick="ITC.widget.DialogBox.AllDialogBoxes['' + this.m_ThisDialogBoxIndex + ''].close();"><span class="alt">'' + ITC.translation.DialogCloseLabel + ''</span></a>'';
			if(this.m_HelpPageUrl) str+=''<a href="''+this.m_HelpPageUrl+''" target="_blank" class="help"><span class="alt">'' + ITC.translation.DialogHelpLabel + ''</span></a>'';
			this.m_TitleBarContainer.innerHTML=str+''<div class="DialogBoxTitleText">'' + this.m_Title + ''</div>'';
		}
	},
	
	_initialize: function() {
		var el, fillerEl, posX, posY, i, str;
		var db = this;
		
		this.m_OverlayContainer = document.createElement(''div'');
		this.m_OverlayContainer.className = ''DialogBoxOverlay'';
		this.m_OverlayContainer.style.zIndex = 100 + (this.m_ThisDialogBoxIndex * 3);
		document.body.appendChild(this.m_OverlayContainer);
		el = document.createElement(''div'');
		el.className = ''DialogBox'';
		el.style.zIndex = 100 + (this.m_ThisDialogBoxIndex * 3) + 1;
		el.style.width = this.m_Width + ''px'';
		el.style.height = this.m_Height + ''px'';
		this.m_DialogContainer = el;
		document.body.appendChild(this.m_DialogContainer);
		str = '''';
		if(this.m_FormName) {
			str += ''<form name="'' + this.m_FormName + ''" id="'' + this.m_FormName + ''" method="post" action="'' + this.m_FormAction;
			if (this.m_FormTarget)
				str += ''" target="'' + this.m_FormTarget;
			str += ''"><input type="hidden" name="isFrame" value="true" /><input type="hidden" name="_apa" value="'';
			if (this.m_FormWebAction)
				str += this.m_FormWebAction;
			str += ''" /><input type="hidden" name="ajaxPopUp" value="'' + this.m_ThisDialogBoxIndex + ''" /><input type="hidden" name="_apfn" value="'' + this.m_FormName + ''" />'';
		}
		str += ''<div id="_dbtit'' + this.m_ThisDialogBoxIndex + ''" class="DialogBoxTitleBar"'' + (ITC.util.IsBrowserInternetExplorer?'' onselectstart="return false;"'':'''') + ''></div>'';
		str += ''<div id="_dbcon'' + this.m_ThisDialogBoxIndex + ''" class="DialogBoxContent"></div>'';
		str += ''<div id="_dbctl'' + this.m_ThisDialogBoxIndex + ''" style="overflow:hidden;background-color:#ffffff;border-top:1px solid #c0c0c0;padding-top:5px;"></div>'';
		if (this.m_FormName)
			str += ''</form>'';
		this.m_DialogContainer.innerHTML = str;
		this.m_TitleBarContainer = ITC.dom.GetElement(''_dbtit'' + this.m_ThisDialogBoxIndex);
		this.m_ContentContainer = ITC.dom.GetElement(''_dbcon'' + this.m_ThisDialogBoxIndex);
		this.m_ControlContainer = ITC.dom.GetElement(''_dbctl'' + this.m_ThisDialogBoxIndex);
		this.setDialogBoxTitle(null);
		for(i=0;i<4;i++) {
			el=document.createElement(''div'');
			el.className = ''DialogBoxOutline'';
			el.style.zIndex = 100 + (this.m_ThisDialogBoxIndex * 3) + 2;
			this.m_OutlineContainer[i] = el;
			document.body.appendChild(el);
			ITC.dom.IEDisableSelectFor(el,this);
		}
		posX = (ITC.dom.GetWindowWidth() - this.m_Width) / 2;
		posY = (ITC.dom.GetWindowHeight() - this.m_Height) / 2;
		if (posY<0)
			posY=-2;
		if (posX<0)
			posX=-2;
		this.m_DialogContainer.style.left = posX + ''px'';
		this.m_DialogContainer.style.top = posY + ''px'';
		if (document.all) {
			if (ITC.util.IsBrowserInternetExplorer55Up()) {
				el=document.createElement("iframe");
				el.src="javascript:false";
				el.scrolling="no";
				el.frameborder="0";
				el.style.position="absolute";
				el.style.left=posX + "px";
				el.style.top=posY + "px";
				el.style.width=this.m_Width + "pt";
				el.style.height=this.m_Height + "pt";
				el.style.filter="Alpha(style=0,opacity=0)";
				el.style.zIndex=100+(this.m_ThisDialogBoxIndex * 3);
				this.m_OverlayContainer.appendChild(el);
				this.m_OverlayFrame=el;
			} else {
				this.m_HideAllDropDowns=true;
			}
		}
		if (!!ITC.dom.GetElement(ITC.widget.DialogBox.PostFrameId)) {
			if (ITC.util.IsBrowserInternetExplorer()) {
				el = document.createElement(''<iframe id="'' + ITC.widget.DialogBox.PostFrameId + ''" name="'' + ITC.widget.DialogBox.PostFrameId + ''" />'');
				el.src = ''javascript:false'';
			} else {
				el = document.createElement(''iframe'');
				el.id = ITC.widget.DialogBox.PostFrameId;
				el.name = ITC.widget.DialogBox.PostFrameId;
			}
			el.style.position = ''absolute'';
			el.style.top = ''-1000px'';
			el.style.left = ''-1000px'';
			el.style.width = ''1px'';
			el.style.height = ''1px'';
			el.style.display = ''none'';
			document.body.appendChild(el);
		}
		ITC.event.AddListener(''resize'', window, function() {
			db._onResize();
		}, this);
		ITC.event.AddListener(''mousedown'', this.m_TitleBarContainer, function(pEvent) {
			var e=pEvent?pEvent:window.event;
	
			if ((db.m_Open == true) && (db.m_Dragging !!= true)) {
				db._onMoveBegin(e);
				e.cancelBubble=true;
				if (e.stopPropagation)
					e.stopPropagation();
			}
		}, this);
		ITC.event.AddListener(''mouseup'', document, function() {
			if (db.m_Dragging == true) {
				db._onMoveEnd();
			}
		}, this);
		ITC.event.AddListener(''mousemove'', document, function(pEvent) {
			var e=pEvent?pEvent:window.event;
	
			if ((db.m_Dragging == true) && (db.m_Open == true)) {
				db._onMove(e);
				e.cancelBubble=true;
				if (e.stopPropagation)
					e.stopPropagation();
			}
		}, this);
	},
	
	_repaint: function() {
		var h,usedHeight;
	
		h = 0;
		if (this.m_ControlContainer.childNodes.length>0)
			h = this.m_ControlContainer.childNodes[0].scrollHeight + (ITC.util.IsBrowserInternetExplorer?12:7);
		usedHeight = this.m_TitleBarContainer.offsetHeight + h + (ITC.util.IsBrowserInternetExplorer?9:14);
		this.m_ControlContainer.style.height = h + ''px'';
		this.m_ContentContainer.style.height = (this.m_DialogContainer.offsetHeight - usedHeight) + ''px'';
		this.m_RepaintNeeded = false;
	},
	
	_onResponseReceived: function(pData) {
		this.m_ContentContainer.innerHTML = pData?pData:''&nbsp;'';
	},
	
	_onMoveBegin: function(pEvent) {
		var left, top, width, height, i;
		
		left = ITC.dom.GetElementPositionLeft(this.m_DialogContainer);
		top = ITC.dom.GetElementPositionTop(this.m_DialogContainer);
		width = this.m_DialogContainer.offsetWidth;
		height = this.m_DialogContainer.offsetHeight;
		this.m_Dragging = true;
		this.m_OutlineContainer[0].style.height = height + ''px'';
		this.m_OutlineContainer[1].style.width = width + ''px'';
		this.m_OutlineContainer[0].style.left = left + ''px'';
		this.m_OutlineContainer[0].style.top = top + ''px'';
		this.m_OutlineContainer[1].style.left = left + ''px'';
		this.m_OutlineContainer[1].style.top = top + ''px'';
		this.m_OutlineContainer[2].style.width = width + 4 + ''px'';
		this.m_OutlineContainer[2].style.left = left + ''px'';
		this.m_OutlineContainer[2].style.top = top + height + ''px'';
		this.m_OutlineContainer[3].style.height = height + ''px'';
		this.m_OutlineContainer[3].style.left = left + width + ''px'';
		this.m_OutlineContainer[3].style.top = top + ''px'';
		this.m_XOffset = left - pEvent.clientX;
		this.m_YOffset = top - pEvent.clientY;
		for(i=0;i<4;i++)
			this.m_OutlineContainer[i].style.display = ''block'';
	},
	
	_onMoveEnd: function() {
		var l, t, i;
		
		this.m_Dragging = false;
		l = ITC.dom.GetElementPositionLeft(this.m_OutlineContainer[0]);
		t = ITC.dom.GetElementPositionTop(this.m_OutlineContainer[0]);
		if(l<0)
			l = 0;
		if(t<0)
			t = 0;
		this.setPosition(l, t);
		for(i=0;i<4;i++)
			this.m_OutlineContainer[i].style.display=''none'';
	},
	
	setPosition: function(left,top) {
		this.m_DialogContainer.style.left = left + ''px'';
		this.m_DialogContainer.style.top = top + ''px'';
		if (this.m_OverlayFrame) {
			this.m_OverlayFrame.style.left = left + ''px'';
			this.m_OverlayFrame.style.top = top + ''px'';
		}
	},
	
	_onMove: function(pEvent) {
		var width,height;
		width = this.m_DialogContainer.offsetWidth;
		height = this.m_DialogContainer.offsetHeight;
		this.m_OutlineContainer[0].style.left = (this.m_XOffset + pEvent.clientX) + ''px'';
		this.m_OutlineContainer[0].style.top = (this.m_YOffset + pEvent.clientY) + ''px'';
		this.m_OutlineContainer[1].style.left = (this.m_XOffset + pEvent.clientX) + ''px'';
		this.m_OutlineContainer[1].style.top = (this.m_YOffset + pEvent.clientY) + ''px'';
		this.m_OutlineContainer[2].style.left = (this.m_XOffset + pEvent.clientX) + ''px'';
		this.m_OutlineContainer[2].style.top = (this.m_YOffset + height + pEvent.clientY) + ''px'';
		this.m_OutlineContainer[3].style.left = (this.m_XOffset + width + pEvent.clientX) + ''px'';
		this.m_OutlineContainer[3].style.top = (this.m_YOffset + pEvent.clientY) + ''px'';
	},
	
	_onResize: function() {
		this.m_OverlayContainer.style.width = ITC.dom.GetWindowWidth() + ''px'';
		this.m_OverlayContainer.style.height = ITC.dom.GetWindowHeight() + ''px'';
	}
};

ITC.widget.DialogBox.PostFrameId = ''_apf'';
ITC.widget.DialogBox.LastDialogBoxIndex = 0;
ITC.widget.DialogBox.AllDialogBoxes = [];
ITC.widget.DialogBox.PreviousKeyboardHandler=[];
ITC.widget.DialogBox.GLC = 0;

ITC.widget.DialogBox.GetTopDialogBoxIndex = function() {
	var i, index;

	if (ITC.widget.DialogBox.AllDialogBoxes) {
		for (i=0;i<ITC.widget.DialogBox.AllDialogBoxes.length;i++) {
			if (ITC.widget.DialogBox.AllDialogBoxes[i] && ITC.widget.DialogBox.AllDialogBoxes[i].isOpen()) 
				index=i;
		}
	}
	return index;
};

ITC.widget.DialogBox.GetTopDialogBox = function() {
	return ITC.widget.DialogBox.AllDialogBoxes[ITC.widget.DialogBox.GetTopDialogBoxIndex()];
};

ITC.widget.DialogBox.CloseTopDialogBox = function() {
	if (ITC.widget.DialogBox.GetTopDialogBox())
		ITC.widget.DialogBox.GetTopDialogBox().close();
};

ITC.widget.DialogBox.CloseAllDialogBoxes = function() {
	var dlg, i;
	
	if (ITC.widget.DialogBox.AllDialogBoxes) {
		for (i=ITC.widget.DialogBox.AllDialogBoxes.length-1;i>=0;i--) {
			if ((dlg=ITC.widget.DialogBox.AllDialogBoxes[i]) && dlg.isOpen())
				dlg.close();
		}
	}
};

ITC.widget.DialogBox.BasicCloseAllDialogBoxes = function() {
	var dlg, i;
	
	if (ITC.widget.DialogBox.AllDialogBoxes) {
		for (i=ITC.widget.DialogBox.AllDialogBoxes.length-1;i>=0;i--) {
			if ((dlg=ITC.widget.DialogBox.AllDialogBoxes[i]) && dlg.isOpen())
				dlg.basicClose();
		}
	}
};

ITC.widget.DialogBox.AjaxGetRequest = function(pURL,pDialogBox) {
	var url, topDialogBoxIndex;
	
	if (pURL) {
		if (pDialogBox) {
			if (pDialogBox.isOpen())
				url = pURL + ''&ajaxPopUp='' + pDialogBox.m_ThisDialogBoxIndex;
			else
				return null;
		} else {
			topDialogBoxIndex = ITC.widget.DialogBox.GetTopDialogBoxIndex();
			if (topDialogBoxIndex !!= null)
				url = pURL + ''&ajaxPopUp='' + topDialogBoxIndex;
			else
				url = pURL;
		}
		url = url + ''&_glc='' + (ITC.widget.DialogBox.GLC++);
		(new ITC.ajax.DataRetriever(null, null, true)).sendRequest(url);
	}
};

ITC.widget.DialogBox.AjaxPostRequestForAction = function(srcEl,action) {
	var formEl = srcEl;
	
	while (formEl.tagName.toUpperCase() !!= ''FORM'') {
		if (formEl == formEl.parentNode || !!formEl.parentNode)
			return;
		formEl = formEl.parentNode;
	}
	formEl.target = ITC.widget.DialogBox.PostFrameId;
	formEl._apa.value = action;
	formEl.submit();
	formEl.target = null;
};

ITC.widget.DialogBox.AjaxPostRequestForActionOnElement = function(elForSub, actionForSub, idForSub, urlForSub)
{
	var frmEl, subEl, invDivEl, idForSubEl, parentFormEl, isFrameEl, apaEl, ajaxPopUpEl, apfnEl;

	subEl=ITC.dom.GetElement(elForSub);
	parentFormEl=ITC.dom.FindParentFormFor(subEl);

	frmEl=document.createElement("form");
	with (frmEl)
	{
		innerHTML=subEl.innerHTML;

		if(parentFormEl) target=parentFormEl.target;
		action= urlForSub + "?action=" + actionForSub;
		method="post";
	};

	if(parentFormEl)
	{
		if(parentFormEl.isFrame) isFrameEl=parentFormEl.isFrame.cloneNode(false);
		if(parentFormEl._apa)
		{
			apaEl=parentFormEl._apa.cloneNode(false);
			apaEl.value=actionForSub;
		};
		if(parentFormEl.ajaxPopUp) ajaxPopUpEl=parentFormEl.ajaxPopUp.cloneNode(false);
		if(parentFormEl._apfn) apfnEl=parentFormEl._apfn.cloneNode(false);
	};

	if(isFrameEl) frmEl.appendChild(isFrameEl);
	if(apaEl) frmEl.appendChild(apaEl);
	if(ajaxPopUpEl) frmEl.appendChild(ajaxPopUpEl);
	if(apfnEl) frmEl.appendChild(apfnEl);

	idForSubEl=document.createElement("input");
	with (idForSubEl)
	{
		type="hidden";
		id="idForSub";
		name="idForSub";
		value=idForSub;
	};

	frmEl.appendChild(idForSubEl);

	invDivEl=document.createElement("div");
	invDivEl.style.display="none";

	invDivEl.appendChild(frmEl);
	document.body.appendChild(invDivEl);

	frmEl.submit();
	frmEl.target=null;

	ITC.dom.DisposeElement(invDivEl);
};

//Legacy mappings
LastDialogBoxIndex = ITC.widget.DialogBox.LastDialogBoxIndex;
AllDialogBoxes = ITC.widget.DialogBox.AllDialogBoxes;
getTopDialogBoxIndex = ITC.widget.DialogBox.GetTopDialogBoxIndex;
getTopDialogBox = ITC.widget.DialogBox.GetTopDialogBox;
closeTopDialogBox = ITC.widget.DialogBox.CloseTopDialogBox;
closeAllDialogBoxes = ITC.widget.DialogBox.CloseAllDialogBoxes;
basicCloseAllDialogBoxes = ITC.widget.DialogBox.BasicCloseAllDialogBoxes;
ajaxGetRequest = ITC.widget.DialogBox.AjaxGetRequest;
ajaxPostRequestForAction = ITC.widget.DialogBox.AjaxPostRequestForAction;
ajaxPostRequestForActionOnElement = ITC.widget.DialogBox.AjaxPostRequestForActionOnElement;'!

javascriptPrivateDropDownSuggest
	^'ITC.widget.DropDownSuggest = function(pUrlPrefix, pInputElementId, pControlElementId, pValueElementId, pDisplayIndex, pValueIndex, pShownIndices, pNoResultsLabel, pOnSelectImgElementId) {
	this.m_UrlPrefix = pUrlPrefix?pUrlPrefix:'''';
	if (this.m_UrlPrefix.indexOf(''?'')<0)
		this.m_UrlPrefix += ''?searchString='';
	this.m_InputElement = ITC.dom.GetElement(pInputElementId);
	this.m_ControlElement = ITC.dom.GetElement(pControlElementId);
	this.m_ValueElement = ITC.dom.GetElement(pValueElementId);
	if (pOnSelectImgElementId) {
		if (pOnSelectImgElementId.nodeName == ''IMG'')
			this.m_OnSelectImgElement = pOnSelectImgElementId;
		else
			this.m_OnSelectImgElement = ITC.dom.GetElement(pOnSelectImgElementId);
	} else {
		this.m_OnSelectImgElement = null;
	}
	this.m_Results = new Array();
	this.m_ShownResults = new Array();
	this.m_ResultRows = null;
	this.m_SuggestBox = null;
	this.m_SuggestBoxTable = null;
	this.m_SuggestBoxTableBody = null;
	this.m_NoResultsContainer = null;
	this.m_SuggestIndex = 0;
	this.m_DisplayIndex = pDisplayIndex?pDisplayIndex:0;
	this.m_ValueIndex = pValueIndex?pValueIndex:0;
	this.m_ShownIndices = pShownIndices?pShownIndices:null;
	this.m_NoResultsLabel = pNoResultsLabel?pNoResultsLabel:''No results found'';
	this.m_IsSuggestBoxOpen = false;
	this.m_DataRetriever = null;
	this.m_IsMouseInsideSuggestBox = false;
	this.m_NoResultsTimer = null;
	this.m_AdditionalRequestFields = new Array();
	this.m_LastWrittenString = this.m_InputElement.value;
	this.m_LastValue = this.m_ValueElement?this.m_ValueElement.value:'''';
	this.m_ValueIsSelected = ((this.m_LastValue !!= null) && !!ITC.util.IsUndefined(this.m_LastValue) && (this.m_LastValue !!= ''''))?true:false;
	this.m_OnSelectFunctions = new Array();
	this.m_Open = false;
	this._initialize();
};

ITC.widget.DropDownSuggest.prototype = {
	addOnSelectFunctionBody: function(pString) {
		this.m_OnSelectFunctions[this.m_OnSelectFunctions.length] = new Function(''pData'', pString);
	},
	
	addRequestField: function(pFieldName) {
		this.m_AdditionalRequestFields[this.m_AdditionalRequestFields.length] = pFieldName;
	},
	
	_initialize: function() {
		var dds = this;
		
		this.m_DataRetriever = new ITC.ajax.DataRetriever(this, ''_onResponseReceived'', true);
		this.m_InputElement.autocomplete = ''off'';
		if (this.m_OnSelectImgElement && !!this.m_ValueIsSelected)
			this.m_OnSelectImgElement.style.visibility = ''hidden'';
		this._initializeSuggestBox();
		this._initializeNoResultsContainer();
		this.m_ControlElement.style.pointer = ''pointer'';
		ITC.event.AddListener(''keypress'', this.m_InputElement, function(pEvent) {
			var ev = pEvent?pEvent:window.event;
			dds._onKeyPress(ev);
		});
		ITC.event.AddListener(''keyup'', this.m_InputElement, function(pEvent) {
			var ev = pEvent?pEvent:window.event;
			dds._onKeyUp(ev);
		});
		ITC.event.AddListener(''keydown'', this.m_InputElement, function(pEvent) {
			var ev = pEvent?pEvent:window.event;
			dds._onKeyDown(ev);
		});
		ITC.event.AddListener(''blur'', this.m_InputElement, function(pEvent) {
			if (dds.m_IsMouseInsideSuggestBox == false)
				dds._hideSuggestBox();
		});
		ITC.event.AddListener(''click'', this.m_ControlElement, function(pEvent) {
			dds._retrieveSuggestData();
		});
	},
	
	_initializeSuggestBox: function() {
		var el, leftPos, topPos;
		
		leftPos = ITC.dom.GetElementPositionLeft(this.m_InputElement);
		topPos = ITC.dom.GetElementPositionTop(this.m_InputElement) + this.m_InputElement.offsetHeight;
		el = document.createElement(''div'');
		el.className = ''suggestBox'';
		el.style.position = ''absolute'';
		el.style.left = leftPos + ''px'';
		el.style.top = topPos + ''px'';
		el.style.display = ''none'';
		el.style.zIndex = 998;
		el.style.overflow = ''auto'';
		el.style.overflowX = ''hidden'';
		document.body.appendChild(el);
		this.m_SuggestBox = el;
		el = document.createElement(''table'');
		el.border = 0;
		el.cellPadding = 2;
		el.cellSpacing = 0;
		el.className = ''suggestResultsTable'';
		this.m_SuggestBoxTable = el;
		this.m_SuggestBoxTableBody = document.createElement(''tbody'');
		this.m_SuggestBoxTable.appendChild(this.m_SuggestBoxTableBody);
		this.m_SuggestBox.appendChild(this.m_SuggestBoxTable);
		ITC.dom.InitializeUndercoverFor(this.m_SuggestBox);
	},
	
	_initializeNoResultsContainer: function() {
		var el, leftPos, topPos;
		
		leftPos = ITC.dom.GetElementPositionLeft(this.m_InputElement);
		topPos = ITC.dom.GetElementPositionTop(this.m_InputElement) + this.m_InputElement.offsetHeight;
		el = document.createElement(''div'');
		el.className = ''suggestBoxNoResults'';
		el.style.position = ''absolute'';
		el.style.left = leftPos + ''px'';
		el.style.top = topPos + ''px'';
		el.style.display = ''none'';
		el.style.zIndex = 998;
		el.textAlign = ''center'';
		document.body.appendChild(el);
		this.m_NoResultsContainer = el;
		el.appendChild(document.createTextNode(this.m_NoResultsLabel));
		ITC.dom.InitializeUndercoverFor(this.m_NoResultsContainer);
	},
	
	_showNoResultsBox: function() {
		var leftPos, topPos;
		
		this.m_NoResultsContainer.style.display = ''block'';
		leftPos = ITC.dom.GetElementPositionLeft(this.m_InputElement);
		topPos = ITC.dom.GetElementPositionTop(this.m_InputElement) + this.m_InputElement.offsetHeight;
		if ((leftPos + this.m_NoResultsContainer.offsetWidth) > ITC.dom.GetDocumentWidth()) {
			leftPos = ITC.dom.GetDocumentWidth() - this.m_NoResultsContainer.offsetWidth;
			if (leftPos < 0)
				leftPos = 0;
		}
		if ((topPos + this.m_NoResultsContainer.offsetHeight) > ITC.dom.GetDocumentHeight()) {
			topPos = ITC.dom.GetDocumentHeight() - this.m_NoResultsContainer.offsetHeight;
			if (topPos < 0)
				topPos = 0;
		}
		this.m_NoResultsContainer.style.left = leftPos + ''px'';
		this.m_NoResultsContainer.style.top = topPos + ''px'';
		this.m_Open = false;
		ITC.dom.ShowUndercoverFor(this.m_NoResultsContainer);
	},
	
	_hideNoResultsBox: function() {
		this.m_NoResultsContainer.style.display = ''none'';
		this.m_Open = false;
		ITC.dom.HideUndercoverFor(this.m_NoResultsContainer);
	},
	
	_showSuggestBox: function() {
		var availHeight, leftPos, topPos;
		
		this._hideNoResultsBox();
		this.m_SuggestBox.style.display = ''block'';
		leftPos = ITC.dom.GetElementPositionLeft(this.m_InputElement);
		topPos = ITC.dom.GetElementPositionTop(this.m_InputElement) + this.m_InputElement.offsetHeight;
		if ((leftPos + this.m_SuggestBox.offsetWidth) > ITC.dom.GetDocumentWidth()) {
			leftPos = ITC.dom.GetDocumentWidth() - this.m_SuggestBox.offsetWidth;
			if (leftPos < 0)
				leftPos = 0;
		}
		if ((topPos + this.m_SuggestBox.offsetHeight) > ITC.dom.GetDocumentHeight()) {
			topPos = ITC.dom.GetDocumentHeight() - this.m_SuggestBox.offsetHeight;
			if (topPos < 0)
				topPos = 0;
		}
		this.m_SuggestBox.style.left = leftPos + ''px'';
		this.m_SuggestBox.style.top = topPos + ''px'';
		availHeight = ITC.dom.GetDocumentHeight() - ITC.dom.GetElementPositionTop(this.m_SuggestBox) - 15;
		if (availHeight < 100)
			availHeight = 100;
		if (this.m_SuggestBoxTable.offsetHeight < availHeight)
			availHeight = this.m_SuggestBoxTable.offsetHeight;
		this.m_SuggestBox.style.height = availHeight + ''px'';
		this.m_SuggestBox.style.width = this.m_SuggestBoxTable.offsetWidth + ''px'';
		if (this.m_SuggestBox.clientWidth < this.m_SuggestBox.offsetWidth)
			this.m_SuggestBox.style.width = (2*this.m_SuggestBox.offsetWidth - this.m_SuggestBox.clientWidth) + ''px'';
		this.m_Open = true;
		ITC.dom.ShowUndercoverFor(this.m_SuggestBox);
		this.m_IsSuggestBoxOpen = true;
	},
	
	_hideSuggestBox: function() {
		this.m_SuggestBox.style.display = ''none'';
		this.m_Open = false;
		ITC.dom.HideUndercoverFor(this.m_SuggestBox);
		this.m_IsSuggestBoxOpen = false;
	},
	
	_retrieveSuggestData: function() {
		var i, el, value, parameters = '''';
		if(this.m_InputElement && this.m_InputElement.disabled) return;
		
		for (i=0;i<this.m_AdditionalRequestFields.length;i++) {
			el = ITC.dom.GetElement(this.m_AdditionalRequestFields[i]);
			if (el) {
				if ((el.tagName.toUpperCase() == ''INPUT'') && el.type && (el.type.toUpperCase()  == ''CHECKBOX''))
					value = el.checked?''true'':''false'';
				else if (el.tagName.toUpperCase() == ''SELECT'')
					value = el.options[el.selectedIndex].value;
				else
					value = el.value;
				if (value)
					parameters += ''&'' + this.m_AdditionalRequestFields[i] + ''='' + value.asUrlEncoded();
			}
		}
		this.m_DataRetriever.sendRequest(this.m_UrlPrefix + this.m_InputElement.value.asUrlEncoded() + parameters);
		this.m_InputElement.focus();
	},
	
	_onResponseReceived: function(pData) {
		var dds = this;
	
		delete this.m_Results;
		this.m_Results = pData;
		if (!!this.m_Results || !!this.m_Results.length || !!(this.m_Results.length > 0)) {
			this.m_Results = null;
			this._showNoResultsBox();
			if (this.m_NoResultsTimer)
				clearTimeout(this.m_NoResultsTimer);
			this.m_NoResultsTimer = setTimeout(function() {
				dds._hideNoResultsBox();
			}, 2000);
			return;
		}
		if (this.m_NoResultsTimer)
			clearTimeout(this.m_NoResultsTimer);
		this.m_NoResultsTimer = null;
		this._updateSuggestBox(this.m_Results);
	},
	
	_addRowEventsTo: function(pElement, pIndex) {
		var i = pIndex, dds = this;
	
		ITC.event.AddListener(''mouseover'', pElement, function(pEvent) {
			dds._moveSelection(pIndex);
			dds.m_IsMouseInsideSuggestBox = true;
		});
		ITC.event.AddListener(''mouseout'', pElement, function(pEvent) {
			dds.m_IsMouseInsideSuggestBox = false;
		});
		ITC.event.AddListener(''click'', pElement, function(pEvent) {
			dds._selectResult();
			dds._confirmSelection();
			dds.m_InputElement.focus();
		});
	},
	
	_updateSuggestBox: function(pResults) {
		var i, j, array, row, cell;
		
		delete this.m_ResultRows;
		delete this.m_ShownResults;
		this.m_ResultRows = new Array();
		if (!!pResults || (pResults.length <= 0)) {
			this._hideSuggestBox();
			return;
		}
		this.m_ShownResults = pResults;
		this.m_SuggestBoxTable.removeChild(this.m_SuggestBoxTableBody);
		this.m_SuggestBoxTableBody = document.createElement(''tbody'');
		this.m_SuggestBoxTable.appendChild(this.m_SuggestBoxTableBody);
		if (!!this.m_ShownIndices) {
			this.m_ShownIndices = new Array();
			if (this.m_ShownResults[0].length > 1) {
				for (i=1;i<this.m_ShownResults[0].length;i++)
					this.m_ShownIndices[i - 1] = i;
			} else {
				this.m_ShownIndices[0] = 0;
			}
		}
		for (i=0;i<this.m_ShownResults.length;i++) {
			array = this.m_ShownResults[i];
			row = document.createElement(''tr'');
			if ((i % 2) == 0)
				row.className = ''suggestResultsEven'';
			else
				row.className = ''suggestResultsOdd'';
			this.m_SuggestBoxTableBody.appendChild(row);
			this.m_ResultRows[this.m_ResultRows.length] = row;
			for (j=0;j<this.m_ShownIndices.length;j++) {
				cell = document.createElement(''td'');
				cell.style.whiteSpace = ''nowrap'';
				cell.appendChild(document.createTextNode(array[this.m_ShownIndices[j]]));
				row.appendChild(cell);
			}
			this._addRowEventsTo(row, i);
		}
		this.m_SuggestIndex = -1;
		this._showSuggestBox();
	},
	
	_updateSuggestedValues: function() {
		var data, regEx, match, matchIndex, exactMatch;
		
		if (!!this.m_Results)
			return;
		if (this.m_InputElement.value.length == 0) {
			this._updateSuggestBox(this.m_Results);
			return;
		}
		exactMatch = false;
		data = new Array();
		try{regExp = new RegExp(ITC.util.EncodeForRegEx(this.m_InputElement.value) + ''.*'', ''i'')}catch(e){};
		if(regExp){
			for (i=0;i<this.m_Results.length;i++) {
				match = regExp.exec(this.m_Results[i][this.m_DisplayIndex]);
				if ((match !!= null) && (match.index == 0)) {
				data[data.length] = this.m_Results[i];
				matchIndex = i;
				}
			}
		};
		if (data.length == 0) {
			data = this.m_Results;
		} else if ((data.length == 1) && (data[0][this.m_DisplayIndex] == this.m_InputElement.value)) {
			exactMatch = true;
			data = this.m_Results;
		}
		this._updateSuggestBox(data);
		if (exactMatch)
			this._moveSelection(matchIndex);
	},
	
	_moveSelection: function(pIndex) {
		if (this.m_Open !!= true) {
			this._retrieveSuggestData();
			if (this.m_Open !!= true)
				return;
		}
		if ((this.m_SuggestIndex >= 0) && (this.m_SuggestIndex < this.m_ShownResults.length)) {
			if ((this.m_SuggestIndex % 2) == 0)
				this.m_ResultRows[this.m_SuggestIndex].className = ''suggestResultsEven'';
			else
				this.m_ResultRows[this.m_SuggestIndex].className = ''suggestResultsOdd'';
		}
		this.m_SuggestIndex = pIndex;
		if ((this.m_SuggestIndex < 0) || (this.m_SuggestIndex > (this.m_ShownResults.length - 1))) {
			if (this.m_SuggestIndex < 0)
				this.m_SuggestIndex = this.m_ShownResults.length - 1;
			else
				this.m_SuggestIndex = 0;
		}
		this.m_ResultRows[this.m_SuggestIndex].className = ''suggestResultsSelected'';
	},
	
	_selectResult: function() {
		var i;
		
		if (this.m_Open !!= true)
			return;
		this.m_InputElement.value = this.m_ShownResults[this.m_SuggestIndex][this.m_DisplayIndex];
		if (this.m_ValueElement)
			this.m_ValueElement.value = this.m_ShownResults[this.m_SuggestIndex][this.m_ValueIndex];
		if (this.m_OnSelectImgElement)
			this.m_OnSelectImgElement.style.visibility = ''visible'';
	},
	
	_confirmSelection: function() {
		this.m_LastWrittenString = this.m_InputElement.value;
		this.m_LastValue = this.m_ValueElement?this.m_ValueElement.value:'''';
		try {
			for (i=0;i<this.m_OnSelectFunctions.length;i++)
				this.m_OnSelectFunctions[i](this.m_ShownResults[this.m_SuggestIndex]);
		} catch (e) {
		}
		this._hideSuggestBox();
	},
	
	_onKeyPress: function(pEvent) {
		if (pEvent.keyCode && (pEvent.keyCode == 13) && (this.m_IsSuggestBoxOpen == true)) {
			this._confirmSelection();
			if (document.all) {
				pEvent.cancelBubble = true;
				pEvent.returnValue = false;
			} else {
				pEvent.stopPropagation();
				pEvent.preventDefault();
			}
			return false;
		}
		return true;
	},
	
	_onKeyUp: function(pEvent) {
		switch (pEvent.keyCode) {
			case 9:
			case 13:
			case 16:
			case 38:
			case 40:
			break;
			case 27:
				if (this.m_IsSuggestBoxOpen) {
					this._hideSuggestBox();
					this.m_InputElement.value = this.m_LastWrittenString;
					if (this.m_ValueElement)
						this.m_ValueElement.value = this.m_LastValue;
					if (this.m_OnSelectImgElement) {
						if ((this.m_LastValue !!= null) && !!ITC.util.IsUndefined(this.m_LastValue) && (this.m_LastValue !!= ''''))
							this.m_OnSelectImgElement.style.visibility = ''visible'';
						else
							this.m_OnSelectImgElement.style.visibility = ''hidden'';
					}
					this.m_IsSuggestBoxOpen = false;
				}
			break;
			default:
				this.m_LastWrittenString = this.m_InputElement.value;
				this.m_LastValue = this.m_ValueElement?this.m_ValueElement.value:'''';
				if (this.m_ValueElement)
					this.m_ValueElement.value = '''';
				if (this.m_OnSelectImgElement)
					this.m_OnSelectImgElement.style.visibility = ''hidden'';
				this._updateSuggestedValues();
			break;
		}
		return true;
	},
	
	_onKeyDown: function(pEvent) {
		switch (pEvent.keyCode) {
			case 38:
				this._moveSelection(this.m_SuggestIndex-1);
				this._selectResult();
			break;
			case 40:
				this._moveSelection(this.m_SuggestIndex+1);
				this._selectResult();
			break;
		}
		return true;
	}
};'!

javascriptPrivateEditableDropDown
	^'ITC.widget.EditableDropDown = function(pInputElementId, pHiddenFieldId, pImageId, pValues) {
	this.m_InputElement = new ITC.dom.Element(pInputElementId);
	this.m_HiddenField = pHiddenFieldId?new ITC.dom.Element(pHiddenFieldId):null;
	this.m_Image = pImageId?new ITC.dom.Element(pImageId):null;
	this.m_Container = null;
	this.m_DropDown = null;
	this.m_TypingTimer = null;
	this.m_LastTypedText = null;
	this.m_Closing = false;
	this.m_ValuesInitialized = false;
	this.m_Values = pValues;
	this.m_Open = false;
	this.m_OnChangeFunctions = new Array();
	this._initialize();
};

ITC.widget.EditableDropDown.prototype = {
	setValues: function(pValues) {
		this.m_Values = pValues;
	},
	
	isOpen: function() {
		return (this.m_Open == true);
	},
	
	addOnChangeFunction: function(pFunction) {
		this.m_OnChangeFunctions[this.m_OnChangeFunctions.length] = pFunction;
	},
	
	addOnChangeFunctionBody: function(pString) {
		this.m_OnChangeFunctions[this.m_OnChangeFunctions.length] = new Function(''pValue'', pString);
	},
	
	isInternalClick: function(pEvent) {
		return ITC.dom.IsMouseInsideElement(this.m_DropDown, pEvent);
	},
	
	_updateOnChangeFunctions: function(pValue) {
		var i;
	
		for (i=0;i<this.m_OnChangeFunctions.length;i++)
			this.m_OnChangeFunctions[i](pValue);
	},
	
	_initialize: function() {
		var edd = this;
		var el;
		
		this.m_Container = document.createElement(''div'');
		document.body.appendChild(this.m_Container);
		this.m_Container.style.position = ''absolute'';
		this.m_Container.style.zIndex = 10;
		el = document.createElement(''select'');
		el.multiple = true;
		this.m_Container.appendChild(el);
		this.m_DropDown = el;
		if (this.m_Values)
			this._updateValues();
		this.m_Container.style.display = ''none'';
		this.m_InputElement.dom.autocomplete = ''off'';
		ITC.event.AddListener(''blur'', this.m_DropDown, function(pEvent) {
			if (this.m_ValuesInitialized == true)
				edd._hide();
		});
		ITC.event.AddListener(''mousedown'', this.m_DropDown, function(pEvent) {
			setTimeout(function() {
				edd._hide();
				try {
					edd.m_InputElement.focus();
				} catch (e) {
				}
			}, 100);
		});
		ITC.event.AddListener(''keydown'', this.m_DropDown, function(pEvent) {
			if (ITC.event.GetCharCode(ITC.event.GetEvent(pEvent)) == 27) {
				edd._hideOnly();
				try {
					edd.m_InputElement.focus();
				} catch (e) {}
			}
		});
		ITC.event.AddListener(''focus'', this.m_DropDown, function(pEvent) {
			edd.m_Closing = false;
		});
		ITC.event.AddListener(''blur'', this.m_InputElement.dom, function() {
			edd.m_Closing = true;
			setTimeout(function() {
				if (edd.m_Closing)
					edd._hideOnly();
			}, 1000);
		});
		ITC.event.AddListener(''keydown'', this.m_InputElement.dom, function(pEvent) {
			edd._onKeyDown(ITC.event.GetEvent(pEvent));
		});
		if (this.m_Image) {
			ITC.event.AddListener(''mousedown'', this.m_Image.dom, function(pEvent) {
				this.m_Closing = false;
				edd._show();
				edd.m_DropDown.focus();
			});
		}
	},
	
	_show: function() {
		var leftPos, topPos;
		
		this._updateValues();
		this.m_Container.style.display = ''block'';
		leftPos = this.m_InputElement.getLeft();
		topPos = this.m_InputElement.getTop() + this.m_InputElement.getHeight();
		if ((leftPos + this.m_Container.offsetWidth) > ITC.dom.GetDocumentWidth()) {
			leftPos = ITC.dom.GetDocumentWidth() - this.m_Container.offsetWidth;
			if (leftPos < 0)
				leftPos = 0;
		}
		if ((topPos + this.m_Container.offsetHeight) > ITC.dom.GetDocumentHeight()) {
			topPos = ITC.dom.GetDocumentHeight() - this.m_Container.offsetHeight;
			if (topPos < 0)
				topPos = 0;
		}
		this.m_Container.style.left = leftPos + ''px'';
		this.m_Container.style.top = topPos + ''px'';
		this.m_Open = true;
	},
	
	_hide: function() {
		if (!!this.isOpen())
			return;
		if (this.m_DropDown.selectedIndex >= 0) {
			if (this.m_HiddenField) {
				this.m_HiddenField.dom.value = this.m_DropDown.options[this.m_DropDown.selectedIndex].value;
				this.m_InputElement.dom.value = this.m_DropDown.options[this.m_DropDown.selectedIndex].text;
			} else {
				this.m_InputElement.dom.value = this.m_DropDown.options[this.m_DropDown.selectedIndex].value;
			}
			this._updateOnChangeFunctions(this.m_DropDown.options[this.m_DropDown.selectedIndex].value);
		}
		this._hideOnly();
	},
	
	_hideOnly: function() {
		this.m_Open = false;
		this.m_Container.style.display = ''none'';
	},
				
	_updateValues: function() {
		var matchIndex = null;
		var exactMatch = false;
		var regEx;
		try{regEx = new RegExp(ITC.util.EncodeForRegEx(this.m_InputElement.dom.value) + ''.*'', ''i'')}catch(e){};
		var match, i, options, newOption, range, enteredValue, str;
		var isValsSelect, vals;
		
		if (ITC.util.IsArray(this.m_Values)) {
			vals = this.m_Values;
			isValsSelect = false;
		} else {
			vals = ITC.dom.GetElement(this.m_Values).options;
			isValsSelect = true;
		}
		this.m_ValuesInitialized = false;
		options = new Array();
		if (regEx && this.m_InputElement.dom.value.length > 0) {
			for (i=0;i<vals.length;i++) {
				match = isValsSelect?regEx.exec(vals[i].text):regEx.exec(vals[i][1]);
				if ((match !!= null) && (match.index == 0)) {
					options[options.length] = vals[i];
					matchIndex = i;
				}
			}
		}
		if (options.length == 0) {
			options = vals;
		} else if ((options.length == 1) && ((isValsSelect?options[0].text:options[0][1]) == this.m_InputElement.dom.value)) {
			exactMatch = true;
			options = vals;
		}
		str = '''';
		if (isValsSelect) {
			for (i=0;i<options.length;i++)
				str += ''<option value="'' + options[i].value + ''"'' + ((exactMatch && (i == matchIndex))?''selected'':'''') + ''>'' + options[i].text + ''</option>'';
		} else {
			for (i=0;i<options.length;i++)
				str += ''<option value="'' + options[i][0] + ''"'' + ((exactMatch && (i == matchIndex))?''selected'':'''') + ''>'' + options[i][1] + ''</option>'';
		}
		this.m_DropDown.innerHTML = str;
		this.m_ValuesInitialized = true;
	},
	
	_clearAll: function() {
		var i;
		var formValue = this.m_HiddenField?this.m_HiddenField.dom.value:this.m_InputElement.dom.value;
		
		this.m_DropDown.focus();
		for(i=0;i<this.m_DropDown.options.length;i++)
	  		if (this.m_DropDown.options[i].value == formValue)
				this.m_DropDown.options[i].selected = true
	  		else
	  			this.m_DropDown.options[i].selected = false;
	},
	
	_onKeyDown: function(pEvent) {
		var edd = this;
		var el;
		var code = ITC.event.GetCharCode(pEvent);
		
		if ((code==27) || (code==13) || (code==38) || (code==40) || (code==9) || (code==37) || (code==39) || (code==16)) {
			if (this.isOpen()) {
				if (code == 13) {
		//			if ((el.selectedIndex || (el.selectedIndex == 0)) && (el.selectedIndex >= 0))
					this._hide();
				} else if (code==27) {
					this._hideOnly();
				} else {
					el = this.m_DropDown;
					if (!!(el.selectedIndex >= 0)) {
						el.selectedIndex = 0;
					} else {
						if (code == 38) {
							if (el.selectedIndex<=0)
								el.selectedIndex = el.options.length-1; 
							else
								el.selectedIndex--;
						} else {
							if ((el.selectedIndex+1)>=el.options.length)
								el.selectedIndex = 0;
							else
								el.selectedIndex++;
						}
					}
				}
				ITC.event.StopEvent(pEvent);
			}
			return;
		}
		if (this.m_LastTypedText == this.m_InputElement.dom.value)
			return;
		if (this.m_HiddenField && (this.m_HiddenField.dom.value !!= ''''))
			this.m_HiddenField.dom.value = '''';
		if (this.m_TypingTimer) 
			clearTimeout(this.m_TypingTimer);
		this.m_TypingTimer = setTimeout(function() {
			edd._updateValues();
			edd._show();
		}, 500);
		this.m_LastTypedText = this.m_InputElement.dom.value;
	}
};'!

javascriptPrivateHideableContainer
	^'ITC.widget.HideableContainer = function(pWidth, pHeight, pHorizontalSlideStep, pVerticalSlideStep, pSlideClosing) {
	this.m_Width = pWidth;
	this.m_Height = pHeight;
	this.m_HorizontalSlideStep = pHorizontalSlideStep?pHorizontalSlideStep:0;
	this.m_VerticalSlideStep = pVerticalSlideStep?pVerticalSlideStep:0;
	this.m_SlideClosing = pSlideClosing==true;
	this.m_Container = null;
	this.m_ContentContainer = null;
	this.m_BarContainer = null;
	this.m_SlidingTimer	= null;
	this.m_Opening = false;
	this.m_Closing = false;
	this.m_RealWidth = null;
	this.m_RealHeight = null;
	this._initialize();
};

ITC.widget.HideableContainer.prototype = {
	setContent: function(pContent) {
		this.m_ContentContainer.innerHTML = pContent;
	},
	
	setHorizontalSlideStep: function(pStep) {
		this.m_HorizontalSlideStep = pStep;
	},
	
	setVerticalSlideStep: function(pStep) {
		this.m_VerticalSlideStep = pStep;
	},
	
	show: function(pX, pY, pShowBar, pContent) {
		var cw, ch;
		
		this.m_Closing = false;
		this.m_Opening = true;
		if (pShowBar == true)
			this.m_BarContainer.style.display = ''block'';
		else
			this.m_BarContainer.style.display = ''none'';
		if (pContent)
			this.setContent(pContent);
		this.m_Container.style.left = pX + ''px'';
		this.m_Container.style.top = pY + ''px'';
		this.m_Container.style.display = ''block'';
		ITC.dom.ShowUndercoverFor(this.m_Container);
		cw = this.m_HorizontalSlideStep > 0?0:this.m_RealWidth;
		ch = this.m_VerticalSlideStep > 0?0:this.m_RealHeight;
		if (this._doSlide())
			this._slide(cw, ch, 1);
	},
	
	hide: function() {
		this.m_Opening = false;
		this.m_Closing = true;
		if ((this.m_SlideClosing == true) && this._doSlide())
			this._slide(this.m_RealWidth, this.m_RealHeight, -1);
		else
			this.hideOnly();
	},
	
	hideOnly: function() {
		this.m_Container.style.display = ''none'';
		ITC.dom.HideUndercoverFor(this.m_Container);
		this.m_Closing = false;
	},
	
	setParentContainer: function(pParentContainer) {
		if (!!pParentContainer)
			return;
		pParentContainer.appendChild(this.m_Container);
	},
	
	_doSlide: function() {
		return ((this.m_HorizontalSlideStep > 0) || (this.m_VerticalSlideStep > 0));
	},
	
	_initialize: function() {
		var hc = this;
		var el, img;
		
		el = document.createElement(''div'');
		el.className = ''HideableContainer'';
		el.style.position = ''absolute'';
		el.style.overflow = ''auto'';
		el.style.width = this.m_Width;
		el.style.height = this.m_Height;
		document.body.appendChild(el);
		this.m_RealWidth = el.offsetWidth;
		this.m_RealHeight = el.offsetHeight;
		el.style.display = ''none'';
		this.m_Container = el;
		el = document.createElement(''div'');
		el.style.height = ''10pt'';
		el.style.textAlign = ''right'';
		el.style.backgroundColor = ''#bbbbbb'';
		img = document.createElement(''img'');
		img.src = ''images/koledarClose.gif'';
		img.style.border = ''1px solid black'';
		img.alt = ''Close'';
		img.title = ''Close'';
		ITC.event.AddListener(''click'', img, function(pEvent) {
			hc.hide();
		});
		el.appendChild(img);
		this.m_BarContainer = el;
		this.m_Container.appendChild(this.m_BarContainer);
		this.m_ContentContainer = document.createElement(''div'');
		this.m_Container.appendChild(this.m_ContentContainer);
		ITC.dom.InitializeUndercoverFor(this.m_Container);
	},
	
	_slide: function(pClipWidth, pClipHeight, pDirection) {
		var hc = this;
		var cw = pClipWidth, ch = pClipHeight;
		var slideAgain = false;
		
		if (((pDirection < 0) && !!this.m_Closing) || ((pDirection > 0) && !!this.m_Opening))
			return;
		if (pDirection < 0) {
			if (this.m_HorizontalSlideStep > 0) {
				cw -= this.m_HorizontalSlideStep;
				if (cw < 0)
					cw = 0;
				else
					slideAgain = true;
			}
			if (this.m_VerticalSlideStep > 0) {
				ch -= this.m_VerticalSlideStep;
				if (ch < 0)
					ch  = 0;
				else
					slideAgain = true;
			}
		} else {
			if (this.m_HorizontalSlideStep > 0) {
				cw += this.m_HorizontalSlideStep;
				if (cw > this.m_RealWidth)
					cw = this.m_RealWidth;
				else
					slideAgain = true;
			}
			if (this.m_VerticalSlideStep > 0) {
				ch += this.m_VerticalSlideStep;
				if (ch > this.m_RealHeight)
					ch  = this.m_RealHeight;
				else
					slideAgain = true;
			}
		}
		this.m_Container.style.clip = ''rect(0px, '' + cw + ''px, '' + ch + ''px, 0px)'';
		if (this.m_CoverFrame)
			this.m_CoverFrame.style.clip = ''rect(0px, '' + cw + ''px, '' + ch + ''px, 0px)'';
		if (slideAgain) {
			this.m_SlidingTimer = setTimeout(function() {
				hc._slide(cw, ch, pDirection);
			}, 50);
			return;
		}
		if (pDirection < 0)
			this.hideOnly();
		else
			this.Opening = false;
	}
};'!

javascriptPrivateItcAjax
	^'ITC.ajax = {
	_RegisteredErrorGroups: null,
	_GetRegisteredErrorGroups: function() {
		if (!!this._RegisteredErrorGroups)
			this._RegisteredErrorGroups = new Hashtable();
		return this._RegisteredErrorGroups;
	},
	_FillElement: function(pElement, pData) {
		var i, str;
		
		if (pElement.length) {
			for (i=0;i<pElement.lenght;i++) {
				if ((pElement[i].nodeName !!= ''INPUT'') || (pElement[i].type.toUpperCase() !!= ''RADIO''))
					throw ''ItcAjax._FillElement: pElement should be an array of radio buttons!!'';
				pElement[i].checked = pElement[i].value == pData;
			}
			return;
		}
		switch (pElement.nodeName) {
			case ''INPUT'':
				if ((pElement.type.toUpperCase() == ''TEXT'') || (pElement.type.toUpperCase() == ''HIDDEN''))
					pElement.value = pData;
				else if (pElement.type.toUpperCase() == ''CHECKBOX'')
					pElement.checked = pData == true;
				else
					throw ''ItcAjax._FillElement: pElement should be either TEXT or CHECKBOX'';
			break;
			case ''SELECT'':
				if (typeof pData == ''object'') {
					pElement.innerHTML = '''';
					str = '''';
					for (i=0;i<pData.options.length;i++)
						str += ''<option value="'' + pData.options[i].value + ''"'' + (pData.options[i].value==pData.value?'' selected="selected"'':'''') + ''>'' + (pData.options[i].text?pData.options[i].text:'''') + ''</option>'';
					pElement.innerHTML = str;
				} else {
					for (i=0;i<pElement.options;i++) {
						if (pElement.options[i].value == pData) {
							pElement.options[i].selected = true;
							return;
						}
					}
				}
			break;
			case ''TEXTAREA'':
				pElement.text = pData;
			break;
			default:
				throw ''ItcAjax._FillElement: nodeName '' + pElement.nodeName + '' not supported!!'';
		}
	},
	FillElementsFromJSON: function(pJSON) {
		var el, key, value;
		
		for (key in pJSON) {
			value = pJSON[key];
			if (el = ITC.dom.GetElement(key)) {
				
			}
		}
	},
	FindFormFor: function(pElement) {
		var el = pElement;
				
		while (el) {
			if (el.tagName == ''FORM'')
				return el;
			el = el.parentNode;
		}
		return null;
	},
	AddErrorToField: function(pFieldName, pErrorText, pHashtable) {
		var el, errorFieldName, field = ITC.dom.GetElement(pFieldName);
		
		if (!!field)
			return;
		errorFieldName = pFieldName + ''_error___'';
		if (!!(el = ITC.dom.GetElement(errorFieldName))) {
			el = document.createElement(''span'');
			el.id = errorFieldName;
			el.className = ''ErrorMessage'';
			field.parentNode.appendChild(el);
			pHashtable.put(pFieldName, el);
		}
		el.innerHTML = ''<br />'' + pErrorText;
		
	},
	AddErrors: function(pErrors, pErrorGroup) {
		var i, el, newDict, dict, keys;
		
		if (!!pErrorGroup)
			return;
		if (!!pErrors)
			return;
		newDict = new Hashtable();
		for (i=0;i<pErrors.length;i++)
			this.AddErrorToField(pErrors[i][0], pErrors[i][1], newDict);
		if (dict = this._GetRegisteredErrorGroups().get(pErrorGroup)) {
			keys = dict.getKeys();
			for (i=0;i<keys.length;i++) {
				if (!!newDict.containsKey(keys[i])) {
					try {
						el = dict.get(keys[i]);
						el.parentNode.removeChild(el);
					} catch(e) {
						alert(''ItcAjax.AddError: '' + e);
					}
				}
			}
			dict.clear();		
		}
		this._GetRegisteredErrorGroups().put(pErrorGroup, newDict);
	}
};

ITC.ajax.Request = function(pOptions) {
	var dr, cb, url, fnc;
	
	cb = {
		onSuccess: function(pData) {
			var result = {};
			
			result.responseText = pData;
			result.options = pOptions;
			fnc = ITC.util.IsFunction(pOptions.callback)?pOptions.callback:(pOptions.callback?pOptions.callback.success:null);
			if (ITC.util.IsFunction(fnc))
				fnc(result);
		}
	};
	dr = new ITC.ajax.DataRetriever(cb, ''onSuccess'', true, true, null, true);
	dr.sendRequest(pOptions.url);
};

ITC.ajax.DataRetriever = function(pHandlerObject, pResponseFunctionName, pUseXmlHttp, pShowWholePage, pMaxTimeForResponse, pReturnRawData) {
	this.m_HandlerObject = pHandlerObject;
	this.m_ResponseFunctionName = pResponseFunctionName;
	this.m_UseXmlHttp = pUseXmlHttp==false?false:true;
	this.m_ShowWholePage = pShowWholePage==true?true:false;
	this.m_MaxTimeForResponse = pMaxTimeForResponse?pMaxTimeForResponse:10000;
	this.m_ReturnRawData = pReturnRawData==true?true:false;
	this.m_XmlHttp = null;
	this.m_XmlDataFrame = null;
	this.m_DataFrameReady = false;
	this.m_UrlPrefix = '''';
	this.m_ResponseTimer = null;
	this.m_WaitingForResponse = false;
	this.m_RequestQueue = new Array();
	this.m_RequestDataQueue = new Array();
	this._initialize();
}

ITC.ajax.DataRetriever.prototype = {
	setUrlPrefix: function(pUrlPrefix) {
		this.m_UrlPrefix = pUrlPrefix?pUrlPrefix:'''';
	},
	
	sendRequest: function(pUrl, pFormOrName) {
		this._sendRequestSynchronized(pUrl, pFormOrName);
	},
	
	_clearWaitForResponseTimer: function() {
		this.m_WaitingForResponse = false;
		if (this.m_ResponseTimer)
			clearTimeout(this.m_ResponseTimer);
	},
	
	_sendRequestSynchronized: function(pUrl, pFormOrName) {
		this.m_RequestQueue[this.m_RequestQueue.length] = pUrl;
		this.m_RequestDataQueue[this.m_RequestDataQueue.length] = this._createRequestStringForForm(pFormOrName);
		if (this.m_WaitingForResponse !!= true)
			this._sendNextRequest();
	},
	
	_sendNextRequest: function() {
		var nextUrl, nextData;
		var dr = this;
	
		if (this.m_RequestQueue.length == 0)
			return;
		nextUrl = this.m_RequestQueue[this.m_RequestQueue.length-1];
		nextData = this.m_RequestDataQueue[this.m_RequestDataQueue.length-1];
		this.m_RequestQueue.splice(this.m_RequestQueue.length-1, 1);
		this.m_RequestDataQueue.splice(this.m_RequestDataQueue.length-1, 1);
		try {
			if (this.m_ResponseTimer)
				clearTimeout(this.m_ResponseTimer);
		} catch (e) {
		}
		if (this.m_MaxTimeForResponse > 0) {
			this.m_ResponseTimer = setTimeout(function() {
				dr._clearWaitForResponseTimer();
				if (dr.m_XmlHttp)
					dr.m_XmlHttp.abort();
				dr._sendNextRequest();
			}, this.m_MaxTimeForResponse);
		}
		this._sendRequest(nextUrl, 3);
	},
	
	_collectFormDataFor: function(pFormOrName) {
		var form, el, i, allElements, type, includeInRequest;
		var result = new Array();
	
		if (!!pFormOrName)
			return result;
		form = (pFormOrName.nodeName == ''FORM'')?pFormOrName:ITC.dom.GetElement(pFormOrName);
		allElements = form.getElementsByTagName (''INPUT'');
		for (el in allElements) {
			type = el.type.toUpperCase();
			includeInRequest = true;
			if ((type == ''CHECKBOX'') || (type == ''RADIO'')) {
				if (el.checked == false)
					includeInRequest = false;
			}
			if (includeInRequest == true)
				result[el.name] = el.value;
		}
		allElements = form.getElementsByTagName (''SELECT'');
		for (el in allElements)
			result[el.name] = el.options[el.selectedIndex].value;
		return result;
	},
	
	_createRequestStringForForm: function(pFormOrName) {
		var formData = this._collectFormDataFor(pFormOrName);
		var result = '''';
	
		for (var n in formData) {
			if (result.length == 0)
				result += ''&'';
			result += escape(n) + ''='' + escape(formData[n]);
		}
		return result;
	},
	
	_sendRequest: function(pUrl, pNumOfTries) {
		var dr = this;
		
		try {
			this.m_WaitingForResponse = true;
			if (this.m_XmlHttp) {
				this.m_XmlHttp.open(''GET'', this.m_UrlPrefix + pUrl, true);
				this.m_XmlHttp.onreadystatechange = function() {
					dr._onResponseReceived();
				};
				this.m_XmlHttp.send(null);
			} else {
				this.m_XmlDataFrame.location.href = this.m_UrlPrefix + pUrl + ''&isFrame=true'';
			}
		} catch (e) {
			if (pNumOfTries && (pNumOfTries>0))
				this._sendRequest(pUrl, pNumOfTries-1);
			else
				this._invokeOnDataRetrieved(null);
		}
	},
	
	_initialize: function() {
		if (this.m_UseXmlHttp == true) {
			try {
				this.m_XmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				try {
					this.m_XmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e) {
					try {
						this.m_XmlHttp = new XMLHttpRequest();
					} catch (e) {
						this.m_XmlHttp = null;
					}
				}
			}
		}
		if (!!this.m_XmlHttp) {
			this._initializeXmlDataFrame();
			this.m_DataFrameReady = true;
		}
	},
	
	_initializeXmlDataFrame: function() {
		var el, name, dr = this;
		
		name = ''DataFrame_'' + Math.random(100000);
		el = document.createElement(''iframe'');
		el.name = name;
		el.id = name;
		el.style.display = ''none'';
		el.src = ''javascript:false'';
		document.body.appendChild(el);
		if (frames && frames[name])
			el = frames[name];
		else
			el = ITC.dom.GetElement(name);
		ITC.event.AddListener(''load'', ITC.dom.GetElement(name), function() {
			dr._onXmlDataFrameLoaded();
		});
		this.m_XmlDataFrame = el;
	},
	
	_onXmlDataFrameLoaded: function() {
		var retrievedData;
	
		if (!!this.m_DataFrameReady || (this.m_XmlDataFrame.location.toString().indexOf(''javascript:false'') == 0))
			return;
		if (this.m_ShowWholePage==true)
			retrievedData = this.m_XmlDataFrame.document.body.innerHTML;
		else
			retrievedData = this.m_XmlDataFrame.xmlData;
		this._invokeOnDataRetrieved(retrievedData);
	},
	
	_onResponseReceived: function() {
		var retrievedData;
		if (this.m_XmlHttp.readyState !!= 4) return;
		if (this.m_ReturnRawData)
			retrievedData = this.m_XmlHttp.responseText;
		else
			retrievedData = (this.m_XmlHttp.responseText=='''')?null:eval(this.m_XmlHttp.responseText);
		this._invokeOnDataRetrieved(retrievedData);
	},
	
	_invokeOnDataRetrieved: function(pData) {
		var func, result = null;
		
		if (this.m_WaitingForResponse !!= true)
			return;
		if (this.m_HandlerObject) {
			func = new Function(''pObject'', ''pData'', ''return pObject.'' + this.m_ResponseFunctionName + ''(pData);'');
			result = func(this.m_HandlerObject, pData);
		} else {
			if(this.m_ResponseFunctionName)
			{
				func = new Function(''pData'', ''return '' + this.m_ResponseFunctionName + ''(pData);'');
				result = func(pData);
			}
			else {if(this.m_XmlHttp) this.m_XmlHttp.onreadystatechange=function(){};this.m_XmlHttp=null;eval(pData);}
		}
		try {
			this.m_WaitingForResponse = false;
			this._sendNextRequest();
		} catch (e) {
		}
		return result;
	}
};'!

javascriptPrivateItcCss
	^'ITC.css = {
	RulesCache: null,
	GetRules: function(pReload) {
		var i, j, rules;
		
		if (!!this.RulesCache || pReload) {
			this.RulesCache = new ITC.util.Hashtable();
			for (i=0;i<document.styleSheets.length;i++) {
				try {
					rules = document.styleSheets[i].cssRules || document.styleSheets[i].rules;
					for (j=0;j<rules.length;j++) {
						this.RulesCache.put(rules[j].selectorText, rules[j]);
					}
				} catch (e) {}
			}
		}
		return this.RulesCache;
	},
	GetRule: function(pSelector, pReload) {
		var rules = this.GetRules(pReload);
		
		return rules.get(pSelector);
	},
	GetElementStyle: function(pElement, pProperty) {
		var cssProp, i, len, prevCh, result = null;
		
		if (pElement.currentStyle) {
			cssProp = '''';
			prevCh = pProperty.charAt(0);
			len = pProperty.length;
			for (i=1;i<=len;i++) {
				cssProp += (prevCh == ''-'')?pProperty.charAt(i++).toUpperCase():prevCh;
				if (i<len)
					prevCh = pProperty.charAt(i);	
			}
			result = pElement.currentStyle[cssProp];
		} else if (window.getComputedStyle) {
			result = document.defaultView.getComputedStyle(pElement, null).getPropertyValue(pProperty);
		}
		return result;
	}
};'!

javascriptPrivateItcDom
	^'ITC.dom = {
	_RegisteredUndercovers: new ITC.util.Hashtable(),
	UndercoverStructure: function() {
		this.m_IFrame = null;
		this.m_HideAllDropDowns = false;
	},
	GetElement: function(pHtmlElementOrIdOrName, pForm) {
		var dom, frm, i, el;
		
		if (!!pHtmlElementOrIdOrName)
			return null;
		if (pHtmlElementOrIdOrName.nodeName) {
			dom = pHtmlElementOrIdOrName;
		} else {
			dom = (document.all && !!document.getElementById)?document.all[pHtmlElementOrIdOrName]:document.getElementById(pHtmlElementOrIdOrName);
			if (!!dom) {
				if (document.getElementsByName) {
					dom = document.getElementsByName(pHtmlElementOrIdOrName);
					if (dom) {
						if (dom.length == 1) {
							dom = dom[0];
						} else if (!!pForm) {
							dom = null;
						} else {
							for (i=0;i<dom.length;i++) {
								el = dom[i];
								if (ITC.dom.FindParentFormFor(el) == pForm) {
									dom = el;
									break; 
								}
							}
							if (dom.length)
								dom = null;
						}
					} else {
						dom = null;
					}
				}
			}
		}
		if (!!dom)
			dom = null;
		return dom;
	},
	GetTopWindow: function() {
		var currWin = window;
	
		while (currWin !!= currWin.parent) {
			currWin = currWin.parent;
		}
		return currWin;
	},
	GetDocumentWidth: function() {
		if (window.innerWidth)
			return window.innerWidth;
		else if (document.all && document.documentElement && document.documentElement.clientWidth)
			return document.documentElement.clientWidth;
		return document.body.clientWidth;
	},
	GetDocumentHeight: function() {
		if (window.innerHeight)
			return window.innerHeight;
		else if (document.documentElement && (document.documentElement.clientHeight > 0))
			return document.documentElement.clientHeight;
		return document.body.clientHeight;
	},
	GetWindowWidth: function() {
		var win = ITC.dom.GetTopWindow();
	
		if (win.innerWidth !!= window.undefined)
			return win.innerWidth; 
		if (document.compatMode == ''CSS1Compat'')
			return win.document.documentElement.clientWidth; 
		if (document.body)
			return win.document.body.clientWidth; 
		return 0;
	},
	GetWindowHeight: function() {
		var win = ITC.dom.GetTopWindow();
	
		if (win.innerHeight !!= window.undefined)
			return win.innerHeight;
		if (document.compatMode == ''CSS1Compat'')
			return win.document.documentElement.clientHeight;
		if (document.body)
			return win.document.body.clientHeight; 
		return 0;
	},
	CenterElement: function(pElement) {
		var w, h, vw, vh, sl, st;
		
		w = pElement.offsetWidth;
		h = pElement.offsetHeight;
		vw = ITC.dom.GetWindowWidth();
		vh = ITC.dom.GetWindowHeight();
		sl = parseInt(document.documentElement.scrollLeft, 10);
		st = parseInt(document.documentElement.scrollTop, 10);
		pElement.style.left = (((vw - w) / 2) + sl) + ''px'';
		pElement.style.top = (((vh - h) / 2) + st) + ''px'';
	},
	GetElementPositionLeft: function(pElement) {
		var result = 0, border, el = pElement;
		
		result = pElement.offsetLeft;
		el = pElement.offsetParent;
		while (el) {
			result += el.offsetLeft;
			border = parseInt(ITC.css.GetElementStyle(el, ''border-left-width''), 10) || 0;
			result += border;
			if (!!document.all && (el !!= pElement) && ITC.css.GetElementStyle(el, ''overflow'') !!= ''visible'')
				result += border;
			el = el.offsetParent;
		}
		return result;
	},
	GetElementPositionTop: function(pElement) {
		var result = 0, border, el = pElement;
		
		result = pElement.offsetTop;
		el = pElement.offsetParent;
		while (el) {
			result += el.offsetTop;
			border = parseInt(ITC.css.GetElementStyle(el, ''border-top-width''), 10) || 0;
			result += border;
			if (!!document.all && (el !!= pElement) && ITC.css.GetElementStyle(el, ''overflow'') !!= ''visible'')
				result += border;
			el = el.offsetParent;
		}
		return result;
	},	
	GetElementScrollLeft: function(pElement) {
		var result = 0, tmpEl = pElement.parentNode;
			
		if(tmpEl)
		{
			while (tmpEl !!= document.body)
			{
				if(tmpEl.scrollLeft)
				{
					result += tmpEl.scrollLeft;
				};
			tmpEl = tmpEl.parentNode;
			}
		};
		return result;
	},
	GetElementScrollTop: function(pElement) {
		var result = 0, tmpEl = pElement.parentNode;
			
		if(tmpEl)
		{
			while (tmpEl !!= document.body)
			{
				if(tmpEl.scrollTop)
				{
					result += tmpEl.scrollTop;
				};
			tmpEl = tmpEl.parentNode;
			}
		};
		return result;
	},	
	GetInlineElementPositionLeft: function(pElement, pContainerElement) {
		var result = 0;
		
		if (!!pContainerElement)
			return ITC.dom.GetElementPositionLeft(pElement);
		if (pElement.offsetParent) {
			while (pElement.offsetParent && (pElement.offsetParent !!= pContainerElement)) {
				result += pElement.offsetLeft
				pElement = pElement.offsetParent;
			}
		} else if (pElement.x) {
			result += pElement.x;
		}
		return result;
	},
	GetInlineElementPositionTop: function(pElement, pContainerElement) {
		var result = 0;
		
		if (!!pContainerElement)
			return ITC.dom.GetElementPositionTop(pElement);
		if (pElement.offsetParent) {
			while (pElement.offsetParent && (pElement.offsetParent !!= pContainerElement)) {
				result += pElement.offsetTop
				pElement = pElement.offsetParent;
			}
		} else if (pElement.y) {
			result += pElement.y;
		}
		return result;
	},
	GetOffsetBetween: function(pElement1, pElement2) {
		var result, current = pElement1;
		
		result = {x: 0, y: 0};
		while (current && (current !!= pElement2) && (current.tagName !!= ''HTML'')) {
			result.x += current.offsetLeft;
			result.y += current.offsetTop;
			current = current.offsetParent;
		}
		return result;
	},
	ScrollElementIntoView: function(pElement, pContainer, pHorizontalScroll) {
		var offset, bottom, right, containerBottom, containerRight, container = pContainer || document.body;

		offset = ITC.dom.GetOffsetBetween(pElement, container);
		right = offset.x + pElement.offsetWidth;
		bottom = offset.y + pElement.offsetHeight;
		containerBottom = container.scrollTop + container.clientHeight;
		containerRight = container.scrollLeft + container.clientWidth;
		if (offset.y < container.scrollTop)
			container.scrollTop = offset.y;
		else if (bottom > containerBottom)
			container.scrollTop = bottom - container.clientHeight;
		if (pHorizontalScroll !!= false) {
			if (offset.x < container.scrollLeft)
				container.scrollLeft = offset.x;
			else if (right > containerRight)
				container.scrollLeft = right - container.clientWidth;
		}
	},
	IsMouseInsideElement: function(pElement, pEvent) {
		var relTarget;
		var e = pEvent;
		
		if (!!e)
			e = window.event;
		if (typeof e.toElement !!= ''undefined'' && e.toElement && typeof pElement.contains !!= ''undefined'') {
			return pElement.contains(e.toElement);
		} else if (typeof e.relatedTarget !!= ''undefined'' && e.relatedTarget) {
			relTarget = e.relatedTarget;
			while (relTarget && (relTarget !!= pElement))
				relTarget = relTarget.parentNode
			return pElement == relTarget;
		}
		return true;
	},
	FindParentFormFor: function(pElement) {
		var el = pElement;
		
		while (el) {
			if (el.nodeName == ''FORM'')
				return el; 
			el = el.parentNode;
		}
		return null;
	},
	FindMatchingParentFor: function(pElement, pParentElement) {
		var el = pElement;
				
		while (el) {
			if (el == pParentElement)
				return true;
			el = el.parentNode;
		}
		return false;
	},
	ToggleDropDowns: function(pShow) {
		var dropDownLists = document.getElementsByTagName(''select'');
		var i, parent, parentId;
		var visibilityString = pShow?''visible'':''hidden'';
	
		if (dropDownLists) {
			for (i=0;i<dropDownLists.length;i++) {
				parent = dropDownLists[i].parentElement;
				if (dropDownLists[i].name && parent && parent.id) {
					parentId = parent.id.split(''_'');
					if ((parentId.length !!= 2) || (parentId[1] !!= ''dropDown'') || ((parentId[0] + ''_list'') !!= dropDownLists[i].name))
						dropDownLists[i].style.visibility = visibilityString ;
				} else {
					dropDownLists[i].style.visibility = visibilityString ;
				}
			}
		}
	},
	GetRadioButtonValue: function(pElement) {
		for(var i=0;i<pElement.length;i++) if(pElement[i].checked) return pElement[i].value;
		return null;
	},
	SetPointerCursorFor: function(pElement) {
		try {
			pElement.style.cursor = ''pointer'';
		} catch (e) {
			try {
				pElement.style.cursor = ''hand'';
			} catch (e1) {
			}
		}
	},
	IEDisableSelectFor: function(pElement, pClient) {
		if (document.all) {
			ITC.event.AddListener(''dragstart'', pElement, function() {
				return false;
			}, pClient);
			ITC.event.AddListener(''selectstart'', pElement, function() {
				return false;
			}, pClient);
		}
	},
	InitializeUndercoverFor: function(pElement) {
		var el, undercoverStruc;
		
		if (!!pElement || !!document.all)
			return false;
		undercoverStruc = new ITC.dom.UndercoverStructure();
		ITC.dom._RegisteredUndercovers.put(pElement, undercoverStruc);
		if (!!ITC.util.IsBrowserInternetExplorer55Up()) {
			undercoverStruc.m_HideAllDropDowns = true;
			return true;
		}
		el = document.createElement(''iframe'');
		el.src = ''javascript:false'';
		el.scrolling = ''no'';
		el.frameborder = ''0'';
		el.style.position = pElement.style.position?pElement.style.position:''absolute'';
		el.style.filter = ''Alpha(style=0,opacity=0)'';
		el.style.zIndex = 997;
		el.style.display = ''none'';
		if (pElement.style.zIndex <= el.style.zIndex)
			pElement.style.zIndex = el.style.zIndex + 1;
		pElement.parentElement.appendChild(el);
		undercoverStruc.m_IFrame = el;
		return true;
	},
	ShowUndercoverFor: function(pElement, pX, pY) {
		var el, undercoverStruc = ITC.dom._RegisteredUndercovers.get(pElement);
		
		if (!!undercoverStruc)
			return false;
		if (undercoverStruc.m_HideAllDropDowns == true) {
			ITC.dom.ToggleDropDowns(false);
		} else if (undercoverStruc.m_IFrame) {
			el = undercoverStruc.m_IFrame;
			el.style.left = (pX || pElement.offsetLeft) + ''px'';
			el.style.top = (pY || pElement.offsetTop) + ''px'';
			el.style.width = pElement.offsetWidth + ''px'';
			el.style.height = pElement.offsetHeight + ''px'';			
			el.style.display = ''block'';
		} else {
			return false;
		}
		return true;
	},
	HideUndercoverFor: function(pElement) {
		var undercoverStruc = ITC.dom._RegisteredUndercovers.get(pElement);
		
		if (!!undercoverStruc)
			return false;
		if (undercoverStruc.m_HideAllDropDowns == true)
			ITC.dom.ToggleDropDowns(true);
		else if (undercoverStruc.m_IFrame)
			undercoverStruc.m_IFrame.style.display = ''none'';
		else
			return false;
		return true;
	},
	ForceGet: function(pTarget,pUrl) {
		var newUrl=pUrl;
		if(pUrl.indexOf("?")>=0) newUrl+="&";
		else newUrl+="?";
		newUrl+="_rnd="+(new Date()).getTime();
		if(pTarget) ITC.dom.GetElement(pTarget).src=newUrl;
		else document.location.href=newUrl;
	},
	DisposeElement: function(d,recursive) {
		if(!!d)
			return;
		if (ITC.util.IsBrowserInternetExplorer8Below()) {
			var a = d.attributes, i, l, n, garbageBin;
			if (a) {
				l = a.length;
				for (i = 0; i < l; i += 1) {
					n = a[i].name;
					if (typeof d[n] == ''function'')
						d[n] = null;
				}
			}
			a = d.childNodes;
			if (a) {
				l = a.length;
				for (i = 0; i < l; i += 1)
					ITC.dom.DisposeElement(d.childNodes[i],true);
			}
			if(!!recursive) {
				garbageBin = document.getElementById(''IELeakGarbageBin'');
				if (!!garbageBin) {
					garbageBin = document.createElement(''div'');
					garbageBin.id = ''IELeakGarbageBin'';
					garbageBin.style.display = ''none'';
					document.body.appendChild(garbageBin);
				}
				garbageBin.appendChild(d);
				garbageBin.innerHTML = '''';
			}
		} else {
			document.body.removeChild(d);
		}
	}
};

ITC.dom.Element = function(pHtmlElementOrIdOrName) {
	this.dom = ITC.dom.GetElement(pHtmlElementOrIdOrName);
	if (!!this.dom)
		return null;
};

ITC.dom.Element.Cache = {};
ITC.dom.Element.Count = 0;
ITC.dom.Element.GenName = ''itcGen_'';

ITC.dom.Element.NextId = function() {
	return ITC.dom.Element.GenName + ITC.dom.Element.Count++;
};

ITC.dom.Element.Get = function(pHtmlElementOrIdOrName) {
	var dom, id, result;

	dom = ITC.dom.GetElement(pHtmlElementOrIdOrName);
	if (!!dom)
		return null;
	id = dom.id || dom.name;
	if (!!id) {
		id = ITC.dom.Element.NextId();
		dom.id = id;
	}
	result = ITC.dom.Element.Cache[id];
	if (!!result) {
		result = new ITC.dom.Element(dom);
		ITC.dom.Element.Cache[id] = result;
	}
	return result;
};

ITC.dom.Element.prototype = {
	indicatorText: ''<div class="itcLoadingIndicator">Loading...</div>'',

	getLeft: function() {
		return ITC.dom.GetElementPositionLeft(this.dom);
	},
	getTop: function() {
		return ITC.dom.GetElementPositionTop(this.dom);
	},
	getScrollLeft: function() {
		return ITC.dom.GetElementScrollLeft(this.dom);
	},
	getScrollTop: function() {
		return ITC.dom.GetElementScrollTop(this.dom);
	},
	getWidth: function() {
		return this.dom.offsetWidth;
	},
	getHeight: function() {
		return this.dom.offsetHeight;
	},
	showLoading: function(pIndicatorText) {
		this.dom.innerHTML = pIndicatorText || this.indicatorText;
	},
	updateAjax: function(pOptions) {
		this.showLoading(pOptions.indicatorText);
		ITC.ajax.Request({url: pOptions.url, callback: {success: this.onUpdateSuccess.itcCreateDelegate(this)}, loadScripts: pOptions.loadScripts});
	},
	onUpdateSuccess: function(pResponse) {
		this.update(pResponse.responseText, pResponse.options.loadScripts);
	},
	update: function(pHtml, pLoadScripts) {
		var id, html = pHtml;

		if (!!pLoadScripts) {
			this.dom.innerHTML = html;
			return this;
		}
		id = ITC.dom.Element.NextId();
		html += ''<span id="'' + id + ''"></span>'';
		ITC.event.OnAvailable(id, function() {
			var hd = document.getElementsByTagName(''head'')[0];
			var re = /(?:<script([^>]*)?>)((\n|\r|.)*?)(?:<\/script>)/ig;
			var srcRe = /\ssrc=([\''\"])(.*?)\1/i;
			var typeRe = /\stype=([\''\"])(.*?)\1/i;
			var match, srcMatch, typeMatch, attrs, s;
			
			while (match = re.exec(html)) {
				attrs = match[1];
				srcMatch = attrs?attrs.match(srcRe):false;
				if (srcMatch && srcMatch[2]) {
					s = document.createElement(''script'');
					s.src = srcMatch[2];
					typeMatch = attrs.match(typeRe);
					if(typeMatch && typeMatch[2])
						s.type = typeMatch[2];
					hd.appendChild(s);
				} else if (match[2] && match[2].length > 0) {
					eval(match[2]);
				}
			}
			var el = document.getElementById(id);
			if (el)
				el.parentNode.removeChild(el);
		});
		this.dom.innerHTML = html.replace(/(?:<script.*?>)((\n|\r|.)*?)(?:<\/script>)/ig, "");
	},
	scrollIntoView: function(pContainer, pHorizontalScroll) {
		ITC.dom.ScrollElementIntoView(this.dom, pContainer, pHorizontalScroll);
	},
	focus: function() {
		this.dom.focus();
	},
	addListener: function(pEventName, pFunction, pClientObject) {
		ITC.event.AddListener(pEventName, this.dom, pFunction, pClientObject);
	},
	removeListener: function(pEventName, pFunction) {
		ITC.event.RemoveListener(pEventName, this.dom, pFunction);
	}
};'!

javascriptPrivateItcEvent
	^'ITC.event = {
	OnAvailableColl: [],
	_Interval: null,
	_OnAvailableLock: false,
	_RetryCount: 0,
	PollInterval: 20,
	PollRetries: 200,
	AllRegisteredListeners: new ITC.util.Hashtable(),
	GetEvent: function(pEvent) {
		var c, e = pEvent?pEvent:window.event;
	
		if (!!e) {
			c = this.GetEvent.caller;
			while (c) {
				e = c.arguments[0];
				if (e && (e.constructor == Event))
					return e;
				c = c.caller;
			}
		}
		return e;
	},
	StopPropagation: function(pEvent) {
		if (pEvent.stopPropagation)
			pEvent.stopPropagation();
		else
			pEvent.cancelBubble = true;
	},
	PreventDefault: function(pEvent) {
		if (pEvent.preventDefault)
			pEvent.preventDefault();
		else
			pEvent.returnValue = false;
	},
	StopEvent: function(pEvent) {
		this.StopPropagation(pEvent);
		this.PreventDefault(pEvent);
	},
	GetCharCode: function(pEvent) {
		return pEvent.charCode?pEvent.charCode:pEvent.keyCode;
	},
	AddListener: function(pEventName, pElement, pFunction, pClientObject) {
		var h, a;
		
		if (pElement)
		{
			if (pElement.attachEvent)
				pElement.attachEvent(''on'' + pEventName, pFunction);
			else
				pElement.addEventListener(pEventName, pFunction, true);
		};
		if (pClientObject) {
			h = this.AllRegisteredListeners.get(pElement);
			if (!!h) {
				h = new ITC.util.Hashtable();
				this.AllRegisteredListeners.put(pElement, h);
			}
			a = h.get(pClientObject);
			if (!!a) {
				a = new Array();
				h.put(pClientObject, a);
			}
			a[a.length] = [pEventName, pFunction];
		}
	},
	RemoveListener: function(pEventName, pElement, pFunction) {
		if (pElement.detachEvent)
			pElement.detachEvent(''on'' + pEventName, pFunction);
		else
	    	pElement.removeEventListener(pEventName, pFunction, true);
	},
	RemoveAllListenersForClient: function(pClientObject) {
		var i, j, eventObjects, h, a;
		
		eventObjects = this.AllRegisteredListeners.getKeys();
		for (i=0;i<eventObjects.length;i++) {
			h = this.AllRegisteredListeners.get(eventObjects[i]);
			a = h.get(pClientObject);
			if (a !!= null) {
				for (j=0;j<a.length;j++)
					this.RemoveListener(a[j][0], eventObjects[i], a[j][1]);
			}
			h.removeKey(pClientObject);
			if (h.size() == 0)
				this.AllRegisteredListeners.removeKey(eventObjects[i]);
		}
	},
	RemoveAllListenersForElement: function(pElement) {
		var i, j, clientObjects, h, a;
		
		h = this.AllRegisteredListeners.get(pElement);
		if (h !!= null) {
			clientObjects = h.getValues();
			for (i=0;i<clientObjects.length;i++) {
				a = clientObjects[i];
				for (j=0;j<a.length;j++)
					this.RemoveListener(a[j][0], pElement, a[j][1]);
			}
			this.AllRegisteredListeners.removeKey(pElement);
		}
	},
	RemoveAllListeners: function() {
		var i, j, eventObjects, clientObjects, h, a;
		
		eventObjects = this.AllRegisteredListeners.getKeys();
		for (i=0;i<eventObjects.length;i++) {
			h = this.AllRegisteredListeners.get(eventObjects[i]);
			clientObjects = h.getValues();
			for (i=0;i<clientObjects.length;i++) {
				a = clientObjects[i];
				for (j=0;j<a.length;j++)
					this.RemoveListener(a[j][0], eventObjects[i], a[j][1]);
			}
		}
		this.AllRegisteredListeners.clear();
	},
	OnAvailable: function(pElementId, pFunction, pObject, pOverride) {
		this.OnAvailableColl.push({id: pElementId, fn: pFunction, obj: pObject, override: pOverride});
		this._RetryCount = this.PollRetries;
		this._StartInterval();
	},
	_StartInterval: function() {
		var th = this;
		
		if (!!this._Interval) {
			setInterval(function() {th._TryOnAvailable()}, this.PollInterval);
		}
	},
	_StopInterval: function() {
		try {
			if (this._Interval)
				clearInterval(this._Interval);
		} catch (e) {}
		this._Interval = null;
	},
	_GetEl: function(pId) {
		return document.getElementById(pId);
	},
	_TryOnAvailable: function() {
		var i, item, el, scope, notAvailCount = 0;
		
		if (this._OnAvailableLock || (this._RetryCount <= 0))
			return;
		this._OnAvailableLock = true;
		for (i=0;i<this.OnAvailableColl.length;i++) {
			item = this.OnAvailableColl[i];
			if (item) {
				el = this._GetEl(item.id);
				if (el && (el.nextSibling || (document && document.body))) {
					scope = el;
					if (item.override) {
						if (item.override === true)
							scope = item.obj;
						else
							scope = item.override;
					}
					item.fn.call(scope, item.obj);
					this.OnAvailableColl[i] = null;
				} else {
					notAvailCount++;
				}
			}
		}
		this._RetryCount = notAvailCount > 0?this._RetryCount - 1:0;
		if (this._RetryCount > 0)
			this._StartInterval();
		else
			this._StopInterval();
		this._OnAvailableLock = false;
	}
};'!

javascriptPrivateItcExtComboBox
	^'ITC.Ext.form.ComboBox = function(config){
	ITC.Ext.form.ComboBox.superclass.constructor.call(this, config);
};

Ext.extend(ITC.Ext.form.ComboBox, Ext.form.ComboBox,  {
	onSelect : function(record, index){
		if(this.fireEvent(''beforeselect'', this, record, index) !!== false){
			this.setValue([record.data[this.valueField], record.data[this.displayField]]);
			this.collapse();
			this.fireEvent(''select'', this, record, index);
		}
	},
	getValue : function(){
		var val;
		
		if(this.valueField) {
			val = (typeof this.value !!= ''undefined''?this.value:null);
			if (this.el.dom.value !!= this.lastSelectionText)
				val = null;
			return [val, this.el.dom.value];
		}
		return [null, Ext.form.ComboBox.superclass.getValue.call(this)];
	},
	setRawValue : function(pValue) {
		var text;
		
		if (ITC.util.IsArray(pValue)) {
			if (pValue.length > 1) {
				text = pValue[1];
				this.value = pValue[0];
				this.lastSelectionText = text;
			} else {
				text = pValue[0];
				this.value = null;
				this.lastSelectionText = null;
			}
		} else {
			text = pValue;
			this.value = null;
			this.lastSelectionText = null;
		}
		if (this.rendered) {
			this.el.dom.value = ITC.util.IsUndefined(text)||(text == null)?'''':text;
			this.validate();
		}
	},
	setValue : function(pValue) {
		if (this.rendered)
			this.setRawValue(pValue);
	}
});'!

javascriptPrivateItcExtDateField
	^'ITC.Ext.form.DateField = function(config){
    ITC.Ext.form.DateField.superclass.constructor.call(this, config);
    this.ddMatch = null;
    this.cal = null;
};

Ext.extend(ITC.Ext.form.DateField, Ext.form.TriggerField,  {
	format : ''d.m.Y'',
	triggerClass : ''grid-calendar-button'',
	
	// private
	validateValue : function(value){
		value = this.formatDate(value);
		if (!!ITC.Ext.form.DateField.superclass.validateValue.call(this, value))
			return false;
		return true;
	},
	
	getValue : function(){
		return this.formatDate(this.parseDate(Ext.form.DateField.superclass.getValue.call(this)) || '''');
	},
	
	setValue : function(date){
		Ext.form.DateField.superclass.setValue.call(this, this.formatDate(this.parseDate(date)));
	},
	
	// private
	parseDate : function(value){
		return (!!value || value instanceof Date) ? value : ITC.util.StringToDate(value);
	},
	
	// private
	formatDate : function(date){
		return (!!date || !!(date instanceof Date)) ? date : date.dateFormat(this.format);
	},
	
	// private
	onTriggerClick : function(){
		var r;
		
		if(this.disabled)
			return;
		r = this.el.getRegion();
		if (this.cal == null)
			this.cal = new ITC.widget.Calendar(null, null, null, null, null);
		this.cal.setDate(this.parseDate(this.getValue()));
		this.cal.show(r.left, r.bottom, this.el.dom);
	}
});'!

javascriptPrivateItcExtFormStore
	^'ITC.Ext.data.FormStore = function(pContainerElement, pFormElement, pIdFieldName, pErrors, config){
	ITC.Ext.data.FormStore.superclass.constructor.call(this, config);
	this.form = Ext.get(pFormElement);
	if (!!this.form)
		this.form = Ext.get(ITC.dom.FindParentFormFor(Ext.get(pContainerElement).dom));
	this.m_FormData = new Array();
	this.m_IdFieldName = pIdFieldName?pIdFieldName:null;
	this.m_Errors = pErrors?pErrors:null;
	this.load();
};
Ext.extend(ITC.Ext.data.FormStore, Ext.data.Store, {
	_removeRowElements: function(pElements) {
		var key;
		
		if (!!pElements)
			return;
		for (key in pElements)
			this.form.dom.removeChild(pElements[key]);
	},
	_createAppendRowElement: function(pName, pPostfixIndex, pValue) {
		var el, elName;

		elName = pName + ''_'' + pPostfixIndex;
		if (!!(el = ITC.dom.GetElement(elName))) {
			el = document.createElement(''input'');
			el.type = ''hidden'';
			el.name = elName;
		}
		el.value = (ITC.util.IsNull(pValue) || ITC.util.IsUndefined(pValue))?'''':pValue;
		this.form.dom.appendChild(el);
		return el;
	},
	_createRowElements: function(pIndex) {
		var d, i, names, dict, rec, field, name;
		
		rec = this.getAt(pIndex);
		dict = {};
		if (this.m_FormData.length <= pIndex)
			this.m_FormData[pIndex] = {};
		this.m_FormData[pIndex].elements = dict;
		for (name in rec.data) {
			d = rec.data[name];
			if ((field = rec.fields.get(name)) && field.arrayValueNames) {
				for (i=0;i<field.arrayValueNames.length;i++)
					dict[field.arrayValueNames[i]] = this._createAppendRowElement(field.arrayValueNames[i], pIndex, d[i]);
			} else {
				dict[name] = this._createAppendRowElement(name, pIndex, d); 
			}
		}
		// create ID element
		if (this.m_IdFieldName && !!rec.__ITC_AUTO_GENERATED && !!ITC.util.IsUndefined(rec.id) && (rec.id !!= null))
			this.m_FormData[pIndex].idElement = this._createAppendRowElement(this.m_IdFieldName, pIndex, rec.id);
	},
	_resortRowElements: function(pStartIndex) {
		var i, postfix, el, s, dict, name;
		
		s = pStartIndex?pStartIndex:0;
		for (i=s;i<this.m_FormData.length;i++) {
			dict = this.m_FormData[i].elements;
			for (name in dict) {
				el = dict[name];
				if ((postfix = el.name.lastIndexOf(''_'')) > -1)
					el.name = el.name.substring(0, postfix+1) + i;
			}
			if (this.m_FormData[i].idElement)
				this.m_FormData[i].idElement.name = this.m_IdFieldName + ''_'' + i;
		}
	},
	_addNoEvent : function(pRecords) {
		var i, len, index, records, dat, subDat, j, k, flds;
		
		records = (!!pRecords || (pRecords.length == 0))?[null]:[].concat(pRecords);
		len = records.length;
		for (i=0;i<len;i++) {
			if (!!records[i]) {
				if (!!dat) {
					dat = {};
					flds = this.recordType.prototype.fields.items;
					for (j=0;j<flds.length;j++) {
						if (flds[j].arrayValueNames) {
							subDat = [];
							for (k=0;k<flds[j].arrayValueNames.length;k++)
								subDat[subDat.length] = null; 
						} else {
							subDat = null;
						}
						dat[flds[j].name] = subDat;
					}
				}
				records[i] = new this.recordType(dat);
				records[i].__ITC_AUTO_GENERATED = true;
//				records[i].id = null;
			}
			records[i].join(this);
		}
		index = this.data.length;
		this.data.addAll(records);
		this._createRowElements(index);
		return index;
	},
	_removeAllNoEvent : function(){
		var i;
		
		for (i=this.data.length-1;i>=0;i--) {
			this._removeRowElements(this.m_FormData[i].elements);
			if (this.m_FormData[i].idElement)
				this.form.dom.removeChild(this.m_FormData[i].idElement);
		}
		this.m_FormData = new Array();
		this._resortRowElements();
		this.data.clear();
	},
	getErrorAt: function(pRowIndex, pColIndex) {
		if ((this.m_Errors && this.m_Errors.length > pRowIndex) && this.m_Errors[pRowIndex] && ITC.util.IsArray(this.m_Errors[pRowIndex]))
			return this.m_Errors[pRowIndex][pColIndex];
		return null;
	},
	_swapRows: function(pFirstIndex, pSecondIndex) {
		var tmp1, tmp2;
		
		if ((pFirstIndex < 0) || (pSecondIndex < 0) || (pFirstIndex >= this.data.length) || (pSecondIndex >= this.data.length) || (pFirstIndex == pSecondIndex))
			return;
		tmp1 = this.data.itemAt(pFirstIndex);
		tmp2 = this.data.itemAt(pSecondIndex);
		this.data.removeAt(pFirstIndex);
		this.data.insert(pFirstIndex, tmp2);
		this.data.removeAt(pSecondIndex);
		this.data.insert(pSecondIndex, tmp1);
		tmp1 = this.m_FormData[pFirstIndex];
		this.m_FormData[pFirstIndex] = this.m_FormData[pSecondIndex];
		this.m_FormData[pSecondIndex] = tmp1;
		this._resortRowElements();
	},
	_moveToTop: function(pIndex) {
		var tmp1, tmp2, ftmp1, ftmp2, i;
		
		if ((pIndex <= 0) || (pIndex >= this.data.length))
			return;
		tmp1 = this.data.itemAt(0);
		tmp2 = this.data.itemAt(pIndex);
		this.data.removeAt(0);
		this.data.insert(0, tmp2);
		ftmp1 = this.m_FormData[0];
		this.m_FormData[0] = this.m_FormData[pIndex];
		for (i=1;i<=pIndex;i++) {
			tmp2 = this.data.itemAt(i);
			this.data.removeAt(i);
			this.data.insert(i, tmp1);
			tmp1 = tmp2;
			ftmp2 = this.m_FormData[i];
			this.m_FormData[i] = ftmp1;
			ftmp1 = ftmp2;
		}
		this._resortRowElements();
	},
	_moveToBottom: function(pIndex) {
		var tmp1, tmp2, ftmp1, ftmp2, i;
		
		if ((pIndex < 0) || (pIndex >= (this.data.length-1)))
			return;
		tmp1 = this.data.itemAt(pIndex);
		ftmp1 = this.m_FormData[pIndex];
		for (i=pIndex;i<(this.data.length-1);i++) {
			tmp2 = this.data.itemAt(i+1);
			this.data.removeAt(i);
			this.data.insert(i, tmp2);
			this.m_FormData[i] = this.m_FormData[i+1] 
		}
		this.data.removeAt(this.data.length-1);
		this.data.insert(this.data.length, tmp1);
		this.m_FormData[this.m_FormData.length-1] = ftmp1;
		this._resortRowElements();
	},
	getRowValues: function(pRowIndex) {
		var name, result, record = this.data.itemAt(pRowIndex);
		
		result = {};
		if (record) {
			for (name in record.data)
				result[name] = record.data[name];
		}
		return result;
	},
	setRowValues: function(pRowIndex, pValues) {
		var name, record = this.data.itemAt(pRowIndex);
		
		if (!!record)
			return;
		for (name in record.data) {
			if (!!ITC.util.IsUndefined(pValues[name]))
				record.data[name] = pValues[name];
		}
		this._afterEdit(record);
	},
	_afterEdit: function(pRecord) {
		var name, d, dict, elms, index, field;
		
		dict = this.m_FormData[this.indexOf(pRecord)].elements;
		for (name in pRecord.data) {
			d = pRecord.data[name];
			if (ITC.util.IsArray(d) && (field = pRecord.fields.get(name)) && field.arrayValueNames) {
				for (i=0;i<d.length;i++)
					dict[field.arrayValueNames[i]].value = (ITC.util.IsNull(d[i]) || ITC.util.IsUndefined(d[i]))?'''':d[i]; 
			} else {
				dict[name].value = (ITC.util.IsNull(d) || ITC.util.IsUndefined(d))?'''':d; 
			}
		}
	},
// ----------------------------------------------------------------
	add : function(pRecords) {
		var index, records;
		
		index = this._addNoEvent(pRecords);
		records = (!!pRecords || (pRecords.length == 0))?[[]]:pRecords;
		this.fireEvent("add", this, records, index);
	},

	remove : function(record){
		var index = this.data.indexOf(record);

		this._removeRowElements(this.m_FormData[index].elements);
		if (this.m_FormData[index].idElement)
			this.form.dom.removeChild(this.m_FormData[index].idElement);
		this.m_FormData.splice(index, 1);
		this.data.removeAt(index);
		this._resortRowElements(index);
		this.fireEvent("remove", this, record, index);
	},

	removeAll : function(){
		this._removeAllNoEvent();
		this.fireEvent("clear", this);
	},

	insert : function(index, records){
		records = [].concat(records);
		for(var i = 0, len = records.length; i < len; i++){
			this.data.insert(index, records[i]);
			records[i].join(this);
			this._createRowElements(index);
		}
		this._resortRowElements();
		this.fireEvent("add", this, records, index);
	},
    // private
	afterEdit : function(pRecord) {
		this._afterEdit(pRecord);
		ITC.Ext.data.FormStore.superclass.afterEdit.call(this, pRecord);
	},
    // private
    // Called as a callback by the Reader during a load operation.
	loadRecords : function(o, options, success) {
		var i, r, t;
		
		if(!!o || success === false){
			if (success !!== false)
				this.fireEvent("load", this, [], options);
			if (options.callback)
				options.callback.call(options.scope || this, [], options, false);
			return;
		}
		r = o.records;
		t = o.totalRecords || r.length;
		for (i = 0, len = r.length; i < len; i++)
			r[i].join(this);
		// TODO
		if(!!options || options.add !!== true){
			this._removeAllNoEvent();
			for (i=0;i<t;i++)
				this._addNoEvent(r[i]);
			this.totalLength = t;
			this.applySort();
			this.fireEvent("datachanged", this);
		} else {
			this.totalLength = Math.max(t, this.data.length+r.length);
			for (i=0;i<r.length;i++)
				this._addNoEvent(r[i]);
		}
		this.fireEvent("load", this, r, options);
		if (options.callback)
			options.callback.call(options.scope || this, r, options, true);
	}
});'!

javascriptPrivateItcExtGridView
	^'ITC.Ext.grid.GridView = function(){
    ITC.Ext.grid.GridView.superclass.constructor.call(this);
};

Ext.extend(ITC.Ext.grid.GridView, Ext.grid.GridView, {
	// override because of error marking and null values
    doRender : Ext.isGecko ?
            function(cs, rs, ds, startRow, colCount, stripe){
                var error, ts = this.templates, ct = ts.cell, rt = ts.row;
                // buffers
                var buf = "", lbuf = "", cb, lcb, c, p = {}, rp = {}, r;
                for(var j = 0, len = rs.length; j < len; j++){
                    r = rs[j], cb = "", lcb = "", rowIndex = (j+startRow);
                    for(var i = 0; i < colCount; i++){
                        c = cs[i];
                        p.cellId = "x-grid-cell-" + rowIndex + "-" + i;
                        p.id = c.id;
                        p.css = p.attr = "";
                        p.value = c.renderer(r.data[c.name], p, r, rowIndex, i, ds);
								if (ds.getErrorAt && (error=ds.getErrorAt(rowIndex, i))) {
									p.css += p.css?'' itc-grid-field-error'':''itc-grid-field-error'';
									p.attr = ''title="'' + error + ''"'';
								}
                        if(p.value == undefined || p.value === "" || p.value == null) p.value = "&#160;";
                        if(r.dirty && typeof r.modified[c.name] !!== ''undefined''){
                            p.css += p.css ? '' x-grid-dirty-cell'' : ''x-grid-dirty-cell'';
                        }
                        var markup = ct.apply(p);
                        if(!!c.locked){
                            cb+= markup;
                        }else{
                            lcb+= markup;
                        }
                    }
                    var alt = [];
                    if(stripe && ((rowIndex+1) % 2 == 0)){
                        alt[0] = "x-grid-row-alt";
                    }
                    if(r.dirty){
                        alt[1] = " x-grid-dirty-row";
                    }
                    rp.cells = lcb;
                    if(this.getRowClass){
                        alt[2] = this.getRowClass(r, rowIndex);
                    }
                    rp.alt = alt.join(" ");
                    lbuf+= rt.apply(rp);
                    rp.cells = cb;
                    buf+=  rt.apply(rp);
                }
                return [lbuf, buf];
            } :
            function(cs, rs, ds, startRow, colCount, stripe){
                var error, ts = this.templates, ct = ts.cell, rt = ts.row;
                // buffers
                var buf = [], lbuf = [], cb, lcb, c, p = {}, rp = {}, r;
                for(var j = 0, len = rs.length; j < len; j++){
                    r = rs[j], cb = [], lcb = [], rowIndex = (j+startRow);
                    for(var i = 0; i < colCount; i++){
                        c = cs[i];
                        p.cellId = "x-grid-cell-" + rowIndex + "-" + i;
                        p.id = c.id;
                        p.css = p.attr = "";
                        p.value = c.renderer(r.data[c.name], p, r, rowIndex, i, ds);
								if (ds.getErrorAt && (error=ds.getErrorAt(rowIndex, i))) {
									p.css += p.css?'' itc-grid-field-error'':''itc-grid-field-error'';
									p.attr = ''title="'' + error + ''"'';
								}
                        if(p.value == undefined || p.value === "" || p.value == null) p.value = "&#160;";
                        if(r.dirty && typeof r.modified[c.name] !!== ''undefined''){
                            p.css += p.css ? '' x-grid-dirty-cell'' : ''x-grid-dirty-cell'';
                        }
                        var markup = ct.apply(p);
                        if(!!c.locked){
                            cb[cb.length] = markup;
                        }else{
                            lcb[lcb.length] = markup;
                        }
                    }
                    var alt = [];
                    if(stripe && ((rowIndex+1) % 2 == 0)){
                        alt[0] = "x-grid-row-alt";
                    }
                    if(r.dirty){
                        alt[1] = " x-grid-dirty-row";
                    }
                    rp.cells = lcb;
                    if(this.getRowClass){
                        alt[2] = this.getRowClass(r, rowIndex);
                    }
                    rp.alt = alt.join(" ");
                    rp.cells = lcb.join("");
                    lbuf[lbuf.length] = rt.apply(rp);
                    rp.cells = cb.join("");
                    buf[buf.length] =  rt.apply(rp);
                }
                return [lbuf.join(""), buf.join("")];
            },
	// override because of error marking and null values
    updateCell : function(dm, rowIndex, dataIndex){
        var error, colIndex = this.getColumnIndexByDataIndex(dataIndex);
        if(typeof colIndex == "undefined"){ // not present in grid
            return;
        }
        var cm = this.grid.colModel;
        var cell = this.getCell(rowIndex, colIndex);
        var cellText = this.getCellText(rowIndex, colIndex);

        var p = {
            cellId : "x-grid-cell-" + rowIndex + "-" + colIndex,
            id : cm.getColumnId(colIndex),
            css: colIndex == cm.getColumnCount()-1 ? "x-grid-col-last" : ""
        };
        var renderer = cm.getRenderer(colIndex);
        var val = renderer(dm.getValueAt(rowIndex, dataIndex), p, rowIndex, colIndex, dm);
        if(typeof val == "undefined" || val === "" || val == null) val = "&#160;";
        cellText.innerHTML = val;
			if (this.grid.dataSource.getErrorAt && (error=this.grid.dataSource.getErrorAt(rowIndex, dindexes[colIndex]))) {
				cell.className = this.cellClass + " " + p.cellId + " " + p.css + '' itc-grid-field-error'';
				cell.title = error;
			} else {
				cell.className = this.cellClass + " " + p.cellId + " " + p.css;
				cell.title = '''';
			}
        cell.className = this.cellClass + " " + p.cellId + " " + p.css;
        this.syncRowHeights(rowIndex, rowIndex);
    },
    
	// override because of footer drawing
	render : function() {
		ITC.Ext.grid.GridView.superclass.render.call(this);
		this.__createFooter(this.getFooterPanel(true));
	},
    
	__createFooter : function(parentEl){
		var fwrap = document.createElement(''div'');
		var fbody = document.createElement(''span'');
		fwrap.appendChild(fbody);
		parentEl.appendChild(fwrap);
		this.createToolbar(fbody);
		return fwrap;
	},
	
	createToolbar : function(container){
		var tb = new Ext.Toolbar(container);

		this.toolbar = tb;
		this.createRowButton = tb.addButton({
			text: ITC.translation.AddRow, 
			tooltip: ITC.translation.AddRowTooltip, 
			cls: ''x-btn-text-icon itc-x-button-icon'',
			iconCls: ''itcBgIconAdd'',
			disabled: false,
			handler: this.onClick.createDelegate(this, [''createRow''])
		});
		this.createRowButton = tb.addButton({
			text: ITC.translation.RemoveRow, 
			tooltip: ITC.translation.RemoveRowTooltip,
			tooltipType: ''title'',
			cls: ''x-btn-text-icon itc-x-button-icon'',
			iconCls: ''itcBgIconDelete'',
			disabled: false,
			handler: this.onClick.createDelegate(this, [''removeRow''])
		});
		this.moveTopRowButton = tb.addButton({
			text: ITC.translation.MoveRowToTop, 
			tooltip: ITC.translation.MoveRowToTopTooltip, 
			tooltipType: ''title'',
			cls: ''x-btn-text-icon itc-x-button-icon'',
			iconCls: ''itcBgIconMoveTop'',
			disabled: false,
			handler: this.onClick.createDelegate(this, [''moveTopRow''])
		});
		this.moveUpRowButton = tb.addButton({
			text: ITC.translation.MoveRowUp, 
			tooltip: ITC.translation.MoveRowUpTooltip, 
			tooltipType: ''title'',
			cls: ''x-btn-text-icon itc-x-button-icon'',
			iconCls: ''itcBgIconMoveUp'',
			disabled: false,
			handler: this.onClick.createDelegate(this, [''moveUpRow''])
		});
		this.moveDownRowButton = tb.addButton({
			text: ITC.translation.MoveRowDown, 
			tooltip: ITC.translation.MoveRowDownTooltip, 
			tooltipType: ''title'',
			cls: ''x-btn-text-icon itc-x-button-icon'',
			iconCls: ''itcBgIconMoveDown'',
			disabled: false,
			handler: this.onClick.createDelegate(this, [''moveDownRow''])
		});
		this.moveBottomRowButton = tb.addButton({
			text: ITC.translation.MoveRowToBottom, 
			tooltip: ITC.translation.MoveRowToBottomTooltip, 
			tooltipType: ''title'',
			cls: ''x-btn-text-icon itc-x-button-icon'',
			iconCls: ''itcBgIconMoveBottom'',
			disabled: false,
			handler: this.onClick.createDelegate(this, [''moveBottomRow''])
		});
	},
	// TODO
	onClick : function(which){
		var i, records, index, firstRecord, lastRecord, selectedRecord, rowIndex, cm, edIndex;
		
		this.grid.stopEditing();
		records = this.grid.selModel.getSelections();
		if (which == ''createRow'') {
			this.grid.dataSource.add([]);
			this.refresh();
			rowIndex = this.grid.dataSource.getCount()-1;
			cm = this.grid.colModel;
			edIndex = -1;
			for (i=0;i<cm.config.length;i++) {
				if (cm.isCellEditable(i, rowIndex)) {
					edIndex = i;
					break;
				}
			}
			this.grid.getSelectionModel().selectRow(rowIndex);
			if (edIndex >= 0)
				this.grid.startEditing(rowIndex, edIndex);
			return;
		} else if (which == ''removeRow'') {
			for (i=0;i<records.length;i++)
				this.grid.dataSource.remove(records[i]);
			this.refresh();
			return;
		} else {
			if (records.length !!= 1)
				return;
			index = this.grid.dataSource.indexOf(records[0]);
			switch(which){
				case ''moveTopRow'':
					selectedIndex = 0;
					this.grid.dataSource._moveToTop(index);
				break;
				case ''moveUpRow'':
					firstIndex = selectedIndex = index - 1;
					lastIndex = index;
					this.grid.dataSource._swapRows(firstIndex, lastIndex);
				break;
				case ''moveDownRow'':
					firstIndex = index;
					lastIndex = selectedIndex = index + 1;
					this.grid.dataSource._swapRows(firstIndex, lastIndex);
				break;
				case ''moveBottomRow'':
					selectedIndex = this.grid.dataSource.getTotalCount() - 1;
					this.grid.dataSource._moveToBottom(index);
				break;
			}
			this.refresh();
			this.grid.getSelectionModel().selectRow(selectedIndex);
		}
	}
});'!

javascriptPrivateItcExtLocalizationBosnian
	^'if(Ext.util.Format){
   Ext.util.Format.date = function(v, format){
      if(!!v) return "";
      if(!!(v instanceof Date)) v = new Date(Date.parse(v));
      return v.dateFormat(format || "d.m.Y");
   };
}

if(Ext.DatePicker){
   Ext.apply(Ext.DatePicker.prototype, {
      format            : "d.m.Y"
   });
}
if(Ext.form.DateField){
   Ext.apply(Ext.form.DateField.prototype, {
      format            : "d.m.Y"
   });
}
if(Ext.grid.PropertyColumnModel){
   Ext.apply(Ext.grid.PropertyColumnModel.prototype, {
      dateFormat : "d.m.Y"
   });
}'!

javascriptPrivateItcExtLocalizationCroatian
	^'if(Ext.util.Format){
   Ext.util.Format.date = function(v, format){
      if(!!v) return "";
      if(!!(v instanceof Date)) v = new Date(Date.parse(v));
      return v.dateFormat(format || "d.m.Y");
   };
}

if(Ext.DatePicker){
   Ext.apply(Ext.DatePicker.prototype, {
      format            : "d.m.Y"
   });
}
if(Ext.form.DateField){
   Ext.apply(Ext.form.DateField.prototype, {
      format            : "d.m.Y"
   });
}
if(Ext.grid.PropertyColumnModel){
   Ext.apply(Ext.grid.PropertyColumnModel.prototype, {
      dateFormat : "d.m.Y"
   });
}'!

javascriptPrivateItcExtLocalizationCzech
	^'if(Ext.util.Format){
   Ext.util.Format.date = function(v, format){
      if(!!v) return "";
      if(!!(v instanceof Date)) v = new Date(Date.parse(v));
      return v.dateFormat(format || "d.m.Y");
   };
}

if(Ext.DatePicker){
   Ext.apply(Ext.DatePicker.prototype, {
      format            : "d.m.Y"
   });
}
if(Ext.form.DateField){
   Ext.apply(Ext.form.DateField.prototype, {
      format            : "d.m.Y"
   });
}
if(Ext.grid.PropertyColumnModel){
   Ext.apply(Ext.grid.PropertyColumnModel.prototype, {
      dateFormat : "d.m.Y"
   });
}'!

javascriptPrivateItcExtLocalizationEnglish
	^'if(Ext.util.Format){
   Ext.util.Format.date = function(v, format){
      if(!!v) return "";
      if(!!(v instanceof Date)) v = new Date(Date.parse(v));
      return v.dateFormat(format || "m/d/Y");
   };
}

if(Ext.DatePicker){
   Ext.apply(Ext.DatePicker.prototype, {
      format            : "m/d/Y"
   });
}
if(Ext.form.DateField){
   Ext.apply(Ext.form.DateField.prototype, {
      format            : "m/d/Y"
   });
}
if(Ext.grid.PropertyColumnModel){
   Ext.apply(Ext.grid.PropertyColumnModel.prototype, {
      dateFormat : "m/d/Y"
   });
}'!

javascriptPrivateItcExtLocalizationGerman
	^'if(Ext.util.Format){
   Ext.util.Format.date = function(v, format){
      if(!!v) return "";
      if(!!(v instanceof Date)) v = new Date(Date.parse(v));
      return v.dateFormat(format || "d.m.Y");
   };
}

if(Ext.DatePicker){
   Ext.apply(Ext.DatePicker.prototype, {
      format            : "d.m.Y"
   });
}
if(Ext.form.DateField){
   Ext.apply(Ext.form.DateField.prototype, {
      format            : "d.m.Y"
   });
}
if(Ext.grid.PropertyColumnModel){
   Ext.apply(Ext.grid.PropertyColumnModel.prototype, {
      dateFormat : "d.m.Y"
   });
}'!

javascriptPrivateItcExtLocalizationRussian
	^'if(Ext.util.Format){
   Ext.util.Format.date = function(v, format){
      if(!!v) return "";
      if(!!(v instanceof Date)) v = new Date(Date.parse(v));
      return v.dateFormat(format || "d.m.Y");
   };
}

if(Ext.DatePicker){
   Ext.apply(Ext.DatePicker.prototype, {
      format            : "d.m.Y"
   });
}
if(Ext.form.DateField){
   Ext.apply(Ext.form.DateField.prototype, {
      format            : "d.m.Y"
   });
}
if(Ext.grid.PropertyColumnModel){
   Ext.apply(Ext.grid.PropertyColumnModel.prototype, {
      dateFormat : "d.m.Y"
   });
}'!

javascriptPrivateItcExtLocalizationSerbian
	^'if(Ext.util.Format){
   Ext.util.Format.date = function(v, format){
      if(!!v) return "";
      if(!!(v instanceof Date)) v = new Date(Date.parse(v));
      return v.dateFormat(format || "d.m.Y");
   };
}

if(Ext.DatePicker){
   Ext.apply(Ext.DatePicker.prototype, {
      format            : "d.m.Y"
   });
}
if(Ext.form.DateField){
   Ext.apply(Ext.form.DateField.prototype, {
      format            : "d.m.Y"
   });
}
if(Ext.grid.PropertyColumnModel){
   Ext.apply(Ext.grid.PropertyColumnModel.prototype, {
      dateFormat : "d.m.Y"
   });
}'!

javascriptPrivateItcExtLocalizationSlovene
	^'if(Ext.util.Format){
   Ext.util.Format.date = function(v, format){
      if(!!v) return "";
      if(!!(v instanceof Date)) v = new Date(Date.parse(v));
      return v.dateFormat(format || "d.m.Y");
   };
}

if(Ext.DatePicker){
   Ext.apply(Ext.DatePicker.prototype, {
      format            : "d.m.Y"
   });
}
if(Ext.form.DateField){
   Ext.apply(Ext.form.DateField.prototype, {
      format            : "d.m.Y"
   });
}
if(Ext.grid.PropertyColumnModel){
   Ext.apply(Ext.grid.PropertyColumnModel.prototype, {
      dateFormat : "d.m.Y"
   });
}'!

javascriptPrivateItcExtNamespace
	^'Ext.namespace(''ITC.widget'', ''ITC.Ext'', ''ITC.Ext.form'', ''ITC.Ext.data'', ''ITC.Ext.grid'');
Ext.BLANK_IMAGE_URL="/' 
		, Processor activeProcess webApplication urlPrefix , '/images/default/s.gif";'!

javascriptPrivateItcExtNumberField
	^'ITC.Ext.form.NumberField = function(config){
	ITC.Ext.form.NumberField.superclass.constructor.call(this, config);
};

Ext.extend(ITC.Ext.form.NumberField, Ext.form.NumberField,  {
	/**
	* @cfg {String} decimalPoint Character(s) to allow as the decimal point (defaults to '','')
	*/
	decimalPoint : ",",
	/**
	* @cfg {String} decimalSeparator Character(s) to allow as the decimal separator (defaults to ''.'')
	*/
	thousandsSeparator : ".",
	
	initEvents : function(){
		this.decimalSeparator = this.decimalPoint + this.thousandsSeparator;
		ITC.Ext.form.NumberField.superclass.initEvents.call(this);
	},
	beforeBlur : function(){
		var v = this.parseNumber(this.getRawValue());
		if (v)
			this.setValue(this.fixPrecision(v));
	},
	validateValue : function(value) {
		if (!!Ext.form.NumberField.superclass.validateValue.call(this, value)) {
			return false;
		}
		if(value.length < 1){ // if it''s blank and textfield didn''t flag it then it''s valid
			return true;
		}
		value = String(value).replace(this.thousandsSeparator, "");
		value = String(value).replace(this.decimalPoint, ".");
		if (isNaN(value)) {
			this.markInvalid(String.format(this.nanText, value));
			return false;
		}
		var num = this.parseValue(value);
		if (num < this.minValue) {
			this.markInvalid(String.format(this.minText, this.minValue));
			return false;
		}
		if (num > this.maxValue) {
			this.markInvalid(String.format(this.maxText, this.maxValue));
			return false;
		}
		return true;
	},
	setValue : function(aNumber){
		Ext.form.NumberField.superclass.setValue.call(this, ITC.util.FloatToString(this.parseNumber(aNumber), this.decimalPrecision, this.decimalPoint, this.thousandsSeparator));
	},
	getValue : function(){
		return ITC.util.FloatToString(this.parseNumber(Ext.form.NumberField.superclass.getValue.call(this)) || null, this.decimalPrecision, this.decimalPoint, this.thousandsSeparator);
	},	
	parseNumber : function(pValue){
		return (!!pValue || !!ITC.util.IsString(pValue))?pValue:ITC.util.StringToFloat(pValue, this.decimalPoint);
	},
	parseValue : function(pValue) {
		return ITC.util.StringToFloat(pValue, ''.'');
	}
});'!

javascriptPrivateItcExtRowSelectionModel
	^'ITC.Ext.grid.RowSelectionModel = function(config){
    ITC.Ext.grid.RowSelectionModel.superclass.constructor.call(this);
};

Ext.extend(ITC.Ext.grid.RowSelectionModel, Ext.grid.RowSelectionModel,  {
	// Override because of shift and ctrl key press problems. We have to cache the variables.
	onEditorKey : function(field, e){
		var k = e.getKey(), newCell, g = this.grid, ed = g.activeEditor;
		var shiftPressed = e.shiftKey == true;
		var ctrlPressed = e.ctrlKey == true;
		
		if (k == e.TAB) {
			e.stopEvent();
			ed.completeEdit();
			if (shiftPressed)
				newCell = g.walkCells(ed.row, ed.col-1, -1, this.acceptsNav, this);
			else
				newCell = g.walkCells(ed.row, ed.col+1, 1, this.acceptsNav, this);
		} else if (k == e.ENTER && !!ctrlPressed) {
			e.stopEvent();
			ed.completeEdit();
			if (shiftPressed)
				newCell = g.walkCells(ed.row-1, ed.col, -1, this.acceptsNav, this);
			else
				newCell = g.walkCells(ed.row+1, ed.col, 1, this.acceptsNav, this);
		} else if (k == e.ESC) {
			ed.cancelEdit();
		}
		if (newCell)
			g.startEditing(newCell[0], newCell[1]);
	}
});'!

javascriptPrivateItcExtSuggestField
	^'ITC.Ext.form.SuggestField = function(config){
	ITC.Ext.form.SuggestField.superclass.constructor.call(this, config);
	this.ddMatch = null;
};

Ext.extend(ITC.Ext.form.SuggestField, Ext.form.TriggerField,  {
	urlPrefix: '''',
	displayIndex: 0,
	valueIndex: 0,
	displayedIndices: null,
	additionalRequestFields: null,
	isDropDown: false,
	hideTrigger: true,
	validateValue : function(value) {
		if (!!ITC.Ext.form.SuggestField.superclass.validateValue.call(this, value))
			return false;
		return true;
	},
	getValue : function(){
		return [this.hiddenValueEl.dom.value, this.el.dom.value];
	},
	setRawValue : function(pValue) {
		if (ITC.util.IsArray(pValue)) {
			if (pValue.length > 1) {
				this.hiddenValueEl.dom.value = ITC.util.IsUndefined(pValue[0])||(pValue[0] == null)?'''':pValue[0];
				this.el.dom.value = ITC.util.IsUndefined(pValue[1])||(pValue[1] == null)?'''':pValue[1];
			} else {
				this.el.dom.value = ITC.util.IsUndefined(pValue[0])||(pValue[0] == null)?'''':pValue[0];
			}
		} else {
			this.el.dom.value = ITC.util.IsUndefined(pValue)||(pValue == null)?'''':pValue;
		}
	},
	setValue : function(pValue) {
		this.value = pValue;
		if(this.rendered) 
		this.setRawValue(pValue);
	},	
	onRender : function(ct) {
		var hidden;
		
		ITC.Ext.form.SuggestField.superclass.onRender.call(this, ct);
		this.hiddenValueEl = this.wrap.createChild({tag: ''input'', type: ''hidden''});
		this.suggest = new ITC.widget.TypingSuggest(this.urlPrefix, this.el.dom, this.hiddenValueEl.dom, this.displayIndex, this.valueIndex, this.displayedIndices, null, (this.isDropDown==true?this.trigger.dom:null), this.isDropDown==true);
		if (this.additionalRequestFields) {
			for (i=0;i<this.additionalRequestFields.length;i++)
				this.suggest.addRequestField(this.additionalRequestFields[i]);
		}
	}
});'!

javascriptPrivateItcExtTranslation
	^'Ext.UpdateManager.defaults.indicatorText = ''<div class="itcLoadingIndicator">' 
		, 'asp.label.ajax.Loading' webTranslate 
			, '</div>'';

if(Ext.View){
   Ext.View.prototype.emptyText = "";
}

if(Ext.grid.Grid){
   Ext.grid.Grid.prototype.ddText = ' 
			, 'Ext.trans.selectedRows' webTranslate asJavascriptValue 
			, ';
}

if(Ext.TabPanelItem){
   Ext.TabPanelItem.prototype.closeText = ' 
			, 'Ext.trans.closeTab' webTranslate asJavascriptValue 
			, ';
}

if(Ext.form.Field){
   Ext.form.Field.prototype.invalidText = ' 
			, 'Ext.trans.valueInvalid' webTranslate asJavascriptValue 
			, ';
}

if(Ext.LoadMask){
    Ext.LoadMask.prototype.msg = ' 
			, 'Ext.trans.loading' webTranslate asJavascriptValue , ';
}

Date.monthNames = ' 
		, (#('codes.month.January' 'codes.month.February' 'codes.month.March' 'codes.month.April' 'codes.month.May' 'codes.month.June' 'codes.month.July' 'codes.month.August' 'codes.month.September' 'codes.month.October' 'codes.month.November' 'codes.month.December') 
				collect: [:each | each webTranslate]) asJavascriptValue 
			, ';

Date.dayNames = ' 
			, (#('codes.day.Monday' 'codes.day.Tuesday' 'codes.day.Wednesday' 'codes.day.Thursday' 'codes.day.Friday' 'codes.day.Saturday' 'codes.day.Sunday') 
					collect: [:each | each webTranslate copyFrom: 1 to: 3]) asJavascriptValue 
			, ';

if(Ext.MessageBox){
   Ext.MessageBox.buttonText = {
      ok     : ' 
			, 'asp.button.OK' webTranslate asJavascriptValue , ',
      cancel : ' 
		, 'asp.button.Cancel' webTranslate asJavascriptValue , ',
      yes    : ' 
		, 'asp.label.Yes' webTranslate asJavascriptValue , ',
      no     : ' 
		, 'asp.label.No' webTranslate asJavascriptValue 
			, '
   };
}

if(Ext.DatePicker){
   Ext.apply(Ext.DatePicker.prototype, {
      todayText         : ' 
			, 'Ext.trans.today' webTranslate asJavascriptValue , ',
      minText           : ' 
		, 'Ext.trans.dateTooSmall' webTranslate asJavascriptValue 
			, ',
      maxText           : "This date is after the maximum date",
      disabledDaysText  : "",
      disabledDatesText : "",
      monthNames	: Date.monthNames,
      dayNames		: Date.dayNames,
      nextText          : ' 
			, 'Ext.trans.nextMonth' webTranslate asJavascriptValue , ',
      prevText          : ' 
		, 'Ext.trans.nextMonth' webTranslate asJavascriptValue , ',
      monthYearText     : ' 
		, 'Ext.trans.chooseMonth' webTranslate asJavascriptValue , ',
      todayTip          : ' 
		, 'Ext.trans.todayTip' webTranslate asJavascriptValue 
			, '
   });
}

if(Ext.PagingToolbar){
   Ext.apply(Ext.PagingToolbar.prototype, {
      beforePageText : ' 
			, 'Ext.trans.beforePageText' webTranslate asJavascriptValue , ',
      afterPageText  : ' 
		, 'Ext.trans.afterPageText' webTranslate asJavascriptValue , ',
      firstText      : ' 
		, 'Ext.trans.firstPage' webTranslate asJavascriptValue , ',
      prevText       : ' 
		, 'Ext.trans.previousPage' webTranslate asJavascriptValue , ',
      nextText       : ' 
		, 'Ext.trans.nextPage' webTranslate asJavascriptValue , ',
      lastText       : ' 
		, 'Ext.trans.lastPage' webTranslate asJavascriptValue , ',
      refreshText    : ' 
		, 'Ext.trans.refresh' webTranslate asJavascriptValue , ',
      displayMsg     : ' 
		, 'Ext.trans.displayedPage' webTranslate asJavascriptValue , ',
      emptyMsg       : ' 
		, 'Ext.trans.noData' webTranslate asJavascriptValue 
			, '
   });
}

if(Ext.form.TextField){
   Ext.apply(Ext.form.TextField.prototype, {
      minLengthText : ' 
			, 'Ext.trans.minLengthText' webTranslate asJavascriptValue , ',
      maxLengthText : ' 
		, 'Ext.trans.maxLengthText' webTranslate asJavascriptValue , ',
      blankText     : ' 
		, 'Ext.trans.blankText' webTranslate asJavascriptValue 
			, ',
      regexText     : "",
      emptyText     : null
   });
}

if(Ext.form.NumberField){
   Ext.apply(Ext.form.NumberField.prototype, {
      minText : ' 
			, 'Ext.trans.minText' webTranslate asJavascriptValue , ',
      maxText : ' 
		, 'Ext.trans.maxText' webTranslate asJavascriptValue , ',
      nanText : ' 
		, 'Ext.trans.nanText' webTranslate asJavascriptValue 
			, '
   });
}

if(Ext.form.DateField){
   Ext.apply(Ext.form.DateField.prototype, {
      disabledDaysText  : ' 
			, 'Ext.trans.disabled' webTranslate asJavascriptValue , ',
      disabledDatesText : ' 
		, 'Ext.trans.disabled' webTranslate asJavascriptValue , ',
      minText           : ' 
		, 'Ext.trans.minDateText' webTranslate asJavascriptValue , ',
      maxText           : ' 
		, 'Ext.trans.maxDateText' webTranslate asJavascriptValue , ',
      invalidText       : ' 
		, 'Ext.trans.invalidDateText' webTranslate asJavascriptValue 
			, '
   });
}

if(Ext.form.ComboBox){
   Ext.apply(Ext.form.ComboBox.prototype, {
      loadingText       : ' 
			, 'Ext.trans.loading' webTranslate asJavascriptValue 
			, ',
      valueNotFoundText : undefined
   });
}

if(Ext.form.VTypes){
   Ext.apply(Ext.form.VTypes, {
      emailText    : ' 
			, 'Ext.trans.emailText' webTranslate asJavascriptValue , ',
      urlText      : ' 
		, 'Ext.trans.urlText' webTranslate asJavascriptValue , ',
      alphaText    : ' 
		, 'Ext.trans.alphaText' webTranslate asJavascriptValue , ',
      alphanumText : ' 
		, 'Ext.trans.alphanumText' webTranslate asJavascriptValue 
			, '
   });
}

if(Ext.grid.GridView){
   Ext.apply(Ext.grid.GridView.prototype, {
      sortAscText  : ' 
			, 'Ext.trans.sortAscText' webTranslate asJavascriptValue , ',
      sortDescText : ' 
		, 'Ext.trans.sortDescText' webTranslate asJavascriptValue , ',
      lockText     : ' 
		, 'Ext.trans.lockText' webTranslate asJavascriptValue , ',
      unlockText   : ' 
		, 'Ext.trans.unlockText' webTranslate asJavascriptValue , ',
      columnsText  : ' 
		, 'Ext.trans.columnsText' webTranslate asJavascriptValue 
			, '
   });
}

if(Ext.grid.PropertyColumnModel){
   Ext.apply(Ext.grid.PropertyColumnModel.prototype, {
      nameText   : ' 
			, 'Ext.trans.nameText' webTranslate asJavascriptValue , ',
      valueText  : ' 
		, 'Ext.trans.valueText' webTranslate asJavascriptValue 
			, '
   });
}

if(Ext.SplitLayoutRegion){
   Ext.apply(Ext.SplitLayoutRegion.prototype, {
      splitTip            : ' 
			, 'Ext.trans.splitTip' webTranslate asJavascriptValue , ',
      collapsibleSplitTip : ' 
		, 'Ext.trans.collapsibleSplitTip' webTranslate asJavascriptValue , '
   });
}'!

javascriptPrivateItcLegacy
	^'commonFormatMoneyField = ITC.util.FormatMoneyField;
commonFloatToStringWithMinimalDecimals = ITC.util.FloatToStringWithMinimalDecimals;
commonStringToDate = ITC.util.StringToDate;
commonDateToString = ITC.util.DateToString;
commonStringToFloat = ITC.util.StringToFloat;
commonFloatToString = ITC.util.FloatToString;
commonIsArray = ITC.util.IsArray;
commonIsUndefined = ITC.util.IsUndefined;
commonIsBrowserInternetExplorer55Up = ITC.util.IsBrowserInternetExplorer55Up;
calculateDate = ITC.util.CalculateDate;
commonEncodeForRegEx = ITC.util.EncodeForRegEx;
Hashtable = ITC.util.Hashtable;
commonGetTopWindow = ITC.dom.GetTopWindow;
commonGetDocumentWidth = ITC.dom.GetDocumentWidth;
commonGetDocumentHeight = ITC.dom.GetDocumentHeight;
commonGetWindowWidth = ITC.dom.GetWindowWidth;
commonGetWindowHeight = ITC.dom.GetWindowHeight;
commonCenterElement = ITC.dom.CenterElement;
commonGetElementPositionLeft = ITC.dom.GetElementPositionLeft;
commonGetElementPositionTop = ITC.dom.GetElementPositionTop;
commonGetInlineElementPositionLeft = ITC.dom.GetInlineElementPositionLeft;
commonGetInlineElementPositionTop = ITC.dom.GetInlineElementPositionTop;
commonIsMouseInsideElement = ITC.dom.IsMouseInsideElement;
commonGetElementById = ITC.dom.GetElement;
commonGetElement = ITC.dom.GetElement;
commonSetPointerCursorFor = ITC.dom.SetPointerCursorFor;
commonFindMatchingParentFor = ITC.dom.FindMatchingParentFor;
commonToggleDropDowns = ITC.dom.ToggleDropDowns;
commonIEDisableSelectFor = ITC.dom.IEDisableSelectFor;
commonAddEvent = ITC.event.AddListener;
commonRemoveEvent = ITC.event.RemoveListener;
commonRemoveAllEventsForClient = ITC.event.RemoveAllListenersForClient;
commonRemoveAllEventsForElement = ITC.event.RemoveAllListenersForElement;
commonRemoveAllEvents = ITC.event.RemoveAllListeners;
disposeElement = ITC.dom.DisposeElement;'!

javascriptPrivateItcLocalizationBosnian
	^'// Bosnian localization
ITC.localization = {
	DecimalPoint: ''.'',
	ThousandSeparator: '','',
	DateFormat: ''DD.MM.YYYY''
};'!

javascriptPrivateItcLocalizationCroatian
	^'// Croatian localization

ITC.localization = {
	DecimalPoint: '','',
	ThousandSeparator: ''.'',
	DateFormat: ''DD.MM.YYYY''
};'!

javascriptPrivateItcLocalizationCzech
	^'// Czech localization

ITC.localization = {
	DecimalPoint: ''.'',
	ThousandSeparator: '','',
	DateFormat: ''MM/DD/YYYY''
};'!

javascriptPrivateItcLocalizationEnglish
	^'// English localization

ITC.localization = {
	DecimalPoint: ''.'',
	ThousandSeparator: '','',
	DateFormat: ''MM/DD/YYYY''
};'!

javascriptPrivateItcLocalizationGerman
	^'// Deutsch localization

ITC.localization = {
	DecimalPoint: ''.'',
	ThousandSeparator: '','',
	DateFormat: ''MM/DD/YYYY''
};'!

javascriptPrivateItcLocalizationRussian
	^'// Russian localization

ITC.localization = {
	DecimalPoint: ''.'',
	ThousandSeparator: '','',
	DateFormat: ''MM/DD/YYYY''
};'!

javascriptPrivateItcLocalizationSerbian
	^'// Serbian localization
ITC.localization = {
	DecimalPoint: ''.'',
	ThousandSeparator: '','',
	DateFormat: ''DD.MM.YYYY''
};'!

javascriptPrivateItcLocalizationSlovene
	^'// Slovenian localization

ITC.localization = {
	DecimalPoint: '','',
	ThousandSeparator: ''.'',
	DateFormat: ''DD.MM.YYYY''
};'!

javascriptPrivateItcNamespace
	^'var ITC = {};
ITC.widget = {};
ITC.localization = {
	DecimalPoint: ''.'',
	ThousandSeparator: '','',
	DateFormat: ''DD.MM.YYYY''
};'!

javascriptPrivateItcTranslation
	^'ITC.translation = {
	DayNames: ' 
		, (#('codes.day.Monday' 'codes.day.Tuesday' 'codes.day.Wednesday' 'codes.day.Thursday' 'codes.day.Friday' 'codes.day.Saturday' 'codes.day.Sunday') 
				collect: [:each | each webTranslate copyFrom: 1 to: 3]) asJavascriptValue 
			, ',
	MonthNames: ' 
			, (#('codes.month.January' 'codes.month.February' 'codes.month.March' 'codes.month.April' 'codes.month.May' 'codes.month.June' 'codes.month.July' 'codes.month.August' 'codes.month.September' 'codes.month.October' 'codes.month.November' 'codes.month.December') 
					collect: [:each | each webTranslate]) asJavascriptValue 
			, ',
	WaitClockMsg: ' , 'asp.label.PleaseWait' webTranslate asJavascriptValue 
		, ',
	TypingSuggestNoResults: ' , 'error.NoMatchFound' webTranslate asJavascriptValue 
		, ',
	DialogCloseLabel: ' , 'asp.button.CloseWindow' webTranslate asJavascriptValue 
		, ',
	DialogHelpLabel: ' , 'asp.button.Help' webTranslate asJavascriptValue 
		, ',
	AddRowTooltip: ' , 'Grid.newRowMessage' webTranslate asJavascriptValue 
		, ',
	AddRow: ' , 'Grid.newRowMessage.short' webTranslate asJavascriptValue 
		, ',
	RemoveRowTooltip: ' , 'Grid.removeRowMessage' webTranslate asJavascriptValue 
		, ',
	RemoveRow: ' , 'Grid.removeRowMessage.short' webTranslate asJavascriptValue 
		, ',
	MoveRowUpTooltip: ' , 'Grid.moveUpRowMessage' webTranslate asJavascriptValue 
		, ',
	MoveRowUp: ' , 'Grid.moveUpRowMessage.short' webTranslate asJavascriptValue 
		, ',
	MoveRowDownTooltip: ' , 'Grid.moveDownRowMessage' webTranslate asJavascriptValue 
		, ',
	MoveRowDown: ' , 'Grid.moveDownRowMessage.short' webTranslate asJavascriptValue 
		, ',
	MoveRowToTopTooltip: ' , 'Grid.moveToTopRowMessage' webTranslate asJavascriptValue 
		, ',
	MoveRowToTop: ' , 'Grid.moveToTopRowMessage.short' webTranslate asJavascriptValue 
		, ',
	MoveRowToBottomTooltip: ' , 'Grid.moveToBottomRowMessage' webTranslate asJavascriptValue 
		, ',
	MoveRowToBottom: ' , 'Grid.moveToBottomRowMessage.short' webTranslate asJavascriptValue 
		, '
};'!

javascriptPrivateItcUtil
	^'ITC.util = {
	IsFunction: function(pObject) {
		return typeof pObject == ''function'';
	},
	IsObject: function(pObject) {
		return typeof pObject == ''object'' || ITC.util.IsFunction(pObject);
	},
	IsArray: function(pObject) {
		if (!!pObject)
			return false;
		if (pObject.constructor && pObject.constructor.toString().indexOf(''Array'') > -1)
			return true;
		else
			return ITC.util.IsObject(pObject) && pObject.constructor == Array;
	},
	IsBoolean: function(pObject) {
		return typeof pObject == ''boolean'';
	},
	IsNull: function(pObject) {
		return pObject === null;
	},
	IsNumber: function(pObject) {
		return !!isNaN(pObject);
	},
	IsString: function(pObject) {
		return typeof pObject == ''string'';
	},
	IsUndefined: function(pObject) {
		return typeof pObject == ''undefined'';
	},
	IsBrowserInternetExplorer8Below: function() {
		if(!!ITC.util.IsBrowserInternetExplorer()) return false;
		var agt = navigator.userAgent.toLowerCase();
		var ind = agt.indexOf("msie ");
		if(ind == -1) return false;
		return (parseInt(agt.substr(ind+5, 3))) < 8;
	},
	IsBrowserInternetExplorer55Up: function() {
		var agt = navigator.userAgent.toLowerCase();
		var major = parseInt(navigator.appVersion, 10);
			
		return (ITC.util.IsBrowserInternetExplorer() && (major >= 4) && (agt.indexOf("msie 4") == -1) && (agt.indexOf("msie 5") == -1));
	},
	IsBrowserInternetExplorer: function() {
		var agt = navigator.userAgent.toLowerCase();
		var isIE = ((agt.indexOf("msie") !!= -1) && (agt.indexOf("opera") == -1));
		return isIE && window.ActiveXObject;
	},
	IsBrowserOpera: function() {
		return navigator.userAgent.toLowerCase().indexOf("opera") !!= -1;
	},
	IsVisible: function(pObject) {
		if(pObject.style.display=="none" || pObject.style.visibility == ''hidden'') return false;
		if(pObject && pObject.parentNode && pObject.parentNode.style) return ITC.util.IsVisible(pObject.parentNode);
		return true;
	},
	EncodeForRegEx: function(pString) {
		if (!!pString)
			return null;
		return pString.replace(/\\/, ''\\\\'').replace(/\(/, ''\\('').replace(/\)/, ''\\)'').replace(/\./, ''\\.'').replace(/\*/, ''.*'');
	},
	EncodeForURL: function(pString) {
		var i, unicode, ch, result = '''';
		if(!!pString) return result;
		for (i=0;i<pString.length;i++) {
			unicode=pString.charCodeAt(i);
			if(unicode<= 32)
			{if(unicode<16) result+="%0"; else result+="%";
			result+=unicode.toString(16).toUpperCase();
			}
			else
			{if(unicode>127){result+="%26%23"+unicode.toString()+"%3B";}
			else{
			ch=pString.charAt(i);
			switch (ch) {
				case ''$'':
					result += ''%24'';
				break;
				case ''&'':
					result += ''%26'';
				break;
				case ''+'':
					result += ''%2B'';
				break;
				case '','':
					result += ''%2C'';
				break;
				case ''/'':
					result += ''%2F'';
				break;
				case '':'':
					result += ''%3A'';
				break;
				case '';'':
					result += ''%3B'';
				break;
				case ''='':
					result += ''%3D'';
				break;
				case ''?'':
					result += ''%3F'';
				break;
				case ''@'':
					result += ''%40'';
				break;
				case ''"'':
					result += ''%22'';
				break;
				case ''<'':
					result += ''%3C'';
				break;
				case ''>'':
					result += ''%3E'';
				break;
				case ''#'':
					result += ''%23'';
				break;
				case ''%'':
					result += ''%25'';
				break;
				default:
					result += ch;
			}}}
		}
		return result;
	},
	FormatMoneyField: function(name, maxDecimals,minDecimals) {
		var i, k, el, str, strChar, tmpStr, val, tmpStyle, valArray = new Array();
	
		el = ITC.dom.GetElement(name);
		str = el.value;
		tmpStr = '''';
		k = 0;
		i = 0;
		while (i <= str.length) {
			strChar = str.charAt(i);
			if (strChar == ''+'' || strChar == ''-'' || strChar == ''*'' || strChar == ''/'' || strChar==''('' || strChar=='')'') {
				valArray[k] = ITC.util.StringToFloat(tmpStr);
				valArray[k+1] = strChar;
				tmpStr = '''';
				k += 2;
			} else {
				tmpStr += strChar;
				valArray[k] = ITC.util.StringToFloat(tmpStr);
			};
			i += 1;
		};
		tmpStr = '''';
		i = 0;
		while (i < valArray.length)	{	
			if (!!(ITC.util.IsUndefined(valArray[i]) || (valArray[i] == null))) 
				tmpStr = tmpStr+valArray[i];
			i+=1;
		};
		try {
			val = eval(tmpStr);
		} catch(e) {};
		if (ITC.util.IsUndefined(val) || (val == null) || (val == "Infinity") || (val == "-Infinity") || (val == "NaN") || (!!val)) {
			el.className = ''error'';
		} else {
			el.value = ITC.util.FloatToStringWithMinimalDecimals(val, maxDecimals, minDecimals);
			el.className = '''';
		}		
	},
	FloatToStringWithMinimalDecimals: function(pFloat,maxDecimals,minDecimals) {
		var i, str, strTmp, val, dpPos, floatTmp;
		floatTmp = pFloat*1;
		str = ITC.util.FloatToString(floatTmp, maxDecimals);
		val = Math.abs(ITC.util.StringToFloat(str));
		i = str.length-1;
		strTmp = '''';
		if (val !!=0) {
			strTmp = str;
			if (Math.round(val) !!= val) {		
				while ((str.charAt(i) == ''0'') || (str.charAt(i) == ITC.localization.DecimalPoint)) {
					strTmp=str.substr(0, i);
					i = i-1;
				}
			} else {
				strTmp = str.substr(0, i-maxDecimals);
			}
			if (minDecimals !!= 0) {
				i = strTmp.length-1;
				dpPos = strTmp.indexOf(ITC.localization.DecimalPoint);
				if(dpPos !!= -1){
					val = strTmp.substr(dpPos, i).length-1;
					if (val<minDecimals) {
						for (i=val;i<minDecimals;i++)
							strTmp = strTmp + ''0'';
					}
				} else {
					strTmp = strTmp + ITC.localization.DecimalPoint;
					for (i=0;i<minDecimals;i++)
						strTmp=strTmp + ''0'';
				}
			}
		} else {
			if (minDecimals==0) {
				strTmp = ''0'';
			} else {
				strTmp = ''0'' + ITC.localization.DecimalPoint;
				for (i=0;i<minDecimals;i++)
					strTmp = strTmp + ''0'';
			}
		}
		return (strTmp);
	},
	StringToDate: function(pString) {
		var df = ITC.localization.DateFormat;
		var str, tokens, monthIndex, dayIndex, yearIndex, day, month, year;
	
		if (!!pString)
			return null;
		str = pString.trimBlanks();
		yearIndex = 2;
		if (df == ''DD.MM.YYYY'') {
			tokens = str.split(''.'');
			dayIndex = 0;
			monthIndex = 1;
		} else if (df == ''MM/DD/YYYY'') {
			tokens = str.split(''/'');
			dayIndex = 1;
			monthIndex = 0;
		} else if (df == ''YYYY-MM-DD'') {
			tokens = str.split(''-'');
			dayIndex = 2;
			monthIndex = 1;
			yearIndex = 0;
		} else {
			return null;
		}
		if ((tokens.length < 1) || (tokens.length > 3))
			return null;
		if ((tokens.length == 1) && (yearIndex == 2) && str.isAllDigits()) {
			if (str.length > 4)
				tokens = [str.substr(0, 2), str.substr(2, 2), str.substr(4)];
			else if (str.length > 2)
				tokens = [str.substr(0, 2), str.substr(2)];
		}
		day = (tokens.length-1)<dayIndex?0:parseInt(tokens[dayIndex], 10);
		month = (tokens.length-1)<monthIndex?(new Date()).getMonth():parseInt(tokens[monthIndex], 10) - 1;
		year = (tokens.length-1)<yearIndex?0:parseInt(tokens[yearIndex], 10);
		if (!!year)
			year = (new Date()).getFullYear();
		if (year < 50)
			year = 2000 + year;
		else if (year < 100)
			year = 1900 + year;
		if (!!day || (day < 0) || (day > 31))
			day = 1;
		if (!!month || (month < 0) || (month > 11))
			month = 0;
		return new Date(year, month, day);
	},
	DateToString: function(pDate) {
		if (!!pDate)
			return '''';
		return pDate.itcFormat(ITC.localization.DateFormat);
	},
	StringToFloat: function(pString, pDecimalPoint) {
		var i, ch, purgedString, dp;
		if (!!pString)
			return null;
		purgedString = '''';
		dp = pDecimalPoint?pDecimalPoint:ITC.localization.DecimalPoint;
		for (i=0;i<pString.length;i++) {
			ch = pString.charAt(i);
			if (ch >= ''0'' && ch <= ''9'')
				purgedString += ch;
			else if (ch == dp)
				purgedString += ''.'';
			else if ((ch == ''-'') && (i == 0))
				purgedString += ch;
		}
		return parseFloat(purgedString);
	},
	FloatToString: function(pFloat, pPrecision, pDecimalPoint, pThousandSeparator) {
		var str, q, r, n, sign, dp, ts;
		
		if ((!!pFloat && (pFloat !!= 0)) || !!(pFloat*1))
			return '''';
		dp = pDecimalPoint?pDecimalPoint:ITC.localization.DecimalPoint;
		ts = pThousandSeparator?pThousandSeparator:ITC.localization.ThousandSeparator;
		sign = pFloat<0?''-'':'''';
		n = Math.abs(pFloat);
		if (!!pPrecision || (pPrecision == 0))
			return '''' + Math.floor(pFloat);
		str = '''' + Math.round(n * Math.pow(10.0, pPrecision) - (Math.floor(n) * Math.pow(10.0, pPrecision)));
		if (str.length > pPrecision)
			return ITC.util.FloatToString((Math.floor(n)+1)*(pFloat<0?-1:1), pPrecision, pDecimalPoint, pThousandSeparator);
		while (str.length < pPrecision) {
			str = ''0'' + str;
		}
		if (dp.length > 0)
			str = dp + str;
		if (ts.length == 0)
			return (sign + Math.floor(n) + str);
		q = Math.floor(n);
		r = q % 1000;
		while (Math.floor(q / 1000) !!= 0) {
			str = r + str;
			if (r < 10) {
				str = ''00'' + str;
			} else {
				if (r < 100)
					str = ''0'' + str;
			}
			str = ts + str;
			q = Math.floor(q / 1000);
			r = q % 1000;
		}
		return (sign + q + str);
	},
	CalculateDate: function(fromDateField, untilDateField, daysField) {
		var date = ITC.util.StringToDate(fromDateField.value);
		var daysToAdd = parseInt(daysField.value, 10);
		if (isNaN(daysToAdd)) daysToAdd = -1;
		if ((date !!= null) && (daysToAdd > 0)) {
			date = date.addDays(daysToAdd);
			untilDateField.value = ITC.util.DateToString(date);
		}
	}
};

ITC.util.Hashtable = function() {
	this.m_Keys = new Array();
	this.m_Values = new Array();
};

ITC.util.Hashtable.prototype = {
	_checkIntegrity: function() {
		if (this.m_Keys.length !!= this.m_Values.length)
			throw "Hashtable integrity failed!!";
	},
	_indexOfKey: function(pKey) {
		var i;
		
		if (pKey == null)
			return -1;
		for (i=0;i<this.m_Keys.length;i++)
			if (this.m_Keys[i] == pKey)
				return i;
		return -1;
	},
	containsKey: function(pKey) {
		return this._indexOfKey(pKey)>=0;
	},
	put: function(pKey, pValue) {
		var index = this._indexOfKey(pKey);
		
		if (index < 0)
			index = this.m_Keys.length;
		this.m_Keys[index] = pKey;
		this.m_Values[index] = pValue;
		this._checkIntegrity();
	},
	get: function(pKey) {
		var index = this._indexOfKey(pKey);
		
		if (index < 0)
			return null;
		return this.m_Values[index];
	},
	removeKey: function(pKey) {
		var index = this._indexOfKey(pKey);
		
		if (index < 0)
			return false;
		this.m_Keys.splice(index, 1);
		this.m_Values.splice(index, 1);
		this._checkIntegrity();
		return true;
	},
	getKeys: function() {
		var i, result = new Array();
		
		for (i=0;i<this.m_Keys.length;i++)
			result[i] = this.m_Keys[i];
		return result;
	},
	getValues: function() {
		var i, result = new Array();
		
		for (i=0;i<this.m_Values.length;i++)
			result[i] = this.m_Values[i];
		return result;
	},
	size: function() {
		return this.m_Keys.length;
	},
	clear: function() {
		this.m_Keys = new Array();
		this.m_Values = new Array();
	}
};

Function.prototype.itcCreateDelegate = function(pScope, pArguments, pAppendArguments) {
	var fnc = this;

	return function() {
		var applyArgs, callArgs = pArguments || arguments;

		if (pAppendArguments === true) {
			callArgs = Array.prototype.slice.call(arguments, 0);
			callArgs = callArgs.concat(pArguments);
		} else if (typeof pAppendArguments == "number") {
			callArgs = Array.prototype.slice.call(arguments, 0);
			applyArgs = [appendArgs, 0].concat(pArguments);
			Array.prototype.splice.apply(callArgs, applyArgs);
		}
		return fnc.apply(pScope || window, callArgs);
	}
};

Date.prototype.addDays = function(pDays) {
	var d=new Date();
	d.setTime(this.getTime());
	d.setDate(this.getDate()+pDays);
	return d;
};

Date.prototype.subtractDays = function(pDays) {
	var d=new Date();
	d.setTime(this.getTime());
	d.setDate(this.getDate()+pDays);
	return d;
};

Date.prototype.getHours12 = function() {
  return (this.getHours()<12)?this.getHours():this.getHours()-12;
}

/* 
	YYYY = 4 digit year
	YY   = 2 digit year
	MM   = 2 digit month number
	M    = 1 or 2 digit month
	DD   = 2 digit day 
	D    = 1 or 2 digit day
	HH   = 2 digit 24 hour
	H    = 1 or 2 digit 24 hour
	hh   = 2 digit 12 Hour
	h    = 1 or 2 digit 12 Hour
	mm   = 2 digit minute
	m    = 1 or 2 digit minute
	ss   = 2 digit second
	s    = 1 or 2 digit second
	nnn  = milliseconds
*/
Date.prototype.itcFormat = function(fs) {
	fs = fs.replace(/YYYY/, this.getFullYear().toString());
	fs = fs.replace(/YY/, this.getFullYear().toString().substr(2,2));
	fs = fs.replace(/MM/, (this.getMonth() + 1) > 9?(this.getMonth() + 1).toString():''0'' + (this.getMonth() + 1).toString());
	fs = fs.replace(/M/, (this.getMonth() + 1).toString());
	fs = fs.replace(/DD/, this.getDate() > 9?this.getDate().toString():''0'' + this.getDate().toString());
	fs = fs.replace(/D/, this.getDate().toString());
	fs = fs.replace(/HH/, this.getHours() > 9?this.getHours().toString():''0'' + this.getHours().toString());
	fs = fs.replace(/H/, this.getHours().toString());
	fs = fs.replace(/hh/, this.getHours12() > 9?this.getHours12().toString():''0'' + this.getHours12().toString());
	fs = fs.replace(/h/, this.getHours12());
	fs = fs.replace(/mm/, this.getMinutes() > 9?this.getMinutes().toString():''0'' + this.getMinutes().toString());
	fs = fs.replace(/m/, this.getMinutes().toString());
	fs = fs.replace(/ss/, this.getSeconds() > 9?this.getSeconds().toString():''0'' + this.getSeconds().toString());
	fs = fs.replace(/s/, this.getSeconds().toString());
	fs = fs.replace(/nnn/, this.getMilliseconds().toString());
	return fs;
};

String.prototype.trimBlanks = function() {
	var b = 0;
	var e = this.length - 1;
	
	while (this.substr(b, 1) == '' '')
		b++;
	while (this.substr(e, 1) == '' '')
		e--;
	return this.substring(b, e+1);
};

String.prototype.isAllDigits = function() {
	var i;
	
	for (i=0;i<this.length;i++) {
		if ((this.charAt(i) < ''0'') || (this.charAt(i) > ''9''))
			return false;
	}
	return true;
};

String.prototype.htmlDecode = function() {
	return this.replace(/&lt;/g, ''<'').replace(/&gt;/g, ''>'').replace(/&#39;/g, ''\'''').replace(/&quot;/g, ''"'').replace(/&#92;/g, ''\\'').replace(/&amp;/g, ''&'');
};

String.prototype.htmlEncode = function() {
	var i, ch, result = '''';
	for (i=0;i<this.length;i++) {
		ch = this.charAt(i);
		
		switch (ch) {
			case ''<'':
				result += ''&lt;'';
			break;
			case ''>'':
				result += ''&gt;'';
			break;
			case ''&'':
				result += ''&amp;'';
			break;
			case ''\'''':
				result += ''&#39;'';
			break;
			case ''"'':
				result += ''&quot;'';
			break;
			case ''\\'':
				result += ''&#92;'';
			break;
			default:
				result += ch;
		}
	}
	return result;
};
String.prototype.asUrlEncoded = function() {
	return ITC.util.EncodeForURL(this);
};'!

javascriptPrivateMainMenu
	^'ITC.widget.MainMenu = function() {
	this.m_Container = null;
	this.m_Items = new Array();
	this.m_OnHideFunctions = new Array();
	this.m_ActiveSubmenu = null;
	this.m_Width = null;
	this.m_Height = null;
	this.m_IsOpen = false;
	this.m_ParentMenu = null;
	this.m_OwnerObject = null;
	this.m_HidingTimer = null;
	this.m_CanHide = false;
	this.m_ItemsContainer = null;
	this.m_ItemsDefinitionUrl = null;
	this.m_ItemsDefinitionBeingRetrieved = false;
	this.m_ItemsDefinitionRetreived = false;
	this.m_RepeatItemsDefinitionRequestOnOpen = false;
};

ITC.widget.MainMenu.prototype = {
	indicatorText: ''<div class="itcLoadingIndicator">Loading...</div>'',
	
	initializeWidthAndHeight: function() {
		this.getContainer();
		this.m_Container.style.display = ''block'';
		this.m_Width = this.m_Container.offsetWidth;
		this.m_Height = this.m_Container.offsetHeight;
		this.m_Container.style.display = ''none'';
	},
	
	isOpen: function() {
	  return this.m_IsOpen;
	},
	
	setParentMenu: function(pMenu) {
		this.m_ParentMenu = pMenu;
	},
	
	setOwnerObject: function(pObject) {
		this.m_OwnerObject = pObject;
	},
	
	getOwnerObject: function() {
		return this.m_OwnerObject;
	},

	getRootMenu: function() {
		var m = this.m_ParentMenu;

		while (m) {
			if (!!m.m_ParentMenu)
				return m;
			m = m.m_ParentMenu;
		}
		return this;
	},
	
	getWidth: function() {
		if (!!this.m_Width)
			this.initializeWidthAndHeight();
		return this.m_Width;
	},
	
	getHeight: function() {
		if (!!this.m_Height)
			this.initializeWidthAndHeight();
		return this.m_Height;
	},

	_emptyItemsContainer: function() {
		if (!!this.m_ItemsContainer)
			return;
		if (document.all) {
			while (this.m_ItemsContainer.childNodes.length > 0)
				this.m_ItemsContainer.removeChild(this.m_ItemsContainer.firstChild);
		} else {
			this.m_ItemsContainer.innerHTML = '''';
		}
	},
	
	_redrawItems: function() {
		var i, row, cell;
		
		if (!!this.m_ItemsContainer)
			return;
		this._emptyItemsContainer();
		for (i=0;i<this.m_Items.length;i++) {
			row = document.createElement(''tr'');
			this.m_ItemsContainer.appendChild(row);
			cell = document.createElement(''td'');
			row.appendChild(cell);
			cell.appendChild(this.m_Items[i].getContainer());
		}
	},
	
	getContainer: function() {
		var i, tbody, me;
	
		if (!!this.m_Container) {
			if (!!this.m_Items)
				return;
			me = this;
			this.m_Container = document.createElement(''table'');
			this.m_Container.cellSpacing = 0;
			this.m_Container.cellPadding = 0;
			this.m_Container.style.cursor = ''default'';
			this.m_Container.className = ''MainMenu'';
			this.m_Container.style.zIndex = ''1000'';
			this.m_Container.style.position = ''absolute'';
			this.m_Container.style.display = ''none'';
			document.body.appendChild(this.m_Container);
			tbody = document.createElement(''tbody'');
			this.m_Container.appendChild(tbody);
			this.m_ItemsContainer = tbody;
			this._redrawItems();
			ITC.dom.InitializeUndercoverFor(this.m_Container);
			ITC.event.AddListener("mouseout", this.m_Container, function(pEvent) {
				if (!!me.isMouseInside(pEvent)) {
					me.markBranchForHide();
					me.m_HidingTimer = setTimeout(function() {
						me.checkHideBranch();
					}, 1500);
				}
			});
			ITC.event.AddListener("contextmenu", this.m_Container, function(pEvent) {
				pEvent.cancelBubble = true;
				pEvent.returnValue = false;
				return false;
			});
			if (document.all) {
				ITC.event.AddListener(''dragstart'', this.m_Container, function() {
					return false;
				});
				ITC.event.AddListener(''selectstart'', this.m_Container, function() {
					return false;
				});
			}
		}
		return this.m_Container;
	},
	
	show: function(pX, pY) {
		var i, topWin, rootMenu, leftPos=pX, topPos=pY;
		
		topWin = ITC.dom.GetTopWindow();
		rootMenu = this.getRootMenu();
		try {
			if (topWin.___ITC_CurrentMenu && (topWin.___ITC_CurrentMenu !!= rootMenu))
				topWin.___ITC_CurrentMenu.hide();
		} catch (e) {}
		if (this.m_HidingTimer)
			clearTimeout(this.m_HidingTimer);
		this.getContainer();
		this.unhighlightAllItems();
		this.m_Container.style.display = ''block'';
		if ((leftPos + this.m_Container.offsetWidth) > ITC.dom.GetDocumentWidth()) {
			leftPos = ITC.dom.GetDocumentWidth() - this.m_Container.offsetWidth - 5;
			if (leftPos < 0)
				leftPos = 0;
		}
		if ((topPos + this.m_Container.offsetHeight) > ITC.dom.GetDocumentHeight()) {
			topPos = ITC.dom.GetDocumentHeight() - this.m_Container.offsetHeight - 5;
			if (topPos < 0)
				topPos = 0;
		}
		this.m_Container.style.left = leftPos + ''px'';
		this.m_Container.style.top = topPos + ''px'';
		ITC.dom.ShowUndercoverFor(this.m_Container);
		this.m_IsOpen = true;
		topWin.___ITC_CurrentMenu = rootMenu;
		if (this.m_ItemsDefinitionUrl && !!this.m_ItemsDefinitionBeingRetrieved && ((this.m_RepeatItemsDefinitionRequestOnOpen == true) || !!this.m_ItemsDefinitionRetreived))
			this._retrieveItemsDefinition(this.m_ItemsDefinitionUrl);
	},
	
	addOnHide: function(pFunction) {
		this.m_OnHideFunctions[this.m_OnHideFunctions.length] = pFunction;
	},
	
	hide: function() {
		var i, topWin, rootMenu;
		
		topWin = ITC.dom.GetTopWindow();
		rootMenu = this.getRootMenu();
		if (topWin.___ITC_CurrentMenu && (topWin.___ITC_CurrentMenu == rootMenu))
			topWin.___ITC_CurrentMenu = null;
		if (this.m_HidingTimer)
			clearTimeout(this.m_HidingTimer);
		for (i=0;i<this.m_Items.length;i++) {
			if (this.m_Items[i].m_Submenu)
				this.m_Items[i].m_Submenu.hide();
		}
		this.getContainer();
		this.m_Container.style.display = ''none'';
		ITC.dom.HideUndercoverFor(this.m_Container);
		if (this.m_OnHideFunctions.length > 0) {
			for (i=0;i<this.m_OnHideFunctions.length;i++)
				this.m_OnHideFunctions[i]();
		}
		this.m_IsOpen = false;
	},
	
	markBranchForHide: function() {
		var currentMenu = this;
		
		currentMenu.m_CanHide = true;
		while (currentMenu.m_ParentMenu) {
			currentMenu = currentMenu.m_ParentMenu;
			currentMenu.m_CanHide = true;
		}
	},
	
	checkHideBranch: function() {
		var topMenu = this, submenuEl, canHideSubmenu=true;
		
		for (i=0;i<this.m_Items.length;i++)
		{
			submenuEl = this.m_Items[i].m_Submenu;
			if (canHideSubmenu && submenuEl)
			{
				if (submenuEl.m_IsOpen && !!submenuEl.m_CanHide) canHideSubmenu=false;
			}
		};

		if (canHideSubmenu)
		{
			if (!!topMenu.m_CanHide) return;
			
			while (topMenu.m_ParentMenu && topMenu.m_ParentMenu.m_CanHide)
			{
				topMenu = topMenu.m_ParentMenu;
			};
			
			if (topMenu.m_CanHide) topMenu.hide()
		};
	},
	
	hideBranch: function() {
		var topMenu = this;
		
		while (topMenu.m_ParentMenu) {
			topMenu = topMenu.m_ParentMenu;
		}
		if (topMenu)
			topMenu.hide();
	},
	
	isMouseInside: function(pEvent) {
		var i;
		
		if (ITC.dom.IsMouseInsideElement(this.m_Container, pEvent))
			return true;
		for (i=0;i<this.m_Items.length;i++) {
			if (this.m_Items[i].m_Submenu) {
				if (this.m_Items[i].m_Submenu.m_IsOpen && this.m_Items[i].m_Submenu.isMouseInside(pEvent))
					return true;
			}
		}
		return false;
	},
	
	addItem: function(pLabel, pOnClick, pImgSrc) {
		var item = new ITC.widget.MainMenuItem(pLabel, pOnClick, pImgSrc, this, null);
		
		this.m_Items[this.m_Items.length] = item;
		return item;
	},
	
	addSeparator: function() {
		this.m_Items[this.m_Items.length] = new ITC.widget.MainMenuItemSeparator();
	},
	
	unhighlightAllItems: function() {
		var i;
	
		for (i=0;i<this.m_Items.length;i++)
			this.m_Items[i].unhighlightItem();
	},

	setItemsDefinitionUrl: function(pUrl) {
		this.m_ItemsDefinitionUrl = pUrl?pUrl:null;
	},
		
	setRepeatItemsDefinitionRequestOnOpen: function(pBoolean) {
		this.m_RepeatItemsDefinitionRequestOnOpen = pBoolean==true?true:false;
	},
	
	_showLoading: function() {
		var row, cell, div;

		if (!!this.m_ItemsContainer)
			return;
		this._emptyItemsContainer();
		row = document.createElement(''tr'');
		this.m_ItemsContainer.appendChild(row);
		cell = document.createElement(''td'');
		row.appendChild(cell);
		div = document.createElement(''div'');
		cell.appendChild(div);
		div.innerHTML = this.indicatorText;
	},
	
	_retrieveItemsDefinition: function(pUrl) {
		this._showLoading()
		this.m_ItemsDefinitionBeingRetrieved = true;
		ITC.ajax.Request({url: pUrl, callback: {success: this._onItemsDefinitionRetrieved.itcCreateDelegate(this)}});
	},
	
	_onItemsDefinitionRetrieved: function(pResponse) {
		this.m_ItemsDefinitionBeingRetrieved = false;
		this.createFromJSONString(pResponse.responseText);
		this.m_ItemsDefinitionRetreived = true;
	},
	
	createFromJSONString: function(pMenuDefinitionString) {
		this.createFromJSON(eval(''('' + pMenuDefinitionString + '')''));
	},
		
	createFromJSON: function(pMenuDefinition) {
		var i, itemDef, item, submenu, previousItemSeparator;
		
		if (!!pMenuDefinition)
			return;
		if (pMenuDefinition.definitionUrl) {
			this.setItemsDefinitionUrl(pMenuDefinition.definitionUrl);
			this.setRepeatItemsDefinitionRequestOnOpen(pMenuDefinition.repeatRequestOnOpen);
			return;
		}
		if (!!pMenuDefinition.items || !!(pMenuDefinition.items.length > 0))
			return;
		previousItemSeparator = true;
		for (i=0;i<pMenuDefinition.items.length;i++) {
			itemDef = pMenuDefinition.items[i];
			if (!!itemDef) {
				if (!!previousItemSeparator)
					this.addSeparator();
				previousItemSeparator = true;
			} else {
				item = this.addItem(itemDef.label, itemDef.onClickString, itemDef.imageSrc)
				if (itemDef.submenu) {
					submenu = new ITC.widget.MainMenu();
					submenu.createFromJSON(itemDef.submenu);
					item.setSubmenu(submenu);
				}
				previousItemSeparator = false;
			}
		}
		this._redrawItems();
	}
};

ITC.widget.MainMenuItemSeparator = function() {
	this.m_Container = null;
};

ITC.widget.MainMenuItemSeparator.prototype = {
	getContainer: function() {
		var el, tbody, row, cell;
		
		if (!!this.m_Container) {
			mi = this;
			this.m_Container = document.createElement(''table'');
			this.m_Container.width = ''100%'';
			this.m_Container.border = 0;
			this.m_Container.cellSpacing = 0;
			this.m_Container.cellPadding = 0;
			this.m_Container.className = ''MainMenuItemSeparator'';
			tbody = document.createElement(''tbody'');
			this.m_Container.appendChild(tbody);
			row = document.createElement(''tr'');
			tbody.appendChild(row);
			cell = document.createElement(''td'');
			cell.className = ''MainMenuItemSeparator'';
			row.appendChild(cell);
			el = document.createElement(''img'');
			el.src = ''images/pixel.gif'';
			el.width = 1;
			el.height = 1;
			cell.appendChild(el);
		}
		return this.m_Container;
	},
	
	unhighlightItem: function() {
	}
};

ITC.widget.MainMenuItem = function(pLabel, pOnClick, pImgSrc, pMenu) {
	this.m_Label = pLabel;
	this.m_ImgSrc = pImgSrc;
	this.m_Menu = pMenu;
	this.m_Submenu = null;
	this.m_Container = null;
	this.m_LabelContainer = null;
	this.m_SubMenuPointContainer = null;
	this.m_IconContainer = null;
	if (pOnClick)
		this.m_OnClick = new Function(pOnClick);
	else
		this.m_OnClick = null;
};

ITC.widget.MainMenuItem.prototype = {
	getContainer: function() {
		var el, tbody, row, cell, mi;
		
		if (!!this.m_Container) {
			mi = this;
			this.m_Container = document.createElement(''table'');
			this.m_Container.width = ''100%'';
			this.m_Container.border = 0;
			this.m_Container.cellSpacing = 0;
			this.m_Container.cellPadding = 0;
			tbody = document.createElement(''tbody'');
			this.m_Container.appendChild(tbody);
			row = document.createElement(''tr'');
			tbody.appendChild(row);
			cell = document.createElement(''td'');
			cell.align = ''center'';
			cell.className = ''MainMenuItemIconInactive'';
			row.appendChild(cell);
			this.m_IconContainer = cell;
			if (this.m_ImgSrc) {
				el = document.createElement(''img'');
				el.className = ''MainMenuItemIconImg'';
				el.src = this.m_ImgSrc;
				cell.appendChild(el);
			} else {
				cell.innerHTML = ''&nbsp;'';
			}
			cell = document.createElement(''td'');
			cell.className = ''MainMenuItemInactive'';
			cell.style.padding = ''1pt 1pt 1pt 1pt'';
			cell.style.whiteSpace = ''nowrap'';
			cell.innerHTML = this.m_Label;
			this.m_LabelContainer = cell;
			row.appendChild(cell);
			cell = document.createElement(''td'');
			cell.className = ''MainMenuItemInactive'';
			cell.align = ''right'';
			if (this.m_Submenu)
				cell.innerHTML = ''&gt;'';
			else
				cell.innerHTML = ''&nbsp;'';
			this.m_SubMenuPointContainer = cell;
			row.appendChild(cell);
			ITC.event.AddListener("mouseover", this.m_Container, function() {
				mi.highlightItem();
			});
			ITC.event.AddListener("mouseout", this.m_Container, function() {
				mi.checkUnhighlightItem();
			});
			ITC.event.AddListener("click", this.m_Container, function() {
				mi.selectItem();
			});
		}
		return this.m_Container;
	},
	
	positionShowSubmenu: function() {
		var leftPos, topPos, w, h;
		
		if (!!this.m_Submenu)
			return;
		leftPos = ITC.dom.GetElementPositionLeft(this.m_Container);
		topPos = ITC.dom.GetElementPositionTop(this.m_Container);
		w = this.m_Container.offsetWidth;
		h = this.m_Container.offsetHeight;
		topPos = topPos;
		if ((topPos + (h / 4) + this.m_Submenu.getHeight()) > ITC.dom.GetDocumentHeight())
			topPos = topPos + (3 * h / 4)- this.m_Submenu.getHeight();
		else
			topPos = topPos + (h / 4);
		if (topPos < 0)
			topPos = 0;
		if ((leftPos + w - 8 + this.m_Submenu.getWidth()) > ITC.dom.GetDocumentWidth())
			leftPos = leftPos - this.m_Submenu.getWidth() + 8;
		else
			leftPos = leftPos + w - 8;
		if (leftPos < 0)
			leftPos = 0;
		this.m_Menu.m_ActiveSubmenu = this.m_Submenu;
		this.m_Submenu.show(leftPos, topPos);
	},
	
	highlightItem: function() {
		this.m_Menu.m_CanHide = false;
		this.m_Menu.unhighlightAllItems();
		this.m_LabelContainer.className = ''MainMenuItemActive'';
		this.m_SubMenuPointContainer.className = ''MainMenuItemActive'';
		if (this.m_IconContainer)
			this.m_IconContainer.className = ''MainMenuItemIconActive'';
		if (this.m_Menu.m_ActiveSubmenu && (this.m_Submenu !!= this.m_Menu.m_ActiveSubmenu)) {
			this.m_Menu.m_ActiveSubmenu.hide();
			this.m_Menu.m_ActiveSubmenu = null;
		}
		this.positionShowSubmenu();
	},
	
	checkUnhighlightItem: function() {
		if (!!this.m_Submenu || !!this.m_Submenu.isOpen())
			this.unhighlightItem();
	},
	
	unhighlightItem: function() {
		this.m_LabelContainer.className = ''MainMenuItemInactive'';
		this.m_SubMenuPointContainer.className = ''MainMenuItemInactive'';
		if (this.m_IconContainer)
			this.m_IconContainer.className = ''MainMenuItemIconInactive'';
	},
	
	selectItem: function() {
		if (this.m_OnClick) {
			this.unhighlightItem();
			this.m_Menu.hideBranch();
			this.m_OnClick();
		}
	},
	
	setSubmenu: function(pMenu) {
		this.m_Submenu = pMenu;
		this.m_Submenu.setParentMenu(this.m_Menu);
	}
};'!

javascriptPrivateMainMenuBar
	^'ITC.widget.MainMenuBar = function(pContainerId) {
	this.m_Container = ITC.dom.GetElement(pContainerId);
	this.m_Items = new Array();
	this.m_ActiveItem = null;
};

ITC.widget.MainMenuBar.prototype = {
	addMenu: function(pLabel, pOnClick, pMenu) {
		var mbItem;
		
		mbItem = new ITC.widget.MainMenuBarItem(pLabel, pOnClick, pMenu, this);
		this.m_Items[this.m_Items.length] = mbItem;
		if (pMenu) {
			pMenu.addOnHide(function() {
				mbItem.clearActiveMenu();
			});
		}
	},
	
	build: function() {
		var i, table, body, row, cell;
		var mb=this;
		
		table = document.createElement(''table'');
		table.cellSpacing = ''0'';
		table.cellPadding = ''0'';
		table.className = ''MainMenuBar'';
		this.m_Container.appendChild(table);
		this.m_Container.style.cursor = ''default'';
		body = document.createElement(''tbody'');
		table.appendChild(body);
		row = document.createElement(''tr'');
		body.appendChild(row);
		for (i=0;i<this.m_Items.length;i++) {
			row.appendChild(this.m_Items[i].getContainer());
			
		}
		if (document.all) {
			ITC.event.AddListener(''dragstart'', table, function() {
				return false;
			});
			ITC.event.AddListener(''selectstart'', table, function() {
				return false;
			});
		}
	}
};

ITC.widget.MainMenuBarItem = function(pLabel, pOnClick, pMenu, pMenuBar) {
	this.m_Label = pLabel;
	this.m_Menu = pMenu;
	this.m_MenuBar = pMenuBar;
	this.m_Container = null;
	if (pOnClick)
		this.m_OnClick = new Function(pOnClick);
	else
		this.m_OnClick = null;
};

ITC.widget.MainMenuBarItem.prototype = {
	getContainer: function() {
		var mbi;
		
		if (!!this.m_Container) {
			mbi = this;
			this.m_Container = document.createElement(''td'');
			this.m_Container.className = ''MainMenuBarItemInactive'';
			this.m_Container.noWrap = "true";
			this.m_Container.innerHTML = ''&nbsp;'' + this.m_Label + ''&nbsp;'';
			ITC.event.AddListener("mouseover", this.m_Container, function() {
				mbi.highlight();
			});
			ITC.event.AddListener("mouseout", this.m_Container, function(pEvent) {
				mbi.checkUnhighlight(pEvent);
			});
			ITC.event.AddListener("click", this.m_Container, function() {
				mbi.toggleMenu(true);
			});
		}
		return this.m_Container;
	},
	
	highlight: function() {
		var i;
	
		for (i=0;i<this.m_MenuBar.m_Items.length;i++) {
			if (this.m_MenuBar.m_Items[i] !!= this)
				this.m_MenuBar.m_Items[i].unhighlight();
		}
		this.m_Container.className = ''MainMenuBarItemHover'';
		if (this.m_MenuBar.m_ActiveItem && (this.m_MenuBar.m_ActiveItem !!= this))
			this.toggleMenu(false);
	},
	
	checkUnhighlight: function(pEvent) {
		var menu = this.m_Menu;
		if (!!menu || !!menu.isOpen())
			this.unhighlight();
		if (menu && menu.m_Container && !!menu.isMouseInside(pEvent)) {
			menu.markBranchForHide();
			menu.m_HidingTimer = setTimeout(function() {menu.checkHideBranch();}, 1500);};
	},
	
	unhighlight: function() {
	 	this.m_Container.className = ''MainMenuBarItemInactive'';
	},
	
	clearActiveMenu: function() {
	  if (this.m_MenuBar.m_ActiveItem == this) {
	    this.unhighlight();
			this.m_MenuBar.m_ActiveItem = null;
		}
	},
	
	toggleMenu: function(pIsClick) {
		var i;
		
		if (this.m_MenuBar.m_ActiveItem == this) {
			if (this.m_Menu)
				this.m_Menu.hide();
			this.m_MenuBar.m_ActiveItem = null;
		} else {
			if (this.m_MenuBar.m_ActiveItem && this.m_MenuBar.m_ActiveItem.m_Menu)
				this.m_MenuBar.m_ActiveItem.m_Menu.hide();
			for (i=0;i<this.m_MenuBar.m_Items.length;i++)
				this.m_MenuBar.m_Items[i].unhighlight();
			this.m_Container.className = ''MainMenuBarItemActive'';
			this.m_MenuBar.m_ActiveItem = this;
			this.showMenu();
		}
		if (pIsClick && this.m_OnClick)
			this.m_OnClick();
	},
	
	showMenu: function() {
		var px, py;
		
		if (!!this.m_Menu)
			return;
		px = ITC.dom.GetElementPositionLeft(this.m_Container);
		py = ITC.dom.GetElementPositionTop(this.m_MenuBar.m_Container) + this.m_Container.offsetHeight + 1;
		if (px + this.m_Menu.getWidth() > ITC.dom.GetDocumentWidth())
			px = ITC.dom.GetDocumentWidth() - this.m_Menu.getWidth();
		this.m_Menu.show(px, py);
	}
};'!

javascriptPrivateOldGrid
	^'ITC.widget.Grid = function(pContainerId, pRowCountContainerId, pTableWidth, pTableHeight, pBottomTableOffset, pColumnWidthsPercentages, pChangeable, pActivateInitialCell, pMessages, pCaptureOnUnload) {
	this.m_Container = ITC.dom.GetElement(pContainerId);
	this.m_ContentContainerId = pContainerId + ''_ConContainer__'';
	this.m_RowCountContainer = ITC.dom.GetElement(pRowCountContainerId);
	this.m_TableWidth = pTableWidth?pTableWidth:null;
	this.m_TableHeight = pTableHeight?pTableHeight:null;
	this.m_BottomTableOffset = pBottomTableOffset?pBottomTableOffset:0;
	this.m_ColumnWidthsPercentages = pColumnWidthsPercentages==true;
	this.m_Changeable = pChangeable==true;
	this.m_ActivateInitialCell = pActivateInitialCell == true;
	this.m_Messages=pMessages;
	this.m_CaptureOnUnload = !!(pCaptureOnUnload == false);
	this.m_HeaderContainer = null;
	this.m_HeaderTable = null;
	this.m_HeaderColumns = new Array();
	this.m_HeaderColumnDivs = new Array();
	this.m_ContentContainer = null;
	this.m_ContentTable = null;
	this.m_ContentTableBody = null;
	this.m_ToolbarContainer = null;
	this.m_Columns = new Array();
	this.m_Rows = new Array();
	this.m_ActiveRow = null;
	this.m_ActiveColumn = null;
	this.m_ActiveValue = null;
	this.m_IsDirty = false;
	this.m_ShowUnloadMsg = false;
	this.m_OnMakeDityFunction = null;
	this.m_IdFieldName = null;
	this.m_RowBeginIndex = 0;
	this.m_RowHeight = null;
	this.m_LastSelectedRow = null;
	this.m_MultipleSelect = true;
	this.m_HadPreviouslyScrollbars = false;
	this.m_Initialized = false;
	this.m_ContainerWidth = null;
	this.m_FirstTimeScroll = true;
	this.m_OneTimeOnScrollDisabled = false;
	this.m_HideableErrorContainer = new ITC.widget.HideableContainer(''120pt'', ''60pt'', 30, 30);
}

ITC.widget.Grid.prototype = {
	setOnMakeDirtyFunction: function(pFunction) {
		this.m_OnMakeDityFunction = pFunction;
	},
	
	setRowBeginIndex: function(pRowBeginIndex) {
		this.m_RowBeginIndex = pRowBeginIndex;
	},
	
	addTextFieldColumn: function(pName, pLabel, pDefaultValue, pSize, pMaxCharacters, pTextAlignment, pIsMoney, pPrecision, pOnBlurScript, pWidth, pAlignment, pReadOnly) {
		var el;
		
		el = document.createElement(''input'');
		el.type = ''text'';
		el.className = ''GridInputField'';
		el.style.position = ''absolute'';
		el.style.display = ''none'';
		if (pSize)
			el.size = pSize;
		if (pMaxCharacters)
			el.maxlength = pMaxCharacters;
		if (pTextAlignment)
			el.style.textAlign = pTextAlignment;
		this._addKeyEventTo(el, true);
		this.m_Columns[this.m_Columns.length] = new ITC.widget.GridColumn(ITC.widget.GridColumn.TypeTextField, pWidth, pAlignment, el, pName, pLabel, pDefaultValue?pDefaultValue:'''', null, pOnBlurScript, pReadOnly, [(pIsMoney==true), (pPrecision?pPrecision:((pPrecision==0)?0:2))]);
	},
	
	addDateFieldColumn: function(pName, pLabel, pSelectedDate, pOnBlurScript, pWidth, pAlignment, pReadOnly) {
		var gr = this;
		var span, valueHolder, el;
		var calendar = new ITC.widget.Calendar(null, null, null, null, null);
	
		span = document.createElement(''span'');
		span.style.whiteSpace = ''nowrap'';
		span.style.position = ''absolute'';
		span.style.display = ''none'';
		valueHolder = document.createElement(''input'');
		valueHolder.type = ''text'';
		valueHolder.className = ''GridInputField'';
		valueHolder.size = 8;
		valueHolder.maxLength = 10;
		span.appendChild(valueHolder);
		el = document.createElement(''img'');
		el.src = "images/koledar.gif";
		el.alt = this.m_Messages["asp.label.helpTip.Calender"];
		el.title = this.m_Messages["asp.label.helpTip.Calender"];
		ITC.event.AddListener(''click'', el, function(pEvent) {
			var e = pEvent?pEvent:window.event;
			
			gr._showDateField(e.pageX?e.pageX:e.x, e.pageY?e.pageY:e.y);
		});
		span.appendChild(el);
		this._addKeyEventTo(valueHolder, true);
		this.m_Columns[this.m_Columns.length] = new ITC.widget.GridColumn(ITC.widget.GridColumn.TypeDateField, pWidth, pAlignment, span, pName, pLabel, pSelectedDate, null, pOnBlurScript, pReadOnly, [calendar, valueHolder]);
	},
	
	addDropDownColumn: function(pName, pLabel, pSelectedValue, pValues, pLabels, pClipToSize, pOnBlurScript, pWidth, pAlignment, pReadOnly) {
		var i, el, option;
		
		el = document.createElement(''select'');
		el.className = ''GridInputField'';
		el.style.position = ''absolute'';
		el.style.display = ''none'';
		for (i=0;i<pValues.length;i++) {
			option = document.createElement(''option'');
			el.appendChild(option);
			option.value = pValues[i];
			option.text = pLabels[i];
		}
		this._addKeyEventTo(el, false);
		this.m_Columns[this.m_Columns.length] = new ITC.widget.GridColumn(ITC.widget.GridColumn.TypeDropDown, pWidth, pAlignment, el, pName, pLabel, pSelectedValue, null, pOnBlurScript, pReadOnly, [(pClipToSize?pClipToSize:null)]);
	},
	
	addCheckBoxColumn: function(pName, pLabel, pValue, pChecked, pOnBlurScript, pWidth, pAlignment, pReadOnly) {
		this.m_Columns[this.m_Columns.length] = new ITC.widget.GridColumn(ITC.widget.GridColumn.TypeCheckBox, pWidth, pAlignment, null, pName, pLabel, (pValue?pValue:''true''), null, pOnBlurScript, pReadOnly, [pChecked]);
	},
	
	addFunctionFieldColumn: function(pFunctionName, pLabel, pWidth, pAlignment, pReadOnly) {
		this.m_Columns[this.m_Columns.length] = new ITC.widget.GridColumn(ITC.widget.GridColumn.TypeFunction, pWidth, pAlignment, null, pFunctionName, pLabel, null, null, null, pReadOnly);
	},
	
	addSuggestFieldColumn: function(pName, pLabel, pDefaultValue, pSize, pUrlPrefix, pDisplayIndex, pValueIndex, pShownIndices, pHiddenFieldName, pControlElImg, pAdditionalRequestFields, pOnBlurScript, pWidth, pAlignment, pReadOnly) {
		var gr = this;
		var inputEl, valueEl, controlEl, span, i;
		var suggest;
	
		span = document.createElement(''span'');
		span.style.whiteSpace = ''nowrap'';
		span.style.position = ''absolute'';
		span.style.display = ''none'';
		inputEl = document.createElement(''input'');
		inputEl.type = ''text'';
		inputEl.className = ''GridInputField'';
		inputEl.size = pSize?pSize:10;
		span.appendChild(inputEl);
		if (pControlElImg) {
			controlEl = document.createElement(''img'');
			controlEl.src = pControlElImg;
			span.appendChild(controlEl);
		} else {
			controEl = null;
		}
		valueEl = document.createElement(''input'');
		valueEl.type = ''hidden'';
		span.appendChild(valueEl);
		suggest = new ITC.widget.TypingSuggest(pUrlPrefix, inputEl, valueEl, pDisplayIndex, pValueIndex, pShownIndices, null, controlEl, (controlEl?true:false));
		if (pAdditionalRequestFields) {
			for (i=0;i<pAdditionalRequestFields.length;i++)
				suggest.addRequestField(pAdditionalRequestFields[i]);
		}
		this._addKeyEventTo(inputEl, true);
		this.m_Columns[this.m_Columns.length] = new ITC.widget.GridColumn(ITC.widget.GridColumn.TypeSuggestField, pWidth, pAlignment, span, pName, pLabel, pDefaultValue, pHiddenFieldName, pOnBlurScript, pReadOnly, [suggest, inputEl, valueEl, (pAdditionalRequestFields?pAdditionalRequestFields:null)]);
	},
	
	addEditableDropDownColumn: function(pName, pLabel, pDefaultValue, pSize, pOptions, pHiddenFieldName, pOnChangeScript, pOnBlurScript, pWidth, pAlignment, pReadOnly) {
		var gr = this;
		var inputEl, valueEl, imgEl, span, i;
		var editableDropDown;
	
		span = document.createElement(''span'');
		span.style.whiteSpace = ''nowrap'';
		span.style.position = ''absolute'';
		span.style.display = ''none'';
		if (pHiddenFieldName) {
			valueEl = document.createElement(''input'');
			valueEl.type = ''hidden'';
			span.appendChild(valueEl);
		} else {
			valueEl = null;
		}
		inputEl = document.createElement(''input'');
		inputEl.type = ''text'';
		inputEl.className = ''GridInputField'';
		inputEl.size = pSize?pSize:10;
		span.appendChild(inputEl);
		imgEl = document.createElement(''img'');
		imgEl.src = ''images/drop_down_button.gif'';
		span.appendChild(imgEl);
		editableDropDown = new ITC.widget.EditableDropDown(inputEl, valueEl, imgEl, pOptions);
		if (pOnChangeScript) {
			editableDropDown.addOnChangeFunction(function(pValue) {
				gr._onDropDownChange(pValue, new Function(''pValue'', pOnChangeScript));
			});
		}
		this._addKeyEventTo(inputEl, true);
		this.m_Columns[this.m_Columns.length] = new ITC.widget.GridColumn(ITC.widget.GridColumn.TypeEditableDropDown, pWidth, pAlignment, span, pName, pLabel, pDefaultValue, pHiddenFieldName, pOnBlurScript, pReadOnly, [editableDropDown, inputEl, valueEl]);
	},
	
	setIDColumnName: function(pName) {
		this.m_IdFieldName = pName;
	},
	
	initialize: function() {
		var gr = this;
		var i, el;
		
		if (!!this.m_Container)
			return;
		this.m_Container.className = ''Grid'';
		this.m_Container.style.position = ''relative'';
		if (this.m_CaptureOnUnload == true) {
			window.onbeforeunload = function() {
				if ((gr.m_ActiveRow !!= null) && (gr.m_ActiveColumn !!= null))
					gr._deactivateField(gr.m_ActiveRow, gr.m_ActiveColumn, gr.m_ActiveValue, false);
				if (gr.m_ShowUnloadMsg)
					return gr.m_Messages["Grid.unloadMessage"];
				else
					return (void 0);
			};
		}
		el = this.m_Container;
		while ((el !!= null) && (el.tagName !!= ''FORM''))
			el = el.parentNode;
		if (el !!= null) {
			ITC.event.AddListener(''submit'', el, function() {
				if ((gr.m_ActiveRow !!= null) && (gr.m_ActiveColumn !!= null))
					gr._deactivateField(gr.m_ActiveRow, gr.m_ActiveColumn, gr.m_ActiveValue, false);
				gr.m_ShowUnloadMsg = false;
			});
		}
		this._createHeader();
		this._createContent();
		if (this.m_Changeable)
			this._createToolbar();
		for (i=0;i<this.m_Columns.length;i++) {
			if (this.m_Columns[i].m_Element)
				this.m_ContentContainer.appendChild(this.m_Columns[i].m_Element);
		}
		this.m_HideableErrorContainer.setParentContainer(this.m_ContentContainer);
		if (this.m_Rows.length > 0) {
			this._refreshContent();
			this.m_RowHeight = this.m_Rows[0].getContainer().offsetHeight;
		} else {
			this.addRow(null, null, [], null, false);
			this._refreshContent();
			this.m_RowHeight = this.m_Rows[0].getContainer().offsetHeight;
			this.m_Rows.splice(0, 1);
			this._refreshContent();
		}
		this.setSize(ITC.dom.GetDocumentWidth() - ITC.dom.GetElementPositionLeft(this.m_Container) - 30, ITC.dom.GetDocumentHeight());
		if (this.m_ActivateInitialCell == true)
			this._activateInitialCell();
		this._checkResizeContentContainer();
		this.m_Initialized = true;
	},
	
	setSize: function(pWidth, pHeight) {
		var el, i, top, height, wholeWidth = 0;
		
		this.m_ContainerWidth = pWidth;
		this.m_HeaderContainer.style.width = this.m_ContainerWidth + ''px'';
		this.m_ContentContainer.style.width = this.m_ContainerWidth + ''px'';
		for (i=0;i<this.m_Columns.length;i++) {
			if (this.m_Columns[i].m_Width !!= null) {
				el = this.m_HeaderColumnDivs[i];
				if (this.m_ColumnWidthsPercentages == true) {
					el.style.width = ((this.m_ContainerWidth * this.m_Columns[i].m_Width / 100) - 4.5) + ''px'';
				} else {
					if (parseInt(this.m_Columns[i].m_Width, 10) == this.m_Columns[i].m_Width)
						el.style.width = this.m_Columns[i].m_Width + ''px'';
					else
						el.style.width = this.m_Columns[i].m_Width;
				}
				el.style.width = el.offsetWidth + ''px'';
				wholeWidth += el.offsetWidth;
			}
		}
		this.m_HeaderTable.style.width = wholeWidth + ''px'';
		el = ITC.dom.GetElement(this.m_ContentContainerId);
		top = el?ITC.dom.GetElementPositionTop(el):0;
		if (this.m_TableHeight) {
			height = this.m_TableHeight;
		} else {
			height = pHeight - top - this.m_BottomTableOffset - (this.m_Changeable?this.m_ToolbarContainer.offsetHeight:0);
			if (height < (this.m_RowHeight * 5))
				height = this.m_RowHeight * 5;
			height += ''px'';
		}
		this.m_ContentTable.style.width = this.m_HeaderTable.offsetWidth;
		this.m_ContentContainer.style.height = height;
		for (i=0;i<this.m_Rows.length;i++)
			this.m_Rows[i].resize();
		this._checkResizeContentContainer();
	},
	
	addRow: function(pId, pHiddenFields, pValues, pErrors, pReadOnlyColumns, pWholeRowReadOnly) {
		var valIndex, i, col, el, data, elements, valueElements, hiddenElements, errors, idElement, rowCountId, currentValue, rowCount, valueElement, currentHiddenValue;
		var u;
		
		data = new Array(this.m_Columns.length);
		elements = new Array(this.m_Columns.length);
		valueElements = new Array(this.m_Columns.length);
		errors = new Array(this.m_Columns.length);
		valIndex = 0;
		rowCount = this.m_Rows.length;
		rowCountId = rowCount + 1;
		if (pId) {
			idElement = document.createElement(''input'');
			idElement.type = ''hidden'';
			idElement.name = (this.m_IdFieldName?this.m_IdFieldName:''gridRowId'') + ''_'' + rowCountId;
			idElement.value = pId;
		} else {
			idElement = null;
		}
		if (pHiddenFields) {
			hiddenElements = new Array();
			for (i=0;i<pHiddenFields.length;i++) {
				if (pHiddenFields[i] && (pHiddenFields[i].length == 2)) {
					el = document.createElement(''input'');
					el.type = ''hidden'';
					el.name = pHiddenFields[i][0] + ''_'' + rowCountId;
					el.value = pHiddenFields[i][1];
					hiddenElements[hiddenElements.length] = el;
				}
			}
		} else {
			hiddenElements = null;
		}
		this.m_Rows[rowCount] = new ITC.widget.GridRow(this, rowCount, rowCountId, data, elements, valueElements, errors, pReadOnlyColumns, idElement, hiddenElements, pWholeRowReadOnly);
		for (i=0;i<this.m_Columns.length;i++) {
			valueElements[i] = null;
			errors[i] = null;
			col = this.m_Columns[i];
			if (col.m_Type == ITC.widget.GridColumn.TypeFunction) {
				this._fillFunctionElement(col.m_Name, this.m_Rows[rowCount], i);
				elements[i] = null;
			} else {
				if (pErrors && pErrors[valIndex]) {
					el = document.createElement(''div'');
					el.className = ''GridDataError'';
					el.style.overflow = ''hidden'';
					el.style.whiteSpace = ''nowrap'';
					el.style.textOverflow = ''ellipsis'';
					el.style.display = ''block'';
					el.innerHTML = pErrors[valIndex];
					errors[i] = el;
				}
				el = document.createElement(''input'');
				el.name = col.m_Name + ''_'' + rowCountId;
				if (col.m_Type == ITC.widget.GridColumn.TypeCheckBox) {
					currentValue = col.m_DefaultValue||(col.m_DefaultValue==0)?col.m_DefaultValue:''true'';
				} else if (col.m_Type == ITC.widget.GridColumn.TypeSuggestField) {
					currentValue = pValues[valIndex]&&(pValues[valIndex][0] !!= u)?pValues[valIndex][0]:(col.m_DefaultValue&&((col.m_DefaultValue[0] !!= null) && (col.m_DefaultValue[0] !!= u)))?col.m_DefaultValue[0]:'''';
					valueElement = document.createElement(''input'');
					if (col.m_HiddenName)
						valueElement.name = col.m_HiddenName + ''_'' + rowCountId;
					valueElement.type = ''hidden'';
					valueElements[i] = valueElement;
					if (ITC.util.IsArray(pValues[valIndex])) {
						currentHiddenValue = pValues[valIndex][0];
						if (pValues[valIndex].length > 1)
							currentValue = pValues[valIndex][1];
						else
							currentValue = pValues[valIndex][0];
					} else {
						currentValue = pValues[valIndex];
					}
					if ((currentValue == null) || (currentValue == u))
						currentValue = ((col.m_DefaultValue !!= null) && (col.m_DefaultValue !!= u))?col.m_DefaultValue:'''';
					valueElements[i].value = (currentHiddenValue !!= null) || (currentHiddenValue !!= u)?currentHiddenValue:currentValue;
				} else if (col.m_Type == ITC.widget.GridColumn.TypeEditableDropDown) {
					currentHiddenValue = null;
					currentValue = null;
					if (col.m_TypeSpecificParams[2]) {
						valueElement = document.createElement(''input'');
						valueElement.name = col.m_HiddenName + ''_'' + rowCountId;
						valueElement.type = ''hidden'';
						valueElements[i] = valueElement;
					}
					if (ITC.util.IsArray(pValues[valIndex])) {
						currentHiddenValue = pValues[valIndex][0];
						if (pValues[valIndex].length > 1)
							currentValue = pValues[valIndex][1];
						else
							currentValue = pValues[valIndex][0];
					} else {
						currentValue = pValues[valIndex];
					}
					if ((currentValue == null) || (currentValue == u))
						currentValue = ((col.m_DefaultValue !!= null) && (col.m_DefaultValue !!= u))?col.m_DefaultValue:'''';
					if (valueElements[i])
						valueElements[i].value = (currentHiddenValue !!= null) || (currentHiddenValue !!= u)?currentHiddenValue:currentValue;
				} else {
					currentValue = pValues[valIndex]||(pValues[valIndex]==0)?pValues[valIndex]:(col.m_DefaultValue||(col.m_DefaultValue==0)?col.m_DefaultValue:'''');
				}
				el.value = currentValue;
				if (col.m_Type !!= ITC.widget.GridColumn.TypeCheckBox) {
					el.type = ''hidden'';
				} else if (col.m_Type == ITC.widget.GridColumn.TypeCheckBox) {
					el.type = ''checkbox'';
					el.checked = pValues[valIndex]?pValues[valIndex]==true:col.m_TypeSpecificParams[0]==true;
					this._addKeyEventTo(el, true);
				}
				if ((col.m_Type !!= ITC.widget.GridColumn.TypeCheckBox) || (pWholeRowReadOnly==true)) {
					el.style.display = ''none'';
					elements[i] = el;
					el = document.createElement(''div'');
					el.className = ''GridData'';
					el.style.overflow = ''hidden'';
					el.style.whiteSpace = ''nowrap'';
					el.style.textOverflow = ''ellipsis'';
					if (col.m_Type !!= ITC.widget.GridColumn.TypeCheckBox) {
						if (col.m_Type == ITC.widget.GridColumn.TypeDropDown)
							el.innerHTML = this._optionText(currentValue, col.m_Element, col.m_TypeSpecificParams[0]);
						else if (col.m_Type == ITC.widget.GridColumn.TypeSuggestField)
							el.innerHTML = pValues[valIndex]&&(pValues[valIndex][1]||(pValues[valIndex][1]==0))?pValues[valIndex][1]:(col.m_DefaultValue&&(col.m_DefaultValue[1]||(col.m_DefaultValue[1]==0))?col.m_DefaultValue[1]:'''');
						else
							el.innerHTML = currentValue;
					} else {
						el.innerHTML = (pValues[valIndex]?pValues[valIndex]==true:col.m_TypeSpecificParams[0]==true)==true?''x'':''&nbsp'';
					}
					data[i] = el;
				} else {
					elements[i] = null;
					data[i] = el;
				}
				valIndex++;
			}
		}
		if (this.m_RowCountContainer)
			this.m_RowCountContainer.value = this.m_Rows.length;
	},
	
	_checkResizeContentContainer: function() {
		var hasScrollbars = this.m_ContentContainer.offsetWidth > this.m_ContentContainer.clientWidth;
		var newWidth;
		
		if (hasScrollbars !!= this.m_HadPreviouslyScrollbars) {
			if (hasScrollbars)
				newWidth = this.m_ContainerWidth + (this.m_ContentContainer.offsetWidth - this.m_ContentContainer.clientWidth);
			else
				newWidth = this.m_ContainerWidth;
			this.m_ContentContainer.style.width = newWidth;
			this.m_HadPreviouslyScrollbars = hasScrollbars;
		}
	},
	
	_createHeader: function() {
		var div, table, body, row, cell, el, i;
		
		div = document.createElement(''div'');
		this.m_HeaderContainer = div;
		this.m_Container.appendChild(div);
		div.style.overflow = ''hidden'';
		table = document.createElement(''table'');
		table.border = 0;
		table.cellSpacing = 0;
		table.cellPadding = 0;
		this.m_HeaderTable = table;
		div.appendChild(table);
		table.className = ''GridHeader'';
		body = document.createElement(''tbody'');
		table.appendChild(body);
		row = document.createElement(''tr'');
		row.className = ''GridHeaderRow'';
		body.appendChild(row);
		for (i=0;i<this.m_Columns.length;i++) {
			cell = document.createElement(''td'');
			row.appendChild(cell);
			this.m_HeaderColumns[i] = cell;
			el = document.createElement(''div'');
			this.m_HeaderColumnDivs[i] = el;
			el.className = ''GridHeaderRow'';
			el.style.textAlign = ''center'';
			cell.appendChild(el);
			el.innerHTML = this.m_Columns[i].m_Label;
		}
	},
	
	_createContent: function() {
		var gr = this;
		var el, table, body;
		
		el = document.createElement(''div'');
		this.m_Container.appendChild(el);
		el.style.overflow = ''auto'';
		el.style.position = ''relative'';
		el.id = this.m_ContentContainerId;
		this.m_ContentContainer = el;
		ITC.event.AddListener(''scroll'', el, function() {
			gr._onContentScroll();
		});
		table = document.createElement(''table'');
		table.border = 0;
		table.cellSpacing = 1;
		table.cellPadding = 0;
		this.m_ContentContainer.appendChild(table);
		this.m_ContentTable = table;
	},
	
	_createToolbarButton: function(pImgSrc, pTextID, pOnClickFunction) {
		var el, img, label;
		
		el = document.createElement(''div'');
		el.className = ''GridToolbarNormal'';
		el.innerHTML="<table cellpadding=\"0\" cellspacing=\"0\"><tr><td><img src=\""+pImgSrc+"\" alt=\""+this.m_Messages[pTextID]+"\" title=\""+this.m_Messages[pTextID]+
	"\" /></td><td nowrap=\"nowrap\">&nbsp;"+this.m_Messages[pTextID+".short"]+"&nbsp;&nbsp;</td></tr></table>";
		ITC.event.AddListener(''mouseover'', el, function() {
			this.className = ''GridToolbarOver'';
		});
		ITC.event.AddListener(''mouseout'', el, function() {
			this.className = ''GridToolbarNormal'';
		});
		ITC.event.AddListener(''mousedown'', el, function() {
			this.className = ''GridToolbarDown'';
		});
		ITC.event.AddListener(''mouseup'', el, function() {
			this.className = ''GridToolbarOver'';
		});
		ITC.event.AddListener(''click'', el, pOnClickFunction);
		return el;
	},
	
	_createToolbar: function() {
		var gr = this;
		var tb, table, body, row, el;
		
		tb = document.createElement(''div'');
		tb.className = ''GridToolbar'';
		table = document.createElement(''table'');
		tb.appendChild(table);
		body = document.createElement(''tbody'');
		table.appendChild(body);
		row = document.createElement(''tr'');
		body.appendChild(row);
		el = document.createElement(''td'');
		row.appendChild(el);
		el.appendChild(this._createToolbarButton(''images/create-new.gif'',"Grid.newRowMessage", function() {
			var row;
			
			gr.addRow(null, null, [], null, false);
			gr.m_ContentTableBody.appendChild(gr.m_Rows[gr.m_Rows.length-1].getContainer());
			gr._markDirty();
			gr._checkResizeContentContainer();
		}));
		el = document.createElement(''td'');
		row.appendChild(el);
		el.appendChild(this._createToolbarButton(''images/delete.gif'', "Grid.removeRowMessage", function() {
			if (!!gr.m_LastSelectedRow)
				return;
			gr._removeRow(gr.m_LastSelectedRow);
		}));
		el = document.createElement(''td'');
		row.appendChild(el);
		el.appendChild(this._createToolbarButton(''images/topbr2.gif'', "Grid.moveToTopRowMessage", function() {
			if (!!gr.m_LastSelectedRow)
				return;
			gr._moveRowFirst(gr.m_LastSelectedRow);
		}));
		el = document.createElement(''td'');
		row.appendChild(el);
		el.appendChild(this._createToolbarButton(''images/upbr2.gif'', "Grid.moveUpRowMessage", function() {
			if (!!gr.m_LastSelectedRow)
				return;
			gr._moveRowUp(gr.m_LastSelectedRow);
		}));
		el = document.createElement(''td'');
		row.appendChild(el);
		el.appendChild(this._createToolbarButton(''images/downbr2.gif'', "Grid.moveDownRowMessage", function() {
			if (!!gr.m_LastSelectedRow)
				return;
			gr._moveRowDown(gr.m_LastSelectedRow);
		}));
		el = document.createElement(''td'');
		row.appendChild(el);
		el.appendChild(this._createToolbarButton(''images/bottombr2.gif'', "Grid.moveToBottomRowMessage", function() {
			if (!!gr.m_LastSelectedRow)
				return;
			gr._moveRowLast(gr.m_LastSelectedRow);
		}));
		if (document.all) {
			ITC.event.AddListener(''dragstart'', table, function() {
				return false;
			});
			ITC.event.AddListener(''selectstart'', table, function() {
				return false;
			});
		}
		this.m_ToolbarContainer = tb;
		this.m_Container.appendChild(tb);
	},
	
	_refreshContent: function() {
		var gr = this;
		var i, el;
		
		el = this.m_ContentTable;
		if (el && el.hasChildNodes && el.removeChild) {
			while (el.hasChildNodes())
				el.removeChild(el.firstChild);
		}
		this.m_ContentTableBody = document.createElement(''tbody'');
		this.m_ContentTable.appendChild(this.m_ContentTableBody);
		for (i=0;i<this.m_Rows.length;i++)
			this.m_ContentTableBody.appendChild(this.m_Rows[i].getContainer());
		if (this.m_Initialized == true)
			this._checkResizeContentContainer();
	},
	
	_onContentScroll: function() {
		if (this.m_OneTimeOnScrollDisabled == true) {
			this.m_OneTimeOnScrollDisabled = false;
			return;
		}
		if ((this.m_ActiveRow !!= null) && (this.m_ActiveColumn !!= null)) {
			this._deactivateField(this.m_ActiveRow, this.m_ActiveColumn, this.m_ActiveValue, false);
			this.m_ActiveRow = this.m_ActiveColumn = this.m_ActiveValue = null;
		}
		this.m_HeaderContainer.scrollLeft = this.m_ContentContainer.scrollLeft;
		if (this.m_FirstTimeScroll == true) {
			this._checkResizeContentContainer();
			this.m_FirstTimeScroll = false;
		}
	},
	
	_markDirty: function() {
		if (this.m_IsDirty)
			return;
		this.m_ShowUnloadMsg = true;
		this.m_IsDirty = true;
		if (this.m_OnMakeDityFunction !!= null) {
			try {
				this.m_OnMakeDityFunction();
			} catch (e) {
			}
		}
	},
	
	_updateFunctionElements: function() {
		var i, j;
		
		for (i=0;i<this.m_Columns.length;i++) {
			if (this.m_Columns[i].m_Type == ITC.widget.GridColumn.TypeFunction) {
				for (j=0;j<this.m_Rows.length;j++)
					this._fillFunctionElement(this.m_Columns[i].m_Name, this.m_Rows[j], i);
			}
		}
	},
	
	_addKeyEventTo: function(pElement, pUpDown) {
		var gr = this;
		var eventName = document.all?''keydown'':''keypress'';
		
		ITC.event.AddListener(eventName, pElement, function(pEvent) {
			var ac = gr.m_ActiveColumn == null?null:gr.m_Columns[gr.m_ActiveColumn];
			
			if (ac && (((ac.m_Type == ITC.widget.GridColumn.TypeSuggestField) && ac.m_TypeSpecificParams[0].isOpen()) || ((ac.m_Type == ITC.widget.GridColumn.TypeEditableDropDown) && ac.m_TypeSpecificParams[0].isOpen())))
				return true;
			if (pEvent.keyCode && ((pEvent.keyCode == 9) || (pEvent.keyCode == 13) || (pUpDown && ((pEvent.keyCode == 38) || (pEvent.keyCode == 40))))) {
				if ((pEvent.keyCode == 9) || (pEvent.keyCode == 13)) {
					if (((pEvent.keyCode == 9) || (pEvent.keyCode == 13)) && pEvent.shiftKey)
						gr._activatePreviousHorizontalCell();
					else
						gr._activateNextHorizontalCell();
				} else {
					if (pEvent.keyCode == 38)
						gr._activatePreviousVerticalCell();
					else
						gr._activateNextVerticalCell();
				}
				if (document.all) {
					pEvent.cancelBubble = true;
					pEvent.returnValue = false;
				} else {
					pEvent.stopPropagation();
					pEvent.preventDefault();
				}
				return false;
			}
			return true;
		});
	},
	
	_activateNextHorizontalCell: function(pPrevious) {
		var i, j, beginColumn, ar, ac;
		
		ar = this.m_ActiveRow == null?0:this.m_ActiveRow;
		ac = this.m_ActiveColumn == null?0:this.m_ActiveColumn;
		beginColumn = ac + 1;
		for (i=ar;i<this.m_Rows.length;i++) {
			if (this.m_Rows[i].m_ReadOnly == false) {
				for (j=beginColumn;j<this.m_Columns.length;j++) {
					if (!!this.m_Rows[i].isColumnReadOnly(j) && (this.m_Columns[j].m_Type !!= ITC.widget.GridColumn.TypeFunction)) {
						this._activateField(i, j);
						return;
					}
				}
			}
			beginColumn = 0;
		}
	},
	
	_activatePreviousHorizontalCell: function(pPrevious) {
		var i, j, beginColumn, ar, ac;
		
		ar = this.m_ActiveRow == null?this.m_Rows.length-1:this.m_ActiveRow;
		ac = this.m_ActiveColumn == null?this.m_Columns.length:this.m_ActiveColumn;
		beginColumn = ac - 1;
		for (i=ar;i>=0;i--) {
			if (this.m_Rows[i].m_ReadOnly == false) {
				for (j=beginColumn;j>=0;j--) {
					if (!!this.m_Rows[i].isColumnReadOnly(j) && (this.m_Columns[j].m_Type !!= ITC.widget.GridColumn.TypeFunction)) {
						this._activateField(i, j);
						return;
					}
				}
			}
			beginColumn = this.m_Columns.length - 1;
		}
	},
	
	_activatePreviousVerticalCell: function(pPrevious) {
		var i, j, ar, ac;
		
		ar = this.m_ActiveRow == null?this.m_Rows.length:this.m_ActiveRow;
		ac = this.m_ActiveColumn == null?0:this.m_ActiveColumn;
		for (i=ar-1;i>=0;i--) {
			if ((this.m_Rows[i].m_ReadOnly == false) && !!this.m_Rows[i].isColumnReadOnly(ac) && (this.m_Columns[ac].m_Type !!= ITC.widget.GridColumn.TypeFunction)) {
				this._activateField(i, ac);
				return;
			}
		}
	},
	
	_activateNextVerticalCell: function(pPrevious) {
		var i, j, ar, ac;
		
		ar = this.m_ActiveRow == null?-1:this.m_ActiveRow;
		ac = this.m_ActiveColumn == null?0:this.m_ActiveColumn;
		for (i=ar+1;i<this.m_Rows.length;i++) {
			if ((this.m_Rows[i].m_ReadOnly == false) && !!this.m_Rows[i].isColumnReadOnly(ac) && (this.m_Columns[ac].m_Type !!= ITC.widget.GridColumn.TypeFunction)) {
				this._activateField(i, ac);
				return;
			}
		}
	},
	
	_activateInitialCell: function() {
		var i, j, editableRow, errors, notEditableFlag;
		
		editableRow = -1;
		for (i=0;i<this.m_Rows.length;i++) {
			errors = this.m_Rows[i].m_Errors;
			if (errors) {
				for (j=0;j<this.m_Columns.length;j++) {
					if (errors[j] && !!this.m_Rows[i].isColumnReadOnly(j)) {
						this._activateField(i, j);
						return;
					}
				}
			}
			if ((editableRow == -1) && (this.m_Rows[i].m_ReadOnly == false)) {
				notEditableFlag = false;
				for (j=0;j<this.m_Columns.length;j++) {
					if (this.m_Rows[i].isColumnReadOnly(j))
						notEditableFlag = true;
				}
				if (notEditableFlag == false)
					editableRow = i;
			}
		}
		if (editableRow > -1) {
			for (j=0;j<this.m_Columns.length;j++) {
				if (!!this.m_Rows[editableRow].isColumnReadOnly(j) && (this.m_Columns[j].m_Type !!= ITC.widget.GridColumn.TypeFunction)) {
					this._activateField(editableRow, j);
					return;
				}
			}
		}
	},
	
	_resortRows: function() {
		var i, j;
		
		this.m_Rows.sort(function(a, b) {
			if (a.m_Index < b.m_Index)
				return -1;
			if (a.m_Index > b.m_Index)
				return 1;
			return 0;
		});
		for (j=0;j<this.m_Rows.length;j++) {
			this.m_Rows[j].m_Index = j;
			if (this.m_Rows[j].m_IdElement)
				this.m_Rows[j].m_IdElement.name = (this.m_IdFieldName?this.m_IdFieldName:''gridRowId'') + ''_'' + j;
			for (i=0;i<this.m_Columns.length;i++) {
				if (this.m_Columns[i].m_Type !!= ITC.widget.GridColumn.TypeFunction) {
					if (this.m_Columns[i].m_Type !!= ITC.widget.GridColumn.TypeCheckBox) {
						if (this.m_Rows[j].m_Elements[i] !!= null)
							this.m_Rows[j].m_Elements[i].name = this.m_Columns[i].m_Name + ''_'' + j;
						if (this.m_Rows[j].m_ValueElements[i] !!= null)
							this.m_Rows[j].m_ValueElements[i].name = this.m_Columns[i].m_HiddenName + ''_'' + j;
					} else {
						if (this.m_Rows[j].m_Data[i] !!= null)
							this.m_Rows[j].m_Data[i].name = this.m_Columns[i].m_Name + ''_'' + j;
					}
				}
			}
		}
	},
	
	_removeRow: function(pRow) {
		var q, i, newRows;
		
		if (!!pRow || !!this.m_Changeable)
			return;
		if (this.m_Messages["Grid.removeRowConfirmMessage"]) {
			if (confirm(this.m_Messages["Grid.removeRowConfirmMessage"]) == ''0'')
				return;
		}
		if ((this.m_ActiveRow !!= null) && (this.m_ActiveColumn !!= null))
			this._deactivateField(this.m_ActiveRow, this.m_ActiveColumn, this.m_ActiveValue, true);
		this.m_ActiveRow = null;
		this.m_ActiveColumn = null;
		newRows = new Array();
		for (i=0;i<this.m_Rows.length;i++)
			if (!!this.m_Rows[i].isSelected() && (this.m_Rows[i] !!= pRow))
				newRows[newRows.length] = this.m_Rows[i];
		this.m_Rows = newRows;
		this._resortRows();
		this._updateFunctionElements();
		this._markDirty();
		this._refreshContent();
	},
	
	_swapRows: function(pRowNr1, pRowNr2) {
		var row1, row2, i, rowCount1, rowCount2, oldIndex, index, name;
		
		row1 = this.m_Rows[pRowNr1];
		row2 = this.m_Rows[pRowNr2];
		if (row1 == row2)
			return;
		rowCount1 = row2.m_RowId;
		rowCount2 = row1.m_RowId;
		for (i=0;i<this.m_Columns.length;i++) {
			if (this.m_Columns[i].m_Type !!= ITC.widget.GridColumn.TypeFunction) {
				if (this.m_Columns[i].m_Type !!= ITC.widget.GridColumn.TypeCheckBox) {
					if (row1.m_Elements[i] !!= null)
						row1.m_Elements[i].name = this.m_Columns[i].m_Name + ''_'' + rowCount1;
					if (row2.m_Elements[i] !!= null)
						row2.m_Elements[i].name = this.m_Columns[i].m_Name + ''_'' + rowCount2;
					if (row1.m_ValueElements[i] !!= null)
						row1.m_ValueElements[i].name = this.m_Columns[i].m_HiddenName + ''_'' + rowCount1;
					if (row2.m_ValueElements[i] !!= null)
						row2.m_ValueElements[i].name = this.m_Columns[i].m_HiddenName + ''_'' + rowCount2;
				} else {
					if (row1.m_Data[i] !!= null)
						row1.m_Data[i].name = this.m_Columns[i].m_Name + ''_'' + rowCount1;
					if (row2.m_Data[i] !!= null)
						row2.m_Data[i].name = this.m_Columns[i].m_Name + ''_'' + rowCount2;
				}
			}
		}
		if (row1.m_IdElement)
			row1.m_IdElement.name = (this.m_IdFieldName?this.m_IdFieldName:''gridRowId'') + ''_'' + rowCount1;
		if (row2.m_IdElement)
			row2.m_IdElement.name = (this.m_IdFieldName?this.m_IdFieldName:''gridRowId'') + ''_'' + rowCount2;
		if (row1.m_HiddenElements) {
			for (i=0;i<row1.m_HiddenElements.length;i++) {
				name = row1.m_HiddenElements[i].name;
				index = name.lastIndexOf(''_'');
				row1.m_HiddenElements[i].name = name.substring(0, index) + ''_'' + rowCount1;
			}
		}
		if (row2.m_HiddenElements) {
			for (i=0;i<row2.m_HiddenElements.length;i++) {
				name = row2.m_HiddenElements[i].name;
				index = name.lastIndexOf(''_'');
				row2.m_HiddenElements[i].name = name.substring(0, index) + ''_'' + rowCount2;
			}
		}
		oldIndex = row1.m_Index;
		row1.m_Index = row2.m_Index;
		row2.m_Index = oldIndex;
		row1.m_RowId = rowCount1;
		row2.m_RowId = rowCount2;
		this.m_Rows[pRowNr1] = row2;
		this.m_Rows[pRowNr2] = row1;
	},
	
	_isMultipleSelected: function() {
		var i, multiple = false;
		
		for (i=0;i<this.m_Rows.length;i++) {
			if (this.m_Rows[i].isSelected()) {
				if (multiple == true)
					return true;
				else
					multiple = true;
			}
		}
		return false;
	},
	
	_moveRowFirst: function(pRow) {
		var i;
		
		if (!!pRow || (this.m_Rows[0] == pRow) || this._isMultipleSelected() || !!this.m_Changeable)
			return;
		if ((this.m_ActiveRow !!= null) && (this.m_ActiveColumn !!= null))
			this._deactivateField(this.m_ActiveRow, this.m_ActiveColumn, this.m_ActiveValue, true);
		this.m_ActiveRow = null;
		this.m_ActiveColumn = null;
		for (i=pRow.m_Index;i>0;i--)
			this._swapRows(i-1, i);
		this._updateFunctionElements();
		this._markDirty();
		this._refreshContent();
	},
	
	_moveRowUp: function(pRow) {
		if (!!pRow || (this.m_Rows[0] == pRow) || this._isMultipleSelected() || !!this.m_Changeable)
			return;
		if ((this.m_ActiveRow !!= null) && (this.m_ActiveColumn !!= null))
			this._deactivateField(this.m_ActiveRow, this.m_ActiveColumn, this.m_ActiveValue, true);
		this.m_ActiveRow = null;
		this.m_ActiveColumn = null;
		this._swapRows(pRow.m_Index-1, pRow.m_Index);
		this._updateFunctionElements();
		this._markDirty();
		this._refreshContent();
	},
	
	_moveRowDown: function(pRow) {
		if (!!pRow || (this.m_Rows[this.m_Rows.length-1] == pRow) || this._isMultipleSelected() || !!this.m_Changeable)
			return;
		if ((this.m_ActiveRow !!= null) && (this.m_ActiveColumn !!= null))
			this._deactivateField(this.m_ActiveRow, this.m_ActiveColumn, this.m_ActiveValue, true);
		this.m_ActiveRow = null;
		this.m_ActiveColumn = null;
		this._swapRows(pRow.m_Index, pRow.m_Index+1);
		this._updateFunctionElements();
		this._markDirty();
		this._refreshContent();
	},
	
	_moveRowLast: function(pRow) {
		var i;
		
		if (!!pRow || (this.m_Rows[this.m_Rows.length-1] == pRow) || this._isMultipleSelected() || !!this.m_Changeable)
			return;
		if ((this.m_ActiveRow !!= null) && (this.m_ActiveColumn !!= null))
			this._deactivateField(this.m_ActiveRow, this.m_ActiveColumn, this.m_ActiveValue, true);
		this.m_ActiveRow = null;
		this.m_ActiveColumn = null;
		for (i=pRow.m_Index;i<this.m_Rows.length-1;i++)
			this._swapRows(i, i+1);
		this._updateFunctionElements();
		this._markDirty();
		this._refreshContent();
	},
	
	_fillRowFrom: function(pRow, pDictionary) {
		var i, dictValue, col;
		var u;
	
		if (!!pRow || !!pDictionary)
			return;
		for (i=0;i<this.m_Columns.length;i++) {
			col = this.m_Columns[i];
			dictValue = pDictionary[col.m_Name];
			if (dictValue !!= u) {
				if ((col.m_Type == ITC.widget.GridColumn.TypeTextField) || (col.m_Type == ITC.widget.GridColumn.TypeDateField)) {
					pRow.m_Elements[i].value = dictValue;
					pRow.m_Data[i].innerHTML = dictValue;
				} else if (col.m_Type == ITC.widget.GridColumn.TypeDropDown) {
					pRow.m_Elements[i].value = dictValue;
					pRow.m_Data[i].innerHTML = this._optionText(pRow.m_Elements[i].value, col.m_Element, col.m_TypeSpecificParams[0]).htmlEncode();
				} else if (col.m_Type == ITC.widget.GridColumn.TypeEditableDropDown) {
					pRow.m_Elements[i].value = dictValue;
					pRow.m_Data[i].innerHTML = dictValue;
				} else if (col.m_Type == ITC.widget.GridColumn.TypeCheckBox) {
					pRow.m_Data[i].checked = dictValue == true;
				}
			}
		}
	},
	
	_onBlurField: function(pRow, pOnBlurFunction) {
		var i, col, rowValues, val;
	
		if (!!pRow)
			return;
		rowValues = new Array();
		for (i=0;i<this.m_Columns.length;i++) {
			col = this.m_Columns[i];
			val = null;
			if ((col.m_Type == ITC.widget.GridColumn.TypeTextField) || (col.m_Type == ITC.widget.GridColumn.TypeDateField)) {
				val = pRow.m_Elements[i].value;
			} else if (col.m_Type == ITC.widget.GridColumn.TypeDropDown) {
				val =  this._optionText(pRow.m_Elements[i].value, col.m_Element, col.m_TypeSpecificParams[0]);
			} else if (col.m_Type == ITC.widget.GridColumn.TypeEditableDropDown) {
				val = pRow.m_Elements[i].value;
			} else if (col.m_Type == ITC.widget.GridColumn.TypeSuggestField) {
				val = pRow.m_Data[i].innerHTML.htmlDecode();
			} else if (col.m_Type == ITC.widget.GridColumn.TypeCheckBox) {
				val = pRow.m_Data[i].checked == true;
			}
			rowValues[col.m_Name] = val;
		}
		this._fillRowFrom(this.m_Rows[this.m_ActiveRow], pOnBlurFunction(rowValues, pRow));
	},
	
	_onDropDownChange: function(pValue, pOnChangeFunction) {
		if (this.m_ActiveRow == null)
			return;
		this._fillRowFrom(this.m_Rows[this.m_ActiveRow], pOnChangeFunction(pValue));
	},
	
	_showDateField: function(pX, pY) {
		var row, col, el, calendar;
		
		if ((this.m_ActiveRow == null) || (this.m_ActiveColumn == null))
			return;
		col = this.m_Columns[this.m_ActiveColumn];
		if (!!col || (col.m_Type !!= ITC.widget.GridColumn.TypeDateField))
			return;
		row = this.m_Rows[this.m_ActiveRow];
		el = row.m_Elements[this.m_ActiveColumn];
		if (!!el)
			return;
		calendar = col.m_TypeSpecificParams[0];
		calendar.setDate(ITC.util.StringToDate(el.value));
		calendar.show(pX, pY, col.m_TypeSpecificParams[1]);
	},
	
	_deactivateField: function(pRowNr, pColumnNr, pOldValue, pMark) {
		var row, col;
		
		if ((pRowNr < 0) || (pRowNr >= this.m_Rows.length) || (pColumnNr < 0) || (pColumnNr >= this.m_Columns.length))
			return;
		col = this.m_Columns[pColumnNr];
		row = this.m_Rows[pRowNr];
		if ((col.m_Type == ITC.widget.GridColumn.TypeFunction) || (row.m_ReadOnly==true) || row.isColumnReadOnly(pColumnNr))
			return;
		if (row.m_Errors && row.m_Errors[pColumnNr])
			this.m_HideableErrorContainer.hideOnly();
		row.m_Data[pColumnNr].style.display = ''block'';
		if (col.m_Element !!= null) {
			col.m_Element.style.display = ''none'';
			if (col.m_Type == ITC.widget.GridColumn.TypeTextField) {
				if (col.m_TypeSpecificParams[0] == true)
					row.m_Elements[pColumnNr].value = ITC.util.FloatToString(ITC.util.StringToFloat(col.m_Element.value), col.m_TypeSpecificParams[1]);
				else
					row.m_Elements[pColumnNr].value = col.m_Element.value;
				row.m_Data[pColumnNr].innerHTML = row.m_Elements[pColumnNr].value;
			} else if (col.m_Type == ITC.widget.GridColumn.TypeDropDown) {
				row.m_Elements[pColumnNr].value = col.m_Element.value;
				row.m_Data[pColumnNr].innerHTML = this._optionText(row.m_Elements[pColumnNr].value, col.m_Element, col.m_TypeSpecificParams[0]).htmlEncode();
			} else if (col.m_Type == ITC.widget.GridColumn.TypeDateField) {
				col.m_TypeSpecificParams[0].hide();
				row.m_Elements[pColumnNr].value = ITC.util.DateToString(ITC.util.StringToDate(col.m_TypeSpecificParams[1].value));
				row.m_Data[pColumnNr].innerHTML = row.m_Elements[pColumnNr].value.htmlEncode();
			} else if (col.m_Type == ITC.widget.GridColumn.TypeSuggestField) {
				col.m_TypeSpecificParams[0]._hideSuggestBox();
				row.m_ValueElements[pColumnNr].value = col.m_TypeSpecificParams[2].value;
				row.m_Elements[pColumnNr].value = col.m_TypeSpecificParams[1].value;
				row.m_Data[pColumnNr].innerHTML = col.m_TypeSpecificParams[1].value.htmlEncode();
			} else if (col.m_Type == ITC.widget.GridColumn.TypeEditableDropDown) {
				col.m_TypeSpecificParams[0]._hide();
				if (col.m_TypeSpecificParams[2] && row.m_ValueElements[pColumnNr])
					row.m_ValueElements[pColumnNr].value = col.m_TypeSpecificParams[2].value;
				row.m_Elements[pColumnNr].value = col.m_TypeSpecificParams[1].value;
				row.m_Data[pColumnNr].innerHTML = col.m_TypeSpecificParams[1].value.htmlEncode();
			} else {
				row.m_Data[pColumnNr].innerHTML = row.m_Elements[pColumnNr].value.htmlEncode();
			}
		} else {
			row.m_Data[pColumnNr].parentNode.className = null;
		}
		if ((pMark == true) && (pOldValue !!= null)) {
			if (col.m_Type == ITC.widget.GridColumn.TypeCheckBox) {
				if ((row.m_Data[pColumnNr].checked == true) !!= pOldValue)
					this._markDirty();
			} else {
				if (row.m_Elements[pColumnNr] && (row.m_Elements[pColumnNr].value !!= pOldValue))
					this._markDirty();
			}
		}
		if (col.m_OnBlurFunction)
			col.m_OnBlurFunction(this, row);
	},
	
	_positionElementVisibleAtParent: function(pParentElement, pElement, pAlignment) {
		var leftPos, scrollLeft, pos, rightPos, scrollTop, containerWidth, containerHeight, containerBottom;
	
		this.m_OneTimeOnScrollDisabled = true;
		containerWidth = this.m_ContentContainer.clientWidth;
		containerHeight = this.m_ContentContainer.clientHeight;
		leftPos = ITC.dom.GetInlineElementPositionLeft(pParentElement, this.m_ContentContainer) - this.m_ContentContainer.scrollLeft;
		if (pAlignment && (pAlignment !!= ''left'') && (pElement.offsetWidth < pParentElement.offsetWidth)) {
			if (pAlignment == ''right'')
				leftPos = leftPos + pParentElement.offsetWidth - pElement.offsetWidth
			else if (pAlignment == ''center'')
				leftPos = leftPos + Math.floor((pParentElement.offsetWidth - pElement.offsetWidth) / 2);
		}
		if ((leftPos + pElement.offsetWidth) > containerWidth) {
			scrollLeft = this.m_ContentContainer.scrollLeft + (leftPos + pElement.offsetWidth) - containerWidth;
			if (scrollLeft > (this.m_ContentContainer.scrollWidth - this.m_ContentContainer.clientWidth)) {
				scrollLeft = this.m_ContentContainer.scrollWidth - this.m_ContentContainer.clientWidth;
				pos = ITC.dom.GetElementPositionLeft(pParentElement) - scrollLeft;
				leftPos = containerWidth - pElement.offsetWidth;
			} else {
				leftPos -= scrollLeft - this.m_ContentContainer.scrollLeft;
			}
			this.m_ContentContainer.scrollLeft = this.m_HeaderContainer.scrollLeft = scrollLeft;
		} else if (leftPos < 0) {
			scrollLeft = this.m_ContentContainer.scrollLeft + leftPos;
			if (scrollLeft < 0)
				scrollLeft = 0;
			leftPos -= scrollLeft - this.m_ContentContainer.scrollLeft;
			this.m_ContentContainer.scrollLeft = this.m_HeaderContainer.scrollLeft = scrollLeft;
		}
		pElement.style.left = ITC.dom.GetInlineElementPositionLeft(pParentElement, this.m_ContentContainer) + ''px'';
		topPos = ITC.dom.GetInlineElementPositionTop(pParentElement, this.m_ContentContainer) - this.m_ContentContainer.scrollTop;
		if ((topPos + pElement.offsetHeight) > containerHeight) {
			scrollTop = this.m_ContentContainer.scrollTop + (topPos + pElement.offsetHeight) - containerHeight;
			if (scrollTop > (this.m_ContentContainer.scrollHeight - this.m_ContentContainer.clientHeight)) {
				scrollTop = this.m_ContentContainer.scrollHeight - this.m_ContentContainer.clientHeight;
				pos = ITC.dom.GetElementPositionTop(pParentElement) - scrollTop;
				topPos = containerHeight - pElement.offsetHeight;
			} else {
				topPos = ITC.dom.GetElementPositionTop(pParentElement) - scrollTop;
			}
			this.m_ContentContainer.scrollTop = scrollTop;
		} else if (topPos < 0) {
			scrollTop = this.m_ContentContainer.scrollTop - (0 - topPos);
			if (scrollTop < 0)
				scrollTop = 0;
			this.m_ContentContainer.scrollTop = scrollTop;
			topPos = ITC.dom.GetElementPositionTop(pParentElement) - scrollTop;
		}
		pElement.style.top = ITC.dom.GetInlineElementPositionTop(pParentElement, this.m_ContentContainer) + ''px'';
	},
	
	_activateField: function(pRowNr, pColumnNr) {
		var row, col, dataEl, element, i, leftPos, scrollLeft, additionalFieldNames;
		
		if ((pRowNr < 0) || (pRowNr >= this.m_Rows.length) || (pColumnNr < 0) || (pColumnNr >= this.m_Columns.length))
			return;
		if ((this.m_ActiveRow == pRowNr) && (this.m_ActiveColumn == pColumnNr))
			return;
		if ((this.m_ActiveRow !!= null) && (this.m_ActiveColumn !!= null))
			this._deactivateField(this.m_ActiveRow, this.m_ActiveColumn, this.m_ActiveValue, true);
		col = this.m_Columns[pColumnNr];
		row = this.m_Rows[pRowNr];
		if ((col.m_Type == ITC.widget.GridColumn.TypeFunction) || (row.m_ReadOnly==true) || row.isColumnReadOnly(pColumnNr)) {
			this.m_ActiveRow = pRowNr;
			this.m_ActiveColumn = pColumnNr;
			return;
		}
		if (col.m_Element !!= null) {
			try {
				document.body.focus();
			} catch (e) {
			}
			col.m_Element.style.display = ''block'';
			this._positionElementVisibleAtParent(row.m_Data[pColumnNr].parentNode, col.m_Element, col.m_Alignment);
			if (row.m_Errors && row.m_Errors[pColumnNr])
				this.m_HideableErrorContainer.show(col.m_Element.offsetLeft, (col.m_Element.offsetTop + col.m_Element.offsetHeight), false, row.m_Errors[pColumnNr].innerHTML);
			row.m_Data[pColumnNr].style.display = ''none'';
			if (col.m_Type == ITC.widget.GridColumn.TypeTextField) {
				col.m_Element.value = row.m_Elements[pColumnNr].value;
				col.m_Element.focus();
				col.m_Element.select();
			} else if (col.m_Type == ITC.widget.GridColumn.TypeDropDown) {
				this._selectOption(row.m_Elements[pColumnNr].value, col.m_Element);
				col.m_Element.focus();
			} else if (col.m_Type == ITC.widget.GridColumn.TypeDateField) {
				col.m_TypeSpecificParams[1].value = row.m_Elements[pColumnNr].value;
				col.m_TypeSpecificParams[1].focus();
				col.m_TypeSpecificParams[1].select();
			} else if (col.m_Type == ITC.widget.GridColumn.TypeSuggestField) {
				try {
					if (col.m_TypeSpecificParams[3]) {
						col.m_TypeSpecificParams[0].clearAllRequestFieldMappings();
						for (i=0;i<col.m_TypeSpecificParams[3].length;i++)
							col.m_TypeSpecificParams[0].addRequestFieldMapping(col.m_TypeSpecificParams[3][i] + ''_'' + (pRowNr + 1));
					}
				} catch (e) {}
				col.m_TypeSpecificParams[2].value = row.m_ValueElements[pColumnNr].value;
				col.m_TypeSpecificParams[1].value = row.m_Data[pColumnNr].innerHTML.htmlDecode();
				col.m_TypeSpecificParams[1].focus();
				col.m_TypeSpecificParams[1].select();
			} else if (col.m_Type == ITC.widget.GridColumn.TypeEditableDropDown) {
				if (col.m_TypeSpecificParams[2]) {
					if (row.m_ValueElements[pColumnNr])
						col.m_TypeSpecificParams[2].value = row.m_ValueElements[pColumnNr].value;
					else
						col.m_TypeSpecificParams[2].value = row.m_Elements[pColumnNr].value;
				}
				col.m_TypeSpecificParams[1].value = row.m_Data[pColumnNr].innerHTML.htmlDecode();
				col.m_TypeSpecificParams[1].focus();
				col.m_TypeSpecificParams[1].select();
			} else {
				col.m_Element.focus();
			}
		} else {
			row.m_Data[pColumnNr].parentNode.className = ''GridInputField'';
			row.m_Data[pColumnNr].focus();
			if (row.m_Errors && row.m_Errors[pColumnNr])
				this.m_HideableErrorContainer.show(row.m_Data[pColumnNr].offsetLeft, (row.m_Data[pColumnNr].offsetTop + row.m_Data[pColumnNr].offsetHeight), false, row.m_Errors[pColumnNr].innerHTML);
		}
		this.m_ActiveRow = pRowNr;
		this.m_ActiveColumn = pColumnNr;
		if (col.m_Type == ITC.widget.GridColumn.TypeCheckBox)
			this.m_ActiveValue = row.m_Data[pColumnNr].checked == true;
		else
			this.m_ActiveValue = row.m_Elements[pColumnNr]?row.m_Elements[pColumnNr].value:null;
	},
	
	_fillFunctionElement: function(pFunctionName, pRow, pColumnIndex) {
		var gr = this;
		var result, el;
		
		if (!!(result = pRow.m_Data[pColumnIndex])) {
			result = document.createElement(''div'');
			result.className = ''GridData'';
			result.style.overflow = ''hidden'';
			result.style.whiteSpace = ''nowrap'';
			result.style.textOverflow = ''ellipsis'';
			pRow.m_Data[pColumnIndex] = result;
		} else {
			result.innerHTML = '''';
		}
		if (pFunctionName == ''SEQ'') {
			result.innerHTML = (this.m_RowBeginIndex + pRow.m_Index + 1) + ''.'';
		} else if (pFunctionName == ''SEQUPDOWN'') {
			el = document.createElement(''img'');
			ITC.dom.SetPointerCursorFor(el);
			el.src = ''images/upbr2.gif'';
			result.appendChild(el);
			ITC.event.AddListener(''click'', el, function(pEvent) {
				gr._moveRowUp(pRow);
			});
			el = document.createElement(''img'');
			ITC.dom.SetPointerCursorFor(el);
			el.src = ''images/downbr2.gif'';
			result.appendChild(el);
			ITC.event.AddListener(''click'', el, function(pEvent) {
				gr._moveRowDown(pRow);
			});
			el = document.createElement(''span'');
			el.className = ''GridData'';
			el.innerHTML = ''&nbsp;'' + (this.m_RowBeginIndex + pRow.m_Index + 1) + ''.'';
			result.appendChild(el);
		} else if (pFunctionName == ''UPDOWN'') {
			el = document.createElement(''img'');
			ITC.dom.SetPointerCursorFor(el);
			el.src = ''images/upbr2.gif'';
			result.appendChild(el);
			ITC.event.AddListener(''click'', el, function(pEvent) {
				gr._moveRowUp(pRow);
			});
			el = document.createElement(''img'');
			ITC.dom.SetPointerCursorFor(el);
			el.src = ''images/downbr2.gif'';
			result.appendChild(el);
			ITC.event.AddListener(''click'', el, function(pEvent) {
				gr._moveRowDown(pRow);
			});
		} else if (pFunctionName == ''DEL'') {
			el = document.createElement(''img'');
			ITC.dom.SetPointerCursorFor(el);
			el.src = ''images/delete.gif'';
			result.appendChild(el);
			ITC.event.AddListener(''click'', el, function(pEvent) {
				gr._removeRow(pRow);
			});
		} else if (pFunctionName == ''SELECTSEQ'') {
			result.appendChild(pRow.getCheckBoxContainer());
			el = document.createElement(''span'');
			el.className = ''GridData'';
			el.innerHTML = ''&nbsp;'' + (this.m_RowBeginIndex + pRow.m_Index + 1) + ''.'';
			result.appendChild(el);
		}
		return result;
	},
	
	_toggleSelectRow: function(pEvent, pRow) {
		var i, selectBool, beginIndex, endIndex, row, e = pEvent?pEvent:window.event;
		
		if (this.m_MultipleSelect) {
			if (e.shiftKey) {
				selectBool = this.m_LastSelectedRow?this.m_LastSelectedRow.isSelected():true;
				beginIndex = 0;
				for (i=0;i<this.m_Rows.length;i++) {
					if (!!e.ctrlKey)
						this.m_Rows[i].selectRow(false);
					if (this.m_Rows[i] == this.m_LastSelectedRow)
						beginIndex = i;
					else if (this.m_Rows[i] == pRow)
						endIndex = i;
				}
				for (i=beginIndex;i<endIndex;i++)
					this.m_Rows[i].selectRow(selectBool);
				pRow.selectRow(true);
			} else if (e.ctrlKey) {
				pRow.toggleSelect();
			} else {
				for (i=0;i<this.m_Rows.length;i++) {
					if (this.m_Rows[i] !!= pRow)
						this.m_Rows[i].selectRow(false);
				}
				pRow.toggleSelect();
			}
		} else {
			if (this.m_LastSelectedRow)
				this.m_LastSelectedRow.selectRow(false);
			if (pRow !!= this.m_LastSelectedRow)
				pRow.selectRow(true);
		}
		this.m_LastSelectedRow = pRow;
	},
	
	_editableDropDownOptionText: function(pValue, pOptions, pHiddenField) {
		var i;
		
		if (!!pHiddenField)
			return pValue;
		if (!!pOptions)
			return '''';
		for (i=0;i<pOptions.length;i++) {
			if (pOptions[i][0] == pValue)
				return pOptions[i][1];
		}
		return '''';
	},
	
	_optionText: function(pValue, pSelectElement, pClipToSize) {
		var i, val;
		
		if (!!pSelectElement)
			return '''';
		for (i=0;i<pSelectElement.options.length;i++) {
			if (pSelectElement.options[i].value == pValue) {
				val = pSelectElement.options[i].text;
				if (pClipToSize && (val.length > pClipToSize))
					val = val.substring(0, pClipToSize);
				return val;
			}
		}
		return '''';
	},
	
	_selectOption: function(pValue, pSelectElement) {
		var i;
		
		if (!!pSelectElement)
			return;
		for (i=0;i<pSelectElement.options.length;i++) {
			if (pSelectElement.options[i].value == pValue) {
				pSelectElement.options[i].selected = true;
				return;
			}
		}
	},
	
	_addActivationEventTo: function(pElement, pRow, pColumn) {
		var gr = this;
		
		ITC.event.AddListener(''click'', pElement, function(pEvent) {
			gr._activateField(pRow, pColumn);
		});
	}
}

ITC.widget.GridRow = function(pGrid, pIndex, pRowId, pData, pElements, pValueElements, pErrors, pReadOnlyColumns, pIdElement, pHiddenElements, pReadOnly) {
	var el, i, gr = this;
	
	this.m_Grid = pGrid;
	this.m_Index = pIndex;
	this.m_RowId = pRowId;
	this.m_Data = pData;
	this.m_Elements = pElements;
	this.m_ValueElements = pValueElements;
	this.m_Errors = pErrors;
	this.m_ReadOnlyColumns = pReadOnlyColumns;
	this.m_IdElement = pIdElement;
	this.m_HiddenElements = pHiddenElements;
	this.m_ReadOnly = pReadOnly==true;
	this.m_Selected = false;
	this.m_Container = null;
	this.m_CellContainers = new Array();
	el = document.createElement(''img'');
	ITC.dom.SetPointerCursorFor(el);
	el.src = ''images/check-box-empty.gif'';
	ITC.event.AddListener(''click'', el, function(pEvent) {
		pGrid._toggleSelectRow(pEvent, gr);
	});
	this.m_CheckBox = el;
	if (!!this.m_ReadOnlyColumns || !!ITC.util.IsArray(this.m_ReadOnlyColumns))
		this.m_ReadOnlyColumns = new Array();
	for (i=0;i<this.m_Grid.m_Columns.length;i++)
		this.m_ReadOnlyColumns[i] = (this.m_ReadOnlyColumns.length<i?false:this.m_ReadOnlyColumns[i]==true) || (this.m_Grid.m_Columns[i].m_ReadOnly == true);
}

ITC.widget.GridRow.prototype = {
	isSelected: function() {
		return this.m_Selected == true;
	},
	
	selectRow: function(pBoolean) {
		this.m_Selected = pBoolean == true;
		this._updateCheckBox();
	},
	
	toggleSelect: function() {
		this.m_Selected = this.m_Selected==true?false:true;
		this._updateCheckBox();
	},
	
	getCheckBoxContainer: function() {
		return this.m_CheckBox;
	},
	
	_updateCheckBox: function() {
		if (this.isSelected()) {
			this.m_Container.className = ''GridRowSelected'';
			this.m_CheckBox.src = ''images/check-box-full.gif'';
		} else {
			this.m_Container.className = ''GridRow'' + ((this.m_Index%2)==0?''Even'':''Odd'');
			this.m_CheckBox.src = ''images/check-box-empty.gif'';
		}
	},
	
	isColumnReadOnly: function(pColumnIndex) {
		if (!!this.m_ReadOnlyColumns)
			return false;
		return ((this.m_ReadOnlyColumns.length > pColumnIndex) && (this.m_ReadOnlyColumns[pColumnIndex] == true));
	},
	
	setColumnReadOnly: function(pColumnIndex, pIsReadOnly) {
		if ((pColumnIndex < 0) || (pColumnIndex >= this.m_Grid.m_Columns.length))
			return;
		this.m_ReadOnlyColumns[pColumnIndex] = pIsReadOnly==true;
	},
	
	_addActivationEventTo: function(pElement, pColumn) {
		var grid = this.m_Grid;
		var gr = this;
		
		ITC.event.AddListener(''click'', pElement, function(pEvent) {
			grid._activateField(gr.m_Index, pColumn);
		});
	},
	
	resize: function() {
		var i, colWidth;
		
		for (i=0;i<this.m_Grid.m_Columns.length;i++) {
			colWidth = this.m_Grid.m_HeaderColumns[i].offsetWidth - 2;
			if (colWidth < 0)
				colWidth = 0;
			this.m_CellContainers[i].style.width = colWidth + ''px'';
			this.m_Data[i].style.width = colWidth + ''px'';
			if (this.m_Errors && this.m_Errors[i])
				this.m_Errors[i].style.width = colWidth + ''px'';
		}
	},
	
	getContainer: function() {
		var row, i, j, el, colWidth;
	
		if (!!this.m_Container) {
			row = document.createElement(''tr'');
			for (i=0;i<this.m_Grid.m_Columns.length;i++) {
				el = document.createElement(''td'');
				this.m_CellContainers[i] = el;
				if (this.m_Grid.m_Columns[i].m_Alignment !!= null)
					el.align = this.m_Grid.m_Columns[i].m_Alignment;
				row.appendChild(el);
				el.appendChild(this.m_Data[i]);
				if (this.m_Elements[i])
					el.appendChild(this.m_Elements[i]);
				if (this.m_ValueElements[i])
					el.appendChild(this.m_ValueElements[i]);
				if (this.m_Errors && this.m_Errors[i]) {
					el.appendChild(this.m_Errors[i]);
				}
				if (i==0) {
					if (this.m_IdElement)
						el.appendChild(this.m_IdElement);
					if (this.m_HiddenElements) {
						for (j=0;j<this.m_HiddenElements.length;j++) {
							if (this.m_HiddenElements[j])
								el.appendChild(this.m_HiddenElements[j]);
						}
					}
				}
				this._addActivationEventTo(el, i);
			}
			this.resize();
			this.m_Container = row;
		}
		if (this.isSelected())
			this.m_Container.className = ''GridRowSelected'';
		else
			this.m_Container.className = ''GridRow'' + ((this.m_Index%2)==0?''Even'':''Odd'');
		return this.m_Container;
	}
}

ITC.widget.GridColumn = function(pType, pWidth, pAlignment, pElement, pName, pLabel, pDefaultValue, pHiddenName, pOnBlurFunctionBody, pReadOnly, pTypeSpecificParams) {
	this.m_Type = pType;
	this.m_Width = pWidth;
	this.m_Alignment = pAlignment;
	this.m_Element = pElement;
	this.m_Name = pName;
	this.m_Label = pLabel;
	this.m_DefaultValue = pDefaultValue;
	this.m_HiddenName = pHiddenName;
	this.m_ReadOnly = pReadOnly==true;
	this.m_OnBlurFunction = pOnBlurFunctionBody?function (pGrid, pRow) {pGrid._onBlurField(pRow, new Function(''pRowValues'', ''pRow'', pOnBlurFunctionBody));}:null;
	this.m_TypeSpecificParams = pTypeSpecificParams?pTypeSpecificParams:null;
}

ITC.widget.GridColumn.TypeTextField = 0;
ITC.widget.GridColumn.TypeDateField = 1;
ITC.widget.GridColumn.TypeDropDown = 2;
ITC.widget.GridColumn.TypeCheckBox = 3;
ITC.widget.GridColumn.TypeFunction = 4;
ITC.widget.GridColumn.TypeSuggestField = 5;
ITC.widget.GridColumn.TypeEditableDropDown = 6;'!

javascriptPrivateSessionRefresher
	^'
ITC.widget.SessionRefresher = function(aTaskUrl, aDefExpTime)
{
	var ts=this;

	this.taskUrl = aTaskUrl;
	this.defExpTime = (aDefExpTime - 2) * 60000;
	if(this.defExpTime<=0) this.defExpTime=null;
	this.lastKeyEventTime = null;
	this.sleepTimer = null;
};

ITC.widget.SessionRefresher.singleton = null;
ITC.widget.SessionRefresher.getSingleton = function(aTaskUrl, aDefExpTime)
{
	if (!!ITC.widget.SessionRefresher.singleton) ITC.widget.SessionRefresher.singleton = new ITC.widget.SessionRefresher(aTaskUrl, aDefExpTime);
	return ITC.widget.SessionRefresher.singleton;
};

ITC.widget.SessionRefresher.prototype = {
	setSleepTimer: function(aSleepTime)
	{
		var ts=this;

		if(aSleepTime) this.defExpTime = (aSleepTime - 2) * 60000;
		if(this.defExpTime<=0) this.defExpTime = null;
		
		this.lastKeyEventTime = null;
		if(this.defExpTime) this.sleepTimer = function(){setTimeout(function(){ts.checkExpiration()}, this.defExpTime)};
		
		this.sleepTimer();
	},

	setLastKeyEventTime: function()
	{
		this.lastKeyEventTime=(new Date()).getTime();
	},

	checkExpiration: function()
	{
		if(this.taskUrl=="" || this.defExpTime == null || this.lastKeyEventTime == null) return true;

		(new ITC.ajax.DataRetriever(null, null, true)).sendRequest(this.taskUrl + "?action=ajaxGetSessionRefresh&id=" + ((new Date()).getTime() - this.lastKeyEventTime));
	}
};'!

javascriptPrivateTypingSuggest
	^'ITC.widget.TypingSuggest = function(pUrlPrefix, pInputElementId, pValueElementId, pDisplayIndex, pValueIndex, pShownIndices, pOnSelectImgElementId, pControlElementId, pSendEmptyRequest, pShowNoResults, pNoResultsLabel, pFormName) {
	var frm = ITC.dom.GetElement(pFormName);

	this.m_UrlPrefix = pUrlPrefix?pUrlPrefix:'''';
	this.m_InputElement = new ITC.dom.Element(pInputElementId, frm);
	this.m_ValueElement = pValueElementId?new ITC.dom.Element(pValueElementId, frm):null;
	this.m_OnSelectImgElement = pOnSelectImgElementId?new ITC.dom.Element(pOnSelectImgElementId, frm):null;
	this.m_ControlElement = pControlElementId?new ITC.dom.Element(pControlElementId, frm):null;
	this.m_CanEdit = true;
	this.m_CanLoad = false;
	this.m_Results = new Array();
	this.m_ResultRows = null;
	this.m_SuggestBox = null;
	this.m_SuggestBoxTable = null;
	this.m_SuggestBoxTableBody = null;
	this.m_TypingTimer = null;
	this.m_SuggestIndex = 0;
	this.m_DisplayIndex = pDisplayIndex?pDisplayIndex:0;
	this.m_ValueIndex = pValueIndex?pValueIndex:0;
	this.m_ShownIndices = pShownIndices?pShownIndices:null;
	this.m_SendEmptyRequest = pSendEmptyRequest?true:false;
	this.m_NoResultsShow = pShowNoResults?true:false;
	this.m_NoResultsWasControlButtonQuery = false;
	this.m_NoResultsLabel = pNoResultsLabel?pNoResultsLabel:ITC.translation.TypingSuggestNoResults;
	this.m_NoResultsContainer = null;
 	this.m_NoResultsTimer = null;
	this.m_LastSearchString = null;
	this.m_LastSelectedString = null;
	this.m_LastWrittenString = '''';
	this.m_Cache = new Array();
	this.m_IsSuggestBoxOpen = false;
	this.m_IsMouseInsideSuggestBox = false;
	this.m_OnSelectFunctions = new Array();
	this.m_CachedFieldNames = null;
	this.m_CachedFieldValues = null;
	this.m_OnStoreCacheFunctions = new Array();
	this.m_OnRestoreCacheFunctions = new Array();
	this.m_CancelSelectCache = new Array();
	this.m_DataRetriever = null;
	this.m_AdditionalRequestFields = new Array();
	this.m_AdditionalRequestFieldMappings = new Array();
 	this.m_ValueIsSelected = (this.m_ValueElement && this.m_ValueElement.dom && this.m_ValueElement.dom.value)?true:false;
	this._initialize();
};

ITC.widget.TypingSuggest.prototype = {
	enableEdit: function(pBoolean) {
		this.m_CanEdit = pBoolean == true;
	},
	
	isOpen: function() {
		return (this.m_IsSuggestBoxOpen == true);
	},
				
	setCachedFieldNames: function(pArray) {
		this.m_CachedFieldNames = pArray;
	},
	
	addOnSelectFunction: function(pFunction) {
		this.m_OnSelectFunctions[this.m_OnSelectFunctions.length] = pFunction;
	},
	
	addOnSelectFunctionBody: function(pString) {
		this.m_OnSelectFunctions[this.m_OnSelectFunctions.length] = new Function(''pData'', pString);
	},
	
	addOnStoreCacheFunction: function(pFunction) {
		this.m_OnStoreCacheFunctions[this.m_OnStoreCacheFunctions.length] = pFunction;
	},
	
	addOnStoreCacheFunctionBody: function(pString) {
		this.m_OnStoreCacheFunctions[this.m_OnStoreCacheFunctions.length] = new Function(''pCache'', pString);
	},
	
	addOnRestoreCacheFunction: function(pFunction) {
		this.m_OnRestoreCacheFunctions[this.m_OnRestoreCacheFunctions.length] = pFunction;
	},
	
	addOnRestoreCacheFunctionBody: function(pString) {
		this.m_OnRestoreCacheFunctions[this.m_OnRestoreCacheFunctions.length] = new Function(''pCache'', pString);
	},
	
	addRequestField: function(pFieldName) {
		this.m_AdditionalRequestFields[this.m_AdditionalRequestFields.length] = pFieldName;
	},
	
	addRequestFieldMapping: function(pFieldName, pMappedFieldName) {
		this.m_AdditionalRequestFieldMappings[pFieldName] = pMappedFieldName;
	},
	
	clearAllRequestFieldMappings: function() {
		delete this.m_AdditionalRequestFieldMappings;
		this.m_AdditionalRequestFieldMappings = new Array();
	},
	
	_initialize: function() {
		var ts = this;
		
		if(!!this.m_InputElement.dom) return false;

		this.m_DataRetriever = new ITC.ajax.DataRetriever(this, ''_onResponseReceived'', false);
		this.m_InputElement.dom.autocomplete = ''off'';
		if (this.m_OnSelectImgElement && !!this.m_ValueIsSelected)
			this.m_OnSelectImgElement.dom.style.visibility = ''hidden'';
		this._initializeSuggestBox();
		if (this.m_NoResultsShow == true)
			this._initializeNoResultsContainer();
		if (this.m_ControlElement) {
			this.m_ControlElement.dom.style.pointer = ''pointer'';
			ITC.event.AddListener(''mousedown'', this.m_ControlElement.dom, function(pEvent) {
				ts.m_NoResultsWasControlButtonQuery = true;
				ts._beginSuggestSearch();
				setTimeout(function(){ts.m_InputElement.dom.focus()}, 0);
				ITC.event.StopEvent(ITC.event.GetEvent(pEvent));
			});
		};
		if(ITC.util.IsBrowserOpera())
		{
			ITC.event.AddListener(''keypress'', this.m_InputElement.dom, function(pEvent) {
			ts._onKeyDown(ITC.event.GetEvent(pEvent));
			})
		}
		else
		{
			ITC.event.AddListener(''keydown'', this.m_InputElement.dom, function(pEvent) {
			ts._onKeyDown(ITC.event.GetEvent(pEvent));
			})
		};
		ITC.event.AddListener(''blur'', this.m_InputElement.dom, function(pEvent) {
			if (ts.m_IsMouseInsideSuggestBox == false)
				ts._hideSuggestBox();
		});
	},
	
	_initializeSuggestBox: function() {
		var el, leftPos, topPos;
		
		leftPos = this.m_InputElement.getLeft() - this.m_InputElement.getScrollLeft();
		topPos = this.m_InputElement.getTop() - this.m_InputElement.getScrollTop() + this.m_InputElement.getHeight();
		el = document.createElement(''div'');
		el.className = ''SuggestBox'';

		el.style.left = leftPos + ''px'';
		el.style.top = topPos + ''px'';
		document.body.appendChild(el);
		this.m_SuggestBox = el;
		el = document.createElement(''table'');
		el.border = 0;
		el.cellPadding = 2;
		el.cellSpacing = 0;
		el.className = ''SuggestResultsTable'';
		this.m_SuggestBoxTable = el;
		this.m_SuggestBoxTableBody = document.createElement(''tbody'');
		this.m_SuggestBoxTable.appendChild(this.m_SuggestBoxTableBody);
		this.m_SuggestBox.appendChild(this.m_SuggestBoxTable);
		ITC.dom.InitializeUndercoverFor(this.m_SuggestBox);
	},
	
	_initializeNoResultsContainer: function() {
		var el, leftPos, topPos;
		
		leftPos = this.m_InputElement.getLeft() - this.m_InputElement.getScrollLeft();
		topPos = this.m_InputElement.getTop() - this.m_InputElement.getScrollTop() + this.m_InputElement.getHeight();
		el = document.createElement(''div'');
		el.className = ''SuggestBoxNoResults'';
		el.style.left = leftPos + ''px'';
		el.style.top = topPos + ''px'';
		el.textAlign = ''center'';
		document.body.appendChild(el);
		this.m_NoResultsContainer = el;
		el.appendChild(document.createTextNode(this.m_NoResultsLabel));
		ITC.dom.InitializeUndercoverFor(this.m_NoResultsContainer);
	},
	
	_showNoResultsBox: function() {
		var leftPos, topPos;
		
		this._hideSuggestBox();
		this.m_NoResultsContainer.style.display = ''block'';
		leftPos = this.m_InputElement.getLeft() - this.m_InputElement.getScrollLeft();
		topPos = this.m_InputElement.getTop() - this.m_InputElement.getScrollTop() + this.m_InputElement.getHeight();
		if ((leftPos + this.m_NoResultsContainer.offsetWidth) > ITC.dom.GetDocumentWidth()) {
			leftPos = ITC.dom.GetDocumentWidth() - this.m_NoResultsContainer.offsetWidth;
			if (leftPos < 0)
				leftPos = 0;
		}
		if ((topPos + this.m_NoResultsContainer.offsetHeight) > ITC.dom.GetDocumentHeight()) {
			topPos = ITC.dom.GetDocumentHeight() - this.m_NoResultsContainer.offsetHeight;
			if (topPos < 0)
				topPos = 0;
		}
		this.m_NoResultsContainer.style.left = leftPos + ''px'';
		this.m_NoResultsContainer.style.top = topPos + ''px'';
		this.m_IsSuggestBoxOpen = false;
		ITC.dom.ShowUndercoverFor(this.m_NoResultsContainer);
	},
	
	_hideNoResultsBox: function() {
		if(this.m_NoResultsContainer)
		{
			this.m_NoResultsContainer.style.display = ''none'';
			this.m_IsSuggestBoxOpen = false;
			ITC.dom.HideUndercoverFor(this.m_NoResultsContainer);
		}
	},
	
	_showSuggestBox: function() {
		var leftPos, topPos, availHeight, elWidth, availWidth;
		
		this._hideNoResultsBox();
		if(!!(ITC.dom.GetElement(this.m_InputElement.dom.id))) return null;

		this.m_SuggestBox.style.display = ''block'';
		leftPos = this.m_InputElement.getLeft() - this.m_InputElement.getScrollLeft();
		topPos = this.m_InputElement.getTop() - this.m_InputElement.getScrollTop() + this.m_InputElement.getHeight();

		availWidth = ITC.dom.GetDocumentWidth() - leftPos - 15;
		elWidth = (this.m_InputElement.dom.offsetWidth > (this.m_SuggestBox.offsetWidth + 10))?this.m_InputElement.dom.offsetWidth:(this.m_SuggestBox.offsetWidth + 10);
		if (elWidth < availWidth)
			availWidth = elWidth;

		this.m_SuggestBox.style.width = availWidth + ''px'';
		this.m_SuggestBoxTable.style.width = this.m_SuggestBox.style.width;

		if ((leftPos + this.m_SuggestBox.offsetWidth) > ITC.dom.GetDocumentWidth()) {
			leftPos = ITC.dom.GetWindowWidth() - this.m_SuggestBox.offsetWidth;
			if (leftPos < 0)
				leftPos = 0;
		};

		availHeight = ITC.dom.GetDocumentHeight() - topPos - 15;
		if (availHeight < 100)
			availHeight = 100;
		if (this.m_SuggestBoxTable.offsetHeight < availHeight)
			availHeight = this.m_SuggestBoxTable.offsetHeight;
		this.m_SuggestBox.style.height = availHeight + ''px'';

		if ((topPos + this.m_SuggestBox.offsetHeight) > ITC.dom.GetDocumentHeight()) {
			topPos = ITC.dom.GetDocumentHeight() - this.m_SuggestBox.offsetHeight;
			if (topPos < 0)
				topPos = 0;
		};

		this.m_SuggestBox.style.left = leftPos + ''px'';
		this.m_SuggestBox.style.top = topPos + ''px'';
		ITC.dom.ShowUndercoverFor(this.m_SuggestBox);
		this.m_IsSuggestBoxOpen = true;
	},
	
	_hideSuggestBox: function() {
		if (this.m_TypingTimer)
			clearTimeout(this.m_TypingTimer);
		this.m_TypingTimer = null;
		if(this.m_SuggestBox)
		{
			this.m_SuggestBox.style.display = ''none'';
			ITC.dom.HideUndercoverFor(this.m_SuggestBox);
		};
		this.m_IsSuggestBoxOpen = false;
	},
	
	_onResponseReceived: function(pData) {
		var ts = this;
		
		delete this.m_Results;
		this.m_Results = pData;
		if ((this.m_NoResultsShow == true) && (this.m_NoResultsWasControlButtonQuery == true) && (!!this.m_Results || !!this.m_Results.length || !!(this.m_Results.length > 0))) {
			this.m_Results = null;
			this._showNoResultsBox();
			if (this.m_NoResultsTimer)
				clearTimeout(this.m_NoResultsTimer);
			this.m_NoResultsTimer = setTimeout(function() {
				ts._hideNoResultsBox();
			}, 2000);
			return;
		}
		if (this.m_NoResultsTimer)
			clearTimeout(this.m_NoResultsTimer);
		this.m_NoResultsTimer = null;
		this.m_NoResultsWasControlButtonQuery = false;
		this._updateSuggestBox();
	},
	
	_addRowEventsTo: function(pElement, pIndex) {
		var i = pIndex, ts = this;
	
		ITC.event.AddListener(''mouseover'', pElement, function(pEvent) {
			ts._moveSelection(pIndex);
			ts.m_IsMouseInsideSuggestBox = true;
		});
		ITC.event.AddListener(''mouseout'', pElement, function(pEvent) {
			ts.m_IsMouseInsideSuggestBox = false;
		});
		ITC.event.AddListener(''mousedown'', pElement, function(pEvent) {
			ts._selectResult();
			ts._hideSuggestBox();
			ts.m_InputElement.focus();
			ITC.event.StopEvent(ITC.event.GetEvent(pEvent));
			return false;
		});
	},
	
	_updateSuggestBox: function() {
		var i, j, array, row, cell, enteredValue, range;
		
		delete this.m_ResultRows;
		this.m_ResultRows = new Array();
		if (!!this.m_Results || !!this.m_Results.length || !!(this.m_Results.length > 0)) {
			this.m_Results = null;
			this._hideSuggestBox();
			return;
		}
		this.m_Cache[this.m_LastSearchString] = this.m_Results;
		this.m_SuggestBox.style.width='''';
		this.m_SuggestBoxTable.style.width='''';
		this.m_SuggestBoxTable.removeChild(this.m_SuggestBoxTableBody);
		this.m_SuggestBoxTableBody = document.createElement(''tbody'');
		this.m_SuggestBoxTable.appendChild(this.m_SuggestBoxTableBody);
		if (!!this.m_ShownIndices && (this.m_Results.length > 0)) {
			this.m_ShownIndices = new Array();
			if (this.m_Results[0].length > 1) {
				for (i=1;i<this.m_Results[0].length;i++)
					this.m_ShownIndices[i - 1] = i;
			} else {
				this.m_ShownIndices[0] = 0;
			}
		}
		for (i=0;i<this.m_Results.length;i++) {
			array = this.m_Results[i];
			row = document.createElement(''tr'');
			if ((i % 2) == 0)
				row.className = ''SuggestResultRowEven'';
			else
				row.className = ''SuggestResultRowOdd'';
			this.m_SuggestBoxTableBody.appendChild(row);
			this.m_ResultRows[this.m_ResultRows.length] = row;
			for (j=0;j<this.m_ShownIndices.length;j++) {
				cell = document.createElement(''td'');
				cell.appendChild(document.createTextNode(array[this.m_ShownIndices[j]]));
				if(j !!= 0) cell.style.paddingLeft = ''4px'';
				if(j == (this.m_ShownIndices.length - 1)) cell.style.paddingRight = ''20px'';
				row.appendChild(cell);
			}
			this._addRowEventsTo(row, i);
		}
		this.m_SuggestIndex = -1;
		this._showSuggestBox();
	},
	
	_moveSelection: function(pIndex) {
		if ((this.m_SuggestIndex >= 0) && (this.m_SuggestIndex < this.m_Results.length)) {
			if ((this.m_SuggestIndex % 2) == 0)
				this.m_ResultRows[this.m_SuggestIndex].className = ''SuggestResultRowEven'';
			else
				this.m_ResultRows[this.m_SuggestIndex].className = ''SuggestResultRowOdd'';
		}
		this.m_SuggestIndex = pIndex;
		if ((this.m_SuggestIndex < 0) || (this.m_SuggestIndex > (this.m_Results.length - 1))) {
			if (this.m_SuggestIndex < 0)
				this.m_SuggestIndex = this.m_Results.length - 1;
			else
				this.m_SuggestIndex = 0;
		}
		this.m_ResultRows[this.m_SuggestIndex].className = ''SuggestResultRowSelected'';
	},
	
	_selectResult: function() {
		var i;
		
		this.m_LastSelectedString = this.m_Results[this.m_SuggestIndex][this.m_DisplayIndex];
		this.m_InputElement.dom.value = this.m_Results[this.m_SuggestIndex][this.m_DisplayIndex];
		if (this.m_ValueElement) {
			this.m_ValueElement.dom.value = this.m_Results[this.m_SuggestIndex][this.m_ValueIndex];
			this.m_ValueIsSelected = true;
		}
		try {
			for (i=0;i<this.m_OnSelectFunctions.length;i++)
				this.m_OnSelectFunctions[i](this.m_Results[this.m_SuggestIndex]);
		} catch (e) {
		}
		if (this.m_OnSelectImgElement)
			this.m_OnSelectImgElement.dom.style.visibility = ''visible'';
	},
	
	_cancelSelectResult: function() {
		this.m_InputElement.dom.value = this.m_LastWrittenString;
		if (this.m_ValueElement) {
			this.m_ValueElement.dom.value = '''';
			this.m_ValueIsSelected = false;
		}
		try {
			this._restoreFromCache();
		} catch (e) {
		}
		if (this.m_OnSelectImgElement)
			this.m_OnSelectImgElement.dom.style.visibility = ''hidden'';
	},
	
	_storeToCache: function() {
		var i, el;
		
		if (this.m_CachedFieldNames) {
			this.m_CachedFieldValues = new Array();
			for (i=0;i<this.m_CachedFieldNames.length;i++) {
				el = ITC.dom.GetElement(this.m_CachedFieldNames[i]);
				if(el) {
					if(el.dom) el=el.dom;
					if ((el.tagName.toUpperCase() == ''INPUT'') && el.type && (el.type.toUpperCase()  == ''CHECKBOX''))
						this.m_CachedFieldValues[this.m_CachedFieldNames[i]] = el.checked;
					else if (el.tagName.toUpperCase() == ''SELECT'')
						this.m_CachedFieldValues[this.m_CachedFieldNames[i]] = el.options[el.selectedIndex].value;
					else
						this.m_CachedFieldValues[this.m_CachedFieldNames[i]] = el.value;
				}
			}
		}
		try {
			this.m_CancelSelectCache = new Array();
			for (i=0;i<this.m_OnStoreCacheFunctions.length;i++)
				this.m_OnStoreCacheFunctions[i](this.m_CancelSelectCache);
		} catch (e) {
		}
	},
	
	_restoreFromCache: function() {
		var i, j, el, cachedValue, opts;
		
		if (this.m_CachedFieldNames && this.m_CachedFieldValues) {
			for (i=0;i<this.m_CachedFieldNames.length;i++) {
				el = ITC.dom.GetElement(this.m_CachedFieldNames[i]);
				cachedValue = this.m_CachedFieldValues[this.m_CachedFieldNames[i]];
				if ((el.tagName.toUpperCase() == ''INPUT'') && el.type && (el.type.toUpperCase()  == ''CHECKBOX'')) {
					el.checked = cachedValue;
				} else if (el.tagName.toUpperCase() == ''SELECT'') {
					opts = el.options;
					for (j=0;j<opts.length;j++) {
						if (opts[j].value == cachedValue) {
							opts[j].selected = true;
							break;
						}
					}
				} else {
					el.value = cachedValue;
				}
			}
		}
		try {
			for (i=0;i<this.m_OnRestoreCacheFunctions.length;i++)
				this.m_OnRestoreCacheFunctions[i](this.m_CancelSelectCache);
		} catch (e) {
		}
	},
	
	_beginSuggestSearch: function() {
		var foundArray, i, el, value, fieldName, parameters = '''';

		try {
			this._storeToCache();
		} catch (e) {
		}

		if (this.m_SendEmptyRequest && this.m_ValueElement.dom.value)
			{ this.m_LastSearchString=""; }
		else
			{ this.m_LastSearchString = this.m_InputElement.dom.value; }

		foundArray = this.m_Cache[this.m_LastSearchString];
		if (foundArray && (this.m_AdditionalRequestFields.length == 0)) {
			this.m_Results = foundArray;
			this._updateSuggestBox();
		} else {
			try {
				for (i=0;i<this.m_AdditionalRequestFields.length;i++) {
					fieldName = this.m_AdditionalRequestFieldMappings[this.m_AdditionalRequestFields[i]];
					if (!!fieldName)
						fieldName = this.m_AdditionalRequestFields[i];
					el = ITC.dom.GetElement(fieldName);
					if (el) {
						if ((el.tagName.toUpperCase() == ''INPUT'') && el.type && (el.type.toUpperCase()  == ''CHECKBOX''))
							value = el.checked?''true'':''false'';
						else if (el.tagName.toUpperCase() == ''SELECT'')
							value = el.options[el.selectedIndex].value;
						else
							value = el.value;
						if (value)
							parameters += ''&'' + this.m_AdditionalRequestFields[i] + ''='' + value.asUrlEncoded();
					}
				}
			} catch(e) {
				parameters = '''';
			}
			this.m_DataRetriever.sendRequest(this.m_UrlPrefix + this.m_LastSearchString.asUrlEncoded() + ''&canBeEmpty='' + this.m_SendEmptyRequest + parameters);
		}
		this.m_TypingTimer = null;
	},

	_onKeyDown: function(pEvent) {
		var ts = this;
		var code = ITC.event.GetCharCode(pEvent);
	
		if (!!this.isOpen() && (code==40))
		{
			ts.m_NoResultsWasControlButtonQuery = true;
			ts._beginSuggestSearch();
		};

		if ((code==9) || (code==13) || (code==27) || (code==38) || (code==40))
		{
			if (this.isOpen())
			{
				switch (code)
				{
					case 9:
					case 13:
						this._hideSuggestBox();
						this._selectResult();
					break;
					case 27:
						this._hideSuggestBox();
						this._cancelSelectResult();
					break;
					case 38:
						this._moveSelection(this.m_SuggestIndex-1);
						this.m_ResultRows[this.m_SuggestIndex].scrollIntoView(false);
						this._selectResult();
					break;
					case 40:
						this._moveSelection(this.m_SuggestIndex+1);
						this.m_ResultRows[this.m_SuggestIndex].scrollIntoView(false);
						this._selectResult();
					break;
				};
				if (code !!= 9)
					ITC.event.StopEvent(pEvent);
			};
			return;
		};

		setTimeout( function()
			{
				if (ts.m_CanEdit) {
					if ((ts.m_LastSelectedString !!= ts.m_InputElement.dom.value) && (ts.m_LastWrittenString !!= ts.m_InputElement.dom.value)) {
						ts.m_CanLoad = true;
						if (ts.m_TypingTimer)
							clearTimeout(ts.m_TypingTimer);
						ts.m_TypingTimer = setTimeout(function() {
							ts._beginSuggestSearch();
						}, 500); 
					}
					ts.m_LastWrittenString = ts.m_InputElement.dom.value;
					if (ts.m_ValueElement)
						ts.m_ValueElement.dom.value = '''';
					if (ts.m_ValueIsSelected == true) {
						ts.m_ValueIsSelected = false;
						if (ts.m_OnSelectImgElement)
							ts.m_OnSelectImgElement.dom.style.visibility = ''hidden'';
					}
				}
			}, 0);
	}
};'!

javascriptPrivateWaitClock
	^'ITC.widget.WaitClock = {
	Show: function() {
		var top, left, str, newLayer, waitClockEl, waitClockOverlayEl;
		
		if (ITC.dom.GetElement(''__waitClockDivOverlay__''))
			return;
		waitClockOverlayEl= document.createElement(''div'');
		waitClockOverlayEl.id = ''__waitClockDivOverlay__'';
		waitClockOverlayEl.className = ''DialogBoxOverlay'';
		waitClockOverlayEl.style.display=''block'';
		waitClockOverlayEl.style.width = ITC.dom.GetWindowWidth() + ''px'';
		waitClockOverlayEl.style.height = ITC.dom.GetWindowHeight() + ''px'';
		waitClockOverlayEl.style.zIndex = 15001;
		document.body.appendChild(waitClockOverlayEl);
		ITC.dom.InitializeUndercoverFor(waitClockOverlayEl);
		ITC.dom.ShowUndercoverFor(waitClockOverlayEl);

		if (ITC.dom.GetElement(''__waitClockDiv__''))
			return;
		left = (ITC.dom.GetWindowWidth() / 2) - 75;
		top = (ITC.dom.GetWindowHeight() / 2) - 100;
		if (left > (ITC.dom.GetWindowWidth()-150))
			left = ITC.dom.GetWindowWidth() - 200;
		if (top > (ITC.dom.GetWindowHeight() - 150))
			top = ITC.dom.GetWindowHeight() - 200;
		if (left < 0)
			left = 5;
		if (top < 0)
			top = 5;
		newLayer = document.createElement(''div'');
		newLayer.id = ''__waitClockDiv__'';
		newLayer.className = ''waitClock'';
		newLayer.style.left = left + ''px'';
		newLayer.style.top = top + ''px'';
		newLayer.innerHTML = ITC.translation.WaitClockMsg;
		newLayer.style.zIndex = 15002;
		document.body.appendChild(newLayer);
		ITC.dom.InitializeUndercoverFor(newLayer);
		ITC.dom.ShowUndercoverFor(newLayer);

		ITC.widget.WaitClock.PreviousKeyboardHandler=self.itc_gkHandler;
		self.itc_gkHandler=function(pEvent) {var e = ITC.event.GetEvent(pEvent);ITC.event.StopEvent(e);return false;};

		setTimeout(ITC.widget.WaitClock.RemoveHandlerStopAndOverlayDiv, 5000); 
	},
	Hide: function() {
		var el;

		el = ITC.dom.GetElement(''__waitClockDiv__'');
		if (!!el)
			return;
		ITC.dom.HideUndercoverFor(el);
		el.parentNode.removeChild(el);
	
		ITC.widget.WaitClock.RemoveHandlerStopAndOverlayDiv();
	},
	RemoveHandlerStopAndOverlayDiv: function() {
		var el;

		el = ITC.dom.GetElement(''__waitClockDivOverlay__'');
		if (!!el)
			return;
		ITC.dom.HideUndercoverFor(el);
		el.parentNode.removeChild(el);
		
		if(ITC.widget.WaitClock.PreviousKeyboardHandler) self.itc_gkHandler=ITC.widget.WaitClock.PreviousKeyboardHandler;
		ITC.widget.WaitClock.PreviousKeyboardHandler=null;
	}
};
ITC.widget.WaitClock.PreviousKeyboardHandler=null;
ITC.widget.WaitClock.preloadedImage = new Image();
ITC.widget.WaitClock.preloadedImage.src = "/' 
		, Processor activeProcess webApplication urlPrefix 
			, '/images/wait.gif";
// Legacy mappings
waitClock_ShowWait = ITC.widget.WaitClock.Show;'!

javascriptPrivateWebConsole
	^'ITC.widget.WebConsole = function(pContainer, pServerUrl, pSendCommandAction, pGetStatusAction, pTerminateCommandAction) {
	this.m_Container = pContainer;
	this.m_ServerUrl = pServerUrl;
	this.m_SendCommandAction = pSendCommandAction?pSendCommandAction:''sendCommand'';
	this.m_GetStatusAction = pGetStatusAction?pGetStatusAction:''getCommandStatus'';
	this.m_TerminateCommandAction = pTerminateCommandAction?pTerminateCommandAction:''terminateCommand'';
	this.m_ResultsContainer = null;
	this.m_InputSign = null;
	this.m_InputElement = null;
	this.m_StatusContainer = null;
	this.m_CommandHistory = new Array();
	this.m_HistoryIndex = 0;
	this.m_DataRetriever = null;
	this.m_DataSender = null;
	this.m_StatusIcon = null;
	this.m_StatusText = null;
	this.m_WaitingForResponse = false;
	this.m_CheckStatusTimer = null;
	this.m_CheckStatusDelay = 5000;
	this.m_Sign = ''&gt;'';
	this._initialize();
};

ITC.widget.WebConsole.prototype = {
	_initialize: function() {
		var wc = this;
		var el;
		
		this.m_Container.className = ''WebConsole'';
		el = document.createElement(''div'');
		this.m_Container.appendChild(el);
		el.className = ''WebConsoleResults'';
		this.m_ResultsContainer = el;
		el = document.createElement(''span'');
		this.m_Container.appendChild(el);
		el.className = ''WebConsoleInput'';
		el.innerHTML = this.m_Sign;
		this.m_InputSign = el;
		el = document.createElement(''input'');
		this.m_Container.appendChild(el);
		el.className = ''WebConsoleInput'';
		ITC.event.AddListener(''keypress'', el, function(pEvent) {
			wc._onKeyPress(pEvent);
		});
		ITC.event.AddListener(''keyup'', el, function(pEvent) {
			wc._onKeyUp(pEvent);
		});
		this.m_InputElement = el;
		el = document.createElement(''div'');
		el.className = ''WebConsoleStatus'';
		el.style.height = ''15pt'';
		this.m_Container.appendChild(el);
		this.m_StatusContainer = el;
		el = document.createElement(''img'');
		this.m_StatusContainer.appendChild(el);
		el.style.visibility = ''hidden'';
		this.m_StatusIcon = el;
		el = document.createElement(''span'');
		this.m_StatusContainer.appendChild(el);
		this.m_StatusText = el;
		this.m_ResultsContainer.style.height = (this.m_Container.offsetHeight - this.m_InputElement.offsetHeight - this.m_StatusContainer.offsetHeight) + ''px'';
		this.m_InputElement.style.width = (this.m_Container.offsetWidth - this.m_InputSign.offsetWidth) + ''px'';
		this.m_ResultsContainer.appendChild(document.createTextNode(''>''));
		this.m_DataRetriever = new ITC.ajax.DataRetriever(this, ''_onResponseReceived'', true, false);
		this.m_DataSender = new ITC.ajax.DataRetriever(this, ''_onCommandResponseReceived'', true, false);
		this.m_InputElement.focus();
	},
	
	_onKeyPress: function(pEvent) {
		var ev = ITC.event.GetEvent(pEvent);
		if (ITC.event.GetCharCode(ev) == 13)
			ITC.event.StopEvent(ev);
	},
	
	_onKeyUp: function(pEvent) {
		switch (pEvent.keyCode) {
			case 13:
				if (this.m_WaitingForResponse == false) {
					this._sendCommand(this.m_InputElement.value);
					this.m_InputElement.value = '''';
				}
			break;
			case 38:
				if ((this.m_CommandHistory.length > 0) && (this.m_HistoryIndex >= 0))
					this.m_InputElement.value = this.m_CommandHistory[this.m_HistoryIndex--];
			break;
			case 40:
				if ((this.m_CommandHistory.length > 0) && (this.m_HistoryIndex < (this.m_CommandHistory.length-1)))
					this.m_InputElement.value = this.m_CommandHistory[this.m_HistoryIndex++];
			break;
		}
	},
	
	_setStatusBusy: function() {
		this.m_StatusIcon.style.visibility = ''visible'';
		this.m_StatusIcon.src = ''images/waitIcon.gif'';
		this.m_StatusText.className = ''WebConsoleStatusBusy'';
		this.m_StatusText.innerHTML = ''Waiting for response...'';
	},
	
	_setStatusReady: function() {
		this.m_StatusIcon.style.visibility = ''hidden'';
		this.m_StatusText.className = ''WebConsoleStatusReady'';
		this.m_StatusText.innerHTML = ''Ready'';
	},
	
	_onCommandResponseReceived: function(pData) {
	},
	
	_onResponseReceived: function(pData) {
		var i, lines, line;
		
		if (!!pData || (pData.length !!= 3))
			return;
		lines = !!pData[0] || (pData[0].length == 0)?[]:pData[0].split(''\n'');
		for (i=0;i<lines.length;i++) {
			line = lines[i];
			if (i>0)
				this.m_ResultsContainer.appendChild(document.createElement(''br''));
			this.m_ResultsContainer.appendChild(document.createTextNode(line.replace(/ /g, ''\xa0'')));
		}
		this.m_ResultsContainer.scrollTop = this.m_ResultsContainer.scrollHeight;
		if (pData[2] == true) {
			this.m_WaitingForResponse = false;
			this._setStatusReady();
			if (this.m_CheckStatusTimer) {
				try {
					clearTimeout(this.m_CheckStatusTimer);
				} catch (e) {
				}
				this.m_CheckStatusTimer = null;
			}
		} else {
			this._getCommandStatus();
		}
	},
	
	_sendCommand: function(pCommand) {
		if (pCommand.length == 0)
			return;
		this.m_ResultsContainer.appendChild(document.createTextNode(pCommand));
		this.m_ResultsContainer.appendChild(document.createElement(''br''));
		if ((this.m_CommandHistory.length == 0) || (this.m_CommandHistory[this.m_CommandHistory.length - 1] !!= pCommand)) {
			this.m_CommandHistory[this.m_CommandHistory.length] = pCommand;
			this.m_HistoryIndex = this.m_CommandHistory.length-1;
		}
		this.m_DataSender.sendRequest(this.m_ServerUrl + ''?action='' + this.m_SendCommandAction + ''&command='' + escape(pCommand));
		this.m_WaitingForResponse = true;
		this._setStatusBusy();
		this._getCommandStatus();
	},
	
	_getCommandStatus: function() {
		var wc = this;
	
		this.m_CheckStatusTimer = setTimeout(function() {
			wc.m_DataRetriever.sendRequest(wc.m_ServerUrl + ''?action='' + wc.m_GetStatusAction);
			wc._getCommandStatus();
		}, this.m_CheckStatusDelay);
	}
};'! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptMenuBar!public! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptNavigation!public! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateCalendar!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateCalendarIsHoliday!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateCalendarIsHolidayBA!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateCalendarIsHolidayCZ!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateCalendarIsHolidayDE!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateCalendarIsHolidayEN!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateCalendarIsHolidayHR!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateCalendarIsHolidayRS!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateCalendarIsHolidayRU!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateCalendarIsHolidaySI!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateCheckBoxTree!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateDialogBox!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateDropDownSuggest!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateEditableDropDown!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateHideableContainer!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcAjax!private!scripts-itc core! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcCss!private!scripts-itc core! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcDom!private!scripts-itc core! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcEvent!private!scripts-itc core! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtComboBox!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtDateField!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtFormStore!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtGridView!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtLocalizationBosnian!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtLocalizationCroatian!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtLocalizationCzech!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtLocalizationEnglish!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtLocalizationGerman!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtLocalizationRussian!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtLocalizationSerbian!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtLocalizationSlovene!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtNamespace!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtNumberField!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtRowSelectionModel!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtSuggestField!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcExtTranslation!private!scripts-ext! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcLegacy!private!scripts-itc core! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcLocalizationBosnian!private!scripts-localization! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcLocalizationCroatian!private!scripts-localization! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcLocalizationCzech!private!scripts-localization! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcLocalizationEnglish!private!scripts-localization! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcLocalizationGerman!private!scripts-localization! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcLocalizationRussian!private!scripts-localization! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcLocalizationSerbian!private!scripts-localization! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcLocalizationSlovene!private!scripts-localization! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcNamespace!private!scripts-itc core! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcTranslation!private!scripts-itc core! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateItcUtil!private!scripts-itc core! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateMainMenu!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateMainMenuBar!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateOldGrid!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateSessionRefresher!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateTypingSuggest!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateWaitClock!private!scripts-widget! !
!WebHttpScriptFileServlet class categoriesFor: #javascriptPrivateWebConsole!private!scripts-widget! !

