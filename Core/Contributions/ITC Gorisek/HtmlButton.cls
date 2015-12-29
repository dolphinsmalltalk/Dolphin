"Filed out from Dolphin Smalltalk X6.1"!

HtmlInputField subclass: #HtmlButton
	instanceVariableNames: 'backToHistory flashingLabel buttonType pleaseWaitNotice'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlButton guid: (GUID fromString: '{961FD15C-A763-4F5D-B8EB-B4394CC6A629}')!
HtmlButton comment: ''!
!HtmlButton categoriesForClass!Unclassified! !
!HtmlButton methodsFor!

backToHistory: anInteger 
	backToHistory := anInteger!

buttonType
	^buttonType!

buttonType: aString 
	buttonType := aString!

flashingLabel: aBoolean 
	flashingLabel := aBoolean!

generateOn: aStream 
	aStream nextPutAll: '<input class="button" type="'.
	buttonType isNil 
		ifFalse: 
			[aStream
				nextPutAll: buttonType;
				nextPut: $"]
		ifTrue: 
			[onClick isNil 
				ifTrue: 
					[backToHistory notNil 
						ifTrue: [aStream nextPutAll: 'button" onclick="history.go(' , backToHistory printString , ')" ']
						ifFalse: 
							[Processor activeProcess webCoderIsGeneratingAjaxForm 
								ifFalse: [aStream nextPutAll: 'submit"']
								ifTrue: 
									["default POST target for ajax forms is a hidden IFRAME so change form target before submitting on regular buttons"
									((name copyFrom: 8) beginsWith: 'ajaxPost') 
										ifTrue: 
											[aStream
												nextPutAll: 'button"';
												nextPutAll: ' onClick="' 
															, (pleaseWaitNotice = true ifTrue: ['waitClock_ShowWait(this);'] ifFalse: ['']) 
																, 'ajaxPostRequestForAction(this,' , (name copyFrom: 8) asJavascriptValue 
															, ')"']
										ifFalse: 
											[aStream
												nextPutAll: 'button" onclick="';
												nextPutAll: (pleaseWaitNotice = true ifTrue: ['waitClock_ShowWait(this);'] ifFalse: ['']);
												nextPutAll: 'document.';
												nextPutAll: Processor activeProcess webCoderDefaultFormName;
												nextPutAll: '.target=''_self'';document.';
												nextPutAll: Processor activeProcess webCoderDefaultFormName.
											(name beginsWith: 'BUTTON_') 
												ifTrue: 
													[aStream
														nextPutAll: '._apa.value=' , (name copyFrom: 8) asJavascriptValue;
														nextPutAll: ';document.';
														nextPutAll: Processor activeProcess webCoderDefaultFormName].
											aStream nextPutAll: '.submit();"']]]]
				ifFalse: [aStream nextPutAll: 'button"']].
	width isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' width="';
				nextPutAll: width;
				nextPutAll: '"'].
	accessKey isNil ifFalse: [aStream nextPutAll: ' accesskey="' , accessKey , '"'].
	pleaseWaitNotice = true 
		ifTrue: [onClick := 'waitClock_ShowWait(this)' add: onClick withDelimiter: ';'].
	onClick isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' onclick="';
				nextPutAll: (onClick isAjaxAction 
							ifTrue: 
								[WebTask 
									generateUrlPrefixStringFor: Processor activeProcess webTask taskURLPrefix
									action: onClick
									id: nil
									convertAjaxActionToScript: true]
							ifFalse: [onClick]);
				nextPut: $"].
	readOnly = true ifTrue: [aStream nextPutAll: ' readonly="readonly"'].
	disabled = true ifTrue: [aStream nextPutAll: ' disabled="disabled"'].
	cssStyle isNil 
		ifFalse: 
			[aStream
				nextPutAll: ' style="';
				nextPutAll: cssStyle;
				nextPut: $"].
	(background isNil and: [color isNil and: [border isNil]]) 
		ifFalse: 
			[aStream nextPutAll: ' style="'.
			background isNil 
				ifFalse: 
					[aStream
						nextPutAll: 'background-color:';
						nextPutAll: background , ';'].
			color isNil 
				ifFalse: 
					[aStream
						nextPutAll: 'color: ';
						nextPutAll: color , ';'].
			border isNil 
				ifFalse: 
					[aStream
						nextPutAll: 'border:';
						nextPutAll: border printString , 'px;'].
			aStream nextPut: $"].
	name isNilOrEmpty 
		ifFalse: 
			[aStream
				nextPutAll: ' name="';
				nextPutAll: name;
				nextPut: $"].
	aStream
		nextPutAll: ' value="';
		nextPutAll: value;
		nextPutAll: '"/>'.
	flashingLabel = true 
		ifTrue: 
			[| formName blinkerName |
			formName := Processor activeProcess webCoderDefaultFormName.
			blinkerName := 'blinker' , ItcSystemManager generateShortRandomString.
			self 
				addJavascript: 'var s=0;
self.' , blinkerName , '=function()
{if(s==0){document.' , formName , '.' 
						, name , '.style.backgroundColor="#ffffff";s=1;setTimeout("' 
						, blinkerName , '()",300);}
else{document.' 
						, formName , '.' 
						, name , '.style.backgroundColor="#ffff80";s=0;setTimeout("' 
						, blinkerName , '()",500);}
};
' 
						, blinkerName , '();'
				on: aStream]!

onSubmit: aString 
	onClick := aString.
	buttonType := 'submit'!

pleaseWaitNotice: aBoolean 
	aBoolean = true 
		ifTrue: 
			[Processor activeProcess attributes at: #javascriptWaitClock put: true.
			pleaseWaitNotice := true.
			buttonType isNil ifTrue: [self buttonType: 'submit']]! !
!HtmlButton categoriesFor: #backToHistory:!public! !
!HtmlButton categoriesFor: #buttonType!public! !
!HtmlButton categoriesFor: #buttonType:!public! !
!HtmlButton categoriesFor: #flashingLabel:!public! !
!HtmlButton categoriesFor: #generateOn:!generating HTML!public! !
!HtmlButton categoriesFor: #onSubmit:!public! !
!HtmlButton categoriesFor: #pleaseWaitNotice:!public! !

!HtmlButton class methodsFor!

label: aString action: actionSymbol id: anObject 
	| button action idString |
	action := actionSymbol webAsActionString.
	idString := ''.
	button := HtmlButton name: 'BUTTON_' , action label: aString webTranslate.
	anObject isNilOrEmpty ifFalse: [idString := '&id=' , anObject asWebString].
	actionSymbol isAjaxAction 
		ifTrue: 
			[(action beginsWith: 'ajaxGet') 
				ifTrue: 
					[Processor activeProcess attributes at: #javascriptDialogBox put: true.
					button
						buttonType: 'button';
						onClick: 'ajaxGetRequest(' 
									, (Processor activeProcess webTask taskURLPrefix , '?action=' , action , idString) asJavascriptValue 
										, ');']
				ifFalse: 
					[(action beginsWith: 'ajaxPost') 
						ifTrue: 
							[button
								buttonType: 'button';
								onClick: 'ajaxPostRequestForAction(this,' , (action , idString) asJavascriptValue , ');']]].
	^button!

label: aString onClick: javascript 
	^(self new)
		value: aString webTranslate;
		buttonType: 'button';
		onClick: javascript;
		yourself!

name: aString flashingLabel: label

	^self new
		name: aString;
		value: label;
		flashingLabel: true!

name: aString label: label

	^self new
		name: aString;
		value: label!

name: nameString label: aString onClick: javascript 
	^(self new)
		name: nameString;
		value: aString webTranslate;
		buttonType: 'button';
		onClick: javascript;
		yourself! !
!HtmlButton class categoriesFor: #label:action:id:!public! !
!HtmlButton class categoriesFor: #label:onClick:!public! !
!HtmlButton class categoriesFor: #name:flashingLabel:!public! !
!HtmlButton class categoriesFor: #name:label:!public! !
!HtmlButton class categoriesFor: #name:label:onClick:!public! !

