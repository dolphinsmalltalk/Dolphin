"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #HttpTranslationService
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'languagesDict charactersMaps unicodeTo8bitCodePageMaps unicodeIntegerTo8bitCodePageMaps alphabeticalSortOrders bit8ToUTF8PageMaps defaultLanguage defaultCodePage'!
HttpTranslationService guid: (GUID fromString: '{0669B386-FC70-47CD-B17C-8B6017FA9511}')!
HttpTranslationService comment: ''!
!HttpTranslationService categoriesForClass!Unclassified! !
!HttpTranslationService class methodsFor!

at: messageId 
	"This method is here so that it still works if the language dict does not exists."

	^messageId!

at: messageId ifAbsent: aBlock 
	"This method is here so that it still works if the language dict does not exists."

	^messageId!

comboCodesFor: prefix language: language 
	| dict codes code |
	codes := SortedCollection sortBlock: [:a :b | a key < b key].
	(dict := self languageDictFor: language) == self ifTrue: [^codes].
	dict keysAndValuesDo: 
			[:key :value | 
			(key beginsWith: prefix) 
				ifTrue: 
					[code := key copyFrom: prefix size + 1 to: key size.
					codes add: (Association key: code value: code , ' ' , value)]].
	^codes asArray!

compressNlsFile: fileName 
	| in out |
	[in := FileStream read: fileName , '.lng'] on: Error do: [:ex | ex exitWith: nil].
	in isFileStream 
		ifFalse: 
			[ItcSystemManager logLine: 'Can not open language file: ' , fileName , '.lng'.
			^nil].
	
	[out := FileStream 
				write: fileName , '.nls'
				mode: #truncate
				check: false
				type: #binary.
	[out nextPutAll: (ZLibInterface compressForWeb: in contents) asByteArray reverse] 
		ensure: [out close]] 
			ensure: [in close]!

dateFormatForLanguage: langName 
	^langName = 'English' ifTrue: ['MM/DD/YYYY'] ifFalse: ['DD.MM.YYYY']!

decimalPoint
	^self decimalPointFor: Processor activeProcess language!

decimalPointFor: language 
	(language = 'Slovene' or: [language = 'Croatian' or: [language = 'Bosnian']]) ifTrue: [^$,].
	^$.!

defaultCodePage
	^defaultCodePage isNil ifTrue: ['windows-1250'] ifFalse: [defaultCodePage]!

defaultCodePage: aString 
	defaultCodePage := aString!

defaultLanguage
	^defaultLanguage isNil ifTrue: ['English'] ifFalse: [defaultLanguage]!

defaultLanguage: aString 
	defaultLanguage := aString!

defineCharactersMapCPWindows1250
	^(LookupTable new)
		at: $¹ put: $š;
		at: $© put: $Š;
		at: $¾ put: $ž;
		at: $® put: $Ž;
		at: 147 asCharacter put: $";
		at: 148 asCharacter put: $";
		yourself!

defineIsoCodesMapCPWindows1250
	"Private - This method defines Unicode mapping &#xxx; codes into Windows character set."

	^(LookupTable new)
		at: '#181' put: $µ;
		at: '#8364' put: $€;
		at: '#352' put: $Š;
		at: '#353' put: $š;
		at: '#268' put: $È;
		at: '#269' put: $è;
		at: '#381' put: $Ž;
		at: '#382' put: $ž;
		at: '#262' put: $Æ;
		at: '#263' put: $æ;
		at: '#272' put: $Ð;
		at: '#273' put: $ð;
		at: '#228' put: $ä;
		at: '#196' put: $Ä;
		at: '#246' put: $ö;
		at: '#214' put: $Ö;
		at: '#252' put: $ü;
		at: '#220' put: $Ü;
		at: '#223' put: $ß;
		at: '#250' put: $ú;
		at: '#369' put: $û;
		at: '#218' put: $Ú;
		at: '#368' put: $Û;
		at: '#344' put: $Ø;
		at: '#345' put: $ø;
		at: '#225' put: $á;
		at: '#193' put: $Á;
		at: '#211' put: $Ó;
		at: '#243' put: $ó;
		at: '#336' put: $Õ;
		at: '#337' put: $õ;
		at: '#205' put: $Í;
		at: '#237' put: $í;
		at: '#201' put: $É;
		at: '#233' put: $é;
		at: '#270' put: $Ï;
		at: '#271' put: $ï;
		at: '#282' put: $Ì;
		at: '#283' put: $ì;
		at: '#327' put: $Ò;
		at: '#328' put: $ò;
		at: '#356' put: $;
		at: '#357' put: $;
		at: '#366' put: $Ù;
		at: '#367' put: $ù;
		at: '#221' put: $Ý;
		at: '#253' put: $ý;
		yourself!

defineIsoCodesMapCPWindows1250forConversionFromUnicode
	"Private - This method defines Unicode mapping &#xxx; codes into Windows character set."

	^(self defineIsoCodesMapCPWindows1250)
		at: '#8222' put: $";
		at: '#8220' put: $";
		at: '#8216' put: $';
		at: '#8217' put: $';
		at: '#8211' put: $-;
		at: '#8470' put: 'No.';
		at: '#65279' put: $ ;
		at: 'Scaron' put: $Š;
		at: 'scaron' put: $š;
		at: 'egrave' put: $è;
		at: 'euro' put: $€;
		at: '#8364' put: $€;
		at: '#181' put: $µ;
		at: '#1040' put: $A;
		at: '#1041' put: $B;
		at: '#1042' put: $V;
		at: '#1043' put: $G;
		at: '#1044' put: $D;
		at: '#1045' put: $E;
		at: '#1026' put: $Ð;
		at: '#1046' put: $Ž;
		at: '#1047' put: $Z;
		at: '#1048' put: $I;
		at: '#1032' put: $J;
		at: '#1050' put: $K;
		at: '#1051' put: $L;
		at: '#1033' put: 'Lj';
		at: '#1052' put: $M;
		at: '#1053' put: $N;
		at: '#1034' put: 'Nj';
		at: '#1054' put: $O;
		at: '#1055' put: $P;
		at: '#1056' put: $R;
		at: '#1057' put: $S;
		at: '#1058' put: $T;
		at: '#1035' put: $Æ;
		at: '#1059' put: $U;
		at: '#1060' put: $F;
		at: '#1061' put: $H;
		at: '#1062' put: $C;
		at: '#1063' put: $È;
		at: '#1039' put: 'Dž';
		at: '#1064' put: $Š;
		at: '#1072' put: $a;
		at: '#1073' put: $b;
		at: '#1074' put: $v;
		at: '#1075' put: $g;
		at: '#1076' put: $d;
		at: '#1106' put: $ð;
		at: '#1077' put: $e;
		at: '#1078' put: $ž;
		at: '#1079' put: $z;
		at: '#1080' put: $i;
		at: '#1112' put: $j;
		at: '#1082' put: $k;
		at: '#1083' put: $l;
		at: '#1113' put: 'lj';
		at: '#1084' put: $m;
		at: '#1085' put: $n;
		at: '#1114' put: 'nj';
		at: '#1086' put: $o;
		at: '#1087' put: $p;
		at: '#1088' put: $r;
		at: '#1089' put: $s;
		at: '#1090' put: $t;
		at: '#1115' put: $æ;
		at: '#1091' put: $u;
		at: '#1092' put: $f;
		at: '#1093' put: $h;
		at: '#1094' put: $c;
		at: '#1095' put: $è;
		at: '#1119' put: 'dž';
		at: '#1096' put: $š;
		at: '#1049' put: $J;
		at: '#1081' put: $j;
		at: '#1065' put: 'Št';
		at: '#1097' put: 'št';
		at: '#1066' put: $Â;
		at: '#1098' put: $â;
		at: '#1068' put: $½;
		at: '#1100' put: $½;
		at: '#1070' put: 'Ju';
		at: '#1102' put: 'ju';
		at: '#1071' put: 'Ja';
		at: '#1103' put: 'ja';
		at: '#1030' put: $I;
		yourself!

defineIsoCodesMapCPWindows1251
	"Private - This method defines Unicode mapping &#xxx; codes into Windows character set."

	"Big letters: 16rA8 - 16rDF, Small letters: 16rB8 - 16rFF"

	"Big serbian letters, which are not in russian alphabet: 16r80 - 16r8F, Small serbian letters, which are not in russian alphabet: 16r90 - 16r9F"

	^(LookupTable new)
		at: '#8222' put: $";
		at: '#8220' put: $";
		at: '#8216' put: $';
		at: '#8217' put: $';
		at: '#352' put: $S;
		at: 'Scaron' put: $S;
		at: '#353' put: $s;
		at: 'scaron' put: $s;
		at: '#268' put: $C;
		at: '#269' put: $c;
		at: 'egrave' put: $e;
		at: '#381' put: $Z;
		at: '#382' put: $z;
		at: '#262' put: $c;
		at: '#263' put: $C;
		at: '#272' put: $D;
		at: '#273' put: $d;
		at: '#191' put: 16rA8 asCharacter;
		at: '#1040' put: 16rC0 asCharacter;
		at: '#1041' put: 16rC1 asCharacter;
		at: '#1042' put: 16rC2 asCharacter;
		at: '#1043' put: 16rC3 asCharacter;
		at: '#1044' put: 16rC4 asCharacter;
		at: '#1045' put: 16rC5 asCharacter;
		at: '#1046' put: 16rC6 asCharacter;
		at: '#1047' put: 16rC7 asCharacter;
		at: '#1048' put: 16rC8 asCharacter;
		at: '#1049' put: 16rC9 asCharacter;
		at: '#1050' put: 16rCA asCharacter;
		at: '#1051' put: 16rCB asCharacter;
		at: '#1052' put: 16rCC asCharacter;
		at: '#1053' put: 16rCD asCharacter;
		at: '#1054' put: 16rCE asCharacter;
		at: '#1055' put: 16rCF asCharacter;
		at: '#1056' put: 16rD0 asCharacter;
		at: '#1057' put: 16rD1 asCharacter;
		at: '#1058' put: 16rD2 asCharacter;
		at: '#1059' put: 16rD3 asCharacter;
		at: '#1060' put: 16rD4 asCharacter;
		at: '#1061' put: 16rD5 asCharacter;
		at: '#1062' put: 16rD6 asCharacter;
		at: '#1063' put: 16rD7 asCharacter;
		at: '#1064' put: 16rD8 asCharacter;
		at: '#1065' put: 16rD9 asCharacter;
		at: '#1066' put: 16rDA asCharacter;
		at: '#1067' put: 16rDB asCharacter;
		at: '#1068' put: 16rDC asCharacter;
		at: '#1069' put: 16rDD asCharacter;
		at: '#1070' put: 16rDE asCharacter;
		at: '#1071' put: 16rDF asCharacter;
		at: '#1105' put: 16rB8 asCharacter;
		at: '#1072' put: 16rE0 asCharacter;
		at: '#1073' put: 16rE1 asCharacter;
		at: '#1074' put: 16rE2 asCharacter;
		at: '#1075' put: 16rE3 asCharacter;
		at: '#1076' put: 16rE4 asCharacter;
		at: '#1077' put: 16rE5 asCharacter;
		at: '#1078' put: 16rE6 asCharacter;
		at: '#1079' put: 16rE7 asCharacter;
		at: '#1080' put: 16rE8 asCharacter;
		at: '#1081' put: 16rE9 asCharacter;
		at: '#1082' put: 16rEA asCharacter;
		at: '#1083' put: 16rEB asCharacter;
		at: '#1084' put: 16rEC asCharacter;
		at: '#1085' put: 16rED asCharacter;
		at: '#1086' put: 16rEE asCharacter;
		at: '#1087' put: 16rEF asCharacter;
		at: '#1088' put: 16rF0 asCharacter;
		at: '#1089' put: 16rF1 asCharacter;
		at: '#1090' put: 16rF2 asCharacter;
		at: '#1091' put: 16rF3 asCharacter;
		at: '#1092' put: 16rF4 asCharacter;
		at: '#1093' put: 16rF5 asCharacter;
		at: '#1094' put: 16rF6 asCharacter;
		at: '#1095' put: 16rF7 asCharacter;
		at: '#1096' put: 16rF8 asCharacter;
		at: '#1097' put: 16rF9 asCharacter;
		at: '#1098' put: 16rFA asCharacter;
		at: '#1099' put: 16rFB asCharacter;
		at: '#1100' put: 16rFC asCharacter;
		at: '#1101' put: 16rFD asCharacter;
		at: '#1102' put: 16rFE asCharacter;
		at: '#1103' put: 16rFF asCharacter;
		at: '#1026' put: 16r80 asCharacter;
		at: '#1032' put: 16rA3 asCharacter;
		at: '#1033' put: 16r8A asCharacter;
		at: '#1034' put: 16r8C asCharacter;
		at: '#1035' put: 16r8E asCharacter;
		at: '#1039' put: 16r8F asCharacter;
		at: '#1006' put: 16r90 asCharacter;
		at: '#1112' put: 16rBC asCharacter;
		at: '#1113' put: 16r9A asCharacter;
		at: '#1114' put: 16r9C asCharacter;
		at: '#1115' put: 16r9E asCharacter;
		at: '#1119' put: 16r9F asCharacter;
		yourself!

defineIsoCodesMapCPWindows1252
	"Private - This method defines Unicode mapping &#xxx; codes into Windows character set."

	^(LookupTable new)
		at: '#8222' put: $";
		at: '#8220' put: $";
		at: '#8216' put: $';
		at: '#8217' put: $';
		at: '#228' put: $ä;
		at: '#196' put: $Ä;
		at: '#246' put: $ö;
		at: '#214' put: $Ö;
		at: '#252' put: $ü;
		at: '#220' put: $Ü;
		at: '#223' put: $ß;
		yourself!

get8bitToUTF8CodePageMapsForCodePage: codePage 
	codePage isNil ifTrue: [^nil].
	bit8ToUTF8PageMaps isNil ifTrue: [self initialize8bitToUTF8CodePageMaps].
	^bit8ToUTF8PageMaps at: codePage!

getAlphabeticalCharacterSortOrderForLanguage: languageName 
	languageName isNil ifTrue: [^#()].
	alphabeticalSortOrders isNil ifTrue: [self initializeAlphabeticalSortOrders].
	^alphabeticalSortOrders at: languageName ifAbsent: [#()]!

getCharactersMapForCodePage: codePage 
	codePage isNil ifTrue: [^nil].
	charactersMaps isNil ifTrue: [self initializeCharactersMaps].
	^charactersMaps at: codePage!

getLowerUpperDefinitionCodePageMapForCodePage: codePage 
	(codePage isNil or: [codePage = 'windows-1250']) 
		ifTrue: 
			[^Array with: 'qwertyuiopasdfghjklzxcvbnmšèžæðäöüúûøáóõíéïìòùý'
				with: 'QWERTYUIOPASDFGHJKLZXCVBNMŠÈŽÆÐÄÖÜÚÛØÁÓÕÍÉÏÌÒÙÝ'].
	codePage = 'windows-1251' ifTrue: [#itcTodo].
	codePage = 'windows-1252' ifTrue: [#itcTodo].
	"Answer default windows-1250 map"
	self error: 'Code page is not supported'!

getUnicodeIntegerTo8bitCodePageMapForCodePage: codePage 
	unicodeIntegerTo8bitCodePageMaps isNil ifTrue: [self initializeUnicodeIntegerTo8bitCodePageMaps].
	^unicodeIntegerTo8bitCodePageMaps at: (codePage ifNil: [self defaultCodePage])!

getUnicodeTo8bitCodePageMapsForCodePage: codePage 
	codePage isNil ifTrue: [^nil].
	unicodeTo8bitCodePageMaps isNil ifTrue: [self initializeUnicodeTo8bitCodePageMaps].
	^unicodeTo8bitCodePageMaps at: codePage!

getUnicodeTo8bitCodePageMapsForCurrentCodePage
	| cp |
	cp := Processor activeProcess webRequestCodePage.
	^self getUnicodeTo8bitCodePageMapsForCodePage: (cp isNil ifTrue: ['windows-1250'] ifFalse: [cp])!

initialize8bitToUTF8CodePageMapFrom: isoCodeToCharDict 
	| result unicode |
	result := ItcLookupTable new.
	isoCodeToCharDict keysAndValuesDo: 
			[:eachUnicode :eachChar | 
			((eachUnicode beginsWith: '#') 
				and: [(unicode := (eachUnicode copyFrom: 2) itcAsInteger) > 0 and: [eachChar asInteger > 127]]) 
					ifTrue: [result at: eachChar put: unicode]].
	^result!

initialize8bitToUTF8CodePageMaps
	^bit8ToUTF8PageMaps := (ItcLookupTable new)
				at: 'windows-1250'
					put: (self initialize8bitToUTF8CodePageMapFrom: self defineIsoCodesMapCPWindows1250);
				at: 'windows-1251'
					put: (self initialize8bitToUTF8CodePageMapFrom: self defineIsoCodesMapCPWindows1251);
				at: 'windows-1252'
					put: (self initialize8bitToUTF8CodePageMapFrom: self defineIsoCodesMapCPWindows1252);
				yourself!

initializeAlphabeticalSortOrders
	alphabeticalSortOrders := (LookupTable new)
				at: 'Slovene' put: 'AaBbCcÈèÆæDdÐðEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsŠšTtUuVvWwXxYyZzŽž';
				at: 'Croatian' put: 'AaBbCcÈèÆæDdÐðEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsŠšTtUuVvWwXxYyZzŽž';
				at: 'Serbian' put: 'AaBbCcÈèÆæDdÐðEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsŠšTtUuVvWwXxYyZzŽž';
				at: 'Russian'
					put: 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz' 
							, #(16rC0 16rE0 16rC1 16rE1 16rC2 16rE2 16rC3 16rE3 16rC4 16rE4 16r80 16r90 16rC5 16rE5 16rA8 16rB8 16rC6 16rE6 16rC7 16rE7 16rC8 16rE8 16rC9 16rE9 16rA3 16rBC 16rCA 16rEA 16rCB 16rEB 16r8A 16r9A 16rCC 16rEC 16rCD 16rED 16r8C 16r9C 16rCE 16rEE 16rCF 16rEF 16rD0 16rF0 16rD1 16rF1 16rD2 16rF2 16r8E 16r9E 16rD3 16rF3 16rD4 16rF4 16rD5 16rF5 16rD6 16rF6 16rD7 16rF7 16r8F 16r9F 16rD8 16rF8 16rD9 16rF9 16rDA 16rFA 16rDB 16rFB 16rDC 16rFC 16rDD 16rFD 16rDE 16rFE 16rDF 16rFF) 
									asByteArray asString;
				yourself!

initializeCharactersMaps
	charactersMaps := (ItcLookupTable new)
				at: 'windows-1250' put: self defineCharactersMapCPWindows1250;
				yourself!

initializeUnicodeIntegerTo8bitCharCodePageMapFrom: isoCodeToCharDict 
	| result unicode |
	result := IdentityDictionary new.
	isoCodeToCharDict keysAndValuesDo: 
			[:eachUnicode :eachChar | 
			((eachUnicode beginsWith: '#') and: [(unicode := (eachUnicode copyFrom: 2) itcAsInteger) > 0]) 
				ifTrue: [result at: unicode put: eachChar]].
	^result!

initializeUnicodeIntegerTo8bitCodePageMaps
	"Mapping from Unicode integer code to local charset 8-bit characters."

	^unicodeIntegerTo8bitCodePageMaps := (ItcLookupTable new)
				at: 'windows-1250'
					put: (self initializeUnicodeIntegerTo8bitCharCodePageMapFrom: self 
									defineIsoCodesMapCPWindows1250forConversionFromUnicode);
				at: 'windows-1251'
					put: (self initializeUnicodeIntegerTo8bitCharCodePageMapFrom: self defineIsoCodesMapCPWindows1251);
				at: 'windows-1252'
					put: (self initializeUnicodeIntegerTo8bitCharCodePageMapFrom: self defineIsoCodesMapCPWindows1252);
				yourself!

initializeUnicodeTo8bitCodePageMaps
	unicodeTo8bitCodePageMaps := (ItcLookupTable new)
				at: 'windows-1250' put: self defineIsoCodesMapCPWindows1250forConversionFromUnicode;
				at: 'windows-1251' put: self defineIsoCodesMapCPWindows1251;
				at: 'windows-1252' put: self defineIsoCodesMapCPWindows1252;
				yourself!

languageDictFor: languageId 
	^self languagesDict at: languageId ifAbsent: [self]!

languageDictFor: languageId put: aDictionary 
	| newDict |
	newDict := ItcLookupTable new.
	languagesDict isNil 
		ifFalse: 
			[languagesDict 
				keysAndValuesDo: [:eachKey :eachValue | eachKey = languageId ifFalse: [newDict at: eachKey put: eachValue]]].
	newDict at: languageId put: aDictionary.
	languagesDict := newDict.
	^aDictionary!

languagesDict
	languagesDict isNil ifTrue: [languagesDict := ItcLookupTable new].
	^languagesDict!

loadMessagesFrom: fileName as: languageName resetBefore: aBoolean 
	| fileStream stream dict extension |
	dict := aBoolean = true 
				ifTrue: 
					["if reset before is <true> then the dictionary will be reloaded and old one forgot"
					ItcLookupTable new]
				ifFalse: 
					["else, just add to the existing translations"
					self languagesDict at: languageName ifAbsentPut: [ItcLookupTable new]].
	[fileStream := FileStream read: fileName , '.lng'] on: Error do: [:ex | ex exitWith: nil].
	fileStream isFileStream 
		ifTrue: 
			[[stream := ReadStream on: fileStream contents] ensure: [fileStream close].
			extension := '.lng']
		ifFalse: 
			[| plainText |
			[fileStream := FileStream read: fileName , '.nls' type: #binary] on: Error
				do: [:ex | ex exitWith: nil].
			(fileStream isFileStream and: 
					[[plainText := ZLibInterface decompress: fileStream contents reverse] on: Error
						do: [:ex | ex exitWith: nil].
					fileStream close.
					plainText notNil]) 
				ifFalse: 
					[^ItcSystemManager 
						message: 'Could not load messages for: ' , fileName asWebString , '
' , stream printString].
			extension := '.nls'.
			stream := ReadStream on: plainText asString].
	ItcSystemManager 
		logLine: 'Loading messages for ' , languageName asWebString , ' from ' , fileName asWebString 
				, extension asWebString.
	self loadMessagesFrom: stream into: dict.
	aBoolean = true 
		ifTrue: 
			[ItcSystemManager logLineWithTS: 'Messages dictionary was reset before reload.'.
			self languageDictFor: languageName put: dict]!

loadMessagesFrom: stream into: aDictionary 
	| messageId message |
	[stream atEnd] whileFalse: 
			[stream peek isSeparator 
				ifTrue: [stream next]
				ifFalse: 
					[messageId := stream upTo: $#.
					message := stream upTo: $#.
					[stream peek = $#] 
						whileTrue: [message := message , (stream
												next;
												upTo: $#)].
					(messageId includes: $ ) 
						ifTrue: 
							[ItcSystemManager 
								logDevTimeError: 'WARNING: message ID should not include space character ' , messageId printString].
					message isNilOrEmpty 
						ifTrue: [aDictionary removeKey: messageId ifAbsent: []]
						ifFalse: [aDictionary at: messageId put: message]]].
	^aDictionary!

reset
	languagesDict := nil.
	charactersMaps := nil.
	unicodeTo8bitCodePageMaps := nil.
	unicodeIntegerTo8bitCodePageMaps := nil.
	alphabeticalSortOrders := nil.
	bit8ToUTF8PageMaps := nil.
	defaultLanguage := nil!

thousandsSeparator
	^self thousandsSeparatorFor: Processor activeProcess language!

thousandsSeparatorFor: language 
	(language = 'Slovene' or: [language = 'Croatian' or: [language = 'Bosnian']]) ifTrue: [^$.].
	language = 'German' ifTrue: [^$'].
	^$,!

translate: messageId into: aLanguage 
	| dict |
	^(dict := languagesDict at: aLanguage) isNil 
		ifTrue: [messageId]
		ifFalse: [dict at: messageId ifAbsent: [messageId]]!

translate: messageId into: aLanguage ifAbsent: aBlock 
	| dict |
	^(dict := languagesDict at: aLanguage) isNil 
		ifTrue: [aBlock value]
		ifFalse: [dict at: messageId ifAbsent: aBlock]!

translate: messageId using: languageDict 
	"If target language is specified then messages are translated using the following rules:

	- first the default language is checked for <messageId>.<targetLanguageName>
	- if not found, the target language is checked for <messageId>
	"

	| targetLanguage |
	^(targetLanguage := Processor activeProcess attributes at: #targetLanguage ifAbsent: []) isNil 
		ifFalse: [self translate: messageId usingDefaultLanguageDictIntoTargetLanguage: targetLanguage]
		ifTrue: [languageDict at: messageId ifAbsent: [messageId]]!

translate: messageId using: languageDict ifAbsent: aBlock 
	^languageDict at: messageId ifAbsent: aBlock!

translate: messageId usingDefaultLanguageDictIntoTargetLanguage: targetLanguage 
	"If target language is specified then messages are translated using the following rules:

	- first the default language is checked for <messageId>.<targetLanguageName>
	- if not found, the target language is checked for <messageId>
	"

	| defaultLanguageMessageId targetLanguageMessageId defLang |
	(messageId endsWith: '.' , targetLanguage) 
		ifTrue: 
			[defaultLanguageMessageId := messageId.
			targetLanguageMessageId := messageId copyFrom: 1 to: messageId size - targetLanguage size - 1]
		ifFalse: 
			[defaultLanguageMessageId := messageId , '.' , targetLanguage.
			targetLanguageMessageId := messageId].
	(defLang := defaultLanguage) isNil 
		ifTrue: [defLang := Processor activeProcess webApplication defaultLanguage].
	^self 
		translate: defaultLanguageMessageId
		into: defLang
		ifAbsent: 
			[self 
				translate: targetLanguageMessageId
				into: targetLanguage
				ifAbsent: [messageId]]!

translateOrNil: messageId into: aLanguage 
	| dict |
	^(dict := languagesDict at: aLanguage) isNil ifFalse: [dict at: messageId ifAbsent: []]!

usingTargetLanguage: targetLanguageName translateAll: aBlock 
	Processor activeProcess attributes at: #targetLanguage put: targetLanguageName.
	aBlock ensure: [Processor activeProcess attributes removeKey: #targetLanguage ifAbsent: []]!

writeMessages: languageName filename: filename 
	| fileStream |
	[fileStream := FileStream write: filename , '.lng'] on: Error do: [:ex | ex exitWith: nil].
	fileStream isFileStream ifFalse: [^nil].
	
	[self 
		writeMessages: languageName
		to: fileStream
		compress: false] 
			ensure: [fileStream close].
	[fileStream := FileStream write: filename , '.nls'] on: Error do: [:ex | ex exitWith: nil].
	fileStream isFileStream ifFalse: [^nil].
	
	[self 
		writeMessages: languageName
		to: fileStream
		compress: true] 
			ensure: [fileStream close]!

writeMessages: languageName to: writeStream compress: compress 
	| dict |
	(dict := self languagesDict at: languageName ifAbsent: []) isNil ifTrue: [^nil].
	self 
		writeMessagesDictionary: dict
		to: writeStream
		compress: compress!

writeMessagesDictionary: dict filename: filename 
	| fileStream |
	[fileStream := FileStream write: filename , '.lng'] on: Error do: [:ex | ex exitWith: nil].
	fileStream isFileStream ifFalse: [^nil].
	
	[self 
		writeMessagesDictionary: dict
		to: fileStream
		compress: false] 
			ensure: [fileStream close].
	ItcSystemManager isRuntime 
		ifFalse: 
			[[fileStream := FileStream write: filename , '.nls'] on: Error do: [:ex | ex exitWith: nil].
			fileStream isFileStream ifFalse: [^nil].
			
			[self 
				writeMessagesDictionary: dict
				to: fileStream
				compress: true] 
					ensure: [fileStream close]]!

writeMessagesDictionary: dict to: writeStream compress: compress 
	| messageIds translation stream contents inLen outLen outData |
	messageIds := (dict keys asSortedCollection: [:a :b | a isAlphabeticalyBefore: b]) 
				asOrderedCollection.
	stream := WriteStream on: String new.
	messageIds do: 
			[:eachId | 
			stream
				nextPutAll: eachId;
				nextPut: $#;
				nextPutAll: ((translation := dict at: eachId) isNil ifTrue: [''] ifFalse: [translation]);
				nextPutAll: '#
'].
	contents := stream contents.
	compress == true 
		ifTrue: 
			[inLen := contents size.
			outLen := ByteArray new: 4.
			outLen dwordAtOffset: 0 put: inLen + 20.
			outData := contents class new: inLen + 20.
			ZLibInterface 
				compress: contents
				len: inLen
				out: outData
				len: outLen
				level: ZLibInterface Z_best_compression.
			contents := outData copyFrom: 1 to: (outLen dwordAtOffset: 0)].
	writeStream nextPutAll: contents! !
!HttpTranslationService class categoriesFor: #at:!public! !
!HttpTranslationService class categoriesFor: #at:ifAbsent:!public! !
!HttpTranslationService class categoriesFor: #comboCodesFor:language:!public! !
!HttpTranslationService class categoriesFor: #compressNlsFile:!public! !
!HttpTranslationService class categoriesFor: #dateFormatForLanguage:!locale specific!public! !
!HttpTranslationService class categoriesFor: #decimalPoint!locale specific!public! !
!HttpTranslationService class categoriesFor: #decimalPointFor:!locale specific!public! !
!HttpTranslationService class categoriesFor: #defaultCodePage!public! !
!HttpTranslationService class categoriesFor: #defaultCodePage:!public! !
!HttpTranslationService class categoriesFor: #defaultLanguage!public! !
!HttpTranslationService class categoriesFor: #defaultLanguage:!public! !
!HttpTranslationService class categoriesFor: #defineCharactersMapCPWindows1250!character set mapping!private! !
!HttpTranslationService class categoriesFor: #defineIsoCodesMapCPWindows1250!character set mapping!private! !
!HttpTranslationService class categoriesFor: #defineIsoCodesMapCPWindows1250forConversionFromUnicode!character set mapping!private! !
!HttpTranslationService class categoriesFor: #defineIsoCodesMapCPWindows1251!character set mapping!private! !
!HttpTranslationService class categoriesFor: #defineIsoCodesMapCPWindows1252!character set mapping!private! !
!HttpTranslationService class categoriesFor: #get8bitToUTF8CodePageMapsForCodePage:!character set mapping!public! !
!HttpTranslationService class categoriesFor: #getAlphabeticalCharacterSortOrderForLanguage:!NLS sort order!public! !
!HttpTranslationService class categoriesFor: #getCharactersMapForCodePage:!character set mapping!public! !
!HttpTranslationService class categoriesFor: #getLowerUpperDefinitionCodePageMapForCodePage:!character set mapping!public! !
!HttpTranslationService class categoriesFor: #getUnicodeIntegerTo8bitCodePageMapForCodePage:!character set mapping!public! !
!HttpTranslationService class categoriesFor: #getUnicodeTo8bitCodePageMapsForCodePage:!character set mapping!public! !
!HttpTranslationService class categoriesFor: #getUnicodeTo8bitCodePageMapsForCurrentCodePage!character set mapping!public! !
!HttpTranslationService class categoriesFor: #initialize8bitToUTF8CodePageMapFrom:!character set mapping!private! !
!HttpTranslationService class categoriesFor: #initialize8bitToUTF8CodePageMaps!character set mapping!private! !
!HttpTranslationService class categoriesFor: #initializeAlphabeticalSortOrders!NLS sort order!private! !
!HttpTranslationService class categoriesFor: #initializeCharactersMaps!character set mapping!private! !
!HttpTranslationService class categoriesFor: #initializeUnicodeIntegerTo8bitCharCodePageMapFrom:!character set mapping!private! !
!HttpTranslationService class categoriesFor: #initializeUnicodeIntegerTo8bitCodePageMaps!character set mapping!private! !
!HttpTranslationService class categoriesFor: #initializeUnicodeTo8bitCodePageMaps!character set mapping!private! !
!HttpTranslationService class categoriesFor: #languageDictFor:!public! !
!HttpTranslationService class categoriesFor: #languageDictFor:put:!public! !
!HttpTranslationService class categoriesFor: #languagesDict!public! !
!HttpTranslationService class categoriesFor: #loadMessagesFrom:as:resetBefore:!public! !
!HttpTranslationService class categoriesFor: #loadMessagesFrom:into:!public! !
!HttpTranslationService class categoriesFor: #reset!public! !
!HttpTranslationService class categoriesFor: #thousandsSeparator!locale specific!public! !
!HttpTranslationService class categoriesFor: #thousandsSeparatorFor:!locale specific!public! !
!HttpTranslationService class categoriesFor: #translate:into:!public! !
!HttpTranslationService class categoriesFor: #translate:into:ifAbsent:!public! !
!HttpTranslationService class categoriesFor: #translate:using:!public! !
!HttpTranslationService class categoriesFor: #translate:using:ifAbsent:!public! !
!HttpTranslationService class categoriesFor: #translate:usingDefaultLanguageDictIntoTargetLanguage:!public! !
!HttpTranslationService class categoriesFor: #translateOrNil:into:!public! !
!HttpTranslationService class categoriesFor: #usingTargetLanguage:translateAll:!public! !
!HttpTranslationService class categoriesFor: #writeMessages:filename:!public! !
!HttpTranslationService class categoriesFor: #writeMessages:to:compress:!public! !
!HttpTranslationService class categoriesFor: #writeMessagesDictionary:filename:!public! !
!HttpTranslationService class categoriesFor: #writeMessagesDictionary:to:compress:!public! !

