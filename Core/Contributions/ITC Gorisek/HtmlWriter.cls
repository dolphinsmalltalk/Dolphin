"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #HtmlWriter
	instanceVariableNames: 'htmlStream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlWriter guid: (GUID fromString: '{C271B651-DA17-4F0E-930D-3248ECF7BC1E}')!
HtmlWriter comment: ''!
!HtmlWriter categoriesForClass!Unclassified! !
!HtmlWriter methodsFor!

actionButton: idString label: labelString 
	(idString webAsActionString beginsWith: 'ajaxGet') 
		ifTrue: 
			[self 
				singleTag: 'input'
				attributes: #('class' 'type' 'value' 'onclick')
				values: (Array 
						with: 'button'
						with: 'button'
						with: labelString webTranslate
						with: (Processor activeProcess webTask urlPrefixForAction: idString))]
		ifFalse: 
			[self 
				singleTag: 'input'
				attributes: #('class' 'type' 'name' 'value')
				values: (Array 
						with: 'button'
						with: 'submit'
						with: 'BUTTON_' , idString webAsActionString
						with: labelString webTranslate)]!

actionButtonFlashing: action label: labelString 
	| formName |
	formName := Processor activeProcess webCoderDefaultFormName.
	htmlStream 
		nextPutAll: '<input class="button" type="submit" name="BUTTON_' , action webAsActionString 
				, '" value="' , labelString 
				, '">'.
	self 
		javascript: 'var s=0;
function blinker()
{
if(s==0){document.' , formName , '.BUTTON_' , action 
				, '.style.backgroundColor="#ffffff";s=1;setTimeout("blinker()",300);}
else{document.' , formName 
				, '.BUTTON_' , action 
				, '.style.backgroundColor="#ffff80";s=0;setTimeout("blinker()",500);}
}
blinker();'!

actionButtonWait: action label: labelString 
	(HtmlButton 
		label: labelString
		action: action
		id: nil)
		pleaseWaitNotice: true;
		generateOn: htmlStream!

addConvertJavascriptLinksFor: activeProcess 
	| activeProcessAttributes |
	activeProcessAttributes := activeProcess attributes.
	(#(#javascriptCommon #javascriptDataRetriever) 
		detect: [:each | (activeProcessAttributes at: each ifAbsent: []) = true]
		ifNone: []) isNil 
		ifFalse: [activeProcess webJavascriptLinksAdd: #javascriptItc].
	(#(#javascriptCalendar #javascriptWaitClock #javascriptHtmlEditor #javascriptMenu #javascriptMenuBar #javascriptCheckBoxTree #javascriptSearchNSuggest #javascriptEditableDropDownList #javascriptHideableContainer #javascriptWebConsole #javascriptDialogBox) 
		detect: [:each | (activeProcessAttributes at: each ifAbsent: []) = true]
		ifNone: []) isNil 
		ifFalse: [activeProcess webJavascriptLinksAdd: #javascriptItcWidget].
	(activeProcessAttributes at: #javascriptGrid ifAbsent: []) = true 
		ifTrue: [activeProcess webJavascriptLinksAdd: #javascriptOldGrid]!

addInlineCSS: cssString 
	htmlStream
		newLine;
		write: '<style type="text/css"><!!--
';
		nextPutAll: cssString;
		nextPutAll: '
-->
</style>'!

addJavascriptScriptsFor: activeProcessAttributes 
	(activeProcessAttributes at: #javascriptZipToCity ifAbsent: []) = true 
		ifTrue: [self javascript: self class javascriptZipToCity]!

background: fragment

	self background: fragment color: '#ffffff'.!

background: fragment color: backgroundColor
	htmlStream
		code: '<table cellpadding="5" cellspacing="0" border="0"';
		code: ' bgcolor="' , backgroundColor , '"';
		code: '><tr><td>';
		inc;
		code: fragment;
		dec;
		code: '</td></tr></table>'!

bar: content

	self bar: content side: nil.!

bar: content side: sideContent 
	self
		code: '<table class="bar" width="100%"><tr valign="middle"><td>';
		inc.
	content isNil ifTrue: [self code: '<small>&nbsp;</small>'] ifFalse: [self code: content].
	self
		dec;
		code: '</td>'.
	sideContent notNil 
		ifTrue: 
			[self
				code: '<td align="right">';
				inc.
			self
				code: sideContent;
				dec.
			self code: '</td>'].
	self code: '</tr></table>'!

bar: content sideActions: sideActions labels: sideActionLabels 
	"Show bar, with actions and their labels. If label starts with * a flashing button will be shown.
	Labels are automatically translated."

	| buttons flashingButton waitButton label |
	sideActions size > 0 
		ifTrue: 
			[buttons := 
					[1 to: sideActions size
						do: 
							[:i | 
							i > 1 ifTrue: [self code: '&nbsp;'].
							label := sideActionLabels at: i.
							(flashingButton := label notEmpty and: [label first = $*]) 
								ifTrue: [label := label copyFrom: 2 to: label size].
							(waitButton := label notEmpty and: [label first = $#]) 
								ifTrue: [label := label copyFrom: 2 to: label size].
							flashingButton 
								ifTrue: [self actionButtonFlashing: (sideActions at: i) label: label webTranslate]
								ifFalse: 
									[waitButton 
										ifTrue: [self actionButtonWait: (sideActions at: i) label: label webTranslate]
										ifFalse: [self actionButton: (sideActions at: i) label: label webTranslate]]]]].
	self bar: content side: buttons!

barActions: barActions labels: barActionLabels side: sideContent
	| buttons |
	barActions size > 0 
		ifTrue: 
			[buttons := 
					[1 to: barActions size
						do: 
							[:i | 
							i > 1 ifTrue: [self code: '&nbsp;'].
							self actionButton: (barActions at: i) label: (barActionLabels at: i)]]].
	self bar: buttons side: sideContent!

barActions: barActions labels: barActionLabels sideActions: sideActions labels: sideActionLabels 
	| buttons label |
	barActions size > 0 
		ifTrue: 
			[buttons := 
					[1 to: barActions size
						do: 
							[:i | 
							i > 1 ifTrue: [self code: '&nbsp;'].
							label := barActionLabels at: i.
							(label isNilOrEmpty not and: [(label at: 1) = $#]) 
								ifTrue: 
									[self actionButtonWait: (barActions at: i)
										label: (label copyFrom: 2 to: label size) webTranslate]
								ifFalse: [self actionButton: (barActions at: i) label: label webTranslate]]]].
	self 
		bar: buttons
		sideActions: sideActions
		labels: sideActionLabels!

barActions: barActions labels: barActionLabels sideActions: sideActions labels: sideActionLabels showFlags: flagsArray 
	| leftActions leftLabels rightActions rightLabels |
	leftActions := OrderedCollection new.
	leftLabels := OrderedCollection new.
	rightActions := OrderedCollection new.
	rightLabels := OrderedCollection new.
	flagsArray doWithIndex: 
			[:each :i | 
			| index |
			i > barActions size 
				ifFalse: 
					[index := i.
					each 
						ifTrue: 
							[leftActions add: (barActions at: index).
							leftLabels add: (barActionLabels at: index)]]
				ifTrue: 
					[index := i - barActions size.
					each 
						ifTrue: 
							[rightActions add: (sideActions at: index).
							rightLabels add: (sideActionLabels at: index)]]].
	self 
		barActions: leftActions
		labels: leftLabels
		sideActions: rightActions
		labels: rightLabels!

bold: fragment
	self tag: 'b' content: fragment!

border: fragment

	self border: fragment width: 1.!

border: fragment width: width
	| borderCode |
	borderCode := width isNil | (width = 0) 
				ifTrue: [' border="0"']
				ifFalse: [' border="' , width printString , '"'].
	htmlStream
		code: '<table cellpadding="5" cellspacing="0"';
		code: borderCode;
		code: '><tr><td>';
		inc;
		code: fragment;
		dec;
		code: '</td></tr></table>'!

break
	self singleTag: 'br'!

center: fragment
	self 
		tag: 'p'
		attributes: #('align')
		values: (Array with: 'center')
		content: fragment!

code: code
	htmlStream code: code!

cr
	htmlStream newLine!

dec
	htmlStream dec!

div: content 
	htmlStream
		nextPutAll: '<div>';
		code: content;
		nextPutAll: '</div>'!

div: elementName content: content 
	htmlStream write: '<div '.
	elementName isNil 
		ifFalse: 
			[htmlStream
				nextPutAll: 'id="';
				nextPutAll: elementName].
	htmlStream
		nextPutAll: '">';
		code: content;
		nextPutAll: '</div>'!

div: elementName style: cssStyle content: content 
	htmlStream write: '<div '.
	elementName isNil 
		ifFalse: 
			[htmlStream
				nextPutAll: 'id="';
				nextPutAll: elementName;
				nextPutAll: '" '].
	htmlStream
		nextPutAll: 'style="';
		nextPutAll: cssStyle;
		nextPutAll: '">';
		code: content;
		nextPutAll: '</div>'!

fileUploadForm: actionURL content: fragment 
	htmlStream
		code: '<form name="file_form" enctype="multipart/form-data" action="';
		code: actionURL;
		code: '" method="post">';
		code: fragment;
		code: '</form>'!

fileUploadForm: actionURL name: formName content: fragment 
	htmlStream
		code: '<form name="' , formName , '" enctype="multipart/form-data" action="';
		code: actionURL;
		code: '" method="post">';
		code: fragment;
		code: '</form>'!

form: actionURL content: fragment 
	htmlStream
		write: '<form name="form" action="';
		nextPutAll: actionURL;
		nextPutAll: '" method="post">';
		code: fragment;
		nextPutAll: '</form>'!

form: actionURL content: fragment onSubmit: onSubmit 
	htmlStream
		write: '<form name="form" action="';
		nextPutAll: actionURL.
	onSubmit isNilOrEmpty 
		ifFalse: 
			[htmlStream
				nextPutAll: '" onsubmit="';
				nextPutAll: onSubmit].
	htmlStream
		nextPutAll: '" method="post">';
		code: fragment;
		nextPutAll: '</form>'!

form: actionURL method: method content: fragment 
	htmlStream
		write: '<form name="form" action="';
		nextPutAll: actionURL;
		nextPutAll: '" method="';
		nextPutAll: method;
		nextPutAll: '">';
		code: fragment;
		nextPutAll: '</form>'!

form: actionURL name: formName content: fragment 
	htmlStream
		write: '<form name="';
		nextPutAll: formName;
		nextPutAll: '" action="';
		nextPutAll: actionURL;
		nextPutAll: '" method="post">'.
	Processor activeProcess webCoderDefaultFormName: formName.
	[htmlStream code: fragment] ensure: 
			[Processor activeProcess webCoderDefaultFormName: nil.
			htmlStream nextPutAll: '</form>']!

form: actionURL name: formName id: formId content: fragment 
	htmlStream
		write: '<form name="';
		nextPutAll: formName;
		nextPutAll: '" id="';
		nextPutAll: formId;
		nextPutAll: '" action="';
		nextPutAll: actionURL;
		nextPutAll: '" method="post">'.
	Processor activeProcess webCoderDefaultFormName: formName.
	[htmlStream code: fragment] ensure: 
			[Processor activeProcess webCoderDefaultFormName: nil.
			htmlStream nextPutAll: '</form>']!

form: actionURL name: formName target: target content: fragment 
	htmlStream
		write: '<form name="';
		nextPutAll: formName;
		nextPutAll: '" action="';
		nextPutAll: actionURL;
		nextPutAll: '" target="';
		nextPutAll: target;
		nextPutAll: '" method="post">'.
	Processor activeProcess webCoderDefaultFormName: formName.
	[htmlStream code: fragment] ensure: 
			[Processor activeProcess webCoderDefaultFormName: nil.
			htmlStream nextPutAll: '</form>']!

h1: header
	self tag: 'h1' content: header!

h2: header
	self tag: 'h2' content: header!

h3: header
	self tag: 'h3' content: header!

h4: header 
	self tag: 'h4' content: header!

hiddenField: idString value: valueString
	self 
		singleTag: 'input'
		attributes: #('type' 'name' 'value')
		values: (Array 
				with: 'hidden'
				with: idString
				with: valueString)!

horizontalRule
	self singleTag: 'hr'!

htmlStream
	^htmlStream!

htmlStream: aHtmlStream
	htmlStream := aHtmlStream!

image: sourceFileName width: width height: height
	self 
		singleTag: 'img'
		attributes: #('src' 'width' 'height')
		values: (Array 
				with: sourceFileName
				with: width
				with: height)!

image: sourceFileName width: width height: height border: border 
	self 
		singleTag: 'img'
		attributes: #('src' 'width' 'height' 'border')
		values: (Array 
				with: sourceFileName
				with: width
				with: height
				with: border)!

inc
	htmlStream inc!

initializeHtmlStream
	htmlStream := HtmlStream new: (WriteStream on: (String new: 256)) compact: true!

italic: fragment
	self tag: 'i' content: fragment!

javascript: fragment 
	fragment isNilOrEmpty ifTrue: [^self].
	Processor activeProcess webProcessingAjaxRequest 
		ifTrue: 
			[fragment isBlockClosure 
				ifTrue: 
					[self error: 'Block closures are not allowed. Please use the equivalent method on coder object.']
				ifFalse: [Processor activeProcess webAjaxRequestJavascriptCollector nextPutAll: fragment]]
		ifFalse: 
			[htmlStream
				nextPutAll: HtmlElement javascriptBeginString;
				code: fragment;
				nextPutAll: HtmlElement javascriptEndString]!

link: urlString content: fragment
	self 
		tag: 'a'
		attributes: #('href')
		values: (Array with: urlString)
		content: fragment!

link: urlString content: fragment targetFrame: frameName
	self 
		tag: 'a'
		attributes: #('href' 'target')
		values: (Array with: urlString with: frameName)
		content: fragment!

link: urlString onClick: onClick title: title content: fragment 
	self 
		tag: 'a'
		attributes: #('href' 'onclick' 'title')
		values: (Array 
				with: urlString webHtmlEncodedForForm
				with: onClick webHtmlEncodedForForm
				with: title webTranslate webHtmlEncodedForForm)
		content: fragment!

link: urlString target: targetString content: fragment
	self 
		tag: 'a'
		attributes: #('href')
		values: (Array with: urlString)
		target: targetString
		content: fragment!

linkInNewWindow: urlString content: fragment 
	self 
		link: urlString
		content: fragment
		targetFrame: '_blank'!

linkInNewWindow: urlString content: fragment width: width height: height
	| winStats |
	winStats := 'scrollbars=yes,resizable=1'.
	width notNil ifTrue: [winStats := winStats , ',width=' , width printString].
	height notNil ifTrue: [winStats := winStats , ',height=' , height printString].
	self 
		tag: 'a'
		attributes: #('href' 'onclick')
		values: (Array with: 'javascript:void(0)'
				with: 'window.open(''' , urlString , ''', '''', ''' , winStats , ''')')
		content: fragment!

page: titleString keywords: keywordsText description: descriptionText refresh: refresh charSet: charSet style: style styleLinks: styleLinks javascriptLinks: javascriptLinks baseUrl: baseUrl baseTarget: baseTarget bgColor: bgColor margin: margin focusField: focusField favoritesIcon: favoritesIconUrl onLoad: onLoad body: body 
	| keyHandlerScript activeProcessAttributes jsLinks cssLinks activeProcess str |
	true 
		ifFalse: 
			[htmlStream 
				nextPutAll: '<?xml version="1.0" encoding="' 
						, (charSet isNil ifFalse: [charSet] ifTrue: ['iso-8859-2']) 
							, '"?><!!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">'].
	htmlStream 
		nextPutAll: '<!!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'.
	htmlStream
		nextPutAll: '<html><head>';
		inc.
	titleString notNil 
		ifTrue: 
			[htmlStream newLine.
			self tag: 'title' content: titleString].
	htmlStream
		newLine;
		write: '<meta http-equiv="imagetoolbar" content="no"/>'.
	refresh isNil 
		ifFalse: 
			[htmlStream
				newLine;
				write: '<meta http-equiv="refresh" content="' , refresh , '"/>'].
	favoritesIconUrl isNil 
		ifFalse: 
			[htmlStream
				newLine;
				write: '<link rel="shortcut icon" href="' , favoritesIconUrl , '" />'].
	keywordsText notNil 
		ifTrue: 
			[htmlStream
				newLine;
				write: '<meta name="keywords" content="';
				text: keywordsText;
				nextPutAll: '"/>'].
	descriptionText notNil 
		ifTrue: 
			[htmlStream
				newLine;
				write: '<meta name="description" content="';
				text: descriptionText;
				nextPutAll: '"/>'].
	charSet notNil 
		ifTrue: 
			[htmlStream
				newLine;
				write: '<meta http-equiv="Content-Type" content="text/html; charset=';
				nextPutAll: charSet;
				nextPutAll: '"/>'].
	(baseUrl isNil and: [baseTarget isNil]) 
		ifFalse: 
			[htmlStream
				newLine;
				write: '<base '.
			baseUrl isNil ifFalse: [htmlStream nextPutAll: 'href="' , baseUrl , '"'].
			baseTarget isNil ifFalse: [htmlStream nextPutAll: 'target="' , baseTarget , '"'].
			htmlStream nextPutAll: '/>'].
	activeProcess := Processor activeProcess.
	activeProcessAttributes := activeProcess attributes.
	"---"
	self addConvertJavascriptLinksFor: activeProcess.
	style isNilOrEmpty ifFalse: [self addInlineCSS: style].
	cssLinks := OrderedCollection new.
	styleLinks isNilOrEmpty 
		ifFalse: 
			[styleLinks isString ifTrue: [cssLinks add: styleLinks] ifFalse: [cssLinks addAll: styleLinks]].
	activeProcess webStyleSheetLinksOrNil isNil 
		ifFalse: [cssLinks addAll: activeProcess webStyleSheetLinks].
	cssLinks isNilOrEmpty 
		ifFalse: 
			[cssLinks 
				do: [:eachUrl | htmlStream write: '<link rel="stylesheet" type="text/css" href="' , eachUrl , '"/>']].
	"---"
	jsLinks := OrderedCollection new.
	javascriptLinks isNilOrEmpty ifFalse: [jsLinks addAll: javascriptLinks].
	(activeProcessAttributes at: #javascriptHtmlEditor ifAbsent: []) == true 
		ifTrue: 
			[jsLinks add: '/' , activeProcess webApplication urlPrefix , '/fckeditor/fckeditor.js?itcLang=' 
						, activeProcess language].
	activeProcess webJavascriptLinksOrNil isNil 
		ifFalse: [jsLinks addAll: activeProcess webJavascriptLinks].
	jsLinks isNilOrEmpty 
		ifFalse: 
			[jsLinks do: 
					[:eachUrl | 
					htmlStream 
						write: '<script type="text/javascript" language="JavaScript" src="' , eachUrl , '"></script>']].
	"---"
	htmlStream dec.
	htmlStream write: '</head><body'.
	bgColor notNil 
		ifTrue: 
			[htmlStream
				write: ' bgcolor="';
				nextPutAll: bgColor;
				nextPut: $"].
	(activeProcessAttributes at: #addNoOuterDivForContent ifAbsent: []) == true 
		ifTrue: 
			[htmlStream
				nextPutAll: ' style="';
				nextPutAll: (self pageBodyMarginStyleStringFor: margin);
				nextPut: $"]
		ifFalse: [htmlStream nextPutAll: ' style="margin:0px;padding:0px;"'].
	(str := Processor activeProcess webTask) isNil 
		ifTrue: [(str := self webSession) isNil ifFalse: [str := str defaultTask]].
	(str notNil and: [str respondsTo: #taskURLPrefix]) ifTrue: [str := str taskURLPrefix].
	(str notNil or: [focusField notNil or: [onLoad notNil]]) 
		ifTrue: 
			[htmlStream nextPutAll: ' onload="'.
			str isNil 
				ifFalse: 
					[str := 'try{ITC.widget.SessionRefresher.getSingleton(''' , str , ''', ' 
								, Processor activeProcess webApplication defaultExpirationTime printString , ')'.
					htmlStream
						nextPutAll: str;
						nextPutAll: '.setSleepTimer()}catch(ex){};'].
			focusField isNil 
				ifFalse: 
					[htmlStream
						nextPutAll: 'document.form.';
						nextPutAll: focusField;
						nextPutAll: '.focus();'].
			onLoad isNil ifFalse: [htmlStream nextPutAll: onLoad].
			htmlStream nextPut: $"].
	(str notNil or: [HtmlPage useGlobalKeyboardHandler]) 
		ifTrue: 
			[htmlStream
				nextPutAll: ' ';
				nextPutAll: ((self webRequest notNil and: [self webRequest isOpera]) 
							ifTrue: ['onkeypress']
							ifFalse: ['onkeydown']);
				nextPutAll: '="'.
			str isNil 
				ifFalse: 
					[htmlStream
						nextPutAll: str;
						nextPutAll: '.setLastKeyEventTime()}catch(ex){};'].
			HtmlPage useGlobalKeyboardHandler 
				ifTrue: 
					["this is only added if keyboard handlers are being used"
					htmlStream nextPutAll: 'if(self.itc_gkHandler){return itc_gkHandler(event);}else{return true;}'].
			htmlStream nextPut: $"].
	htmlStream nextPut: $>.
	self addJavascriptScriptsFor: activeProcessAttributes.
	"If key down event is not used don't add keyboard script."
	HtmlPage useGlobalKeyboardHandler 
		ifTrue: 
			[(keyHandlerScript := HtmlPage getKeyboardHandlingScriptForTheCurrentPageOrRequest) isNilOrEmpty 
				ifFalse: [self javascript: 'self.itc_gkHandler=function(ev)
{' , keyHandlerScript , '};
']].
	"---"
	(activeProcessAttributes at: #addNoOuterDivForContent ifAbsent: []) == true 
		ifFalse: 
			[(activeProcessAttributes at: #addNoScrollbarsDiv ifAbsent: []) == true 
				ifFalse: 
					[htmlStream nextPutAll: '<div style="width:100%;height:100%;overflow:auto;position:relative;">'].
			htmlStream
				nextPutAll: '<div style="';
				nextPutAll: (self pageBodyMarginStyleStringFor: margin);
				nextPutAll: '" id="' , self class topEnclosingContentContainerId , '">';
				code: body;
				nextPutAll: '</div>'.
			(activeProcessAttributes at: #addNoScrollbarsDiv ifAbsent: []) == true 
				ifFalse: [htmlStream nextPutAll: '</div>']]
		ifTrue: 
			[(activeProcessAttributes at: #addNoScrollbarsDiv ifAbsent: []) == true 
				ifTrue: 
					[htmlStream
						nextPutAll: '<div style="width:100%;height:100%;overflow:hidden;position:relative;" id="' 
									, self class topEnclosingContentContainerId , '">';
						code: body;
						nextPutAll: '</div>']
				ifFalse: [htmlStream code: body]].
	focusField isNil ifTrue: [self javascript: 'window.focus();'].
	htmlStream write: '</body></html>'!

pageBodyMarginStyleStringFor: margin 
	| str |
	self webRequest isInternetExplorer ifTrue: [^'margin:0px;'].
	^(margin isNil or: [margin = 0]) 
		ifTrue: ['padding:0px;margin:0px;']
		ifFalse: 
			[str := margin printString.
			'padding-top:' , str , 'px;padding-left:' , str , 'px;padding-right:' , str , 'px;margin:0px;']!

paragraph: content
	self tag: 'p' content: content!

pixel
	self pixelWidth: 1 height: 1!

pixelWidth: width height: height 
	width = 1 
		ifTrue: [htmlStream nextPutAll: '<img width="1" height="' , height asWebString , '"/>']
		ifFalse: 
			[height = 1 
				ifTrue: [htmlStream nextPutAll: '<img width="' , width asWebString , '" height="1"/>']
				ifFalse: 
					[htmlStream 
						nextPutAll: '<img src="images/pixel.gif" width="' , width asWebString , '" height="' 
								, height asWebString , '" border="0"/>']]!

rectangleWidth: width height: height 
	htmlStream 
		nextPutAll: '<img src="images/pixel.gif" width="' , width asWebString , '" height="' 
				, height asWebString , '" border="1" alt=""/>'!

singleTag: elementName 
	self 
		singleTag: elementName
		attributes: #()
		values: #()!

singleTag: elementName attributes: attributes values: values 
	| value |
	htmlStream write: '<' , elementName.
	1 to: attributes size
		do: 
			[:i | 
			(value := values at: i) notNil 
				ifTrue: 
					[value isString ifFalse: [value := value printString].
					htmlStream
						nextPutAll: ' ';
						nextPutAll: (attributes at: i);
						nextPutAll: '="';
						nextPutAll: value;
						nextPutAll: '"']].
	htmlStream nextPutAll: '/>'!

space

	self code: '&nbsp;'.
!

spaces: anInteger

	anInteger timesRepeat: [self code: '&nbsp;'].!

span: elementName content: content 
	htmlStream write: '<span '.
	elementName isNil 
		ifFalse: 
			[htmlStream
				nextPutAll: 'id="';
				nextPutAll: elementName].
	htmlStream
		nextPutAll: '">';
		code: content;
		nextPutAll: '</span>'!

tag: elementName attributes: attributes values: values content: content
	" Characters in values are not converted!! "

	| value |
	htmlStream
		code: '<';
		code: elementName.
	1 to: attributes size
		do: 
			[:i | 
			(value := values at: i) notNil 
				ifTrue: 
					[value isString ifFalse: [value := value printString].
					htmlStream
						code: ' ';
						code: (attributes at: i);
						code: '="';
						code: value;
						code: '"']].
	htmlStream
		code: '>';
		code: content;
		code: '</';
		code: elementName;
		code: '>'!

tag: elementName attributes: attributes values: values target: target content: content
	" Characters in values are not converted!! "

	| value |
	htmlStream
		code: '<';
		code: elementName.
	1 to: attributes size
		do: 
			[:i | 
			(value := values at: i) notNil 
				ifTrue: 
					[value isString ifFalse: [value := value printString].
					htmlStream
						code: ' ';
						code: (attributes at: i);
						code: '="';
						code: value;
						code: '"']].
	htmlStream
		code: ' target=';
		code: target;
		code: '>';
		code: content;
		code: '</';
		code: elementName;
		code: '>'!

tag: elementName content: content
	self 
		tag: elementName
		attributes: #()
		values: #()
		content: content!

text: text
	htmlStream text: text!

writeOn: aHtmlStream 
	aHtmlStream code: htmlStream contents! !
!HtmlWriter categoriesFor: #actionButton:label:!public! !
!HtmlWriter categoriesFor: #actionButtonFlashing:label:!public! !
!HtmlWriter categoriesFor: #actionButtonWait:label:!public! !
!HtmlWriter categoriesFor: #addConvertJavascriptLinksFor:!generating page!private! !
!HtmlWriter categoriesFor: #addInlineCSS:!generating page!private! !
!HtmlWriter categoriesFor: #addJavascriptScriptsFor:!generating page!private! !
!HtmlWriter categoriesFor: #background:!public! !
!HtmlWriter categoriesFor: #background:color:!public! !
!HtmlWriter categoriesFor: #bar:!public! !
!HtmlWriter categoriesFor: #bar:side:!public! !
!HtmlWriter categoriesFor: #bar:sideActions:labels:!public! !
!HtmlWriter categoriesFor: #barActions:labels:side:!public! !
!HtmlWriter categoriesFor: #barActions:labels:sideActions:labels:!public! !
!HtmlWriter categoriesFor: #barActions:labels:sideActions:labels:showFlags:!public! !
!HtmlWriter categoriesFor: #bold:!public! !
!HtmlWriter categoriesFor: #border:!public! !
!HtmlWriter categoriesFor: #border:width:!public! !
!HtmlWriter categoriesFor: #break!public! !
!HtmlWriter categoriesFor: #center:!public! !
!HtmlWriter categoriesFor: #code:!public! !
!HtmlWriter categoriesFor: #cr!public! !
!HtmlWriter categoriesFor: #dec!public! !
!HtmlWriter categoriesFor: #div:!public! !
!HtmlWriter categoriesFor: #div:content:!public! !
!HtmlWriter categoriesFor: #div:style:content:!public! !
!HtmlWriter categoriesFor: #fileUploadForm:content:!public! !
!HtmlWriter categoriesFor: #fileUploadForm:name:content:!public! !
!HtmlWriter categoriesFor: #form:content:!public! !
!HtmlWriter categoriesFor: #form:content:onSubmit:!public! !
!HtmlWriter categoriesFor: #form:method:content:!public! !
!HtmlWriter categoriesFor: #form:name:content:!public! !
!HtmlWriter categoriesFor: #form:name:id:content:!public! !
!HtmlWriter categoriesFor: #form:name:target:content:!public! !
!HtmlWriter categoriesFor: #h1:!public! !
!HtmlWriter categoriesFor: #h2:!public! !
!HtmlWriter categoriesFor: #h3:!public! !
!HtmlWriter categoriesFor: #h4:!public! !
!HtmlWriter categoriesFor: #hiddenField:value:!public! !
!HtmlWriter categoriesFor: #horizontalRule!public! !
!HtmlWriter categoriesFor: #htmlStream!public! !
!HtmlWriter categoriesFor: #htmlStream:!public! !
!HtmlWriter categoriesFor: #image:width:height:!public! !
!HtmlWriter categoriesFor: #image:width:height:border:!public! !
!HtmlWriter categoriesFor: #inc!public! !
!HtmlWriter categoriesFor: #initializeHtmlStream!public! !
!HtmlWriter categoriesFor: #italic:!public! !
!HtmlWriter categoriesFor: #javascript:!public! !
!HtmlWriter categoriesFor: #link:content:!public! !
!HtmlWriter categoriesFor: #link:content:targetFrame:!public! !
!HtmlWriter categoriesFor: #link:onClick:title:content:!public! !
!HtmlWriter categoriesFor: #link:target:content:!public! !
!HtmlWriter categoriesFor: #linkInNewWindow:content:!public! !
!HtmlWriter categoriesFor: #linkInNewWindow:content:width:height:!public! !
!HtmlWriter categoriesFor: #page:keywords:description:refresh:charSet:style:styleLinks:javascriptLinks:baseUrl:baseTarget:bgColor:margin:focusField:favoritesIcon:onLoad:body:!generating page!public! !
!HtmlWriter categoriesFor: #pageBodyMarginStyleStringFor:!generating page!public! !
!HtmlWriter categoriesFor: #paragraph:!public! !
!HtmlWriter categoriesFor: #pixel!public! !
!HtmlWriter categoriesFor: #pixelWidth:height:!public! !
!HtmlWriter categoriesFor: #rectangleWidth:height:!public! !
!HtmlWriter categoriesFor: #singleTag:!public! !
!HtmlWriter categoriesFor: #singleTag:attributes:values:!public! !
!HtmlWriter categoriesFor: #space!public! !
!HtmlWriter categoriesFor: #spaces:!public! !
!HtmlWriter categoriesFor: #span:content:!public! !
!HtmlWriter categoriesFor: #tag:attributes:values:content:!public! !
!HtmlWriter categoriesFor: #tag:attributes:values:target:content:!public! !
!HtmlWriter categoriesFor: #tag:content:!public! !
!HtmlWriter categoriesFor: #text:!public! !
!HtmlWriter categoriesFor: #writeOn:!public! !

!HtmlWriter class methodsFor!

javascriptZipToCity
	| application postneStevilke result |
	application := Processor activeProcess webApplication.
	postneStevilke := (application notNil and: [application respondsTo: #postneStevilke]) 
				ifFalse: [#()]
				ifTrue: [application postneStevilke].
	result := WriteStream on: String new.
	result nextPutAll: 'function cityFromZipCode(zipCode){switch(zipCode){
'.
	postneStevilke do: 
			[:eachAssociation | 
			result
				nextPutAll: 'case "';
				nextPutAll: eachAssociation key;
				nextPutAll: '":return "';
				nextPutAll: eachAssociation value;
				nextPutAll: '";
'].
	result nextPutAll: 'default: break;}}'.
	^result contents!

new
	^super new initializeHtmlStream!

on: htmlStream
	^super new htmlStream: htmlStream!

topEnclosingContentContainerId
	^'__ItcTopEnclosingContentContainer__'! !
!HtmlWriter class categoriesFor: #javascriptZipToCity!public!scripts! !
!HtmlWriter class categoriesFor: #new!public! !
!HtmlWriter class categoriesFor: #on:!public! !
!HtmlWriter class categoriesFor: #topEnclosingContentContainerId!private! !

