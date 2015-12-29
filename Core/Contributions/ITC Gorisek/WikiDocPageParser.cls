"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #WikiDocPageParser
	instanceVariableNames: 'writeStream pageVersion urlPrefix application insideParagraph ident identTags referencedPages pageTitle session table alternateColor figures toolTipIds onLoadScript defaultLanguage'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocPageParser guid: (GUID fromString: '{1AFE5D5E-92D1-43A2-B63E-2A3D5DD92D6B}')!
WikiDocPageParser comment: ''!
!WikiDocPageParser categoriesForClass!Unclassified! !
!WikiDocPageParser methodsFor!

addFigure: imageName caption: caption 
	"Preveri ali se je ta slika s to labelo ze uporabila.
	Ce se je ze, vrne <false>.
	Ce se se ni uporabila, vrne <true> in jo doda v collection.

	Slike so ostevilcene zato preverja, da se ne ponavljajo.
	V besedilu se nato lahko slike referencirajo."

	figures 
		do: [:each | ((each at: 1) = imageName and: [(each at: 2) = caption]) ifTrue: [^false]].
	figures add: (Array with: imageName with: caption).
	^true!

clearIdentAndParagraph
	"Metoda zakljuci odstavek ali tabelo ali nastevanje z alinejami oz. stevilkami.
	Vrne <true>, ce je naredil zakljucek.
	Vrne <false>, ce ni naredil nic -> v tem primeru se za prazno vrstico naredi prazen odstavek."

	| result |
	result := false.
	table = true 
		ifTrue: 
			[table := nil.
			writeStream nextPutAll: '</table></div>'.
			result := true].
	[ident = 0] whileFalse: 
			[writeStream nextPutAll: (identTags at: ident).
			ident := ident - 1.
			result := true].
	insideParagraph 
		ifTrue: 
			[writeStream nextPutAll: '</p>'.
			insideParagraph := false.
			result := true].
	^result!

clearNextEmptyLineFrom: readStream 
	| pos |
	pos := readStream position.
	readStream atEnd 
		ifFalse: [readStream nextLine trimBlanks isEmpty ifFalse: [readStream position: pos]]!

figures
	^figures!

figures: aCollection 
	figures := aCollection!

generateHtmlFrom: contents for: aPageVersion on: htmlStream urlPrefix: anObject application: anObject1 session: aWebSession 
	| rs |
	defaultLanguage := Processor activeProcess language.
	figures isNil ifTrue: [figures := OrderedCollection new].
	session := aWebSession.
	referencedPages := nil.
	identTags := Array new: 200.
	pageVersion := aPageVersion.
	writeStream := htmlStream.
	urlPrefix := anObject.
	pageTitle := nil.
	application := anObject1.
	rs := ReadStream on: contents.
	ident := 0.
	insideParagraph := false.
	toolTipIds := OrderedCollection new.
	onLoadScript := ''.
	(pageVersion pageFormat == #wikiDocPageFormatHTML 
		or: [pageVersion pageFormat == #wikiDocPageFormatPlainHTML]) 
			ifTrue: [self generatePageContentsInHtmlFormatFrom: rs]
			ifFalse: [self generatePageContentsInWikiDocMarkupFormatFrom: rs].
	(onLoadScript isEmpty or: [onLoadScript endsWith: ';']) 
		ifFalse: [onLoadScript := onLoadScript , ';'].
	toolTipIds do: [:each | onLoadScript := onLoadScript , 'initializeToolTip' , each , '();'].
	(onLoadScript := onLoadScript trimBlanks) isEmpty 
		ifFalse: 
			[writeStream
				nextPutAll: HtmlElement javascriptBeginString;
				nextPutAll: 'function initializeContentPage' , onLoadScript hash printString , '() {
	';
				nextPutAll: onLoadScript;
				nextPutAll: '
	}
	ToolTip.AddEvent(''load'', window, initializeContentPage' 
							, onLoadScript hash printString , ');';
				nextPutAll: HtmlElement javascriptEndString]!

generatePageContentsInHtmlFormatFrom: rs 
	writeStream nextPutAll: rs contents!

generatePageContentsInWikiDocMarkupFormatFrom: rs 
	[rs atEnd] whileFalse: [self parseParagraphContentsFrom: rs].
	self clearIdentAndParagraph!

getHtmlFragmentFrom: rs 
	| ch ws |
	ws := WriteStream on: String new.
	[rs atEnd] whileFalse: 
			[ch := rs next.
			(ch = $< and: [(rs peek: 6) asUppercase = '/HTML>']) 
				ifTrue: 
					[rs next: 6.
					^ws contents]
				ifFalse: [ws nextPut: ch]].
	^ws contents!

getNestedParagraphContentsFrom: rs 
	| ws ch |
	ws := WriteStream on: String new.
	[rs atEnd] whileFalse: 
			[ch := rs next.
			"preveri, ce je konec nested paragraph-a"
			(ch = $} and: [rs peek = $}]) 
				ifTrue: 
					[rs next.
					^ws contents].
			"preveri, ce je zacetek HTML fragmenta"
			(ch = $< and: [(rs peek: 5) asUppercase = 'HTML>']) 
				ifTrue: 
					[ws
						nextPut: ch;
						nextPutAll: (rs next: 5).
					ws
						nextPutAll: (self getHtmlFragmentFrom: rs);
						nextPutAll: '</html>']
				ifFalse: [ws nextPut: ch]].
	^ws contents!

getParagraphLineFrom: rs inside: insideBool 
	"Private - Vrne celotno vsebino odstavka za primer vsebovanega HTML in nested paragrapha."

	| ws ch cr lf |
	cr := 13 asCharacter.
	lf := 10 asCharacter.
	ws := WriteStream on: String new.
	[rs atEnd] whileFalse: 
			[ch := rs next.
			"preveri, ce je konec nested paragraph-a"
			(insideBool == true and: [ch = $} and: [rs peek = $}]]) 
				ifTrue: 
					[ws
						nextPut: ch;
						nextPut: rs next.
					^ws contents].
			"preveri, ce je zacetek nested paragraph-a"
			(ch = ${ and: [rs peek = ${]) 
				ifTrue: 
					[insideBool = true ifTrue: [self error: 'Paragraph nesting too deep'].
					ws
						nextPut: ch;
						nextPut: rs next;
						nextPutAll: (self getParagraphLineFrom: rs inside: true)]
				ifFalse: 
					["preveri, ce je zacetek HTML fragmenta"
					(ch = $< and: [(rs peek: 5) asUppercase = 'HTML>']) 
						ifTrue: 
							[ws
								nextPut: ch;
								nextPutAll: (rs next: 5).
							ws
								nextPutAll: (self getHtmlFragmentFrom: rs);
								nextPutAll: '</html>']
						ifFalse: 
							[(insideBool ~~ true and: [ch = cr or: [ch = lf]]) 
								ifTrue: 
									[rs peek = lf ifTrue: [rs next].
									^ws contents].
							ws nextPut: ch]]].
	^ws contents!

occurrencesOfAll: aCollection in: aString 
	| st count |
	st := ReadStream on: aString.
	count := 0.
	[st itcSkipToAll: aCollection] whileTrue: [count := count + 1].
	^count!

pageTitle
	^pageTitle!

parseHtmlAndGetReferencesToOtherWikiPages
	| parsedPage langName pageId fields |
	parsedPage := HtmlParserPage fromString: writeStream contents.
	parsedPage links do: 
			[:eachLink | 
			(eachLink url beginsWith: 'WikiPage?page=') 
				ifTrue: 
					[fields := eachLink getUrlAttributeNamesAndValues.
					(application applicationLanguages includes: (langName := fields at: 'lang')) 
						ifFalse: [langName := defaultLanguage].
					pageId := fields at: 'page'.
					(application getPage: pageId language: langName) notNil 
						ifTrue: [referencedPages add: (Association key: langName value: pageId)]]]!

parseLine: line 
	insideParagraph 
		ifFalse: 
			[ident = 0 
				ifTrue: 
					[writeStream nextPutAll: '<p>'.
					insideParagraph := true]].
	self writeParagraph: line!

parseParagraphContentsFrom: rs 
	"Parse line and remaining text on stream."

	| newIdent i ch line lastPos |
	lastPos := rs position.
	line := rs nextLine.
	(line beginsWithUppercase: '<PRE>') 
		ifTrue: 
			["is preformated text begin"
			^self writePreformatedText: line from: rs].
	line isEmpty 
		ifTrue: 
			["is new paragraph?"
			self clearIdentAndParagraph ifFalse: [writeStream nextPutAll: '<br />'].
			^self].
	line first = $| 
		ifTrue: 
			[table = true 
				ifFalse: 
					[self clearIdentAndParagraph.
					table := true.
					alternateColor := false.
					writeStream 
						nextPutAll: '<div style="margin-left:10px;margin-right:10px;"><table cellpadding=2 cellspacing=2 border=0 width="92%" style="border-top:1px solid gray;border-bottom:1px solid gray;">'].
			rs position: lastPos.
			^self parseTableItemsFrom: (self getParagraphLineFrom: rs inside: false)].
	table = true 
		ifTrue: 
			[table := nil.
			writeStream nextPutAll: '</table></div>'].
	((line beginsWith: '===') and: [line endsWith: '===']) 
		ifTrue: [^self writeHeading2: line fromStream: rs].
	((line beginsWith: '==') and: [line endsWith: '==']) 
		ifTrue: [^self writeHeading: line fromStream: rs].
	i := 1.
	[i < line size and: 
			[ch := line at: i.
			ch = $* or: [ch = $#]]] whileTrue: [i := i + 1].
	newIdent := i - 1.
	newIdent = ident 
		ifFalse: 
			[newIdent > ident 
				ifTrue: 
					[ident + 1 to: newIdent
						do: 
							[:index | 
							ch := line at: index.
							ch = $* 
								ifTrue: 
									[writeStream nextPutAll: '<ul>'.
									identTags at: index put: '</ul>']
								ifFalse: 
									[writeStream nextPutAll: '<ol>'.
									identTags at: index put: '</ol>']]]
				ifFalse: 
					[ident to: newIdent + 1
						by: -1
						do: [:index | writeStream nextPutAll: (identTags at: index)]]].
	ident := newIdent.
	ident = 0 
		ifFalse: 
			[writeStream nextPutAll: '<li>'.
			lastPos := lastPos + ident].
	rs position: lastPos.
	self parseLine: (self getParagraphLineFrom: rs inside: false).
	ident = 0 ifFalse: [writeStream nextPutAll: '</li>']!

parseTableItemsFrom: line 
	| tokens rs ws ch |
	tokens := OrderedCollection new.
	ws := WriteStream on: String new.
	rs := ReadStream on: line.
	"skip first |"
	rs next.
	[rs atEnd] whileFalse: 
			[ch := rs next.
			ch = $| 
				ifTrue: 
					[tokens add: ws contents.
					ws := WriteStream on: String new]
				ifFalse: 
					[ws nextPut: ch.
					ch = $[ 
						ifTrue: 
							[ws
								nextPutAll: (rs upTo: $]);
								nextPut: $]]]].
	tokens add: ws contents.
	^tokens size = 2 
		ifTrue: [self parseTableTwoColumnsItemsFrom: tokens]
		ifFalse: [self parseTableThreeColumnsItemsFrom: tokens]!

parseTableThreeColumnsItemsFrom: tokens 
	| index index2 label description description2 |
	alternateColor := alternateColor not.
	label := tokens at: 1.
	description := tokens at: 2.
	description2 := tokens at: 3.
	writeStream nextPutAll: '<tr><td width="20%" valign="top"'.
	alternateColor ifTrue: [writeStream nextPutAll: ' bgcolor="#f0f0f0"'].
	writeStream nextPutAll: '><font class="inputFieldLabel">'.
	self writeParagraph: label.
	writeStream nextPutAll: '</font></td><td width="15%" valign="top"'.
	alternateColor ifTrue: [writeStream nextPutAll: ' bgcolor="#f0f0f0"'].
	writeStream nextPutAll: '><i>'.
	self writeParagraph: description.
	writeStream nextPutAll: '</i></td><td width="65%" valign="top"'.
	alternateColor ifTrue: [writeStream nextPutAll: ' bgcolor="#f0f0f0"'].
	writeStream nextPut: $>.
	self writeParagraph: description2.
	writeStream nextPutAll: '</td></tr>'!

parseTableTwoColumnsItemsFrom: tokens 
	| label description |
	alternateColor := alternateColor not.
	label := tokens at: 1.
	description := tokens at: 2.
	writeStream nextPutAll: '<tr><td width="20%" valign="top"'.
	alternateColor ifTrue: [writeStream nextPutAll: ' bgcolor="#f0f0f0"'].
	writeStream nextPutAll: '><font class="inputFieldLabel">'.
	self writeParagraph: label.
	writeStream nextPutAll: '</font></td><td width="80%" valign="top"'.
	alternateColor ifTrue: [writeStream nextPutAll: ' bgcolor="#f0f0f0"'].
	writeStream nextPut: $>.
	self writeParagraph: description.
	writeStream nextPutAll: '</td></tr>'!

referencedPages
	referencedPages isNil 
		ifTrue: 
			[referencedPages := OrderedCollection new.
			(pageVersion pageFormat == #wikiDocPageFormatHTML 
				or: [pageVersion pageFormat == #wikiDocPageFormatPlainHTML]) 
					ifTrue: [self parseHtmlAndGetReferencesToOtherWikiPages]].
	^referencedPages!

writeButtonFrom: rs 
	| content |
	rs next: 9.
	content := rs itcUpToAll: ']]'.
	writeStream
		nextPutAll: '<span class="buttonLabel">';
		nextPutAll: content webHtmlEncoded asHtmlString;
		nextPutAll: '</span>'!

writeCheckBoxFrom: rs 
	| content |
	rs next: 11.
	content := rs itcUpToAll: ']]'.
	writeStream
		nextPutAll: '<span class="checkBoxLabel">';
		nextPutAll: '&nbsp;<img src="images/checkbox.gif" width="21" height="20" border="0"/>';
		nextPutAll: content webHtmlEncoded asHtmlString;
		nextPutAll: '&nbsp;</span>'!

writeDownloadFrom: rs 
	| content tokens fileName file showUploadLink linkFragment |
	rs upTo: $:.
	content := rs itcUpToAll: ']]'.
	tokens := content itcSubStrings: $|.
	fileName := tokens at: 1.
	file := application getDownloadableFile: fileName.
	showUploadLink := session notNil and: [session user notNil].
	linkFragment := showUploadLink 
				ifTrue: 
					['<a class="downloadableFile" href="' 
						, (urlPrefix , '?action=uploadFile&page=' , pageVersion page pageName webHttpUrlEncoded , '&id=' 
								, fileName webHttpUrlEncoded) webHtmlEncodedForForm 
							, '">']
				ifFalse: 
					['<a class="downloadableFile" href="files-wiki/' 
						, fileName asWebString webHttpUrlEncodedForPathComponent webHtmlEncodedForForm , '">'].
	writeStream
		nextPutAll: '<table><tr><td>';
		nextPutAll: linkFragment.
	showUploadLink 
		ifTrue: 
			[writeStream nextPutAll: '<img src="images/download.gif" width="36" height="36" border="'.
			writeStream nextPut: (file isNil ifTrue: [$2] ifFalse: [$0]).
			writeStream 
				nextPutAll: '" alt="' , 'WikiDoc.ClickHereToUploadFile' webTranslate webHtmlEncodedForForm 
						, '" title="' , 'WikiDoc.ClickHereToUploadFile' webTranslate webHtmlEncodedForForm 
						, '"/>']
		ifFalse: [writeStream nextPutAll: '<img src="images/download.gif" width="36" height="36" border="0"/>'].
	writeStream
		nextPutAll: '</a></td><td nowrap="nowrap">';
		nextPutAll: linkFragment;
		nextPutAll: fileName asWebString webHtmlEncoded.
	file isNil 
		ifFalse: 
			[writeStream
				nextPutAll: '<br /><small>';
				nextPutAll: 'Dokument.fileSize' webTranslate;
				nextPutAll: ': ';
				nextPutAll: (file fileSize / 1024.0) asWebString;
				nextPutAll: ' kB</small>'].
	writeStream nextPutAll: '</a></td></tr></table>'!

writeExternalLinkFrom: rs 
	| content url linkTitle request |
	rs next.
	content := rs upTo: $].
	(content indexOf: $ ) = 0 
		ifTrue: 
			[url := content.
			linkTitle := content]
		ifFalse: 
			[url := content copyFrom: 1 to: (content indexOf: $ ) - 1.
			linkTitle := content copyFrom: url size + 2 to: content size].
	(url beginsWithUppercase: 'MAILTO:') 
		ifTrue: 
			["tukaj se e-mail naslovi zakodirajo z Javascriptom tako, da jih agent-i ne morejo pobirati z web-a"
			writeStream 
				nextPutAll: ('<a href="' , url webHtmlEncodedForForm , '" title="' , linkTitle webHtmlEncodedForForm 
						, '" class="external" target="_blank">' , linkTitle webHtmlEncoded 
						, '</a>') asJavascriptWriteEncodedString 
						asJavascriptHtmlFragment]
		ifFalse: 
			[writeStream
				nextPutAll: '<a href="' , url webHtmlEncodedForForm , '" title="' , linkTitle webHtmlEncodedForForm 
							, '" class="external" target="_blank">';
				nextPutAll: linkTitle webHtmlEncoded;
				nextPutAll: '</a>'].
	(request := Processor activeProcess webRequest) isNil 
		ifFalse: 
			[request isMozilla 
				ifFalse: 
					[writeStream
						nextPutAll: '&nbsp;<a href="';
						nextPutAll: url webHtmlEncodedForForm;
						nextPutAll: '" target="_blank"><img src="images/external.gif" width="10" height="10" border="0" alt="';
						nextPutAll: url webHtmlEncodedForForm;
						nextPutAll: '"/></a>']]!

writeFigureFrom: rs 
	| content tokens imageFile image caption |
	rs next: 9.
	content := rs itcUpToAll: ']]'.
	tokens := content itcSubStrings: $|.
	imageFile := tokens at: 1.
	tokens size > 1 ifTrue: [caption := tokens at: 2].
	(self addFigure: imageFile caption: caption) ifFalse: [^self].
	writeStream 
		nextPutAll: '<table cellpadding="0" cellspacing="0" border="0"><tr><td>&nbsp;&nbsp;</td><td align="center">'.
	writeStream nextPutAll: '<div style="border:1px solid #c0c0c0;margin:3px;padding:2px;">'.
	(image := application getImage: imageFile) isNil 
		ifTrue: 
			[writeStream 
				nextPutAll: '<a href="' , urlPrefix , '?action=' , #processUploadImage:on: webAsActionString 
						, '&page=' , pageVersion page pageName webHttpUrlEncoded 
						, '&id=' , imageFile webHttpUrlEncoded 
						, '"><img src="images/diskette3.gif" width="23" height="23" border=2 alt="' 
							, 'WikiDoc.ClickHereToUploadImage' webTranslate webHtmlEncodedForForm , '"  title="' 
						, 'WikiDoc.ClickHereToUploadImage' webTranslate webHtmlEncodedForForm , '"/></a>']
		ifFalse: 
			[(session isNil or: [session user isNil]) 
				ifFalse: 
					[writeStream 
						nextPutAll: '<a href="' , urlPrefix , '?action=' , #processUploadImage:on: webAsActionString 
								, '&page=' , pageVersion page pageName webHttpUrlEncoded 
								, '&id=' , imageFile webHttpUrlEncoded 
								, '">'].
			writeStream nextPutAll: (image 
						getImageTagMaxWidth: nil
						maxHeight: nil
						border: 0
						alt: caption asWebString).
			(session isNil or: [session user isNil]) ifFalse: [writeStream nextPutAll: '</a>']].
	writeStream nextPutAll: '</div></td><td width="100%"><img width="1" height="1" /></td></tr>'.
	caption isNilOrEmpty 
		ifFalse: 
			[writeStream
				nextPutAll: '<tr><td>&nbsp;&nbsp;</td><td colspan="2"><table cellspacing="0" cellpadding="0" border="0"><tr><td><font class="caption">&nbsp;&nbsp;</font></td><td><font class="caption"><b>';
				nextPutAll: ('WikiDoc.FigureLabelWith' webTranslateWith: figures size printString);
				nextPutAll: '&nbsp;';
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
		nextPutAll: '<table cellpadding="0" cellspacing="0" border="0" align="right"><tr><td>&nbsp;</td><td>'.
	writeStream nextPutAll: '<span style="border:1px solid #c0c0c0;margin:3px;padding:2px;">'.
	(image := application getImage: imageFile) isNil 
		ifTrue: 
			[writeStream 
				nextPutAll: '<a href="' , urlPrefix , '?action=uploadImage&page=' 
						, pageVersion page pageName webHttpUrlEncoded , '&id=' 
						, imageFile webHttpUrlEncoded 
							, '"><img src="images/diskette3.gif" width=23 height=23 border=2 alt="' 
							, 'WikiDoc.ClickHereToUploadImage' webTranslate webHtmlEncodedForForm , '"/></a>']
		ifFalse: 
			[(session isNil or: [session user isNil]) 
				ifFalse: 
					[writeStream 
						nextPutAll: '<a href="' , urlPrefix , '?action=uploadImage&page=' 
								, pageVersion page pageName webHttpUrlEncoded , '&id=' 
								, imageFile webHttpUrlEncoded , '">'].
			writeStream nextPutAll: (image 
						getImageTagMaxWidth: nil
						maxHeight: nil
						border: 0
						alt: caption asWebString).
			(session isNil or: [session user isNil]) ifFalse: [writeStream nextPutAll: '</a>']].
	writeStream
		nextPutAll: '</span></td></tr><tr><td>&nbsp;</td><td><table cellspacing="0" cellpadding="0" border="0"><tr><td><font class="caption">&nbsp;&nbsp;</font></td><td><font class="caption"><b>';
		nextPutAll: ('WikiDoc.FigureLabelWith' webTranslateWith: figures size printString);
		nextPutAll: '&nbsp;';
		nextPutAll: (caption isNilOrEmpty 
					ifTrue: ['<font class="error">' , 'asp.error.MandatoryEntry' webTranslate , '</font>']
					ifFalse: [caption webHtmlEncoded]);
		nextPutAll: '</b></font></td></tr></table></td></tr></table>'!

writeHeading: line fromStream: readStream 
	| title |
	title := line copyFrom: 3 to: line size - 2.
	self clearIdentAndParagraph.
	writeStream nextPutAll: '<h1>' , title webHtmlEncoded , '</h1>'.
	pageTitle isNil ifTrue: [pageTitle := title].
	self clearNextEmptyLineFrom: readStream!

writeHeading2: line fromStream: readStream 
	| title |
	title := line copyFrom: 4 to: line size - 3.
	self clearIdentAndParagraph.
	writeStream nextPutAll: '<h2>' , title webHtmlEncoded , '</h2>'.
	self clearNextEmptyLineFrom: readStream!

writeHintNoticeFrom: rs 
	rs upTo: $:.
	writeStream 
		nextPutAll: '<div style="alignment:center;border:1px solid #c0c0c0;padding:3pt;margin-top:8pt;margin-bottom:5pt;margin-left:30pt;margin-right:30pt;background:#ffffcc;"><table border="0" cellspacing="5" width="80%" ><tr><td><img src="images/ideja-lucka.gif" width="19" height="19"/></td><td width="100%">'.
	(rs peek: 2) = '{{' 
		ifTrue: 
			[rs next: 2.
			self writeNestedParagraphsFrom: (ReadStream on: (self getNestedParagraphContentsFrom: rs)).
			rs itcUpToAll: ']]']
		ifFalse: 
			[writeStream
				nextPutAll: '<b>';
				nextPutAll: (rs itcUpToAll: ']]') webHtmlEncoded;
				nextPutAll: '</b>'].
	writeStream nextPutAll: '</td></tr></table></div>'!

writeImageCenterFrom: rs 
	| content tokens imageFile |
	rs next: 15.
	content := rs itcUpToAll: ']]'.
	tokens := content itcSubStrings: $|.
	imageFile := tokens at: 1.
	writeStream nextPutAll: '<center>'.
	self writeImageFragmentFor: imageFile.
	writeStream nextPutAll: '</center>'!

writeImageFragmentFor: imageFile 
	| image |
	(image := application getImage: imageFile) isNil 
		ifTrue: 
			[writeStream 
				nextPutAll: '<a href="' , urlPrefix , '?action=uploadImage&page=' 
						, pageVersion page pageName webHttpUrlEncoded , '&id=' 
						, imageFile webHttpUrlEncoded 
							, '"><img src="images/diskette3.gif" width=23 height=23 border=2 alt="' 
							, 'WikiDoc.ClickHereToUploadImage' webTranslate webHtmlEncodedForForm , '"  title="' 
						, 'WikiDoc.ClickHereToUploadImage' webTranslate webHtmlEncodedForForm , '"/></a>']
		ifFalse: 
			[(session isNil or: [session user isNil]) 
				ifFalse: 
					[writeStream 
						nextPutAll: '<a href="' , urlPrefix , '?action=uploadImage&page=' 
								, pageVersion page pageName webHttpUrlEncoded , '&id=' 
								, imageFile webHttpUrlEncoded , '">'].
			writeStream nextPutAll: (image 
						getImageTagMaxWidth: nil
						maxHeight: nil
						border: 0
						alt: image imageName).
			(session isNil or: [session user isNil]) ifFalse: [writeStream nextPutAll: '</a>']]!

writeImageFrom: rs 
	| content tokens imageFile |
	rs next: 8.
	content := rs itcUpToAll: ']]'.
	tokens := content itcSubStrings: $|.
	imageFile := tokens at: 1.
	self writeImageFragmentFor: imageFile!

writeImageRightFrom: rs 
	| content tokens imageFile |
	rs next: 14.
	content := rs itcUpToAll: ']]'.
	tokens := content itcSubStrings: $|.
	imageFile := tokens at: 1.
	writeStream nextPutAll: '<table cellpadding="0" cellspacing="0" border="0" align="right"><tr><td>'.
	self writeImageFragmentFor: imageFile.
	writeStream nextPutAll: '</td></tr></table>'!

writeImportantNoticeFrom: rs 
	rs upTo: $:.
	writeStream 
		nextPutAll: '<div style="alignment:center;border:2px solid #a0a0f0;padding:3pt;margin-top:8pt;margin-bottom:5pt;margin-left:30pt;margin-right:30pt;background:#f0f0f0;"><table border="0" cellspacing="5" width="80%" ><tr><td><img src="images/warning2.gif" width="41" height="36"/></td><td width="100%">'.
	(rs peek: 2) = '{{' 
		ifTrue: 
			[rs next: 2.
			self writeNestedParagraphsFrom: (ReadStream on: (self getNestedParagraphContentsFrom: rs)).
			rs itcUpToAll: ']]']
		ifFalse: 
			[writeStream
				nextPutAll: '<b>';
				nextPutAll: (rs itcUpToAll: ']]') webHtmlEncoded;
				nextPutAll: '</b>'].
	writeStream nextPutAll: '</td></tr></table></div>'!

writeInputFieldFrom: rs 
	| content |
	rs next: 8.
	content := rs itcUpToAll: ']]'.
	writeStream
		nextPutAll: '<span class="inputFieldLabel">';
		nextPutAll: content webHtmlEncoded asHtmlString;
		nextPutAll: '&nbsp;</span>'!

writeMenuReferenceFrom: rs 
	| content |
	rs next: 7.
	content := rs itcUpToAll: ']]'.
	writeStream nextPutAll: '<span class="menuLabel">'.
	(content itcSubStrings: $|) doWithIndex: 
			[:eachLabel :index | 
			index = 1 ifFalse: [writeStream nextPutAll: '<small>&nbsp;</small>'].
			writeStream
				nextPutAll: '<b>|</b>';
				nextPutAll: eachLabel webHtmlEncoded].
	writeStream nextPutAll: '</span>'!

writeNestedParagraphsFrom: rs 
	| oldTable oldIdent oldInsideParagraph contentsStream |
	oldTable := table.
	oldIdent := ident.
	oldInsideParagraph := insideParagraph.
	table := nil.
	ident := 0.
	insideParagraph := false.
	rs next: 2.
	contentsStream := ReadStream on: (self getNestedParagraphContentsFrom: rs).
	[contentsStream atEnd] whileFalse: [self parseParagraphContentsFrom: contentsStream].
	table := oldTable.
	ident := oldIdent.
	insideParagraph := oldInsideParagraph!

writeNextTokenFrom: rs 
	| ch str7 |
	ch := rs peek.
	(ch = ${ and: [(rs peek: 2) = '{{']) ifTrue: [^self writeNestedParagraphsFrom: rs].
	ch = $[ 
		ifTrue: 
			[str7 := (rs peek: 7) asUppercase.
			((rs peek: 12) asUppercase = '[[IMPORTANT:' or: [str7 = '[[WARN:']) 
				ifTrue: [^self writeImportantNoticeFrom: rs].
			(str7 = '[[HINT:' or: [str7 = '[[IDEA:']) ifTrue: [^self writeHintNoticeFrom: rs].
			str7 = '[[MENU:' ifTrue: [^self writeMenuReferenceFrom: rs].
			(rs peek: 10) asUppercase = '[[TOOLTIP:' ifTrue: [^self writeToolTipReferenceFrom: rs].
			((rs peek: 11) asUppercase = '[[DOWNLOAD:' or: [str7 = '[[FILE:']) 
				ifTrue: [^self writeDownloadFrom: rs].
			(rs peek: 8) asUppercase = '[[IMAGE:' ifTrue: [^self writeImageFrom: rs].
			(rs peek: 14) asUppercase = '[[IMAGE-RIGHT:' ifTrue: [^self writeImageRightFrom: rs].
			(rs peek: 15) asUppercase = '[[IMAGE-CENTER:' ifTrue: [^self writeImageCenterFrom: rs].
			(rs peek: 9) asUppercase = '[[FIGURE:' ifTrue: [^self writeFigureFrom: rs].
			(rs peek: 15) asUppercase = '[[FIGURE-RIGHT:' ifTrue: [^self writeFigureRightFrom: rs].
			(rs peek: 8) asUppercase = '[[FIELD:' ifTrue: [^self writeInputFieldFrom: rs].
			(rs peek: 11) asUppercase = '[[CHECKBOX:' ifTrue: [^self writeCheckBoxFrom: rs].
			(rs peek: 9) asUppercase = '[[BUTTON:' ifTrue: [^self writeButtonFrom: rs].
			(rs peek: 2) = '[[' ifTrue: [^self writePageLinkFrom: rs].
			((rs peek: 8) asUppercase = '[HTTP://' 
				or: [(rs peek: 9) asUppercase = '[HTTPS://' or: [(rs peek: 8) asUppercase = '[MAILTO:']]) 
					ifTrue: [^self writeExternalLinkFrom: rs]].
	ch = $< ifTrue: [(rs peek: 6) asUppercase = '<HTML>' ifTrue: [^self writeRawHtmlFrom: rs]].
	ch = $' 
		ifTrue: 
			[(rs peek: 3) = '''''''' 
				ifTrue: 
					[rs next: 3.
					writeStream nextPutAll: '<strong>'.
					self writeParagraph: (rs itcUpToAll: '''''''').
					writeStream nextPutAll: '</strong>'.
					^self].
			(rs peek: 2) = '''''' 
				ifTrue: 
					[rs next: 2.
					writeStream nextPutAll: '<i>'.
					self writeParagraph: (rs itcUpToAll: '''''').
					writeStream nextPutAll: '</i>'.
					^self]].
	writeStream nextPut: rs next!

writePageLinkFrom: rs 
	| content tokens pageId linkText index langName |
	rs next: 2.
	content := rs itcUpToAll: ']]'.
	tokens := content itcSubStrings: $|.
	pageId := tokens at: 1.
	tokens size > 1 ifTrue: [linkText := tokens at: 2] ifFalse: [linkText := tokens at: 1].
	(index := pageId indexOfSubCollection: '\\') > 0 
		ifTrue: 
			[langName := pageId copyFrom: 1 to: index - 1.
			pageId := pageId copyFrom: index + 2 to: pageId size.
			(application applicationLanguages includes: langName) 
				ifFalse: [self error: 'Selected language is not supported']]
		ifFalse: [langName := defaultLanguage].
	referencedPages isNil ifTrue: [referencedPages := OrderedCollection new].
	referencedPages add: (Association key: langName value: pageId).
	writeStream
		nextPutAll: (WikiDocPageParser 
					pageLinkFor: pageId
					pageTitle: pageId
					pageLanguage: langName
					defaultLanguage: defaultLanguage
					application: application);
		nextPutAll: linkText webHtmlEncoded;
		nextPutAll: '</a>'!

writeParagraph: aString 
	| rs |
	rs := ReadStream on: aString.
	[rs atEnd] whileFalse: [self writeNextTokenFrom: rs]!

writePreformatedText: line from: rs 
	| ws ch |
	self clearIdentAndParagraph.
	ws := WriteStream on: String new.
	line size > 5 
		ifTrue: 
			[ws
				nextPutAll: (line copyFrom: 6 to: line size);
				cr].
	
	[rs atEnd ifTrue: [^self].
	ch := rs next.
	ch = $< and: [(rs peek: 5) asUppercase = '/PRE>']] 
			whileFalse: [ws nextPut: ch].
	rs next: 5.
	writeStream
		nextPutAll: '<blockquote style="background:#ffffd0;border:1px solid black;padding:1em;font-family:Verdana">';
		nextPutAll: ws contents webHtmlEncoded;
		nextPutAll: '</blockquote>'!

writeRawHtmlFrom: rs 
	| content |
	rs next: 6.
	content := self getHtmlFragmentFrom: rs.
	writeStream nextPutAll: content!

writeToolTipReferenceFrom: rs 
	| content partContent count definition toolTipId toolTipShowDelay toolTipHideDelay toolTips parsed newStream |
	Processor activeProcess attributes at: #addWikiTooltipScript put: true.
	content := WriteStream on: String new.
	rs skipTo: $:.
	toolTips := rs upTo: $:.
	partContent := rs itcUpToAll: ']]'.
	count := 0.
	[rs atEnd not and: [(count := count + (self occurrencesOfAll: '[[' in: partContent)) > 0]] 
		whileTrue: 
			[content
				nextPutAll: partContent;
				nextPutAll: ']]'.
			partContent := rs itcUpToAll: ']]'.
			count := count - 1].
	content nextPutAll: partContent.
	content := content contents.
	toolTipId := content hash printString , '_' , toolTipIds size printString.
	writeStream
		nextPutAll: '<span id="toolTip';
		nextPutAll: toolTipId;
		nextPutAll: '">'.
	newStream := ReadStream on: content.
	self parseParagraphContentsFrom: newStream.
	writeStream
		nextPutAll: '</span>';
		nextPutAll: HtmlElement javascriptBeginString;
		nextPutAll: 'function initializeToolTip';
		nextPutAll: toolTipId;
		nextPutAll: '() {var tt; '.
	parsed := false.
	(toolTips itcSubStrings: $;) do: 
			[:each | 
			parsed 
				ifFalse: 
					[definition := each itcSubStrings: $,.
					(definition size = 1 or: [definition size = 3]) 
						ifTrue: 
							[definition size = 1 
								ifTrue: [toolTipShowDelay := toolTipHideDelay := '0']
								ifFalse: 
									[toolTipShowDelay := definition at: 2.
									toolTipHideDelay := definition at: 3].
							writeStream
								nextPutAll: 'tt = new ToolTip(''toolTip';
								nextPutAll: toolTipId;
								nextPutAll: ''', ''';
								nextPutAll: (definition at: 1);
								nextPutAll: ''', ';
								nextPutAll: toolTipShowDelay;
								nextPutAll: ', ';
								nextPutAll: toolTipHideDelay;
								nextPutAll: ');'.
							parsed := true]]].
	writeStream
		nextPutAll: '}';
		nextPutAll: HtmlElement javascriptEndString.
	toolTipIds add: toolTipId! !
!WikiDocPageParser categoriesFor: #addFigure:caption:!public! !
!WikiDocPageParser categoriesFor: #clearIdentAndParagraph!public! !
!WikiDocPageParser categoriesFor: #clearNextEmptyLineFrom:!private! !
!WikiDocPageParser categoriesFor: #figures!public! !
!WikiDocPageParser categoriesFor: #figures:!public! !
!WikiDocPageParser categoriesFor: #generateHtmlFrom:for:on:urlPrefix:application:session:!public! !
!WikiDocPageParser categoriesFor: #generatePageContentsInHtmlFormatFrom:!public! !
!WikiDocPageParser categoriesFor: #generatePageContentsInWikiDocMarkupFormatFrom:!public! !
!WikiDocPageParser categoriesFor: #getHtmlFragmentFrom:!private! !
!WikiDocPageParser categoriesFor: #getNestedParagraphContentsFrom:!private! !
!WikiDocPageParser categoriesFor: #getParagraphLineFrom:inside:!private! !
!WikiDocPageParser categoriesFor: #occurrencesOfAll:in:!private! !
!WikiDocPageParser categoriesFor: #pageTitle!public! !
!WikiDocPageParser categoriesFor: #parseHtmlAndGetReferencesToOtherWikiPages!private! !
!WikiDocPageParser categoriesFor: #parseLine:!public! !
!WikiDocPageParser categoriesFor: #parseParagraphContentsFrom:!public! !
!WikiDocPageParser categoriesFor: #parseTableItemsFrom:!public! !
!WikiDocPageParser categoriesFor: #parseTableThreeColumnsItemsFrom:!public! !
!WikiDocPageParser categoriesFor: #parseTableTwoColumnsItemsFrom:!public! !
!WikiDocPageParser categoriesFor: #referencedPages!public! !
!WikiDocPageParser categoriesFor: #writeButtonFrom:!private! !
!WikiDocPageParser categoriesFor: #writeCheckBoxFrom:!private! !
!WikiDocPageParser categoriesFor: #writeDownloadFrom:!private! !
!WikiDocPageParser categoriesFor: #writeExternalLinkFrom:!private! !
!WikiDocPageParser categoriesFor: #writeFigureFrom:!private! !
!WikiDocPageParser categoriesFor: #writeFigureRightFrom:!private! !
!WikiDocPageParser categoriesFor: #writeHeading:fromStream:!private! !
!WikiDocPageParser categoriesFor: #writeHeading2:fromStream:!private! !
!WikiDocPageParser categoriesFor: #writeHintNoticeFrom:!private! !
!WikiDocPageParser categoriesFor: #writeImageCenterFrom:!private! !
!WikiDocPageParser categoriesFor: #writeImageFragmentFor:!private! !
!WikiDocPageParser categoriesFor: #writeImageFrom:!private! !
!WikiDocPageParser categoriesFor: #writeImageRightFrom:!private! !
!WikiDocPageParser categoriesFor: #writeImportantNoticeFrom:!private! !
!WikiDocPageParser categoriesFor: #writeInputFieldFrom:!private! !
!WikiDocPageParser categoriesFor: #writeMenuReferenceFrom:!private! !
!WikiDocPageParser categoriesFor: #writeNestedParagraphsFrom:!private! !
!WikiDocPageParser categoriesFor: #writeNextTokenFrom:!public! !
!WikiDocPageParser categoriesFor: #writePageLinkFrom:!private! !
!WikiDocPageParser categoriesFor: #writeParagraph:!private! !
!WikiDocPageParser categoriesFor: #writePreformatedText:from:!private! !
!WikiDocPageParser categoriesFor: #writeRawHtmlFrom:!private! !
!WikiDocPageParser categoriesFor: #writeToolTipReferenceFrom:!private! !

!WikiDocPageParser class methodsFor!

pageLinkFor: pageId pageTitle: pageTitle pageLanguage: pageLanguage defaultLanguage: defaultLanguage application: application 
	^pageLanguage = defaultLanguage 
		ifTrue: 
			['<a href="/' 
				, (application urlPrefix , '/WikiPage?page=' , pageId webHttpUrlEncoded , '&lang=' 
						, pageLanguage) webHtmlEncodedForForm 
					, '" title="' , pageTitle webHtmlEncodedForForm 
				, '" class="internal">']
		ifFalse: 
			['<a href="/' 
				, (application urlPrefix , '/WikiPage?action=reload&page=' , pageId webHttpUrlEncoded 
						, '&lang=' , pageLanguage) 
						webHtmlEncodedForForm 
					, '" title="' , pageTitle webHtmlEncodedForForm 
				, '" class="internal" target="_top">']! !
!WikiDocPageParser class categoriesFor: #pageLinkFor:pageTitle:pageLanguage:defaultLanguage:application:!public! !

