"Filed out from Dolphin Smalltalk"!

UI.Scintilla.ScintillaLibrary subclass: #'UI.Scintilla.NullScintillaLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.NullScintillaLibrary guid: (Core.GUID fromString: '{1e501b54-23a3-4cda-82ad-c28e1c9800db}')!
UI.Scintilla.NullScintillaLibrary comment: ''!
!UI.Scintilla.NullScintillaLibrary categoriesForClass!External-Libraries! !
!UI.Scintilla.NullScintillaLibrary methodsFor!

directBooleanFunction: sciThis msg: msg wParam: wParam lParam: lParam
	^self returnValues lookup: msg!

directFunction: sciThis msg: msg wParam: wParam lParam: lParam
	^self returnValues lookup: msg!

directFunction: sciThis msg: msg wParam: wParam lpParam: lpParam
	^self returnValues lookup: msg!

directFunction: sciThis msg: msg wpParam: wParam lParam: lpParam
	^self returnValues lookup: msg!

directFunction: sciThis msg: msg wpParam: wParam lpParam: lpParam
	^self returnValues lookup: msg!

open: aString
	"Private - Open the external library with the external file name, aString,
	as the library referenced by the receiver. Answer the receiver.
	The library is initialized."

	self initialize!

returnValues
	^##(IdentityDictionary new
		at: SCI_ALLOCATEEXTENDEDSTYLES put: 0;
		at: SCI_ALLOCATESUBSTYLES put: 0;
		at: SCI_ANNOTATIONGETLINES put: 0;
		at: SCI_ANNOTATIONGETSTYLEOFFSET put: 0;
		at: SCI_ANNOTATIONGETSTYLES put: 0;
		at: SCI_ANNOTATIONGETTEXT put: 0;
		at: SCI_ANNOTATIONGETVISIBLE put: 0;
		at: SCI_AUTOCACTIVE put: false;
		at: SCI_AUTOCGETAUTOHIDE put: false;
		at: SCI_AUTOCGETCANCELATSTART put: false;
		at: SCI_AUTOCGETCASEINSENSITIVEBEHAVIOUR put: 0;
		at: SCI_AUTOCGETCHOOSESINGLE put: false;
		at: SCI_AUTOCGETCURRENT put: 0;
		at: SCI_AUTOCGETCURRENTTEXT put: 0;
		at: SCI_AUTOCGETDROPRESTOFWORD put: false;
		at: SCI_AUTOCGETIGNORECASE put: false;
		at: SCI_AUTOCGETMAXHEIGHT put: 0;
		at: SCI_AUTOCGETMAXWIDTH put: 0;
		at: SCI_AUTOCGETMULTI put: 0;
		at: SCI_AUTOCGETORDER put: 0;
		at: SCI_AUTOCGETSEPARATOR put: 0;
		at: SCI_AUTOCGETTYPESEPARATOR put: 0;
		at: SCI_AUTOCPOSSTART put: 0;
		at: SCI_BRACEMATCH put: 0;
		at: SCI_BRACEMATCHNEXT put: 0;
		at: SCI_CALLTIPACTIVE put: false;
		at: SCI_CALLTIPPOSSTART put: 0;
		at: SCI_CANPASTE put: false;
		at: SCI_CANREDO put: false;
		at: SCI_CANUNDO put: false;
		at: SCI_CHANGELEXERSTATE put: 0;
		at: SCI_CHARPOSITIONFROMPOINT put: 0;
		at: SCI_CHARPOSITIONFROMPOINTCLOSE put: 0;
		at: SCI_CONTRACTEDFOLDNEXT put: 0;
		at: SCI_COUNTCHARACTERS put: 0;
		at: SCI_COUNTCODEUNITS put: 0;
		at: SCI_CREATEDOCUMENT put: nil;
		at: SCI_DESCRIBEKEYWORDSETS put: 0;
		at: SCI_DESCRIBEPROPERTY put: 0;
		at: SCI_DESCRIPTIONOFSTYLE put: 0;
		at: SCI_DISTANCETOSECONDARYSTYLES put: 0;
		at: SCI_DOCLINEFROMVISIBLE put: 0;
		at: SCI_ENCODEDFROMUTF8 put: 0;
		at: SCI_EOLANNOTATIONGETSTYLE put: 0;
		at: SCI_EOLANNOTATIONGETSTYLEOFFSET put: 0;
		at: SCI_EOLANNOTATIONGETTEXT put: 0;
		at: SCI_EOLANNOTATIONGETVISIBLE put: 0;
		at: SCI_FINDCOLUMN put: 0;
		at: SCI_FINDTEXT put: 0;
		at: SCI_FOLDDISPLAYTEXTGETSTYLE put: 0;
		at: SCI_FORMATRANGE put: 0;
		at: SCI_GETACCESSIBILITY put: 0;
		at: SCI_GETADDITIONALCARETSBLINK put: false;
		at: SCI_GETADDITIONALCARETSVISIBLE put: false;
		at: SCI_GETADDITIONALSELECTIONTYPING put: false;
		at: SCI_GETALLLINESVISIBLE put: false;
		at: SCI_GETANCHOR put: 0;
		at: SCI_GETAUTOMATICFOLD put: 0;
		at: SCI_GETBACKSPACEUNINDENTS put: false;
		at: SCI_GETBIDIRECTIONAL put: 0;
		at: SCI_GETBUFFEREDDRAW put: false;
		at: SCI_GETCARETLINEFRAME put: 0;
		at: SCI_GETCARETLINELAYER put: 0;
		at: SCI_GETCARETLINEVISIBLEALWAYS put: false;
		at: SCI_GETCARETPERIOD put: 0;
		at: SCI_GETCARETSTICKY put: 0;
		at: SCI_GETCARETSTYLE put: 0;
		at: SCI_GETCARETWIDTH put: 0;
		at: SCI_GETCHARACTERCATEGORYOPTIMIZATION put: 0;
		at: SCI_GETCHARAT put: 0;
		at: SCI_GETCODEPAGE put: 0;
		at: SCI_GETCOLUMN put: 0;
		at: SCI_GETCONTROLCHARSYMBOL put: 0;
		at: SCI_GETCURLINE put: 0;
		at: SCI_GETCURRENTPOS put: 0;
		at: SCI_GETDEFAULTFOLDDISPLAYTEXT put: 0;
		at: SCI_GETDOCPOINTER put: nil;
		at: SCI_GETDOCUMENTOPTIONS put: 0;
		at: SCI_GETEDGECOLUMN put: 0;
		at: SCI_GETEDGEMODE put: 0;
		at: SCI_GETELEMENTALLOWSTRANSLUCENT put: false;
		at: SCI_GETELEMENTCOLOUR put: nil;
		at: SCI_GETELEMENTISSET put: false;
		at: SCI_GETENDATLASTLINE put: false;
		at: SCI_GETENDSTYLED put: 0;
		at: SCI_GETEOLMODE put: 0;
		at: SCI_GETEXTRAASCENT put: 0;
		at: SCI_GETEXTRADESCENT put: 0;
		at: SCI_GETFIRSTVISIBLELINE put: 0;
		at: SCI_GETFOLDEXPANDED put: false;
		at: SCI_GETFOLDLEVEL put: 0;
		at: SCI_GETFOLDPARENT put: 0;
		at: SCI_GETFONTLOCALE put: 0;
		at: SCI_GETFONTQUALITY put: 0;
		at: SCI_GETHIGHLIGHTGUIDE put: 0;
		at: SCI_GETHOTSPOTACTIVEUNDERLINE put: false;
		at: SCI_GETHOTSPOTSINGLELINE put: false;
		at: SCI_GETHSCROLLBAR put: false;
		at: SCI_GETIDLESTYLING put: 0;
		at: SCI_GETIMEINTERACTION put: 0;
		at: SCI_GETINDENT put: 0;
		at: SCI_GETINDENTATIONGUIDES put: 0;
		at: SCI_GETINDICATORCURRENT put: 0;
		at: SCI_GETINDICATORVALUE put: 0;
		at: SCI_GETKEYSUNICODE put: false;
		at: SCI_GETLASTCHILD put: 0;
		at: SCI_GETLAYOUTCACHE put: 0;
		at: SCI_GETLEXER put: 0;
		at: SCI_GETLEXERLANGUAGE put: 0;
		at: SCI_GETLINE put: 0;
		at: SCI_GETLINECHARACTERINDEX put: 0;
		at: SCI_GETLINECOUNT put: 0;
		at: SCI_GETLINEENDPOSITION put: 0;
		at: SCI_GETLINEENDTYPESACTIVE put: 0;
		at: SCI_GETLINEENDTYPESALLOWED put: 0;
		at: SCI_GETLINEENDTYPESSUPPORTED put: 0;
		at: SCI_GETLINEINDENTATION put: 0;
		at: SCI_GETLINEINDENTPOSITION put: 0;
		at: SCI_GETLINESELENDPOSITION put: 0;
		at: SCI_GETLINESELSTARTPOSITION put: 0;
		at: SCI_GETLINESTATE put: 0;
		at: SCI_GETLINEVISIBLE put: false;
		at: SCI_GETMAINSELECTION put: 0;
		at: SCI_GETMARGINLEFT put: 0;
		at: SCI_GETMARGINOPTIONS put: 0;
		at: SCI_GETMARGINRIGHT put: 0;
		at: SCI_GETMARGINS put: 0;
		at: SCI_GETMAXLINESTATE put: 0;
		at: SCI_GETMODIFY put: false;
		at: SCI_GETMOUSEDOWNCAPTURES put: false;
		at: SCI_GETMOUSEDWELLTIME put: 0;
		at: SCI_GETMOUSESELECTIONRECTANGULARSWITCH put: false;
		at: SCI_GETMOUSEWHEELCAPTURES put: false;
		at: SCI_GETMOVEEXTENDSSELECTION put: false;
		at: SCI_GETMULTIEDGECOLUMN put: 0;
		at: SCI_GETMULTIPASTE put: 0;
		at: SCI_GETMULTIPLESELECTION put: false;
		at: SCI_GETNAMEDSTYLES put: 0;
		at: SCI_GETNEXTTABSTOP put: 0;
		at: SCI_GETOVERTYPE put: false;
		at: SCI_GETPASTECONVERTENDINGS put: false;
		at: SCI_GETPHASESDRAW put: 0;
		at: SCI_GETPOSITIONCACHE put: 0;
		at: SCI_GETPRIMARYSTYLEFROMSTYLE put: 0;
		at: SCI_GETPRINTCOLOURMODE put: 0;
		at: SCI_GETPRINTMAGNIFICATION put: 0;
		at: SCI_GETPRINTWRAPMODE put: 0;
		at: SCI_GETPROPERTY put: 0;
		at: SCI_GETPROPERTYEXPANDED put: 0;
		at: SCI_GETPROPERTYINT put: 0;
		at: SCI_GETPUNCTUATIONCHARS put: 0;
		at: SCI_GETRECTANGULARSELECTIONANCHOR put: 0;
		at: SCI_GETRECTANGULARSELECTIONANCHORVIRTUALSPACE put: 0;
		at: SCI_GETRECTANGULARSELECTIONCARET put: 0;
		at: SCI_GETRECTANGULARSELECTIONCARETVIRTUALSPACE put: 0;
		at: SCI_GETREPRESENTATION put: 0;
		at: SCI_GETREPRESENTATIONAPPEARANCE put: 0;
		at: SCI_GETREPRESENTATIONCOLOUR put: nil;
		at: SCI_GETSCROLLWIDTH put: 0;
		at: SCI_GETSCROLLWIDTHTRACKING put: false;
		at: SCI_GETSEARCHFLAGS put: 0;
		at: SCI_GETSELECTIONEMPTY put: false;
		at: SCI_GETSELECTIONEND put: -1;
		at: SCI_GETSELECTIONLAYER put: 0;
		at: SCI_GETSELECTIONMODE put: 0;
		at: SCI_GETSELECTIONNANCHOR put: 0;
		at: SCI_GETSELECTIONNANCHORVIRTUALSPACE put: 0;
		at: SCI_GETSELECTIONNCARET put: 0;
		at: SCI_GETSELECTIONNCARETVIRTUALSPACE put: 0;
		at: SCI_GETSELECTIONNEND put: -1;
		at: SCI_GETSELECTIONNENDVIRTUALSPACE put: 0;
		at: SCI_GETSELECTIONNSTART put: -1;
		at: SCI_GETSELECTIONNSTARTVIRTUALSPACE put: 0;
		at: SCI_GETSELECTIONS put: 0;
		at: SCI_GETSELECTIONSTART put: -1;
		at: SCI_GETSELEOLFILLED put: false;
		at: SCI_GETSELTEXT put: 0;
		at: SCI_GETSTATUS put: 0;
		at: SCI_GETSTYLEAT put: 0;
		at: SCI_GETSTYLEDTEXT put: 0;
		at: SCI_GETSTYLEFROMSUBSTYLE put: 0;
		at: SCI_GETSUBSTYLEBASES put: 0;
		at: SCI_GETSUBSTYLESLENGTH put: 0;
		at: SCI_GETSUBSTYLESSTART put: 0;
		at: SCI_GETTABDRAWMODE put: 0;
		at: SCI_GETTABINDENTS put: false;
		at: SCI_GETTABMINIMUMWIDTH put: 0;
		at: SCI_GETTABWIDTH put: 0;
		at: SCI_GETTAG put: 0;
		at: SCI_GETTARGETEND put: -1;
		at: SCI_GETTARGETENDVIRTUALSPACE put: 0;
		at: SCI_GETTARGETSTART put: -1;
		at: SCI_GETTARGETSTARTVIRTUALSPACE put: 0;
		at: SCI_GETTARGETTEXT put: 0;
		at: SCI_GETTECHNOLOGY put: 0;
		at: SCI_GETTEXT put: 0;
		at: SCI_GETTEXTLENGTH put: 0;
		at: SCI_GETTEXTRANGE put: 0;
		at: SCI_GETUNDOCOLLECTION put: false;
		at: SCI_GETUSETABS put: false;
		at: SCI_GETVIEWEOL put: false;
		at: SCI_GETVIEWWS put: 0;
		at: SCI_GETVIRTUALSPACEOPTIONS put: 0;
		at: SCI_GETVSCROLLBAR put: false;
		at: SCI_GETWHITESPACECHARS put: 0;
		at: SCI_GETWHITESPACESIZE put: 0;
		at: SCI_GETWORDCHARS put: 0;
		at: SCI_GETWRAPINDENTMODE put: 0;
		at: SCI_GETWRAPMODE put: 0;
		at: SCI_GETWRAPSTARTINDENT put: 0;
		at: SCI_GETWRAPVISUALFLAGS put: 0;
		at: SCI_GETWRAPVISUALFLAGSLOCATION put: 0;
		at: SCI_GETXOFFSET put: 0;
		at: SCI_GETZOOM put: 0;
		at: SCI_INDEXPOSITIONFROMLINE put: 0;
		at: SCI_INDICATORALLONFOR put: 0;
		at: SCI_INDICATOREND put: 0;
		at: SCI_INDICATORSTART put: 0;
		at: SCI_INDICATORVALUEAT put: 0;
		at: SCI_ISRANGEWORD put: false;
		at: SCI_LINEFROMINDEXPOSITION put: 0;
		at: SCI_LINESONSCREEN put: 0;
		at: SCI_MARGINGETSTYLE put: 0;
		at: SCI_MARGINGETSTYLEOFFSET put: 0;
		at: SCI_MARGINGETSTYLES put: 0;
		at: SCI_MARGINGETTEXT put: 0;
		at: SCI_MARKERGET put: 0;
		at: SCI_MARKERHANDLEFROMLINE put: 0;
		at: SCI_MARKERLINEFROMHANDLE put: 0;
		at: SCI_MARKERNEXT put: 0;
		at: SCI_MARKERNUMBERFROMLINE put: 0;
		at: SCI_MARKERPREVIOUS put: 0;
		at: SCI_MARKERSYMBOLDEFINED put: 0;
		at: SCI_NAMEOFSTYLE put: 0;
		at: SCI_POINTXFROMPOSITION put: 0;
		at: SCI_POINTYFROMPOSITION put: 0;
		at: SCI_POSITIONAFTER put: 0;
		at: SCI_POSITIONBEFORE put: 0;
		at: SCI_POSITIONFROMPOINT put: 0;
		at: SCI_POSITIONFROMPOINTCLOSE put: 0;
		at: SCI_POSITIONRELATIVE put: 0;
		at: SCI_POSITIONRELATIVECODEUNITS put: 0;
		at: SCI_PRIVATELEXERCALL put: nil;
		at: SCI_PROPERTYNAMES put: 0;
		at: SCI_PROPERTYTYPE put: 0;
		at: SCI_REPLACETARGET put: 0;
		at: SCI_REPLACETARGETRE put: 0;
		at: SCI_SEARCHINTARGET put: 0;
		at: SCI_SEARCHNEXT put: 0;
		at: SCI_SEARCHPREV put: 0;
		at: SCI_SELECTIONISRECTANGLE put: false;
		at: SCI_SUPPORTSFEATURE put: false;
		at: SCI_TAGSOFSTYLE put: 0;
		at: SCI_TARGETASUTF8 put: 0;
		at: SCI_TEXTHEIGHT put: 0;
		at: SCI_TEXTWIDTH put: 0;
		at: SCI_VISIBLEFROMDOCLINE put: 0;
		at: SCI_WORDENDPOSITION put: 0;
		at: SCI_WORDSTARTPOSITION put: 0;
		at: SCI_WRAPCOUNT put: 0;
		shrink;
		isImmutable: true;
		yourself)! !
!UI.Scintilla.NullScintillaLibrary categoriesFor: #directBooleanFunction:msg:wParam:lParam:!operations!private! !
!UI.Scintilla.NullScintillaLibrary categoriesFor: #directFunction:msg:wParam:lParam:!operations!private! !
!UI.Scintilla.NullScintillaLibrary categoriesFor: #directFunction:msg:wParam:lpParam:!operations!private! !
!UI.Scintilla.NullScintillaLibrary categoriesFor: #directFunction:msg:wpParam:lParam:!operations!private! !
!UI.Scintilla.NullScintillaLibrary categoriesFor: #directFunction:msg:wpParam:lpParam:!operations!private! !
!UI.Scintilla.NullScintillaLibrary categoriesFor: #open:!private!realizing/unrealizing! !
!UI.Scintilla.NullScintillaLibrary categoriesFor: #returnValues!**auto generated**!development!private!scintilla interface! !

